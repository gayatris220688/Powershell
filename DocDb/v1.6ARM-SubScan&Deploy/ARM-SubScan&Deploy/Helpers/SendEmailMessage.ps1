Function SendEmail {
       param
       (
              [string]$strTo,
              [string]$strCc,
              [string]$strBCc,
              [string]$strSubject,
              [string]$strBody,
              [string]$filename,
              [string]$logfilename
       )
       
    
    ##SMTP Server Address##
    $smpthost = "smtp.office365.com"      

    for($attempt=0;$attempt -lt 3;$attempt++)
       {
              $ObjMsg = new-object Net.Mail.MailMessage
              $ObjSmtp = new-object Net.Mail.SmtpClient($smpthost)
              $ObjSmtp.UseDefaultCredentials = $true
              $ObjSmtp.Port = 25;
              $ObjSmtp.EnableSsl = $true;
              $emailFrom = "{0}@mindtree.com" -f $env:USERNAME
              $ObjMsg.From = New-Object System.Net.Mail.MailAddress($emailFrom)
              if($strTo -match ";") 
              { 
                $ToList = $strTo.split(";"); 
                foreach($to in $ToList) 
                { 
                    if($to.Contains('@'))
                    {
                        $ObjMsg.To.Add($to) 
                    }
                    else
                    {
                        write-host $to + '@mindtree.com'
                        $t = $to + '@mindtree.com'
                        $ObjMsg.To.Add($t) 
                    }
                    
                } 
              }
              else 
              {             
                    if($strTo.Contains('@'))
                    {
                        $ObjMsg.To.Add($strTo) 
                    }
                    else
                    {
                        #write-host $strTo + '@mindtree.com'
                        $t = $strTo + '@mindtree.com'
                        $ObjMsg.To.Add($strTo + '@mindtree.com') 
                    }
              }

              ################### Email to Cc People ############

              if(![String]::IsNullOrEmpty($strCc))
              {
                  if($strCc -match ";") 
                  { 
                    $ToList = $strCc.split(";"); 
                    foreach($to in $ToList) 
                    { 
                        if($to.Contains('@'))
                        {
                            $ObjMsg.Cc.Add($to) 
                        }
                        else
                        {
                            write-host $to + '@mindtree.com'
                            $t = $to + '@mindtree.com'
                            $ObjMsg.Cc.Add($t) 
                        }
                    
                    } 
                  }
                  else 
                  {             
                        if($strCc.Contains('@'))
                        {
                            $ObjMsg.Cc.Add($strCc) 
                        }
                        else
                        {
                            #write-host $strTo + '@mindtree.com'
                            $t = $strCc + '@mindtree.com'
                            $ObjMsg.Cc.Add($strCc + '@mindtree.com') 
                        }
                  }
              }
              ###################################################

              ################### Email to Bcc People ############

              if(![String]::IsNullOrEmpty($strBCc))
              {
                  if($strBCc -match ";") 
                  { 
                    $ToList = $strBCc.split(";"); 
                    foreach($to in $ToList) 
                    { 
                        if($to.Contains('@'))
                        {
                            $ObjMsg.BCc.Add($to) 
                        }
                        else
                        {
                            write-host $to + '@mindtree.com'
                            $t = $to + '@mindtree.com'
                            $ObjMsg.BCc.Add($t) 
                        }
                    
                    } 
                  }
                  else 
                  {             
                        if($strCc.Contains('@'))
                        {
                            $ObjMsg.BCc.Add($strCc) 
                        }
                        else
                        {
                            #write-host $strTo + '@mindtree.com'
                            $t = $strBCc + '@mindtree.com'
                            $ObjMsg.BCc.Add($strBCc + '@mindtree.com') 
                        }
                  }
              }
              ###################################################
              
              #$ObjMsg.To.Add($emailFrom)
              $ObjMsg.Subject = $strSubject
              $ObjMsg.Body = $strBody
              $ObjMsg.IsBodyHtml = $true 
              if($filename){
              if(Test-Path $filename) {$ObjMsg.Attachments.Add($filename)}else{Write-host "No file for attachment $filename"}}
              if($logfilename){
              if(Test-Path $logfilename){$ObjMsg.Attachments.Add($logfilename)}else{Write-host "No logfile for attachment $logfilename"}}
              
              try
              {      
                     $ObjSmtp.Send($ObjMsg)
                     if($?) { return $true }
              }
              catch [System.Exception]
              {
    
                     $ObjMsg = $null
                     $ObjSmtp = $null
                     continue;
              }
       }
    
       return $false
}
