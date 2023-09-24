#Persistent
#SingleInstance, Force
#Include BinReadWrite.ahk

myVERSION=3.01
StringCaseSense On

;TESVSGM ini-filename
TESVSGMINIFILENAME=TESVSGM.ini
SKYRIMINIFILE=Skyrim.ini

;Location of the Savegames folder
SAVEGAMESFOLDER=
PROFILESSUBFOLDER=TESVSGM
PROFILETOBACKUP=

;the name of the active profile (=foldername)
ACTIVE=
ACTIVELOCATION=
ACTIVELEVEL=
ACTIVEPLAYTIME=
ACTIVEPT=
ACTIVENAME=
ACTIVERACE=
ACTIVEGENDER=
ACTIVESAFEGAMETIME=
ACTIVEINIFILE=
ACTIVEDIFFICULTY=

ACTIVESGCOUNT=
ACTIVESGSIZE=

;Others variables for storing the TESVSGM.ini datas
PLAYBUTTONLINK=
PLAYBUTTONPARAM=
SAVEGAMESKEEP=
SAVEGAMESCOUNTS=
BACKUPATH=
SAVEGAMESTYPE=
SAVEGAMESHOURS=
ALWAYSBACKUP=
ALWAYSCLEANUP=
PROFILEFORNEWGAME=

;Active Game name
NEXTGAMENAME=

;detected locale Name
LOCALENAME=
LOCALEUSED=

;For saving menu name for being able to update localisation of the menu
SAVEOLDMENUNAMEFILE=
SAVEOLDMENUNAMEPROFILE=
SAVEOLDMENUNAMEHELP=

;Status of GUI (updatable or not)
IS_GUI_UPDATABLE = false

;locales subfolder
LOCALESSUBFOLDER=locales

;Things to do before making the main GUI

;Upgrade the TESVSGM.ini if needed
gosub, subConvertTESVSGMIni

;read TESVSGM.ini
gosub, subReadTESVSGMIni

;get the system language
gosub, subGetLocaleName

;load all strings of the actual language
gosub, subInitLocaleParameters


IS_GUI_UPDATABLE = true
;------------------------------------
; G*U*I
;------------------------------------

;------------
; Sub Menus
;------------
;test = Options

;File
Menu, subMenuSG, Add, Skyrim SE, subSwitchGame
IF SKYRIMSE = 1
{
	Menu, subMenuSG, Check, Skyrim SE
}
Else
{
	Menu, subMenuSG, Uncheck, Skyrim SE
}
Menu, subMenuSG, Add, %localestr1%, subOptions
Menu, subMenuSG, Add	;a line -----
Menu, subMenuSG, Add, %localestr2%, subExit

;Profile
Menu, subMenuADV, Add, %localestr3%, submenuSGHandler
Menu, subMenuADV, Add, %localestr4%, submenuSGHandler
Menu, subMenuADV, Add	;a line -----
Menu, subMenuADV, Add, %localestr5%, submenuSGHandler
Menu, subMenuADV, Add	;a line -----
Menu, subMenuADV, Add, %localestr6%, submenuSGHandler
Menu, subMenuADV, Add, %localestr7%, submenuSGHandler
Menu, subMenuADV, Add, %localestr8%, submenuSGHandler
Menu, subMenuADV, Add	;a line -----
Menu, subMenuADV, Add, %localestr9%, submenuSGHandler
Menu, subMenuADV, Add, %localestr10%, submenuSGHandler

;help
Menu, subMenuHELP, Add, %localestr11%, submenuHELPHandler
Menu, subMenuHELP, Add 	;a line -----
Menu, subMenuHELP, Add, %localestr12%, submenuHELPHandler 
Menu, subMenuHELP, Add, %localestr13%, submenuHELPHandler 
Menu, subMenuHELP, Add 	;a line -----
Menu, subMenuHELP, Add, %localestr14%, submenuHELPHandler

;attach menus to app
Menu, menuMain, Add, %localestr15%, :subMenuSG
Menu, menuMain, Add, %localestr16%, :subMenuADV
Menu, menuMain, Add, %localestr17%, :subMenuHELP

;----------------
; Tray Menu
;----------------


;remove AHK items
Menu, Tray, NoStandard

Menu, Tray, Add		;a line ------ 
Menu, Tray, Add, %localestr18%, submenuTrayHandler
Menu, Tray, Add		;a line ------ 
Menu, Tray, Add, %localestr19%, submenuTrayHandler
Menu, Tray, Add		;a line ------ 
Menu, Tray, Add, %localestr20%, submenuTrayHandler


;-------------------------------------
;GUI window 1
;-------------------------------------
Gui, Main:+OwnDialogs

;Gui, Add, GroupBox, x6 y1 w320 h390 , 
;Gui, Font, bold,
Gui, Add, Text, x16 y11 w200 h20 vSelectProfile, %localestr21% ;Select Profile
;Gui, Font
If NEXTGAMENAME = Skyrim SE 
{
	Gui, Add, Text, x260 y11 w56 h20 cgreen right vEdition, Skyrim
} 
else 
{
	Gui, Add, Text, x260 y11 w56 h20 cblue right vEdition, Skyrim SE
}
Gui, Add, DropDownList, x16 y31 w300 h300 sort vddlCharacter gguiDropdownProfile

Gui, Add, Button,  x15 y60 w240 h40 DEFAULT gsubRunSkyrim vPlay, %localestr22% ;Play
Gui, Add, Button, x260 y60 w57 h40 gguiDropdownProfile vRefresh, %localestr23% ;Refresh

Gui, Add, Tab2, x15 y110 w300 h280 vMainTab, %localestr24%|%localestr25%|%localestr26%

Gui, Tab, 1
Gui, Font, bold,
Gui, Add, Text, x25 y140 w100 h20 vScreenshot, %localestr27% ;Screenshot
Gui, Add, Picture, x25 y160 w280 h154 +E0x200 vpic ;, standard.jpg
Gui, Add, Text, x25 y320 h20 w60 vLabelPlayTime, Time ;%localestr28%: ;Time
Gui, Add, Text, x180 y320 h20 w60 vLabelLevel, %localestr29%: ;Level
Gui, Add, Text, x25 y340 h20 w60 vLabelRace, %localestr30%: ;Race
Gui, Add, Text, x180 y340 h20 w60 vLabelDiffy, %localestr31%: ;Difficulty
Gui, Add, Text, x25 y360 h20 w60 vLabelPlace, %localestr32%: ;Location
Gui, Font,

Gui, Add, Text, x85 y320 w50 h20 vPlayTime,
Gui, Add, Text, x240 y320 w40 h20 vLevel,
Gui, Add, Text, x85 y340 w90 vRace, 
Gui, Add, Text, x240 y340 w70 vDiffy,
Gui, Add, Text, x85 y360 w215 -wrap vPlace, 

Gui, Tab, 2
Gui, Add, Text, x25 y140 w250 h20 vLabelDescription, %localestr33% ;Notes
Gui, Font, ,Courier New
Gui, Add, Edit, x25 y160 w280 h170 vDescription
Gui, Font, , 
Gui, Add, Button, x25 y340 w80 h40 gsubSaveFile vButtonSave, %localestr34% ;Save
Gui, Add, Button, x255 y340 w50 h40 gsubClearFile vButtonClear, %localestr35% ;Clear

Gui, Tab, 3
Gui, Add, Button, x25  y140 w210 h40 vCustomIni gsubSetCustomIni, %localestr36% ;CustomIni
Gui, Add, Button, x240 y140 w65 h40 vResetCustomIni gsubResetCustomIni, %localestr37% ;ResetCustomIni
Gui, Add, Edit,   x25  y190 w280 h20 vIniFile Disabled, %SKYRIMINIFILE%

Gui, Tab
Gui, Add, Button,  x16 y400 w150 h35 vBtnCleanUp gsubCleanUpSG, %localestr38% 
Gui, Add, Button, x168 y400 w150 h35 gsubExit vButtonClose, %localestr39%
Gui, Add, StatusBar,vStatusBar, 

Gui, Show, xCenter yCenter h482 w335, Skyrim Savegame Manager %myVERSION%
Gui, Menu, menuMain
GuiControl, Focus, ddlCharacter
Main.OnEvent("Close", "Gui_close")
;------------------------------------------------

;-----------------------
; MAIN
;-----------------------
Gosub subSetupTESVSGM

;Mainloop
Return


;-------------------
subSaveFile:
{
	Gui, Submit, NoHide
	FileRecycle,  %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\Description.txt
	FileAppend, %Description%, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\Description.txt
	return
}

;-------------------
subSetCustomIni:
{
	FileSelectFile, strIniFile,1,%SAVEGAMESFOLDER%, %localestr40%, %localestr41% (*.ini)
	If ErrorLevel = 0
	{
		GuiControl,, IniFile, %strIniFile%
		FileRecycle, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\IniFile.txt
		FileAppend, %strIniFile%, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\IniFile.txt
		ACTIVEINIFILE = %strIniFile%
	}
	return
}

;-------------------
subResetCustomIni:
{
	GuiControl,, IniFile,
	ACTIVEINIFILE = 
	FileRecycle, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\IniFile.txt
	return
}

;------------
FinishApp:
GuiClose:
subExit:
{
	gosub, subWriteTESVSGMini
	ExitApp
	Return
}


;subroutines for TESVSGM
;----------------------------
subScanForNewProfiles:
{
	Gui, +Disabled
	GoSub doScanForSavegameNames
	doUpdateProfileDDL(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE)
	Gui, -Disabled
	
	;subScanForNewProfiles
	Return
}

