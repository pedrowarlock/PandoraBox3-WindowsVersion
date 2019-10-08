#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include "InterfaceCall.au3"
Global $CoInitialize = False , $Ole32 = DllOpen("Ole32.dll"),$MsgGraphArray = 0,$StartGraph = 0
Const $WM_GRAPHNOTIFY = $WM_APP + 1
;Video Files (avi|qt|mov|mpg|mpeg|m1v|wmv)
;Audio files (wav|mpa|mp2|mp3|au|aif|aiff|snd)
;MIDI Files (mid|midi|rmi)
;Image Files (jpg|bmp|gif)
;And Other

; #FUNCTION# ====================================================================================================================
; Name ..........: GUICtrlCreateGraph
; Description ...:
; Syntax ........: GUICtrlCreateGraph($Gui, $FileName, $L, $T, $W, $H[, $Style = -1[, $ExStyle = -1[, $Run = True]]])
; Parameters ....: $Gui                 - an unknown value.
;                  $FileName            - an unknown value.
;                  $L                   - an unknown value.
;                  $T                   - an unknown value.
;                  $W                   - an unknown value.
;                  $H                   - an unknown value.
;                  $Style               - [optional] an unknown value. Default is -1.
;                  $ExStyle             - [optional] an unknown value. Default is -1.
;                  $Run                 - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func GUICtrlCreateGraph($Gui,$FileName,$L,$T,$W,$H,$Style = -1,$ExStyle = -1,$Run = True)
;$FileName the name of a media file
if $Style = -1 Then $Style = BitOR($WS_CHILD,$WS_CLIPCHILDREN,$WS_CLIPSIBLINGS)
if $ExStyle = -1 Then $ExStyle = 0
$StrIID_IGraphBuilder = "{56a868a9-0ad4-11ce-b03a-0020af0ba770}"
$StrCLSID_FilterGraph = "{e436ebb3-524f-11ce-9f53-0020af0ba770}"
$NewIGraphBuilder = GetObjFromGuid($StrIID_IGraphBuilder,$StrCLSID_FilterGraph)
if @error Then Return SetError(1,0,0)

if $StartGraph = 0 Then
GUIRegisterMsg($WM_GRAPHNOTIFY,"CREATEGRAPH_WM_MSG")
GUIRegisterMsg($WM_ERASEBKGND,"CREATEGRAPH_WM_MSG")
GUIRegisterMsg($WM_ACTIVATEAPP,"CREATEGRAPH_WM_MSG")
GUIRegisterMsg($WM_DEVMODECHANGE,"CREATEGRAPH_WM_MSG")
GUIRegisterMsg($WM_DISPLAYCHANGE,"CREATEGRAPH_WM_MSG")
GUIRegisterMsg($WM_PALETTECHANGED,"CREATEGRAPH_WM_MSG")
GUIRegisterMsg($WM_PALETTEISCHANGING,"CREATEGRAPH_WM_MSG")
GUIRegisterMsg($WM_QUERYNEWPALETTE,"CREATEGRAPH_WM_MSG")
$StartGraph = 1
ElseIf $StartGraph = 2 Then
GUIRegisterMsg($WM_ERASEBKGND,"CREATEGRAPH_WM_MSG")
GUIRegisterMsg($WM_ACTIVATEAPP,"CREATEGRAPH_WM_MSG")
GUIRegisterMsg($WM_DEVMODECHANGE,"CREATEGRAPH_WM_MSG")
GUIRegisterMsg($WM_DISPLAYCHANGE,"CREATEGRAPH_WM_MSG")
GUIRegisterMsg($WM_PALETTECHANGED,"CREATEGRAPH_WM_MSG")
GUIRegisterMsg($WM_PALETTEISCHANGING,"CREATEGRAPH_WM_MSG")
GUIRegisterMsg($WM_QUERYNEWPALETTE,"CREATEGRAPH_WM_MSG")
GUIRegisterMsg($WM_SYSCOLORCHANGE,"CREATEGRAPH_WM_MSG")
EndIf

Add_Remove_MsgGraphArray($NewIGraphBuilder) ; Add

;-------IGraphBuilder RenderFile Virtual Method Number Is 14;----------------
$Rt = InterfaceCall($NewIGraphBuilder,"long",14,"wstr",$FileName,"ptr",0)
if @error Or $Rt[0] <> 0 Then
Add_Remove_MsgGraphArray($NewIGraphBuilder,2) ; Remove
CtrlGraphRelease($NewIGraphBuilder)
Return SetError(2,0,0)
EndIf
;-------IGraphBuilder RenderFile Virtual Method Number Is 14;----------------

$IVideoWindow = GetIVideoWindow($NewIGraphBuilder)
if @error Then
Add_Remove_MsgGraphArray($NewIGraphBuilder,2) ; Remove
CtrlGraphRelease($NewIGraphBuilder)
Return SetError(3,0,0)
EndIf

$IMediaEventEx =  GetIMediaEventEx($NewIGraphBuilder)
if @error Then
Add_Remove_MsgGraphArray($NewIGraphBuilder,2) ; Remove
CtrlGraphRelease($NewIGraphBuilder,$IVideoWindow)
Return SetError(4,0,0)
EndIf

