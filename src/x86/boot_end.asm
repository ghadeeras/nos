%ifndef BOOT_END
%define BOOT_END

hang:
    jmp $ ; Do not allow execution to go beyond this point.

end:
    times 510 - ($end - $begin) db 0 ; Program must fit into 512 bytes (a sector).
    dw 0xAA55 ; For BIOS to know this is a boot sector.

%endif