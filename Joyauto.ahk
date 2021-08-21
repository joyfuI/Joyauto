#NoEnv
#Persistent
#SingleInstance force   ; 중복 실행 시 다시 실행

; 작업 디렉토리를 스크립트가 있는 폴더로 이동. 따로 지정 안해놓으면 자동 실행으로 시작 시 작업 디렉토리가 다른 곳으로 설정돼 오류가 남
SetWorkingDir, %A_ScriptDir%

Menu, Tray, NoStandard
Menu, Tray, Add, 마우스 가두기, Mouse
Menu, Tray, Add, 노트북 한영키, Laptop
Menu, Tray, Add, 스팀 선호도 설정, Steam
Menu, Tray, Add
Menu, Tray, Add, 부팅 시 자동 실행, Autorun
Menu, Tray, Add, 종료, Close
Menu, Tray, Default, 마우스 가두기
Menu, Tray, Click, 1

; 자동실행 레지스트리가 있는지 확인
RegRead, reg, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto
If (ErrorLevel = 0 && reg = A_ScriptFullPath)
    Menu, Tray, Check, 부팅 시 자동 실행

Hotkey, Pause, Mouse    ; Pause 키에 마우스 가두기 단축키 지정
Progress, b p0 r0-100 w200 Hide zh15 fs10 ws700, 0

; 기본 재생장치 설정
Run, "nircmd.exe" setdefaultsounddevice "헤드셋 이어폰", , Hide
Return


Mouse:
Menu, Tray, ToggleCheck, 마우스 가두기
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
; 해상도 크기만큼 마우스 가두기
ClipCursor(0, 0, A_ScreenWidth, A_ScreenHeight)
Return


Laptop:
Menu, Tray, ToggleCheck, 노트북 한영키
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
Menu, Tray, ToggleCheck, 부팅 시 자동 실행
; 자동실행 레지스트리가 있는지 확인
RegRead, reg, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto
If (ErrorLevel = 0 && reg = A_ScriptFullPath)
    RegDelete, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto
Else
    RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto, %A_ScriptFullPath%
Return


Close:
ExitApp


; 컨트롤 + 윈도우키 + T
^#t::
; 포커스된 창을 항상 위로
WinSet, AlwaysOnTop, toggle, A
Return


; 컨트롤 + 윈도우키 + ↑
^#Up::
WinGet, trans, Transparent, A           ; 투명도 알아내기
If (!trans)
    Return
trans += 10
If (trans >= 255)
    WinSet, Transparent, off, A         ; 투명창 끄기. 투명도를 255로 지정해도 불투명하나 그러면 투명창으로 인식하기 때문에 성능이 하락함.
Else
    WinSet, Transparent, %trans%, A     ; 포커스된 창을 투명하게
Return


; 컨트롤 + 윈도우키 + ↓
^#Down::
WinGet, trans, Transparent, A
If (!trans)
    trans := 255
trans -= 10
If (trans <= 0)
    Return
WinSet, Transparent, %trans%, A
Return


; 컨트롤 + 윈도우키 + M
^#m::
; 포커스된 창의 최소화 버튼 제거
WinSet, Style, ^0x00020000, A
Return


; 컨트롤 + 윈도우키 + S
^#s::
; 포커스된 창의 굵은 테두리 제거. 즉, 창 크기 변경 불가
WinSet, Style, ^0x00040000, A
Return


; 시프트 + 휠업
+WheelUp::
; 왼쪽으로 스크롤
ControlGetFocus, fcontrol, A
SendMessage, 0x114, 0, 0, %fcontrol%, A
Return


; 시프트 + 휠다운
+WheelDown::
; 오른쪽으로 스크롤
ControlGetFocus, fcontrol, A
SendMessage, 0x114, 1, 0, %fcontrol%, A
Return


; 윈도우키 + 휠업
#WheelUp::
SoundSet, +5
SoundGet, volume
volume := Round(volume)
Progress, %volume%, %volume%
Progress, Show
SetTimer, ProgressHide, -1000
Return


; 윈도우키 + 휠다운
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


; 컨트롤 + 시프트 + V
^+!v::
clipboard := clipboard  ; 클립보드에서 서식 제거
Send, ^v
Sleep, 100              ; 딜레이 안주면 이상하게 안됨..
clipboard := clip       ; 원래 클립보드 내용 복구
clip := ""              ; 메모리 해제
Return


; 컨트롤 + 시프트 + 알트 + V
^+v::
Send, %clipboard%
Return


; 컨트롤 + 시프트 + 알트 + 1
^+!1::
; 헤드셋
SwitchSound("헤드셋 이어폰")
Return


; 컨트롤 + 시프트 + 알트 + 2
^+!2::
; 모니터
SwitchSound("2477W1M")
Return


; 컨트롤 + 시프트 + 알트 + 3
^+!3::
; 이어폰(전면잭)
SwitchSound("스피커")
Return


; 컨트롤 + 시프트 + 스페이스
^!Space::
clip := ClipboardAll        ; 클립보드 내용 보관
Send, ^c
If (IME_CHECK("A") == 0)    ; IME가 영문이면 한글로 변경
    Send, {vk15sc138}
Send, %clipboard%
Sleep, 100
clipboard := clip           ; 원래 클립보드 내용 복구
clip := ""                  ; 메모리 해제
Return


; 핫스트링
#Hotstring *?
::\->::→
::\<-::←
::\up::↑
::\down::↓
::\<->::↔
::\star::★


; 마우스 가두는 함수
ClipCursor(x1, y1, x2, y2)
{
    VarSetCapacity(rect, 16, 0)
    args := x1 . "|" . y1 . "|" . x2 . "|" . y2
    Loop, Parse, args, |
        NumPut(A_LoopField, &rect, (a_index - 1) * 4)
    DllCall("ClipCursor", "Str", rect)
}

; 출력 장치 변경 함수
SwitchSound(device)
{
    TrayTip     ; 이전 메시지는 지우고
    RunWait, "nircmd.exe" setdefaultsounddevice "%device%", , Hide
    SoundGet, volume
    volume := Round(volume)
    TrayTip, , %device% : %volume%
}

; IME 상태 알아내는 함수. 영어면 0을 반환
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
