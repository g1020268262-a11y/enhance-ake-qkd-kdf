param([string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference = 'Stop'
$m4Root = (Resolve-Path -LiteralPath $ProjectRoot).Path
& (Join-Path $PSScriptRoot 'validate-m2-m3.ps1') -ProjectRoot $m4Root

Add-Type -AssemblyName Microsoft.VisualBasic
$csvPath = Join-Path $m4Root 'field-security-mapping.csv'
$parser = [Microsoft.VisualBasic.FileIO.TextFieldParser]::new($csvPath)
$parser.TextFieldType = 'Delimited'
$parser.SetDelimiters(',')
$parser.HasFieldsEnclosedInQuotes = $true
try {
    $rowCount = -1
    while (-not $parser.EndOfData) {
        $cells = $parser.ReadFields()
        $rowCount++
        if ($cells.Count -ne 8) { throw "M4 row $rowCount has wrong column count" }
    }
    if ($rowCount -ne 18) { throw "M4 mapping expected 18 rows, found $rowCount" }
} finally { $parser.Dispose() }
$rows = Import-Csv -LiteralPath $csvPath
$expectedHeader = 'Field|Location|Source|Semantic Role|Security Property|Existing Guarantee|Gap|Status'
if ((@($rows[0].PSObject.Properties.Name) -join '|') -ne $expectedHeader) { throw 'M4 schema mismatch' }
$obligations = Get-Content -Raw -LiteralPath (Join-Path $m4Root 'm4-proof-obligation.md')
$analysis = Get-Content -Raw -LiteralPath (Join-Path $m4Root 'binding-property-analysis.md')
foreach ($row in $rows) {
    foreach ($cell in $row.PSObject.Properties) {
        if ([string]::IsNullOrWhiteSpace($cell.Value)) { throw "Empty M4 cell for $($row.Field)" }
    }
    if ($row.Status -notin @('Hypothesis / requires validation','Protected scope / proof obligation')) { throw 'Unsupported M4 conclusion' }
    $refs = [regex]::Matches($row.Gap, 'PO-\d{2}')
    if ($refs.Count -eq 0) { throw "Missing PO reference for $($row.Field)" }
    foreach ($ref in $refs) {
        if ($obligations -notmatch "(?m)^### $($ref.Value)：") { throw "Missing obligation $($ref.Value)" }
    }
}
foreach ($sourceName in @('KEM','QKD')) {
    $count = if ($sourceName -eq 'KEM') { 8 } else { 3 }
    for ($index = 1; $index -le $count; $index++) {
        $prefix = "c_$sourceName[$index]"
        if (@($rows | Where-Object { $_.Location.StartsWith($prefix) }).Count -ne 1) { throw "Missing or repeated context position $prefix" }
    }
}
foreach ($id in 1..12) {
    $label = 'PO-{0:d2}' -f $id
    if ($obligations -notmatch "(?m)^### $label") { throw "Missing $label" }
}
foreach ($id in 1..8) {
    if (-not $obligations.Contains("U$id")) { throw "Missing common obligation U$id" }
}
foreach ($id in 1..6) {
    $label = 'OI-{0:d2}' -f $id
    if (-not $obligations.Contains($label)) { throw "Lost open issue $label" }
}
foreach ($branch in @('BG','KO','QS','QB','QT','FF')) {
    if (-not $analysis.Contains($branch)) { throw "Missing failure branch $branch" }
}
foreach ($doc in @('binding-property-analysis.md','m4-proof-obligation.md','路线图.md','model-freeze-proposal.md','model-freeze-review-summary.md')) {
    $full = Join-Path $m4Root $doc
    $body = Get-Content -Raw -LiteralPath $full
    foreach ($link in [regex]::Matches($body, '\]\(([^)]+)\)')) {
        $target = ($link.Groups[1].Value -split '#')[0]
        if (-not $target -or $target -match '^https?://') { continue }
        if (-not (Test-Path -LiteralPath (Join-Path (Split-Path -Parent $full) $target))) { throw "Broken link $doc -> $target" }
    }
}
$roadmap = Get-Content -Raw -LiteralPath (Join-Path $m4Root '路线图.md')
foreach ($item in @(1,2,3,4,5,7)) {
    if ($roadmap -notmatch "- \[x\] M4\.$item ") { throw "Missing completed mapping task M4.$item" }
}
foreach ($item in @(6,8)) {
    if ($roadmap -notmatch "- \[ \] M4\.$item ") { throw "Premature variant-selection completion M4.$item" }
}
if (-not $obligations.Contains('G3-M4_REVIEW_PENDING')) { throw 'Missing stop gate' }
if ($analysis -notmatch 'k1′' -or $analysis -notmatch 'k2′' -or $analysis -notmatch 'k_A\*' -or $analysis -notmatch 'k_B\*') { throw 'Missing local-role distinction' }
Write-Output 'PASS M4: 18x8 mapping, all 11 context positions, PO references, roles, open issues and branches'
Write-Output 'PASS M4 links, mapping-only roadmap and pending review gate'
Write-Output 'Document validation only; not a security proof or attack search.'
