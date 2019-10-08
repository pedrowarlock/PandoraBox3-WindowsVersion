

Local $GameLoad,$GameRom, $GameAdd
Global $confINI 	= "Config.ini"

Global $ResourceFile = "resources-high"
Global $FULLSCREEN  = False
Global $i15hz = False
Local $ret = IniRead($confINI,"configuration","15hz","False")
if $ret = "True" Then $i15hz = True
Global $WINDOWS_SIZE[2] = [800,600]

if  $i15hz Then ;and _CheckScreenResEx(640,480,32,60) Then ;_CheckScreenResEx(384,240,32,60) Then
	$i15hz = True
	$WINDOWS_SIZE[0] = 640
	$WINDOWS_SIZE[1] = 480
	$ResourceFile = "resources-low"
EndIf

Global $WINDOWS_SAVE[2] = [@DesktopWidth,@DesktopHeight]
Global $PlayngIntro = False



global enum $MY_GUI_BUTTON_FILE = 101, _
$MY_GUI_BUTTON_WINDOW, _ ;    102
$MY_GUI_BUTTON_QUIT, _ ;      103
$MY_GUI_BUTTON_CLOSE, _ ;     104
$MY_GUI_SCROLLBAR_RED, _ ;    105
$MY_GUI_SCROLLBAR_GREEN, _ ;  106
$MY_GUI_LISTBOX, _ ;          107
$MY_GUI_CHECKBOX, _ ;         108
$MY_GUI_EDITBOX, _ ;          109
$MY_GUI_PASSWORD, _ ;         110
$MY_GUI_FILEOPEN		;        111



;--------------------------------------------------------------------------------
;RETTICK COUNT
Global $User32DLL	 = DllOpen("User32.dll")
Global $Kernel32DLL  = DllOpen("kernel32.dll")
Global $rettick=DllCall($Kernel32DLL, "int", "GetTickCount")
Global $rettick_CRONO = $rettick[0]
Global $rettick_KEY   = $rettick[0]
Global $rettick_ATTALL= $rettick[0]
Global $rettick_PLAY= $rettick[0]
;--------------------------------------------------------------------------------

Global $CONTADOR_TIME = 60000
Global $CONTADOR_INICIO=TimerInit(),$CONTADOR_FINAL,$CONTADOR_CT = $CONTADOR_TIME
Global $fps_maintimer = TimerInit(),$fps=0

;LEITURA
Global $EmuleDir = @ScriptDir & "\emulator"
Global $EmuleExe = "mame.exe"
Global $EmuleClass= "[CLASS:MAME]"

Global $GamePasta 	= @ScriptDir & "\GameList.ini"
Global $ImagSelect	= @ScriptDir & "\images\" & $ResourceFile & "\name\select\"
Global $ImagUnselt	= @ScriptDir & "\images\" & $ResourceFile & "\name\unselect\"

Global $FICHAS		= IniRead($confINI,"configuration","Coins",0)
Global $CoinsPulse	= IniRead($confINI,"configuration","pulse",0)
Global $ExitMod	    = IniRead($confINI,"configuration","exitMod",0)
Global $AUTO_EXIT   = IniRead($confINI,"configuration","autoexit",0)
Global $SELECT_GMODE= IniRead($confINI,"configuration","SelectMode",0)
Global $GERAL_CASE	= IniRead($confINI,"configuration","GeralCase",0)
Global $GERAL_PASS	= IniRead($confINI,"configuration","password",0)
Global $TIMER_ON=True
if $FICHAS > 0 then $TIMER_ON=False
Global $CONF_COIN[6] 	  = ["FREE","1C:1C","1C:2C","1C:3C","1C:4C","1C:5C"]
Global $CONF_EXIT[3] 	  = ["OFF","Start+C","MENU"]
Global $CONF_AUTO_EXIT[4] = ["OFF","After 3 Min","After 5 Min","After 10 Min"]
Global $CONF_SEL_GAME[2]  = ["Any","With Coin"]
Global $MAX_COIN = 99
;-----------------------
;JOYSTICK (START)
Global $X1,$Y1,$X2,$Y2,$BT_JOY1,$BT_JOY2,$JOYINFO1,$JOYINFO2,$JOYSTRUTURA ;JOYSTICKS
;DIRECIONAIS
	;PLAY 1
	$res_buttonsUP1_LEFT      =213
	$res_buttonsUP1_RIGHT     =251
	$res_buttonsUP1_RSOUCE_AX =87
	$res_buttonsUP1_RSOUCE_AY =133
	$res_buttonsUP1_W		  =30
	$res_buttonsUP1_H		  =38

	$res_buttonsDOWN1_LEFT      =213
	$res_buttonsDOWN1_RIGHT     =306
	$res_buttonsDOWN1_RSOUCE_AX =126
	$res_buttonsDOWN1_RSOUCE_AY =133
	$res_buttonsDOWN1_W		    =30
	$res_buttonsDOWN1_H		    =39

	$res_buttonsLEFT1_LEFT      =181
	$res_buttonsLEFT1_RIGHT     =283
	$res_buttonsLEFT1_RSOUCE_AX =5
	$res_buttonsLEFT1_RSOUCE_AY =141
	$res_buttonsLEFT1_W		    =38
	$res_buttonsLEFT1_H		    =30

	$res_buttonsRIGHT1_LEFT       =236
	$res_buttonsRIGHT1_RIGHT      =283
	$res_buttonsRIGHT1_RSOUCE_AX  =44
	$res_buttonsRIGHT1_RSOUCE_AY  =141
	$res_buttonsRIGHT1_W		  =39
	$res_buttonsRIGHT1_H		  =30


	;PLAY 2
	$res_buttonsUP2_LEFT      =556
	$res_buttonsUP2_RIGHT     =251
	$res_buttonsUP2_RSOUCE_AX =87
	$res_buttonsUP2_RSOUCE_AY =133
	$res_buttonsUP2_W		  =30
	$res_buttonsUP2_H		  =38

	$res_buttonsDOWN2_LEFT      =556
	$res_buttonsDOWN2_RIGHT     =306
	$res_buttonsDOWN2_RSOUCE_AX =126
	$res_buttonsDOWN2_RSOUCE_AY =133
	$res_buttonsDOWN2_W		    =30
	$res_buttonsDOWN2_H		    =39

	$res_buttonsLEFT2_LEFT      =524
	$res_buttonsLEFT2_RIGHT     =283
	$res_buttonsLEFT2_RSOUCE_AX =5
	$res_buttonsLEFT2_RSOUCE_AY =141
	$res_buttonsLEFT2_W		    =38
	$res_buttonsLEFT2_H		    =30

	$res_buttonsRIGHT2_LEFT       =579
	$res_buttonsRIGHT2_RIGHT      =283
	$res_buttonsRIGHT2_RSOUCE_AX  =44
	$res_buttonsRIGHT2_RSOUCE_AY  =141
	$res_buttonsRIGHT2_W		  =39
	$res_buttonsRIGHT2_H		  =30
