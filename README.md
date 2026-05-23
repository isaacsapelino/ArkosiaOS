# ArkosiaOS 
A hobby operating system written in x86 Assembly

## Features
- BIOS Bootloader
- FAT12 support
- LBA to CHS conversion
- INT 13h disk reading
- Kernel Loading (planned)
- Protected mode (planned)

## Project Structure
```
/boot       - Bootloader (BIOS, diskreading)
/kernel     - Kernel (planned)
/fs         - FAT12 filesystem integration (planned)
```

## Build & Run

### Requirements
- NASM (assembler)
- Bochs or QEMU emulator
- Git (optional)

### Build executable
```
make all
```

### Run in QEMU
```
make qemu
```

### Run in Bochs (Powershell/Windows)
```
.\Debug.ps1
```

---


## Goals
- [x] BIOS Boot
- [x] Disk Reading
- [ ] FAT12 parser
- [ ] Protected mode
- [ ] C Kernel
- [ ] Memory manager


## Screenshots

Coming soon.

## License 

This project is licensed under the BSD 3-Clause License.
See the LICENSE file for details.