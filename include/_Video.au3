#Region ==> UDF Vídeo By: smashly
#include-once
#include <File.au3>
#include <array.au3>
#include <GUIConstantsEx.au3>
;~ $iFiles = _FileListToArray("D:\SCRIPTS AUTOIT\Projeto Frontend\snap\bk snaps\Pandora-SemAudio\","*",1,True)

;~ _ArrayDisplay($iFiles)

;~ 	Local $hGUI = GUICreate("Example",800,600)
;~ 	Local $iVideo[2]
;~     GUISetState(@SW_SHOW, $hGUI)
;~ 	$info = True
;~ 	For $i=1 to $iFiles[0]
;~ 		_Video_Pause($iVideo[$info])
;~ 		$iVideo[$info] = _Video_Open($iFiles[$i], $hGUI, 0, 0,800 , 600)
;~ 		_Video_Play($iVideo[$info])
;~ 		$info = Not $info
;~ 		_Video_Close($iVideo[$info])
;~ 	Next

;~     ; Delete the previous GUI and all controls.
;~     GUIDelete($hGUI)



Global $vRet, $iTicks, $mciLevel, $lpszReturnString,$mciInit
;==================================== #CURRENT FUNCTIONS#==================================================
; _Video_Close
; _Video_Dimension ==> Adicionado
; _Video_FrameRate ==> Adicionado
; _Video_Length
; _Video_Mute
; _Video_Open
; _Video_Pause
; _Video_Play
; _Video_Resume
; _Video_Seek
; _Video_Status  ==> Adicionado
; _Video_Step    ==> Adicionado
; _Video_Stop    ==> Adicionado
; _Video_TimePos
; _Video_Volume  ==> Adicionado
; _RandomStr
; _MSToHMS
; _mciDeviceExists
; _mciListDevices
; _mciSendString
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_Close
; Description....: Close a video.
; Syntax.........: _Video_Close($sAlias)
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
; Return values .: Success    - Return 1 and sets Alias name to "".
;                  Failure    - Return 0 and @error 1~2
;                               @error 1 = Invalid Alias
;                               @error 2 = MCI failed to close video
; Author ........: smashly
Func _Video_Close(ByRef $sAlias)
	 If $sAlias = "" Or StringRegExp($sAlias, "\W|_", 0) Then Return SetError(1, 0, 0)
	 If _mciSendString("close " & $sAlias) = 0 Then
		 $sAlias = ""
		 Return SetError(0, 0, 1)
	   Else
		 Return SetError(2, 0, 0)
     EndIf
EndFunc   ;==>_Video_Close
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_Dimension
; Description....: Retrieves the Width and Height of the source video.
; Syntax.........: _Video_Dimension($sFile)
; Parameters ....: $sFile     - The full path to video file.
; Return values .: Success    - Returns an array. array[0] = Width, array[1] = Height
;                  Failure    - Return 0 and @error 1~3
;                               @error 1 = File doesn't exist.
;                               @error 2 = MCI failed to open the video file.
;                               @error 3 = MCI failed to get the source video dimensions.
; Author ........: smashly
Func _Video_Dimension($sFile)
	 Local $iRet, $sVID, $aTmp
	 If Not FileExists($sFile) Then Return SetError(1, 0, 0)
	 $sVID = _RandomStr()
	 $iRet = _mciSendString("open " & FileGetShortName($sFile) & " alias " & $sVID)
	 If $iRet <> 0 Then Return SetError(2, 0, 0)
	 $iRet = _mciSendString("where " & $sVID & " source", 255)
	 If $iRet = "" Then
		 _mciSendString("close " & $sVID)
		 Return SetError(3, 0, 0)
	 EndIf
	 _mciSendString("close " & $sVID)
	 $aTmp = StringSplit($iRet, Chr(32))
	 $aTmp[1] = $aTmp[$aTmp[0]]
	 $aTmp[0] = $aTmp[$aTmp[0] - 1]
	 ReDim $aTmp[2]
	 Return $aTmp
EndFunc   ;==>_Video_Dimension
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_FrameRate
; Description....: Close a video.
; Syntax.........: _Video_FrameRate($sAlias)
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
; Return values .: Success    - Returns the Frames Per Second of the video.
;                  Failure    - Return 0 and @error 1
;                               @error 1 = Invalid Alias
; Author ........: smashly
Func _Video_FrameRate($sAlias)
	 If $sAlias = "" Or StringRegExp($sAlias, "\W|_", 0) Then Return SetError(1, 0, 0)
	 Return _mciSendString("status " & $sAlias & " nominal frame rate", 255) / 1000
EndFunc   ;==>_Video_FrameRate
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_Length
; Description....: Get the time length of a video in Milliseconds or Hours, Minutes, Seconds (HH:MM:SS)
; Syntax.........: _Video_Length($sAlias[, $iTime = 0])
; Parameters ....: $sAlias    - Alias name returned by _Video_Open
;				   $iTime     - 0 Return time lenth in Hours, Minutes, Seconds (HH:MM:SS)
;						      - 1 Return time lenth in Milliseconds.
; Return values .: Success    - Return time length in Milliseconds or Hours, Minutes, Seconds (HH:MM:SS)
;                  Failure    - Return 0 and @error 1
;                               @error 1 = Invalid Alias
; Author ........: smashly
Func _Video_Length($sAlias, $iTime = 0)
	 Local $iMS
	 If $sAlias = "" Or StringRegExp($sAlias, "\W|_", 0) Then Return SetError(1, 0, 0)
	 _mciSendString("set " & $sAlias & " time format ms")
	 $iMS = _mciSendString("status " & $sAlias & " length", 255)
	 If Not $iTime Then Return _MSToHMS($iMS)
	 If $iTime Then Return $iMS
EndFunc   ;==>_Video_Length
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_Mute
; Description....: Turn off/on the audio in a video.
; Syntax.........: _Video_Mute($sAlias[, $iMute = 0])
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
;                  $iAudio    - 0 = Audio On, 1 = Audio Off
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~2
;                               @error 1 = Invalid Alias
;                               @error 2 = MCI failed to turn the video audio off/on
; Author ........: smashly
Func _Video_Mute($sAlias, $iMute = 0)
     Local $iRet, $iAM = "on"
     If $sAlias = "" Or StringRegExp($sAlias, "\W|_", 0) Then Return SetError(1, 0, 0)
	 If $iMute Then $iAM = "off"
	 $iRet = _mciSendString("set " & $sAlias & " audio all " & $iAM)
	 If $iRet = 0 Then
		 Return SetError(0, 0, 1)
	   Else
		 Return SetError(2, 0, 0)
     EndIf
EndFunc   ;==>_Video_Mute
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_Open
; Description ...: Opens a Video file ready for use with other _Video_xxxx functions.
; Syntax.........: _Video_Open($sFile, $hWnd, $iX, $iY, $iW, $iH[, $sDevice = ""])
; Parameters ....: $sFile     - The full path to video file.
;                  $hWnd      - Handle to a window or control that the video will be displayed on
;                  $iX        - Left position of the video.
;                  $iY        - Top position of the video.
;                  $iW        - Width of the video.
;                  $iH        - Height of the video.
;                  $sDevice   - MCI Device type to play video with. (See Remarks for more info)
; Return values .: Success    - Return an Alias name for use with other _Video_xxxx functions.
;                  Failure    - Return an empty String "" and @error 1~5
;                               @error 1 = File doesn't exist
;                               @error 2 = Window or Control handle not valid.
;                               @error 3 = Invalid MCI Device type specified.
;                               @error 4 = MCI failed to open video file
;                               @error 5 = MCI failed window for video.
;                               @error 5 = MCI failed to put video at the deignated location.
;
; Remarks .......: If your having trouble with avi playback (eg; playing fast, slow, choppy or no audio)
;                  or a video won't play but it plays fine in any other player ...
;                  Then set the $sDevice parameter to "MPEGVideo"
;                  If the $sDevice parameter is left blank then windows will decide which MCI Device type
;                  to use.
;                  Most current day avi/wmv/mp4 formats dont play properly or at all when windows selects
;                  the mci device type to use.
;                  Windows would default use "AVIVideo" MCI Device type to play avi with mci.
;                  When you specify "MPEGVideo" for an avi and mci fails it then uses the windows native
;                  chain of codecs that would be used by any other player not using mci ;)
;                  Because of this behaviour you can usually play almost any type of video that normally
;                  fails when using mci just by specifying "MPEGVideo" mci device type.
;                  For playing video on an autoit gui then be sure to add the $WS_CLIPCHILDREN style
;                  to your Gui. This will keep the Video dislpayed on your Gui all the time.
; PT-BR :: Observações:
; ... Se você tiver problemas com a reprodução avi (por exemplo, jogar rápido, lento, intermitente ou sem áudio)
; Ou um vídeo não será reproduzido, mas reproduz bem em qualquer outro player ...
; Em seguida, defina o parâmetro $sDevice como "MPEGVideo"
; Se o parâmetro $sDevice for deixado em branco, o Windows decidirá qual tipo de dispositivo MCI usar.
; A maioria dos formatos atuais de avi / wmv / mp4 não jogam corretamente ou quando o Windows seleciona
; O tipo de dispositivo mci a ser usado.
; Windows usaria padrão "AVIVideo" tipo de dispositivo MCI para jogar avi com mci.
; Quando você especifica "MPEGVideo" para um avi e mci falha, em seguida, usa as janelas nativas
; Cadeia de codecs que seriam usados ??por qualquer outro jogador que não usasse mci;)
; Devido a esse comportamento, você geralmente pode reproduzir quase qualquer tipo de vídeo que normalmente
; Falha ao usar mci apenas especificando "MPEGVideo" tipo de dispositivo mci.
; Para reproduzir o vídeo em um gui autoit, então certifique-se de adicionar o estilo $WS_CLIPCHILDREN
; Para o seu Gui. Isto manterá o vídeo dislpayed em seu Gui todo o tempo.
;
; Author ........: smashly
Func _Video_Open($sFile, $hWnd, $iX, $iY, $iH, $iW, $sDevice = "MPEGVideo")
	 Local $sVID, $gId, $iRet, $sDT = ""
	 If Not FileExists($sFile) Then Return SetError(1, 0, "")
	 If Not IsHWnd($hWnd) Then Return SetError(2, 0, "")
	 If $sDevice <> "" Then
	 	 If Not _mciDeviceExists($sDevice) Then Return SetError(3, 0, "")
	 	 $sDT = " type " & $sDevice
	 EndIf
	 $gId = Dec(StringTrimLeft($hWnd, 2))
	 $sVID = _RandomStr()
	 $iRet = _mciSendString("open " & FileGetShortName($sFile) & " alias " & $sVID & $sDT)
	 If $iRet <> 0 Then Return SetError(4, 0, "")
	 $iRet = _mciSendString("window " & $sVID & " handle " & $gId)
	 If $iRet <> 0 Then
	 	 _mciSendString("close " & $sVID)
	 	 Return SetError(5, 0, "")
	 EndIf
	 $iRet = _mciSendString("put " & $sVID & " destination at " & $iX & " " & $iY & " " & $iH & " " & $iW)
	 If $iRet <> 0 Then
	 	 _mciSendString("close " & $sVID)
	 	 Return SetError(6, 0, "")
	 EndIf
	 Return SetError(0, 0, $sVID)
