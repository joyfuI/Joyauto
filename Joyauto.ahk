#NoEnv
#Persistent
#SingleInstance force	; 중복 실행 시 다시 실행

ClipCursor(x1, y1, x2, y2)	; 마우스 가두는 함수
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
	TrayTip	; 이전 메시지는 지우고
	RunWait, "nircmd.exe" setdefaultsounddevice "%device%", , Hide
	SoundGet, volume
	volume := Round(volume)
	TrayTip, , %device% : %volume%
	Return
}

SetWorkingDir, %A_ScriptDir%	; 작업 디렉토리를 스크립트가 있는 폴더로 이동. 따로 지정 안해놓으면 자동 실행으로 시작 시 작업 디렉토리가 다른 곳으로 설정돼 오류가 남

Menu, Tray, NoStandard	; 트레이 기본메뉴 제거
Menu, Tray, Add, 마우스 가두기, Mouse
Menu, Tray, Add, 노트북 한영키, Laptop
Menu, Tray, Add
Menu, Tray, Add, 부팅 시 자동 실행, Autorun
Menu, Tray, Add, 종료, Close
Menu, Tray, Default, 마우스 가두기	; 트레이 아이콘 클릭 시 동작할 기본메뉴
Menu, Tray, Click, 1	; 트레이 아이콘을 한번만 눌러도 기본메뉴 작동

RegRead, reg, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto	; 자동실행 레지스트리가 있는지 확인
If (ErrorLevel = 0)	; 레지스트리가 있고
	If (reg = A_ScriptFullPath)	; 그 값이 이 파일이라면
		Menu, Tray, Check, 부팅 시 자동 실행	; 트레이 메뉴 체크

Hotkey, Pause, Mouse	; Pause 키에 마우스 가두기 단축키 지정
Progress, b p%volume% r0-100 w200 Hide zh15 fs10 ws700, %volume%

Run, "nircmd.exe" setdefaultsounddevice "헤드셋 이어폰", , Hide	; 기본 재생장치 설정
Return

Mouse:
Menu, Tray, ToggleCheck, 마우스 가두기
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
ClipCursor(0, 0, A_ScreenWidth, A_ScreenHeight)	; 해상도 크기만큼 마우스 가두기
Return

Laptop:
Menu, Tray, ToggleCheck, 노트북 한영키
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
Menu, Tray, ToggleCheck, 부팅 시 자동 실행
RegRead, reg, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto	; 자동실행 레지스트리가 있는지 확인
If (ErrorLevel = 0)	; 레지스트리가 있고
	If (reg = A_ScriptFullPath)	; 그 값이 이 파일이라면
	{
		RegDelete, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto	; 레지스트리 삭제
		Return
	}
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Joyauto, %A_ScriptFullPath%	; 레지스트리 생성
Return

Close:
ExitApp

^+!t::	; 컨트롤 + 시프트 + 알트 + T
WinSet, AlwaysOnTop, toggle, A	; 포커스된 창을 항상 위로
Return

^+!Up::	; 컨트롤 + 시프트 + 알트 + ↑
WinGet, trans, Transparent, A	; 투명도 알아내기
If (!trans)
	Return
trans += 10	; 투명도 간격 10
If (trans >= 255)	; 투명도 0 ~ 255
{
	WinSet, Transparent, off, A	; 투명창 끄기. 투명도를 255로 지정해도 불투명하나 그러면 투명창으로 인식하기 때문에 성능이 하락함.
	Return
}
WinSet, Transparent, %trans%, A	; 포커스된 창을 투명하게
Return

^+!Down::	; 컨트롤 + 시프트 + 알트 + ↓
WinGet, trans, Transparent, A
If (!trans)
	trans := 255
trans -= 10
If (trans <= 0)
	Return
WinSet, Transparent, %trans%, A
Return

^+!m::	; 컨트롤 + 시프트 + 알트 + M
WinSet, Style, ^0x00020000, A	; 포커스된 창의 최소화 버튼 제거
Return

^+!s::	; 컨트롤 + 시프트 + 알트 + S
WinSet, Style, ^0x00040000, A	; 포커스된 창의 굵은 테두리 제거. 즉, 창 크기 변경 불가
Return

+WheelUp::	; 시프트 + 휠업
ControlGetFocus, fcontrol, A
SendMessage, 0x114, 0, 0, %fcontrol%, A	; 왼쪽으로 스크롤
Return

+WheelDown::	; 시프트 + 휠다운
ControlGetFocus, fcontrol, A
SendMessage, 0x114, 1, 0, %fcontrol%, A	; 오른쪽으로 스크롤
Return

#WheelUp::	; 윈도우키 + 휠업
SoundSet, +5
SoundGet, volume
volume := Round(volume)
Progress, %volume%, %volume%
Progress, Show
SetTimer, ProgressHide, -1000
Return

#WheelDown::	; 윈도우키 + 휠다운
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

^+v::	; 컨트롤 + 시프트 + V
clip := ClipboardAll	; 클릭보드 내용 보관
clipboard := clipboard	; 클립보드에서 서식들 날림
Send, ^v	; 붙여넣기
Sleep, 100	; 딜레이 안주면 이상하게 안됨..
clipboard := clip	; 원래 내용 복구
clip := ""	; 메모리 해제
Return

^+!1::	; 컨트롤 + 시프트 + 알트 + 1
SwitchSound("헤드셋 이어폰")	; 헤드셋
Return

^+!2::	; 컨트롤 + 시프트 + 알트 + 2
SwitchSound("2477W1M")	; 모니터
Return

^+!3::	; 컨트롤 + 시프트 + 알트 + 3
SwitchSound("스피커")	; 이어폰(전면잭)
Return

#Hotstring *?
::\->::→
::\<-::←
::\up::↑
::\down::↓
::\<->::↔
::\star::★
