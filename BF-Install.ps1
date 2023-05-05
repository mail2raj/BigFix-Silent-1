try {
    cd C:\BF-Files
} catch {
    Write-Host "Error: C:\BF-Files directory does not exist."
    exit
}
#Files for the installer
$server = "BigFix Server.msi"
$console = "BigFix Console.msi"
$client = "BigFix Client.msi"





$choice = Read-Host "Which MSI do you want to install? Please Enter your choice `n 1 for Server`n 2 for Console`n 3 for Client `n All to install all the three components`n"

if ($choice -eq "All" -or "all")
{
echo "Installing all components one by one"
if (!(Test-Path $server)) {
    Write-Host "Error: $server does not exist in C:\BF-Files directory."
    exit
}

echo "Installing BigFix Server Started"
    Start-Process msiexec.exe -ArgumentList "/i `"$server`" /qn" -Wait
    echo "Installation of BigFix Server is completed. Checking the Required Directories"
    if (!(Test-Path "C:\Program Files (x86)\BigFix Enterprise\Bes Server"))
    {
    echo "The BigFix Directory is not found. Please validate the Installation Files"
    exit
    } 

if (!(Test-Path $console)) {
    Write-Host "Error: $console does not exist in C:\BF-Files directory."
    exit
} 
echo "Installing the BigFix Console"
    Start-Process msiexec.exe -ArgumentList "/i `"$console`" /qb" -Wait
    echo "Installation is successful"

if (!(Test-Path $client)) {
    Write-Host "Error: $client does not exist in C:\BF-Files directory."
    exit
}   echo "Installing the BigFix Client"
    Start-Process msiexec.exe -ArgumentList "/i `"$client`" /qb" -Wait
    
    

    if (!(Test-Path "C:\Program Files (x86)\BigFix Enterprise\BES Client\__BESData\__Global\Logs"))
    {
    echo "The Client installation Folder is not present. Please verify the installer"
    exit
    }
    else
    {
    Get-Content "C:\Program Files (x86)\BigFix Enterprise\BES Client\__BESData\__Global\Logs\*.log" | ForEach-Object {
    Write-Host $_
    Start-Sleep -Seconds 5
}
echo "Installation is successful, Checking the Logs for the deployment"
}


}

elseif ($choice -eq "1") {
    if (!(Test-Path $server)) {
    Write-Host "Error: $server does not exist in C:\BF-Files directory."
    exit
} 
    echo "Installing BigFix Server Started"
    Start-Process msiexec.exe -ArgumentList "/i `"$server`" /qn" -Wait
    echo "Installation of BigFix Server is completed. Checking the Required Directories"
    if (!(Test-Path "C:\Program Files (x86)\BigFix Enterprise\Bes Server"))
    {
    echo "The BigFix Directory is not found. Please validate the Installation Files"
    exit
    }

} elseif ($choice -eq "2") {

if (!(Test-Path $console)) {
    Write-Host "Error: $console does not exist in C:\BF-Files directory."
    exit
}   
    echo "Installing the BigFix Console"
    Start-Process msiexec.exe -ArgumentList "/i `"$console`" /qb" -Wait
    echo "Installation is successful"
} elseif ($choice -eq "3") {

    if (!(Test-Path $client)) {
    Write-Host "Error: $client does not exist in C:\BF-Files directory."
    exit
}   echo "Installing the BigFix Client"
    Start-Process msiexec.exe -ArgumentList "/i `"$client`" /qb" -Wait
    
    

    if (!(Test-Path "C:\Program Files (x86)\BigFix Enterprise\BES Client\__BESData\__Global\Logs"))
    {
    echo "The Client installation Folder is not present. Please verify the installer"
    exit
    }
    else
    {
    $logDir = "C:\Program Files (x86)\BigFix Enterprise\BES Client\__BESData\__Global\Logs"
    $logFiles = Get-ChildItem -Path $logDir -Filter "*.log" | Sort-Object LastWriteTime -Descending
    $latestLog = $logFiles[0].FullName
    Get-Content -Path $latestLog -Tail 10
}
echo "Installation is successful, Checking the Logs for the deployment"
}

 else {
    Write-Host "Invalid choice. Please enter the correct response"
}
