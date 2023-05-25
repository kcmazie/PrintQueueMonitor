# PrintQueueMonitor
This script is intended to be used on a LOCAL print server to monitor the print queues for activity.

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
