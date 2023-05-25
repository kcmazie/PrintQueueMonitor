<#==============================================================================
         File Name : PrintQueueMonitor.ps1
   Original Author : Kenneth C. Mazie (kcmjr @ kcmjr.com)
                   :
       Description : This script is intended to be used on a LOCAL print server so as
                   : to monitor the print queues for activity. It is difficult to identify
                   : every user who may have a printer installed when you are trying to
                   : decommission or migrate print servers. This allows you to get notified
                   : if the queues are still being used. Cycle period is adjustable. All queues
                   : are polled and checked each cycle. It is recommended that this is executed
                   : locally on the server being monitored via a scheduled task set to run
                   : indefinitely every 5 minutes.
                   :
         Arguments : Named command line parameters: (all are optional)
                   : None
                   :
             Notes : !!! -- Best run from a scheduled job -- !!!
                   : To test while running place a blank file named "flagfile.txt" in the script folder.
                   :
          Warnings : Be prepared to be SPAMMED !!! Set up a folder and associated rule for these!
                   :
             Legal : Public Domain. Modify and redistribute freely. No rights reserved.
                   : SCRIPT PROVIDED "AS IS" WITHOUT WARRANTIES OR GUARANTEES OF
                   : ANY KIND. USE AT YOUR OWN RISK. NO TECHNICAL SUPPORT PROVIDED.
                   : That being said please let me know if you find bugs!
                   :
           Credits : Code snippets and/or ideas came from many sources around the web.
                   :
    Last Update by : Kenneth C. Mazie (email kcmjr AT kcmjr.com for comments or to report bugs)
   Version History : v1.00 - 07-03-18 - Original
    Change History : v2.00 - 00-00-00 -
                   :
#===============================================================================#>
<#PSScriptInfo
.VERSION 1.00
.AUTHOR Kenneth C. Mazie (kcmjr AT kcmjr.com)
.DESCRIPTION
This script is intended to be used on a LOCAL print server to monitor the print queues for activity. It is difficult to identify
every user who may have a printer installed when you are trying to decommission or migrate print servers. This allows you to get notified
if the queues are still being used. Cycle period is adjustable. All queues are polled and checked each cycle. If ANY job is detected
an email gets sent. It is recommended that this is executed locally on the server being monitored via a scheduled task set to run
indefinitely every 5 minutes. To test while running place a blank file named "flagfile.txt" in the script folder.
#>

clear-host 

Function SendEmail {
    $Domain = $Env:UserDnsDomain
    $EmailTo = ""                                                #--[ Edit this as needed before use ]--
    #$EmailFrom = "$Env:ComputerName@$Env:UserDnsDomain"
    $EmailFrom = "PrintQueueMonitor@$Env:UserDnsDomain"
    $SmtpServer = ""                                             #--[ Edit this as needed before use ]--
    $email = New-Object System.Net.Mail.MailMessage
    $email.From = $EmailFrom
    $email.IsBodyHtml = $true
    $email.To.Add($EmailTo)
    $email.Subject = "Print Queue Activity"
    $email.Body = $Script:ReportBody
    $smtp = new-object System.Net.Mail.SmtpClient($SmtpServer)
    $smtp.Send($email)
}

$Counter = 0
#
# 4 min 50 sec = 290 sec
# script rotation every 5 minutes via scheduled task
# loop sleep 5 seconds = counter of 58
# loop sleep 3 seconds = counter of 97
# loop sleep 1 seconds = counter of 290
#
#
If ($Psversiontable.PSVersion.Major -le 2){
    $ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition
}Else{
    $ScriptPath = $PSScriptRoot
}    

While ($Counter -lt 290){
    If (Test-Path "$ScriptPath/flagfile.txt"){
        Remove-Item "$ScriptPath/flagfile.txt" -Force -Confirm:$false
        $Script:ReportBody = "Print Queue Script is working..."
        write-host "Sending Test Email"
        Write-host $ScriptPath
        SendEmail
    }

    $Jobs = Get-WMIObject Win32_PerfFormattedData_Spooler_PrintQueue |  Select Name, @{Expression={$_.jobs};Label="CurrentJobs"}, TotalJobsPrinted, JobErrors
    ForEach ($job in $jobs){
        If ($Job.CurrentJobs -gt 0){
            $Script:ReportBody = $Job.Name
            $Script:ReportBody += $Jobs.TotalJobsPrinted
            SendEmail
        }
    }
    Start-Sleep -Seconds 1
    $Counter++
}
