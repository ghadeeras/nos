%ifndef DISK
%define DISK

DISK_INT EQU 0x13 ; Disk interrupt
DISK_INT_ROUT_READ_SECTORS EQU 0x02 ; Read Sectors

; Routine:
; Loads a number of sectors from a disk to memory (just after the boot sector)
; AL <-- the number of sectors to read
; DL <-- the disk drive to read from
; ES:BX <-- the address to load the sectors at
; AL --> the number of sectors that were read
load_sectors:
    push cx
    push dx
    push ax

    mov ch, 0; cylinder 0
    mov dh, 0; head 0
    mov cl, 2; skipping boot sector (i.e. sector 1)
    mov ah, DISK_INT_ROUT_READ_SECTORS
    int DISK_INT

    jnc $load_sector_end
    mov al, 0; no sector was read

load_sector_end:
    pop dx
    mov ah, dh; restore ah from the stack, without overwriting al.
    pop dx
    pop cx
    ret

disk_end:
%endif