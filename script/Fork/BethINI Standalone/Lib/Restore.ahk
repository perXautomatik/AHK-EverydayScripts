Restore(Message="true", CreationKit="true", Suffix="")
	{
		if Suffix =
			Suffix := "." . shortName . "backup"
		sm("Reverting your INI files...")
		IfNotExist, %INIfolder%%gameNameINI%.ini%Suffix%
			sm(gameNameINI . ".ini." .  shortName . "backup does not exist, so it will not be restored.")
		IfNotExist, %INIfolder%%gameNameINI%Custom.ini%Suffix%
			sm(gameNameINI . "Custom.ini." .  shortName . "backup does not exist, so it will not be restored.")
		IfNotExist, %INIfolder%Custom.ini%Suffix%
			sm("Custom.ini." .  shortName . "backup does not exist, so it will not be restored.")
		IfNotExist, %INIfolder%%gameNameINI%Prefs.ini%Suffix%
			sm(gameNameINI . "Prefs.ini." .  shortName . "backup does not exist, so it will not be restored.")
		if CreationKit = true
			{
				bCreationKit := getSettingValueProject("General", "bCreationKit")
				if bCreationKit = 1
					{
						IfNotExist, %gameFolder%%gameNameINI%Editor.ini%Suffix%
							sm(gameNameINI . "Editor.ini." . shortName . "backup does not exist, so it will not be restored.")
						IfNotExist, %gameFolder%%gameNameINI%EditorPrefs.ini%Suffix%
							sm(gameNameINI . "EditorPrefs.ini." . shortName . "backup does not exist, so it will not be restored.")
					}
			}
		IfExist, %INIfolder%%gameNameINI%.ini%Suffix%
			FileMove, %INIfolder%%gameNameINI%.ini%Suffix%, %INIfolder%%gameNameINI%.ini, 1
		IfExist, %INIfolder%%gameNameINI%Custom.ini%Suffix%
			FileMove, %INIfolder%%gameNameINI%Custom.ini%Suffix%, %INIfolder%%gameNameINI%Custom.ini, 1
		IfExist, %INIfolder%Custom.ini%Suffix%
			FileMove, %INIfolder%Custom.ini%Suffix%, %INIfolder%Custom.ini, 1
		IfExist, %INIfolder%%gameNameINI%Prefs.ini%Suffix%
			FileMove, %INIfolder%%gameNameINI%Prefs.ini%Suffix%, %INIfolder%%gameNameINI%Prefs.ini, 1
		IfExist, %gameFolder%%gameNameINI%Editor.ini%Suffix%
			FileMove, %gameFolder%%gameNameINI%Editor.ini%Suffix%, %gameFolder%%gameNameINI%Editor.ini, 1
		IfExist, %gameFolder%%gameNameINI%EditorPrefs.ini%Suffix%
			FileMove, %gameFolder%%gameNameINI%EditorPrefs.ini%Suffix%, %gameFolder%%gameNameINI%EditorPrefs.ini, 1
		tempText = Your INI files were successfully reverted.
		sm(tempText)
		if Message = true
			MsgBox, %tempText%
		return
	}