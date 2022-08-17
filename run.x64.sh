#!/usr/bin/env bash

echo "Cleaning ..."
rm -R ./bootdrv
mkdir -p bootdrv/EFI/Boot/ || exit 1

echo "Compiling ..."
nasm -f win64 -o ./kernel.obj -i ./src/x64 ./src/x64/kernel.asm || exit 1

echo "Linking ..."
lld-link -subsystem:efi_application -nodefaultlib -dll -entry:start -out:./bootdrv/EFI/Boot/bootx64.efi ./kernel.obj || exit 1

echo "Running ..."
qemu-system-x86_64 -bios OVMF-pure-efi.fd -net none -hda fat:rw:bootdrv || exit 1

echo "Done!"
