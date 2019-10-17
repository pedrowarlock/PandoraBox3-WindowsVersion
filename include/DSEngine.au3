;~ Global $tagRECT
Global $DllEngine

;~ Local $hGUI1 = GUICreate("Example1",500,500,500,1)
;~ Local $hGUI2 = GUICreate("Example1",500,500,1,1)

;~ Local $iv1 = Engine_Startup("DSEngine.dll")
;~ Engine_LoadFile($iv1,"F:\Vídeos\2019-07-15 10-39-19.mp4", $hGUI1)

;~ Local $iv2 = Engine_Startup("DSEngine.dll")
;~ Engine_LoadFile($iv2,"F:\Vídeos\2019-07-15 11-13-19.mp4", $hGUI2)


;~ Engine_StartPlayback($iv1)
;~ Engine_StartPlayback($iv2)

;~ GUISetState(@SW_SHOW, $hGUI1)
;~ GUISetState(@SW_SHOW, $hGUI2)
;~     While 1
;~         Switch GUIGetMsg()
;~ 			Case -3
;~                 ExitLoop

;~         EndSwitch
;~     WEnd

;~     GUIDelete($hGUI1)
;~     GUIDelete($hGUI2)


; Starts the engine.
Func Engine_Startup($sPath = "DSEngine.dll")
	if not FileExists($sPath) then  return SetError(-2,0,"DSEnginer.dll não foi encontrada na pasta selecionada " & $sPath)
	$DllEngine = DllOpen($sPath)
	Local $ret = DllCall($DllEngine, "ptr:cdecl", "StartupEngine")
	if not IsArray($ret) or @error Then return SetError(-1,0,"DSEnginer.dll não pode ser iniciada")
	Return $ret[0]
EndFunc   ;==>Engine_Startup

; Removes the current overlay bmp
Func Engine_RemoveOverlay($Enginer)
	DllCall($DllEngine,"int:cdecl","RemoveBitmap","ptr",$Enginer)
EndFunc

; Sets a HBITMAP to overlay the current playing video.
; Remove the overlay with Engine_RemoveOverlay
; Source rectangle is in pixels while destination rectangle is in relative coords (0.0 is top, 1.0 is bottom etc.)
; Colorkey is in RRGGBB format (24 bits)
; Alpha channel is 0.0->1.0
Func Engine_SetOverlay($Enginer, $hbitmap, $sourceLeft, $sourceTop, $sourceRight, $sourceBottom, _
		$destinationLeft, $destinationTop, $destinationRight, $destinationBottom, $colorkey, $alpha)

	Local $sourcerect = DllStructCreate($tagRECT)
	DllStructSetData($sourcerect, "left", $sourceLeft)
	DllStructSetData($sourcerect, "top", $sourceTop)
	DllStructSetData($sourcerect, "right", $sourceright)
	DllStructSetData($sourcerect, "bottom", $sourceBottom)

	Local $destrect = DllStructCreate("float left;float top;float right;float bottom")
	DllStructSetData($destrect, "left", $destinationLeft)
	DllStructSetData($destrect, "top", $destinationTop)
	DllStructSetData($destrect, "right", $destinationRight)
	DllStructSetData($destrect, "bottom", $destinationBottom)

	Local $ret=DllCall($DllEngine, "int:cdecl", "BlendBitmap", "ptr", $Enginer, "ptr", $hbitmap, "ptr", _
	DllStructGetPtr($sourcerect), "ptr", DllStructGetPtr($destrect), "dword", $colorkey, "float", $alpha)
	Return $ret[0]
EndFunc   ;==>Engine_SetOverlay

; Force VMR9 to redraw the current frame into the selected window
Func Engine_Repaint($Enginer)
	DllCall($DllEngine,"int:cdecl","RepaintFrame","ptr",$Enginer)
EndFunc

; Mutes the audio from directshow
Func Engine_Mute($Enginer)
	Local $ret=DllCall($DllEngine,"int:cdecl","Mute","ptr",$Enginer)
EndFunc


; Recieve events from DirectShow, see DSEngineConstants.au3 for values
; Also has a minor block, think of it as GUIGetMsg()
Func Engine_GetEvent($Enginer)
	Local $arr[3]
	Local $ret = DllCall($DllEngine, "int:cdecl", "GetEvent", "ptr", $Enginer, "long*", 0, "long*", 0, "long*", 0)
