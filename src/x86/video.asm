%ifndef VIDEO
%define VIDEO

VIDEO_INT EQU 0x10 ; Video interrupt
VIDEO_INT_ROUT_WRITE_CHAR EQU 0x0E ; Write Teletype to Active Page

; End of line string
end_of_line:
    db 0x0D, 0x0A, 0x00

; Hexadecimal prefix string
hex_prefix:
    db '0x', 0

; Routine:
; Prints an ASCII character
; AL <-- the character to print
print_char:
    push ax

    mov ah, VIDEO_INT_ROUT_WRITE_CHAR
    int VIDEO_INT

    pop ax
    ret

; Routine:
; Prints a string
; DS:SI <-- the address of the zero-terminated string to print
print:
    pusha

print_loop:
    mov al, [si]
    cmp al, 0
    je $print_end

    call $print_char
    inc si
    jmp $print_loop

print_end:
    popa
    ret

; Routine:
; Prints a string followed by new line sequence
; DS:SI <-- the address of the zero-terminated string to print
println:
    push si

    call $print
    mov si, $end_of_line
    call $print

    pop si
    ret

; Routine:
; Prints a 16-bit number in hexadecimal
; DX <-- the 16-bit number to print
print_hex:
    pusha

    mov si, $hex_prefix
    call $print

    mov cx, 4
print_hex_loop:
    rol dx, 4

    mov al, dl
    call $to_hex_digit
    call $print_char

    loop $print_hex_loop

    popa
    ret

; Routine:
; Converts a 4-bit number to a character (hexadecimal digit)
; AL <-- the input number to convert  (the lower 4 bits).
; AL --> the output hexadecimal digit
to_hex_digit:
    and al, 0x0F
    add al, '0'
    cmp al, '9'
    jle $to_hex_digit_end
    add al, 'A' - '0' - 0xA
to_hex_digit_end:
    ret

video_end:
%endif