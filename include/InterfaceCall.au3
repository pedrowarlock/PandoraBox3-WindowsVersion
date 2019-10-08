

Func InterfaceCall($Inface,$ReturnType,$MethodNum,$Type1 = 0,$Param1 = 0,$Type2 = 0,$Param2 = 0 _
,$Type3 = 0,$Param3 = 0, $Type4 = 0,$Param4 = 0 ,$Type5 = 0 ,$Param5 = 0,$Type6 = 0,$Param6 = 0 _
,$Type7 = 0,$Param7 = 0, $Type8 = 0,$Param8 = 0,$Type9 = 0,$Param9 = 0,$Type10 = 0,$Param10 = 0 _
,$Type11= 0,$Param11= 0,$Type12= 0,$Param12= 0,$Type13= 0,$Param13 = 0,$Type14 = 0,$Param14 = 0 _
,$Type15= 0,$Param15= 0,$Type16= 0,$Param16= 0,$Type17= 0,$Param17 = 0,$Type18 = 0,$Param18 = 0 _
,$Type19= 0,$Param19= 0,$Type20= 0,$Param20= 0,$Type21= 0,$Param21 = 0,$Type22 = 0,$Param22 = 0 _
,$Type23= 0,$Param23= 0,$Type24= 0,$Param24= 0,$Type25= 0,$Param25 = 0,$Type26 = 0,$Param26 = 0 _
,$Type27= 0,$Param27= 0,$Type28= 0,$Param28= 0,$Type29= 0,$Param29 = 0,$Type30 = 0,$Param30 = 0)
;;Return Array Of DllCallAddress
;Only Call Virtual Method Form any Class Or From any Interface
;$MethodNum ==> Virtual Method Number In (Virtual Methods Table) ;See the examples
;-------------------------------------------------------------------;C++ Example1
;C++ Example1
;class iClass
;{
;public:
;void MethodA()
;{
;MessageBox(0,"MethodA","MSG",0);
;}
;virtual void VirtualMethodB()
;{
;MessageBox(0,"VirtualMethodB","MSG",0);
;}
;virtual void VirtualMethodC()
;{
;MessageBox(0,"VirtualMethodC","MSG",0);
;}
;void MethodB()
;{
;MessageBox(0,"MethodB","MSG",0);
;}
;virtual void VirtualMethodA()
;{
;MessageBox(0,"VirtualMethodA","MSG",0);
;}
;};
;-----------------------------------------------------------;Virtual Methods Table
;Virtual Methods Table
;virtual void VirtualMethodB() ==> Virtual Method Number Is 1
;virtual void VirtualMethodC() ==> Virtual Method Number Is 2
;virtual void VirtualMethodA() ==> Virtual Method Number Is 3
;-----------------------------------------------------------;Virtual Methods Table
;-------------------------------------------------------------------;C++ Example1

;////////////////////////////////////////////////////////////////////////////////

;-------------------------------------------------------------------;C++ Example2
;C++ Example2
;class iClassA
;{
;public:
;void MethodA()
;{
;MessageBox(0,"MethodA","MSG",0);
;}
;virtual void VirtualMethodB()
;{
;MessageBox(0,"VirtualMethodB","MSG",0);
;}
;virtual void VirtualMethodC()
;{
;MessageBox(0,"VirtualMethodC","MSG",0);
;}
;};

;class iClassB : public iClassA
;{
;public:
;void MethodD()
;{
;MessageBox(0,"MethodD","MSG",0);
;}
;virtual void VirtualMethodF()
;{
;MessageBox(0,"VirtualMethodF","MSG",0);
;}
;virtual void VirtualMethodE()
;{
;MessageBox(0,"VirtualMethodE","MSG",0);
;}
;};
;////////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////////
;------------------------------------------;Virtual Methods Table Of iClassA Class
;Virtual Methods Table Of iClassA Class
;virtual void VirtualMethodB() ==> Virtual Method Number Is 1
;virtual void VirtualMethodC() ==> Virtual Method Number Is 2
;------------------------------------------;Virtual Methods Table Of iClassA Class
;////////////////////////////////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////////////////////////
;------------------------------------------;Virtual Methods Table Of iClassB Class
;class iClassB : public iClassA
;base class ==> iClassA
;derived class ==> iClassB
;http://msdn.microsoft.com/en-us/library/hzk8a7d3.aspx
;When preceding the name of a base class, the public keyword specifies that the public
;and protected members of the base class are public and protected members, respectively,
;of the derived class.
;-------------------------------------------------------------------------------------
;Virtual Methods Table Of iClassB Class
;virtual void VirtualMethodB() In (iClassA) ==> Virtual Method Number Is 1
;virtual void VirtualMethodC() In (iClassA) ==> Virtual Method Number Is 2
;virtual void VirtualMethodF() In (iClassB) ==> Virtual Method Number Is 3
;virtual void VirtualMethodE() In (iClassB) ==> Virtual Method Number Is 4
;------------------------------------------;Virtual Methods Table Of iClassB Class
;-------------------------------------------------------------------;C++ Example2
;////////////////////////////////////////////////////////////////////////////////
if Not IsPtr($Inface) Or ($MethodNum < 1) Then Return SetError(1,0,0)
if (@NumParams > 3) And (Mod((@NumParams - 3),2) <> 0) Then Return SetError(2,0,0)
Local $iMethAddress = GetMethodAddress($Inface,$MethodNum)
if Not ($iMethAddress) Then Return SetError(3,0,0)
Local $iDataType = "",$iFuncParam = "",$iCommand = "",$iReturn = 0
;Why use Inface Param In DllCallAddress Function Because the Function of the method
;starts from the (Interface Or class)
;See here
;int class::MethodFunction( int Param ){return 0;};
$iCommand = 'DllCallAddress("' & $ReturnType & '",Eval("iMethAddress"),"ptr",Eval("Inface"),'
For $i = 1 To ((@NumParams - 3) / 2)
$iDataType = Eval("Type" & $i)
$iCommand &= '"' & $iDataType & '",'
$iFuncParam = 'Eval("Param' & $i & '"),'
$iCommand &= $iFuncParam
Next
$iCommand = StringTrimRight($iCommand,1)
$iCommand &= ")"
$iReturn = Execute($iCommand)
if @error Then Return SetError(4,0,0)
Local $nReturn[UBound($iReturn) -1] , $j = 0
For $i = 0 To UBound($iReturn) - 1
if ($i = 1) Then ContinueLoop ;Skip $Inface Element
$nReturn[$j] = $iReturn[$i]
$j += 1
Next
Return SetError(0,0,$nReturn)
EndFunc

