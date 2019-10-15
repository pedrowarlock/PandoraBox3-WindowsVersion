#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\03 - incones\Double-J-Design-Diagram-V2-Game-pad.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <array.au3>
#include <Sound.au3>
#include <WinAPIRes.au3>
#include <Memory.au3>
#include <WinAPIMisc.au3>
#include <WinAPI.au3>
#include <string.au3>
#include <AutoItConstants.au3>
;~ #include ".\include\DSEngine.au3"
#include ".\include\ScreenConst.au3"

#include ".\include\au3Irr2_System.au3"
#include ".\include\au3Irr2_KeyboardMouse.au3"
#include ".\include\au3Irr2_2D.au3"
#include ".\include\au3Irr2_GUI.au3"

#include <GuiAVI.au3>
#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include ".\include\leitura.au3"
#include ".\include\DSEngine.au3"
;~ #include ".\include\DirectShow.au3"
#include <GDIPlus.au3>
    _GDIPlus_Startup()

$enginer = Engine_Startup(@ScriptDir & "\bin\DSEngine.dll")

$PLAYNG = False
Global $TrocaSnap = True

;~ #NoTrayIcon
;----------------------------------------------
;GUI PRINCIPAL
;----------------------------------------------
Global $IGraphBuilder
Global $iHandle = "PandoraBox3"
;~ Global $iGui = GUICreate("",$WINDOWS_SIZE[0],$WINDOWS_SIZE[1],0,0,$WS_POPUP)

Global $iGui = _IrrStartAdvanced ( _
    $IRR_EDT_OPENGL, _       ; Use OpenGL
    0, 0, _ ; screen size
    $IRR_BITS_PER_PIXEL_32, _; using 32 bit true color
    $IRR_WINDOWED, _ ;$IRR_FULLSCREEN, _         ; in a window $IRR_WINDOWED
    $IRR_NO_SHADOWS, _       ; without stencil shadows
    $IRR_CAPTURE_EVENTS, _    ; dont capture keystrokes and mouse
    $IRR_VERTICAL_SYNC_ON, _ ; sync to the monitor refresh rate
    0, _                    ; 0 = use the most appropriate window device
    $IRR_ON, _               ; Switch on double buffering of the display
    4, _                    ; Anti-aliasing level 4
    $IRR_ON )                ; use high precision floating point math

; Set the title of the display
_IrrSetWindowCaption($iHandle)
Global $pHande=WinGetHandle($iHandle)
_WinAPI_ShowWindow ($pHande,@SW_HIDE)
;~ _WinAPI_Setparent($pHande, $iGui)
_IrrHideMouse()

Local $g_hAVI = GUICreate("MiniW",$Video_W,$Video_H,$Video_left,$Video_top,$WS_POPUP + $WS_CHILD + $WS_DISABLED ,-1,$pHande)
GUISetBkColor(0)

;_WinAPI_MoveWindow ($pHande, 0, 0, $WINDOWS_SIZE[0],$WINDOWS_SIZE[1], True)

;~ Global $iIntro = Engine_LoadFile(@ScriptDir & "\intro.mp4", $pHande)
;~ if not @error Then $PlayngIntro = True
;~ Engine_StartPlayback()

;~ Global $g_hLogo = __GUICtrlEngine_Create($pHande, "", 0, 0,$WINDOWS_SIZE[0],$WINDOWS_SIZE[1])
;~ _PlaySnap(@ScriptDir & "\intro.mp4",$g_hLogo,$WINDOWS_SIZE[0],$WINDOWS_SIZE[1])

ProgressOn("Carregando lista de jogos...", "", "", -1, -1, $DLG_NOTONTOP)

Global $WIN_STATUS = True
;~ AdlibRegister ("__Constants")