EndFunc   ;==>_Video_Open
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_Pause
; Description....: Pause a Video at the current playing position.
; Syntax.........: _Video_Pause($sAlias)
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~2
;                               @error 1 = Invalid Alias
;                               @error 2 = Failed to pause video.
; Author ........: smashly
Func _Video_Pause($sAlias)
	Local $iRet
	If $sAlias = "" Or StringRegExp($sAlias, "\W|_", 0) Then Return SetError(1, 0, 0)
	$iRet = _mciSendString("pause " & $sAlias)
	If $iRet = 0 Then
		Return SetError(0, 0, 1)
	Else
		Return SetError(2, 0, 0)
	EndIf
EndFunc   ;==>_Video_Pause
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_Play
; Description....: Plays a Video from the current position.
; Syntax.........: _Video_Play($sAlias[, $iMode = 0])
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
;                  $iMode     - 0 play video on the window or control as specified in _Video_Open
;                             - 1 play video in Fullscreen mode.
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~2
;                               @error 1 = Invalid Alias
;                               @error 2 = MCI failed to play video.
; Author ........: smashly
Func _Video_Play($sAlias, $iMode = 0)
     Local $iRet
     If $sAlias = "" Or StringRegExp($sAlias, "\W|_", 0) Then Return SetError(1, 0, 0)
     If _Video_TimePos($sAlias, 1) = _Video_Length($sAlias, 1) Then _Video_Seek($sAlias, "start")
     If $iMode Then
         $vRet = _mciSendString("play " & $sAlias & " fullscreen")
       Else
         $iRet = _mciSendString("play " & $sAlias)
     EndIf
     If $iRet = 0 Then
         Return SetError(0, 0, 1)
       Else
         Return SetError(1, 0, 0)
     EndIf
