bits 64

%include "utils.asm"
%include "uefi.asm"

struc START_LOCAL_VARS
    .Handle         int64
    .SystemTable    pointer
    .BootServices   pointer
    .ConsoleOut     pointer
endstruc

section .text

global start

start:
    push rbp
    mov rbp, rsp
    sub rsp, START_LOCAL_VARS_size
    and esp, 0xFFFFFFF0

    ; Sanity checks
    mov rax, EFI_SYSTEM_TABLE_SIGNATURE
    xor rax, [rdx + EFI_TABLE_HEADER.Signature]
    jnz the_end

    mov eax, [rdx + EFI_TABLE_HEADER.HeaderSize]
    cmp eax, EFI_SYSTEM_TABLE_size
    jl the_end

    ; Save important resource handles and services
    mov [rbp - START_LOCAL_VARS_size + START_LOCAL_VARS.Handle], rcx
    mov [rbp - START_LOCAL_VARS_size + START_LOCAL_VARS.SystemTable], rdx

    mov rax, [rdx + EFI_SYSTEM_TABLE.ConOut]
    mov [rbp - START_LOCAL_VARS_size + START_LOCAL_VARS.ConsoleOut], rax
    ; Null check
    and rax, rax
    jz the_end

    mov rax, [rdx + EFI_SYSTEM_TABLE.BootServices]
    mov [rbp - START_LOCAL_VARS_size + START_LOCAL_VARS.BootServices], rax
    ; Null check
    and rax, rax
    jz the_end

    ; Reset the console out service
    mov rcx, [rbp - START_LOCAL_VARS_size + START_LOCAL_VARS.ConsoleOut]
    mov rdx, 0 ; ExtendedVerification = False
    sub rsp, 4 * 8 ; Room for rcx, rdx, r8 and r9
    call [rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.Reset]
    add rsp, 4 * 8
    ; Error code check
    and rax, rax
    jnz the_end

    ; Set foreground and background colors for the following text output operations
    mov rcx, [rbp - START_LOCAL_VARS_size + START_LOCAL_VARS.ConsoleOut]
    mov rdx, (1 << 4) + 12 ; BG = 1 (Blue), FG = 12 (Bright Red)
    sub rsp, 4 * 8 ; Room for rcx, rdx, r8 and r9
    call [rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.SetAttribute]
    add rsp, 4 * 8
    ; Error code check
    and rax, rax
    jnz the_end

    ; Print a welcome message
    mov rcx, [rbp - START_LOCAL_VARS_size + START_LOCAL_VARS.ConsoleOut]
    lea rdx, [rel strHello]
    sub rsp, 4 * 8 ; Room for rcx, rdx, r8 and r9
    call [rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.OutputString]
    add rsp, 4 * 8
    ; Error code check
    and rax, rax
    jnz the_end

loopForever:
    jmp loopForever

the_end:
    mov rax, 0
    leave
    ret

section .data
    strHello db __utf16__ `Hello World! This is Ghadeer's OS!\n\r\0`

; Required by UEFI
section '.reloc'
