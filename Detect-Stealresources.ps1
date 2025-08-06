# ====================================================== Write powershell Script to detect stale Resources ===========================================
 


# Detect-StaleResources.ps1


# Connect to Azure using managed Identity or Service principal 
Connect-AzAccount -Identity


#Get all stopped vms
$stoppedVms = Get-AzVM | Where-Object { $_.powerstate -eq "Vm deallocation" }



# Get unattached disks
$unattachedDisk = Get-AzDisk | Where-object { -not $_.ManagedBY }

#Get unused IPs
$unusedIPs = Get-AzpublicIpAddress | Where-Object { $_Ipconfiguration -eq $null }



write-Host "===== Stopped VMs ====="
$stoppedVMs | ForEach-object { write-Host $_.Name }


write-Host "`n===== unattached Disks ==="
$unattachedDisks | forEach-object { write-Host $.Name }


write-Host "n===== unused public IPs ====="
$unusedIPs | ForEach-object { write-Host $_.Name }



# Optionaolly export to file 
$timestamp = Get-Date -Format "yyyy-mm-dd_HH-mm"
$reportpath = "stale-resources_report_$timestamp.txt"



@"


======= Stopped VMs =====
$($stoppedVMs.Name)

===== unattached Disks ====
$($unattachedDisks.Name)


======== unused public IPs =======

$($unusedIPs.Name)
"@ | Out-File -Filepath $reportpath 


write-Host "Report saved: $reportpath"


                                                                                          