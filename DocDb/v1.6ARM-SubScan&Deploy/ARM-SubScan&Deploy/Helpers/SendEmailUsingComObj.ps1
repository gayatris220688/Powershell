#Sends email message using Outlook COM object rather than SMTP Client#
Function Invoke-SendEmailUsingComObj{
   param(
      $strTo,
      $strCc,
      $strBcc,
      [string]$subject,
      [string]$htmlBody
   )
   $mailstatus = $false;

      try {

         $Outlook = New-Object -ComObject Outlook.Application
         $Mail = $Outlook.CreateItem(0);

         if(![string]::IsNullOrEmpty($strTo)){
            $Mail.To = [string]$strTo;
         }

         if(![string]::IsNullOrEmpty($strCc)){
            $Mail.CC = [string]$strCc;
         }

         if(![string]::IsNullOrEmpty($strBcc)){
            $Mail.BCC = $strBcc;
         }

         if(![string]::IsNullOrEmpty($subject)){
            $Mail.Subject = $subject;
         }

         if(![string]::IsNullOrEmpty($htmlBody)){
            $Mail.HTMLBody = $htmlBody;
         }
         $Mail.Send()
         [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Outlook) | Out-Null
         $mailstatus = $true;
      }
      catch {
         Write-Host "[EXCEPTION]: $($_.Exception)" -ForegroundColor Red
      }

   return $mailstatus;
}

Function Import-ReceipientList{
   param($emailConfig)

   if($null -ne $emailConfig)
   {
      $to = $emailConfig | Select-Object Tolist ;
      $cc = $emailConfig | Select-Object Cclist ;
      $bcc = $emailConfig | Select-Object Bcclist ;

      if($null -ne $to){
         foreach($item in $to){
            $emailto+= $item.Tolist + ";";
         }
      }

      if($null -ne $cc){
         foreach($itemcc in $cc){
            $emailcc+= $itemcc.Cclist + ";";
         }
      }

      if($null -ne $bcc){
         foreach($itembcc in $bcc){
            $emailbcc+= $itembcc.Bcclist + ";";
         }
      }
   }

   return $emailto.TrimEnd(';'),$emailcc.TrimEnd(';'),$emailbcc.TrimEnd(';');
}