EndFunc   ;==>_Video_Play
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_Resume
; Description....: Resume playing a video after pausing.
; Syntax.........: _Video_Resume($sAlias)
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~2
;                               @error 1 = Invalid Alias
;                               @error 2 = MCI failed to resume video.
; Author ........: smashly
Func _Video_Resume($sAlias)
	Local $iRet
	If $sAlias = "" Or StringRegExp($sAlias, "\W|_", 0) Then Return SetError(1, 0, 0)
	$iRet = _mciSendString("resume " & $sAlias)
	If $iRet = 0 Then
		Return SetError(0, 0, 1)
	Else
		Return SetError(2, 0, 0)
	EndIf
EndFunc   ;==>_Video_Resume
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_Seek
; Description....: Seek a video to the specified time position.
; Syntax.........: _Video_Seek($sAlias, $iTime)
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
;                  $iTime     - Time to Seek. Can be Millisecons or HH:MM:SS or "start" or "end"
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~3
;                               @error 1 = Invalid Alias
;                               @error 2 = Invalid time format.
;                               @error 3 = MCI Seek error
; Author ........: smashly
Func _Video_Seek($sAlias, $iTime)
	 Local $iMS, $aTime, $iRet
     If $sAlias = "" Or StringRegExp($sAlias, "\W|_", 0) Then Return SetError(1, 0, 0)
     If StringInStr($iTime, ":") Then
		 $aTime = StringSplit($iTime, ":")
		 If $aTime[0] <> 3 Then Return SetError(2, 0, 0)
		 $iMS = 1000 * ((3600 * $aTime[1]) + (60 * $aTime[2]) + $aTime[3])
     ElseIf StringIsInt($iTime) Or $iTime = "start" Or $iTime = "end" Then
		 $iMS = $iTime
       Else
		 Return SetError(2, 0, 0)
     EndIf
     _mciSendString("set " & $sAlias & " time format ms")
     $iRet = _mciSendString("seek " & $sAlias & " to " & $iMS)
     If $iRet = 0 Then
		 Return SetError(0, 0, 1)
       Else
		 Return SetError(3, 0, 0)
     EndIf