;-------------------------------------------




		;PLAYER 1 BUTTONS
			;A
			$res_buttonsA_LEFT		 = 57
			$res_buttonsA_RIGHT		 = 422
			$res_buttonsA_RSOUCE_AX  = 54
			$res_buttonsA_RSOUCE_AY  = 33
			$res_buttonsA_RSOUCE_AX_GREEN= 54
			$res_buttonsA_RSOUCE_AY_GREEN= 81
			$res_buttonsA_W			 = 47
			$res_buttonsA_H			 = 47
			;B
			$res_buttonsB_LEFT		 = 111
			$res_buttonsB_RIGHT		 = 422
			$res_buttonsB_RSOUCE_AX  = 108
			$res_buttonsB_RSOUCE_AY  = 33
			$res_buttonsB_RSOUCE_AX_GREEN= 108
			$res_buttonsB_RSOUCE_AY_GREEN= 81
			$res_buttonsB_W			 = 47
			$res_buttonsB_H			 = 47
			;C
			$res_buttonsC_LEFT		 = 162
			$res_buttonsC_RIGHT		 = 422
			$res_buttonsC_RSOUCE_AX  = 162
			$res_buttonsC_RSOUCE_AY  = 33
			$res_buttonsC_RSOUCE_AX_GREEN= 162
			$res_buttonsC_RSOUCE_AY_GREEN= 81
			$res_buttonsC_W			 = 47
			$res_buttonsC_H			 = 47
			;D
			$res_buttonsD_LEFT		 = 220
			$res_buttonsD_RIGHT		 = 422
			$res_buttonsD_RSOUCE_AX  = 217
			$res_buttonsD_RSOUCE_AY  = 33
			$res_buttonsD_RSOUCE_AX_GREEN   = 217
			$res_buttonsD_RSOUCE_AY_GREEN   = 81
			$res_buttonsD_W			 = 47
			$res_buttonsD_H			 = 47
			;E
			$res_buttonsE_LEFT		 = 274
			$res_buttonsE_RIGHT		 = 422
			$res_buttonsE_RSOUCE_AX  = 271
			$res_buttonsE_RSOUCE_AY  = 33
			$res_buttonsE_RSOUCE_AX_GREEN   = 271
			$res_buttonsE_RSOUCE_AY_GREEN   = 81
			$res_buttonsE_W			 = 47
			$res_buttonsE_H			 = 47
			;E
			$res_buttonsF_LEFT		 = 328
			$res_buttonsF_RIGHT		 = 422
			$res_buttonsF_RSOUCE_AX  = 325
			$res_buttonsF_RSOUCE_AY  = 33
			$res_buttonsF_RSOUCE_AX_GREEN   = 325
			$res_buttonsF_RSOUCE_AY_GREEN   = 81
			$res_buttonsF_W			 = 47
			$res_buttonsF_H			 = 47

	;PLAYER 2 BUTTONS
			;A
			$res_buttonsA2_LEFT		 = 420
			$res_buttonsA2_RIGHT		 = 422
			$res_buttonsA2_RSOUCE_AX  = 54
			$res_buttonsA2_RSOUCE_AY  = 33
			$res_buttonsA2_RSOUCE_AX_GREEN   = 54
			$res_buttonsA2_RSOUCE_AY_GREEN   = 81
			$res_buttonsA2_W			 = 47
			$res_buttonsA2_H			 = 47
			;B
			$res_buttonsB2_LEFT		 = 474
			$res_buttonsB2_RIGHT		 = 422
			$res_buttonsB2_RSOUCE_AX  = 108
			$res_buttonsB2_RSOUCE_AY  = 33
			$res_buttonsB2_RSOUCE_AX_GREEN   = 108
			$res_buttonsB2_RSOUCE_AY_GREEN   = 81
			$res_buttonsB2_W			 = 47
			$res_buttonsB2_H			 = 47
			;C
			$res_buttonsC2_LEFT		 = 528
			$res_buttonsC2_RIGHT		 = 422
			$res_buttonsC2_RSOUCE_AX  = 162
			$res_buttonsC2_RSOUCE_AY  = 33
			$res_buttonsC2_RSOUCE_AX_GREEN   = 162
			$res_buttonsC2_RSOUCE_AY_GREEN   = 81
			$res_buttonsC2_W			 = 47
			$res_buttonsC2_H			 = 47
			;D
			$res_buttonsD2_LEFT		 = 583
			$res_buttonsD2_RIGHT		 = 422
			$res_buttonsD2_RSOUCE_AX  = 217
			$res_buttonsD2_RSOUCE_AY  = 33
			$res_buttonsD2_RSOUCE_AX_GREEN   = 217
			$res_buttonsD2_RSOUCE_AY_GREEN   = 81
			$res_buttonsD2_W			 = 47
			$res_buttonsD2_H			 = 47
			;E
			$res_buttonsE2_LEFT		 = 637
			$res_buttonsE2_RIGHT		 = 422
			$res_buttonsE2_RSOUCE_AX  = 271
			$res_buttonsE2_RSOUCE_AY  = 33
			$res_buttonsE2_RSOUCE_AX_GREEN   = 271
			$res_buttonsE2_RSOUCE_AY_GREEN   = 81
			$res_buttonsE2_W			 = 47
			$res_buttonsE2_H			 = 47
			;E
			$res_buttonsF2_LEFT		 = 691
			$res_buttonsF2_RIGHT		 = 422
			$res_buttonsF2_RSOUCE_AX  = 325
			$res_buttonsF2_RSOUCE_AY  = 33
			$res_buttonsF2_RSOUCE_AX_GREEN   = 325
			$res_buttonsF2_RSOUCE_AY_GREEN   = 81
			$res_buttonsF2_W			 = 47
			$res_buttonsF2_H			 = 47
	;----------------
			;START 1 (BUTTON)
			$res_buttonsS1_LEFT		  = 313
			$res_buttonsS1_RIGHT	  = 165
			$res_buttonsS1_RSOUCE_AX  = 0
			$res_buttonsS1_RSOUCE_AY  = 33
			$res_buttonsS1_RSOUCE_AX_GREEN   = 0
			$res_buttonsS1_RSOUCE_AY_GREEN   = 81
			$res_buttonsS1_W			 =47
			$res_buttonsS1_H			 = 47
			;START 2 (BUTTON)
			$res_buttonsS2_LEFT		 = 440
			$res_buttonsS2_RIGHT	 = 165
			$res_buttonsS2_RSOUCE_AX = 0
			$res_buttonsS2_RSOUCE_AY = 33
			$res_buttonsS2_RSOUCE_AX_GREEN  = 0
			$res_buttonsS2_RSOUCE_AY_GREEN  = 81
			$res_buttonsS2_W			 = 47
			$res_buttonsS2_H			 = 47
			;MENU (BUTTON)
			$res_buttonsS3_LEFT		 = 683
			$res_buttonsS3_RIGHT	 = 165
			$res_buttonsS3_RSOUCE_AX = 0
			$res_buttonsS3_RSOUCE_AY = 33
			$res_buttonsS3_RSOUCE_AX_GREEN  = 0
			$res_buttonsS3_RSOUCE_AY_GREEN  = 81
			$res_buttonsS3_W		 = 47
			$res_buttonsS3_H		 = 47
			;COINS (BUTTON)
			$res_buttonsS4_LEFT		 = 79
			$res_buttonsS4_RIGHT	 = 165
			$res_buttonsS4_RSOUCE_AX = 0
			$res_buttonsS4_RSOUCE_AY = 33
			$res_buttonsS4_RSOUCE_AX_GREEN  = 0
			$res_buttonsS4_RSOUCE_AY_GREEN  = 81
			$res_buttonsS4_W			 = 47
			$res_buttonsS4_H			 = 47

			;START 1 (TEXT)
			$res_buttonsG1_LEFT		 = 287
			$res_buttonsG1_RIGHT	 = 225
			$res_buttonsG1_RSOUCE_AX = 8
			$res_buttonsG1_RSOUCE_AY = 4
			$res_buttonsG1_W			 = $res_buttonsG1_RSOUCE_AX+102
			$res_buttonsG1_H			 = $res_buttonsG1_RSOUCE_AY+18
			;START 2 (TEXT)
			$res_buttonsG2_LEFT		 = 414
			$res_buttonsG2_RIGHT	 = 225
			$res_buttonsG2_RSOUCE_AX = 115
			$res_buttonsG2_RSOUCE_AY = 4
			$res_buttonsG2_W		 = $res_buttonsG2_RSOUCE_AX+102
			$res_buttonsG2_H		 = $res_buttonsG2_RSOUCE_AY+18
			;MENU (TEXT)
			$res_buttonsG3_LEFT		 = 667
			$res_buttonsG3_RIGHT	 = 225
			$res_buttonsG3_RSOUCE_AX = 293
			$res_buttonsG3_RSOUCE_AY = 4
			$res_buttonsG3_W		 = $res_buttonsG3_RSOUCE_AX+77
			$res_buttonsG3_H		 = $res_buttonsG3_RSOUCE_AY+18
			;COINS (TEXT)
			$res_buttonsG4_LEFT		 = 67
			$res_buttonsG4_RIGHT	 = 225
			$res_buttonsG4_RSOUCE_AX = 225
			$res_buttonsG4_RSOUCE_AY = 4
			$res_buttonsG4_W		 = $res_buttonsG4_RSOUCE_AX+57
			$res_buttonsG4_H		 = $res_buttonsG4_RSOUCE_AY+18



