$OriginalFileName = @{
	Name = "OriginalFileName"
	Expression = {$_.OriginalFileName | Split-Path -Leaf}
}
$AllDrivers = Get-WindowsDriver –Online -All | Where-Object -FilterScript {$_.Driver -like "oem*inf"} | Select-Object $OriginalFileName, Driver, ClassDescription, ProviderName, Date, Version
Write-Host "All installed third-party drivers" -ForegroundColor Yellow
$AllDrivers | Sort-Object ClassDescription | Format-Table
$DriverGroups = $AllDrivers | Group-Object OriginalFileName | Where-Object -FilterScript {$_.Count -gt 1}
Write-Host "Duplicate drivers" -ForegroundColor Yellow
$DriverGroups | ForEach-Object {$_.Group | Sort-Object Date -Descending | Select-Object -Skip 1} | Format-Table
$DriversToRemove = $DriverGroups | ForEach-Object {$_.Group | Sort-Object Date -Descending | Select-Object -Skip 1}
Write-Host "Drivers to remove" -ForegroundColor Yellow
$DriversToRemove | Sort-Object ClassDescription | Format-Table
Foreach ($item in $DriversToRemove)
{
	$Name = $($item.Driver).Trim()
	& pnputil.exe /delete-driver "$Name" /force
}
