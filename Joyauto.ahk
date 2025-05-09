#SingleInstance Force ; 중복 실행 시 다시 실행
Persistent

; 작업 디렉토리를 스크립트가 있는 폴더로 이동. 따로 지정 안해놓으면 자동 실행으로 시작 시 작업 디렉토리가 다른 곳으로 설정돼 오류가 남
SetWorkingDir A_ScriptDir

tray := A_TrayMenu
tray.delete()
tray.add("마우스 가두기", Mouse)
tray.add("노트북 한영키", Laptop)
tray.add("스팀 선호도 설정", Steam)
tray.add()
tray.add("부팅 시 자동 실행", Autorun)
tray.add("종료", Close)
tray.Default := "마우스 가두기"
tray.ClickCount := 1

try {
    ; 자동실행 레지스트리가 있는지 확인
    reg := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "Joyauto")
    if (reg == A_ScriptFullPath) {
        tray.Check("부팅 시 자동 실행")
    }
}

; 기본 재생장치 설정
SwitchSound("헤드셋")
return

Mouse(*) {
    static toggle := False
    tray.ToggleCheck("마우스 가두기")
    if (toggle) {
        SetTimer Cursor, 0
        DllCall("ClipCursor", "Int", 0)
    } else {
        SetTimer Cursor
    }
    toggle := !toggle
}

Cursor(*) {
    ; 해상도 크기만큼 마우스 가두기
    ClipCursor(0, 0, A_ScreenWidth, A_ScreenHeight)
}

Laptop(*) {
    static toggle := False
    tray.ToggleCheck("노트북 한영키")
    if (toggle) {
        Hotkey "RAlt", Ralt, "Off"
    } else {
        Hotkey "RAlt", Ralt, "On"
    }
    toggle := !toggle
}

Ralt(*) {
    Send "{vk15sc138}"
}

Steam(*) {
    Run '"nircmd.exe" setprocessaffinity "C:\Program Files (x86)\Steam\steam.exe" 0 1 2 3', , "Hide"
}

Autorun(*) {
    tray.ToggleCheck("부팅 시 자동 실행")
    try {
        ; 자동실행 레지스트리가 있는지 확인
        reg := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "Joyauto")
        if (reg == A_ScriptFullPath) {
            RegDelete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "Joyauto"
        } else {
            RegWrite A_ScriptFullPath, "REG_SZ", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run",
                "Joyauto"
        }
    } catch {
        RegWrite A_ScriptFullPath, "REG_SZ", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run",
            "Joyauto"
    }
}

Close(*) {
    ExitApp
}

; 마우스 가두기 단축키
; Pause
Pause:: Mouse

; 현재창 점점 불투명하게
; 컨트롤 + 윈도우키 + ↑
^#Up:: {
    trans := WinGetTransparent("A") ; 투명도 알아내기
    if (!trans) {
        return
    }
    trans += 10
    if (trans >= 255) {
        WinSetTransparent "Off", "A" ; 투명창 끄기. 투명도를 255로 지정해도 불투명하나 그러면 투명창으로 인식하기 때문에 성능이 하락함.
    } else {
        WinSetTransparent trans, "A" ; 포커스된 창을 투명하게
    }
}

; 현재창 점점 투명하게
; 컨트롤 + 윈도우키 + ↓
^#Down:: {
    trans := WinGetTransparent("A")
    if (!trans) {
        trans := 255
    }
    trans -= 10
    if (trans <= 0) {
        return
    }
    WinSetTransparent trans, "A"
}

; 왼쪽으로 스크롤
; 시프트 + 휠업
+WheelUp:: {
    fcontrol := ControlGetFocus("A")
    if (fcontrol) {
        SendMessage(0x114, 0, 0, fcontrol, "A")
    } else {
        Send "+{WheelUp}"
    }
}

; 오른쪽으로 스크롤
; 시프트 + 휠다운
+WheelDown:: {
    fcontrol := ControlGetFocus("A")
    if (fcontrol) {
        SendMessage(0x114, 1, 0, fcontrol, "A")
    } else {
        Send "+{WheelDown}"
    }
}

; 볼륨 +2
; 윈도우키 + 휠업
#WheelUp:: {
    Send "{Volume_Up}"
}

; 볼륨 -2
; 윈도우키 + 휠다운
#WheelDown:: {
    Send "{Volume_Down}"
}

; 서식없이 붙여넣기
; 컨트롤 + 알트 + V
^!v:: {
    Send A_Clipboard
}

; 컨트롤 + 시프트 + 알트 + 1
^+!1:: {
    SwitchSound("헤드셋")
}

; 컨트롤 + 시프트 + 알트 + 2
^+!2:: {
    SwitchSound("모니터")
}

; 컨트롤 + 시프트 + 알트 + 3
^+!3:: {
    SwitchSound("스피커")
}

; 블록지정한 영타를 한타로 변경
; 컨트롤 + 알트 + 스페이스
^!Space:: {
    clip := ClipboardAll() ; 클립보드 내용 보관
    Send "^c"
    if (IME_CHECK("A") == 0) { ; IME가 영문이면 한글로 변경
        Send "{vk15sc138}"
    }
    Send A_Clipboard
    Sleep 100
    A_Clipboard := clip ; 원래 클립보드 내용 복구
    clip := "" ; 메모리 해제
}

; 커서 밑 텍스트 복사 (잘 안됨)
; 시프트 + 휠클릭
+MButton:: {
    MouseGetPos , , , &fcontrol, 2
    if (fcontrol) {
        text := ControlGetText(fcontrol)
        A_Clipboard := text
    }
}

; 핫스트링
#Hotstring *?
::\->::→
::\<-::←
::\up::↑
::\down::↓
::\<>::↔
::\star::★
::\r::®
::\wn::㈜

; 마우스 가두는 함수
ClipCursor(x1, y1, x2, y2) {
    rect := Buffer(16)
    args := x1 . "|" . y1 . "|" . x2 . "|" . y2
    loop parse, args, "|" {
        NumPut "Int", A_LoopField, rect, (A_Index - 1) * 4
    }
    DllCall("ClipCursor", "Ptr", rect)
}

; 출력 장치 변경 함수
SwitchSound(device) {
    try {
        TrayTip ; 이전 메시지는 지우고
        RunWait('"nircmd.exe" setdefaultsounddevice ' . device, , "Hide")
        volume := SoundGetVolume()
        volume := Round(volume)
        TrayTip , device . " : " . volume
    }
}

; IME 상태 알아내는 함수. 영어면 0을 반환
; 새 IME로 바뀌고 작동 안함
IME_CHECK(winTitle) {
    hWnd := WinGetID(winTitle)
    defaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hWnd, "Uint")
    detectSave := A_DetectHiddenWindows
    DetectHiddenWindows True
    result := SendMessage(0x283, 0x005, "", , "ahk_id " . defaultIMEWnd)
    if (detectSave !== A_DetectHiddenWindows) {
        DetectHiddenWindows detectSave
    }
    return result
}