Local $BitmapFont = _IrrGetFont ( @ScriptDir & ".\images\"& $ResourceFile &"\trends.png" )
_IrrGUISetFont( $BitmapFont )
_IrrGUISetColor( $EGDC_BUTTON_TEXT, 223, 223, 0, 255 )

;Inicia joysticks
_joyConst("Start",0,2)

;-------------------------------------
Global $Label_Pulse 	= _IrrAddStaticText($CONF_COIN[$CoinsPulse] 	  ,$res_labels_pulse_topX,$res_labels_pulse_topY,$res_labels_pulse_buttonX,$res_labels_pulse_buttonY,$IRR_GUI_NO_BORDER,$IRR_GUI_NO_WRAP )
Global $Label_Exit_mod	= _IrrAddStaticText($CONF_EXIT[$ExitMod] 		  ,$res_labels_Exit_mod_topX,$res_labels_Exit_mod_topY,$res_labels_Exit_mod_buttonX,$res_labels_Exit_mod_buttonY,$IRR_GUI_NO_BORDER,$IRR_GUI_NO_WRAP )
Global $Label_auto_exit	= _IrrAddStaticText($CONF_AUTO_EXIT[$AUTO_EXIT]	  ,$res_labels_auto_exit_topX,$res_labels_auto_exit_topY,$res_labels_auto_exit_buttonX,$res_labels_auto_exit_buttonY,$IRR_GUI_NO_BORDER,$IRR_GUI_NO_WRAP )
Global $Label_SelectGM	= _IrrAddStaticText($CONF_SEL_GAME[$SELECT_GMODE] ,$res_labels_SelectGM_topX,$res_labels_SelectGM_topY,$res_labels_SelectGM_buttonX,$res_labels_SelectGM_buttonY,$IRR_GUI_NO_BORDER,$IRR_GUI_NO_WRAP )
;-------------------------------------------------------------
;LEITURA - ARRAY DOS ITENS DO MENU
Global $ITENS_TOTAL =IniReadSectionNames ($GamePasta)
For $i=1 To 8
_ArrayColInsert($ITENS_TOTAL,1)
Next
;~ Global $ARRAY_LIST[1] = [0]



$ITENS_TOTAL[0][3] =  UBound($ITENS_TOTAL)-1
$ITENS_TOTAL[0][4] =  UBound($ITENS_TOTAL)-1
For $i=1 To UBound($ITENS_TOTAL)-1
	$GameRom  = IniRead($GamePasta,$ITENS_TOTAL[$i][0],"Rom", "")
	$GameLoad = IniRead($GamePasta,$ITENS_TOTAL[$i][0],"Load",5)
	$GameAdd  = IniRead($GamePasta,$ITENS_TOTAL[$i][0],"Show","False")

	if $GameAdd = "False" Then
		$ITENS_TOTAL[0][3] -= 1
		$ITENS_TOTAL[0][4] -= 1
	EndIf
	$ITENS_TOTAL[$i][1] = $GameRom
	$ITENS_TOTAL[$i][2] = $GameLoad
	$ITENS_TOTAL[$i][3] = $GameAdd
	$ITENS_TOTAL[$i][4] = $GameAdd
	if FileExists($ImagSelect & $ITENS_TOTAL[$i][0] & ".png") Then $ITENS_TOTAL[$i][5] = _IrrGetTexture($ImagSelect & $ITENS_TOTAL[$i][0] & ".png")
	if FileExists($ImagUnselt & $ITENS_TOTAL[$i][0] & ".png") Then $ITENS_TOTAL[$i][6] = _IrrGetTexture($ImagUnselt & $ITENS_TOTAL[$i][0] & ".png")

	$OG=int(100/(UBound($ITENS_TOTAL)-1)*$i)
	ProgressSet($OG, $OG & "%",$i & "/" & (UBound($ITENS_TOTAL)-1))
Next
Global $VALOR_MAX_ITENS = $ITENS_TOTAL[0][3]
Global $TOTAL_DE_GAMES_PAGINAS = __NumberInt($ITENS_TOTAL[0][3],9)


ProgressOff()

_WinAPI_ShowWindow ($pHande,@SW_SHOWMAXIMIZED)
$GStyle = _WinAPI_GetWindowLong ( $pHande, $GWL_STYLE )
_WinAPI_SetWindowLong ( $pHande, $GWL_STYLE ,$GStyle+$WS_DLGFRAME);+382205952



;~ _ArrayDisplay($ITENS_TOTAL,"GAME LIST","","",Default,"JOGOS|ROMS|COIN TIME|ADD/REMOVE|IMG SELECIONADA|IMG NÃO SELECIONADA|DIFICULDADE|LIFES")
;----------------------------------------------------------------------------
;IMAGENS DE NUMEROS
Local $hImageLoad	= _IrrGetTexture(".\images\" & $ResourceFile & "\loading.png");_GDIPlus_ImageLoadFromFile(".\images\" & $ResourceFile & "\loading.png")
Local $hImageMenu	= _IrrGetTexture(".\images\" & $ResourceFile & "\menu.png");_GDIPlus_ImageLoadFromFile(".\images\" & $ResourceFile & "\menu.png")
Local $hImageConf	= _IrrGetTexture(".\images\" & $ResourceFile & "\config_misc.png");_GDIPlus_ImageLoadFromFile(".\images\" & $ResourceFile & "\config_misc.png")
Local $hImageSelect	= _IrrGetTexture(".\images\" & $ResourceFile & "\select.png");_GDIPlus_ImageLoadFromFile(".\images\select.png")
Local $hImageSelect2= _IrrGetTexture(".\images\" & $ResourceFile & "\config_cursor.png");_GDIPlus_ImageLoadFromFile(".\images\config_cursor.png")
Local $hImageSelect3= _IrrGetTexture(".\images\" & $ResourceFile & "\config_cursor_2.png");_GDIPlus_ImageLoadFromFile(".\images\config_cursor.png")
Local $hImageTestIO	= _IrrGetTexture(".\images\" & $ResourceFile & "\config_iotest.png");_GDIPlus_ImageLoadFromFile(".\images\" & $ResourceFile & "\config_iotest.png")
Local $hImageGConf	= _IrrGetTexture(".\images\" & $ResourceFile & "\config_menu.png");_GDIPlus_ImageLoadFromFile(".\images\" & $ResourceFile & "\config_menu.png")
Local $hImageGConf2	= _IrrGetTexture(".\images\" & $ResourceFile & "\config_lev.png");_GDIPlus_ImageLoadFromFile(".\images\" & $ResourceFile & "\config_lev.png")
Local $hImageGConf3	= _IrrGetTexture(".\images\" & $ResourceFile & "\config_show.png");_GDIPlus_ImageLoadFromFile(".\images\" & $ResourceFile & "\config_show.png")
Local $hImageSalving= _IrrGetTexture(".\images\" & $ResourceFile & "\config_saving.png");_GDIPlus_ImageLoadFromFile(".\images\" & $ResourceFile & "\config_show.png")
Local $hImageADM1	= _IrrGetTexture(".\images\" & $ResourceFile & "\pwd_admin.png");_GDIPlus_ImageLoadFromFile(".\images\" & $ResourceFile & "\pwd_admin.png")
Local $hImageADM2	= _IrrGetTexture(".\images\" & $ResourceFile & "\pwd_user.png");_GDIPlus_ImageLoadFromFile(".\images\" & $ResourceFile & "\pwd_user.png")
Local $hImageADM3	= _IrrGetTexture(".\images\" & $ResourceFile & "\pwd_input.png");_GDIPlus_ImageLoadFromFile(".\images\" & $ResourceFile & "\pwd_input.png")
Local $hImageADM4	= _IrrGetTexture(".\images\" & $ResourceFile & "\pwd_input_new.png");_GDIPlus_ImageLoadFromFile(".\images\" & $ResourceFile & "\pwd_input_new.png")
Local $hImageADM5	= _IrrGetTexture(".\images\" & $ResourceFile & "\pwd_input_old.png");_GDIPlus_ImageLoadFromFile(".\images\" & $ResourceFile & "\pwd_input_old.png")
Local $hImageButtons= _IrrGetTexture(".\images\" & $ResourceFile & "\buttons.png");_GDIPlus_ImageLoadFromFile(".\images\" & $ResourceFile & "\pwd_input_old.png")

	;NUMEROS -GRANDES-
	Global $NUMEROS_IMG[11]
	for $i=0 to 9
		$NUMEROS_IMG[$i] = _IrrGetTexture(".\images\" & $ResourceFile & "\num_menu\" & $i & ".png");_GDIPlus_ImageLoadFromFile(".\images\num_menu\" & $i & ".png")
	Next

	;NUMEROS -PEQUENOS-
	Global $NUMEROS_IMG2[12]
	for $i=0 to 9
		$NUMEROS_IMG2[$i] = _IrrGetTexture(".\images\" & $ResourceFile & "\" & $i & ".png");_GDIPlus_ImageLoadFromFile(".\images\" & $i & ".png")
	Next
	$NUMEROS_IMG2[10] = _IrrGetTexture(".\images\" & $ResourceFile & "\gang.png") ;_GDIPlus_ImageLoadFromFile(".\images\gang.png")
	$NUMEROS_IMG2[11] = _IrrGetTexture(".\images\" & $ResourceFile & "\hide.png") ;_GDIPlus_ImageLoadFromFile(".\images\hide.png")

_DRAW_MENU($MENU_SELECIONADO)


;MINI MENU ======================================================================>
    Local $hGUI_MiniMenu = GUICreate("MiniMenu", $iMini_SIZEW, $iMini_SIZEH,0,@DesktopHeight-$iMini_SIZEH, $WS_POPUP, $WS_EX_TOPMOST+$WS_EX_TOOLWINDOW)


	Local $dir = @ScriptDir & "\images\" & $ResourceFile & "\"
	Local $cursor = "cursor.png"
	Local $bk_menu= "exitmenu.png"

	Global $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI_MiniMenu)
	Global $hBitmap = _GDIPlus_BitmapCreateFromGraphics($iMini_SIZEW,$iMini_SIZEH , $hGraphic)
	Global $hBuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)

    Local $hBitmap1 = _GDIPlus_BitmapCreateFromFile($dir & $bk_menu)
	Local $hBitmap2 = _GDIPlus_BitmapCreateFromFile($dir & $cursor)



	Global $hFormat 	  = _GDIPlus_StringFormatCreate()
	Global $hBrush_Amarelo = _GDIPlus_BrushCreateSolid(0xFFB2B200)
	Global $hFamily 	  = _GDIPlus_FontFamilyCreate("ShiShangZhongHeiJianTi")

	Global $hFont_MiniM   = _GDIPlus_FontCreate($hFamily, $iMini_MenuFontS, 0)
	Global $tLayout_MiniM = _GDIPlus_RectFCreate($iMini_coinLeft,$iMini_coinTOP,$iMini_coinW)

	Const $APP_TIMER_ID = 9999
	Global $iMini_MenuShow= False
	Global $PermitirMMenu = False
	Global $SEND_COIN = True
	Global $iMini_ITEM		= 1
	Global $iMini_ITEM_M	= 2
;==================================================================================>
	if $PlayngIntro Then

		While Engine_GetLength($enginer) - Engine_GetPosition($enginer)
			Sleep(1000)
		WEnd
	EndIf


;~ 	Local $nCtrlID = __UDF_GetNextGlobalID($pHande)
;~ 	Local $g_hAVI = _WinAPI_CreateWindowEx(0, $__AVICONSTANT_ClassName, "", BitOR($__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE), 0, 0, $Video_W, $Video_H, $pHande, $nCtrlID)
	_WinAPI_ShowWindow ($g_hAVI,@SW_SHOWNOACTIVATE)
WinSetOnTop($g_hAVI, "", 1)
;~ Global $g_hAVI = __GUICtrlEngine_Create($pHande, "", $Video_left, $Video_top,$Video_W,$Video_H)

;~ AdlibRegister("_PlaySnap",0)

;============================================================================================================>
#Region LOOP PRINCIPAL
;============================================================================================================>
_IrrGUIEvents( 1 )


While _IrrRunning()
	$rettick=DllCall($Kernel32DLL, "int", "GetTickCount")
	_joyConst()

	Select
		Case _IsPressed("1B") 	;exit programa
			_exit()
		Case _IsPressed($Bt_COIN); or (BitAND($BT_JOY1,128))									;COIN
			__KeyPressed(1)

		;Case (BitAND($BT_JOY1,64)) or (BitAND($BT_JOY2,64))									;START GAME
		;	__KeyPressed(2)

		Case _IsPressed($Bt_UP) ;or ($Y1 = 0) or ($Y2 = 0)									;BUTTON (UP)
			if not $PLAYNG Then __KeyPressed(3)

			if not $PRESSED Then

				_WinAPI_PlaySound($SOUND_CLICK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
				if $iMini_MenuShow Then
					if $iMini_ITEM > 1 Then
						$iMini_ITEM -= 1
						$iMini_ADC -= $iMini_SPACE
					EndIf
				EndIf
			$PRESSED=True
			EndIf
		Case _IsPressed($Bt_DOWN); or ($Y1 > $X1 and $X1 > 0) or ($Y2 > $X2 and $X2 > 0)		;BUTTON (DOWN)
			if not $PLAYNG Then __KeyPressed(4)

			if not $PRESSED Then

				_WinAPI_PlaySound($SOUND_CLICK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
				if $iMini_MenuShow Then
					if $iMini_ITEM < $iMini_ITEM_M Then
						$iMini_ITEM += 1
						$iMini_ADC += $iMini_SPACE
					EndIf
				EndIf
			$PRESSED=True
			EndIf
		Case _IsPressed($Bt_LEFT); or ($X1 = 0) or ($X2 = 0)									;BUTTON (LEFT)

			if not $PLAYNG Then __KeyPressed(5)

		Case _IsPressed($Bt_RIGHT) ;or ($X1 > $Y1 and $Y1 > 0) or ($X2 > $Y2 and $Y2 > 0)	;BUTTON (RIGHT)

			if not $PLAYNG Then __KeyPressed(6)

		Case _IsPressed($Bt_SELECT); or (BitAND($BT_JOY1,1)) or (BitAND($BT_JOY2,1))			;BUTTON (A) - ACCEPT
			if not $PLAYNG Then __KeyPressed(7)

		Case (BitAND($BT_JOY1,2)); or (BitAND($BT_JOY2,2))									;BUTTON (B)
			if not $PLAYNG Then __KeyPressed(8)

		Case (BitAND($BT_JOY1,4)) ;or (BitAND($BT_JOY2,4))									;BUTTON (C)
			if not $PLAYNG Then __KeyPressed(9)

		Case _IsPressed($Bt_BACK) ;or (BitAND($BT_JOY1,8)) or (BitAND($BT_JOY2,8))			;BUTTON (D) - BACK
			if not $PLAYNG Then __KeyPressed(10)

		Case (BitAND($BT_JOY1,16)) ;or (BitAND($BT_JOY2,16))									;BUTTON (E)
			if not $PLAYNG Then __KeyPressed(11)

		Case (BitAND($BT_JOY1,32)) ;or (BitAND($BT_JOY2,32))									;BUTTON (F)
			if not $PLAYNG Then __KeyPressed(12)

		Case _IsPressed($Bt_MENU) ;or (BitAND($BT_JOY2,128))									;BUTTON (MENU CONFIGURATION)
			if not $PLAYNG Then __KeyPressed(13)

		Case _IsPressed("20") 	;exit game
			__KeyPressed(14)
		Case Else
			$PRESSED = False
			$rettick_KEY=$rettick[0]
	EndSelect

	;TIMER DO CONTADOR DE 60 SEGUNDOS
if not $PLAYNG Then
	if $TIMER_ON and $FICHAS > 0 Then
		Int(TimerDiff($CONTADOR_INICIO) < $CONTADOR_TIME)
		$CONTADOR_FINAL=Int((TimerDiff($CONTADOR_INICIO)/1000))
		$CONTADOR_CT=StringFormat("%02d", String($CONTADOR_TIME/1000-$CONTADOR_FINAL))
		if $CONTADOR_CT <= 0 then
			$TIMER_ON = False
			_playGame()
		EndIf
	EndIf

	;REDESENHA A CADA 300 ms
	if "300" <= ($rettick[0] - $rettick_ATTALL) or $MENU_SELECIONADO=6 or $MENU_SELECIONADO=7 or $MENU_SELECIONADO=8 Then
		_DRAW_MENU($MENU_SELECIONADO)
	EndIf
Else

	if $iMini_MenuShow Then
		_GDIPlus_GraphicsClear($hBuffer)
		_GDIPlus_GraphicsDrawImageRect ( $hBuffer, $hBitmap1, 0, 0, $iMini_SIZEW, $iMini_SIZEH )
		_GDIPlus_GraphicsDrawImageRect ( $hBuffer, $hBitmap2, $iMini_Left, $iMini_ADC, $iMini_W, $iMini_H )
		_GDIPlus_GraphicsDrawStringEx($hBuffer, StringFormat("%02d",$FICHAS), $hFont_MiniM, $tLayout_MiniM,$hFormat,$hBrush_Amarelo)
		_GDIPlus_GraphicsDrawImage($hGraphic, $hBitmap, 0, 0)
	EndIf

	if "3000" <= ($rettick[0] - $rettick_PLAY) Then
		if Not ProcessExists($EmuleExe) Then
			$PLAYNG = False
			ProcessClose($EmuleExe)
			$PermitirMMenu = False
			_WinShow(True)
		EndIf
	EndIf

	if "8000" <= ($rettick[0] - $rettick_PLAY) Then
		if Not WinActive($EmuleClass) Then
			$PLAYNG = False
			ProcessClose($EmuleExe)
			$PermitirMMenu = False
			_WinShow(True)
		EndIf
	EndIf

	if $ITENS_TOTAL[_FindGame()][2] <= ($rettick[0] - $rettick_PLAY) and $SEND_COIN Then
		_SendCoin()
	EndIf
EndIf

;MOSTRA O FPS
;~ $metrics = "FPS: (" & _IrrGetFPS() & ")"
;~ _IrrSetWindowCaption( $metrics )
WEnd


;==============================================================>
Exit

;~ Func TimerCallBack($hWndGUI, $MsgID)
;~ 	WinSetOnTop("", "", 1)
;~ EndFunc   ;==>TimerCallBack

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __KeyPressed
; Description ...:
; Syntax ........: __KeyPressed($ikey)
; Parameters ....: $ikey                - an integer value.
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __KeyPressed($ikey)
	_PlaySnap()
Switch $ikey

	Case 1 	;COIN
		if Not $PRESSED then
				If $MENU_SELECIONADO = 1 then
					_WinAPI_PlaySound($SOUND_COIN, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
					if $FICHAS < $MAX_COIN Then	$FICHAS +=$CoinsPulse
					$iRet =  IniRead($confINI,"configuration","coins",0)
					$iRet2=  IniRead($confINI,"configuration","GeralCase",0)
					IniWrite ($confINI,"Configuration","Coins",$iRet+$CoinsPulse)
					IniWrite ($confINI,"Configuration","GeralCase",$iRet2+1)
					$GERAL_CASE+=1
					$CONTADOR_INICIO=TimerInit()
					$TIMER_ON = True
				Else
					_WinAPI_PlaySound($SOUND_CLICK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
				EndIf
			$PRESSED = True
		EndIf
	Case 2 	;START
		if Not $PRESSED Then
			_WinAPI_PlaySound($SOUND_CLICK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
		$PRESSED = True
		EndIf
	Case 3 	;UP
		if Not $PRESSED Then ; or "350" <= ($rettick[0] - $rettick_KEY) Then
					_WinAPI_PlaySound($SOUND_CLICK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
					if $MENU_SELECIONADO = 1 and $SELECT_GMODE = 1 and $FICHAS <= 0 Then
						$PRESSED = True
						Return
					EndIf
					;------------------------PASS MENU
					if $MENU_SELECIONADO = 6 or $MENU_SELECIONADO = 7 or $MENU_SELECIONADO = 8 Then
						$ic = $CHEK_PASSWORD[$iPassPos]
						if $ic < 9 Then
							$CHEK_PASSWORD[$iPassPos] += 1
						Else
							$CHEK_PASSWORD[$iPassPos] = 0
						EndIf
;~ 						Sleep(200)
					EndIf
					;------------------------
					if $GAME_SELECTED > 1 Then
						$GAME_SELECTED -= 1
					Else
						$PRESSED = True
						Return
					EndIf

					if $ITEM_MENU_SELECIONADO > 1 Then
						$SELECT_BARRA_POS -= $Select_ADC
						$ITEM_MENU_SELECIONADO -=1
					Else
						$ITEM_MENU_SELECIONADO = $MENU_MAXITENS
						$SELECT_BARRA_POS = $Select_TOP + $Select2_ADC *($MENU_MAXITENS-1)
						$PAGE_FIRST = $GAME_SELECTED-($MENU_MAXITENS-1)
						$PAGE -= 1
					EndIf
					_DRAW_MENU($MENU_SELECIONADO)
				EndIf
		$PRESSED = True
		$TrocaSnap = True
		Return
	Case 4 	;DOWN
		if Not $PRESSED Then  ;or "350" <= ($rettick[0] - $rettick_KEY) Then
					_WinAPI_PlaySound($SOUND_CLICK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
					if $MENU_SELECIONADO = 1 and $SELECT_GMODE = 1 and $FICHAS <= 0 Then
						$PRESSED = True
						Return
					EndIf

					if $MENU_SELECIONADO = 6 or $MENU_SELECIONADO = 7 or $MENU_SELECIONADO = 8 Then
						$ic = $CHEK_PASSWORD[$iPassPos]
						if $ic > 0 Then
							$CHEK_PASSWORD[$iPassPos] -= 1
						Else
							$CHEK_PASSWORD[$iPassPos] = 9
						EndIf
;~ 						Sleep(200)
					EndIf

					;------------------

					if $GAME_SELECTED < $VALOR_MAX_ITENS Then
						$GAME_SELECTED += 1
					Else
						$PRESSED = True
						Return
					EndIf

					if $ITEM_MENU_SELECIONADO < $MENU_MAXITENS Then
						$SELECT_BARRA_POS += $Select_ADC
						$ITEM_MENU_SELECIONADO +=1
					Else
						$ITEM_MENU_SELECIONADO = 1
						$SELECT_BARRA_POS = $Select_TOP
						$PAGE_FIRST = $GAME_SELECTED
						$PAGE += 1
					EndIf
					_DRAW_MENU($MENU_SELECIONADO)
				EndIf
			$PRESSED = True
			$TrocaSnap = True
			Return
	Case 5 	;LEFT
		if Not $PRESSED  Then;or "350" <= ($rettick[0] - $rettick_KEY) Then
			_WinAPI_PlaySound($SOUND_OK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
			if $MENU_SELECIONADO = 1 and $SELECT_GMODE = 1 and $FICHAS <= 0 Then
				$PRESSED = True
				Return
			EndIf

			if $MENU_SELECIONADO = 6 or $MENU_SELECIONADO = 7 or $MENU_SELECIONADO = 8 Then
					if $iPassPos > 0 Then
						$iPassPos -=1
						$Select3_POS-=$Select3_ADC
					EndIf

					$PRESSED = True
				Return
				EndIf

			if $MENU_SELECIONADO = 1  or $MENU_SELECIONADO = 4 or $MENU_SELECIONADO = 9 or $MENU_SELECIONADO = 10 Then
				if $VALOR_MAX_ITENS - $GAME_SELECTED+1 >= 1 and $PAGE > 1 Then
					$GAME_SELECTED -= 9
					$PAGE -= 1
					$PAGE_FIRST = $GAME_SELECTED - $ITEM_MENU_SELECIONADO +1
				Else
					$SELECT_BARRA_POS = $Select_TOP
					$ITEM_MENU_SELECIONADO = 1
					$GAME_SELECTED = 1
				EndIf
				_DRAW_MENU($MENU_SELECIONADO)
			EndIf
		EndIf
		$PRESSED = True
		$TrocaSnap = True
		Return
	Case 6	;RIGHT
		if Not $PRESSED  Then;or "350" <= ($rettick[0] - $rettick_KEY) Then
			_WinAPI_PlaySound($SOUND_OK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
			if $MENU_SELECIONADO = 1 and $SELECT_GMODE = 1 and $FICHAS <= 0 Then
				$PRESSED = True
				Return
			EndIf

			if $MENU_SELECIONADO = 6 or $MENU_SELECIONADO = 7 or $MENU_SELECIONADO = 8 Then
				if $iPassPos < $iPassPosMax Then
					$iPassPos +=1
					$Select3_POS+=$Select3_ADC
				EndIf
				$PRESSED = True
				Return
			EndIf

			if $MENU_SELECIONADO = 1 or $MENU_SELECIONADO = 4 or $MENU_SELECIONADO = 9 or $MENU_SELECIONADO = 10 Then
				if $VALOR_MAX_ITENS - $GAME_SELECTED+1 > $MENU_MAXITENS and $PAGE < $TOTAL_DE_GAMES_PAGINAS Then
					$GAME_SELECTED += 9
					$PAGE += 1
					$PAGE_FIRST = $GAME_SELECTED - $ITEM_MENU_SELECIONADO +1
				Else
					if $PAGE < $TOTAL_DE_GAMES_PAGINAS Then
						$ITEM_MENU_SELECIONADO = 1
						$SELECT_BARRA_POS = $Select_TOP
						$PAGE += 1
						$PAGE_FIRST 	+= 9
						$GAME_SELECTED  = $PAGE_FIRST
					Else
						$SELECT_BARRA_POS = $Select_TOP + ($Select2_ADC) * ($VALOR_MAX_ITENS - $PAGE_FIRST)
						$ITEM_MENU_SELECIONADO = $VALOR_MAX_ITENS - $PAGE_FIRST + 1
						$GAME_SELECTED = $VALOR_MAX_ITENS
					EndIf
				EndIf
				_DRAW_MENU($MENU_SELECIONADO)
			EndIf
		EndIf
		$PRESSED = True
		$TrocaSnap = True
		Return
	Case 7 	;A
		if Not $PRESSED then
			_WinAPI_PlaySound($SOUND_CLICK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
			_ACCEPT_KEY()
		EndIf
		$PRESSED = True
		Return
	Case 8	;B
		if Not $PRESSED Then
			_SoundPlay($SOUND_CLICK);_WinAPI_PlaySound($SOUND_CLICK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
			_ACCEPT_KEY2()
		EndIf
		$PRESSED = True
		Return
	Case 9	;C
		if Not $PRESSED Then
			_SoundPlay($SOUND_CLICK);_WinAPI_PlaySound($SOUND_CLICK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
			_ACCEPT_KEY3()
		EndIf
		$PRESSED = True
		Return
	Case 10 ;D  -BACK-
		if Not $PRESSED then
			_SoundPlay($SOUND_CLICK);_WinAPI_PlaySound($SOUND_CLICK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
			_ACCEPT_KEY(False)
		EndIf
		$PRESSED = True
		Return
	Case 11 ;E
		if Not $PRESSED Then
			_SoundPlay($SOUND_CLICK);_WinAPI_PlaySound($SOUND_CLICK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
		EndIf
		$PRESSED = True
		Return
	Case 12 ;F
		if Not $PRESSED Then
			_SoundPlay($SOUND_CLICK);_WinAPI_PlaySound($SOUND_CLICK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
		EndIf
		$PRESSED = True
		Return
	Case 13 	;MENU
		if Not $PRESSED Then
			_SoundPlay($SOUND_CLICK);_WinAPI_PlaySound($SOUND_CLICK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
				if Not $iConf Then
					$TIMER_ON = False
					$SELECT_BARRA_POS = $Select_TOP+$Select_TOP_EXTRA
					$ITEM_MENU_SELECIONADO =1
					$MENU_SELECIONADO = 2
					$iConf = True
					$GAME_SELECTED = 1
					$PAGE = 1
					$PAGE_FIRST = 1
					$VALOR_MAX_ITENS = 9
					$TOTAL_DE_GAMES_PAGINAS = __NumberInt($ITENS_TOTAL[0][3],9)
;~ 					Engine_StopPlayback()
					_WinAPI_ShowWindow ($g_hAVI,@SW_HIDE)
					_DRAW_MENU($MENU_SELECIONADO)
					_SoundPlay($SOUND_BG)

				ElseIf $iConf and $MENU_SELECIONADO = 2 Then

					$CONTADOR_INICIO=TimerInit()
					$TIMER_ON = True
					$SELECT_BARRA_POS = $Select_TOP
					$ITEM_MENU_SELECIONADO =1
					$iConf = False
					$MENU_SELECIONADO = 1
					$GAME_SELECTED = 1
					$PAGE = 1
					$PAGE_FIRST = 1
					$VALOR_MAX_ITENS = $ITENS_TOTAL[0][3]
					_PlaySnap()
					$TOTAL_DE_GAMES_PAGINAS = __NumberInt($ITENS_TOTAL[0][3],9)
					_WinAPI_ShowWindow ($g_hAVI,@SW_SHOW)
					_DRAW_MENU($MENU_SELECIONADO)
					_SoundStop($SOUND_BG)

				EndIf
		EndIf
			$PRESSED = True
			Return
	Case 14
			if not $PRESSED Then
				if $PLAYNG and $PermitirMMenu Then
				_WinAPI_PlaySound($SOUND_CLICK, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))
				if $iMini_MenuShow and $PLAYNG Then
					if $iMini_ITEM = 1 Then
						_WinAPI_ShowWindow ($hGUI_MiniMenu,@SW_HIDE)

						Sleep(100)
							Send("{P DOWN}")
						Sleep(100)
							Send("{P UP}")
					Else
						$iMini_ITEM = 1
						$iMini_ADC = $iMini_TOP
						_WinAPI_ShowWindow ($hGUI_MiniMenu,@SW_HIDE)
						_ExitGame()
					EndIf
				Else
						Send("{P DOWN}")
							Sleep(50)
						Send("{P UP}")
							Sleep(50)

					_WinAPI_ShowWindow ($hGUI_MiniMenu,@SW_SHOWNOACTIVATE)
					WinSetOnTop($hGUI_MiniMenu, "", 1)
;~ 					GUIRegisterMsg($WM_TIMER, "TimerCallBack")
					DllCall("User32.dll", "int", "SetTimer", "hwnd", $hGUI_MiniMenu, "int", $APP_TIMER_ID, "int", @DesktopRefresh, "int", 0)
				EndIf
				$iMini_MenuShow= not $iMini_MenuShow
				$PRESSED = True
				EndIf
			EndIf
EndSwitch

EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _ACCEPT_KEY3
; Description ...:
; Syntax ........: _ACCEPT_KEY3([$back = True])
; Parameters ....: $back                - [optional] a boolean value. Default is True.
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ACCEPT_KEY3($back=True)
	Switch $MENU_SELECIONADO
		Case 10
			For $i=1 to UBound($ITENS_TOTAL)-1
			$ITENS_TOTAL[$i][4] = "False"
			Next
			$ITENS_TOTAL[0][4] = 0
	EndSwitch
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _ACCEPT_KEY
; Description ...:
; Syntax ........: _ACCEPT_KEY([$back = True])
; Parameters ....: $back                - [optional] a boolean value. Default is True.
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ACCEPT_KEY2($back=True)
	Switch $MENU_SELECIONADO
		Case 4
			$MENU_SELECIONADO = 10
			Return
		Case 10
			For $i=1 to UBound($ITENS_TOTAL)-1
			$ITENS_TOTAL[$i][4] = "True"
			Next
			$ITENS_TOTAL[0][4] = UBound($ITENS_TOTAL)-1
	EndSwitch
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _ACCEPT_KEY
; Description ...:
; Syntax ........: _ACCEPT_KEY($iMenu)
; Parameters ....: $iMenu               - an integer value.
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: 1 = MENU PRINCIPAL //-// 2 = CONFIG MENU //-// 3 = GAME CONFIGURATIONS //-// 4 = BOOK KEEPING
; ===============================================================================================================================


Func _ACCEPT_KEY($back=True)
	Switch $MENU_SELECIONADO
		Case 1														;/// MENU PRINCIPAL ///

			if Not $back Then
				Return
			EndIf
			;FAZER O CÓDIGO DE ENTRAR NO EMULADOR
			_playGame()

			Return
		Case 2  													;/// CONFIG MENU ///
			;BACK
			;-----------------------------------------
			;BACK
			if Not $back Then
				Return
			EndIf
			;-----------------------------------------
			;ENTER
			Switch $ITEM_MENU_SELECIONADO
				Case 1 ;ABRE IO/TEST
					$MENU_SELECIONADO = 3
					Return
				Case 2 ;CHANGE COINS SET
					if $CoinsPulse < UBound($CONF_COIN)-1 then
						$CoinsPulse += 1
					Else
						$CoinsPulse = 0
					EndIf
					Return
				Case 3 ;EXIT GAME MODE
					if $ExitMod < UBound($CONF_EXIT)-1 then
						$ExitMod += 1
					Else
						$ExitMod = 0
					EndIf
					Return
				Case 4 ;AUTO EXIT
					if $AUTO_EXIT < UBound($CONF_AUTO_EXIT)-1 then
						$AUTO_EXIT += 1
					Else
						$AUTO_EXIT = 0
					EndIf
					Return
				Case 5 ;SELECT GAME MODE
					if $SELECT_GMODE < UBound($CONF_SEL_GAME)-1 then
						$SELECT_GMODE += 1
					Else
						$SELECT_GMODE = 0
					EndIf
					Return
				Case 6 ;GAME CONFIGURATIONS
					$MENU_SELECIONADO = 4
					$SELECT_BARRA_POS = $Select_TOP
					$ITEM_MENU_SELECIONADO =1
					$GAME_SELECTED = 1
					$PAGE = 1
					$PAGE_FIRST = 1
					$TOTAL_DE_GAMES_PAGINAS = __NumberInt(UBound($ITENS_TOTAL)-1,9)
					$VALOR_MAX_ITENS = UBound($ITENS_TOTAL)-1
					Return
				Case 7 ;BOOK KEEPING
					$MENU_SELECIONADO = 5
						if $DEFAUT_PAS Then
							$MENU_MAXITENS = 2
							$VALOR_MAX_ITENS = 2
						Else
							$MENU_MAXITENS = 3
							$VALOR_MAX_ITENS = 3
						EndIf
					$ITEM_MENU_SELECIONADO = 1
					$GAME_SELECTED = 1

					$SELECT_BARRA_POS = $Select_TOP_BOOK
					$Select_ADC = $Select_ADC_BOOK
					Return
				Case 8 ;SAVE SETTINGS AND REBOOT
					$MENU_SELECIONADO = 11
					AdlibRegister("_salve_settings")
					Return
				Case 9 ;FACTORY SETTINGS AND REBOOT
					Return
			EndSwitch

		Case 4														;/// GAME CONFIGURATION ///
			if Not $back Then
				$MENU_SELECIONADO = 2
				$GAME_SELECTED = 6
				$ITEM_MENU_SELECIONADO  = 6
				$MENU_MAXITENS  = 9
				$VALOR_MAX_ITENS = 9
				$SELECT_BARRA_POS = ($Select_TOP + $Select_TOP_EXTRA) + $Select_ADC * ($ITEM_MENU_SELECIONADO-1)
				Return
			EndIf

			$MENU_SELECIONADO = 9
			Return
		Case 5 														;///  BOOK KEEPING  ///
			;-----------------------------------------
			;BACK
				if Not $back Then
					$VALOR_MAX_ITENS = 9
					$GAME_SELECTED = 7
					$Select_ADC 	= $Select_ADC_SAVE
					$MENU_SELECIONADO 		= 2
					$ITEM_MENU_SELECIONADO  = 7
					$SELECT_BARRA_POS     = ($Select_TOP + $Select_TOP_EXTRA) + $Select_ADC * ($ITEM_MENU_SELECIONADO - 1)
					$MENU_MAXITENS  = 9
					Return
				EndIf
			;-----------------------------------------
			;ENTER
			Switch $ITEM_MENU_SELECIONADO
				Case 1 ;COIN CLEAR
					$GERAL_CASE = StringFormat("%05s", 0)
					$CONTADOR_CT = $CONTADOR_TIME
				Case 2 ;MOLDAR AQUI O CHANGE PASSWORD -(ENTER)-
					$MENU_SELECIONADO = 6
				Case 3 ;CLEAN PASSWORD
					for $i=0 to UBound($CUR_PASSWORD)-1
						$CUR_PASSWORD[$i] = 0
					Next
					IniWrite($confINI,"configuration","password",Number(00000000))
					$Select_ADC 			= $Select_ADC_SAVE
					$MENU_SELECIONADO 		= 2
					$ITEM_MENU_SELECIONADO  = 7
					$SELECT_BARRA_POS       = $Select_TOP + $Select_ADC * ($ITEM_MENU_SELECIONADO - 1)
					$MENU_MAXITENS  		= 9
					$DEFAUT_PAS = True
					$VALOR_MAX_ITENS 		= 9
					$GAME_SELECTED 			= 7
				Return
			EndSwitch
			Return
		Case 6 ;CHECK PASSWORD - BOOK KEEPING -(ENTER)-
			;-----------------------------------------
			;BACK

			if Not $back Then

				if $DEFAUT_PAS Then
					$MENU_MAXITENS = 2
					$VALOR_MAX_ITENS = 2
				Else
					$MENU_MAXITENS = 3
					$VALOR_MAX_ITENS = 3
				EndIf
				$GAME_SELECTED = 2
				$MENU_SELECIONADO = 5
				$ITEM_MENU_SELECIONADO  = 2
				$SELECT_BARRA_POS = $Select_TOP_BOOK + $Select_ADC_BOOK * ($ITEM_MENU_SELECIONADO-1)
				$iPassPos=0
				$Select3_POS=$Select3_LEFT
					for $i=0 to UBound($CHEK_PASSWORD)-1
						$CHEK_PASSWORD[$i] = 0
					Next
				Return
			EndIf
			;-----------------------------------------
			;ENTER
			$PASS_CHECK = False
			For $i=0 to UBound($CUR_PASSWORD)-1
				if $CHEK_PASSWORD[$i] <> $CUR_PASSWORD[$i] Then
					ExitLoop
				EndIf
			if $i=UBound($CUR_PASSWORD)-1 Then $PASS_CHECK = True
			Next
			if $PASS_CHECK then
				$MENU_SELECIONADO = 7
				$iPassPos = 0
				$Select3_POS=$Select3_LEFT
				for $i=0 to UBound($CHEK_PASSWORD)-1
					$CHEK_PASSWORD[$i] = 0
				Next
			EndIf
			Return
		Case 7 ;NEW PASSWORD - BOOK KEEPING -(ENTER)-
			;-----------------------------------------
			;BACK
			if Not $back Then
					$MENU_SELECIONADO = 6
					$iPassPos=0
					$Select3_POS=$Select3_LEFT
					for $i=0 to UBound($CHEK_PASSWORD)-1
						$CHEK_PASSWORD[$i] = 0
					Next
				Return
			EndIf
			;-----------------------------------------
			;ENTER
				for $i=0 to UBound($CHEK_PASSWORD)-1
					$RED_PASSWORD[$i] = $CHEK_PASSWORD[$i]
					$CHEK_PASSWORD[$i] = 0
				Next
				$MENU_SELECIONADO = 8
				$iPassPos = 0
				$Select3_POS=$Select3_LEFT
			Return
		Case 8 ;REDIGITE PASSWORD - BOOK KEEPING -(ENTER)-
			;-----------------------------------------
			;BACK
				if Not $back Then
					$MENU_SELECIONADO = 7
					$iPassPos=0
					$Select3_POS=$Select3_LEFT
						for $i=0 to UBound($CHEK_PASSWORD)-1
							$CHEK_PASSWORD[$i] = 0
						Next
					Return
				EndIf
			;-----------------------------------------
			;ENTER
				$PASS_CHECK2 = False
				For $i=0 to UBound($RED_PASSWORD)-1
					if $CHEK_PASSWORD[$i] <> $RED_PASSWORD[$i] Then
						ExitLoop
					EndIf
					if $i=UBound($RED_PASSWORD)-1 Then $PASS_CHECK2 = True
				Next

				if $PASS_CHECK2 then
					Local $iDig=$RED_PASSWORD[0]&$RED_PASSWORD[1]&$RED_PASSWORD[2]&$RED_PASSWORD[3]&$RED_PASSWORD[4]&$RED_PASSWORD[5]&$RED_PASSWORD[6]&$RED_PASSWORD[7]
					for $i=0 to UBound($CHEK_PASSWORD)-1
						$CHEK_PASSWORD[$i] = 0
						$CUR_PASSWORD[$i] = $RED_PASSWORD[$i]
					Next


					$iPassPos = 0
					$Select3_POS=$Select3_LEFT
					$Select_ADC 	= $Select_ADC_SAVE
					$MENU_SELECIONADO 		= 2
					$ITEM_MENU_SELECIONADO  = 7
					$SELECT_BARRA_POS     = ($Select_TOP+$Select_TOP_EXTRA) + $Select_ADC * ($ITEM_MENU_SELECIONADO - 1)
					$MENU_MAXITENS  = 9

					$GAME_SELECTED = 7
					$VALOR_MAX_ITENS = 9

					IniWrite($confINI,"configuration","password",Number($iDig))

					For $i=0 to UBound($CUR_PASSWORD)-1
						if $CUR_PASSWORD[$i] <> 0 Then
							$DEFAUT_PAS = False
							ExitLoop
						EndIf
						if $i=UBound($CUR_PASSWORD)-1 Then $DEFAUT_PAS = True
					Next
				EndIf
			Return
		Case 9
				if Not $back Then
				$MENU_SELECIONADO = 4
				Return
				EndIf
		Case 10
				if Not $back Then
				$MENU_SELECIONADO = 4
				Return
				EndIf

				if  $ITENS_TOTAL[$GAME_SELECTED][4] = "False" Then
					$ITENS_TOTAL[$GAME_SELECTED][4] = "True"
					$ITENS_TOTAL[0][4] +=1
				Else
					$ITENS_TOTAL[$GAME_SELECTED][4] = "False"
					$ITENS_TOTAL[0][4] -=1
				EndIf
				$ITENS_TOTAL[0][2] = __NumberInt($ITENS_TOTAL[0][3],9)
	EndSwitch
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _START_MENU
; Description ...:
; Syntax ........: _START_MENU($iMenu)
; Parameters ....: $iMenu               - an integer value.
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _DRAW_MENU($iMenu)
	Switch $iMenu
		Case 0 ;MENU DE INICIAÇÃO --- VIDEO INTRO JÁ FOI EXECUTADO NO INICIO/ AQUI SÓ DA PLAY NO SNAP E MUDA PARA O MENU 1
			_PlaySnap()
			$MENU_SELECIONADO = 1
		Case 1 ;MENU DE PRINCIPAL
			;BACKGROUND
			_IrrDraw2DImage( $hImageMenu, 0, 0);_GDIPlus_GraphicsDrawImageRect($hBuffer, $hImageMenu, 0, 0,$WINDOWS_SIZE[0],$WINDOWS_SIZE[1])
			;Barra de seleção
			_IrrDraw2DImageElement( $hImageSelect, $Select_LEFT, $SELECT_BARRA_POS, 0,0,$Select_WIDTH,$Select_HEIGHT, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $hImageSelect, $Select_LEFT, $SELECT_BARRA_POS, $Select_WIDTH,$Select_HEIGHT)
			;FICHAS
			_IrrDraw2DImageElement($NUMEROS_IMG[StringMid(StringFormat("%02d",$FICHAS),1,1)],$res_labels_fichas1_left,$res_labels_fichas_top ,0,0,$res_labels_fichas_w,$res_labels_fichas_h, $IRR_USE_ALPHA )
			_IrrDraw2DImageElement($NUMEROS_IMG[StringMid(StringFormat("%02d",$FICHAS),2,1)],$res_labels_fichas2_left,$res_labels_fichas_top ,0,0,$res_labels_fichas_w,$res_labels_fichas_h, $IRR_USE_ALPHA )
			;CRONO
				_IrrDraw2DImageElement($NUMEROS_IMG2[StringLeft($CONTADOR_CT,1)], $res_labels_CRONO1_top,$res_labels_CRONO1_left,0,0,$res_labels_CRONO_w,$res_labels_CRONO_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringLeft($CONTADOR_CT,1)], 502, 25, 16,24)
				_IrrDraw2DImageElement($NUMEROS_IMG2[StringRight($CONTADOR_CT,1)],$res_labels_CRONO2_top,$res_labels_CRONO2_left,0,0,$res_labels_CRONO_w,$res_labels_CRONO_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringRight($CONTADOR_CT,1)], 517, 25, 16,24)
			;PAGINAS TOTAL E PAGINA SELECIONADA
			_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%02d", $PAGE),1,1)], $res_labels_page1_left, $res_labels_page_top,0,0, $res_labels_page_w,$res_labels_page_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%02d", $PAGE),1,1)], 685, 25, 16,24)
			_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%02d", $PAGE),2,1)], $res_labels_page2_left, $res_labels_page_top,0,0, $res_labels_page_w,$res_labels_page_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%02d", $PAGE),2,1)], 698, 25, 16,24)
			_IrrDraw2DImageElement($NUMEROS_IMG2[10], $res_labels_pageBar_left, $res_labels_page_top,0,0, $res_labels_page_w,$res_labels_page_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[10], 710, 25, 16,24)
			_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%02d", $TOTAL_DE_GAMES_PAGINAS),1,1)], $res_labels_page3_left, $res_labels_page_top,0,0, $res_labels_page_w,$res_labels_page_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%02d", $TOTAL_DE_GAMES_PAGINAS),1,1)], 725, 25, 16,24)
			_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%02d", $TOTAL_DE_GAMES_PAGINAS),2,1)], $res_labels_page4_left, $res_labels_page_top,0,0, $res_labels_page_w,$res_labels_page_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%02d", $TOTAL_DE_GAMES_PAGINAS),2,1)], 738, 25, 16,24)
			;ITENS DO MENU PRINCIPAL JOGOS/NUMEROS

			$iVoltas=0
			$id=0
			While $id < 9
					if $PAGE_FIRST+$id <= $ITENS_TOTAL[0][3] Then
						if $ITENS_TOTAL[$iVoltas+1][3] = "True" Then
							;Nome dos jogos
							if $id+1 = $ITEM_MENU_SELECIONADO Then
								if ($ITENS_TOTAL[$PAGE_FIRST+$iVoltas][5]) <> "" Then _IrrDraw2DImageElement($ITENS_TOTAL[$PAGE_FIRST+$iVoltas][5],$Itens_Lista_left, $Itens_Lista_top_S,0,0, $Itens_Lista_width,$Itens_Lista_height, $IRR_USE_ALPHA )
							Else
								if ($ITENS_TOTAL[$PAGE_FIRST+$iVoltas][6]) <> "" Then _IrrDraw2DImageElement($ITENS_TOTAL[$PAGE_FIRST+$iVoltas][6],$Itens_Lista_left, $Itens_Lista_top_S,0,0, $Itens_Lista_width,$Itens_Lista_height, $IRR_USE_ALPHA )
							EndIf
							;Numeros
								_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%03d", $PAGE_FIRST+$id),1,1)],$res_labels_itens001_left, $res_labels_itens000_top,0,0, $res_labels_itens000_w,$res_labels_itens000_h, $IRR_USE_ALPHA )
								_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%03d", $PAGE_FIRST+$id),2,1)],$res_labels_itens002_left, $res_labels_itens000_top,0,0, $res_labels_itens000_w,$res_labels_itens000_h, $IRR_USE_ALPHA )
								_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%03d", $PAGE_FIRST+$id),3,1)],$res_labels_itens003_left, $res_labels_itens000_top,0,0, $res_labels_itens000_w,$res_labels_itens000_h, $IRR_USE_ALPHA )
							$id+=1
							$Itens_Lista_top_S += $Itens_Lista_space
							$res_labels_itens000_top += $res_labels_itens000_space
						EndIf
					Else
						ExitLoop
					EndIf
					$iVoltas+=1
			WEnd
			$Itens_Lista_top_S = $Itens_Lista_top
			$res_labels_itens000_top = $res_labels_itens000_save

		Case 2	;CONFIG MENU
			_IrrDraw2DImage( $hImageConf, 0, 0);BACKGROUND
			;BARRA DE SELEÇÃO2
			_IrrDraw2DImageElement($hImageSelect2, $Select2_LEFT, $SELECT_BARRA_POS,0,0, $Select2_WIDTH,$Select2_HEIGHT, $IRR_USE_ALPHA )
			;string CASE
			_IrrGUISetText($Label_Pulse ,$CONF_COIN[$CoinsPulse])
			;string EXIT_MOD
 			_IrrGUISetText($Label_Exit_mod,$CONF_EXIT[$ExitMod])
			;string auto exit
			_IrrGUISetText( $Label_auto_exit,$CONF_AUTO_EXIT[$AUTO_EXIT])
			;Select game mode
			_IrrGUISetText( $Label_SelectGM, $CONF_SEL_GAME[$SELECT_GMODE])

			__Fichas_case()
			_IrrDrawGUI()

		Case 3	;I/O TEST
			_IrrDraw2DImage( $hImageTestIO, 0, 0);BACKGROUND

			;MENU/COIN/PLAY1/PLAY2 (TEXT)
			_IrrDraw2DImageElement($hImageButtons, $res_buttonsG1_LEFT, $res_buttonsG1_RIGHT ,$res_buttonsG1_RSOUCE_AX,$res_buttonsG1_RSOUCE_AY, $res_buttonsG1_W,$res_buttonsG1_H,$IRR_USE_ALPHA)
			_IrrDraw2DImageElement($hImageButtons, $res_buttonsG2_LEFT, $res_buttonsG2_RIGHT ,$res_buttonsG2_RSOUCE_AX,$res_buttonsG2_RSOUCE_AY, $res_buttonsG2_W,$res_buttonsG2_H,$IRR_USE_ALPHA)
			_IrrDraw2DImageElement($hImageButtons, $res_buttonsG3_LEFT, $res_buttonsG3_RIGHT ,$res_buttonsG3_RSOUCE_AX,$res_buttonsG3_RSOUCE_AY, $res_buttonsG3_W,$res_buttonsG3_H,$IRR_USE_ALPHA)
			_IrrDraw2DImageElement($hImageButtons, $res_buttonsG4_LEFT, $res_buttonsG4_RIGHT ,$res_buttonsG4_RSOUCE_AX,$res_buttonsG4_RSOUCE_AY, $res_buttonsG4_W,$res_buttonsG4_H,$IRR_USE_ALPHA)

			__DrawMenuJoy()

		Case 4 ;GAME SETTINGS
			;BACKGROUND
			_IrrDraw2DImage( $hImageGConf, 0, 0)
			_Menu_Configura()

		Case 5;BOOK KEEPING
			if $DEFAUT_PAS Then
				_IrrDraw2DImage( $hImageADM2, 0, 0)
			Else
				_IrrDraw2DImage( $hImageADM1, 0, 0)
			EndIf
			;BARRA DE SELEÇÃO PEQUENO
			_IrrDraw2DImageElement($hImageSelect2, $Select2_LEFT, $SELECT_BARRA_POS,0,0, $Select2_WIDTH,$Select2_HEIGHT, $IRR_USE_ALPHA )
			__Fichas_case()

		Case 6 ;PASSWORD MENU (ENTER PASSWORD)
			_IrrDraw2DImage( $hImageADM3, 0, 0) ;BACKGROUND
			_PASSWORD_DRAW_NUMB()
			__Fichas_case()
		Case 7 ;PASSWORD MENU (NEW PASSWORD)
			_IrrDraw2DImage( $hImageADM4, 0, 0) ;BACKGROUND
			_PASSWORD_DRAW_NUMB()
			__Fichas_case()
		Case 8 ;PASSWORD MENU (RE-DIGIT PASSWORD)
			_IrrDraw2DImage( $hImageADM5, 0, 0) ;BACKGROUND
			_PASSWORD_DRAW_NUMB()
			__Fichas_case()
		Case 9
			_IrrDraw2DImage( $hImageGConf2, 0, 0);_GDIPlus_GraphicsDrawImageRect($hBuffer, $hImageGConf2, 0, 0,$WINDOWS_SIZE[0],$WINDOWS_SIZE[1])
			_Menu_Configura()
		Case 10 ;GAME SETTINGS ADD/REMOVE GAMES
			;background
			_IrrDraw2DImage( $hImageGConf3, 0, 0);_GDIPlus_GraphicsDrawImageRect($hBuffer, $hImageGConf3, 0, 0,$WINDOWS_SIZE[0],$WINDOWS_SIZE[1])
			;ITENS NA LISTA
			_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%04d", $ITENS_TOTAL[0][4]),1,1)], $res_labels_GameListA1_left, $res_labels_GameListA_top,0,0, $res_labels_GameList_W,$res_labels_GameList_H, $IRR_USE_ALPHA) ;_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%04d", $ITENS_TOTAL[0][3]),1,1)], 515, 194, 16,24)
			_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%04d", $ITENS_TOTAL[0][4]),2,1)], $res_labels_GameListA2_left, $res_labels_GameListA_top,0,0, $res_labels_GameList_W,$res_labels_GameList_H, $IRR_USE_ALPHA) ;_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%04d", $ITENS_TOTAL[0][3]),2,1)], 528,  194, 16,24)
			_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%04d", $ITENS_TOTAL[0][4]),3,1)], $res_labels_GameListA3_left, $res_labels_GameListA_top,0,0, $res_labels_GameList_W,$res_labels_GameList_H, $IRR_USE_ALPHA) ;_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%04d", $ITENS_TOTAL[0][3]),3,1)], 541,  194, 16,24)
			_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%04d", $ITENS_TOTAL[0][4]),4,1)], $res_labels_GameListA4_left, $res_labels_GameListA_top,0,0, $res_labels_GameList_W,$res_labels_GameList_H, $IRR_USE_ALPHA) ;_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%04d", $ITENS_TOTAL[0][3]),4,1)], 554,  194, 16,24)
			;ITENS TOTAL
			_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%04d", UBound($ITENS_TOTAL)-1),1,1)], $res_labels_GameListB1_left, $res_labels_GameListB_top,0,0, $res_labels_GameList_W,$res_labels_GameList_H, $IRR_USE_ALPHA ) ;_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%04d", UBound($ITENS_TOTAL)-1),1,1)], 710, 194, 16,24);48
			_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%04d", UBound($ITENS_TOTAL)-1),2,1)], $res_labels_GameListB2_left, $res_labels_GameListB_top,0,0, $res_labels_GameList_W,$res_labels_GameList_H, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%04d", UBound($ITENS_TOTAL)-1),2,1)], 723,  194, 16,24)
			_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%04d", UBound($ITENS_TOTAL)-1),3,1)], $res_labels_GameListB3_left, $res_labels_GameListB_top,0,0, $res_labels_GameList_W,$res_labels_GameList_H, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%04d", UBound($ITENS_TOTAL)-1),3,1)], 736,  194, 16,24)
			_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%04d", UBound($ITENS_TOTAL)-1),4,1)], $res_labels_GameListB4_left, $res_labels_GameListB_top,0,0, $res_labels_GameList_W,$res_labels_GameList_H, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%04d", UBound($ITENS_TOTAL)-1),4,1)], 749,  194, 16,24)
			;Desenha a Lista
			_Menu_Configura()
		case 11
			_IrrDraw2DImage( $hImageSalving, 0, 0)
	EndSwitch
	$rettick_ATTALL = $rettick[0]
    _IrrEndScene()
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __Fichas_case
; Description ...:
; Syntax ........: __Fichas_case()
; Parameters ....:
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __Fichas_case()
	;FICHAS
	$iString1 = StringMid(StringFormat("%05s", $GERAL_CASE),1,1)
	$iString2 = StringMid(StringFormat("%05s", $GERAL_CASE),2,1)
	$iString3 =	StringMid(StringFormat("%05s", $GERAL_CASE),3,1)
	$iString4 =	StringMid(StringFormat("%05s", $GERAL_CASE),4,1)
	$iString5 =	StringMid(StringFormat("%05s", $GERAL_CASE),5,1)

	_IrrDraw2DImageElement($NUMEROS_IMG2[$iString1], $res_labels_fichasCase1_left, $res_labels_fichasCase_top,0,0, $res_labels_fichasCase_W,$res_labels_fichasCase_H, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG[$iString1], 540, 183, 29,40)
	_IrrDraw2DImageElement($NUMEROS_IMG2[$iString2], $res_labels_fichasCase2_left, $res_labels_fichasCase_top,0,0, $res_labels_fichasCase_W,$res_labels_fichasCase_H, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG[$iString2], 555, 183, 29,40)
	_IrrDraw2DImageElement($NUMEROS_IMG2[$iString3], $res_labels_fichasCase3_left, $res_labels_fichasCase_top,0,0, $res_labels_fichasCase_W,$res_labels_fichasCase_H, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG[$iString3], 570, 183, 29,40)
	_IrrDraw2DImageElement($NUMEROS_IMG2[$iString4], $res_labels_fichasCase4_left, $res_labels_fichasCase_top,0,0, $res_labels_fichasCase_W,$res_labels_fichasCase_H, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG[$iString4], 585, 183, 29,40)
	_IrrDraw2DImageElement($NUMEROS_IMG2[$iString5], $res_labels_fichasCase5_left, $res_labels_fichasCase_top,0,0, $res_labels_fichasCase_W,$res_labels_fichasCase_H, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG[$iString5], 600, 183, 29,40)
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __DrawMenuJoy
; Description ...:
; Syntax ........: __DrawMenuJoy()
; Parameters ....:
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __DrawMenuJoy()

			If $Y1 = 0 Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsUP1_LEFT, $res_buttonsUP1_RIGHT ,$res_buttonsUP1_RSOUCE_AX,$res_buttonsUP1_RSOUCE_AY,$res_buttonsUP1_W+$res_buttonsUP1_RSOUCE_AX,$res_buttonsUP1_H+$res_buttonsUP1_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If $Y1 > $X1 and $X1 > 0 Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsDOWN1_LEFT, $res_buttonsDOWN1_RIGHT ,$res_buttonsDOWN1_RSOUCE_AX,$res_buttonsDOWN1_RSOUCE_AY,$res_buttonsDOWN1_W+$res_buttonsDOWN1_RSOUCE_AX,$res_buttonsDOWN1_H+$res_buttonsDOWN1_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If $X1 = 0 Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsLEFT1_LEFT, $res_buttonsLEFT1_RIGHT ,$res_buttonsLEFT1_RSOUCE_AX,$res_buttonsLEFT1_RSOUCE_AY,$res_buttonsLEFT1_W+$res_buttonsLEFT1_RSOUCE_AX,$res_buttonsLEFT1_H+$res_buttonsLEFT1_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If $X1 > $Y1 and $Y1 > 0 Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsRIGHT1_LEFT, $res_buttonsRIGHT1_RIGHT ,$res_buttonsRIGHT1_RSOUCE_AX,$res_buttonsRIGHT1_RSOUCE_AY,$res_buttonsRIGHT1_W+$res_buttonsRIGHT1_RSOUCE_AX,$res_buttonsRIGHT1_H+$res_buttonsRIGHT1_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY1,1) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsA_LEFT, $res_buttonsA_RIGHT ,$res_buttonsA_RSOUCE_AX_GREEN,$res_buttonsA_RSOUCE_AY_GREEN, $res_buttonsA_W+$res_buttonsA_RSOUCE_AX_GREEN,$res_buttonsA_H+$res_buttonsA_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsA_LEFT, $res_buttonsA_RIGHT ,$res_buttonsA_RSOUCE_AX,$res_buttonsA_RSOUCE_AY, $res_buttonsA_W+$res_buttonsA_RSOUCE_AX,$res_buttonsA_H+$res_buttonsA_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY1,2) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsB_LEFT, $res_buttonsB_RIGHT ,$res_buttonsB_RSOUCE_AX_GREEN,$res_buttonsB_RSOUCE_AY_GREEN, $res_buttonsB_W+$res_buttonsB_RSOUCE_AX_GREEN,$res_buttonsB_H+$res_buttonsB_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsB_LEFT, $res_buttonsB_RIGHT ,$res_buttonsB_RSOUCE_AX,$res_buttonsB_RSOUCE_AY, $res_buttonsB_W+$res_buttonsB_RSOUCE_AX,$res_buttonsB_H+$res_buttonsB_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY1,4) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsC_LEFT, $res_buttonsC_RIGHT ,$res_buttonsC_RSOUCE_AX_GREEN,$res_buttonsC_RSOUCE_AY_GREEN, $res_buttonsC_W+$res_buttonsC_RSOUCE_AX_GREEN,$res_buttonsC_H+$res_buttonsC_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsC_LEFT, $res_buttonsC_RIGHT ,$res_buttonsC_RSOUCE_AX,$res_buttonsC_RSOUCE_AY, $res_buttonsC_W+$res_buttonsC_RSOUCE_AX,$res_buttonsC_H+$res_buttonsC_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY1,8) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsD_LEFT, $res_buttonsD_RIGHT ,$res_buttonsD_RSOUCE_AX_GREEN,$res_buttonsD_RSOUCE_AY_GREEN, $res_buttonsD_W+$res_buttonsD_RSOUCE_AX_GREEN,$res_buttonsD_H+$res_buttonsD_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsD_LEFT, $res_buttonsD_RIGHT ,$res_buttonsD_RSOUCE_AX,$res_buttonsD_RSOUCE_AY, $res_buttonsD_W+$res_buttonsD_RSOUCE_AX,$res_buttonsD_H+$res_buttonsD_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY1,16) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsE_LEFT, $res_buttonsE_RIGHT ,$res_buttonsE_RSOUCE_AX_GREEN,$res_buttonsE_RSOUCE_AY_GREEN, $res_buttonsE_W+$res_buttonsE_RSOUCE_AX_GREEN,$res_buttonsE_H+$res_buttonsE_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsE_LEFT, $res_buttonsE_RIGHT ,$res_buttonsE_RSOUCE_AX,$res_buttonsE_RSOUCE_AY, $res_buttonsE_W+$res_buttonsE_RSOUCE_AX,$res_buttonsE_H+$res_buttonsE_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY1,32) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsF_LEFT, $res_buttonsF_RIGHT ,$res_buttonsF_RSOUCE_AX_GREEN,$res_buttonsF_RSOUCE_AY_GREEN, $res_buttonsF_W+$res_buttonsF_RSOUCE_AX_GREEN,$res_buttonsF_H+$res_buttonsF_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsF_LEFT, $res_buttonsF_RIGHT ,$res_buttonsF_RSOUCE_AX,$res_buttonsF_RSOUCE_AY, $res_buttonsF_W+$res_buttonsF_RSOUCE_AX,$res_buttonsF_H+$res_buttonsF_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY1,64) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsS1_LEFT, $res_buttonsS1_RIGHT ,$res_buttonsS1_RSOUCE_AX_GREEN,$res_buttonsS1_RSOUCE_AY_GREEN, $res_buttonsS1_W+$res_buttonsS1_RSOUCE_AX_GREEN,$res_buttonsS1_H+$res_buttonsS1_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsS1_LEFT, $res_buttonsS1_RIGHT ,$res_buttonsS1_RSOUCE_AX,$res_buttonsS1_RSOUCE_AY, $res_buttonsS1_W+$res_buttonsS1_RSOUCE_AX,$res_buttonsS1_H+$res_buttonsS1_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY1,128) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsS4_LEFT, $res_buttonsS4_RIGHT ,$res_buttonsS4_RSOUCE_AX_GREEN,$res_buttonsS4_RSOUCE_AY_GREEN, $res_buttonsS4_W+$res_buttonsS4_RSOUCE_AX_GREEN,$res_buttonsS4_H+$res_buttonsS4_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsS4_LEFT, $res_buttonsS4_RIGHT ,$res_buttonsS4_RSOUCE_AX,$res_buttonsS4_RSOUCE_AY, $res_buttonsS4_W+$res_buttonsS4_RSOUCE_AX,$res_buttonsS4_H+$res_buttonsS4_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf
;joy2
			;DIRECIONAIS
			If $Y2 = 0 Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsUP2_LEFT, $res_buttonsUP2_RIGHT ,$res_buttonsUP2_RSOUCE_AX,$res_buttonsUP2_RSOUCE_AY,$res_buttonsUP2_W+$res_buttonsUP2_RSOUCE_AX,$res_buttonsUP2_H+$res_buttonsUP2_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If $Y2 > $X2 and $X2 > 0 Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsDOWN2_LEFT, $res_buttonsDOWN2_RIGHT ,$res_buttonsDOWN2_RSOUCE_AX,$res_buttonsDOWN2_RSOUCE_AY,$res_buttonsDOWN2_W+$res_buttonsDOWN2_RSOUCE_AX,$res_buttonsDOWN2_H+$res_buttonsDOWN2_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If $X2 = 0 Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsLEFT2_LEFT, $res_buttonsLEFT2_RIGHT ,$res_buttonsLEFT2_RSOUCE_AX,$res_buttonsLEFT2_RSOUCE_AY,$res_buttonsLEFT2_W+$res_buttonsLEFT2_RSOUCE_AX,$res_buttonsLEFT2_H+$res_buttonsLEFT2_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If $X2 > $Y2 and $Y2 > 0 Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsRIGHT2_LEFT, $res_buttonsRIGHT2_RIGHT ,$res_buttonsRIGHT2_RSOUCE_AX,$res_buttonsRIGHT2_RSOUCE_AY,$res_buttonsRIGHT2_W+$res_buttonsRIGHT2_RSOUCE_AX,$res_buttonsRIGHT2_H+$res_buttonsRIGHT2_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			;BOTOENS
			If BitAND($BT_JOY2,1) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsA2_LEFT, $res_buttonsA2_RIGHT ,$res_buttonsA2_RSOUCE_AX_GREEN,$res_buttonsA2_RSOUCE_AY_GREEN, $res_buttonsA2_W+$res_buttonsA2_RSOUCE_AX_GREEN ,$res_buttonsA2_H+$res_buttonsA2_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsA2_LEFT, $res_buttonsA2_RIGHT ,$res_buttonsA2_RSOUCE_AX,$res_buttonsA2_RSOUCE_AY, $res_buttonsA2_W+$res_buttonsA2_RSOUCE_AX ,$res_buttonsA2_H+$res_buttonsA2_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY2,2) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsB2_LEFT, $res_buttonsB2_RIGHT ,$res_buttonsB2_RSOUCE_AX_GREEN,$res_buttonsB2_RSOUCE_AY_GREEN, $res_buttonsB2_W+$res_buttonsB2_RSOUCE_AX_GREEN,$res_buttonsB2_H+$res_buttonsB2_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsB2_LEFT, $res_buttonsB2_RIGHT ,$res_buttonsB2_RSOUCE_AX,$res_buttonsB2_RSOUCE_AY, $res_buttonsB2_W+$res_buttonsB2_RSOUCE_AX,$res_buttonsB2_H+$res_buttonsB2_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY2,4) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsC2_LEFT, $res_buttonsC2_RIGHT ,$res_buttonsC2_RSOUCE_AX_GREEN,$res_buttonsC2_RSOUCE_AY_GREEN, $res_buttonsC2_W+$res_buttonsC2_RSOUCE_AX_GREEN,$res_buttonsC2_H+$res_buttonsC2_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsC2_LEFT, $res_buttonsC2_RIGHT ,$res_buttonsC2_RSOUCE_AX,$res_buttonsC2_RSOUCE_AY, $res_buttonsC2_W+$res_buttonsC2_RSOUCE_AX,$res_buttonsC2_H+$res_buttonsC2_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY2,8) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsD2_LEFT, $res_buttonsD2_RIGHT ,$res_buttonsD2_RSOUCE_AX_GREEN,$res_buttonsD2_RSOUCE_AY_GREEN, $res_buttonsD2_W+$res_buttonsD2_RSOUCE_AX_GREEN,$res_buttonsD2_H+$res_buttonsD2_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsD2_LEFT, $res_buttonsD2_RIGHT ,$res_buttonsD2_RSOUCE_AX,$res_buttonsD2_RSOUCE_AY, $res_buttonsD2_W+$res_buttonsD2_RSOUCE_AX,$res_buttonsD2_H+$res_buttonsD2_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY2,16) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsE2_LEFT, $res_buttonsE2_RIGHT ,$res_buttonsE2_RSOUCE_AX_GREEN,$res_buttonsE2_RSOUCE_AY_GREEN, $res_buttonsE2_W+$res_buttonsE2_RSOUCE_AX_GREEN,$res_buttonsE2_H+$res_buttonsE2_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsE2_LEFT, $res_buttonsE2_RIGHT ,$res_buttonsE2_RSOUCE_AX,$res_buttonsE2_RSOUCE_AY, $res_buttonsE2_W+$res_buttonsE2_RSOUCE_AX,$res_buttonsE2_H+$res_buttonsE2_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY2,32) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsF2_LEFT, $res_buttonsF2_RIGHT ,$res_buttonsF2_RSOUCE_AX_GREEN,$res_buttonsF2_RSOUCE_AY_GREEN, $res_buttonsF2_W+$res_buttonsF2_RSOUCE_AX_GREEN,$res_buttonsF2_H+$res_buttonsF2_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsF2_LEFT, $res_buttonsF2_RIGHT ,$res_buttonsF2_RSOUCE_AX,$res_buttonsF2_RSOUCE_AY, $res_buttonsF2_W+$res_buttonsF2_RSOUCE_AX,$res_buttonsF2_H+$res_buttonsF2_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY2,64) Then
			_IrrDraw2DImageElement($hImageButtons, $res_buttonsS2_LEFT, $res_buttonsS2_RIGHT ,$res_buttonsS2_RSOUCE_AX_GREEN,$res_buttonsS2_RSOUCE_AY_GREEN, $res_buttonsS2_W+$res_buttonsS2_RSOUCE_AX_GREEN,$res_buttonsS2_H+$res_buttonsS2_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
			_IrrDraw2DImageElement($hImageButtons, $res_buttonsS2_LEFT, $res_buttonsS2_RIGHT ,$res_buttonsS2_RSOUCE_AX,$res_buttonsS2_RSOUCE_AY, $res_buttonsS2_W+$res_buttonsS2_RSOUCE_AX,$res_buttonsS2_H+$res_buttonsS2_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			If BitAND($BT_JOY2,128) Then
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsS3_LEFT, $res_buttonsS3_RIGHT ,$res_buttonsS3_RSOUCE_AX_GREEN,$res_buttonsS3_RSOUCE_AY_GREEN, $res_buttonsS3_W+$res_buttonsS3_RSOUCE_AX_GREEN,$res_buttonsS3_H+$res_buttonsS3_RSOUCE_AY_GREEN,$IRR_USE_ALPHA)
			Else
				_IrrDraw2DImageElement($hImageButtons, $res_buttonsS3_LEFT, $res_buttonsS3_RIGHT ,$res_buttonsS3_RSOUCE_AX,$res_buttonsS3_RSOUCE_AY, $res_buttonsS3_W+$res_buttonsS3_RSOUCE_AX,$res_buttonsS3_H+$res_buttonsS3_RSOUCE_AY,$IRR_USE_ALPHA)
			EndIf

			if (BitAND($BT_JOY2,64) and BitAND($BT_JOY2,1)) or (BitAND($BT_JOY1,64) and BitAND($BT_JOY1,1)) Then
				$ITEM_MENU_SELECIONADO = 1
				$SELECT_BARRA_POS    = $Select_TOP+$Select_TOP_EXTRA
				$MENU_SELECIONADO = 2
			EndIf
EndFunc




; #FUNCTION# ====================================================================================================================
; Name ..........: _Menu_Configura
; Description ...:
; Syntax ........: _Menu_Configura()
; Parameters ....:
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Menu_Configura()
	;Barra de seleção
		_IrrDraw2DImageElement($hImageSelect, $Select_LEFT, $SELECT_BARRA_POS, 0,0,$Select_WIDTH,$Select_HEIGHT, $IRR_USE_ALPHA )
	;PAGINAS TOTAL E PAGINA SELECIONADA
		_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%02d", $PAGE),1,1)], $res_labels_page1_left, $res_labels_page_top,0,0, $res_labels_page_w,$res_labels_page_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%02d", $PAGE),1,1)], 685, 25, 16,24)
		_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%02d", $PAGE),2,1)], $res_labels_page2_left, $res_labels_page_top,0,0, $res_labels_page_w,$res_labels_page_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%02d", $PAGE),2,1)], 698, 25, 16,24)
		_IrrDraw2DImageElement($NUMEROS_IMG2[10], $res_labels_pageBar_left, $res_labels_page_top,0,0, $res_labels_page_w,$res_labels_page_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[10], 710, 25, 16,24)
		_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%02d", $TOTAL_DE_GAMES_PAGINAS),1,1)], $res_labels_page3_left, $res_labels_page_top,0,0, $res_labels_page_w,$res_labels_page_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%02d", $TOTAL_DE_GAMES_PAGINAS),1,1)], 725, 25, 16,24)
		_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%02d", $TOTAL_DE_GAMES_PAGINAS),2,1)], $res_labels_page4_left, $res_labels_page_top,0,0, $res_labels_page_w,$res_labels_page_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%02d", $TOTAL_DE_GAMES_PAGINAS),2,1)], 738, 25, 16,24)

	;MENU ITENS DO MENU (GAME SETTINGS)

	$id=0
		For $i=1 to $MENU_MAXITENS
			if $PAGE_FIRST+$id <= UBound($ITENS_TOTAL)-1 Then
				If $ITENS_TOTAL[$PAGE_FIRST+$id][4] = "False" Then
					_IrrDraw2DImageElement($NUMEROS_IMG2[11], $res_labels_exclude_left, $res_labels_exclude_top_save, 0,0,$res_labels_exclude_W,$res_labels_exclude_H, $IRR_USE_ALPHA )	;_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[11], 48, $Itens_Lista_top_S+3, 30,30)
				Else
					_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%03d", $PAGE_FIRST+$id),1,1)],$res_labels_itens001_left, $res_labels_itens000_top,0,0, $res_labels_itens000_w,$res_labels_itens000_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%03d", $PAGE_FIRST+$id),1,1)], 48, $Itens_Lista_top_S+4, 16,24)
					_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%03d", $PAGE_FIRST+$id),2,1)],$res_labels_itens002_left, $res_labels_itens000_top,0,0, $res_labels_itens000_w,$res_labels_itens000_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%03d", $PAGE_FIRST+$id),2,1)], 61, $Itens_Lista_top_S+4, 16,24)
					_IrrDraw2DImageElement($NUMEROS_IMG2[StringMid(StringFormat("%03d", $PAGE_FIRST+$id),3,1)],$res_labels_itens003_left, $res_labels_itens000_top,0,0, $res_labels_itens000_w,$res_labels_itens000_h, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer, $NUMEROS_IMG2[StringMid(StringFormat("%03d", $PAGE_FIRST+$id),3,1)], 74, $Itens_Lista_top_S+4, 16,24)
				EndIf
					if $i = $ITEM_MENU_SELECIONADO Then
						if ($ITENS_TOTAL[$PAGE_FIRST+$id][5]) <> "" Then _IrrDraw2DImageElement($ITENS_TOTAL[$PAGE_FIRST+$id][5], $Itens_Lista_left, $Itens_Lista_top_S, 0,0,$Itens_Lista_width,$Itens_Lista_height, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer,$ITENS_TOTAL[$PAGE_FIRST+$id][4] , $Itens_Lista_left, $Itens_Lista_top_S, $Itens_Lista_width, $Itens_Lista_height)
					Else
						if ($ITENS_TOTAL[$PAGE_FIRST+$id][6]) <> "" Then _IrrDraw2DImageElement($ITENS_TOTAL[$PAGE_FIRST+$id][6], $Itens_Lista_left, $Itens_Lista_top_S, 0,0,$Itens_Lista_width,$Itens_Lista_height, $IRR_USE_ALPHA );_GDIPlus_GraphicsDrawImageRect($hBuffer,$ITENS_TOTAL[$PAGE_FIRST+$id][5] , $Itens_Lista_left, $Itens_Lista_top_S, $Itens_Lista_width, $Itens_Lista_height)
					EndIf
				EndIf
					$Itens_Lista_top_S += $Itens_Lista_space
					$res_labels_itens000_top += $res_labels_itens000_space
					$res_labels_exclude_top_save += $Itens_Lista_space
					$id+=1
		Next
		$Itens_Lista_top_S = $Itens_Lista_top
		$res_labels_itens000_top = $res_labels_itens000_save
		$res_labels_exclude_top_save = $res_labels_exclude_top
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __NumberInt
; Description ...:
; Syntax ........: __NumberInt($iNumber, $iConta)
; Parameters ....: $iNumber             - an integer value.
;                  $iConta              - an integer value.
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __NumberInt($iNumber,$iConta)
	Local $iSoma  = ($iNumber/$iConta)
	if IsInt($iSoma) Then Return $iSoma
	Return Int($iSoma) +1
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _joyConst
; Description ...:
; Syntax ........: _joyConst()
; Parameters ....:
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _joyConst($iRun="",$iJoy1="",$iJoy2="")
	if $iRun = "Start" Then
		Global $JOYID1 = 0
		Global $JOYID2 = 1
		if $iJoy1 <> "" then $JOYID1=$iJoy1
		if $iJoy2 <> "" then $JOYID2=$iJoy2

		$JOYSTRUTURA = "int x;int y;int z;int buttons"
		$JOYINFO1 = DllStructCreate($JOYSTRUTURA)
		$JOYINFO2 = DllStructCreate($JOYSTRUTURA)
		Return
	EndIf

		Global $RETJOY1 = DllCall("winmm.dll", "int", "joyGetPos", "int", $JOYID1, "ptr", DllStructGetPtr($JOYINFO1))
		Global $BT_JOY1 = DllStructGetData($JOYINFO1, "buttons")
		Global $X1 = DllStructGetData($JOYINFO1, "x")
		Global $Y1 = DllStructGetData($JOYINFO1, "y")

		Global $RETJOY2 = DllCall("winmm.dll", "int", "joyGetPos", "int", $JOYID2, "ptr", DllStructGetPtr($JOYINFO2))
		Global $BT_JOY2 = DllStructGetData($JOYINFO2, "buttons")
		Global $X2 = DllStructGetData($JOYINFO2, "x")
		Global $Y2 = DllStructGetData($JOYINFO2, "y")
	Return
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _exit
; Description ...:
; Syntax ........: _exit()
; Parameters ....:
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _exit()
	if $FULLSCREEN Then
			While 100
				_ChangeScreenResEx(1, $WINDOWS_SAVE[0], $WINDOWS_SAVE[1])
				if @DesktopWidth = $WINDOWS_SAVE[0] then ExitLoop
			WEnd
		EndIf
		_IrrStop()
		Exit
