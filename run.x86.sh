#!/usr/bin/env bash

echo "Cleaning ..."
rm -R ./bootdrv
mkdir -p bootdrv/ || exit 1

echo "Compiling ..."
nasm -f bin -i ./src/x86 -o ./bootdrv/boot_sector.bin ./src/x86/boot_sector.asm || exit 1

echo "Running ..."
qemu-system-x86_64 ./bootdrv/boot_sector.bin || exit 1

echo "Done!"