;-----------------------------------------------------------
;skin
	;SNAP VIDEO/IMAGE - AREA
	Global $Video_top 	=116
	Global $Video_left	=406
	Global $Video_W		=354
	Global $Video_H     =274

	;BARRA DE SELEÇÃO -MEDIDAS-
	Global $Select_LEFT   	= 28
	Global $Select_TOP    	= 115
	Global $Select_HEIGHT 	= 49
	Global $Select_WIDTH  	= 321
	Global $SELECT_BARRA_POS= $Select_TOP
	Global $Select_ADC_SAVE = 47
	Global $Select_ADC      = $Select_ADC_SAVE
	Global $Select_TOP_EXTRA= 5

	;BARRA DE SELEÇÃO2 - MENU
	Global $Select2_LEFT   = 5
	Global $Select2_TOP    = 115
	Global $Select2_HEIGHT = 36
	Global $Select2_WIDTH  = 50
	Global $Select2_POS    = $Select_TOP
	Global $Select2_ADC    = 47
	;BARRA DE SELEÇÃO2 (MENU PASSWORD)
	Global $Select3_TOP	  = 308
	Global $Select3_LEFT  = 40
	Global $Select3_HEIGHT= 18
	Global $Select3_WIDTH = 28
	Global $Select3_POS   = $Select3_LEFT
	Global $Select3_ADC		  = 39
	;ITENS NOMES LISTA
	Global $Itens_Lista_top	  = 121
	Global $Itens_Lista_left  = 92
	Global $Itens_Lista_width = 246
	Global $Itens_Lista_height= 35
	Global $Itens_Lista_top_S = $Itens_Lista_top
	Global $Itens_Lista_space = 47
	;MENU CONFIG ITENS
	Global $res_labels_pulse_topY	=173
	Global $res_labels_pulse_topX 	=225
	Global $res_labels_pulse_buttonY=$res_labels_pulse_topY+23
	Global $res_labels_pulse_buttonX=$res_labels_pulse_topX+111

	Global $res_labels_Exit_mod_topY=220
	Global $res_labels_Exit_mod_topX=200
	Global $res_labels_Exit_mod_buttonY=$res_labels_Exit_mod_topY+23
	Global $res_labels_Exit_mod_buttonX=$res_labels_Exit_mod_topX+136

	Global $res_labels_auto_exit_topY=266
	Global $res_labels_auto_exit_topX=150
	Global $res_labels_auto_exit_buttonY=$res_labels_auto_exit_topY+23
	Global $res_labels_auto_exit_buttonX=$res_labels_auto_exit_topX+186

	Global $res_labels_SelectGM_topY=313
	Global $res_labels_SelectGM_topX=220
	Global $res_labels_SelectGM_buttonY=$res_labels_SelectGM_topY+24
	Global $res_labels_SelectGM_buttonX=$res_labels_SelectGM_topX+116

	;FICHAS LABEL
	Global $res_labels_fichas1_left	=	640
	Global $res_labels_fichas2_left	=	656
	Global $res_labels_fichas_top	=	457
	Global $res_labels_fichas_w		=	29
	Global $res_labels_fichas_h		=	40
	;CRONO (60)
	Global $res_labels_CRONO1_top	=	502
	Global $res_labels_CRONO1_left	=	25
	Global $res_labels_CRONO2_top	=	515
	Global $res_labels_CRONO2_left	=	25
	Global $res_labels_CRONO_w		=	16
	Global $res_labels_CRONO_h		=	24
	;PAGES MENU ITEM 00/00
	Global $res_labels_page1_left=685
	Global $res_labels_page2_left=698
	Global $res_labels_page3_left=725
	Global $res_labels_page4_left=738
	Global $res_labels_pageBar_left=710

	Global $res_labels_page_top=25
	Global $res_labels_page_w=16
	Global $res_labels_page_h=24

	;NUMEROS DO MENU PRINCIPAL 001..002..003
	Global $res_labels_itens001_left	=	48
	Global $res_labels_itens002_left	=	61
	Global $res_labels_itens003_left	=	74

	Global $res_labels_itens000_top		=	126
	Global $res_labels_itens000_w		=	16
	Global $res_labels_itens000_h		=	24

	Global $res_labels_itens000_save	=	$res_labels_itens000_top
	Global $res_labels_itens000_space	= 	47


	;FICHAS CASE
	Global $res_labels_fichasCase1_left=540
	Global $res_labels_fichasCase2_left=555
	Global $res_labels_fichasCase3_left=570
	Global $res_labels_fichasCase4_left=585
	Global $res_labels_fichasCase5_left=600
	Global $res_labels_fichasCase_top  =192
	Global $res_labels_fichasCase_W  =16
	Global $res_labels_fichasCase_H  =24


	;MENU KEEP BOOK
	Global $Select_TOP_BOOK    		= 165
	Global $SELECT_BARRA_POS_BOOK   = $Select_TOP_BOOK
	Global $Select_ADC_BOOK    		= 97
	;EXCLUDE ICON
	Global $res_labels_exclude_left  	=48
	Global $res_labels_exclude_top   	=124
	Global $res_labels_exclude_W     	=30
	Global $res_labels_exclude_H     	=30
	Global $res_labels_exclude_top_save = $res_labels_exclude_top


	;GAMER LIST TOTAL/REMOVER/ADD
	Global $res_labels_GameListA1_left=515
	Global $res_labels_GameListA2_left=528
	Global $res_labels_GameListA3_left=541
	Global $res_labels_GameListA4_left=554

	Global $res_labels_GameListB1_left=710
	Global $res_labels_GameListB2_left=723
	Global $res_labels_GameListB3_left=736
	Global $res_labels_GameListB4_left=749


	Global $res_labels_GameListA_top=194
	Global $res_labels_GameListB_top=194


	Global $res_labels_GameList_W=16
	Global $res_labels_GameList_H=24

	;PASSWORD ITENS NUMEROS
	Global $Res_PasswordNumb_top=250
	Global $Res_PasswordNumb_left=40
	Global $Res_PasswordNumb_W=29
	Global $Res_PasswordNumb_H=40
	Global $Res_PasswordNumb_top_SAVE=$Res_PasswordNumb_left
	Global $Res_PasswordNumb_space =39


	Global $iMini_SIZEW	= 207
	Global $iMini_SIZEH	= 129

	Global $iMini_TOP 		= 50
	Global $iMini_Left 		= 14
	Global $iMini_W 		= 40
	Global $iMini_H 		= 30
	Global $iMini_ADC		= $iMini_TOP
	Global $iMini_SPACE 	= 37

	Global $iMini_MenuFontS = 26
	Global $iMini_coinTOP 	= 13
	Global $iMini_coinLeft  = 121
	Global $iMini_coinW 	= 70
	Global $iMini_coinH 	= 30