;--------------------
doScanForSavegameNames:
{
	lstSavegames =
	strName =
	Progress, A B2 w200,, %localestr42%, 
	
	Loop, %SAVEGAMESFOLDER%\Saves\*.ess,0,1
	{
		FileCount = %A_Index%
	}
	
	Loop, %SAVEGAMESFOLDER%\Saves\*.ess,0,1 
	{
		i := %A_Index% / %FileCount%
		Progress, %i% 
		
		strSGName := A_LoopFileName
		rc := doGetSaveGameInfo(SAVEGAMESFOLDER,"Saves","",strSGName, false)
		
		;create character folders
		IfNotExist, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVENAME%
		{
			FileCreateDir, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVENAME%
		}
		
		
		SplitPath, strSGName, ,,,MoveName
		MeSKSE = %MoveName%.skse
		
		;move normal savegames to profile folder
		FileMove, %SAVEGAMESFOLDER%\Saves\%strSGName%, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVENAME%
		; Move the SKSE with the same name
		FileMove, %SAVEGAMESFOLDER%\Saves\%MeSKSE%,    %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVENAME%
		
		
	} ;loop
	
	; Moving pictures that matches the player name to the player dir
	Loop, %SAVEGAMESFOLDER%\Saves\*.jpg,0,1 
	{
		strPicName := A_LoopFileName
		StringReplace, strPicNameNoExt, A_LoopFileName, % "." . A_LoopFileExt
		IfExist, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%strPicNameNoExt%
		{
			FileMove, %SAVEGAMESFOLDER%\Saves\%strPicName%, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%strPicNameNoExt%
		}
	} ;loop
	Progress, Off
	Return   ;doScanForSavegameNames()
}


;---------------------
subSetupTESVSGM:
{
	;try to find at standard location
	
	IfNotExist, %SAVEGAMESFOLDER%\Saves
	{
		MsgBox, 0, %localestr45%, %localestr46%,
		FileSelectFolder, SAVEGAMESFOLDER,,,%localestr47%
		If ErrorLevel = 1
		{
			SAVEGAMESFOLDER = 	
		}
	}
	lstProfiles := doUpdateProfileDDL(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE)
	
	
	;subSetupTESVSGM:
	Return
}

;-------------------
subRunSkyrim:
{
	SplitPath, PLAYBUTTONLINK,, strRunfilepath
	
	IfNotExist, %PLAYBUTTONLINK%  
	{
		MsgBox, 16, %localestr48%, %localestr49%
		Return
	}
	
	if ("" . PLAYBUTTONPARAM = "") {
		Run, "%PLAYBUTTONLINK%", %strRunfilepath%
	} else {
		Run, "%PLAYBUTTONLINK%" "%PLAYBUTTONPARAM%", %strRunfilepath%
	}
	
	;subRunSkyrim
	Return
}