;-------IMediaEventEx SetNotifyWindow Virtual Method Number Is 14;----------------
$Rt = InterfaceCall($IMediaEventEx,"long",14,"ptr",$Gui,"long",$WM_GRAPHNOTIFY,"ptr",0)
if @error Or $Rt[0] <> 0 Then
Add_Remove_MsgGraphArray($NewIGraphBuilder,2) ; Remove
CtrlGraphRelease($NewIGraphBuilder,$IVideoWindow,$IMediaEventEx)
Return SetError(5,0,0)
EndIf
;-------IMediaEventEx SetNotifyWindow Virtual Method Number Is 14;----------------

;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------
$Rt = InterfaceCall($IVideoWindow,"long",30,"ptr",$Gui)
if @error Or $Rt[0] <> 0 Then
Add_Remove_MsgGraphArray($NewIGraphBuilder,2) ; Remove
CtrlGraphRelease($NewIGraphBuilder,$IVideoWindow,$IMediaEventEx)
Return SetError(6,0,0)
EndIf
;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------

;-------IVideoWindow put_MessageDrain Virtual Method Number Is 32;----------------
$Rt = InterfaceCall($IVideoWindow,"long",32,"ptr",$Gui)
if @error Or $Rt[0] <> 0 Then
Add_Remove_MsgGraphArray($NewIGraphBuilder,2) ; Remove
CtrlGraphRelease($NewIGraphBuilder,$IVideoWindow,$IMediaEventEx)
Return SetError(7,0,0)
EndIf
;-------IVideoWindow put_MessageDrain Virtual Method Number Is 32;----------------

;-------IVideoWindow SetWindowPosition Virtual Method Number Is 40;----------------
$Rt = InterfaceCall($IVideoWindow,"long",40,"long",$L,"long",$T,"long",$W,"long",$H)
if @error Or $Rt[0] <> 0 Then
Add_Remove_MsgGraphArray($NewIGraphBuilder,2) ; Remove
;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------
$Rt = InterfaceCall($IVideoWindow,"long",30,"ptr",0)
;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------
CtrlGraphRelease($NewIGraphBuilder,$IVideoWindow,$IMediaEventEx)
Return SetError(8,0,0)
EndIf
;-------IVideoWindow SetWindowPosition Virtual Method Number Is 40;----------------

;-------IVideoWindow put_WindowStyle Virtual Method Number Is 10;----------------
$Rt = InterfaceCall($IVideoWindow,"long",10,"long",$Style)
if @error Or $Rt[0] <> 0 Then
Add_Remove_MsgGraphArray($NewIGraphBuilder,2) ; Remove
;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------
$Rt = InterfaceCall($IVideoWindow,"long",30,"ptr",0)
;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------
CtrlGraphRelease($NewIGraphBuilder,$IVideoWindow,$IMediaEventEx)
Return SetError(9,0,0)
EndIf
;-------IVideoWindow put_WindowStyle Virtual Method Number Is 10;----------------

;-------IVideoWindow put_WindowStyleEx Virtual Method Number Is 12;----------------
$Rt = InterfaceCall($IVideoWindow,"long",12,"long",$ExStyle)
if @error Or $Rt[0] <> 0 Then
Add_Remove_MsgGraphArray($NewIGraphBuilder,2) ; Remove
;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------
$Rt = InterfaceCall($IVideoWindow,"long",30,"ptr",0)
;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------
CtrlGraphRelease($NewIGraphBuilder,$IVideoWindow,$IMediaEventEx)
Return SetError(10,0,0)
EndIf
;-------IVideoWindow put_WindowStyleEx Virtual Method Number Is 12;----------------

;-------IVideoWindow put_AutoShow Virtual Method Number Is 14;----------------
$Rt = InterfaceCall($IVideoWindow,"long",14,"long",-1)
if @error Or $Rt[0] <> 0 Then
Add_Remove_MsgGraphArray($NewIGraphBuilder,2) ; Remove
;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------
$Rt = InterfaceCall($IVideoWindow,"long",30,"ptr",0)
;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------
CtrlGraphRelease($NewIGraphBuilder,$IVideoWindow,$IMediaEventEx)
Return SetError(11,0,0)
EndIf
;-------IVideoWindow put_AutoShow Virtual Method Number Is 14;----------------

if ($Run) Then
IMediaControl_Run($NewIGraphBuilder)
EndIf

CtrlGraphRelease($IVideoWindow,$IMediaEventEx)

Return SetError(0,0,$NewIGraphBuilder)

EndFunc



; #FUNCTION# ====================================================================================================================
; Name ..........: Re_GUICtrlCreateGraph
; Description ...:
; Syntax ........: Re_GUICtrlCreateGraph(Byref $OutIGraphBuilder, $FileName[, $Run = True])
; Parameters ....: $OutIGraphBuilder    - [in/out] an unknown value.
;                  $FileName            - an unknown value.
;                  $Run                 - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Re_GUICtrlCreateGraph(ByRef $OutIGraphBuilder,$FileName,$Run = True)

$IVideoWindow = GetIVideoWindow($OutIGraphBuilder)
if @error Then Return SetError(1,0,False)

$IMediaEventEx =  GetIMediaEventEx($OutIGraphBuilder)
if @error Then Return SetError(2,0,False)

