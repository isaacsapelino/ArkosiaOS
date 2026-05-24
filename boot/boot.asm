org 0x7c00
bits 16

%define ENDL 0Dh
%define NEWL 0Ah

jmp short start
nop

;== FAT 12 BIOS Parameter Block ==;
oemName:            db 'ARKOSIA1'
bytesPerSector:     dw 512
sectorsPerCluster:  db 1
reversedSectors:    dw 1
numberOfFATs:       db 2
rootEntries:        dw 224
totalSectors:       dw 2880
mediaDescriptor:    db 0F0h
sectorsPerFAT:      dw 9
sectorsPerTrack:    dw 18
numbHeads:          dw 2
hiddenSectors:      dd 0
largeSectors:       dd 0

;== Extended Boot Record ==;
driveNumber:        db 0
                    db 0
bootSignature:      db 0x29
volumeID:           dd 0x20261605
volumeLabel:        db "ARKOSIA  OS"
fileSystemType:     db "FAT12   "

ROOT_DIR_SECTORS   equ 14
FAT_SECTORS        equ 9
RESERVED_SECTORS   equ 1
FIRST_DATA_SECTOR  equ 33

start:
    cli
    xor ax, ax
    mov es, ax
    mov ds, ax
    mov ss, ax 
    mov sp, 0x7c00
    mov si, 0h
    sti

; LBA to CHS 
; For INT 13H Reference
; Sector = CL, Cylinder = CH, Head = DH
; DIV = DX:AX

lbaToChs:
    xor dx, dx
    div word [sectorsPerTrack]

    inc dx
    mov cl, dl

    xor dx, dx
    div word [numbHeads]

    mov ch, al
    mov dh, dl
    ret

; TTY Function
print:
    lodsb
    cmp al, 0
    je done

.next:
    mov ah, 0Eh
    int 10h
    jmp print

done:
    ret

msg_hello: db 'Loading Arkosia OS v0.0.1', ENDL, NEWL, 0
diskFailedMsg: db 'Cannot read disk!', ENDL, NEWL, 0
diskSuccessMsg: db 'Disk read successful.', ENDL, NEWL, 0
foundKernel: db 'Found Kernel', 0
kernelFile: db 'KERNEL  BIN'
times 510 - ($-$$) db 0
dw 0xAA55