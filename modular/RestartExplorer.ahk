restartExplorer(){
   try {
      
      Run, taskkill.exe /im explorer.exe /f
      
   } catch  {
         MsgBox, An exception was thrown!`nSpecifically: %e%
      Exit
   }
   sleep, 1000
   try {
      
      Run, explorer.exe
   } catch  {
      MsgBox, An exception was thrown!`nSpecifically: %e%
      Exit
   }
}