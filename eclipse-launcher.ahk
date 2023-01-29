/*******************************************************************************
 * Copyright (C) 2022, 2023, Michael Keppler <michael.keppler@gmx.de>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License 2.0
 * which accompanies this distribution, and is available at
 * https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *******************************************************************************
*/

; Eclipse Launcher - configuration section

; the directory to scan for nested installations
RootDir := "c:\dev"

; Folders to be shown on the top level of the resulting menu. Others will be shown in a sub menu only.
; type: regular expression
; default: all items displayed on top level
; example: to display only egit and platform on the top level, use "egit|platform"
TopLevelPattern := ".*"

; folder names to ignore
; type: regular expression string
; default: ignore folders containing "old" or "backup" or starting with an underscore
IgnorePattern := "^_|\bold|backup"



; Nothing to change below this line

; Recommended for performance and compatibility with future AutoHotkey releases.
#NoEnv

; Enable warnings to assist with detecting common errors.
#Warn

; Ensure a consistent starting directory.
SetWorkingDir %A_ScriptDir%

; Remain in memory
#Persistent

; Avoid accidentally running this multiple times.
#SingleInstance Force

; Disable tray icon
Menu, Tray, NoIcon

; scan for directories with eclipse.exe
FileList := ""
Loop, Files, c:\dev\*, D
{
	If IsIgnored(A_LoopFileName)
	{
		Continue
	}

	; check for nested \eclipse\eclipse.exe
	IfExist, %RootDir%\%A_LoopFileName%\eclipse\eclipse.exe
	{
		FileList .= A_LoopFileName "`n"
	}
}
; remove last newline and sort items
FileList := Trim(FileList, "`r`n")
Sort, FileList, CL

IconPath := ""
ShowSubMenu := false
Loop, parse, FileList, `n
{
	FolderName := A_LoopField

	If (IconPath == "")
	{
		; take the icon from the first installation and don't load each one separately
		IconPath = %RootDir%\%FolderName%\eclipse\eclipse.exe
	}

	If IsTopLevel(FolderName)
	{
		; add as top level menu item
		Menu, MyMenu, Add, %FolderName%, MenuStartEclipse
		Menu, MyMenu, Icon, %FolderName%, %IconPath%, 1
	}
	else {
		; add to submenu instead
		Menu, MenuOther, Add, %FolderName%, MenuStartEclipse
		Menu, MenuOther, Icon, %FolderName%, %IconPath%, 1
		ShowSubMenu = true
	}
}

; add the sub menu, if there were any items for it
If ShowSubMenu
{
	; separator after all top level menu items
	Menu, MyMenu, Add
	; attach the sub menu to the main menu
	Menu, MyMenu, Add, Other, :MenuOther
}

; menu item reload, needed to recognize new installations
Menu, MyMenu, Add
Menu, MyMenu, Add, Reload, MenuReload

; exit script, wait for hotkey
return

IsTopLevel(FolderName)
{
	global TopLevelPattern
	If (RegExMatch(FolderName, TopLevelPattern) > 0)
	{
		return true
	}
	return false
}

IsIgnored(FolderName)
{
	global IgnorePattern
	If (RegExMatch(FolderName, IgnorePattern) > 0)
	{
		return true
	}
	return false
}

MenuStartEclipse:
	; use menu item to run a process, and set the working directory
	Run, %RootDir%\%A_ThisMenuItem%\eclipse\eclipse.exe, %A_ThisMenuItem%\eclipse
return

MenuReload:
	Reload
return

; enable hotkey
^#e::Menu, MyMenu, Show  ; Ctrl-Win-E