;-------IVideoWindow get_WindowStyle Virtual Method Number Is 11;----------------
$Rt = InterfaceCall($IVideoWindow,"long",11,"long*",0)
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IVideoWindow,$IMediaEventEx)
Return SetError(3,0,False)
EndIf
$Style = $Rt[1]
;-------IVideoWindow get_WindowStyle Virtual Method Number Is 11;----------------

;-------IVideoWindow get_WindowStyleEx Virtual Method Number Is 13;----------------
$Rt = InterfaceCall($IVideoWindow,"long",13,"long*",0)
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IVideoWindow,$IMediaEventEx)
Return SetError(4,0,False)
EndIf
$ExStyle = $Rt[1]
;-------IVideoWindow get_WindowStyleEx Virtual Method Number Is 13;----------------

;-------IVideoWindow get_Owner Virtual Method Number Is 31;----------------
$Rt = InterfaceCall($IVideoWindow,"long",31,"ptr*",0)
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IVideoWindow,$IMediaEventEx)
Return SetError(5,0,False)
EndIf
$Gui = $Rt[1]
;-------IVideoWindow get_Owner Virtual Method Number Is 31;----------------

;-------IVideoWindow GetRestorePosition Virtual Method Number Is 44;----------------
$Rt = InterfaceCall($IVideoWindow,"long",44,"long*",0,"long*",0,"long*",0,"long*",0)
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IVideoWindow,$IMediaEventEx)
Return SetError(6,0,False)
EndIf
$L = $Rt[1]
$T = $Rt[2]
$W = $Rt[3]
$H = $Rt[4]
;-------IVideoWindow GetRestorePosition Virtual Method Number Is 44;------------

$RtIGraphBuilder = GUICtrlCreateGraph($Gui,$FileName,$L,$T,$W,$H,$Style,$ExStyle,$Run)
if @error Then
CtrlGraphRelease($IVideoWindow,$IMediaEventEx)
Return SetError(7,0,False)
Else

IMediaControl_Stop($OutIGraphBuilder)
Add_Remove_MsgGraphArray($OutIGraphBuilder,2) ; Remove

;-------IMediaEventEx SetNotifyWindow Virtual Method Number Is 14;----------------
$Rt = InterfaceCall($IMediaEventEx,"long",14,"ptr",0,"long",0,"ptr",0)
;-------IMediaEventEx SetNotifyWindow Virtual Method Number Is 14;----------------

;-------IVideoWindow put_Visible Virtual Method Number Is 20;----------------
$Rt = InterfaceCall($IVideoWindow,"long",20,"long",0)
;-------IVideoWindow put_Visible Virtual Method Number Is 20;----------------

;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------
$Rt = InterfaceCall($IVideoWindow,"long",30,"ptr",0)
;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------

CtrlGraphRelease($OutIGraphBuilder,$IVideoWindow,$IMediaEventEx)
$OutIGraphBuilder = $RtIGraphBuilder

EndIf

Return SetError(0,0,True)

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: GUICtrlDeleteGraph
; Description ...:
; Syntax ........: GUICtrlDeleteGraph(Byref $OutIGraphBuilder)
; Parameters ....: $OutIGraphBuilder    - [in/out] an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func GUICtrlDeleteGraph(ByRef $OutIGraphBuilder)

$IVideoWindow = GetIVideoWindow($OutIGraphBuilder)
if @error Then Return SetError(1,0,False)

$IMediaEventEx =  GetIMediaEventEx($OutIGraphBuilder)
if @error Then Return SetError(2,0,False)

IMediaControl_Stop($OutIGraphBuilder)

Add_Remove_MsgGraphArray($OutIGraphBuilder,2) ; Remove

;-------IMediaEventEx SetNotifyWindow Virtual Method Number Is 14;----------------
$Rt = InterfaceCall($IMediaEventEx,"long",14,"ptr",0,"long",0,"ptr",0)
;-------IMediaEventEx SetNotifyWindow Virtual Method Number Is 14;----------------

;-------IVideoWindow put_Visible Virtual Method Number Is 20;----------------
$Rt = InterfaceCall($IVideoWindow,"long",20,"long",0)
;-------IVideoWindow put_Visible Virtual Method Number Is 20;----------------

;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------
$Rt = InterfaceCall($IVideoWindow,"long",30,"ptr",0)
;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------

CtrlGraphRelease($IVideoWindow,$OutIGraphBuilder,$IMediaEventEx)
$OutIGraphBuilder = 0

Return SetError(0,0,True)

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: CtrlCreateAudio
; Description ...:
; Syntax ........: CtrlCreateAudio($Gui, $FileName[, $Run = True])
; Parameters ....: $Gui                 - an unknown value.
;                  $FileName            - an unknown value.
;                  $Run                 - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func CtrlCreateAudio($Gui,$FileName,$Run = True)
;$FileName the name of a media file

$StrIID_IGraphBuilder = "{56a868a9-0ad4-11ce-b03a-0020af0ba770}"
$StrCLSID_FilterGraph = "{e436ebb3-524f-11ce-9f53-0020af0ba770}"
$NewIGraphBuilder = GetObjFromGuid($StrIID_IGraphBuilder,$StrCLSID_FilterGraph)
if @error Then Return SetError(1,0,0)

if $StartGraph = 0 Then
GUIRegisterMsg($WM_GRAPHNOTIFY,"CREATEGRAPH_WM_MSG")
$StartGraph = 2
EndIf

Add_Remove_MsgGraphArray($NewIGraphBuilder) ; Add

