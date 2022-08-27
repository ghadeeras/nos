%ifndef uefi_out
%define uefi_out

; Largely based on the UEFI library for fasm by bzt: https://wiki.osdev.org/Uefi.inc

%include "utils.asm"
%include "uefi.asm"

struc EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL
    .Reset             pointer
    .OutputString      pointer
    .TestString	       pointer
    .QueryMode	       pointer
    .SetMode	       pointer
    .SetAttribute      pointer
    .ClearScreen       pointer
    .SetCursorPosition pointer
    .EnableCursor      pointer
    .Mode              pointer
endstruc

struc EFI_HEX_STRING
    .Digits arrayOf(char, 16)
    .Null char
endstruc

section .text

; A function to reset the console output
; Output:
;   RAX = 0 if successful, error code otherwise
efiOutReset:
    fnEnter
    mov rcx, [rel efiSystemTable]
    mov rcx, [rcx + EFI_SYSTEM_TABLE.ConOut]
    mov rdx, 0 ; ExtendedVerification = False
    efiCall rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.Reset
    fnReturn

; A function to set foreground and background colors
; Input:
;   R10 = Foreground color
;   R11 = Background color
; Output:
;   RAX = 0 if successful, error code otherwise
efiOutColor:
    fnEnter
    mov rcx, [rel efiSystemTable]
    mov rcx, [rcx + EFI_SYSTEM_TABLE.ConOut]
    mov rdx, r11
    shl rdx, 4
    add rdx, r10
    efiCall rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.SetAttribute
    fnReturn

; A function to print a string to console output and a new line
; Input:
;   R10 = address of UTF16 zero terminated string
; Output:
;   RAX = 0 if successful, error code otherwise
efiOutPrintLn:
    fnEnter

    call efiOutPrint
    errJump efiOutPrintLn_err

    call efiOutPrintEOL
efiOutPrintLn_err:
    fnReturn

; A function to print an end-of-line string to console output
; Output:
;   RAX = 0 if successful, error code otherwise
efiOutPrintEOL:
    fnEnter
    mov R10, EFI_EOL
    call efiOutPrint
    fnReturn

; A function to print a string to console output
; Input:
;   R10 = address of UTF16 zero terminated string
; Output:
;   RAX = 0 if successful, error code otherwise
efiOutPrint:
    fnEnter
    mov rcx, [rel efiSystemTable]
    mov rcx, [rcx + EFI_SYSTEM_TABLE.ConOut]
    mov rdx, r10
    efiCall rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.OutputString
    fnReturn

; A function to print a number to console output in hexadecimal
; Input:
;   R10 = number to print in hexadecimal
; Output:
;   RAX = 0 if successful, error code otherwise
efiOutPrintHex:
    fnEnter EFI_HEX_STRING
    xor ax, ax
    mov [localVar(EFI_HEX_STRING, Null)], ax

    mov r11, r10
    lea r10, [localVar(EFI_HEX_STRING, Digits)]
    call to_hex_64
    errJump efiOutPrintHex_err

    mov r10, EFI_HEX_PREFIX
    call efiOutPrint
    errJump efiOutPrintHex_err

    lea r10, [localVar(EFI_HEX_STRING, Digits)]
    call efiOutPrint
efiOutPrintHex_err:
    fnReturn

section .data
    ; GUIDs
    EFI_CONSOLE_OUTPUT_PROTOCOL_UUID    db dword 0x387477c2, word 0x69c7, word 0x11d2, 0x8e,0x39,0x00,0xa0,0xc9,0x69,0x72,0x3b

    ; Constant Strings
    EFI_EOL         db __utf16__`\r\n\0`
    EFI_HEX_PREFIX  db __utf16__`0x\0`
%endif