;~ 	IF @error Then MsgBox(0,"",@error)
	If Not @error And $ret[0] Then
		$arr[0] = $ret[2]
		$arr[1] = $ret[3]
		$arr[2] = $ret[4]
		Return $arr
	Else
		Return False
	EndIf
EndFunc   ;==>Engine_GetEvent

; Get's the playback state, see DSEngineConstants.au3 for values
Func Engine_GetState($Enginer)
	Local $ret = DllCall($DllEngine, "long:cdecl", "GetState", "ptr", $Enginer)
	Return $ret[0]
EndFunc   ;==>Engine_GetState

;; Sets the letterbox border color, default is black
Func Engine_SetBorderColor($Enginer, $RGBColor)
	Local $ret = DllCall($DllEngine, "int:cdecl", "SetBorderColor", "ptr", $Enginer, "dword", $RGBColor)
	Return $ret[0]
EndFunc   ;==>Engine_SetBorderColor

; All left=-10000
; All right=10000
; Equal balance=0
Func Engine_GetAudioBalance($Enginer)
	Local $ret = DllCall($DllEngine, "long:cdecl", "GetAudioBalance", "ptr", $Enginer)
	Return $ret[0]
EndFunc   ;==>Engine_GetAudioBalance

; All left=-10000
; All right=10000
; Equal balance=0
Func Engine_SetAudioBalance($Enginer, $iBalance)
	Local $ret = DllCall($DllEngine, "int:cdecl", "SetAudioBalance", "ptr", $Enginer, "long", $iBalance)
	Return $ret[0]
EndFunc   ;==>Engine_SetAudioBalance

; Gets the playback rate as a multiplier (1.0 is normal speed, 0.5 is half, 2.0 is double etc.)
Func Engine_GetPlaybackRate($Enginer)
	Local $ret = DllCall($DllEngine, "double:cdecl", "GetPlaybackRate", "ptr", $Enginer)
	Return $ret[0]
EndFunc   ;==>Engine_GetPlaybackRate

; Sets the playback rate as a multiplier (1.0 is normal speed, 0.5 is half, 2.0 is double etc.)
Func Engine_SetPlaybackRate($Enginer, $dRate)
	Local $ret = DllCall($DllEngine, "int:cdecl", "SetPlaybackRate", "ptr", $Enginer, "double", $dRate)
	Return $ret[0]
EndFunc   ;==>Engine_SetPlaybackRate

; Save the current frame as a bmp file
Func Engine_SaveScreencap($Enginer, $sFilename)
	Local $ret = DllCall($DllEngine, "int:cdecl", "SaveScreencap", "ptr", $Enginer, "wstr", $sFilename)
	Return $ret[0]
EndFunc   ;==>Engine_SaveScreencap

; Gets the current frame as a hbitmap
Func Engine_GetCurrentFrame($Enginer)
	Local $ret=DllCall($DllEngine,"ptr:cdecl","GetCurrentFrame","ptr",$Enginer)
	Return $ret[0]
EndFunc

; Gets an array where [0] is width and [1] is height
Func Engine_GetVideoSize($Enginer)
	Local $ret = DllCall($DllEngine, "int:cdecl", "GetVideoDimensions", "ptr", $Enginer, "long*", 0, "long*", 0)
	Local $arr[2]
	$arr[0] = $ret[2] ; Width
	$arr[1] = $ret[3] ; Height
	Return $arr
EndFunc   ;==>Engine_GetVideoSize

; Sets the playback position in seconds (floating point is ok)
Func Engine_SetPosition($Enginer, $dTime)
	Local $ret = DllCall($DllEngine, "int:cdecl", "SetStreamPosition", "ptr", $Enginer, "double", $dTime)
	Return $ret[0]
EndFunc   ;==>Engine_SetPosition

; Gets the playback position in seconds (floating point is ok)
Func Engine_GetPosition($Enginer)
	Local $ret = DllCall($DllEngine, "double:cdecl", "GetStreamPosition", "ptr", $Enginer)
	Return $ret[0]
EndFunc   ;==>Engine_GetPosition

; Get the length of the current playing file (in seconds)
Func Engine_GetLength($Enginer)
	Local $ret = DllCall($DllEngine, "double:cdecl", "GetStreamLength", "ptr", $Enginer)
	Return $ret[0]
EndFunc   ;==>Engine_GetLength

