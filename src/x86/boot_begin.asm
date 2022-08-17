%ifndef BOOT_BEGIN
%define BOOT_BEGIN

BOOT_SECTOR_ADDRESS EQU 0x7C00

org BOOT_SECTOR_ADDRESS

begin:
    mov [$boot_drive], dl
    mov bp, 0x8000
    mov sp, bp
    jmp $boot

boot_drive:
    db 0x00
%endif