;-----------------------------------------------------------

if $i15hz Then


;-----------------------------------------------------------
	;SNAP VIDEO/IMAGE - AREA
	$Video_top =49
	$Video_left=184
	$Video_W   =194
	$Video_H   =114
	;BARRA DE SELEÇÃO1 -MEDIDAS-
	$Select_LEFT   	 = 4
	$Select_TOP    	 = 50
	$Select_HEIGHT 	 = 21
	$Select_WIDTH  	 = 156
	$SELECT_BARRA_POS= $Select_TOP
	$Select_ADC_SAVE = 19
	$Select_ADC      = $Select_ADC_SAVE
	$Select_TOP_EXTRA= 3
	;BARRA DE SELEÇÃO2 (MENU 2)
	Global $Select2_LEFT   = 5
	Global $Select2_TOP    = 50
	Global $Select2_HEIGHT = 18
	Global $Select2_WIDTH  = 15
	Global $Select2_POS    = $Select_TOP
	Global $Select2_ADC    = 19
	;BARRA DE SELEÇÃO2 (MENU PASSWORD)
	Global $Select3_TOP	  =132
	Global $Select3_LEFT  =7
	Global $Select3_HEIGHT= 18
	Global $Select3_WIDTH = 15
	Global $Select3_POS   = $Select3_LEFT
	$Select3_ADC		  = 19
	;ITENS NOMES LISTA
	Global $Itens_Lista_top	  = 52
	Global $Itens_Lista_left  = 32
	Global $Itens_Lista_width = 130
	Global $Itens_Lista_height= 20
	Global $Itens_Lista_top_S = $Itens_Lista_top
	Global $Itens_Lista_space = 19
	;MENU CONFIG ITENS
	Global $res_labels_pulse_topY=77
	Global $res_labels_pulse_topX =127
	Global $res_labels_pulse_buttonY=$res_labels_pulse_topY+13
	Global $res_labels_pulse_buttonX=$res_labels_pulse_topX+70

	Global $res_labels_Exit_mod_topY=95
	Global $res_labels_Exit_mod_topX=125
	Global $res_labels_Exit_mod_buttonY=$res_labels_Exit_mod_topY+11
	Global $res_labels_Exit_mod_buttonX=$res_labels_Exit_mod_topX+74

	Global $res_labels_auto_exit_topY=114
	Global $res_labels_auto_exit_topX=112
	Global $res_labels_auto_exit_buttonY=$res_labels_auto_exit_topY+11
	Global $res_labels_auto_exit_buttonX=$res_labels_auto_exit_topX+95

	Global $res_labels_SelectGM_topY=132
	Global $res_labels_SelectGM_topX=137
	Global $res_labels_SelectGM_buttonY=$res_labels_SelectGM_topY+11
	Global $res_labels_SelectGM_buttonX=$res_labels_SelectGM_topX+62
	;CRONO
	Global $res_labels_CRONO1_top	=	218
	Global $res_labels_CRONO1_left	=	20
	Global $res_labels_CRONO2_top	=	225
	Global $res_labels_CRONO2_left	=	20
	Global $res_labels_CRONO_w		=	7
	Global $res_labels_CRONO_h		=	10
	;PAGES
	Global $res_labels_page1_left=333
	Global $res_labels_page2_left=340
	Global $res_labels_page3_left=354
	Global $res_labels_page4_left=361
	Global $res_labels_pageBar_left=347

	Global $res_labels_page_top=20
	Global $res_labels_page_w=7
	Global $res_labels_page_h=10
	;Não sei
	Global $res_labels_itens001_left	=	10
	Global $res_labels_itens002_left	=	17
	Global $res_labels_itens003_left	=	24

	Global $res_labels_itens000_top		=	58
	Global $res_labels_itens000_w		=	7
	Global $res_labels_itens000_h		=	10

	Global $res_labels_itens000_save	=	$res_labels_itens000_top
	Global $res_labels_itens000_space	= 	19

	;FICHAS LABEL
	Global $res_labels_fichas1_left	=	308
	Global $res_labels_fichas2_left	=	320
	Global $res_labels_fichas_top	=	181
	Global $res_labels_fichas_w		=	12
	Global $res_labels_fichas_h		=	17
	;FICHAS CASE (MENU 2)
	Global $res_labels_fichasCase1_left=284
	Global $res_labels_fichasCase2_left=291
	Global $res_labels_fichasCase3_left=298
	Global $res_labels_fichasCase4_left=305
	Global $res_labels_fichasCase5_left=312

	Global $res_labels_fichasCase_top  =77
	Global $res_labels_fichasCase_W    =7
	Global $res_labels_fichasCase_H    =10
	;MENU KEEP BOOK (PONTEIRO DE SELEÇÃO)
	Global $Select_TOP_BOOK    		= 75
