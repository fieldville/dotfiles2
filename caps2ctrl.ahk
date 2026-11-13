#Requires AutoHotkey v2.0
#SingleInstance Force

; CapsLock(英数)キーを左Ctrlにする。
; 日本語配列ではキー名 CapsLock だと反応しない/張り付くことがあるため、
; スキャンコード(sc03A)で指定している。
*sc03A::Send "{Blind}{LCtrl down}"
*sc03A up::Send "{Blind}{LCtrl up}"
