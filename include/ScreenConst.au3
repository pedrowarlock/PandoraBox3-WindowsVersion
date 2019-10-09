#include <WinAPIGdi.au3>
;~ #include <array.au3>
; #FUNCTION# ====================================================================================================================
; Name ..........: _CheckScreenResEx
; Description ...:
; Syntax ........: _CheckScreenResEx($iX, $iY, $iBits, $iHz)
; Parameters ....: $iX                  - an integer value.
;                  $iY                  - an integer value.
;                  $iBits               - an integer value.
;                  $iHz                 - an integer value.
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _CheckScreenResEx($iX,$iY,$iBits,$iHz)
	Local $i = 0, $aData,$iArray[0][5]

		While 1
			$aData = _WinAPI_EnumDisplaySettings('', $i)
				If IsArray($aData) Then
					if $aData[0] = $iX and $aData[1] = $iY And $aData[2] = $iBits And $aData[3] = $iHz Then Return True
				Else
					ExitLoop
				EndIf
			$i += 1
		WEnd
	Return False
;~ _ArraySort($iArray,1)
;~ _ArrayDisplay($iArray,"Resolução do Monitor","",0,"","X|Y|Bits|Htz|Device")
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _ChangeScreenResEx
; Description ...:
; Syntax ........: _ChangeScreenResEx([$i_DisplayNum = 1[, $i_Width = @DesktopWidth[, $i_Height = @DesktopHeight[,
;                  $i_BitsPP = @DesktopDepth[, $i_RefreshRate = @DesktopRefresh]]]]])
; Parameters ....: $i_DisplayNum        - [optional] an integer value. Default is 1.
;                  $i_Width             - [optional] an integer value. Default is @DesktopWidth.
;                  $i_Height            - [optional] an integer value. Default is @DesktopHeight.
;                  $i_BitsPP            - [optional] an integer value. Default is @DesktopDepth.
;                  $i_RefreshRate       - [optional] an integer value. Default is @DesktopRefresh.
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ChangeScreenResEx($i_DisplayNum = 1, $i_Width = @DesktopWidth, $i_Height = @DesktopHeight, $i_BitsPP = @DesktopDepth, $i_RefreshRate = @DesktopRefresh)
	Local $hDLL = DllOpen("user32.dll")
	Local Const $DM_PELSWIDTH = 0x00080000
	Local Const $DM_PELSHEIGHT = 0x00100000
	Local Const $DM_BITSPERPEL = 0x00040000
	Local Const $DM_DISPLAYFREQUENCY = 0x00400000
	Local Const $CDS_TEST = 0x00000002
	Local Const $CDS_UPDATEREGISTRY = 0x00000001
	Local Const $DISP_CHANGE_RESTART = 1
	Local Const $DISP_CHANGE_SUCCESSFUL = 0
	Local Const $HWND_BROADCAST = 0xffff
	Local Const $WM_DISPLAYCHANGE = 0x007E
	If $i_Width = "" Or $i_Width = -1 Then $i_Width = @DesktopWidth; default to current setting
	If $i_Height = "" Or $i_Height = -1 Then $i_Height = @DesktopHeight; default to current setting
	If $i_BitsPP = "" Or $i_BitsPP = -1 Then $i_BitsPP = @DesktopDepth; default to current setting
	If $i_RefreshRate = "" Or $i_RefreshRate = -1 Then $i_RefreshRate = @DesktopRefresh; default to current setting
	Local $DEVMODE = DllStructCreate("byte[32];int[10];byte[32];int[6]")
	Local $s_Display

	$s_Display = "\\.\Display" & $i_DisplayNum

	Local $B = DllCall($hDLL, "int", "EnumDisplaySettings", "ptr", 0, "int", 0, "ptr", DllStructGetPtr($DEVMODE))

	If @error Then
    	$B = 0
    	SetError(1)
    	Return $B
	Else
    	$B = $B[0]
	EndIf
	If $B <> 0 Then
    	DllStructSetData($DEVMODE, 2, BitOR($DM_PELSWIDTH, $DM_PELSHEIGHT, $DM_BITSPERPEL, $DM_DISPLAYFREQUENCY), 5)
    	DllStructSetData($DEVMODE, 4, $i_Width, 2)
    	DllStructSetData($DEVMODE, 4, $i_Height, 3)
    	DllStructSetData($DEVMODE, 4, $i_BitsPP, 1)
    	DllStructSetData($DEVMODE, 4, $i_RefreshRate, 5)

    	$B = DllCall($hDLL, "int", "ChangeDisplaySettingsEx","str", $s_Display, "ptr", DllStructGetPtr($DEVMODE), "hwnd", Null, "dword", $CDS_TEST, "lparam", Null)
    	If @error Then
        	$B = -1
    	Else
        	$B = $B[0]
    	EndIf
    	Select
        	Case $B = $DISP_CHANGE_RESTART
            	$DEVMODE = ""
            	Return 2
        	Case $B = $DISP_CHANGE_SUCCESSFUL
            	DllCall($hDLL, "int", "ChangeDisplaySettingsEx","str", $s_Display, "ptr", DllStructGetPtr($DEVMODE), "hwnd", Null, "dword", Null, "lparam", Null)
            	DllCall($hDLL, "int", "SendMessage", "hwnd", $HWND_BROADCAST, "int", $WM_DISPLAYCHANGE, "int", $i_BitsPP, "int", $i_Height * 2 ^ 16 + $i_Width)
				$DEVMODE = ""
            	Return 1
        	Case Else
            	$DEVMODE = ""
            	SetError(1)
            	Return $B
    	EndSelect
	EndIf
EndFunc;==>_ChangeScreenResEx