;-------IGraphBuilder RenderFile Virtual Method Number Is 14;----------------
$Rt = InterfaceCall($NewIGraphBuilder,"long",14,"wstr",$FileName,"ptr",0)
if @error Or $Rt[0] <> 0 Then
Add_Remove_MsgGraphArray($NewIGraphBuilder,2) ; Remove
CtrlGraphRelease($NewIGraphBuilder)
Return SetError(2,0,0)
EndIf
;-------IGraphBuilder RenderFile Virtual Method Number Is 14;----------------

$IMediaEventEx =  GetIMediaEventEx($NewIGraphBuilder)
if @error Then
Add_Remove_MsgGraphArray($NewIGraphBuilder,2) ; Remove
CtrlGraphRelease($NewIGraphBuilder)
Return SetError(3,0,0)
EndIf

;-------IMediaEventEx SetNotifyWindow Virtual Method Number Is 14;----------------
$Rt = InterfaceCall($IMediaEventEx,"long",14,"ptr",$Gui,"long",$WM_GRAPHNOTIFY,"ptr",0)
if @error Or $Rt[0] <> 0 Then
Add_Remove_MsgGraphArray($NewIGraphBuilder,2) ; Remove
CtrlGraphRelease($NewIGraphBuilder,$IMediaEventEx)
Return SetError(4,0,0)
EndIf
;-------IMediaEventEx SetNotifyWindow Virtual Method Number Is 14;----------------

if ($Run) Then
IMediaControl_Run($NewIGraphBuilder)
EndIf

CtrlGraphRelease($IMediaEventEx)

Return SetError(0,0,$NewIGraphBuilder)

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: CtrlDeleteAudio
; Description ...:
; Syntax ........: CtrlDeleteAudio(Byref $OutIGraphBuilder)
; Parameters ....: $OutIGraphBuilder    - [in/out] an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func CtrlDeleteAudio(ByRef $OutIGraphBuilder)

$IMediaEventEx =  GetIMediaEventEx($OutIGraphBuilder)
if @error Then Return SetError(1,0,False)

$State = IMediaControl_GetState($OutIGraphBuilder)
if @error Then Return SetError(2,0,False)

if $State = 2 Or $State = 1 Then
IMediaControl_Stop($OutIGraphBuilder)
EndIf

;-------IMediaEventEx SetNotifyWindow Virtual Method Number Is 14;----------------
$Rt = InterfaceCall($IMediaEventEx,"long",14,"ptr",0,"long",0,"ptr",0)
;-------IMediaEventEx SetNotifyWindow Virtual Method Number Is 14;----------------

Add_Remove_MsgGraphArray($OutIGraphBuilder,2) ; Remove
CtrlGraphRelease($OutIGraphBuilder,$IMediaEventEx)
$OutIGraphBuilder = 0

