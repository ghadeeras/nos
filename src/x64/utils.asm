%ifndef utils
%define utils

; Primitive types
%define int8            RESB 1
%define int16           RESW 1
%define int32           RESD 1
%define int64           RESQ 1
%define pointer         RESQ 1

; Macros
%define id(x)           x
%define structure(name) RESB id(name)_size

section .text

to_string_hex:
    push rbx
    push rsi
    push rdi

    mov rbx, 0x0F ; Mask to keep first hex digit
    add rdi, 30; 2 (utf-16 char size) * 15 (index of least significant hex digit in a 64-bit number)
    mov rcx, 16; 16 hex digits
to_string_loop:
    mov rsi, rdx
    and rsi, rbx
    shl rsi, 1
    mov ax, [hexDigits + rsi]
    mov [rdi], ax
    shr rdx, 4
    sub rdi, 2
    loop to_string_loop

    pop rdi
    pop rsi
    pop rbx
    ret

section .data
    hexDigits db __utf16__ `0123456789ABCDEF`
    hexTemplate db __utf16__ `0x0000000000000000\n\0`

%endif