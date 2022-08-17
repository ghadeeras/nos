# NOS
**NOS**, as opposed to DOS, stands for "**N**ot an **O**perating **S**ystem", 
or a "**N**o **O**perating **S**ystem" software. I am using it to learn and 
experiment with OS development (i.e. writing the software that takes control 
of the computer right after the firmware loads it into memory) but WITHOUT 
making the writing of an actual OS the goal of this endeavor.

What prompted this exercise is a longing for low-level, down-to-the-metal 
development when I felt that, as a developer, I completely owned my PC and 
was able to manipulate the hardware directly. That was back in the days of 
DOS and the MSX (the 80s and early 90s). I wanted to restore that, but on 
modern hardware.

**NOTE**: It turned out that there was a discontinued operating system with 
the same name. This one is certainly unrelated to it.

## Building & Running

### Requirements

   * [NASM](https://www.nasm.us/): Needed to compile the assembly code. I am using version 2.15.05
   * [LLVM](https://llvm.org/): Needed for its linker (to generate EFI application). I am using version 14.0.6. 
   * [QEMU](https://www.qemu.org/): needed to run NOS in an emulator. I am using version 7.0.0.
   * The executable binaries of the above tools should be in the search PATH.
   * a POSIX-compatible environment: I am using (Git Bash on Windows).

### How To

Easy! From a terminal:

   * Clone this repository somewhere.
   * Change directory into the cloned repository.
   * For a legacy x86 architecture (BIOS): `$ ./run.x86.sh`
   * For a modern x64 architecture (UEFI): `$ ./run.x64.sh`
