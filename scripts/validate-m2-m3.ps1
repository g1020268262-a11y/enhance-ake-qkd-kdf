param([string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference = 'Stop'
$taskRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path
Add-Type -AssemblyName Microsoft.VisualBasic

$schemas = @{
    'field-ledger.csv' = @(27,18)
    'claims-register.csv' = @(18,8)
    'related-work-matrix.csv' = @(9,12)
    'security-contract.csv' = @(33,11)
    'hybrid-branch-compatibility.csv' = @(4,17)
    'model-assumption-table.csv' = @(16,5)
}
foreach ($name in $schemas.Keys) {
    $parser = [Microsoft.VisualBasic.FileIO.TextFieldParser]::new((Join-Path $taskRoot $name))
    $parser.TextFieldType = 'Delimited'
    $parser.SetDelimiters(',')
    $parser.HasFieldsEnclosedInQuotes = $true
    try {
        $rowCount = -1
        while (-not $parser.EndOfData) {
            $fields = $parser.ReadFields()
            $rowCount++
            if ($fields.Count -ne $schemas[$name][1]) { throw "$name row $rowCount has $($fields.Count) columns" }
        }
        if ($rowCount -ne $schemas[$name][0]) { throw "$name has $rowCount rows" }
        Write-Output "PASS CSV $name : $rowCount rows / $($schemas[$name][1]) columns"
    } finally { $parser.Dispose() }
}

$contracts = Import-Csv -LiteralPath (Join-Path $taskRoot 'security-contract.csv')
$cellIds = @($contracts.cell_id)
if (@($cellIds | Select-Object -Unique).Count -ne $cellIds.Count) { throw 'Duplicate contract IDs' }
$gates = Import-Csv -LiteralPath (Join-Path $taskRoot 'hybrid-branch-compatibility.csv')
foreach ($gate in $gates) {
    foreach ($ref in ($gate.contract_cells -split '\|')) {
        if ($ref -notin $cellIds) { throw "Unknown contract cell $ref" }
    }
    if ($gate.verdict -notin @('全部原分支兼容','仅附加 binding 条件下兼容','不兼容','证据不足')) { throw 'Invalid gate verdict' }
    if ($gate.verdict -eq '证据不足' -and $gate.M4_admission -ne '未准入') { throw 'Unsupported admission' }
}
Write-Output 'PASS contract references and gate statuses'

# M3.2 evidence closure is distinct from adopting a complete security game.
$assumptions = Import-Csv -LiteralPath (Join-Path $taskRoot 'model-assumption-table.csv')
if ((@($assumptions[0].PSObject.Properties.Name) -join '|') -ne 'Item|HAKE source|CK01 source|Adopted interpretation|Reason') { throw 'Assumption schema mismatch' }
foreach ($row in $assumptions) {
    foreach ($property in $row.PSObject.Properties) {
        if ([string]::IsNullOrWhiteSpace($property.Value)) { throw 'Empty assumption cell' }
    }
}
foreach ($contract in $contracts) {
    if ($contract.proof_obligation -notmatch '^proof obligation') { throw 'Missing proof obligation label' }
}
foreach ($gate in $gates) {
    if ($gate.candidate_hypothesis -notmatch '^candidate hypothesis' -or $gate.binding_proof_obligation -notmatch '^proof obligation') { throw 'Missing hypothesis label' }
    if ($gate.field_status -ne 'requires validation（无删除结论）' -or $gate.M4_admission -ne '未准入') { throw 'Premature field conclusion' }
}
$model = Get-Content -Raw -LiteralPath (Join-Path $taskRoot 'security-model.md')
$assumptionText = Get-Content -Raw -LiteralPath (Join-Path $taskRoot 'model-assumption-table.csv')
$conclusion = Get-Content -Raw -LiteralPath (Join-Path $taskRoot 'm3-conclusion.md')
foreach ($id in @('OI-01','OI-02','OI-03','OI-04','OI-05','OI-06')) {
    if (-not $model.Contains($id) -or -not $assumptionText.Contains($id)) { throw "Missing issue $id" }
}
if ($model -notmatch 'OPEN ISSUE' -or $conclusion -notmatch 'WAITING FOR HUMAN REVIEW') { throw 'Missing review gate' }
foreach ($name in @('security-contract.csv','hybrid-branch-compatibility.csv')) {
    if ((Get-Content -Raw -LiteralPath (Join-Path $taskRoot $name)) -match '(?i)safe-to-remove|candidate-removable') { throw "Removal label in $name" }
}
Write-Output 'PASS M3.2 assumptions, obligation labels and OPEN ISSUE boundaries'

$manifest = Get-Content -Raw -LiteralPath (Join-Path $taskRoot 'sources/README.md')
$hashRows = [regex]::Matches($manifest, '(?m)^([A-F0-9]{64})  (.+)\r?$')
if ($hashRows.Count -ne 10) { throw 'Expected 10 pinned source hashes' }
foreach ($row in $hashRows) {
    $file = Join-Path (Join-Path $taskRoot 'sources') $row.Groups[2].Value.Trim()
    $actual = (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash
    if ($actual -ne $row.Groups[1].Value) { throw "Source hash mismatch: $file" }
}
Write-Output 'PASS all 10 source hashes including original HAKE'

$bib = Get-Content -Raw -LiteralPath (Join-Path $taskRoot 'references.bib')
$keys = [regex]::Matches($bib, '(?m)^@\w+\{([^,]+),') | ForEach-Object { $_.Groups[1].Value }
if ($keys.Count -ne 9 -or @($keys | Select-Object -Unique).Count -ne 9) { throw 'BibTeX keys missing or duplicated' }
$balance = 0
foreach ($char in $bib.ToCharArray()) {
    if ($char -eq '{') { $balance++ }
    if ($char -eq '}') { $balance-- }
    if ($balance -lt 0) { throw 'Unbalanced BibTeX braces' }
}
if ($balance -ne 0) { throw 'Unbalanced BibTeX braces' }
Write-Output 'PASS 9 BibTeX entries and brace balance (not a typesetting test)'

$docPaths = @('novelty-gap.md','security-model.md','m2-m3-status.md','m3-conclusion.md','sources/README.md','research-scope.md','baseline-spec.md','kdf-dataflow.md')
foreach ($docPath in $docPaths) {
    $full = Join-Path $taskRoot $docPath
    $body = Get-Content -Raw -LiteralPath $full
    foreach ($link in [regex]::Matches($body, '\]\(([^)]+)\)')) {
        $target = $link.Groups[1].Value
        if ($target -match '^(https?://|#)') { continue }
        $target = ($target -split '#')[0]
        if (-not (Test-Path -LiteralPath (Join-Path (Split-Path -Parent $full) $target))) { throw "Broken local link $docPath -> $target" }
    }
}
Write-Output 'PASS local Markdown links'
$roadmap = Get-Content -Raw -LiteralPath (Join-Path $taskRoot '路线图.md')
if ([regex]::Matches($roadmap,'(?m)^- \[x\] M2\.').Count -ne 8) { throw 'M2 checklist mismatch' }
if ($roadmap -notmatch '- \[ \] M3\.2') { throw 'Unresolved M3.2 must remain unchecked' }
Write-Output 'PASS roadmap completion boundaries'
Write-Output 'Document validation only; no protocol theorem or implementation test was run.'