; Makes file ready for playback, also specifying which window the payback should start in
Func Engine_LoadFile($Enginer, $sFilename, $WinHandle)
	Local $ret = DllCall($DllEngine, "int:cdecl", "LoadFile", "ptr", $Enginer, "wstr", $sFilename, "hwnd", $WinHandle)
	Return $ret[0]
EndFunc   ;==>Engine_LoadFile

; Starts playback
Func Engine_StartPlayback($ivideo)
	Local $ret = DllCall($DllEngine, "int:cdecl", "StartPlayback", "ptr", $ivideo)
	Return $ret[0]
EndFunc   ;==>Engine_StartPlayback

; Pause playback (other function will still work)
Func Engine_PausePlayback($Enginer)
	Local $ret = DllCall($DllEngine, "int:cdecl", "PausePlayback", "ptr", $Enginer)
	Return $ret[0]
EndFunc   ;==>Engine_PausePlayback

; Stop playback (all directshow interfaces is cleared and all functions related to active directshow functions stop working)
Func Engine_StopPlayback($Enginer)
	Local $ret = DllCall($DllEngine, "int:cdecl", "StopPlayback", "ptr", $Enginer)
	Return $ret[0]
EndFunc   ;==>Engine_StopPlayback

; Shutdown the engine, also stopping all active streams
Func Engine_Shutdown($Enginer)
	DllCall($DllEngine, "int:cdecl", "ShutdownEngine", "ptr", $Enginer)
	DllClose($DllEngine)
EndFunc   ;==>Engine_Shutdown

; Gets the volume, max i 0 and min is -10 000 (divide by 100 to get dB)
Func Engine_GetVolume($Enginer)
	Local $ret = DllCall($DllEngine, "long:cdecl", "GetVolume", "ptr", $Enginer)
	Return $ret[0]
EndFunc   ;==>Engine_GetVolume

; Sets the volume, max i 0 and min is -10 000 (divide by 100 to get dB)
Func Engine_SetVolume($Enginer, $vol)
	Local $ret = DllCall($DllEngine, "int:cdecl", "SetVolume", "ptr", $Enginer, "long", $vol)
	Return $ret[0]
EndFunc   ;==>Engine_SetVolume

; If this is set to false video will not be letterboxed while size changes
Func Engine_MaintainAspectRatio($Enginer, $maintain = True)
	Local $ret = DllCall($DllEngine, "int:cdecl", "MaintainAspectRatio", "ptr", $Enginer, "int", $maintain)
	Return $ret[0]
EndFunc   ;==>Engine_MaintainAspectRatio



; Sets the playing window, also adjust video to client rect
Func Engine_SetWindow($Enginer,$WinHandle)
Local $ret = DllCall($DllEngine, "int:cdecl", "SetWindow", "ptr", $Enginer, "hwnd", $WinHandle)
Local $wsize = WinGetClientSize($WinHandle)
	If @error Then Return False
	Engine_SetRects($Enginer,0, 0, 0, 0, 0, 0, $wsize[0], $wsize[1])
	Return $ret[0]
EndFunc   ;==>Engine_SetWindow

; If rect1 = {0,0,0,0} source is entire video
; Rect1= source rect
; rect2 = destination rect
Func Engine_SetRects($Enginer, $left1, $top1, $right1, $bottom1, $left2, $top2, $right2, $bottom2)
	If ($left1 + $top1 + $right1 + $bottom1) > 0 Then
		$rect1 = DllStructCreate($tagRECT)
		DllStructSetData($rect1, "left", $left1)
		DllStructSetData($rect1, "right", $right1)
		DllStructSetData($rect1, "top", $top1)
		DllStructSetData($rect1, "bottom", $bottom1)
		$prect1 = DllStructGetPtr($rect1)
	Else
Local		$prect1 = 0
	EndIf
Local $rect2 = DllStructCreate($tagRECT)
	DllStructSetData($rect2, "left", $left2)
	DllStructSetData($rect2, "right", $right2)
	DllStructSetData($rect2, "top", $top2)
	DllStructSetData($rect2, "bottom", $bottom2)
Local	$prect2 = DllStructGetPtr($rect2)

Local $ret = DllCall($DllEngine, "int:cdecl", "SetRects", "ptr", $Enginer, "ptr", $prect1, "ptr", $prect2)
EndFunc   ;==>Engine_SetRects


