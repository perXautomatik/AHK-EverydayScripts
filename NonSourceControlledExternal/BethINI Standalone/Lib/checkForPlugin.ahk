checkForPlugin(Plugin)
	{
		if INIfolder contains rofiles
			pluginstxt = %INIfolder%plugins.txt
		else
			{
				SplitPath, A_AppData,, appdata
				pluginstxt = %appdata%\Local\%gameNameReg%\plugins.txt
			}
		sm("plugins.txt is located here: " . pluginstxt)
		FileRead, plugins, %pluginstxt%
		if plugins contains %Plugin%
			return 1
		return 0
	}