;-------------------
subCleanUpSG:
{
	
	Answer = 0
	
	if (ALWAYSBACKUP = 1){
		if BACKUPATH=
		{
			MsgBox, 8208, %localestr48%, %localestr50%
			return
		}
		GoSub subBackupActiveProfile
	}
	
	SetFormat, IntegerFast, D
	
	if ("" . SAVEGAMESTYPE = "" . "Files") {
		
		if (ALWAYSCLEANUP = 0) {
			MsgBox, 8484, %localestr51%, %localestr52% %SAVEGAMESCOUNTS% %localestr53%
			
			IfMsgBox, Yes	
				Answer = 1
		} else {
			Answer = 1
		}
		
		if (Answer = 1)
		{
			FileList =
			
			Loop, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\*.ess  ; Include Files and Directories
				FileList = %FileList%%A_LoopFileTimeModified%`t%A_LoopFileName%`n
			Sort, FileList, R ; Sort by date.
			
			Loop, Parse, FileList, `n
			{
				if A_LoopField =  ; Omit the last linefeed (blank item) at the end of the list.
					continue
				if A_INDEX <= %SAVEGAMESCOUNTS%
					continue
				StringSplit, FileItem, A_LoopField, %A_Tab%  ; Split into two parts at the tab char.
				
				;GuiControl,, StatusBar, Deleting file %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\%FileItem2%
				
				SplitPath, FileItem2,,,,DelName
				DeleteMeSKSE = %DelName%.skse
				DeleteMeBAK  = %FileItem2%.bak
				
				FileRecycle, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\%FileItem2%
				; Delete the SKSE with the same name
				FileRecycle, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\%DeleteMeSKSE%
				FileRecycle, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\%DeleteMeBAK%
				
				GoSub subUpdateStatusBar
			}
		}
	} else {
		
		Folder = %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\
		Files := Object()
		FileCount := 0
		
		Loop %Folder%\*.ess
		{
			rc := doGetSaveGameInfo(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE,A_LoopFileName, false)
			Files[A_Index,1] := ACTIVEPT   ; Playtime
			Files[A_Index,2] := A_LoopFileName
			FileCount += 1
		}
		
		hasChanged = 1
		FileCount := % Files.Length()
		While (hasChanged) {
			hasChanged = 0
			loop, %FileCount% {
				i := A_Index
				j := i + 1
				if (Files[i,1] < Files[j,1]) {
					tmp1 := Files[i,1]
					tmp2 := Files[i,2]
					Files[i,1] := Files[j,1]
					Files[i,2] := Files[j,2]
					Files[j,1] := tmp1
					Files[j,2] := tmp2
					hasChanged = 1
				}
			}    
		}
		
		maxHours := SubStr(Files[1,1],1,3)
		maxMin   := SubStr(Files[1,1],4,2)
		maxSec   := SubStr(Files[1,1],6,2)
		maxTime  := Files[1,1]
		
		saveSec   := 00
		saveMin   := SubStr(SAVEGAMESHOURS,5,2) 
		saveHours := (SubStr(SAVEGAMESHOURS,1,2) * 24) + SubStr(SAVEGAMESHOURS,3,2) 
		
		edgeSec   := maxSec - saveSec
		edgeMin   := maxMin - saveMin
		edgeHours := maxHours - saveHours
		
		
		if (edgeMin < 0 ) {
			edgeMin := 60 + edgeMin
			edgeHours := edgeHours - 1
		}
		if (edgeHours < 0 ) {
			edgeHours := 24 + edgeHours
			edgeDays := edgeDays - 1
		}
		
		edgeSec = 00%edgeSec%
		edgeSec := SubStr(edgeSec,-1,2)
		
		edgeMin = 00%edgeMin%
		edgeMin := SubStr(edgeMin,-1,2)
		
		edgeHours = 000%edgeHours%	
		edgeHours := SubStr(edgeHours,-2,3)
		
		edgeTime = %edgeHours%%edgeMin%%edgeSec%
		
		if (ALWAYSCLEANUP = 0) {
			MsgBox, 8484, %localestr54%, %localestr55%`n`n%edgeHours% %localestr56% %edgeMin% %localestr57% %edgeSec% %localestr58%`n`n%maxHours% %localestr56% %maxMin% %localestr57% %maxSec% %localestr59% `n`n%SAVEGAMESKEEP% %localestr60%
			IfMsgBox, Yes 
			{	
				Answer = 1
			}
		} else {
			Answer = 1
		}
		skipOnce = 0
		If (Answer = 1) 
		{
			if ((edgeHours > maxHours) or ((edgeHours = maxHours) and (edgeMin > maxMin)) or ((edgeHours = maxHours) and (edgeMin = maxMin) and (edgeSec > maxSec)))
			{
				msgbox, 48,%localestr61%, %localestr62%
				return
			}
			
			i := 1
			Progress, A B2 w200,, %localestr63%,
			loop, %FileCount% 
			{
				if (A_Index <= SAVEGAMESKEEP) {
					continue
				}
				if (Files[A_Index,1] >= edgeTime) {
					continue
				}
				if (skipOnce = 0) {
					skipOnce = 1
					continue
				}
				
				if (Files[A_Index,1] < edgeTime) {
					DeleteMe := Files[A_Index,2] 
					SplitPath, DeleteMe,,,,DelName
					DeleteMeSKSE = %DelName%.skse
					DeleteMeBAK = %DelName%.bak
					j:= i / FileCount
					Progress,%j% ; 
					FileRecycle, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\%DeleteMe%
					; Delete the SKSE with the same name
					FileRecycle, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\%DeleteMeSKSE%
					FileRecycle, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\%DeleteMeBAK%
				}
				i+=1
			}
			Progress, Off
			GoSub subUpdateStatusBar
		} ;msgbox
	}
	FileRecycle, %Folder%\*.bak
	FileRecycle, %Folder%\*.tmp
	
	;subCleanUpSG
	Return
}

;-------------------
subLoadFile:
{
	FileRead, MyText, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\Description.txt
	GuiControl,, Description, %MyText%
	return
}

;-------------------
subClearFile:
{
	FileRecycle, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\Description.txt
	GuiControl,, Description, 
	return
}

;-------------------
subUpdateStatusBar:
{
	Gui, 1:Default
	SetFormat, IntegerFast, D
	;GuiControl,, StatusBar, Chargement ... 
	GoSub doCountSavegames
	GoSub doGetExistingPlayTime
	
	sFile =%ACTIVESGCOUNT% %localestr64%
	sSize =%ACTIVESGSIZE% %localestr65%
	sPT   =%localestr66% %ACTIVESAFEGAMETIME% 
	
	SB_SetParts(16,100,80,140)
	SB_SetIcon("source\TESVSGM.ico", 1, 1)
	SB_SetText(A_Tab A_Tab sFile,2)
	SB_SetText(A_Tab A_Tab sSize,3)
	SB_SetText(A_Tab A_Tab sPT,4)
	
	Return ;subUpdateStatusBar
}

;-----------------------
subActivateProfile:
{
	;If no profile then the profile is: Standard
	if ACTIVE =
	{
		ACTIVE = Standard
	}
	
	;If custom Ini file is not set then use the Skyrim.ini
	if ACTIVEINIFILE =
	{
		INIFileToUse = %SAVEGAMESFOLDER%\Skyrim.ini
	} else {
		INIFileToUse = %ACTIVEINIFILE%
	}
	
	;only when profile folder exists
	IfExist, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%
	{		
		;activate profile
		;check if INI is readonly
		FileGetAttrib, Attribute, %INIFileToUse%
		IfInString, Attribute, R
		;remove the attribute
		FileSetAttrib, -R+A, %INIFileToUse%
		
		IniWrite, %PROFILESSUBFOLDER%\%ACTIVE%\, %INIFileToUse%, General, SLocalSavePath
		
		;make ini readonly again
		FileSetAttrib, +R+A, %INIFileToUse%
	}
	else
	{
		ACTIVE=Standard
	}
	
	if ACTIVE = Standard
	{
		;activate standard profile
		;check if INI is readonly
		FileGetAttrib, Attribute, %SAVEGAMESFOLDER%\Skyrim.INI
		IfInString, Attribute, R
		;remove the attribute
		FileSetAttrib, -R+A, %SAVEGAMESFOLDER%\Skyrim.INI
		
		IniWrite, Saves\, %SAVEGAMESFOLDER%\Skyrim.INI, General, SLocalSavePath
		
		;make ini readonly again
		FileSetAttrib, +R+A, %SAVEGAMESFOLDER%\Skyrim.INI
	}
	
	;subActivateProfile
	Return
}

;--------------------------
subLaunchNexusSkyrim:
{
	Run, http://www.nexusmods.com/skyrim/mods/82747/
	Return
}

;-------------------
subLaunchNexusSkyrimSE:
{
	Run, http://www.nexusmods.com/skyrimspecialedition/mods/8980/?
	Return
}

;-----------------
doBackupProfile:
{
	strPath=
	if BACKUPATH=
	{
		MsgBox, 8208, %localestr48%, %localestr67%
		return
	}
	
	if PROFILETOBACKUP!=
	{
		Progress, w200 A B2 WM400 FS10 ,%PROFILETOBACKUP%,%localestr68%,
		if PROFILETOBACKUP=Standard
		{
			strPath = %SAVEGAMESFOLDER%\Saves
		}
		else
		{
			strPath = %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%PROFILETOBACKUP%
		}
		
		FileCount = 0
		Loop, %strPath%\*.*,0,1
		{
			FileCount += 1 
		}
		
		IfNotExist %BACKUPATH%\%PROFILETOBACKUP%
		{
			FileCreateDir %BACKUPATH%\%PROFILETOBACKUP%
		}
		
		Loop, %strPath%\*.*,0,1
		{
			j = % floor((A_Index / FileCount) * 100)
			Progress,%j% 
			
			TempFile := A_LoopFileName
			TempTime := A_LoopFileTimeModified
			
			IfExist, %BACKUPATH%\%PROFILETOBACKUP%\%TempFile%
			{
				FileGetTime, TargetFileDate , %BACKUPATH%\%PROFILETOBACKUP%\%TempFile%, M
				EnvSub, TempTime, %TargetFileDate%, Seconds
				
				SplitPath, TempFile, ,,,MoveName
				MeSKSE = %MoveName%.skse
				
				IfGreater,  TempTime, 0
				{
					FileCopy, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%PROFILETOBACKUP%\%A_LoopFileName%, %BACKUPATH%\%PROFILETOBACKUP%, 1	
					FileCopy, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%PROFILETOBACKUP%\%MeSKSE%, %BACKUPATH%\%PROFILETOBACKUP%, 1						
				} else {
				}
			} else {
				FileCopy, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%PROFILETOBACKUP%\%A_LoopFileName%, %BACKUPATH%\%PROFILETOBACKUP%, 1
				FileCopy, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%PROFILETOBACKUP%\%MeSKSE%, %BACKUPATH%\%PROFILETOBACKUP%, 1			
			}
		}
		Progress, Off
	}
	
	;doBackupProfile
	Return  
}

;-------------------
subGetSaveGameInfo:
{
	Folder = %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%
	Time := 0
	File := 
	
	Loop %Folder%\*.ess
	{
		If ( A_LoopFileTimeModified >= Time )
		{
			Time := A_LoopFileTimeModified
			File := A_LoopFileName
		}
	}
	rc := doGetSaveGameInfo(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE,File, true)
	IniRead,ACTIVEDIFFICULTY,%SAVEGAMESFOLDER%\SkyrimPrefs.ini,GamePlay,iDifficulty
	
	If ACTIVEDIFFICULTY = 0
	{	Difficulty = %localestr69%
	}Else If ACTIVEDIFFICULTY = 1
	{	Difficulty = %localestr70%
	}Else If ACTIVEDIFFICULTY = 2
	{	Difficulty = %localestr71%
	}Else If ACTIVEDIFFICULTY = 3
	{	Difficulty = %localestr72%
	}Else If ACTIVEDIFFICULTY = 4
	{	Difficulty = %localestr73%
	}Else If ACTIVEDIFFICULTY = 5
	{	Difficulty = %localestr74%
	}


	Gui, Submit, NoHide
	GuiControl,, Place,%ACTIVELOCATION%
	StringReplace, ACTIVEPLAYTIME, ACTIVEPLAYTIME, . , :, All
	GuiControl,, PlayTime,%ACTIVEPLAYTIME% ; (hh`:mm`:ss)
	If Active = Standard
	{
		GuiControl,, Level, %A_Space%
		GuiControl,, Diffy, %A_Space%
		GuiControl,, Race, %A_Space%
	}
	else
	{
		GuiControl,, Level, %ACTIVELEVEL%
		GuiControl,, Diffy, %Difficulty%
		GuiControl,, Race, %ACTIVERACE% / %ACTIVEGENDER%
	}


	return 
}


doGetSavegameInfo( in_strProfilefolder, in_strProfilesub, in_strActiveProfile, in_strFileName, in_bolPicture)
{
	global ACTIVELOCATION
	global ACTIVELEVEL
	global ACTIVEPLAYTIME
	global ACTIVENAME
	global ACTIVEPT
	global ACTIVERACE
	global ACTIVEGENDER
	global localestr75
	global localestr76
	
	VarSetCapacity(ACTIVERACE,300)
	FILE_CURRENT = 1
	
	ScreenShotfilePPM = %in_strProfilefolder%\%in_strProfilesub%\%in_strActiveProfile%\Screenshot.ppm
	ScreenShotfileJPG = %in_strProfilefolder%\%in_strProfilesub%\%in_strActiveProfile%\Screenshot.jpg
	SSConverter=ffmpeg.exe
	SSConverterParameter1= -i 
	
	if (!in_strActiveProfile) {
		savefile = %in_strProfilefolder%\%in_strProfilesub%\%in_strFileName%
	} else {
		savefile = %in_strProfilefolder%\%in_strProfilesub%\%in_strActiveProfile%\%in_strFileName%
	}
	SaveFile := OpenFileForRead(savefile)
	Offset := 0x11
	
	ReadFromFile(SaveFile,VersionBin,1,FILE_BEGIN, Offset)  ; Savefile Version
	Bin2Hex(VersionHex,VersionBin,1)
	Version = 0x%VersionHex%
	
	if (Version = 0x0C)
	{
		SKYRIMSE:=1
	} else {
		SKYRIMSE:=0
	}
	
	Offset := 0x19
	
	ReadFromFile(SaveFile,LenNameBin,1,FILE_BEGIN, Offset)  ; Length of Name
	Bin2Hex(LenNameHex,LenNameBin,1)
	NameLen = 0x%LenNameHex%
	Offset := Offset + 0x02
	ReadFromFile(SaveFile,Name,NameLen,FILE_BEGIN, Offset)           ; Name
	ACTIVENAME := Name
	
	Offset := Offset + NameLen
	ReadFromFile(SaveFile,LevelBin,1,FILE_BEGIN, Offset)                      ; Level
	Offset := Offset + 0x02
	Bin2Hex(LevelHex,LevelBin,1)
	LevelHex = 0x%LevelHex%
	SetFormat, Integer, D
	ACTIVELEVEL := LevelHex + 0
	
	Offset := Offset + 0x02                        ; empty
	
	ReadFromFile(SaveFile,LenLocationBin,1,FILE_BEGIN, Offset)	              ; Length of Location
	Offset := Offset + 0x02
	
	Bin2Hex(LenLocationHex,LenLocationBin,1)
	LenLocation = 0x%LenLocationHex%
	
	ReadFromFile(SaveFile,Location,LenLocation,FILE_BEGIN, Offset)      ; Location
	ACTIVELOCATION := Location
	Offset := Offset + LenLocation
	
	ReadFromFile(SaveFile,LenPlayTimeBin,1,FILE_BEGIN, Offset)	              ; Length of PlayTime
	Offset := Offset + 0x02
	Bin2Hex(LenPlayTimeHex,LenPlayTimeBin,1)
	LenPlayTime = 0x%LenPlayTimeHex%
	
	ReadFromFile(SaveFile,PlayTime,LenPlayTime,FILE_BEGIN, Offset)      ; PlayTime
	Offset := Offset + LenPlayTime
	ACTIVEPLAYTIME := PlayTime
	StringSplit, PT, PlayTime,`.
	
	ACTIVEPT = %PT1%%PT2%%PT3%
	
	ReadFromFile(SaveFile,LenRaceBin,1,FILE_BEGIN, Offset)	              ; Length of Race
	Offset := Offset + 0x02
	Bin2Hex(LenRaceHex,LenRaceBin,1)
	LenRace = 0x%LenRaceHex%
	
	ReadFromFile(SaveFile,Race,LenRace,FILE_BEGIN, Offset)      ; Race
	Offset := Offset + LenRace
	StringReplace,ACTIVERACE,Race,Race
	
	ReadFromFile(SaveFile,GenderBin,1,FILE_BEGIN, Offset)	              ; Length of Race
	Bin2Hex(GenderHex,GenderBin,1)
	
	if (GenderHex = 00) { 
		ACTIVEGENDER = %localestr75%
	} else {
		ACTIVEGENDER = %localestr76%
	}
	
	Offset := Offset + 16 + 2
	ReadFromFile(SaveFile,SSW,2,FILE_BEGIN, Offset)
	Offset := Offset + 4
	ReadFromFile(SaveFile,SSH,2,FILE_BEGIN, Offset)
	Offset := Offset + 4
	
	
	if (in_bolPicture)
	{
		
		PPMFile := FileOpen(ScreenShotFilePPM, "rw") 
		PPMFile.WriteLine("P6 320 192 255 ")
		
		if (SKYRIMSE = 0) 
		{
			SSConverterParameter2= -y -vf eq=1.3:0.15:2:1:1:1:1:1
			Loop, 192
			{
				rc := ReadFromFile(SaveFile,LineOfBytes,960,-1,0 )
				PPMFile.RawWrite(LineOfBytes,960)    ;960
			}
		} else {
			SSConverterParameter2= -y -vf hue=h=-128 
			;eq=1.3:0.15:2:1:1:1:1:1
			Loop, 192
			{
				rc := ReadFromFile(SaveFile,LineOfBytes,1280,-1,0 )
				i:=0
				Loop, 320
				{
					of:=i*4
					Pixels:=substrBuf( &LineOfBytes+of, 4 )
					PPMFile.RawWrite(Pixels,3)    ;960
					i+=1
				}
			}
		}
		
		PPMFile.Close()
		
		
		IfExist, %ScreenShotFilePPM%
		{
			RunWait,%SSConverter% %SSConverterParameter1% "%ScreenShotFilePPM%" %SSConverterParameter2% "%ScreenShotFileJPG%" ,%in_strProfilefolder%\%in_strProfilesub%\%in_strActiveProfile%,hide
			FileRecycle, %ScreenShotFilePPM%
		}
	}
	CloseFile(SaveFile)
	return
}

debugPrint(strText)
{
	FileAppend  %strText%`n, *
	return 
}

;-------------------
doGetExistingPlayTime:
{
	Folder = %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\
	
	OldestFile =
	NewestFile =
	OldestTime =99999999999999
	NewestTime =00000000000000
	Loop, %Folder%\*.ess
	{
		TempFile := A_LoopFileName 
		TempTime := A_LoopFileTimeModified
		
		IfGreater, TempTime, %NewestTime%
		{
			NewestTime = %TempTime%
			NewestFile = %TempFile%
		}
		ifLess, TempTime, %OldestTime%
		{
			OldestTime = %TempTime%
			OldestFile = %TempFile%
		}
	}
	
	rc := doGetSaveGameInfo(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE,OldestFile, false)
	OldestPT := ACTIVEPT
	
	rc := doGetSaveGameInfo(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE,NewestFile, false)
	NewestPT := ACTIVEPT
	
	maxHours := SubStr(NewestPT,1,3)
	maxMin   := SubStr(NewestPT,4,2)
	maxSec   := SubStr(NewestPT,6,2)
	
	minHours := SubStr(OldestPT,1,3)
	minMin   := SubStr(OldestPT,4,2)
	minSec   := SubStr(OldestPT,6,2)
	
	edgeSec   := maxSec - MinSec
	edgeMin   := maxMin - MinMin
	edgeHours := maxHours - MinHours
	
	if (edgeSec < 0 ) {
		edgeSec := 60 + edgeSec
		edgeMin := edgeMin - 1
	}	
	if (edgeMin < 0 ) {
		edgeMin := 60 + edgeMin
		edgeHours := edgeHours - 1
	}
	if (edgeHours < 0 ) {
		edgeHours := 24 + edgeHours
		edgeDays := edgeDays - 1
	}
	
	edgeSec = 00%edgeSec%
	edgeSec := SubStr(edgeSec,-1,2)
	
	edgeMin = 00%edgeMin%
	edgeMin := SubStr(edgeMin,-1,2)
	
	edgeHours = 0%edgeHours%
	if ( edgeHours = 0 ) { 
		edgeHours = 00 
	}
	edgeHours := SubStr(edgeHours,-2,3)
	
	ACTIVESAFEGAMETIME = %edgeHours%:%edgeMin%:%edgeSec%
	return
}

;-------------------
doGetExistingPlayTime_old:
{
	Folder = %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\
	Files := Object()
	FileCount := 0
	
	Loop %Folder%\*.ess
	{
		rc := doGetSaveGameInfo(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE,A_LoopFileName, false)
		Files[A_Index,1] := ACTIVEPT   ; Playtime
		Files[A_Index,2] := A_LoopFileName
		FileCount += 1
	}
	
	hasChanged = 1
	FileCount := % Files.Length()
	While (hasChanged) {
		hasChanged = 0
		loop, %FileCount% {
			i := A_Index
			j := i + 1
			if (Files[i,1] < Files[j,1]) {
				tmp1 := Files[i,1]
				tmp2 := Files[i,2]
				Files[i,1] := Files[j,1]
				Files[i,2] := Files[j,2]
				Files[j,1] := tmp1
				Files[j,2] := tmp2
				hasChanged = 1
			}
		}    
	}
	
	maxHours := SubStr(Files[1,1],1,3)
	maxMin   := SubStr(Files[1,1],4,2)
	maxSec   := SubStr(Files[1,1],6,2)
	
	minHours := SubStr(Files[FileCount,1],1,3)
	minMin   := SubStr(Files[FileCount,1],4,2)
	minSec   := SubStr(Files[FileCount,1],6,2)
	
	edgeSec   := maxSec - MinSec
	edgeMin   := maxMin - MinMin
	edgeHours := maxHours - MinHours
	
	if (edgeSec < 0 ) {
		edgeSec := 60 + edgeSec
		edgeMin := edgeMin - 1
	}	
	if (edgeMin < 0 ) {
		edgeMin := 60 + edgeMin
		edgeHours := edgeHours - 1
	}
	if (edgeHours < 0 ) {
		edgeHours := 24 + edgeHours
		edgeDays := edgeDays - 1
	}
	
	edgeSec = 00%edgeSec%
	edgeSec := SubStr(edgeSec,-1,2)
	
	edgeMin = 00%edgeMin%
	edgeMin := SubStr(edgeMin,-1,2)
	
	;edgeHours = 000%edgeHours%	
	;edgeHours := SubStr(edgeHours,-2,3)
	
	ACTIVESAFEGAMETIME = %edgeHours%:%edgeMin%:%edgeSec%
	return
}


;-----------------
doUpdateProfileDDL( in_strSavegamefolder, in_strSubfolder, in_strPreSelect)
{
	
	;check if profile for preselection exists
	if (in_strPreSelect != Standard)
	{
		IfNotExist, %in_strSavegamefolder%\%in_strSubfolder%\%in_strPreSelect%
		{
			in_strPreSelect = Standard
		}
	}
	
	;clear the dropdownlist
	GuiControl,, ddlCharacter, |
	
	;add Standard to combobox
	if in_strPreSelect = Standard
	{
		;pre-select
		GuiControl,, ddlCharacter, Standard||
	}
	else
	{
		GuiControl,, ddlCharacter, Standard|
	}
	
	;scan all folders and add to combobox
	Loop, %in_strSavegamefolder%\%in_strSubfolder%\*.,2,0
	{
		lstProfilenames = %lstProfilenames%%A_LoopFileName%`n
		if A_LoopFileName = %in_strPreSelect%
		{
			;pre-select
			GuiControl,, ddlCharacter, %A_LoopFileName%||
		}
		else
		{
			GuiControl,, ddlCharacter, %A_LoopFileName%|
		}
	}
	
	Gosub guiDropdownProfile
	
	;update GUI
	Gui, Show	
	
	Return lstProfilenames
} ;doUpdateProfileDDL

;-----------------
doCountSavegames:
{
	iCount = 0
	iSize = 0
	
	if ACTIVE!=
	{
		if ACTIVE=Standard
		{
			strPath = %SAVEGAMESFOLDER%\Saves
		}
		
		else
		{
			strPath = %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%
		}
		
		Loop, %strPath%\*.ess,0,1
		{
			iCount := A_Index
			iSize += %A_LoopFileSize%
		}
	}
	
	ACTIVESGSIZE := floor(iSize / 1024 / 1024)
	ACTIVESGCOUNT = %iCount%
	
	;doCountSavegames
	Return  
}

Hex2ASCII(fHexString)
{
	Loop, Parse, fHexString
	{
		Chunk := substr(fHexString,(A_Index * 2) - 1,2)
		SetFormat, Integer, D
		HexString +=0
		SetFormat, Integer, H
		Tmp1=% Chr("0x" Chunk)
		ConvString .= Tmp1
	;MsgBox %ASCIIString%
	}
	Return ConvString
}

subPickRandomPic() ;Unused
{
	FileCount = 0
	Loop, %A_WorkingDir%\*.jpg 
	{
		FileCount = %A_Index% 
	}
	
	Random r, 1, FileCount
	Loop, %A_WorkingDir%\*.jpg 
	{
		if (A_Index=r)
		{
			rndFileName := A_LoopFileFullPath
			break
		}
	}
	return rndFileName
}

;-------------------
subBackupActiveProfile:
{
	;profile = Standard
	If ACTIVE = Standard
	{
		;folderselect OK
		if BACKUPATH!= 
		{	
			Progress, A B2 w200,, %localestr77%, %localestr78%
			Progress, 50 ; Set bar position to 50%.
			FileCopyDir, %SAVEGAMESFOLDER%\Saves, %BACKUPATH%\Standard, 1
			Progress, Off
		}
		else
		{
			MsgBox, 8208, %localestr48%, %localestr67%
		}
		Return
	}
	
	;profile folder not found
	IfNotExist, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%
	{
		MsgBox, 8208, %localestr48%, %localestr79%`n (%SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%)
		return
	}
	
	;if profile folder exists
	Else 
	{
		PROFILETOBACKUP = %ACTIVE%
		gosub doBackupProfile
	}
	Return
}

;subroutines for TESVSGM gui

;-------------------
submenuSGHandler:
{
	If A_ThisMenuItem = %localestr3% ;Create a new profile
	{
		InputBox, strNewProfileName, %localestr3%, %localestr80%
		
			;user click OK
		If (ErrorLevel = 0 AND strNewProfileName!= )
		{
			;abort if profile exist already
			IfExist %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%strNewProfileName%
			{
				MsgBox, 0, %localestr48%, %localestr81%
			}
			Else
			{
				if (PROFILEFORNEWGAME != "") {
					FileCopyDir, %PROFILEFORNEWGAME%, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%strNewProfileName%
				} else {
					FileCreateDir %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%strNewProfileName%
				}
				
				ACTIVE=%strNewProfileName%
				doUpdateProfileDDL(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE)
			}
		}
	}
	
	Else If A_ThisMenuItem = %localestr6% ;Backup current profile
	{	GoSub subBackupActiveProfile
}

Else If A_ThisMenuItem = %localestr7% ;Backup all profiles
{
	if BACKUPATH!= 
	{
		PROFILETOBACKUP = Standard
		gosub doBackupProfile	
		
						;scan all folders 
		Loop, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\*.,2,0
		{
			PROFILETOBACKUP = %A_LoopFileName%
			gosub doBackupProfile
		}
	}
}

Else If A_ThisMenuItem = %localestr8% ;Open the backup folder
{
	IfExist, %BACKUPATH%
	{
		Run, "%BACKUPATH%"
	}
	else
	{
		If BACKUPATH !=
		{
			MsgBox, 8208, %localestr48%, %BACKUPATH% %localestr82%
		}
		else
		{
			MsgBox, 8208, %localestr48%, %BACKUPATH% %localestr67%
		}
	}
}

Else If A_ThisMenuItem = %localestr5% ;Delete current profile
{
	gosub subShowDeleteProfile
}	

Else If A_ThisMenuItem = %localestr4% ;Scan for new profiles
{
	MsgBox, 8256, %localestr4%, %localestr83%
	gosub subScanForNewProfiles
	
			;Activate Standard profile
	ACTIVE  = Standard
	gosub subActivateProfile
	doUpdateProfileDDL(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE)
}

Else If A_ThisMenuItem = %localestr9% ;Open the Skyrim saves folder
{
	IfExist, %SAVEGAMESFOLDER%
	{
		Run, "%SAVEGAMESFOLDER%\Saves"
	} else {
		MsgBox, 8208, %localestr48%, %localestr84%
	}
}

Else If A_ThisMenuItem = %localestr10% ;Open the folder of the current profile
{
	IfExist, %SAVEGAMESFOLDER%
	{
		IfExist, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%
		{
			Run, "%SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%"
		}
		
		Else
		{
			Run, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\
		}
	} else {
		MsgBox, 8208, %localestr48%, %localestr84%
	}
}


	;submenuSGHandler
Return
}

;-------------------
submenuHELPHandler:
{
	If A_ThisMenuItem =  %localestr11% ;Help
	{
		Run, %A_WorkingDir%\help\TESVSGMReadMe_%LOCALEUSED%.txt
	}
	
	Else If A_ThisMenuItem = %localestr14% ;About
	{
		MsgBox, 8256, %localestr85%, Skyrim Savegame Manager`n%localestr86% %myVERSION%`n`n%localestr87%: RedawgTS, Askedal & StarcomFr (aka Starcom)`n%localestr88%: digitalfun %localestr89% Schattenfell`n`n%localestr90%: `nhttp://www.nexusmods.com/`n`n%localestr91%`n%localestr92%: %LOCALENAME%
	}
	
	Else If A_ThisMenuItem = %localestr93% ;www.nexusmods.com/skyrim
	{
		GoSub subLaunchNexusSkyrim 
	}
	
	Else If A_ThisMenuItem = %localestr94% ;www.nexusmods.com/skyrimse
	{
		GoSub subLaunchNexusSkyrimSE 
	}

	;submenuHELPHandler
	Return
}


;------------------
submenuTrayHandler:
{
	If A_ThisMenuItem = %localestr18% ;Run the game
	{
		gosub subRunSkyrim
	}
	
	Else If A_ThisMenuItem = %localestr19% ;Open the TESVSGM window
	{
		Gui, Show
	}
	
	Else If A_ThisMenuItem = %localestr20% ;Exit
	{
		goto FinishApp
	}
	
	;submenuTrayHandler
	Return
}


;-------------------
guiDropdownProfile:
{
	Gui, Submit, NoHide
	
	strPicFilename=
	
	;activate selected profile
	If ddlCharacter != 
		ACTIVE := ddlCharacter
	
	GoSub subLoadIniFile        ; custom ini file
	GoSub subActivateProfile    ; saves active Profile to INI file
	GoSub subUpdateStatusBar    ; update count and size of SGs in status bar
	GoSub subLoadFile           ; Load description File
	GoSub subGetSaveGameInfo    ; update Location, Level etc.
	
	;show profile picture
	;if standard, use standard pic
	If ACTIVE = Standard 
	{
		strPicFilename = standard.jpg
	}	
	
	;else scan profile folder for bmp
	else 
	{
		Loop, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\*.jpg, 0, 1 
		{
			If A_LoopFileName != 
			{
				strPicFilename=%SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\%A_LoopFileName%
				Break
			}
		}
	}
	
	IfExist %strPicFilename%
	{
	;set picture control
		GuiControl, 1:,pic, %strPicFilename%
	} else {
		GuiControl, 1:,pic, standard.jpg
	}
	
;guiDropdownProfile:
	Return
}

;-------------------
subLoadIniFile:
{
	;Load Custom INI file
	IfExist,  %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\IniFile.txt
	{
		FileRead, MyText, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\IniFile.txt
		GuiControl,, IniFile, %MyText%
		ACTIVEINIFILE=%MyText%
	} else {
		GuiControl,, IniFile,
		ACTIVEINIFILE=
	}
	return
}

;-------------------
GuiDropFiles:
{
	; Extract filename (only the first if multiple files were dropped)
	Loop, parse, A_GuiEvent, `n
	{
		strFilename = %A_LoopField%
		Break
	}
	
	;if strFilename is a JPG or BMP
	SplitPath, strFilename,,, strExt
	if (strExt = "JPG" OR strExt = "BMP")
	{
		if ACTIVE=
		{
		}
		
		else if ACTIVE=Standard
		{
			MsgBox, %localestr97%
		}
		
		else
		{
		;remove previous pic
			FileRecycle, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\*.jpg
			FileRecycle, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\*.bmp
			
		;copy the picture to the profilefolder	
			FileCopy, %strFilename%,  %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\%ACTIVE%.%strExt%
			
		;show the new pic
			gosub guiDropdownProfile
		}
		
		
	}
	
	;GuiDropFiles
	Return
}



;-------------------
subOptions:
{
	lDays := SubStr(SAVEGAMESHOURS,1,2)	
	lHours := SubStr(SAVEGAMESHOURS,3,2)
	lMinutes := SubStr(SAVEGAMESHOURS,5,2)
	
	Gui, MyGui:New
	Gui, MyGui:+Owner	
	
	Gui, Add, Tab2, x10 y10 w320 h185 vTabOptions, %localestr98%|%localestr99%|%localestr100%|%localestr101%
	
	Gui, Tab, 1
	Gui, MyGui:Add, GroupBox, x15 y40 w305 h140 vGroupSettings, %localestr102%
	Gui, MyGui:Add, Radio, x20 y55 w150 h30 gRadioHandler vRadio1  , %localestr103%
	Gui, MyGui:Add, Text, x227 y63 w100 h20 vLabelFiles , %localestr104%
	Gui, MyGui:Add, Radio, x20 y88 w300 h30 gRadioHandler vRadio2  , %localestr105%
	;SavegameCounts
	Gui, MyGui:Add, Edit, x170 y58 w50 h20 Number vOptSaveGameCounts, %SAVEGAMESCOUNTS%	
	Gui, Add, UpDown, vMeinUpDown Range1-99, %SAVEGAMESCOUNTS%	
	;SaveHours
	Gui, MyGui:Add, Edit, x20 y125 w40 h20 Number vOptGameDays, %lDays%	
	Gui, Add, UpDown, vMyDays Range0-99, %lDays%
	Gui, MyGui:Add, Text, x65 y128 w40 h20 vLabelOptGameDays, %localestr106%	
	
	Gui, MyGui:Add, Edit, x110 y125 w40 h20 Number vOptGameHours, %lHours%
	Gui, Add, UpDown, vMyHours Range0-23, %lHours%
	Gui, MyGui:Add, Text, x155 y128 w40 h20 vLabelOptGameHours, %localestr107%	
	
	Gui, MyGui:Add, Edit, x215 y125 w40 h20 Number vOptGameMinutes, %lMinutes%	
	Gui, Add, UpDown, vMyMin Range0-59, %lMinutes%
	Gui, MyGui:Add, Text, x260 y128 w40 h20 vLabelOptGameMinutes, %localestr108%
	
	Gui, MyGui:Add, Text, x20 y155 w105 h20 vLabelSaveGameKeep, %localestr109%
	Gui, MyGui:Add, Edit, x130 y152 w50 h20 Number vOptSaveGameKeep %SAVEGAMESKEEP%	
	Gui, Add, UpDown, vMeinKeep Range1-99, %SAVEGAMESKEEP%	
	Gui, MyGui:Add, Text, x188 y155 w100 h20 vLabelFilesMin, %localestr104%
	
	Gui, Tab, 3
	Gui, MyGui:Add, Text, x18 y40 w270 h20 vLabelOptPlayButton, %localestr110%
	Gui, MyGui:Add, Edit, x18 y60 w270 h20 vOptPlayButton, %PLAYBUTTONLINK%
	Gui, MyGui:Add, Button, x290 y60 w20 h20 gsubGetExeFile, ..
	
	Gui, MyGui:Add, Text, x18 y90 w270 h20 vLabelOptPlayButtonParam, %localestr111%
	Gui, MyGui:Add, Edit, x18 y110 w270 h20 vOptPlayButtonParam, %PLAYBUTTONPARAM%
	
	Gui, MyGui:Add, Text, x15 y145 w155 h15 vLabelddlLanguage, %localestr125%
	Gui, Add, DropDownList,  w305  vddlLanguage,
	
	
	Gui, Tab, 2
	Gui, MyGui:Add, Text, x18 y40 w270 h20 vLabelOptBackupPath, %localestr112%
	Gui, MyGui:Add, Edit, x18 y60 w270 h20 vOptBackupPath, %BACKUPATH%
	Gui, MyGui:Add, Button, x290 y60 w20 h20 gsubGetBackupDir, ..
	
	Gui, MyGui:Add, Checkbox, x18 y90 vOptAlwaysBackup, %localestr113%
	GuiControl, , OptAlwaysBackup , %ALWAYSBACKUP%
	
	Gui, MyGui:Add, Checkbox, x18 y110 vOptAlwaysCleanup, %localestr114%
	GuiControl, , OptAlwaysCleanup , %ALWAYSCLEANUP%
	
	Gui, Tab, 4
	Gui, MyGui:Add, Text, x18 y40 w270 vLabelOptNewGame, %localestr115%
	Gui, MyGui:Add, Edit, x18 y70 w270 h20 vOptNewGame Disabled, %PROFILEFORNEWGAME%
	Gui, MyGui:Add, Button, x290 y70 w20 h20 gsubGetProfileDir, ..
	
	Gui, Tab
	Gui, MyGui:Add, Button, x10  y200 w155 h40 gsubCancel vOptBtnCancel, %localestr116%
	Gui, MyGui:Add, Button, x175 y200 w155 h40 DEFAULT gdoSaveOptions vOptBtnOk, %localestr117%
	
	
	if ("" . SAVEGAMESTYPE = "" . "Files") {
		GuiControl, Enable, OptSaveGameCounts
		GuiControl, Disable, OptGameDays
		GuiControl, Disable, OptGameHours
		GuiControl, Disable, OptGameMinutes
		GuiControl, Disable, OptSaveGameKeep
		GuiControl,, Radio1, 1
		GuiControl,, Radio2, 0
	} else {
		GuiControl, Disable, OptSaveGameCounts
		GuiControl, Enable, OptGameDays
		GuiControl, Enable, OptGameHours
		GuiControl, Enable, OptGameMinutes
		GuiControl, Enable, OptSaveGameKeep
		GuiControl,, Radio1, 0
		GuiControl,, Radio2, 1
	}
	
	;Load avaible languages in the Language selector
	gosub, subScanLanguageFiles
	
	Gui, MyGui:Show,, Options
	
	Return
}

;-------------------
subGetProfileDir:
{
	FileSelectFolder, _folder,%SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%,,%localestr118%
	If ErrorLevel = 0
	{
		GuiControl,, OptNewGame, %_folder%
	}
	return
}

;-------------------
subGetExeFile:
{
	strSkyrimPath= %PLAYBUTTONLINK%
	If strSkyrimPath =
	{
		If SKYRIMSE = 0
		{
			strSkyrimPath=
			RegRead, strSkyrimPath, HKEY_LOCAL_MACHINE, Software\Wow6432Node\Bethesda Softworks\Skyrim, Installed Path
		}
		Else
		{
			strSkyrimPath=
			RegRead, strSkyrimPath, HKEY_LOCAL_MACHINE, Software\Wow6432Node\Bethesda Softworks\Skyrim Special Edition, Installed Path
		}

	}
	
	FileSelectFile, strRunfile,1,%strSkyrimPath%, %localestr119%, %localestr120% (*.exe;*.com;*.bat;*.cmd)
	If ErrorLevel = 0
	{
		GuiControl,, OptPlayButton, %strRunfile%
	}
	return
}

;-------------------
subGetBackupDir:
{
	FileSelectFolder, strFolder,3,%BACKUPATH%, %localestr121%
	If ErrorLevel = 0
	{
		GuiControl,, OptBackupPath, %strFolder%
	}
	return
}

;-------------------
subCancel:
{
	Gui, Cancel
	Return
}

;-------------------
RadioHandler:
{
	Gui, Submit, NoHide
	if (Radio1 = 1) {
		GuiControl, Enable, OptSaveGameCounts
		GuiControl, Disable, OptGameDays
		GuiControl, Disable, OptGameHours
		GuiControl, Disable, OptGameMinutes
		GuiControl, Disable, OptSaveGameKeep
	} else {
		GuiControl, Disable, OptSaveGameCounts
		GuiControl, Enable, OptGameDays
		GuiControl, Enable, OptGameHours
		GuiControl, Enable, OptGameMinutes
		GuiControl, Enable, OptSaveGameKeep
	}
	Return
}

;-------------------
doSaveOptions:
{
	Gui, Submit, NoHide
	GuiControlGet, OptPlayButton
	GuiControlGet, OptSaveGameCounts
	GuiControlGet, OptBackupPath
	GuiControlGet, OptGameDays
	GuiControlGet, OptGameHours
	GuiControlGet, OptGameMinutes
	GuiControlGet, OptAlwaysBackup
	GuiControlGet, OptAlwaysCleanup
	GuiControlGet, RadioGroup
	GuiControlGet, OptNewGame
	GuiControlGet, ddlLanguage
	
	
	PLAYBUTTONLINK    = %OptPlayButton%
	PLAYBUTTONPARAM   = %OptPlayButtonParam%
	SAVEGAMESCOUNTS   = %OptSaveGameCounts%
	SAVEGAMESKEEP     = %OptSaveGameKeep%
	BACKUPATH         = %OptBackupPath%
	ALWAYSBACKUP      = %OptAlwaysBackup%
	ALWAYSCLEANUP     = %OptAlwaysCleanup%
	PROFILEFORNEWGAME = %OptNewGame%
	LOCALEUSED        = %ddlLanguage%
	
	if (Radio1 = 1){
		SAVEGAMESTYPE = Files
	} else {
		SAVEGAMESTYPE = GamingHours
	}   
	
	
	lDays = 00%OptGameDays%
	lDays := SubStr(lDays,-1,2)
	
	lHours = 00%OptGameHours%	
	lHours := SubStr(lHours,-1,2)
	
	lMinutes = 00%OptGameMinutes%
	lMinutes := SubStr(lMinutes,-1,2)
	
	lResult = %lDays%%lHours%%lMinutes%
	
	SAVEGAMESHOURS  = %lResult%
	
	;Refresh locale strings
	gosub, subInitLocaleParameters
	
	Gui, Cancel
	
	; Refresh CleanUp button "on the fly "
	Gui, 1:Default
	if ALWAYSBACKUP = 1 
	{
		GuiControl , Text, BtnCleanUp, %localestr95% && %localestr96%
	} else {
		GuiControl , Text, BtnCleanUp, %localestr38%
	}
	return
}

;-------------------
subShowDeleteProfile:
{
	MsgBox, 276, %localestr122%, %localestr123%
	
	IfMsgBox Yes
	{
		FileRemoveDir, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\, 1
		MsgBox, 276, %localestr122%, %localestr124%
		IfMsgBox Yes
		{
			FileRemoveDir,%BACKUPATH%\%ACTIVE%\, 1
		}
		ACTIVE=Standard
		doUpdateProfileDDL(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE)
	}
	
	return
}

;-------------------
subGetLocaleName:
{
	languageCode_0436 := "Afrikaans"
	languageCode_041c := "Albanian"
	languageCode_0401 := "Arabic_Saudi_Arabia"
	languageCode_0801 := "Arabic_Iraq"
	languageCode_0c01 := "Arabic_Egypt"
	languageCode_1001 := "Arabic_Libya"
	languageCode_1401 := "Arabic_Algeria"
	languageCode_1801 := "Arabic_Morocco"
	languageCode_1c01 := "Arabic_Tunisia"
	languageCode_2001 := "Arabic_Oman"
	languageCode_2401 := "Arabic_Yemen"
	languageCode_2801 := "Arabic_Syria"
	languageCode_2c01 := "Arabic_Jordan"
	languageCode_3001 := "Arabic_Lebanon"
	languageCode_3401 := "Arabic_Kuwait"
	languageCode_3801 := "Arabic_UAE"
	languageCode_3c01 := "Arabic_Bahrain"
	languageCode_4001 := "Arabic_Qatar"
	languageCode_042b := "Armenian"
	languageCode_042c := "Azeri_Latin"
	languageCode_082c := "Azeri_Cyrillic"
	languageCode_042d := "Basque"
	languageCode_0423 := "Belarusian"
	languageCode_0402 := "Bulgarian"
	languageCode_0403 := "Catalan"
	languageCode_0404 := "Chinese_Taiwan"
	languageCode_0804 := "Chinese_PRC"
	languageCode_0c04 := "Chinese_Hong_Kong"
	languageCode_1004 := "Chinese_Singapore"
	languageCode_1404 := "Chinese_Macau"
	languageCode_041a := "Croatian"
	languageCode_0405 := "Czech"
	languageCode_0406 := "Danish"
	languageCode_0413 := "Dutch_Standard"
	languageCode_0813 := "Dutch_Belgian"
	languageCode_0409 := "English_United_States"
	languageCode_0809 := "English_United_Kingdom"
	languageCode_0c09 := "English_Australian"
	languageCode_1009 := "English_Canadian"
	languageCode_1409 := "English_New_Zealand"
	languageCode_1809 := "English_Irish"
	languageCode_1c09 := "English_South_Africa"
	languageCode_2009 := "English_Jamaica"
	languageCode_2409 := "English_Caribbean"
	languageCode_2809 := "English_Belize"
	languageCode_2c09 := "English_Trinidad"
	languageCode_3009 := "English_Zimbabwe"
	languageCode_3409 := "English_Philippines"
	languageCode_0425 := "Estonian"
	languageCode_0438 := "Faeroese"
	languageCode_0429 := "Farsi"
	languageCode_040b := "Finnish"
	languageCode_040c := "French_Standard"
	languageCode_080c := "French_Belgian"
	languageCode_0c0c := "French_Canadian"
	languageCode_100c := "French_Swiss"
	languageCode_140c := "French_Luxembourg"
	languageCode_180c := "French_Monaco"
	languageCode_0437 := "Georgian"
	languageCode_0407 := "German_Standard"
	languageCode_0807 := "German_Swiss"
	languageCode_0c07 := "German_Austrian"
	languageCode_1007 := "German_Luxembourg"
	languageCode_1407 := "German_Liechtenstein"
	languageCode_0408 := "Greek"
	languageCode_040d := "Hebrew"
	languageCode_0439 := "Hindi"
	languageCode_040e := "Hungarian"
	languageCode_040f := "Icelandic"
	languageCode_0421 := "Indonesian"
	languageCode_0410 := "Italian_Standard"
	languageCode_0810 := "Italian_Swiss"
	languageCode_0411 := "Japanese"
	languageCode_043f := "Kazakh"
	languageCode_0457 := "Konkani"
	languageCode_0412 := "Korean"
	languageCode_0426 := "Latvian"
	languageCode_0427 := "Lithuanian"
	languageCode_042f := "Macedonian"
	languageCode_043e := "Malay_Malaysia"
	languageCode_083e := "Malay_Brunei_Darussalam"
	languageCode_044e := "Marathi"
	languageCode_0414 := "Norwegian_Bokmal"
	languageCode_0814 := "Norwegian_Nynorsk"
	languageCode_0415 := "Polish"
	languageCode_0416 := "Portuguese_Brazilian"
	languageCode_0816 := "Portuguese_Standard"
	languageCode_0418 := "Romanian"
	languageCode_0419 := "Russian"
	languageCode_044f := "Sanskrit"
	languageCode_081a := "Serbian_Latin"
	languageCode_0c1a := "Serbian_Cyrillic"
	languageCode_041b := "Slovak"
	languageCode_0424 := "Slovenian"
	languageCode_040a := "Spanish_Traditional_Sort"
	languageCode_080a := "Spanish_Mexican"
	languageCode_0c0a := "Spanish_Modern_Sort"
	languageCode_100a := "Spanish_Guatemala"
	languageCode_140a := "Spanish_Costa_Rica"
	languageCode_180a := "Spanish_Panama"
	languageCode_1c0a := "Spanish_Dominican_Republic"
	languageCode_200a := "Spanish_Venezuela"
	languageCode_240a := "Spanish_Colombia"
	languageCode_280a := "Spanish_Peru"
	languageCode_2c0a := "Spanish_Argentina"
	languageCode_300a := "Spanish_Ecuador"
	languageCode_340a := "Spanish_Chile"
	languageCode_380a := "Spanish_Uruguay"
	languageCode_3c0a := "Spanish_Paraguay"
	languageCode_400a := "Spanish_Bolivia"
	languageCode_440a := "Spanish_El_Salvador"
	languageCode_480a := "Spanish_Honduras"
	languageCode_4c0a := "Spanish_Nicaragua"
	languageCode_500a := "Spanish_Puerto_Rico"
	languageCode_0441 := "Swahili"
	languageCode_041d := "Swedish"
	languageCode_081d := "Swedish_Finland"
	languageCode_0449 := "Tamil"
	languageCode_0444 := "Tatar"
	languageCode_041e := "Thai"
	languageCode_041f := "Turkish"
	languageCode_0422 := "Ukrainian"
	languageCode_0420 := "Urdu"
	languageCode_0443 := "Uzbek_Latin" 
	languageCode_0843 := "Uzbek_Cyrillic"
	languageCode_042a := "Vietnamese"
	
	LOCALENAME := languageCode_%A_Language%
	
	return
}

;-------------------
subInitLocaleParameters:
{
	LocaleFile =
	If (LOCALEUSED = "ERROR" or LOCALEUSED = "" or LOCALEUSED = )
	{
		LOCALEUSED = %LOCALENAME%
	}
	;If the selected language is not available then display an advertisement to explain the situation. The default English_United_States is useded
	IfNotExist, %A_WorkingDir%\locales\%LOCALEUSED%.lng
	{
		MsgBox,48,Attention!,Because your language (%LOCALENAME%) was not found in the directory:`n%A_WorkingDir%\locales`n`nthe default (English_United_States) language will be used.`n`nNotice it's easy to make your own language file.`nJust duplicate an existing .lng file from %A_WorkingDir%\locales then rename it into "%LOCALENAME%.lng", which is the right name for your actual system.`n`nThe last step is to edit this file using an UTF-8 BOM compatible editor and translate each strings.`n`nDone!`n`nAlso consider that you can post your final file in the TESVSGM thread on the Nexus mods forum for sharing it with community and get a chance to see it included in a next version. 
		LOCALEUSED=English_United_States 
	}
	
	LocaleFile := A_WorkingDir . "\locales\" . LOCALEUSED . ".lng"
	;Read all strings in the selected language file
	loop, Read, %LocaleFile%
	{
		localestr%A_Index% := A_LoopReadLine
		StringReplace, localestr%A_Index%, localestr%A_Index%, &crlf&, `n, All 
	}
	
	;If the GUI was already shown, we need to update it
	If IS_GUI_UPDATABLE = true 
	{
		gosub, subLocaleChange
	}
	
	;Save all actual menu Title to be able to modify them later
	SAVEOLDMENUNAMEFILE = %localestr15%
	SAVEOLDMENUNAMEPROFILE = %localestr16%
	SAVEOLDMENUNAMEHELP = %localestr17%
	
	return 
}

;-------------------
subScanLanguageFiles:
{
	GuiControl,MyGui:, ddlLanguage, |
	
	;scan all language files and add them to the dropdown list
	Loop, Files, %A_WorkingDir%\locales\*.lng, F
	{
		LanguageName := StrReplace(A_LoopFileName, ".lng")
		if LanguageName = %LOCALEUSED%
		{
			GuiControl,MyGui:, ddlLanguage, %LanguageName%||
		}
		else
		{
			GuiControl,MyGui:, ddlLanguage, %LanguageName%|
		}
	}
	return
}

;-------------------
subLocaleChange:
{
	
	;Menus (Beccause it's not displayed, remake completly the submenus of the menu bar)
	;File
	Gui, 1: Menu ;detach menu from the mainb GUI (1) to be able to change it (prevent from "already in use" errors with 1.1.22 compilator)
	Menu, subMenuSG, DeleteAll
	Menu, subMenuADV, DeleteAll
	Menu, subMenuHELP, DeleteAll
	
	Menu, subMenuSG, Add, Skyrim SE, subSwitchGame
	IF SKYRIMSE = 1
	{
		Menu, subMenuSG, Check, Skyrim SE
	}
	Else
	{
		Menu, subMenuSG, Uncheck, Skyrim SE
	}
	Menu, subMenuSG, Add, %localestr1%, subOptions
	Menu, subMenuSG, Add	;a line -----
	Menu, subMenuSG, Add, %localestr2%, subExit
	
	;Profile
	Menu, subMenuADV, Add, %localestr3%, submenuSGHandler
	Menu, subMenuADV, Add, %localestr4%, submenuSGHandler
	Menu, subMenuADV, Add	;a line -----
	Menu, subMenuADV, Add, %localestr5%, submenuSGHandler
	Menu, subMenuADV, Add	;a line -----
	Menu, subMenuADV, Add, %localestr6%, submenuSGHandler
	Menu, subMenuADV, Add, %localestr7%, submenuSGHandler
	Menu, subMenuADV, Add, %localestr8%, submenuSGHandler
	Menu, subMenuADV, Add	;a line -----
	Menu, subMenuADV, Add, %localestr9%, submenuSGHandler
	Menu, subMenuADV, Add, %localestr10%, submenuSGHandler
	
	;help
	Menu, subMenuHELP, Add, %localestr11%, submenuHELPHandler
	Menu, subMenuHELP, Add 	;a line -----
	Menu, subMenuHELP, Add, %localestr12%, submenuHELPHandler 
	Menu, subMenuHELP, Add, %localestr13%, submenuHELPHandler 
	Menu, subMenuHELP, Add 	;a line -----
	Menu, subMenuHELP, Add, %localestr14%, submenuHELPHandler
	
	;Rename menus in the menu bar
	debugPrint(%SAVEOLDMENUNAMEFILE%)
	Menu, menuMain, Rename, %SAVEOLDMENUNAMEFILE%, %localestr15%
	Menu, menuMain, Rename, %SAVEOLDMENUNAMEPROFILE%, %localestr16%
	Menu, menuMain, Rename, %SAVEOLDMENUNAMEHELP%, %localestr17%
	
	Gui, 1: Menu, menuMain ;Reattach the menu to the Main GUI (1)
	
	Menu, Tray, Add, %localestr18%, submenuTrayHandler
	Menu, Tray, Add		;a line ------ 
	Menu, Tray, Add, %localestr19%, submenuTrayHandler
	Menu, Tray, Add		;a line ------ 
	Menu, Tray, Add, %localestr20%, submenuTrayHandler
	
;-------------------------------------
;GUI window 1
;-------------------------------------
	GuiControl, 1:, SelectProfile, %localestr21%
	GuiControl, 1:, Play, %localestr22%
	GuiControl, 1:, Refresh, %localestr23%
	Gui, Submit, NoHide
	
	;Tabs
	GuiControl, 1:, MainTab, |
	GuiControl, 1:, MainTab, %localestr24%|%localestr25%|%localestr26%
	
	GuiControl, 1:, Screenshot, %localestr27%
	GuiControl, 1:, LabelPlayTime, %localestr28%:
	GuiControl, 1:, LabelLevel, %localestr29%:
	GuiControl, 1:, LabelRace, %localestr30%:
	GuiControl, 1:, LabelDiffy, %localestr31%:
	GuiControl, 1:, LabelPlace, %localestr32%:
	
	GuiControl, 1:, LabelDescription, %localestr33%
	GuiControl, 1:, ButtonSave, %localestr34%
	GuiControl, 1:, ButtonClear, %localestr35%
	
	GuiControl, 1:, CustomIni, %localestr36%
	GuiControl, 1:, ResetCustomIni, %localestr37% 
	
	;Main
	GuiControl, 1:, BtnCleanUp, %localestr38% 
	GuiControl, 1:, ButtonClose, %localestr39%
	
	gosub, subUpdateStatusBar
	Gui, MyGui:Default
;-------------------------------------
;GUI Options
;-------------------------------------
	GuiControl, MyGui:, TabOptions, |
	GuiControl, MyGui:, TabOptions, %localestr98%|%localestr99%|%localestr100%|%localestr101%
	GuiControl, MyGui:, GroupSettings, %localestr102%
	GuiControl, MyGui:, Radio1, %localestr103%
	GuiControl, MyGui:, LabelFiles, %localestr104%
	GuiControl, MyGui:, Radio2, %localestr105%
	GuiControl, MyGui:, LabelOptGameDays , %localestr106%	
	GuiControl, MyGui:, LabelOptGameHours, %localestr107%	
	GuiControl, MyGui:, LabelOptGameMinutes, %localestr108%	
	GuiControl, MyGui:, LabelSaveGameKeep, %localestr109%
	GuiControl, MyGui:, LabelFilesMin, %localestr104%
	GuiControl, MyGui:, LabelOptPlayButton, %localestr110%
	GuiControl, MyGui:, LabelOptPlayButtonParam, %localestr111%
	GuiControl, MyGui:, LabelddlLanguage, %localestr125%
	GuiControl, MyGui:, LabelOptBackupPath, %localestr112%
	GuiControl, MyGui:, OptAlwaysBackup, %localestr113%
	GuiControl, MyGui:, OptAlwaysCleanup, %localestr114%
	GuiControl, MyGui:, LabelOptNewGame, %localestr115%
	GuiControl, MyGui:, OptBtnCancel, %localestr116%
	GuiControl, MyGui:, OptBtnOk, %localestr117%
	
	return
}

;-------------------
subConvertTESVSGMIni:
{
	;This Subroutine check the version of the ini file by trying to read one of the new entries.
	;If the ini file use the old format then it will be converted into the new one.
	
	;This allow old users to use the progrom normaly and keep their settings
	
	;Look for SKYRIMSE key in [COMPUTER_NAME] section of the ini file
	IniRead, SKYRIMSE, %TESVSGMINIFILENAME%, %A_ComputerName%, SkyrimSE
	
	;The key is found so load all other keys
	If SKYRIMSE != ERROR
	{
	;Make the corresponding path
		If (SKYRIMSE=0) {
			SAVEGAMESFOLDERDEFAULT = %A_MyDocuments%\My Games\Skyrim
			RegRead, strSkyrimPath, HKEY_LOCAL_MACHINE, Software\Wow6432Node\Bethesda Softworks\Skyrim, Installed Path
		} else {
			SAVEGAMESFOLDERDEFAULT = %A_MyDocuments%\My Games\Skyrim Special Edition
			RegRead, strSkyrimPath, HKEY_LOCAL_MACHINE, Software\Wow6432Node\Bethesda Softworks\Skyrim Special Edition, Installed Path
		}
		
		IniRead, SAVEGAMESFOLDER, %TESVSGMINIFILENAME%, %A_ComputerName%, SaveGameFolder, %SAVEGAMESFOLDERDEFAULT%
		IniRead, PLAYBUTTONLINK, %TESVSGMINIFILENAME%, %A_ComputerName%, PlayButtonLink, %strSkyrimPath%SkyrimLauncher.exe
		IniRead, PLAYBUTTONPARAM, %TESVSGMINIFILENAME%, %A_ComputerName%, PlayButtonParameter, %A_Space%
		IniRead, ACTIVE, %TESVSGMINIFILENAME%, %A_ComputerName%, Active, Standard
		IniRead, SAVEGAMESKEEP, %TESVSGMINIFILENAME%, %A_ComputerName%, SaveGameKeep, 10
		IniRead, SAVEGAMESCOUNTS, %TESVSGMINIFILENAME%, %A_ComputerName%, SaveGameCounts, 15
		IniRead, BACKUPATH, %TESVSGMINIFILENAME%, %A_ComputerName%, BackupPath, %A_Space%
		IniRead, SAVEGAMESTYPE, %TESVSGMINIFILENAME%, %A_ComputerName%, SaveGameType, GamingHours
		IniRead, SAVEGAMESHOURS, %TESVSGMINIFILENAME%, %A_ComputerName%, SaveGameHours, 000500
		IniRead, ALWAYSBACKUP, %TESVSGMINIFILENAME%, %A_ComputerName%, AlwaysBackup, 0
		IniRead, ALWAYSCLEANUP, %TESVSGMINIFILENAME%, %A_ComputerName%, AlwaysCleanup, 0
		IniRead, PROFILEFORNEWGAME, %TESVSGMINIFILENAME%, %A_ComputerName%, ProfileForNewGame, %A_Space%
		
		;All variables are loaded so now we can delete the corresponding Section
		IniDelete, %TESVSGMINIFILENAME%, %A_ComputerName%
		
		;Then rewrite all keys in new format
		Gosub, subWriteTESVSGMini
	}
	return
}

;-------------------
subReadTESVSGMini:
{
	;Read TESVSGM.ini and store everything in global vars
	;This was made to centralize all reading access to TESVSGM.ini instead of having read instructions in several places of the script
	;This prevent multiple read of same informations too. TESVSGM.ini is only read 2 time: 
	;  1. At the start of the program.
	;  2. When changing the game (Skyrim/SkyrimSE)
	
	If (LOCALEUSED = "ERROR" or LOCALEUSED = "" or LOCALEUSED = )
	{
		IniRead, LOCALEUSED, %TESVSGMINIFILENAME%, %A_ComputerName%_TESVSGM, Language
	}
	
	;Settings for the current game
	If (SKYRIMSE != 0) And (SKYRIMSE != 1)
	{
		IniRead, SKYRIMSE, %TESVSGMINIFILENAME%, %A_ComputerName%_TESVSGM, SkyrimSE, 0
	}
	
	;Make the corresponding path
	GameName = SKYRIM
	NEXTGAMENAME = Skyrim
	If (SKYRIMSE=0) {
		SAVEGAMESFOLDERDEFAULT = %A_MyDocuments%\My Games\Skyrim
		RegRead, strSkyrimPath, HKEY_LOCAL_MACHINE, Software\Wow6432Node\Bethesda Softworks\Skyrim, Installed Path
		GuiControl, 1: +cGreen,Edition
		GuiControl, 1: Text,Edition, %NEXTGAMENAME%
		NEXTGAMENAME = %NEXTGAMENAME% SE
	} else {
		SAVEGAMESFOLDERDEFAULT = %A_MyDocuments%\My Games\Skyrim Special Edition
		RegRead, strSkyrimPath, HKEY_LOCAL_MACHINE, Software\Wow6432Node\Bethesda Softworks\Skyrim Special Edition, Installed Path
		GameName = %GameName%SE
		GuiControl, 1: +cBlue,Edition
		GuiControl, 1: Text,Edition, %NEXTGAMENAME% SE
	}
	
	;Settings for the current game
	IniRead, SAVEGAMESFOLDER, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, SaveGameFolder, %SAVEGAMESFOLDERDEFAULT%
	IniRead, PLAYBUTTONLINK, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, PlayButtonLink, %strSkyrimPath%SkyrimLauncher.exe
	IniRead, PLAYBUTTONPARAM, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, PlayButtonParameter, %A_Space%
	IniRead, ACTIVE, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, Active, Standard
	IniRead, SAVEGAMESKEEP, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%,  SaveGameKeep, 10
	IniRead, SAVEGAMESCOUNTS, %TESVSGMINIFILENAME%, %A_ComputerName%, SaveGameCounts, 15
	IniRead, BACKUPATH, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, BackupPath, %A_Space%
	IniRead, SAVEGAMESTYPE, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, SaveGameType, GamingHours
	IniRead, SAVEGAMESHOURS, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, SaveGameHours, 000500
	IniRead, ALWAYSBACKUP, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, AlwaysBackup, 0
	IniRead, ALWAYSCLEANUP, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, AlwaysCleanup, 0
	IniRead, PROFILEFORNEWGAME, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, ProfileForNewGame, %A_Space%
	
	lstProfiles := doUpdateProfileDDL(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE)
	gosub, subActivateProfile
	
	return	
}

;-------------------
subWriteTESVSGMini:
{
	;Write TESVSGM.ini to save the content of the options global vars
	;This was made to centralize all writing access to TESVSGM.ini instead of having write instructions in several places of the script
	;This prevent multiple write of same informations too. TESVSGM.ini is only wrote 2 time: 
	;  1. When changing the game (Skyrim/SkyrimSE)
	;  2. At the end of the program.
	
	;Write the TESVSGM section
	IniWrite, %SKYRIMSE%, %TESVSGMINIFILENAME%, %A_ComputerName%_TESVSGM, SkyrimSE
	IniWrite, %LOCALEUSED%, %TESVSGMINIFILENAME%, %A_ComputerName%_TESVSGM, Language
	
	;Select the game name
	GameName = SKYRIM
	If SKYRIMSE=1
	{
		GameName = %GameName%SE
	}
	
	;Write the game settings section
	IniWrite, %SAVEGAMESFOLDER%, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, SaveGameFolder
	IniWrite, %PLAYBUTTONLINK%, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, PlayButtonLink
	IniWrite, %PLAYBUTTONPARAM%, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, PlayButtonParameter
	IniWrite, %ACTIVE%, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, Active
	IniWrite, %SAVEGAMESKEEP%, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, SaveGameKeep
	IniWrite, %SAVEGAMESCOUNTS%, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, SaveGameCounts
	IniWrite, %BACKUPATH%, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, BackupPath
	IniWrite, %SAVEGAMESTYPE%, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, SaveGameType
	IniWrite, %SAVEGAMESHOURS%, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, SaveGameHours
	IniWrite, %ALWAYSBACKUP%, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, AlwaysBackup
	IniWrite, %ALWAYSCLEANUP%, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, AlwaysCleanup
	IniWrite, %PROFILEFORNEWGAME%, %TESVSGMINIFILENAME%, %A_ComputerName%_%GameName%, ProfileForNewGame
	
	return
}

;-------------------
subSwitchGame:
{
	gosub, subWriteTESVSGMini
	If SKYRIMSE = 1
	{
		SKYRIMSE = 0
		SAVEGAMESFOLDERDEFAULT = %A_MyDocuments%\My Games\Skyrim
	}
	Else
	{
		SKYRIMSE = 1
		SAVEGAMESFOLDERDEFAULT = %A_MyDocuments%\My Games\Skyrim Special Edition
	}
	Menu, subMenuSG, ToggleCheck, Skyrim SE
	Gosub, subReadTESVSGMini
	return
}