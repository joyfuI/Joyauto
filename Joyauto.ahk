#NoEnv
#Persistent	; 실행 유지(ExitApp로 종료)
#SingleInstance force	; 중복실행시 다시 실행

volume := 5

Menu, Tray, NoStandard	; 트레이 기본메뉴 제거
Menu, Tray, Add, 부팅시 자동 실행, Autorun
Menu, Tray, Add, 종료, Close	; 종료 메뉴 추가

RegRead, reg, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, 오핫매크로	; 자동실행 레지스트리가 있는지 확인
If ErrorLevel = 0	; 레지스트리가 있고
	If reg = %A_ScriptFullPath%	; 그 값이 이 파일이라면
		Menu, Tray, Check, 부팅시 자동 실행	; 트레이 메뉴 체크

Progress, b p%volume% r0-100 w200 Hide zh15 fs10 ws700, %volume%
SoundSet, %volume%	; 시작시 기본 볼륨

RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, ShowSuperHidden, 0	; "보호된 운영 체제 파일 숨기기(권장)" 체크
Return

Autorun:
Menu, Tray, ToggleCheck, 부팅시 자동 실행
RegRead, reg, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, 오핫매크로	; 자동실행 레지스트리가 있는지 확인
if ErrorLevel = 0	; 레지스트리가 있고
	if reg = %A_ScriptFullPath%	; 그 값이 이 파일이라면
	{
		RegDelete, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, 오핫매크로	; 레지스트리 삭제
		Return
	}
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, 오핫매크로, %A_ScriptFullPath%	; 레지스트리 생성
Return

Close:
ExitApp

^+!t::	; 컨트롤 + 시프트 + 알트 + T
WinSet, AlwaysOnTop, toggle, A	; 포커스된 창을 항상 위로
Return

^+!Up::	; 컨트롤 + 시프트 + 알트 + ↑
WinGet, 투명도, Transparent, A	; 투명도 알아내기
If 투명도 = 
	Return
투명도 := 투명도 + 10	; 투명도 간격 10
If 투명도 >= 255	; 투명도 0 ~ 255
{
	WinSet, Transparent, off, A	; 투명창 끄기. 투명도를 255로 지정해도 불투명하나 그러면 투명창으로 인식하기 때문에 성능이 하락함.
	Return
}
WinSet, Transparent, %투명도%, A	; 포커스된 창을 투명하게
Return

^+!Down::	; 컨트롤 + 시프트 + 알트 + ↓
WinGet, 투명도, Transparent, A
If 투명도 = 
	투명도 := 255
투명도 := 투명도 - 10
If 투명도 <= 0
	Return
WinSet, Transparent, %투명도%, A
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
return

+WheelDown::	; 시프트 + 휠다운
ControlGetFocus, fcontrol, A
SendMessage, 0x114, 1, 0, %fcontrol%, A	; 오른쪽으로 스크롤
return

#WheelUp::	; 윈도우키 + 휠업
SoundSet, +5
SoundGet, volume
volume := Round(volume)
Progress, %volume%, %volume%
Progress, Show
SetTimer, volume, -1000
Return

#WheelDown::	; 윈도우키 + 휠다운
SoundSet, -5
SoundGet, volume
volume := Round(volume)
Progress, %volume%, %volume%
Progress, Show
SetTimer, volume, -1000
Return

^+v::	; 컨트롤 + 시프트 + V
clip := ClipboardAll	; 클릭보드 내용 보관
clipboard := clipboard	; 클립보드에서 서식들 날림
Send, ^v	; 붙여넣기
Sleep, 100	; 딜레이 안주면 이상하게 안됨..
clipboard := clip	; 원래 내용 복구
clip := ""	; 메모리 해제
Return

volume:
Progress, b p%volume% r0-100 w200 Hide zh15 fs10 ws700, %volume%
Return
