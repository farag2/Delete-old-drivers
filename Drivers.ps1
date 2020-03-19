﻿$OriginalFileName = @{
	Name = "OriginalFileName"
	Expression = {$_.OriginalFileName | Split-Path -Leaf}
}
$Date = @{
	Name = "Date"
	Expression = {$_.Date.Tostring().Split("")[0]}
}
$AllDrivers = Get-WindowsDriver -Online -All | Where-Object -FilterScript {$_.Driver -like 'oem*inf'} | Select-Object -Property $OriginalFileName, Driver, ClassDescription, ProviderName, $Date, Version
Write-Host "`nAll installed third-party drivers" -ForegroundColor Yellow
($AllDrivers | Sort-Object -Property ClassDescription | Format-Table -AutoSize -Wrap | Out-String).Trim()
$DriverGroups = $AllDrivers | Group-Object -Property OriginalFileName | Where-Object -FilterScript {$_.Count -gt 1}
Write-Host "`nDuplicate drivers" -ForegroundColor Yellow
($DriverGroups | ForEach-Object -Process {$_.Group | Sort-Object -Property Date -Descending | Select-Object -Skip 1} | Format-Table | Out-String).Trim()
$DriversToRemove = $DriverGroups | ForEach-Object -Process {$_.Group | Sort-Object -Property Date -Descending | Select-Object -Skip 1}
Write-Host "`nDrivers to remove" -ForegroundColor Yellow
($DriversToRemove | Sort-Object -Property ClassDescription | Format-Table | Out-String).Trim()
foreach ($item in $DriversToRemove)
{
	$Name = $($item.Driver).Trim()
	& pnputil.exe /delete-driver "$Name" /force
}