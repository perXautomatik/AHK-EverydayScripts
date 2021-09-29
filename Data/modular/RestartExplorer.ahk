restartExplorer(){
   
   Run, taskkill.exe /im explorer.exe /f
   
   sleep, 1000
   
   Run, explorer.exe
}