$found = @()
$devices = Get-ADComputer -Filter "Enabled -eq 'True'" -ErrorAction Stop | foreach {
    $name = $_.Name
    $programs = Get-WmiObject -Class Win32Reg_AddRemovePrograms -ComputerName $name
    $programs | ForEach-Object {
        if ($_.DisplayName -like '*SolarWinds Orion*') {
            echo $_
            $found += [string]($name)
			break
        }
    }
}
$found = $found | Select-Object @{Name='Name';Expression={$_}}
$found | Export-Csv -Encoding UTF8 -NoTypeInformation -Path ".\devices-with-orion.csv"
Read-Host -Prompt "Press Enter to exit"