Func GetMethodAddress($Inface,$MethodNum)
;$MethodNum ==> Virtual Method Number In (Virtual Methods Table)
Local $SizeOfUlong_Ptr = 4,$iMethAddress = 0,$OutCastStruct1 = 0
Local $OutCast1 = 0 , $OutCastStruct2 = 0
if Not IsPtr($Inface) Or ($MethodNum < 1) Then Return SetError(1,0,0)
;-------------------------------------------------------
$OutCastStruct1 = DllStructCreate("ULONG_PTR",$Inface)
$OutCast1 = DllStructGetData($OutCastStruct1,1)
;In C++ ==> unsigned long** OutCast1 = *(unsigned long***)Inface;
;--------------------------------------------------------
;-------------------------------------------------------
$OutCastStruct2 = DllStructCreate("ULONG_PTR",$OutCast1 + ($SizeOfUlong_Ptr * ($MethodNum - 1)))
$iMethAddress = DllStructGetData($OutCastStruct2,1)
;$OutCast1 + ($SizeOfUlong_Ptr * ($MethodNum - 1)) ==> $OutCast1 Is PTR Array Of Virtual Methods Table // Method PTR = Array[MethodNum - 1]
;In C++ ==> unsigned long* iMethAddress = *(unsigned long**)((BYTE*)OutCast1 + (SizeOfUlong_Ptr * (MethodNum - 1)));
;Or In C++ ==> unsigned long* iMethAddress = OutCast1[MethodNum - 1];
;--------------------------------------------------------
if (IsBadCodePtr($iMethAddress)) Then Return SetError(2,0,0)
Return SetError(0,0,$iMethAddress)
EndFunc

Func GetCount_Of_VirtualMethods($Inface)
Local $SizeOfUlong_Ptr = 4,$iMethAddress = 0,$OutCastStruct1 = 0
Local $OutCast1 = 0 , $OutCastStruct2 = 0 , $MethodNum = 1
if Not IsPtr($Inface) Then Return SetError(1,0,0)
;-------------------------------------------------------
$OutCastStruct1 = DllStructCreate("ULONG_PTR",$Inface)
$OutCast1 = DllStructGetData($OutCastStruct1,1)
;In C++ ==> unsigned long** OutCast1 = *(unsigned long***)Inface;
;--------------------------------------------------------
While 1
;-------------------------------------------------------
$OutCastStruct2 = DllStructCreate("ULONG_PTR",DllStructGetData($OutCastStruct1,1) + ($SizeOfUlong_Ptr * ($MethodNum - 1)))
$iMethAddress = DllStructGetData($OutCastStruct2,1)
;$OutCast1 + ($SizeOfUlong_Ptr * ($MethodNum - 1)) ==> $OutCast1 Is PTR Array Of Virtual Methods Table // Method PTR = Array[MethodNum - 1]
;In C++ ==> unsigned long* iMethAddress = *(unsigned long**)((BYTE*)OutCast1 + (SizeOfUlong_Ptr * (MethodNum - 1)));
;Or In C++ ==> unsigned long* iMethAddress = OutCast1[MethodNum - 1];
;--------------------------------------------------------
if (IsBadCodePtr($iMethAddress)) Then
$MethodNum -= 1
ExitLoop
Else
$MethodNum += 1
EndIf
WEnd
Return SetError(0,0,$MethodNum)
EndFunc

Func IsBadCodePtr($lpfn)
Local $iReturn
$iReturn = DllCall("Kernel32.dll","BOOL","IsBadCodePtr","ptr",$lpfn)
if @error Then Return SetError(1,0,0)
Return SetError(0,0,$iReturn[0])
EndFunc

Func CLSIDFromString($psz)
$GUID = DllStructCreate("ulong Data1;ushort Data2;ushort Data3;byte Data4[8]")
$Oleerror = DllCall("Ole32.dll","int","CLSIDFromString","WSTR",$psz,"struct*",$GUID)
if @error Or $Oleerror[0] <> 0 Then Return SetError(1,0,0)
Return SetError(0,0,$Oleerror[2])
EndFunc

Func IIDFromString($psz)
$GUID = DllStructCreate("ulong Data1;ushort Data2;ushort Data3;byte Data4[8]")
$Oleerror = DllCall("Ole32.dll","int","IIDFromString","WSTR",$psz,"struct*",$GUID)
if @error Or $Oleerror[0] <> 0 Then Return SetError(1,0,0)
Return SetError(0,0,$Oleerror[2])
EndFunc