;~ 	Global $SELECT_BARRA_POS_BOOK   = $Select_TOP_BOOK
	Global $Select_ADC_BOOK    		= 30

	;EXCLUDE ICON
	Global $res_labels_exclude_left  	=12
	Global $res_labels_exclude_top   	=54
	Global $res_labels_exclude_W     	=16
	Global $res_labels_exclude_H     	=16
	Global $res_labels_exclude_top_save = $res_labels_exclude_top


;GAMER LIST TOTAL/REMOVER/ADD
	Global $res_labels_GameListA1_left=305
	Global $res_labels_GameListA2_left=312
	Global $res_labels_GameListA3_left=319
	Global $res_labels_GameListA4_left=326

	Global $res_labels_GameListB1_left=305
	Global $res_labels_GameListB2_left=312
	Global $res_labels_GameListB3_left=319
	Global $res_labels_GameListB4_left=326

	Global $res_labels_GameListA_top=79
	Global $res_labels_GameListB_top=95
	Global $res_labels_GameList_W=7
	Global $res_labels_GameList_H=10
	;PASSWORD ITENS NUMEROS
	Global $Res_PasswordNumb_top=110
	Global $Res_PasswordNumb_left=10
	Global $Res_PasswordNumb_W=12
	Global $Res_PasswordNumb_H=17
	Global $Res_PasswordNumb_top_SAVE=$Res_PasswordNumb_left
	Global $Res_PasswordNumb_space =19


