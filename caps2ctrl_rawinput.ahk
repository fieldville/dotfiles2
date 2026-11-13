#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

; CapsLock(英数)キーを左Ctrlにする (Raw Input 版)。
; 日本語配列では英数キーの「離した」イベントがキーボードフックに届かず
; Ctrl が張り付くため、押下/解放の検出は Raw Input (WM_INPUT) で行う。
; フック側のホットキーは、英数キー本来の動作を止めるためだけに置いている。
*sc03A::return
*sc03A up::return

; WM_INPUT を受け取るための非表示ウィンドウ
rawWin := Gui()

; RAWINPUTDEVICE { USHORT usUsagePage; USHORT usUsage; DWORD dwFlags; HWND hwndTarget; }
rid := Buffer(8 + A_PtrSize, 0)
NumPut("UShort", 1, "UShort", 6, "UInt", 0x100, "Ptr", rawWin.Hwnd, rid)  ; キーボード, RIDEV_INPUTSINK
if !DllCall("RegisterRawInputDevices", "Ptr", rid, "UInt", 1, "UInt", rid.Size) {
    MsgBox "RegisterRawInputDevices に失敗しました"
    ExitApp
}
OnMessage(0x00FF, OnRawInput)  ; WM_INPUT

OnRawInput(wParam, lParam, msg, hwnd) {
    static hdrSize := 8 + 2 * A_PtrSize  ; RAWINPUTHEADER のサイズ
    size := 0
    DllCall("GetRawInputData", "Ptr", lParam, "UInt", 0x10000003, "Ptr", 0, "UInt*", &size, "UInt", hdrSize)
    if size = 0
        return
    buf := Buffer(size, 0)
    if DllCall("GetRawInputData", "Ptr", lParam, "UInt", 0x10000003, "Ptr", buf, "UInt*", &size, "UInt", hdrSize) <= 0
        return
    if NumGet(buf, 0, "UInt") != 1  ; RIM_TYPEKEYBOARD 以外は無視
        return
    makeCode := NumGet(buf, hdrSize, "UShort")
    flags := NumGet(buf, hdrSize + 2, "UShort")
    if makeCode != 0x3A || (flags & 2)  ; 英数キー以外 (拡張キー含む) は無視
        return
    if flags & 1  ; RI_KEY_BREAK = 離した
        Send "{Blind}{LCtrl up}"
    else
        Send "{Blind}{LCtrl down}"
}
