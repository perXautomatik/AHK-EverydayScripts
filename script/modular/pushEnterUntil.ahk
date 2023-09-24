

pushEnterUntil()
{
	SetTitleMatchMode 2
	
	 while IfWinExist  TortoiseGit
	{
		
		WinActivate,TortoiseGit
		{
			Send,{Enter}			
		}
		sleep 50
	}

return
}