EndFunc   ;==>_Video_Seek
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_Status
; Description....: Get a status status message from a video device.
; Syntax.........: _Video_Status($sAlias[, $sQuery = "mode"])
; Parameters ....: $sAlias    - Alias name returned by _Video_Open
;                  $sQuery    - What to get the status of:
;                               "audio" - returns the "on" or "off"
;                               "mode"  - returns "paused", "playing" and "stopped"
; Return values .: Success    - Returns a Status message from the video device.
;                  Failure    - Return 0 and @error 1
;                               @error 1 = Invalid Alias
;                               @error 2 = Invalid query (To be implemented)
; Author ........: smashly
Func _Video_Status($sAlias, $sQuery = "mode")
	If $sAlias = "" Or StringRegExp($sAlias, "\W|_", 0) Then Return SetError(1, 0, 0)
	;; error check for the $sQuery goes here
	Return _mciSendString("status " & $sAlias & " " & $sQuery, 255)
EndFunc   ;==>_Video_Status
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_Step
; Description....: Step a video forwards or backwards by a number of frames.
; Syntax.........: _Video_Step($sAlias, $iFrames)
; Parameters ....: $sAlias    - Alias name returned by _Video_Open
;                  $iFrames   - The number of frames to step, use negative numbers to step backwards.
; Return values .: Success    - Returns 1 and @error 0
;                  Failure    - Return 0 and @error 1~3
;                               @error 1 = Invalid Alias
;                               @error 2 = Invalid frames
;                               @error 3 = MCI Step error
; Author ........: smashly
Func _Video_Step($sAlias, $iFrames)
	Local $iRet
	If $sAlias = "" Or StringRegExp($sAlias, "\W|_", 0) Then Return SetError(1, 0, 0)
	If StringRegExp(StringReplace($iFrames, "-", ""), '\D', 0) Then Return SetError(2, 0, 0)
	$iRet = _mciSendString("step " & $sAlias & " by " & $iFrames)
	If $iRet = 0 Then
		Return SetError(0, 0, 1)
	Else
		Return SetError(3, 0, 0)
	EndIf
