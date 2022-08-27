%ifndef utils
%define utils

; Primitive types
%define int8            RESB 1
%define int16           RESW 1
%define int32           RESD 1
%define int64           RESQ 1
%define pointer         RESQ 1
%define char            RESW 1

; Macros
%define dot()                   .
%define id(x)                   x
%define structure(name)         RESB id(name)_size
%define localVar(name, member)  rbp - id(name)_size + id(name)dot()id(member)
%define arrayOf(type, length)   type * length

%macro fnEnter 0-1
    push    rbp
    mov     rbp, rsp
    %rep %0
    sub     rsp, id(%1)_size
    %endrep
    and     rsp, 0xFFFFFFFFFFFFFFF0
%endmacro

%macro fnLeave 0
    mov rsp, rbp
    pop rbp
%endmacro

%macro fnReturn 0-1
    fnLeave
    %rep %0
    mov rax, %1
    %endrep
    ret
%endmacro

%macro errJump 1
    or rax, rax
    jnz %1
%endmacro

section .text

to_hex_64:
    fnEnter
    mov rbx, hexDigits
    lea rdi, [r10 + 2 * 15]
    mov cl, 16
to_hex_64_loop:
    mov rsi, r11
    and rsi, 0x0F
    mov ax, word [rbx + 2 * rsi]
    mov word [rdi], ax
    shr r11, 4
    sub rdi, 2
    dec cl
    jnz to_hex_64_loop
    fnReturn 0

section .data
    hexDigits db __utf16__`0123456789ABCDEF`

%endif