;; ARK AutoIt Script
;; (c) 2018 by Jonniboy (mail@jonni.it)
;; idea by raneo/Chiggn

; config
Global $vHotkeyStopScript		= "F1"
Global $vHotkeyToggleGui		= "F2"
Global $vHotkeyToggleW 			= "F3"
Global $vHotkeyToggleAutoClick 	= "F4"
Global $vHotkeyToggleAutoE 		= "F5"
Global $vHotkeyToggleAutoU 		= "F6"

Global $vShowGuiOnDefault		= True

;;;;;;;;;;;;;;;;;;;;;;;;; do not edit furthermore ;;;;;;;;;;;;;;;;;;;;;;;;;

#include <AutoItConstants.au3>
#include <GUIConstantsEx.au3>
#include <ColorConstants.au3>
#include <FontConstants.au3>

;; gui definitions

Global $hGui = GUICreate("ARK AutoIt Script", 200, 200)

Global $vGuiMainLabel = GUICtrlCreateLabel("ARK AutoIt Script", 5, 5, 100, 170) ; disables the ability to click on the checkboxes
GUICtrlSetFont($vGuiMainLabel, 9, $FW_BOLD)

Global $vGuiCopyrightLabel = GUICtrlCreateLabel("(C) by Jonniboy (mail@jonni.it)", 5, 20, 200, 50)

Global $vMarginTop = 40;
GUICtrlCreateLabel("Hotkeys:", 105, $vMarginTop, 50, 50)

; exit script
Global $vGuiLabel_showGui = GUICtrlCreateLabel("Exit script", 5, $vMarginTop + 15)
Global $vGuiLabel_showGui = GUICtrlCreateLabel($vHotkeyStopScript, 105, $vMarginTop + 15)
GUICtrlSetColor($vGuiLabel_showGui, $COLOR_RED)

; toggle gui
Global $vGuiLabel_showGui = GUICtrlCreateLabel("Toggle GUI", 5, $vMarginTop + 35)
Global $vGuiLabel_showGui = GUICtrlCreateLabel($vHotkeyToggleGui, 105, $vMarginTop + 35)
GUICtrlSetColor($vGuiLabel_showGui, $COLOR_RED)

; w
Global $vGuiCheckbox_w = GUICtrlCreateCheckbox("Auto W", 5, $vMarginTop + 50, 100, 25)
Global $vGuiLabel_w = GUICtrlCreateLabel($vHotkeyToggleW, 105, $vMarginTop + 55)
GUICtrlSetColor($vGuiLabel_w, $COLOR_RED)

; auto click
Global $vGuiCheckbox_autoClick = GUICtrlCreateCheckbox("Auto Left-Click", 5, $vMarginTop + 70, 100, 25)
Global $vGuiLabel_autoClick = GUICtrlCreateLabel($vHotkeyToggleAutoClick, 105, $vMarginTop + 75)
GUICtrlSetColor($vGuiLabel_autoClick, $COLOR_RED)

; auto E
Global $vGuiCheckbox_autoE = GUICtrlCreateCheckbox("Auto E", 5, $vMarginTop + 90, 100, 25)
Global $vGuiLabel_autoE = GUICtrlCreateLabel($vHotkeyToggleAutoE, 105, $vMarginTop + 95)
GUICtrlSetColor($vGuiLabel_autoE, $COLOR_RED)

; auto U
Global $vGuiCheckbox_autoU = GUICtrlCreateCheckbox("Auto U", 5, $vMarginTop + 110, 100, 25)
Global $vGuiLabel_autoU = GUICtrlCreateLabel($vHotkeyToggleAutoU, 105, $vMarginTop + 115)
GUICtrlSetColor($vGuiLabel_autoU, $COLOR_RED)

; buttons
Global $vGuiButton_Stop = GUICtrlCreateButton("Stop", 30, $vMarginTop + 135, 85, 25)
Global $vGuiButton_Hide = GUICtrlCreateButton("Hide", 115, $vMarginTop + 135, 85, 25)

;; global variables

; non-ARK related
Global $vClose = False
Global $vGuiToggle = False

; ARK-related
Global $vWToggle = False
Global $vAutoClickToggle = False
Global $vAutoEToggle = False
Global $vAutoUToggle = False

;; hotkey definitions

HotKeySet("{" & $vHotkeyStopScript & "}", "_stopScript")
HotKeySet("{" & $vHotkeyToggleGui & "}", "_toggleGui")
HotKeySet("{" & $vHotkeyToggleW & "}", "_toggleW")
HotKeySet("{" & $vHotkeyToggleAutoClick & "}", "_toggleAutoClick")
HotKeySet("{" & $vHotkeyToggleAutoE & "}", "_toggleAutoE")
HotKeySet("{" & $vHotkeyToggleAutoU & "}", "_toggleAutoU")

;; function definitions

Func _stopScript()
   $vClose = True
   $vGuiToggle = False ; fix for running gui loop, since otherwise it does not jump into the main while loop at the end
EndFunc

Func _toggleGui()
   If $vGuiToggle = False Then
	  $vGuiToggle = True

	  GUISetState(@SW_SHOW)

	  ; loop until the user exits
	  While $vGuiToggle = True
		   Switch GUIGetMsg()
			   Case $GUI_EVENT_CLOSE, $vGuiButton_Stop
				  $vClose = True
				  ExitLoop

			   Case $vGuiButton_Hide
				  ExitLoop
		   EndSwitch
	   WEnd

	  $vGuiToggle = False
	  GUISetState(@SW_HIDE)
   Else
	  $vGuiToggle = False
   EndIf
EndFunc

Func _toggleW()
   If $vWToggle = False Then
	  $vWToggle = True
	  Send("{w down}")
	  GUICtrlSetState($vGuiCheckbox_w, $GUI_CHECKED)
   Else
	  $vWToggle = False
	  Send("{w up}")
	  GUICtrlSetState($vGuiCheckbox_w, $GUI_UNCHECKED)
   EndIf
EndFunc

Func _toggleAutoClick()
   If $vAutoClickToggle = False Then
	  $vAutoClickToggle = True
	  GUICtrlSetState($vGuiCheckbox_autoClick, $GUI_CHECKED)
	  _autoClickLoop()
   Else
	  $vAutoClickToggle = False
	  GUICtrlSetState($vGuiCheckbox_autoClick, $GUI_UNCHECKED)
   EndIf
EndFunc

Func _toggleAutoE()
   If $vAutoEToggle = False Then
	  $vAutoEToggle = True
	  GUICtrlSetState($vGuiCheckbox_autoE, $GUI_CHECKED)
	  _autoELoop()
   Else
	  $vAutoEToggle = False
	  GUICtrlSetState($vGuiCheckbox_autoE, $GUI_UNCHECKED)
   EndIf
EndFunc

Func _toggleAutoU()
   If $vAutoUToggle = False Then
	  $vAutoUToggle = True
	  GUICtrlSetState($vGuiCheckbox_autoU, $GUI_CHECKED)
	  _autoULoop()
   Else
	  $vAutoUToggle = False
	  GUICtrlSetState($vGuiCheckbox_autoU, $GUI_UNCHECKED)
   EndIf
EndFunc

Func _autoClickLoop()
   While $vAutoClickToggle = True
	  Sleep(100)
	  MouseClick($MOUSE_CLICK_LEFT)
   WEnd
EndFunc

Func _autoELoop()
   While $vAutoEToggle = True
	  Sleep(200)
	  Send("e")
   WEnd
EndFunc

Func _autoULoop()
   While $vAutoUToggle = True
	  Sleep(200)
	  Send("u")
   WEnd
EndFunc

Func _main()
   If $vShowGuiOnDefault = True Then
	  _toggleGui()
   EndIf

   While $vClose = False ; pls don't die
	  Sleep(100)
   WEnd

   $vGuiToggle = False
   $vWToggle = False
   $vAutoClickToggle = False
   $vAutoEToggle = False
   $vAutoUToggle = False

   GUIDelete($hGui)
EndFunc

;; initial Call

_main()