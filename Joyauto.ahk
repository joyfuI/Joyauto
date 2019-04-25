#NoEnv
#Persistent
#SingleInstance force	; �ߺ� ���� �� �ٽ� ����

ClipCursor(x1, y1, x2, y2)	; ���콺 ���δ� �Լ�
{
	VarSetCapacity(rect, 16, 0)
	args := x1 . "|" . y1 . "|" . x2 . "|" . y2
	Loop, Parse, args, |
		NumPut(A_LoopField, &rect, (a_index - 1) * 4)
	DllCall("ClipCursor", "Str", rect)
	Return
}

SwitchSound(device)
{
	TrayTip	; ���� �޽����� �����
	RunWait, "nircmd.exe" setdefaultsounddevice "%device%", , Hide
	SoundGet, volume
	volume := Round(volume)
	TrayTip, , %device% : %volume%
	Return
}

SetWorkingDir, %A_ScriptDir%	; �۾� ���丮�� ��ũ��Ʈ�� �ִ� ������ �̵�. ���� ���� ���س����� �ڵ� �������� ���� �� �۾� ���丮�� �ٸ� ������ ������ ������ ��

Menu, Tray, NoStandard	; Ʈ���� �⺻�޴� ����
Menu, Tray, Add, ���콺 ���α�, Mouse
Menu, Tray, Add, ��Ʈ�� �ѿ�Ű, Laptop
Menu, Tray, Add
Menu, Tray, Add, ���� �� �ڵ� ����, Autorun
Menu, Tray, Add, ����, Close
Menu, Tray, Default, ���콺 ���α�	; Ʈ���� ������ Ŭ�� �� ������ �⺻�޴�
Menu, Tray, Click, 1	; Ʈ���� �������� �ѹ��� ������ �⺻�޴� �۵�

RegRead, reg, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto	; �ڵ����� ������Ʈ���� �ִ��� Ȯ��
If (ErrorLevel = 0)	; ������Ʈ���� �ְ�
	If (reg = A_ScriptFullPath)	; �� ���� �� �����̶��
		Menu, Tray, Check, ���� �� �ڵ� ����	; Ʈ���� �޴� üũ

Hotkey, Pause, Mouse	; Pause Ű�� ���콺 ���α� ����Ű ����
Progress, b p%volume% r0-100 w200 Hide zh15 fs10 ws700, %volume%

Run, "nircmd.exe" setdefaultsounddevice "���� �̾���", , Hide	; �⺻ �����ġ ����
Return

Mouse:
Menu, Tray, ToggleCheck, ���콺 ���α�
If (toggle1)
{
	SetTimer, Cursor, Off
	DllCall("ClipCursor", "Int", 0)
}
Else
{
	SetTimer, Cursor, On
}
toggle1 := !toggle1
Return

Cursor:
ClipCursor(0, 0, A_ScreenWidth, A_ScreenHeight)	; �ػ� ũ�⸸ŭ ���콺 ���α�
Return

Laptop:
Menu, Tray, ToggleCheck, ��Ʈ�� �ѿ�Ű
If (toggle2)
{
	Hotkey, RAlt, Ralt, Off
}
Else
{
	Hotkey, RAlt, Ralt, On
}
toggle2 := !toggle2
Return

Ralt:
Send, {vk15sc138}
Return

Autorun:
Menu, Tray, ToggleCheck, ���� �� �ڵ� ����
RegRead, reg, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto	; �ڵ����� ������Ʈ���� �ִ��� Ȯ��
If (ErrorLevel = 0)	; ������Ʈ���� �ְ�
	If (reg = A_ScriptFullPath)	; �� ���� �� �����̶��
	{
		RegDelete, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto	; ������Ʈ�� ����
		Return
	}
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto, %A_ScriptFullPath%	; ������Ʈ�� ����
Return

Close:
ExitApp

^+!t::	; ��Ʈ�� + ����Ʈ + ��Ʈ + T
WinSet, AlwaysOnTop, toggle, A	; ��Ŀ���� â�� �׻� ����
Return

^+!Up::	; ��Ʈ�� + ����Ʈ + ��Ʈ + ��
WinGet, trans, Transparent, A	; ���� �˾Ƴ���
If (!trans)
	Return
trans += 10	; ���� ���� 10
If (trans >= 255)	; ���� 0 ~ 255
{
	WinSet, Transparent, off, A	; ����â ����. ������ 255�� �����ص� �������ϳ� �׷��� ����â���� �ν��ϱ� ������ ������ �϶���.
	Return
}
WinSet, Transparent, %trans%, A	; ��Ŀ���� â�� �����ϰ�
Return

^+!Down::	; ��Ʈ�� + ����Ʈ + ��Ʈ + ��
WinGet, trans, Transparent, A
If (!trans)
	trans := 255
trans -= 10
If (trans <= 0)
	Return
WinSet, Transparent, %trans%, A
Return

^+!m::	; ��Ʈ�� + ����Ʈ + ��Ʈ + M
WinSet, Style, ^0x00020000, A	; ��Ŀ���� â�� �ּ�ȭ ��ư ����
Return

^+!s::	; ��Ʈ�� + ����Ʈ + ��Ʈ + S
WinSet, Style, ^0x00040000, A	; ��Ŀ���� â�� ���� �׵θ� ����. ��, â ũ�� ���� �Ұ�
Return

+WheelUp::	; ����Ʈ + �پ�
ControlGetFocus, fcontrol, A
SendMessage, 0x114, 0, 0, %fcontrol%, A	; �������� ��ũ��
Return

+WheelDown::	; ����Ʈ + �ٴٿ�
ControlGetFocus, fcontrol, A
SendMessage, 0x114, 1, 0, %fcontrol%, A	; ���������� ��ũ��
Return

#WheelUp::	; ������Ű + �پ�
SoundSet, +5
SoundGet, volume
volume := Round(volume)
Progress, %volume%, %volume%
Progress, Show
SetTimer, ProgressHide, -1000
Return

#WheelDown::	; ������Ű + �ٴٿ�
SoundSet, -5
SoundGet, volume
volume := Round(volume)
Progress, %volume%, %volume%
Progress, Show
SetTimer, ProgressHide, -1000
Return

ProgressHide:
Progress, b p%volume% r0-100 w200 Hide zh15 fs10 ws700, %volume%
Return

^+v::	; ��Ʈ�� + ����Ʈ + V
clip := ClipboardAll	; Ŭ������ ���� ����
clipboard := clipboard	; Ŭ�����忡�� ���ĵ� ����
Send, ^v	; �ٿ��ֱ�
Sleep, 100	; ������ ���ָ� �̻��ϰ� �ȵ�..
clipboard := clip	; ���� ���� ����
clip := ""	; �޸� ����
Return

^+!1::	; ��Ʈ�� + ����Ʈ + ��Ʈ + 1
SwitchSound("���� �̾���")	; ����
Return

^+!2::	; ��Ʈ�� + ����Ʈ + ��Ʈ + 2
SwitchSound("2477W1M")	; �����
Return

^+!3::	; ��Ʈ�� + ����Ʈ + ��Ʈ + 3
SwitchSound("����Ŀ")	; �̾���(������)
Return

#Hotstring *?
::\->::��
::\<-::��
::\up::��
::\down::��
::\<->::��
::\star::��
