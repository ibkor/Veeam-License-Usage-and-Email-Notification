$date = Get-Date -format "dd-MM-yyyy"
$Applications = 0; $Servers = 0; $VMs = 0
$licinfo = gwmi -namespace root\veeamem -Class License
$licusage = $licinfo.GetDetailedLicensedInstancesCounters()

[xml]$xmllic = $licusage.ReturnValue
$TotalUsage = $xmllic.lic.totalInst
foreach ($stat in $xmllic.lic.using.stat) {
    $platformId = $stat.PlatformId
    $usedInst = $stat.usedInst
    
    # Perform actions based on PlatformId
    switch ($platformId) {
        "eef5400f-e4e7-4ebf-86f9-d4e54b88c028" {
            # Applications
            $Applications = $usedInst         
            break
        }
        "11d0870b-566f-46ce-a190-e65a4ae39f09" {
            # Servers
            $Servers = $usedInst 
            break
        }
        "ab555a3a-8f2d-492a-83ee-a41ecd3b0893" {
            # VMs
            $VMs = $usedInst
            break
        }
        # In case more platformIds Appear
        default {
            Write-Host "Unknown PlatformId: $platformId"
            break
        }
      }      
}

#Email Body
$EBody = @"
    <table style="width: 60%" style="border: 1px solid #008000;">
        <tr>
            <td colspan="2" bgcolor="#008000" style="color: #FFFFFF; font-size: large; height: 30px;">
             Summary of License Consumption on $date
            </td>
         </tr>
         <tr style="border-bottom-style: solid; border-bottom-width: 1px; padding-bottom: 1px">
              <td style="width: 201px; height: 35px"> Total Used Instances </td>
              <td style="text-align: center; height: 35px; width: 233px;">
               <b>$TotalUsage</b></td>
        </tr>
        <tr style="height: 39px; border: 1px solid #008000">
              <td style="width: 201px; height: 39px">  Virtual Machines</td>
              <td style="text-align: center; height: 39px; width: 233px;">
               <b>$VMs</b></td>
         <tr style="height: 39px; border: 1px solid #008000">
              <td style="width: 201px; height: 39px">  Servers</td>
              <td style="text-align: center; height: 39px; width: 233px;">
               <b>$Servers</b></td>
        </tr>
              <tr style="height: 39px; border: 1px solid #008000">
              <td style="width: 201px; height: 39px">  Applications</td>
              <td style="text-align: center; height: 39px; width: 233px;">
              <b>$Applications</b></td>
        </tr>
</table>
"@

#retrieve the key
$keyString = [System.Environment]::GetEnvironmentVariable("MyKey", [System.EnvironmentVariableTarget]::User)
$path = [System.Environment]::GetEnvironmentVariable("PathforFile", [System.EnvironmentVariableTarget]::User)
$pathpw = $path + "\password.json"
$key = $keyString -split ',' | ForEach-Object { [byte]$_ }

# Read the JSON file
$jsonContent = Get-Content -Path $pathpw | ConvertFrom-Json

$encryptedSender = $jsonContent.SenderEmail | ConvertTo-SecureString -Key $key 
$encryptedReceiver = $jsonContent.ReceiverEmail | ConvertTo-SecureString -Key $key
$encryptedSmtpServer = $jsonContent.SmtpServer | ConvertTo-SecureString -Key $key
$encryptedSmtpPort = $jsonContent.SmtpPort | ConvertTo-SecureString -Key $key
$password = $jsonContent.EncryptedPassword | ConvertTo-SecureString -Key $key  
$senderEmail = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($encryptedSender))
$receiverEmail = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($encryptedReceiver))
$smtpServer = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($encryptedSmtpServer))
$smtpPort = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($encryptedSmtpPort))
$receiverEmailsArray = $receiverEmail -split ","
$subject = "Veeam Weekly License Consumption"
$body = $EBody

$credentials = New-Object System.Management.Automation.PSCredential ($senderEmail, $password)

foreach ($email in $receiverEmailsArray) {
    Send-MailMessage -SmtpServer $smtpServer -Port $smtpPort -From $senderEmail -To $email.Trim() -Subject $subject -Body $body -BodyAsHtml -Credential $credentials
}