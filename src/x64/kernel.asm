bits 64

%include "utils.asm"
%include "uefi.asm"
%include "uefi.out.asm"

section .text

global start

start:
    fnEnter

    mov r10, rcx
    mov r11, rdx
    call efiInit
    errJump the_end

    call efiOutReset
    errJump the_end

    mov r10, 0xF
    mov r11, 0x0
    call efiOutColor
    errJump the_end

    mov r10, msgWelcome
    call efiOutPrintLn
    errJump the_end

    mov r10, msgVersion
    call efiOutPrintLn
    errJump the_end

    mov r10, msgGitHub
    call efiOutPrintLn
    errJump the_end

    call efiOutPrintEOL
    errJump the_end

    mov r10, msgFirmwareVendor
    call efiOutPrint
    errJump the_end
    call efiFirmwareVendor
    errJump the_end
    mov r10, rbx
    call efiOutPrint
    errJump the_end
    call efiOutPrintEOL
    errJump the_end

    mov r10, msgFirmwareRevision
    call efiOutPrint
    errJump the_end
    call efiFirmwareRevision
    errJump the_end
    mov r10, rbx
    call efiOutPrintHex
    errJump the_end
    call efiOutPrintEOL
    errJump the_end

loopForever:
    jmp loopForever

the_end:
    fnReturn 0

section .data
    msgWelcome db __utf16__`Welcome to NOS, the "No Operating System"!\0`
    msgVersion db __utf16__`Version: 0.1.0\0`
    msgGitHub db __utf16__`GitHub Repository: https://github.com/ghadeeras/nos\0`
    msgFirmwareVendor db __utf16__`Firmware Vendor: \0`
    msgFirmwareRevision db __utf16__`Firmware Revision: \0`

; Required by UEFI
section '.reloc'
