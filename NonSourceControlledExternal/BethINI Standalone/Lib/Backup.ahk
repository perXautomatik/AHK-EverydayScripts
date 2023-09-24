Backup()
	{
		sm("Backing up INIs...")
		FirstTimeBackup = 0
		IfNotExist, %INIfolder%%shortName% Cache\Before %shortName%
			{
				sm("Creating First Time Backup...")
				FileCreateDir, %INIfolder%%shortName% Cache\Before %shortName%
				FirstTimeBackup = 1
			}
		bCreationKit := getSettingValueProject("General", "bCreationKit") ;Checks if the user has specified the Creation Kit to NOT be modified.
		if bCreationKit =
			{
				bCreationKit = 0
				IniWrite, 0, %scriptName%.ini, General, bCreationKit
			}
		if bCreationKit = 1 ;if the Creation Kit files are specified to be modified, they will be backed up.
			{
				BackupINI(gameFolder . gameNameINI . "Editor.ini", FirstTimeBackup, "true")
				BackupINI(gameFolder . gameNameINI . "EditorPrefs.ini", FirstTimeBackup, "true")
			}
		BackupINI(INIfolder . gameNameINI . ".ini", FirstTimeBackup)
		if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Fallout New Vegas")
			BackupINI(INIfolder . gameNameINI . "Custom.ini", FirstTimeBackup)
		if gameName = Fallout 3
			BackupINI(INIfolder . "Custom.ini", FirstTimeBackup)
		BackupINI(INIfolder . gameNameINI . "Prefs.ini", FirstTimeBackup)
		
		sm("Finished backing up any INI files.")
		return
	}