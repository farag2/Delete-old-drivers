## Overview
Delete old drivers using Get-WindowsDriver function.
If you want only to display out-dated drivers, comment

<code>
& pnputil.exe /delete-driver "$Name" /force
</code>

## GUI
If prefer GUI
- [DriverStoreExplorer
](https://github.com/lostindark/DriverStoreExplorer)

## Inspired by
- [Habr](https://habr.com/ru/post/319152/)