EndFunc ; _exit


; #FUNCTION# ====================================================================================================================
; Name ..........: _ExitGame
; Description ...:
; Syntax ........: _ExitGame()
; Parameters ....:
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ExitGame()

	if ProcessExists("mame.exe") Then
		ProcessClose("mame.exe")
	ProcessWaitClose("mame.exe")
	$PLAYNG = False
	$SEND_COIN = True
	$PermitirMMenu = False
	$CONTADOR_INICIO=TimerInit()
	$TIMER_ON = True
	_WinShow(True)

	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _WinShow
; Description ...:
; Syntax ........: _WinShow($i)
; Parameters ....: $i                   - an integer value.
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _WinShow($i)
	if $i Then
		_WinAPI_ShowWindow ($g_hAVI,@SW_SHOW)
		_WinAPI_ShowWindow ($pHande,@SW_SHOW)
		_PlaySnap()
	Else
		_WinAPI_ShowWindow ($g_hAVI,@SW_HIDE)
		_WinAPI_ShowWindow ($pHande,@SW_HIDE)
	EndIf
EndFunc


; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __GUICtrlEngine_Create
; Description ...:
; Syntax ........: __GUICtrlEngine_Create($hWnd[, $sFilePath = ""[, $iX = 0[, $iY = 0[, $iWidth = 0[, $iHeight = 0[,
;                  $iStyle = 0x00000000[, $iExStyle = 0x00000000]]]]]]])
; Parameters ....: $hWnd                - a handle value.
;                  $sFilePath           - [optional] a string value. Default is "".
;                  $iX                  - [optional] an integer value. Default is 0.
;                  $iY                  - [optional] an integer value. Default is 0.
;                  $iWidth              - [optional] an integer value. Default is 0.
;                  $iHeight             - [optional] an integer value. Default is 0.
;                  $iStyle              - [optional] an integer value. Default is 0x00000000.
;                  $iExStyle            - [optional] an integer value. Default is 0x00000000.
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __GUICtrlEngine_Create($hWnd, $sFilePath = "",  $iX = 0, $iY = 0, $iWidth = 0, $iHeight = 0, $iStyle = 0x00000000, $iExStyle = 0x00000000)
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0)
	$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE)

	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hAVI = _WinAPI_CreateWindowEx($iExStyle, $__AVICONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
	_WinAPI_ShowWindow ($hAVI,@SW_SHOWNOACTIVATE)

	Return $hAVI
EndFunc   ;==>_GUICtrlAVI_Create

Func __GUICtrlEngine_SetState($g_hLogo,$iState=@SW_SHOW)
	if IsHWnd($g_hLogo) Then
		_WinAPI_ShowWindow ($g_hLogo,$iState)
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _PlaySnap
; Description ...:
; Syntax ........: _PlaySnap($iFile[, $iImg = True])
; Parameters ....: $iFile               - an integer value.
;                  $iImg                - [optional] an integer value. Default is True.
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func _PlaySnap()
	if  Not $MENU_SELECIONADO = 1 and $TrocaSnap = False Then Return

	if Engine_GetPosition($enginer) <> Engine_GetLength($enginer) and $TrocaSnap = False then Return

	Local $iSNAP_FORMAT[3]=[".avi",".mp4",".flv"]
	Local $iFormatVideo
	Local $iFile = $SNAPS & $ITENS_TOTAL[_FindGame()][0]


	For $i = 0 to Ubound($iSNAP_FORMAT)-1
		if FileExists($iFile & $iSNAP_FORMAT[$i]) Then
			$iFormatVideo = $iSNAP_FORMAT[$i]
			ExitLoop
		EndIf
	Next

			;DirectShow (DsEnginer.dll)
			if FileExists($iFile & $iFormatVideo) Then

				$iVideo[$info_play] = Engine_LoadFile($enginer,$iFile & $iFormatVideo, $g_hAVI)
				Engine_StartPlayback($enginer)
			Else
				Engine_StopPlayback($Enginer)
				Engine_Repaint($Enginer)
			EndIf
			$TrocaSnap = False
EndFunc
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __Constants
; Description ...:
; Syntax ........: __Constants()
; Parameters ....:
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __Constants()
	Local $iG=WinGetState($pHande)
;~ 	_WinAPI_IsZoomed ( $hWnd )
;~ 	_WinAPI_IsIconic ( $hWnd )

	if $WIN_STATUS and $iG=47 Then
		if $FULLSCREEN Then
			While 100
				_ChangeScreenResEx(1, $WINDOWS_SIZE[0], $WINDOWS_SIZE[1])
				if not @error Then
					While 100
						if @DesktopWidth = $WINDOWS_SIZE[0] then ExitLoop
					WEnd
					ExitLoop
				EndIf
			WEnd
		EndIf
		$WIN_STATUS = False
		Return
	ElseIf Not $WIN_STATUS and $iG=39 Then
		if $FULLSCREEN Then
			While 100
				WinSetState($pHande,"",@SW_MINIMIZE )
				_ChangeScreenResEx(1, $WINDOWS_SAVE[0], $WINDOWS_SAVE[1])
				if @DesktopWidth = $WINDOWS_SAVE[0] then ExitLoop
			WEnd
		EndIf
		$WIN_STATUS = True
		Return
	EndIf
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _PASSWORD_DRAW_NUMB
; Description ...:
; Syntax ........: _PASSWORD_DRAW_NUMB()
; Parameters ....:
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _PASSWORD_DRAW_NUMB()
	_IrrDraw2DImageElement($hImageSelect3, $Select3_POS,$Select3_TOP ,0,0, $Select3_WIDTH,$Select3_HEIGHT, $IRR_USE_ALPHA )
	For $i=0 to 7
		$id = $CHEK_PASSWORD[$i]
		_IrrDraw2DImageElement( $NUMEROS_IMG[$id], $Res_PasswordNumb_top_SAVE,$Res_PasswordNumb_top,0,0,$Res_PasswordNumb_W,$Res_PasswordNumb_H, $IRR_USE_ALPHA )
		$Res_PasswordNumb_top_SAVE += $Res_PasswordNumb_space
	Next
		$Res_PasswordNumb_top_SAVE = $Res_PasswordNumb_left
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _salve_settings
; Description ...:
; Syntax ........: _salve_settings()
; Parameters ....:
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _salve_settings()
					_DRAW_MENU($MENU_SELECIONADO)
					$CONTADOR_INICIO=TimerInit()
					$TIMER_ON = True
					$SELECT_BARRA_POS = $Select_TOP
					$ITEM_MENU_SELECIONADO =1
					$iConf = False
					$MENU_SELECIONADO = 1
					$CONTADOR_CT = $CONTADOR_TIME
					IniWrite ($confINI,"Configuration","Pulse",$CoinsPulse)
					IniWrite ($confINI,"Configuration","GeralCase",$GERAL_CASE)

					IniWrite ($confINI,"Configuration","SelectMode",$SELECT_GMODE)
					IniWrite ($confINI,"Configuration","autoexit",$AUTO_EXIT)

					$GAME_SELECTED = 1
					$PAGE = 1
					$PAGE_FIRST = 1


					For $i=1 to UBound($ITENS_TOTAL)-1
						IniWrite ($GamePasta,$ITENS_TOTAL[$i][0],"Show",$ITENS_TOTAL[$i][4])
						$ITENS_TOTAL[$i][3] = $ITENS_TOTAL[$i][4]
					Next
					$ITENS_TOTAL[0][3]  = $ITENS_TOTAL[0][4]
					$VALOR_MAX_ITENS 	= $ITENS_TOTAL[0][4]
					$TOTAL_DE_GAMES_PAGINAS = __NumberInt($ITENS_TOTAL[0][3],9)
					_DRAW_MENU($MENU_SELECIONADO)
					_WinAPI_ShowWindow ($g_hAVI,@SW_SHOW)
;~ 					_PlaySnap()
				AdlibUnRegister("_salve_settings")
		Return
EndFunc



; #FUNCTION# ====================================================================================================================
; Name ..........: _SendCoin
; Description ...:
; Syntax ........: _SendCoin()
; Parameters ....:
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _SendCoin()
	While $FICHAS
		$iRet =  IniRead($confINI,"configuration","coins",0)
		if $iRet > 0 Then
			Sleep(100)
				Send("{5 DOWN}")
			Sleep(100)
				Send("{5 UP}")

			$FICHAS -= 1
			$iRet -= 1
			IniWrite ($confINI,"Configuration","Coins",$iRet)
		EndIf
	WEnd
	$PermitirMMenu = True
	$SEND_COIN = False
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _FindGame
; Description ...:
; Syntax ........: _FindGame()
; Parameters ....:
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
			Func _FindGame()
				$find = 0
				for $i=1 to UBound($ITENS_TOTAL)-1
					if $ITENS_TOTAL[$i][3] = "True" then $find +=1
					if $find = $GAME_SELECTED then

						$find = $i
						ExitLoop
					EndIf
				Next
				Return $find
			EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _playGame
; Description ...:
; Syntax ........: _playGame()
; Parameters ....:
; Return values .: None
; Author ........: PedroWarlock
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _playGame()
			if $FICHAS > 0 Then
;~ 			_PlaySnap("stop")
			_WinShow(False)
			$PLAYNG = True

			$CONTADOR_INICIO=TimerInit()
			$CONTADOR_CT=StringFormat("%02d",$CONTADOR_TIME )


			Global $exe_emulador = ShellExecute($EmuleExe, $ITENS_TOTAL[_FindGame()][1],$EmuleDir , "open", @SW_HIDE)
			EndIf
			$rettick_PLAY=$rettick[0]
EndFunc