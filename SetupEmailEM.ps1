# This project is licensed under the MIT License - see the LICENSE file for details.
#set and save the encryption key
$key = 0..255 | Get-Random -Count 32 | %{[byte]$_}
$keyString = ($key -join ',') 
[System.Environment]::SetEnvironmentVariable("MyKey", $keyString, [System.EnvironmentVariableTarget]::User)

#Save the password as Json file
$sender = Read-Host "Please enter sender email address" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString -Key $key
$secureString = Read-Host "Please enter your password" -AsSecureString
$serversmtp = Read-Host "Please enter SMTP Server" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString -Key $key
$portsmtp = Read-Host "Please enter SMTP Port" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString -Key $key
$path = Read-Host "Please enter the file location"
[System.Environment]::SetEnvironmentVariable("PathforFile", $path, [System.EnvironmentVariableTarget]::User)
$pathpw = $path + "\password.json"

$encryptedPassword = $secureString | ConvertFrom-SecureString -Key $key
$receiver = Read-Host "Please enter receiver email address separated with comma" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString -Key $key

$credentialObject = @{
    "SenderEmail" = $sender
    "ReceiverEmail" = $receiver -split ","
    "EncryptedPassword" = $encryptedPassword
    "SmtpServer" = $serversmtp
    "SmtpPort" = $portsmtp
}

$credentialObject | ConvertTo-Json | Set-Content -Path $pathpw