;DIRECIONAIS
	;DIRECIONAIS
	;PLAY 1
	$res_buttonsUP1_LEFT      =98
	$res_buttonsUP1_RIGHT     =111
	$res_buttonsUP1_RSOUCE_AX =36
	$res_buttonsUP1_RSOUCE_AY =70
	$res_buttonsUP1_W		  =11
	$res_buttonsUP1_H		  =14

	$res_buttonsDOWN1_LEFT      =98
	$res_buttonsDOWN1_RIGHT     =132
	$res_buttonsDOWN1_RSOUCE_AX =49
	$res_buttonsDOWN1_RSOUCE_AY =70
	$res_buttonsDOWN1_W		    =11
	$res_buttonsDOWN1_H		    =14

	$res_buttonsLEFT1_LEFT      =86
	$res_buttonsLEFT1_RIGHT     =123
	$res_buttonsLEFT1_RSOUCE_AX =6
	$res_buttonsLEFT1_RSOUCE_AY =73
	$res_buttonsLEFT1_W		    =14
	$res_buttonsLEFT1_H		    =11

	$res_buttonsRIGHT1_LEFT       =107
	$res_buttonsRIGHT1_RIGHT      =123
	$res_buttonsRIGHT1_RSOUCE_AX  =21
	$res_buttonsRIGHT1_RSOUCE_AY  =73
	$res_buttonsRIGHT1_W		  =14
	$res_buttonsRIGHT1_H		  =11


	;PLAY 2
	$res_buttonsUP2_LEFT      =274
	$res_buttonsUP2_RIGHT     =111
	$res_buttonsUP2_RSOUCE_AX =36
	$res_buttonsUP2_RSOUCE_AY =70
	$res_buttonsUP2_W		  =11
	$res_buttonsUP2_H		  =14

	$res_buttonsDOWN2_LEFT      =274
	$res_buttonsDOWN2_RIGHT     =132
	$res_buttonsDOWN2_RSOUCE_AX =49
	$res_buttonsDOWN2_RSOUCE_AY =70
	$res_buttonsDOWN2_W		    =11
	$res_buttonsDOWN2_H		    =14

	$res_buttonsLEFT2_LEFT      =262
	$res_buttonsLEFT2_RIGHT     =123
	$res_buttonsLEFT2_RSOUCE_AX =6
	$res_buttonsLEFT2_RSOUCE_AY =73
	$res_buttonsLEFT2_W		    =14
	$res_buttonsLEFT2_H		    =11

	$res_buttonsRIGHT2_LEFT       =283
	$res_buttonsRIGHT2_RIGHT      =123
	$res_buttonsRIGHT2_RSOUCE_AX  =21
	$res_buttonsRIGHT2_RSOUCE_AY  =73
	$res_buttonsRIGHT2_W		  =14
	$res_buttonsRIGHT2_H		  =11
