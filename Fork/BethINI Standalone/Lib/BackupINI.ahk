BackupINI(INItoBackup, FirstTimeBackup, CreationKitFile="false", ExitIfWriteAccessDenied="true", Suffix="")
	{
		/*
		Usage:
		
		INItoBackup is the full path to the INI file to be backed up
		FirstTimeBackup is either 0 false or 1 true
		ExitIfWriteAccessDenied if set to true (default) will cause the app to exit unless CreationKitFile is set to true
		CreationKitFile indicates that the INItoBackup is a Creation Kit INI
		Suffix is any custom suffix to append to the filename.
		*/
		if Suffix =
			Suffix := "." . shortName . "backup"
		SplitPath, INItoBackup, INItoBackupFileName, INItoBackupDirectory
		IfNotExist, %INItoBackup%
			{
				if CreationKitFile = true
					{
						sm(INItoBackup . " does not exist. Setting bCreationKit=0 and skipping Creation Kit backup procedure.")
						IniWrite, 0, %scriptName%.ini, General, bCreationKit
					}
				else
					sm(INItoBackup . " does not exist, so it will not be backed up.")
			}
		else
			{
				FileSetAttrib, -R, %INItoBackup%
				FileCopy, %INItoBackup%, %INItoBackup%%Suffix%, 1
				FileCopy, %INItoBackup%, %INIfolder%%shortName% Cache\%theTime%\%INItoBackupFileName%
				if FirstTimeBackup = 1
					FileCopy, %INItoBackup%, %INIfolder%%shortName% Cache\Before %shortName%\%INItoBackupFileName%
				IfNotExist, %INItoBackup%%Suffix%
					{ 
						if CreationKitFile = true
							{
								sm("Error backing up " . INItoBackup . "! It appears you do not have write access to the " . INItoBackupDirectory . " folder. Setting bCreationKit=0 and skipping Creation Kit backup procedure.")
								IniWrite, 0, %scriptName%.ini, Directories, bCreationKit
							}
						else 
							{
								if ExitIfWriteAccessDenied = true
									{
										tempText = Error backing up %INItoBackup%! It appears you do not have write access to the %INItoBackupDirectory% folder. %shortName% shall now exit.
										MsgBox, %tempText%
										sm(tempText)
										ExitApp
									}
								else
									{
										tempText = Error backing up %INItoBackup%! It appears you do not have write access to the %INItoBackupDirectory% folder.
										sm(tempText)
									}
							}
					}
			}
		return
	}