Return SetError(0,0,True)

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: GetIVideoWindow
; Description ...:
; Syntax ........: GetIVideoWindow($IGraphBuilder)
; Parameters ....: $IGraphBuilder       - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func GetIVideoWindow($IGraphBuilder)
$IID_IVideoWindow =  IIDFromString("{56a868b4-0ad4-11ce-b03a-0020af0ba770}")
if @error Then Return SetError(1,0,0)
;---------IUnknown QueryInterface Virtual Method Number Is 1;-------------------
$Rt = InterfaceCall($IGraphBuilder,"long",1,"struct*",$IID_IVideoWindow,"ptr*",0)
;---------IUnknown QueryInterface Virtual Method Number Is 1;-------------------
if @error Or $Rt[0] <> 0 Then Return SetError(2,0,0)
Return SetError(0,0,$Rt[2])
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: GetIMediaControl
; Description ...:
; Syntax ........: GetIMediaControl($IGraphBuilder)
; Parameters ....: $IGraphBuilder       - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func GetIMediaControl($IGraphBuilder)
$IID_IMediaControl = IIDFromString("{56a868b1-0ad4-11ce-b03a-0020af0ba770}")
if @error Then Return SetError(1,0,0)
;---------IUnknown QueryInterface Virtual Method Number Is 1;-------------------
$Rt = InterfaceCall($IGraphBuilder,"long",1,"struct*",$IID_IMediaControl,"ptr*",0)
;---------IUnknown QueryInterface Virtual Method Number Is 1;-------------------
if @error Or $Rt[0] <> 0 Then Return SetError(2,0,0)
Return SetError(0,0,$Rt[2])
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: GetIMediaSeeking
; Description ...:
; Syntax ........: GetIMediaSeeking($IGraphBuilder)
; Parameters ....: $IGraphBuilder       - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func GetIMediaSeeking($IGraphBuilder)
$IID_IMediaSeeking = IIDFromString("{36b73880-c2c8-11cf-8b46-00805f6cef60}")
if @error Then Return SetError(1,0,0)
;---------IUnknown QueryInterface Virtual Method Number Is 1;-------------------
$Rt = InterfaceCall($IGraphBuilder,"long",1,"struct*",$IID_IMediaSeeking,"ptr*",0)
;---------IUnknown QueryInterface Virtual Method Number Is 1;-------------------
if @error Or $Rt[0] <> 0 Then Return SetError(2,0,0)
Return SetError(0,0,$Rt[2])
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: GetIMediaEventEx
; Description ...:
; Syntax ........: GetIMediaEventEx($IGraphBuilder)
; Parameters ....: $IGraphBuilder       - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func GetIMediaEventEx($IGraphBuilder)
$IID_IMediaEventEx = IIDFromString("{56a868c0-0ad4-11ce-b03a-0020af0ba770}")
if @error Then Return SetError(1,0,0)
;---------IUnknown QueryInterface Virtual Method Number Is 1;-------------------
$Rt = InterfaceCall($IGraphBuilder,"long",1,"struct*",$IID_IMediaEventEx,"ptr*",0)
;---------IUnknown QueryInterface Virtual Method Number Is 1;-------------------
if @error Or $Rt[0] <> 0 Then Return SetError(2,0,0)
Return SetError(0,0,$Rt[2])
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: CREATEGRAPH_WM_MSG
; Description ...:
; Syntax ........: CREATEGRAPH_WM_MSG($hWnd, $Msg, $wParam, $lParam)
; Parameters ....: $hWnd                - a handle value.
;                  $Msg                 - an unknown value.
;                  $wParam              - an unknown value.
;                  $lParam              - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func CREATEGRAPH_WM_MSG($hWnd,$Msg,$wParam,$lParam)
if IsArray($MsgGraphArray) Then
For $i = 0 To UBound($MsgGraphArray) - 1
Switch $Msg
Case $WM_GRAPHNOTIFY
Local $EC_COMPLETE = 0x01
$IMediaEventEx =  GetIMediaEventEx($MsgGraphArray[$i])
if Not @error Then
;-------IMediaEventEx GetEvent Virtual Method Number Is 9;----------------
$Rt = InterfaceCall($IMediaEventEx,"long",9,"Long*",0,"LONG_PTR*",0,"LONG_PTR*",0,"long",100)
;-------IMediaEventEx GetEvent Virtual Method Number Is 9;----------------
if Not @error And $Rt[0] = 0 Then
$lEventCode = $Rt[1]
$lParam1 = $Rt[2]
$lParam2 = $Rt[3]
if  $lEventCode = $EC_COMPLETE Then
IMediaControl_StopWhenReady($MsgGraphArray[$i])
EndIf
;-------IMediaEventEx FreeEventParams Virtual Method Number Is 13;----------------
InterfaceCall($IMediaEventEx,"long",13,"Long",$lEventCode,"LONG_PTR",$lParam1,"LONG_PTR",$lParam2)
;-------IMediaEventEx FreeEventParams Virtual Method Number Is 13;----------------
EndIf
EndIf
Case $WM_ERASEBKGND
$IVideoWindow = GetIVideoWindow($MsgGraphArray[$i])
if Not @error Then
;-------IVideoWindow put_BackgroundPalette Virtual Method Number Is 18;----------------
;The put_BackgroundPalette method specifies whether the video window realizes its palette
;in the background.
;BackgroundPalette [in]
;Specifies whether the video renderer realizes it palette in the background. Must be one of
;the following values:
;Value 	Description
;OATRUE = -1	The video renderer realizes the palette in the background.
;OAFALSE = 0	The video renderer does not realize the palette in the background. (Default.)
Local $BackgroundPalette = -1
$Rt = InterfaceCall($IVideoWindow,"long",18,"long",$BackgroundPalette)
;-------IVideoWindow put_BackgroundPalette Virtual Method Number Is 18;----------------
CtrlGraphRelease($IVideoWindow)
; No Return
EndIf
Case Else
$IVideoWindow = GetIVideoWindow($MsgGraphArray[$i])
if Not @error Then
;-------IVideoWindow NotifyOwnerMessage Virtual Method Number Is 39;----------------
InterfaceCall($IVideoWindow,"long",39,"ptr",$hWnd,"long",$Msg,"long",$wParam,"long",$lParam)
;-------IVideoWindow NotifyOwnerMessage Virtual Method Number Is 39;----------------
CtrlGraphRelease($IVideoWindow)
Return $GUI_RUNDEFMSG
EndIf
EndSwitch
Next
EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: CREATEGRAPH_ON_EXIT
; Description ...:
; Syntax ........: CREATEGRAPH_ON_EXIT()
; Parameters ....:
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func CREATEGRAPH_ON_EXIT()
DllCall($Ole32,"long","CoUninitialize")
DllClose($Ole32)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: IMediaSeeking_SeekToCurrent
; Description ...:
; Syntax ........: IMediaSeeking_SeekToCurrent($IGraphBuilder)
; Parameters ....: $IGraphBuilder       - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func IMediaSeeking_SeekToCurrent($IGraphBuilder)
;-------IMediaSeeking SetPositions Virtual Method Number Is 15;----------------
$IMediaSeeking = GetIMediaSeeking($IGraphBuilder)
if @error Then Return SetError(1,0,False)
$Rt = InterfaceCall($IMediaSeeking,"long",15,"INT64*",0,"DWORD",0x1,"INT64*",0,"DWORD",0)
;-------IMediaSeeking SetPositions Virtual Method Number Is 15;----------------
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IMediaSeeking)
Return SetError(2,0,False)
EndIf
IMediaControl_Stop($IGraphBuilder)
CtrlGraphRelease($IMediaSeeking)
Return SetError(0,0,True)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: IMediaControl_Run
; Description ...:
; Syntax ........: IMediaControl_Run($IGraphBuilder)
; Parameters ....: $IGraphBuilder       - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func IMediaControl_Run($IGraphBuilder)
$IMediaControl = GetIMediaControl($IGraphBuilder)
if @error Then Return SetError(1,0,False)
$State = IMediaControl_GetState($IGraphBuilder)
if @error Then Return SetError(2,0,False)
if $State = 2 Then
IMediaControl_Stop($IGraphBuilder)
if @error Then Return SetError(3,0,False)
EndIf
if $State = 2 Or $State = 0 Then
IMediaSeeking_SeekToCurrent($IGraphBuilder)
if @error Then Return SetError(4,0,False)
EndIf
;-------IMediaControl Run Virtual Method Number Is 8;----------------
$Rt = InterfaceCall($IMediaControl,"long",8)
;-------IMediaControl Run Virtual Method Number Is 8;----------------
if @error Or $Rt[0] <> 1 Then
CtrlGraphRelease($IMediaControl)
Return SetError(5,0,False)
EndIf
CtrlGraphRelease($IMediaControl)
Return SetError(0,0,True)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: IMediaControl_Pause
; Description ...:
; Syntax ........: IMediaControl_Pause($IGraphBuilder)
; Parameters ....: $IGraphBuilder       - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func IMediaControl_Pause($IGraphBuilder)
$IMediaControl = GetIMediaControl($IGraphBuilder)
if @error Then Return SetError(1,0,False)
;-------IMediaControl Pause Virtual Method Number Is 9;----------------
$Rt = InterfaceCall($IMediaControl,"long",9)
;-------IMediaControl Pause Virtual Method Number Is 9;----------------
if @error Or $Rt[0] <> 1 Then
CtrlGraphRelease($IMediaControl)
Return SetError(2,0,False)
EndIf
Return SetError(0,0,True)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: IMediaControl_Stop
; Description ...:
; Syntax ........: IMediaControl_Stop($IGraphBuilder)
; Parameters ....: $IGraphBuilder       - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func IMediaControl_Stop($IGraphBuilder)
$IMediaControl = GetIMediaControl($IGraphBuilder)
if @error Then Return SetError(1,0,False)
;-------IMediaControl Stop Virtual Method Number Is 10;----------------
$Rt = InterfaceCall($IMediaControl,"long",10)
;-------IMediaControl Stop Virtual Method Number Is 10;----------------
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IMediaControl)
Return SetError(2,0,False)
EndIf
CtrlGraphRelease($IMediaControl)
Return SetError(0,0,True)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: IMediaControl_StopWhenReady
; Description ...:
; Syntax ........: IMediaControl_StopWhenReady($IGraphBuilder)
; Parameters ....: $IGraphBuilder       - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func IMediaControl_StopWhenReady($IGraphBuilder)
$IMediaControl = GetIMediaControl($IGraphBuilder)
if @error Then Return SetError(1,0,False)
;-------IMediaControl StopWhenReady Virtual Method Number Is 16;----------------
$Rt = InterfaceCall($IMediaControl,"long",16)
;-------IMediaControl StopWhenReady Virtual Method Number Is 16;----------------
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IMediaControl)
Return SetError(2,0,False)
EndIf
CtrlGraphRelease($IMediaControl)
Return SetError(0,0,True)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: IMediaControl_GetState
; Description ...:
; Syntax ........: IMediaControl_GetState($IGraphBuilder)
; Parameters ....: $IGraphBuilder       - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func IMediaControl_GetState($IGraphBuilder)
;enum _FilterState
;{	State_Stopped	= 0,
;State_Paused	= State_Stopped + 1,
;State_Running	= State_Paused + 1
;}	FILTER_STATE;
$IMediaControl = GetIMediaControl($IGraphBuilder)
if @error Then Return SetError(1,0,-1)
;-------IMediaControl GetState Virtual Method Number Is 11;----------------
$Rt = InterfaceCall($IMediaControl,"long",11,"long",1000,"long*",0)
;-------IMediaControl GetState Virtual Method Number Is 11;----------------
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IMediaControl)
Return SetError(2,0,-1)
EndIf
CtrlGraphRelease($IMediaControl)
Return SetError(0,0,$Rt[2])
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: IVideoWindow_put_Owner
; Description ...:
; Syntax ........: IVideoWindow_put_Owner($IGraphBuilder, $Gui)
; Parameters ....: $IGraphBuilder       - an unknown value.
;                  $Gui                 - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func IVideoWindow_put_Owner($IGraphBuilder,$Gui)
$IVideoWindow = GetIVideoWindow($IGraphBuilder)
if @error Then Return SetError(1,0,False)
;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------
$Rt = InterfaceCall($IVideoWindow,"long",30,"ptr",$Gui)
;-------IVideoWindow put_Owner Virtual Method Number Is 30;----------------
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IVideoWindow)
Return SetError(2,0,False)
EndIf
CtrlGraphRelease($IVideoWindow)
Return SetError(0,0,True)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: IVideoWindow_SetWindowPosition
; Description ...:
; Syntax ........: IVideoWindow_SetWindowPosition($IGraphBuilder, $L, $T, $W, $H)
; Parameters ....: $IGraphBuilder       - an unknown value.
;                  $L                   - an unknown value.
;                  $T                   - an unknown value.
;                  $W                   - an unknown value.
;                  $H                   - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func IVideoWindow_SetWindowPosition($IGraphBuilder,$L,$T,$W,$H)
$IVideoWindow = GetIVideoWindow($IGraphBuilder)
if @error Then Return SetError(1,0,False)
;-------IVideoWindow SetWindowPosition Virtual Method Number Is 40;----------------
$Rt = InterfaceCall($IVideoWindow,"long",40,"long",$L,"long",$T,"long",$W,"long",$H)
;-------IVideoWindow SetWindowPosition Virtual Method Number Is 40;----------------
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IVideoWindow)
Return SetError(2,0,False)
EndIf
CtrlGraphRelease($IVideoWindow)
Return SetError(0,0,True)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: IVideoWindow_put_WindowState
; Description ...:
; Syntax ........: IVideoWindow_put_WindowState($IGraphBuilder, $WindowState)
; Parameters ....: $IGraphBuilder       - an unknown value.
;                  $WindowState         - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func IVideoWindow_put_WindowState($IGraphBuilder,$WindowState)
$IVideoWindow = GetIVideoWindow($IGraphBuilder)
if @error Then Return SetError(1,0,False)
;The put_WindowState method shows, hides, minimizes, or maximizes the video window.
;WindowState
;Flag that specifies how the window is to be shown. The value can be any
;constant defined for the nCmdShow parameter of the ShowWindow function.
;-------IVideoWindow put_WindowState Virtual Method Number Is 16;----------------
$Rt = InterfaceCall($IVideoWindow,"long",16,"long",$WindowState)
;-------IVideoWindow Sput_WindowState Virtual Method Number Is 16;----------------
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IVideoWindow)
Return SetError(2,0,False)
EndIf
CtrlGraphRelease($IVideoWindow)
Return SetError(0,0,True)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: IVideoWindow_put_FullScreenMode
; Description ...:
; Syntax ........: IVideoWindow_put_FullScreenMode($IGraphBuilder, $FullScreenMode)
; Parameters ....: $IGraphBuilder       - an unknown value.
;                  $FullScreenMode      - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func IVideoWindow_put_FullScreenMode($IGraphBuilder,$FullScreenMode)
$IVideoWindow = GetIVideoWindow($IGraphBuilder)
if @error Then Return SetError(1,0,False)
;Sets a hotkey that calls a user function.
;HotKeySet("{ESC}", "HotKeyFullScreenMode")
;Func HotKeyFullScreenMode()
;IVideoWindow_put_FullScreenMode($IGraphBuilder,$FullScreenMode)
;EndFunc
;The put_FullScreenMode method enables or disables full-screen video rendering.
;FullScreenMode [in]
;Boolean value that specifies whether to enable or disable full-screen mode. Must be one
;of the following values:
;Value 	Description
;OATRUE = -1	Switch to full-screen mode.
;OAFALSE = 0	Disable full-screen mode. (Default.)
;-------IVideoWindow put_FullScreenMode Virtual Method Number Is 37;----------------
$Rt = InterfaceCall($IVideoWindow,"long",37,"long",$FullScreenMode)
;-------IVideoWindow put_FullScreenMode Virtual Method Number Is 37;----------------
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IVideoWindow)
Return SetError(2,0,False)
EndIf
CtrlGraphRelease($IVideoWindow)
Return SetError(0,0,True)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: IVideoWindow_HideCursor
; Description ...:
; Syntax ........: IVideoWindow_HideCursor($IGraphBuilder, $HideCursor)
; Parameters ....: $IGraphBuilder       - an unknown value.
;                  $HideCursor          - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func IVideoWindow_HideCursor($IGraphBuilder,$HideCursor)
$IVideoWindow = GetIVideoWindow($IGraphBuilder)
if @error Then Return SetError(1,0,False)
;The SetWindowForeground method places the video window at the top of the Z order.
;HideCursor [in]
;Specifies whether to show or hide the cursor. Must be one of the following values:
;Value	Meaning
;OATRUE = -1 Hide the cursor.
;OAFALSE = 0 Show the cursor.
;-------IVideoWindow HideCursor Virtual Method Number Is 45;----------------
$Rt = InterfaceCall($IVideoWindow,"long",45,"long",$HideCursor)
;-------IVideoWindow HideCursor Virtual Method Number Is 45;----------------
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IVideoWindow)
Return SetError(2,0,False)
EndIf
CtrlGraphRelease($IVideoWindow)
Return SetError(0,0,True)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: IVideoWindow_SetWindowForeground
; Description ...:
; Syntax ........: IVideoWindow_SetWindowForeground($IGraphBuilder, $Focus)
; Parameters ....: $IGraphBuilder       - an unknown value.
;                  $Focus               - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func IVideoWindow_SetWindowForeground($IGraphBuilder,$Focus)
$IVideoWindow = GetIVideoWindow($IGraphBuilder)
if @error Then Return SetError(1,0,False)
;The SetWindowForeground method places the video window at the top of the Z order.
;Focus
;Specifies whether to give the window focus. Must be one of the following values:
;Value 	Description
;OATRUE = -1	Give the window focus.
;OAFALSE = 0	Do not give the window focus.
;-------IVideoWindow SetWindowForeground Virtual Method Number Is 38;----------------
$Rt = InterfaceCall($IVideoWindow,"long",38,"long",$Focus)
;-------IVideoWindow SetWindowForeground Virtual Method Number Is 38;----------------
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IVideoWindow)
Return SetError(2,0,False)
EndIf
CtrlGraphRelease($IVideoWindow)
Return SetError(0,0,True)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: IVideoWindow_put_BorderColor
; Description ...:
; Syntax ........: IVideoWindow_put_BorderColor($IGraphBuilder, $Color)
; Parameters ....: $IGraphBuilder       - an unknown value.
;                  $Color               - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func IVideoWindow_put_BorderColor($IGraphBuilder,$Color)
$IVideoWindow = GetIVideoWindow($IGraphBuilder)
if @error Then Return SetError(1,0,False)
;-------IVideoWindow put_BorderColor Virtual Method Number Is 35;----------------
$Rt = InterfaceCall($IVideoWindow,"long",35,"long",$Color)
;-------IVideoWindow put_BorderColor Virtual Method Number Is 35;----------------
if @error Or $Rt[0] <> 0 Then
CtrlGraphRelease($IVideoWindow)
Return SetError(2,0,False)
EndIf
CtrlGraphRelease($IVideoWindow)
Return SetError(0,0,True)
EndFunc

Func CtrlGraphRelease($IUnknown1 = 0,$IUnknown2 = 0,$IUnknown3 = 0)
if ($IUnknown1) Then IUnknownRelease($IUnknown1)
if ($IUnknown2) Then IUnknownRelease($IUnknown2)
if ($IUnknown3) Then IUnknownRelease($IUnknown3)
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: Add_Remove_MsgGraphArray
; Description ...:
; Syntax ........: Add_Remove_MsgGraphArray($IGraphBuilderObj[, $Flag = 1])
; Parameters ....: $IGraphBuilderObj    - an unknown value.
;                  $Flag                - [optional] an unknown value. Default is 1.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Add_Remove_MsgGraphArray($IGraphBuilderObj,$Flag = 1)
;$Flag = 1 Add
;$Flag = 2 Remove
Switch $Flag
Case 1
if Not IsArray($MsgGraphArray) Then
Local $TempMsgGraphArray[1]
$TempMsgGraphArray[0] = $IGraphBuilderObj
$MsgGraphArray = $TempMsgGraphArray
Return SetError(0,0,True)
Else
For $i = 0 To UBound($MsgGraphArray) - 1
if $IGraphBuilderObj = $MsgGraphArray[$i] Then Return SetError(1,0,False)
Next
ReDim $MsgGraphArray[UBound($MsgGraphArray) + 1]
$MsgGraphArray[UBound($MsgGraphArray) - 1] = $IGraphBuilderObj
Return SetError(0,0,True)
EndIf
Case 2
if IsArray($MsgGraphArray) Then
Local $TempMsgGraphArray[UBound($MsgGraphArray)],$Test = False , $j = 0
For $i = 0 To UBound($MsgGraphArray) - 1
if $IGraphBuilderObj = $MsgGraphArray[$i] Then
$Test = True
ContinueLoop
EndIf
$TempMsgGraphArray[$j] = $MsgGraphArray[$i]
$j += 1
Next
if ($Test) Then
if UBound($TempMsgGraphArray) > 1 Then
ReDim $TempMsgGraphArray[UBound($TempMsgGraphArray) - 1]
$MsgGraphArray = $TempMsgGraphArray
Else
$MsgGraphArray = 0
EndIf
Return SetError(0,0,True)
Else
Return SetError(2,0,False)
EndIf
EndIf
Case Else
Return SetError(3,0,False)
EndSwitch
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: IUnknownRelease
; Description ...:
; Syntax ........: IUnknownRelease($IUnknown)
; Parameters ....: $IUnknown            - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func IUnknownRelease($IUnknown)
;-------IUnknown Release Virtual Method Number Is 3;----------------
$Rt = InterfaceCall($IUnknown,"long",3)
;-------IUnknown Release Virtual Method Number Is 3;----------------
if @error Then Return SetError(1,0,0)
Return SetError(0,0,$Rt[0])
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: GetObjFromGuid
; Description ...:
; Syntax ........: GetObjFromGuid($StrIID, $StrCLSID)
; Parameters ....: $StrIID              - an unknown value.
;                  $StrCLSID            - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func GetObjFromGuid($StrIID,$StrCLSID)
Local $LSCTX_ALL = BitOR(0x1,0x4,0x16),$Rt = 0
if Not ($CoInitialize) Then
$Rt = DllCall($Ole32,"long","CoInitialize","ptr",0)
if @error Or ($Rt[0] <> 0 And $Rt[0] <> 1) Then Return SetError(1,0,0)
$CoInitialize = True
OnAutoItExitRegister("CREATEGRAPH_ON_EXIT")
EndIf
$clsid = CLSIDFromString($StrCLSID)
if @error Then Return SetError(2,0,0)
$riid = IIDFromString($StrIID)
if @error Then Return SetError(3,0,0)
$Rt = DllCall($Ole32,"long","CoCreateInstance","ptr",DllStructGetPtr($clsid), _
"ptr",0,"DWORD",$LSCTX_ALL,"ptr",DllStructGetPtr($riid),"ptr*",0)
if @error Or $Rt[0] <> 0 Then Return SetError(4,0,0)
Return SetError(0,0,$Rt[5])
EndFunc