;-------------------------------------------




		;PLAYER 1 BUTTONS
			;A
			$res_buttonsA_LEFT		 = 29
			$res_buttonsA_RIGHT		 = 166
			$res_buttonsA_RSOUCE_AX  = 26
			$res_buttonsA_RSOUCE_AY  = 16
			$res_buttonsA_RSOUCE_AX_GREEN= 26
			$res_buttonsA_RSOUCE_AY_GREEN= 43
			$res_buttonsA_W			 = 23
			$res_buttonsA_H			 = 23
			;B
			$res_buttonsB_LEFT		 = 53
			$res_buttonsB_RIGHT		 = 166
			$res_buttonsB_RSOUCE_AX  = 51
			$res_buttonsB_RSOUCE_AY  = 16
			$res_buttonsB_RSOUCE_AX_GREEN= 51
			$res_buttonsB_RSOUCE_AY_GREEN= 43
			$res_buttonsB_W			 = 23
			$res_buttonsB_H			 = 23
			;C
			$res_buttonsC_LEFT		 = 77
			$res_buttonsC_RIGHT		 = 166
			$res_buttonsC_RSOUCE_AX  = 77
			$res_buttonsC_RSOUCE_AY  = 16
			$res_buttonsC_RSOUCE_AX_GREEN= 77
			$res_buttonsC_RSOUCE_AY_GREEN= 43
			$res_buttonsC_W			 = 23
			$res_buttonsC_H			 = 23
			;D
			$res_buttonsD_LEFT		 = 100
			$res_buttonsD_RIGHT		 = 166
			$res_buttonsD_RSOUCE_AX  = 102
			$res_buttonsD_RSOUCE_AY  = 16
			$res_buttonsD_RSOUCE_AX_GREEN   = 102
			$res_buttonsD_RSOUCE_AY_GREEN   = 43
			$res_buttonsD_W			 = 23
			$res_buttonsD_H			 = 23
			;E
			$res_buttonsE_LEFT		 = 124
			$res_buttonsE_RIGHT		 = 166
			$res_buttonsE_RSOUCE_AX  = 128
			$res_buttonsE_RSOUCE_AY  = 16
			$res_buttonsE_RSOUCE_AX_GREEN   = 128
			$res_buttonsE_RSOUCE_AY_GREEN   = 43
			$res_buttonsE_W			 = 23
			$res_buttonsE_H			 = 23
			;E
			$res_buttonsF_LEFT		 = 148
			$res_buttonsF_RIGHT		 = 166
			$res_buttonsF_RSOUCE_AX  = 153
			$res_buttonsF_RSOUCE_AY  = 16
			$res_buttonsF_RSOUCE_AX_GREEN   = 153
			$res_buttonsF_RSOUCE_AY_GREEN   = 43
			$res_buttonsF_W			 = 23
			$res_buttonsF_H			 = 23

	;PLAYER 2 BUTTONS
			;A
			$res_buttonsA2_LEFT		 = 212
			$res_buttonsA2_RIGHT		 = 166
			$res_buttonsA2_RSOUCE_AX  = 26
			$res_buttonsA2_RSOUCE_AY  = 16
			$res_buttonsA2_RSOUCE_AX_GREEN   = 26
			$res_buttonsA2_RSOUCE_AY_GREEN   = 43
			$res_buttonsA2_W			 = 23
			$res_buttonsA2_H			 = 23
			;B
			$res_buttonsB2_LEFT		 = 236
			$res_buttonsB2_RIGHT		 = 166
			$res_buttonsB2_RSOUCE_AX  = 51
			$res_buttonsB2_RSOUCE_AY  = 16
			$res_buttonsB2_RSOUCE_AX_GREEN   = 51
			$res_buttonsB2_RSOUCE_AY_GREEN   = 43
			$res_buttonsB2_W			 = 23
			$res_buttonsB2_H			 = 23
			;C
			$res_buttonsC2_LEFT		 = 260
			$res_buttonsC2_RIGHT		 = 166
			$res_buttonsC2_RSOUCE_AX  = 77
			$res_buttonsC2_RSOUCE_AY  = 16
			$res_buttonsC2_RSOUCE_AX_GREEN   = 77
			$res_buttonsC2_RSOUCE_AY_GREEN   = 43
			$res_buttonsC2_W			 = 23
			$res_buttonsC2_H			 = 23
			;D
			$res_buttonsD2_LEFT		 = 283
			$res_buttonsD2_RIGHT		 = 166
			$res_buttonsD2_RSOUCE_AX  = 102
			$res_buttonsD2_RSOUCE_AY  = 16
			$res_buttonsD2_RSOUCE_AX_GREEN   = 102
			$res_buttonsD2_RSOUCE_AY_GREEN   = 43
			$res_buttonsD2_W			 = 23
			$res_buttonsD2_H			 = 23
			;E
			$res_buttonsE2_LEFT		 = 307
			$res_buttonsE2_RIGHT		 = 166
			$res_buttonsE2_RSOUCE_AX  = 128
			$res_buttonsE2_RSOUCE_AY  = 16
			$res_buttonsE2_RSOUCE_AX_GREEN   = 128
			$res_buttonsE2_RSOUCE_AY_GREEN   = 43
			$res_buttonsE2_W			 = 23
			$res_buttonsE2_H			 = 23
			;E
			$res_buttonsF2_LEFT		  = 331
			$res_buttonsF2_RIGHT	  = 166
			$res_buttonsF2_RSOUCE_AX  = 153
			$res_buttonsF2_RSOUCE_AY  = 16
			$res_buttonsF2_RSOUCE_AX_GREEN   = 153
			$res_buttonsF2_RSOUCE_AY_GREEN   = 43
			$res_buttonsF2_W			 = 23
			$res_buttonsF2_H			 = 23
	;----------------
			;START 1 (BUTTON)
			$res_buttonsS1_LEFT		  = 148
			$res_buttonsS1_RIGHT	  = 85
			$res_buttonsS1_RSOUCE_AX  = 0
			$res_buttonsS1_RSOUCE_AY  = 16
			$res_buttonsS1_RSOUCE_AX_GREEN   = 0
			$res_buttonsS1_RSOUCE_AY_GREEN   = 43
			$res_buttonsS1_W			 =23
			$res_buttonsS1_H			 = 23
			;START 2 (BUTTON)
			$res_buttonsS2_LEFT		 = 211
			$res_buttonsS2_RIGHT	 = 85
			$res_buttonsS2_RSOUCE_AX = 0
			$res_buttonsS2_RSOUCE_AY = 16
			$res_buttonsS2_RSOUCE_AX_GREEN  = 0
			$res_buttonsS2_RSOUCE_AY_GREEN  = 43
			$res_buttonsS2_W			 = 23
			$res_buttonsS2_H			 = 23
			;MENU (BUTTON)
			$res_buttonsS3_LEFT		 = 331
			$res_buttonsS3_RIGHT	 = 85
			$res_buttonsS3_RSOUCE_AX = 0
			$res_buttonsS3_RSOUCE_AY = 16
			$res_buttonsS3_RSOUCE_AX_GREEN  = 0
			$res_buttonsS3_RSOUCE_AY_GREEN  = 43
			$res_buttonsS3_W		 = 23
			$res_buttonsS3_H		 = 23
			;COINS (BUTTON)
			$res_buttonsS4_LEFT		 = 29
			$res_buttonsS4_RIGHT	 = 85
			$res_buttonsS4_RSOUCE_AX = 0
			$res_buttonsS4_RSOUCE_AY = 16
			$res_buttonsS4_RSOUCE_AX_GREEN  = 0
			$res_buttonsS4_RSOUCE_AY_GREEN  = 43
			$res_buttonsS4_W			 = 23
			$res_buttonsS4_H			 = 23

			;START 1 (TEXT)
			$res_buttonsG1_LEFT		 = 129
			$res_buttonsG1_RIGHT	 = 110
			$res_buttonsG1_RSOUCE_AX = 33
			$res_buttonsG1_RSOUCE_AY = 0
			$res_buttonsG1_W			 = $res_buttonsG1_RSOUCE_AX+58
			$res_buttonsG1_H			 = $res_buttonsG1_RSOUCE_AY+13
			;START 2 (TEXT)
			$res_buttonsG2_LEFT		 = 195
			$res_buttonsG2_RIGHT	 = 110
			$res_buttonsG2_RSOUCE_AX = 94
			$res_buttonsG2_RSOUCE_AY = 0
			$res_buttonsG2_W		 = $res_buttonsG2_RSOUCE_AX+59
			$res_buttonsG2_H		 = $res_buttonsG2_RSOUCE_AY+13
			;MENU (TEXT)
			$res_buttonsG3_LEFT		 = 314
			$res_buttonsG3_RIGHT	 = 110
			$res_buttonsG3_RSOUCE_AX = 155
			$res_buttonsG3_RSOUCE_AY = 0
			$res_buttonsG3_W		 = $res_buttonsG3_RSOUCE_AX+50
			$res_buttonsG3_H		 = $res_buttonsG3_RSOUCE_AY+13
			;COINS (TEXT)
			$res_buttonsG4_LEFT		 = 25
			$res_buttonsG4_RIGHT	 = 110
			$res_buttonsG4_RSOUCE_AX = 0
			$res_buttonsG4_RSOUCE_AY = 0
			$res_buttonsG4_W		 = $res_buttonsG4_RSOUCE_AX+31
			$res_buttonsG4_H		 = $res_buttonsG4_RSOUCE_AY+13

