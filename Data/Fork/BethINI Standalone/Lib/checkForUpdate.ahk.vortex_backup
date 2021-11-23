checkForUpdate()
	{
		whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		Results = No Error.
		try 
			{
				whr.Open("GET", "https://www.nexusmods.com/fallout4/mods/67", true)
				whr.Send()
				whr.WaitForResponse()
				NexusPage := whr.ResponseText
			}
		catch e
			{
				sm("Exception caught checking for updates.")
			}
		sm(Results)
		if NexusPage contains Version
			{
				StringGetPos, fileVersionPos, NexusPage, Version
				StringGetPos, startingPosition, NexusPage, % "content=", , %fileVersionPos%
				StringGetPos, endingPosition, NexusPage, % " />", , %startingPosition%
				startingPosition += 10
				NexusVersion := SubStr(NexusPage, startingPosition, endingPosition - startingPosition)
				if NexusVersion != 3.5
					{
						sm("A new version (" . NexusVersion . ") is available!")
						MsgBox, 1, An update to BethINI is available!, Click OK to open the Nexus page so you can download the latest version. Or click cancel and continue using this outdated version. Your choice. Automatically checking for updates can be disabled in the Setup tab.
						IfMsgBox OK
							{
								if gameName = Skyrim Special Edition
									Run, http://www.nexusmods.com/skyrimspecialedition/mods/4875
								else if gameName = Skyrim
									Run, https://www.nexusmods.com/skyrim/mods/69787
								else if gameName = Oblivion
									Run, https://www.nexusmods.com/oblivion/mods/46440
								else if gameName = Fallout 4
									Run, https://www.nexusmods.com/fallout4/mods/67
								else if gameName = Fallout 3
									Run, https://www.nexusmods.com/fallout3/mods/21741
								else if gameName = Fallout New Vegas
									Run, https://www.nexusmods.com/newvegas/mods/60560
							}
					}
				else
					sm("This version is up to date!")
				return
			}
		else
		 {
			sm("Failed to check for update!")
			return
		 }
	}