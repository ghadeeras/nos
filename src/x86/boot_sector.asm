%include "boot_begin.asm"
%include "video.asm"
%include "disk.asm"

message:
    db 'Hello!', 0x0D, 0x0A, 'Size: ', 0x00

error_message:
    db 'Failed to load from drive!', 0x00

boot:
    mov si, $message
    call $println

    mov dx, ($end - $begin)
    call $print_hex

    mov si, $end_of_line
    call $print

    mov bx, 0x9000; address
    mov al, (($sector_2_end - $sector_2) + 0x01FF) >> 9; number of sectors sector
    mov dl, [$boot_drive];
    call $load_sectors

    cmp al, 1
    je $print_loaded_sector
    mov si, $error_message
    call $println
    jmp $hang

print_loaded_sector:
    mov si, bx
    call $println
    jmp $hang

%include "boot_end.asm"

sector_2:
    db 0x0D, 0x0A
    db "This is the second sector, which for now has no important information whatsoever. "
    db "I am just using it for testing how to load more sectors during the bootstrapping process.", 0x00
sector_2_end: