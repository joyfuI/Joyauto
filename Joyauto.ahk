#NoEnv
#Persistent	; ���� ����(ExitApp�� ����)
#SingleInstance force	; �ߺ������ �ٽ� ����

volume := 5

Menu, Tray, NoStandard	; Ʈ���� �⺻�޴� ����
Menu, Tray, Add, ���ý� �ڵ� ����, Autorun
Menu, Tray, Add, ����, Close	; ���� �޴� �߰�

RegRead, reg, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, ���ָ�ũ��	; �ڵ����� ������Ʈ���� �ִ��� Ȯ��
If ErrorLevel = 0	; ������Ʈ���� �ְ�
	If reg = %A_ScriptFullPath%	; �� ���� �� �����̶��
		Menu, Tray, Check, ���ý� �ڵ� ����	; Ʈ���� �޴� üũ

Progress, b p%volume% r0-100 w200 Hide zh15 fs10 ws700, %volume%
SoundSet, %volume%	; ���۽� �⺻ ����

RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, ShowSuperHidden, 0	; "��ȣ�� � ü�� ���� �����(����)" üũ
Return

Autorun:
Menu, Tray, ToggleCheck, ���ý� �ڵ� ����
RegRead, reg, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, ���ָ�ũ��	; �ڵ����� ������Ʈ���� �ִ��� Ȯ��
if ErrorLevel = 0	; ������Ʈ���� �ְ�
	if reg = %A_ScriptFullPath%	; �� ���� �� �����̶��
	{
		RegDelete, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, ���ָ�ũ��	; ������Ʈ�� ����
		Return
	}
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, ���ָ�ũ��, %A_ScriptFullPath%	; ������Ʈ�� ����
Return

Close:
ExitApp

^+!t::	; ��Ʈ�� + ����Ʈ + ��Ʈ + T
WinSet, AlwaysOnTop, toggle, A	; ��Ŀ���� â�� �׻� ����
Return

^+!Up::	; ��Ʈ�� + ����Ʈ + ��Ʈ + ��
WinGet, ����, Transparent, A	; ���� �˾Ƴ���
If ���� = 
	Return
���� := ���� + 10	; ���� ���� 10
If ���� >= 255	; ���� 0 ~ 255
{
	WinSet, Transparent, off, A	; ����â ����. ������ 255�� �����ص� �������ϳ� �׷��� ����â���� �ν��ϱ� ������ ������ �϶���.
	Return
}
WinSet, Transparent, %����%, A	; ��Ŀ���� â�� �����ϰ�
Return

^+!Down::	; ��Ʈ�� + ����Ʈ + ��Ʈ + ��
WinGet, ����, Transparent, A
If ���� = 
	���� := 255
���� := ���� - 10
If ���� <= 0
	Return
WinSet, Transparent, %����%, A
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
return

+WheelDown::	; ����Ʈ + �ٴٿ�
ControlGetFocus, fcontrol, A
SendMessage, 0x114, 1, 0, %fcontrol%, A	; ���������� ��ũ��
return

#WheelUp::	; ������Ű + �پ�
SoundSet, +5
SoundGet, volume
volume := Round(volume)
Progress, %volume%, %volume%
Progress, Show
SetTimer, volume, -1000
Return

#WheelDown::	; ������Ű + �ٴٿ�
SoundSet, -5
SoundGet, volume
volume := Round(volume)
Progress, %volume%, %volume%
Progress, Show
SetTimer, volume, -1000
Return

^+v::	; ��Ʈ�� + ����Ʈ + V
clip := ClipboardAll	; Ŭ������ ���� ����
clipboard := clipboard	; Ŭ�����忡�� ���ĵ� ����
Send, ^v	; �ٿ��ֱ�
Sleep, 100	; ������ ���ָ� �̻��ϰ� �ȵ�..
clipboard := clip	; ���� ���� ����
clip := ""	; �޸� ����
Return

volume:
Progress, b p%volume% r0-100 w200 Hide zh15 fs10 ws700, %volume%
Return
