VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Test GPP"
   ClientHeight    =   1320
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   3225
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   88
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   215
   StartUpPosition =   2  'CenterScreen
   Begin VB.Timer tmrScreenSize 
      Interval        =   1000
      Left            =   0
      Top             =   0
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Test GPP"
      Height          =   495
      Left            =   240
      TabIndex        =   0
      Top             =   180
      Width           =   2775
   End
   Begin VB.Label lblScreenSize 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   840
      Width           =   2775
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Function GPSL_SetTextLineData Lib "gpcomms.dll" _
    (ByVal wTextPosX As Integer, ByVal wTextPosY As Integer, _
    ByVal LPCTSTR As String, ByVal dwTextColor As Long, _
    ByVal bBlackBackground As Boolean, ByVal cSize As Byte, _
    ByVal bTextBold As Boolean, ByVal cFontFamily As Byte) As Boolean
    
Private Declare Function GPSL_ShowText Lib "gpcomms.dll" (ByVal bShowIt As Boolean) As Boolean

Private Declare Function GPML_SetTextMultilineData Lib "gpcomms.dll" _
    (ByVal wPosX As Integer, ByVal wPosY As Integer, _
    ByVal pText As String, ByVal dwTextColor As Long, _
    ByVal bBlackBackground As Boolean, ByVal cFontSize As Byte, _
    ByVal bTextBold As Boolean, _
    ByVal wSizeX As Integer, ByVal wSizeY As Integer, _
    ByVal cFontFamily As Byte) As Boolean
    
Private Declare Function GPML_ShowText Lib "gpcomms.dll" (ByVal bShowIt As Boolean) As Boolean

Private Declare Function GPPIC_LoadNewPicture Lib "gpcomms.dll" (ByVal LPCTSTR As String) As Boolean

Private Declare Function GPPIC_ShowPicturePos Lib "gpcomms.dll" (ByVal bShowIt As Boolean, ByVal wPosX As Integer, ByVal wPosY As Integer) As Boolean

Private Declare Function GPSI_GetScreenSize Lib "gpcomms.dll" (ByRef piScreenX As Long, ByRef piScreenY As Long) As Boolean

Private Declare Function GPSI_ShowFPS Lib "gpcomms.dll" (ByVal bShowIt As Boolean) As Boolean
    


Private Sub Command1_Click()
    
    Dim sw As Long, sh As Long
    
    ' -- Single Line.
    
    ' Setup the single line of text.
    GPSL_SetTextLineData 500, 100, "Hello there", GetTextColour(255, 0), True, 50, True, 0
    
    ' Show the text.
    GPSL_ShowText True


    ' -- Multi Line.

    ' Setup the multi line of text.
    GPML_SetTextMultilineData 200, 200, "Hello there - in yellow" & vbCrLf & "and 50% transparency", GetTextColour(65535, 50), False, 40, True, 300, 400, 1

    ' Show the text.
    GPML_ShowText True


    ' -- Picture.
    
    ' Load the picture.
    GPPIC_LoadNewPicture App.Path & "\test.jpg"

    ' Show the picture.
    GPPIC_ShowPicturePos True, 0, 50

    
    ' Show the FPS counter.
    GPSI_ShowFPS True
    
End Sub



Public Function GetTextColour(ByVal p_lngTextColour As Long, ByVal p_intTransparency As Integer) As Long

    ' Returns the colour that can be used by the GPP Proxy DLL.
    
    ' Parameters:
    '     p_lngTextColour = Normal RGB colour.
    '     p_intTransparency = Transparency % (0 = Full display ...to... 100 = No display)

    ' Color Sequence (&HAARRGGBB) = (AA) Alpha / Transparency, (RR) Red, (GG) Green, (BB) Blue.
    
    Dim intTransparency As Integer
    Dim intRed As Integer
    Dim intGreen As Integer
    Dim intBlue As Integer
    Dim strColour As String

    intTransparency = 255 - ((p_intTransparency / 100) * 255)
    intRed = (p_lngTextColour And &HFF&)
    intGreen = (p_lngTextColour And &HFF00&) \ &H100
    intBlue = (p_lngTextColour And &HFF0000) \ &H10000
      
    strColour = "&H"
    strColour = strColour & IIf(Len(Hex(intTransparency)) = 1, "0", "") & Hex(intTransparency)
    strColour = strColour & IIf(Len(Hex(intRed)) = 1, "0", "") & Hex(intRed)
    strColour = strColour & IIf(Len(Hex(intGreen)) = 1, "0", "") & Hex(intGreen)
    strColour = strColour & IIf(Len(Hex(intBlue)) = 1, "0", "") & Hex(intBlue)
        
    ' Return the colour as a hexadecimal string.
    GetTextColour = CLng(strColour)
  
  
End Function

Private Sub tmrScreenSize_Timer()

    ' Check for the DirectX Screen Size.

    Dim sw As Long
    Dim sh As Long

    ' -- Screen Size.

    ' This will return the size of the DirectX screen.

    ' Note, this will only work when something when the GPP DLL has been initiased,
    ' and a DirectX screen is being displayed.
    GPSI_GetScreenSize sw, sh

    ' Every second the screen size will be checked.
    ' If the screen size is found, this will be reported and the timer stopped.
    ' Otherwise a "N/A" message will be displayed.

    lblScreenSize.Caption = "Screen Size: "

    If sw <> 0 And sh <> 0 Then
        lblScreenSize.Caption = lblScreenSize.Caption & "W: " & sw
        lblScreenSize.Caption = lblScreenSize.Caption & ", H: " & sh

        tmrScreenSize.Enabled = True
    Else
        lblScreenSize.Caption = lblScreenSize.Caption & "N/A"
    End If

End Sub