EndFunc   ;==>_Video_Step
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_Stop
; Description....: Stop a Video playing. (seeks video to start)
; Syntax.........: _Video_Stop($sAlias)
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~2
;                               @error 1 = Invalid Alias
;                               @error 2 = Failed to stop or seek
; Author ........: smashly
Func _Video_Stop($sAlias)
	Local $iRet, $iRet2
	If $sAlias = "" Or StringRegExp($sAlias, "\W|_", 0) Then Return SetError(1, 0, 0)
	$iRet = _Video_Seek($sAlias, "start")
	$iRet2 = _mciSendString("stop " & $sAlias)
	If $iRet = 0 And $iRet2 = 0 Then
		Return SetError(0, 0, 1)
	Else
		Return SetError(2, 0, 0)
	EndIf
EndFunc   ;==>_Video_Stop
;==========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_TimePos
; Description....: Get the time poition of a video in Milliseconds or Hours, Minutes, Seconds (HH:MM:SS)
; Syntax.........: _Video_TimePos($sAlias[, $iTime = 0])
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
;                  $iTime     - 0 Return time lenth in Hours, Minutes, Seconds (HH:MM:SS)
;                             - 1 Return time lenth in Milliseconds.
; Return values .: Success    - Return time position in Milliseconds or Hours, Minutes, Seconds (HH:MM:SS)
;                  Failure    - Return 0 and @error 1
;                               @error 1 = Invalid Alias
; Author ........: smashly
Func _Video_TimePos($sAlias, $iTime = 0)
     Local $iMS
     If $sAlias = "" Or StringRegExp($sAlias, "\W|_", 0) Then Return SetError(1, 0, 0)
     _mciSendString("set " & $sAlias & " time format ms")
     $iMS = _mciSendString("status " & $sAlias & " position", 255)
     If Not $iTime Then Return _MSToHMS($iMS)
     If $iTime Then Return $iMS
EndFunc   ;==>_Video_TimePos
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _Video_Volume
; Description....: Turn the video audio volume up or down.
; Syntax.........: _Video_AudioVolume($sAlias[, $iVolume = 100])
; Parameters ....: $sAlias    - Alias name returned by _Video_Open.
;                  $iVolume   - 0 = Min, 100 = Max
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~2
;                               @error 1 = Invalid Alias
;                               @error 2 = Invalid Volume
;                               @error 3 = MCI failed to set volume
; Author ........: smashly
;~ Func _Video_Volume($sAlias, $iVolume = 100)
;~ 	Local $iRet, $iVol
;~ 	If $sAlias = "" Or StringRegExp($sAlias, "\W|_", 0) Then Return SetError(1, 0, 0)
;~ 	If StringRegExp($iVolume, '\D', 0) Then Return SetError(2, 0, 0)
;~ 	If $iVolume >= 100 Then
;~ 		$iVol = 1000
;~ 	ElseIf $iVolume <= 0 Then
;~ 		$iVol = 0
;~ 	ElseIf $iVolume > 0 And $iVolume < 100 Then
;~ 		$iVol = $iVolume * 10
;~ 	EndIf
;~ 	$iRet = _mciSendString("setaudio " & $sAlias & " volume to " & $iVol)
;~ 	If $iRet = 0 Then
;~ 		Return SetError(0, 0, 1)
;~ 	Else
;~ 		Return SetError(3, 0, 0)
;~ 	EndIf
;~ EndFunc   ;==>_Video_Volume

;By PedroWarlock
Func _Video_Volume($sAlias, $iVol=100, $sName = "")

    ;Declare variables
    Local $iRet

    If $iVol >= 0 And $iVol <= 100 Then
        $iVol *= 10 ; vol goes here from 0 - 1000
    EndIf

    Switch $sName
        Case "LEFT"
            $iRet =_mciSendString("setaudio " & $sAlias & " left volume to " & $iVol & " wait")

        Case "RIGHT"
            $iRet = _mciSendString("setaudio " & $sAlias & " right volume to " & $iVol & " wait")

        Case "BASS"
            $iRet = _mciSendString("setaudio " & $sAlias & " bass to " & $iVol & " wait")

        Case "TREBLE"
            $iRet = _mciSendString("setaudio " & $sAlias & " treble to " & $iVol & " wait")

        Case Else ; default 0 ""
            $iRet = _mciSendString("setaudio " & $sAlias & " volume to " & $iVol & " wait")
    EndSwitch

    ;return
    If $iRet = 0 Then
        Return 1
    Else
        Return SetError(1, 0, 0)
    EndIf
