<#
    .SYNOPSIS
    Insert copyright notice
    .DESCRIPTION
    Script to add a copyright notice. Recursively processes all files in a directory and inserts copyright notice at the top.
    Review the copyright year as appropriate.
    Disclaimer: don't forget to backup files before using the script.
    .PARAMETER Force
    Skip confirmation prompt
    .PARAMETER DryRun
    Count the number of files to be updated, but do not update the content
    .PARAMETER Verbose
    Print file paths
    .EXAMPLE
    cp.ps1 -force
	Update all files in the current folder and don't prompt for confirmation.
	.EXAMPLE
	cp.ps1 -dryrun -extensions "*.txt"
	Estimate the number of txt files to be updated.
	
#>

# To get detailed help use Get-Help .\cp.ps1 -Detailed
# To run this script you should allow PS script execution on your machine: Set-ExecutionPolicy RemoteSigned
# © Copyright Aleksey Yushko.

param(
[string[]]$extensions = @("*.java", "*.cpp", "*.c", "*.cs", "*.ts"),
[switch]$Force = $false,
[switch]$DryRun = $false,
[switch]$Verbose = $false
)

$scriptPath = Get-Location

function Confirm
{
    if ($Force.IsPresent -or $DryRun.IsPresent)
    {
        return $true
    }

    $confirmation = Read-Host "This script will attept to modify $extensions files. Do you wish to continue?"
    if ($confirmation.ToLower() -eq 'y') {
      return $true
    }
    return $false
}

$c = Confirm
if (($c -eq $false))
{
    return
}

$year = "2019";
$copyright = "/*---------------------------------------------------------------------------------------------
 *  (C) Copyright Aleksey Yushko.
 *--------------------------------------------------------------------------------------------*/";

Write-Host Looking for $extensions files in $scriptPath...

$files = Get-ChildItem -Path $scriptPath -Recurse -Include $extensions

$count = 0;

foreach ($f in $files){
    $outfile = $f.FullName
    if ($DryRun.IsPresent)
    {
        $content = Get-Content $f.FullName -TotalCount 14 | Out-String
    }
    else
    {
        $content = Get-Content $f.FullName | Out-String
    }

    if (($content.Length -gt 0) -and !$content.Contains(" Copyright "))
    {
        $count++
        if ($Verbose.IsPresent)
        {
            Write-Host $outfile
        }

        if (!$DryRun.IsPresent) 
        {
            Set-Content -Path $outfile -Value ($copyright + "`r`n" + $content) -NoNewline
        }
    }
}

$action = if($DryRun.IsPresent) { "Found" } else { "Updated" }
Write-Host $action $count of $files.Count files