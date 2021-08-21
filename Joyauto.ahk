#NoEnv
#Persistent
#SingleInstance force   ; �ߺ� ���� �� �ٽ� ����

; �۾� ���丮�� ��ũ��Ʈ�� �ִ� ������ �̵�. ���� ���� ���س����� �ڵ� �������� ���� �� �۾� ���丮�� �ٸ� ������ ������ ������ ��
SetWorkingDir, %A_ScriptDir%

Menu, Tray, NoStandard
Menu, Tray, Add, ���콺 ���α�, Mouse
Menu, Tray, Add, ��Ʈ�� �ѿ�Ű, Laptop
Menu, Tray, Add, ���� ��ȣ�� ����, Steam
Menu, Tray, Add
Menu, Tray, Add, ���� �� �ڵ� ����, Autorun
Menu, Tray, Add, ����, Close
Menu, Tray, Default, ���콺 ���α�
Menu, Tray, Click, 1

; �ڵ����� ������Ʈ���� �ִ��� Ȯ��
RegRead, reg, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto
If (ErrorLevel = 0 && reg = A_ScriptFullPath)
    Menu, Tray, Check, ���� �� �ڵ� ����

Hotkey, Pause, Mouse    ; Pause Ű�� ���콺 ���α� ����Ű ����
Progress, b p0 r0-100 w200 Hide zh15 fs10 ws700, 0

; �⺻ �����ġ ����
Run, "nircmd.exe" setdefaultsounddevice "���� �̾���", , Hide
Return


Mouse:
Menu, Tray, ToggleCheck, ���콺 ���α�
If (toggle1)
{
    SetTimer, Cursor, Off
    DllCall("ClipCursor", "Int", 0)
}
Else
    SetTimer, Cursor, On
toggle1 := !toggle1
Return


Cursor:
; �ػ� ũ�⸸ŭ ���콺 ���α�
ClipCursor(0, 0, A_ScreenWidth, A_ScreenHeight)
Return


Laptop:
Menu, Tray, ToggleCheck, ��Ʈ�� �ѿ�Ű
If (toggle2)
    Hotkey, RAlt, Ralt, Off
Else
    Hotkey, RAlt, Ralt, On
toggle2 := !toggle2
Return


Ralt:
Send, {vk15sc138}
Return


Steam:
Run, "nircmd.exe" setprocessaffinity "C:\Program Files (x86)\Steam\steam.exe" 0 1 2 3, , Hide
Return


Autorun:
Menu, Tray, ToggleCheck, ���� �� �ڵ� ����
; �ڵ����� ������Ʈ���� �ִ��� Ȯ��
RegRead, reg, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto
If (ErrorLevel = 0 && reg = A_ScriptFullPath)
    RegDelete, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto
Else
    RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto, %A_ScriptFullPath%
Return


Close:
ExitApp


; ��Ʈ�� + ������Ű + T
^#t::
; ��Ŀ���� â�� �׻� ����
WinSet, AlwaysOnTop, toggle, A
Return


; ��Ʈ�� + ������Ű + ��
^#Up::
WinGet, trans, Transparent, A           ; ���� �˾Ƴ���
If (!trans)
    Return
trans += 10
If (trans >= 255)
    WinSet, Transparent, off, A         ; ����â ����. ������ 255�� �����ص� �������ϳ� �׷��� ����â���� �ν��ϱ� ������ ������ �϶���.
Else
    WinSet, Transparent, %trans%, A     ; ��Ŀ���� â�� �����ϰ�
Return


; ��Ʈ�� + ������Ű + ��
^#Down::
WinGet, trans, Transparent, A
If (!trans)
    trans := 255
trans -= 10
If (trans <= 0)
    Return
WinSet, Transparent, %trans%, A
Return


; ��Ʈ�� + ������Ű + M
^#m::
; ��Ŀ���� â�� �ּ�ȭ ��ư ����
WinSet, Style, ^0x00020000, A
Return


; ��Ʈ�� + ������Ű + S
^#s::
; ��Ŀ���� â�� ���� �׵θ� ����. ��, â ũ�� ���� �Ұ�
WinSet, Style, ^0x00040000, A
Return


; ����Ʈ + �پ�
+WheelUp::
; �������� ��ũ��
ControlGetFocus, fcontrol, A
SendMessage, 0x114, 0, 0, %fcontrol%, A
Return


; ����Ʈ + �ٴٿ�
+WheelDown::
; ���������� ��ũ��
ControlGetFocus, fcontrol, A
SendMessage, 0x114, 1, 0, %fcontrol%, A
Return


; ������Ű + �پ�
#WheelUp::
SoundSet, +5
SoundGet, volume
volume := Round(volume)
Progress, %volume%, %volume%
Progress, Show
SetTimer, ProgressHide, -1000
Return


; ������Ű + �ٴٿ�
#WheelDown::
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


; ��Ʈ�� + ����Ʈ + V
^+!v::
clipboard := clipboard  ; Ŭ�����忡�� ���� ����
Send, ^v
Sleep, 100              ; ������ ���ָ� �̻��ϰ� �ȵ�..
clipboard := clip       ; ���� Ŭ������ ���� ����
clip := ""              ; �޸� ����
Return


; ��Ʈ�� + ����Ʈ + ��Ʈ + V
^+v::
Send, %clipboard%
Return


; ��Ʈ�� + ����Ʈ + ��Ʈ + 1
^+!1::
; ����
SwitchSound("���� �̾���")
Return


; ��Ʈ�� + ����Ʈ + ��Ʈ + 2
^+!2::
; �����
SwitchSound("2477W1M")
Return


; ��Ʈ�� + ����Ʈ + ��Ʈ + 3
^+!3::
; �̾���(������)
SwitchSound("����Ŀ")
Return


; ��Ʈ�� + ����Ʈ + �����̽�
^!Space::
clip := ClipboardAll        ; Ŭ������ ���� ����
Send, ^c
If (IME_CHECK("A") == 0)    ; IME�� �����̸� �ѱ۷� ����
    Send, {vk15sc138}
Send, %clipboard%
Sleep, 100
clipboard := clip           ; ���� Ŭ������ ���� ����
clip := ""                  ; �޸� ����
Return


; �ֽ�Ʈ��
#Hotstring *?
::\->::��
::\<-::��
::\up::��
::\down::��
::\<->::��
::\star::��


; ���콺 ���δ� �Լ�
ClipCursor(x1, y1, x2, y2)
{
    VarSetCapacity(rect, 16, 0)
    args := x1 . "|" . y1 . "|" . x2 . "|" . y2
    Loop, Parse, args, |
        NumPut(A_LoopField, &rect, (a_index - 1) * 4)
    DllCall("ClipCursor", "Str", rect)
}

; ��� ��ġ ���� �Լ�
SwitchSound(device)
{
    TrayTip     ; ���� �޽����� �����
    RunWait, "nircmd.exe" setdefaultsounddevice "%device%", , Hide
    SoundGet, volume
    volume := Round(volume)
    TrayTip, , %device% : %volume%
}

; IME ���� �˾Ƴ��� �Լ�. ����� 0�� ��ȯ
IME_CHECK(winTitle)
{
    WinGet, hWnd, ID, %winTitle%
    defaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", Uint, hWnd, Uint)
    detectSave := A_DetectHiddenWindows
    DetectHiddenWindows, ON
    SendMessage, 0x283, 0x005, "", , ahk_id %defaultIMEWnd%
    If (detectSave != A_DetectHiddenWindows)
        DetectHiddenWindows, %detectSave%
    Return ErrorLevel
}