EndFunc   ;==>_SoundSetVolume
; =========================================================================================================
;==========================================================================================================
; Internal use functions beyond this point / Funções de uso interno além deste ponto
;==========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _mciDeviceExists
; Description....: Check if a MCI Device type exists
; Syntax.........: _mciDeviceExists($sDevice)
; Parameters ....: $sDevice   - Name of MCI Device type to check for
; Return values .: Success    - Return 1 if MCI Device type exists and @error 0
;                  Failure    - Return 0 if MCI Device type does not exist and @error 1~2
;                               @error 1 = No matching MCI Device type found.
;                               @error 2 = Failed to list any MCI Device types
; Author ........: smashly
Func _mciDeviceExists($sDevice)
	 Local $aDT = _mciListDevices()
	 If @error Then Return SetError(2, 0, 0)
	 For $idx = 1 To $aDT[0]
		 If $sDevice = $aDT[$idx] Then Return SetError(0, 0, 1)
	 Next
	 Return SetError(1, 0, 0)
EndFunc   ;==>_mciDeviceExists
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _mciListDevices
; Description....: List all found MCI Device types in an array
; Syntax.........: _mciListDevices()
; Parameters ....: None
; Return values .: Success    - Return 1D array of found MCI Device types and @error 0
;                               array[0] Number of MCI Device types found
;                               array[n] MCI Device type name
;                  Failure    - Return empty 1D array and @error 1
; Author ........: smashly
Func _mciListDevices()
	 Local $iMD, $sTmp
	 $iMD = _mciSendString("sysinfo all quantity", 255)
	 If StringIsInt($iMD) Then
		 For $idx = 1 To $iMD
			 $sTmp &= _mciSendString("sysinfo all name " & $idx, 255) & Chr(0)
		 Next
		 Return SetError(0, 0, StringSplit(StringTrimRight($sTmp, 1), Chr(0)))
	 EndIf
	 Return SetError(1, 0, StringSplit($sTmp, Chr(0)))
EndFunc   ;==>_mciListDevices
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _mciSendString
; Description....:
; Syntax.........: _mciSendString($string[, $iLen = 0])
; Parameters ....: $string
;                  $iLen
; Return values .:
; Author ........: RazerM
Func _mciSendString($string, $iLen = 0)
	 Local $iRet    ; winmm.dll Fica na Pasta System32.
;~ 	 $iRet = DllCall("winmm.dll", "int", "mciSendStringA", "str", $string, "str", "", "long", $iLen, "long", 0) ; Usado pelo smashly.
     $iRet = DllCall("winmm.dll", "dword", "mciSendStringW", "wstr", $string, "wstr", "", "uint", $iLen, "ptr", 0) ; Usado por jscript.
	 If Not @error Then Return $iRet[2]
EndFunc   ;==>_mciSendString
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _MSToHMS
; Description....: Converts Milliseconds to Hours, Minutes, Seconds
; Syntax.........: _MSToHMS($iMS)
; Parameters ....: $iMS       - Milliseconds to convert
; Return values .: Success    - Returns Hours, Minutes, Seconds (HH:MM:SS)
; Author ........: smashly
Func _MSToHMS($iMS)
	 Local $iHours = 0, $iMins = 0, $iSecs = 0
	 If Number($iMS) > 0 Then
		 $iMS = Round($iMS / 1000)
		 $iHours = Int($iMS / 3600)
		 $iTicks = Mod($iMS, 3600)
		 $iMins = Int($iMS / 60)
		 $iSecs = Round(Mod($iMS, 60))
		 Return StringFormat("%02i:%02i:%02i", $iHours, $iMins, $iSecs)
     EndIf

     Return StringFormat("%02i:%02i:%02i", $iHours, $iMins, $iSecs)
EndFunc   ;==>_MSToHMS
; =========================================================================================================
; #FUNCTION# ==============================================================================================
; Name...........: _RandomStr
; Description....: Creates a random string
; Syntax.........: _RandomStr([$iLen = 10])
; Parameters ....: $iLen      - Length of string to return
; Return values .: Success    - Returns a string of random letters (a~z)
; Author ........: RazerM
Func _RandomStr($iLen = 10)
	 Local $sTmp = ''
	 For $i = 1 To $iLen
		 $sTmp &= Chr(Random(97, 122, 1))
	 Next
	 Return $sTmp
EndFunc   ;==>_RandomStr
; =========================================================================================================
#EndRegion

; #FUNCTION# ====================================================================================================================
; Name ..........: _SoundGetWaveVolume
; Description ...:
; Syntax ........: _SoundGetWaveVolume()
; Parameters ....:
; Return values .: None
; Author ........: PedroWarlock - AutoitScriptBrasil
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Media_SoundGetWaveVolume()
    Local $WaveVol = -1, $p, $ret
    Const $MMSYSERR_NOERROR = 0
    $p = DllStructCreate ("dword")
    If @error Then
        SetError(2)
        Return -2
    EndIf
    $ret = DllCall("winmm.dll", "long", "waveOutGetVolume", "long", -1, "long", DllStructGetPtr ($p))
    If ($ret[0] == $MMSYSERR_NOERROR) Then
        $WaveVol = Round(Dec(StringRight(Hex(DllStructGetData ($p, 1), 8), 4)) / 0xFFFF * 100)
    Else
        SetError(1)
    EndIf
    $Struct=0
    Return $WaveVol
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _SoundSetSpeed
; Description ...:
; Syntax ........: _SoundSetSpeed($sSnd_id, $Speed)
; Parameters ....: $sSnd_id             - a string value.
;                  $Speed               - an unknown value.
; Return values .: None
; Author ........: PedroWarlock - AutoitScriptBrasil
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Media_SetSpeed($sAlias, $Speed)  ;Speed: 1 - 2267, 1000= normal

    If StringInStr($sAlias,'!') Then Return SetError(3, 0, 0)

	   if $speed < 1 then $speed=1
	   if $Speed > 2267 Then $speed=2267
    Local $iRet = _mciSendString("set " & FileGetShortName($sAlias) & " speed "& $speed)
	If $iRet = 0 Then
		Return SetError(0, 0, 1)
	Else
		Return SetError(3, 0, 0)
	EndIf
EndFunc



Func _Media_SaveVideoImage($sAlias,$s_Location)
;~ 	DllCall("winmm.dll","int","mciSendString","str","capture media"&$sSnd_id&" "&FileGetShortName($s_Location),"str","","int",65534,"hwnd",0)
;~ 	If @error Then
;~ 		SetError(1)
;~ 		Return 0
;~ 	Else
;~ 		Return 1
;~ 	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _MicroGetNivel
; Description ...:
; Syntax ........: _MicroGetNivel()
; Parameters ....:
; Return values .: None
; Author ........: PedroWarlock - AutoitScriptBrasil
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Media_MicroGetNivel()
	If Not IsArray($mciInit) Then
		Local $mciInit = _mciSendString('open new type waveaudio alias mywave')
		If $mciInit <> 0 Then Return SetError(3, 0, 0)
	EndIf

	$mciLevel = DllCall('winmm.dll', 'long', 'mciSendStringA', 'str', 'status mywave level', 'str',   "", 'long', 64, 'long', 0) ;Chamada antiga - Precisa ser atualizada
   	if Not IsArray($mciLevel) or @error Then Return SetError(2)
	Return $mciLevel[2]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _Media_MicroRecord
; Description ...:
; Syntax ........: _Media_MicroRecord([$Status = True])
; Parameters ....: $Status              - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........: PedroWarlock - AutoitScriptBrasil
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Media_MicroRecord($Status=True,$filename=@ScriptDir)
	if $Status Then
		_mciSendString("close all")
		_mciSendString("open new type waveaudio alias capture")
		_mciSendString("set capture bitspersample 16") ; 8, etc.
		_mciSendString("set capture samplespersec 22050") ; 44100, etc...
		_mciSendString("set capture channels 1") ; or 2
		_mciSendString("record capture")
	Else
		_mciSendString("stop capture")
		_mciSendString('save capture "' & $filename & '" wait')
		_mciSendString("close capture")
	EndIf
EndFunc

