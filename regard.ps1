# © Copyright Aleksey Yushko.
$targetPath = 'HKCU:\Software\Microsoft\VisualStudio\14.0Exp_Config\Packages\{655034bd-818f-4456-b1e4-0e8075db4cd9}'
$targetValue = 'C:\Users\ayushko\AppData\Local\Microsoft\VisualStudio\14.0Exp\Extensions\Serena Software, Inc\Dimensions CM for Visual Studio\14.5.1\Serena.VsCMPkg.dll'
$interval = 5
Write-Host 'Watching registry key ' $targetPath
while ($true)
{
    $value = (get-item -Path $targetPath | get-itemproperty -Name CodeBase).CodeBase
    if ($value -ne $targetValue)
    {
        Remove-ItemProperty -Path $targetPath -Name CodeBase
        New-ItemProperty -Path $targetPath -Name CodeBase -PropertyType String -Value $targetValue > $null
        Write-Host (Get-Date -Format t) 'Restored key value'
    }
    Start-Sleep -Seconds $interval
}