;MINI MENU
	Global $iMini_SIZEW	= 118
	Global $iMini_SIZEH	= 66

	Global $iMini_TOP 		= 24
	Global $iMini_Left 		= 14
	Global $iMini_W 		= 15
	Global $iMini_H 		= 18

	Global $iMini_ADC		= $iMini_TOP
	Global $iMini_SPACE 	= 19

	Global $iMini_MenuFontS = 14
	Global $iMini_coinTOP 	= 4
	Global $iMini_coinLeft  = 70
	Global $iMini_coinW 	= 38
	Global $iMini_coinH 	= 20

;-----------------------------------------------------------
EndIf


;INFO VIDEO-REPRODUÇAO
Global $SNAPS = @ScriptDir & "\Snaps\"
Global $iVideo[2]
Global $info_play = True
Global $Snap_image
Global $Snap_check = False



Global $GAME_SELECTED = 1
Global $PAGE=1
Global $PAGE_FIRST=1

;PASSWORD MENU INFO
Global $DEFAUT_PAS = True
Global $CUR_PASSWORD[8] = [0,0,0,0,0,0,0,0]
if $GERAL_PASS <> 0 Then
	$DEFAUT_PAS = False
	Local $iGetPass = StringFormat("%08s", $GERAL_PASS)

	for $i=0 to UBound($CUR_PASSWORD)-1
		$CUR_PASSWORD[$i] = StringMid($iGetPass,$i+1,1)
	Next
EndIf

;~ Global $iNumb = 40
Global $iPassPos=0
Global $iPassPosMax=7
Global $RED_PASSWORD[8] = [0,0,0,0,0,0,0,0]
Global $NEW_PASSWORD[8] = [0,0,0,0,0,0,0,0]
Global $CHEK_PASSWORD[8]= [0,0,0,0,0,0,0,0]

Global $PASS_CHECK = False
Global $PASS_CHECK2= False
;-----------------------------------------------------------------
Global $MENU_MAXITENS = 9
Global $ITEM_MENU_SELECIONADO = 1

Global $Bt_MENU   = "4D"
Global $Bt_DOWN   = "28"
Global $Bt_UP     = "26"
Global $Bt_COIN   = "43"
Global $Bt_SELECT = "0D"
Global $Bt_BACK	  = "11"
Global $Bt_LEFT	  = "25"
Global $Bt_RIGHT  = "27"
Global $iConf 	= False
Global $PRESSED = False
Global $MENU_SELECIONADO = 0
;-----------------------------------------------------------------
;SONS

;-----------------------
Local $hInstance = _WinAPI_LoadLibraryEx(@ScriptDir & "\bin\date.dll", $LOAD_LIBRARY_AS_DATAFILE)
If Not $hInstance Then
    MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), 'Error', @ScriptDir & '\bin\date.dll not found.')
    Exit
EndIf
		;------
		;CLICK1
		$hResource = _WinAPI_FindResource($hInstance, 'SOUND', 4)
		$iSize = _WinAPI_SizeOfResource($hInstance, $hResource)
		$hData = _WinAPI_LoadResource($hInstance, $hResource)
		$pData = _WinAPI_LockResource($hData)
;~ 		; Copy WAV to memory for use later
		Local $hWave = _MemGlobalAlloc($iSize, $GMEM_MOVEABLE)
		Local $SOUND_CLICK = _MemGlobalLock($hWave)
		_MemMoveMemory($pData, $SOUND_CLICK, $iSize)
		;------
		;CLICK2
		$hResource = _WinAPI_FindResource($hInstance, 'SOUND', 1)
		$iSize = _WinAPI_SizeOfResource($hInstance, $hResource)
		$hData = _WinAPI_LoadResource($hInstance, $hResource)
		$pData = _WinAPI_LockResource($hData)
		;Copy WAV to memory for use later
		Local $hWave = _MemGlobalAlloc($iSize, $GMEM_MOVEABLE)
		Local $SOUND_OK = _MemGlobalLock($hWave)
		_MemMoveMemory($pData, $SOUND_OK, $iSize)
		;------
		;COIN
		$hResource = _WinAPI_FindResource($hInstance, 'SOUND', 2)
		$iSize = _WinAPI_SizeOfResource($hInstance, $hResource)
		$hData = _WinAPI_LoadResource($hInstance, $hResource)
		$pData = _WinAPI_LockResource($hData)
		; Copy WAV to memory for use later
		Local $hWave = _MemGlobalAlloc($iSize, $GMEM_MOVEABLE)
		Local $SOUND_COIN = _MemGlobalLock($hWave)
		_MemMoveMemory($pData, $SOUND_COIN, $iSize)
		;------
		;KEY
		$hResource = _WinAPI_FindResource($hInstance, 'SOUND', 5)
		$iSize = _WinAPI_SizeOfResource($hInstance, $hResource)
		$hData = _WinAPI_LoadResource($hInstance, $hResource)
		$pData = _WinAPI_LockResource($hData)
		; Copy WAV to memory for use later
		Local $hWave = _MemGlobalAlloc($iSize, $GMEM_MOVEABLE)
		Local $SOUND_KEY = _MemGlobalLock($hWave)
		_MemMoveMemory($pData, $SOUND_KEY, $iSize)
		;------
Global $SOUND_BG = _SoundOpen(@ScriptDir & "\bin\bg.mp3")

		;INFO VIDEO-REPRODUÇAO
Global $SNAPS = @ScriptDir & "\Snaps\"
Global $iVideo[2]
Global $info_play = True
Global $Snap_image
Global $Snap_check = False