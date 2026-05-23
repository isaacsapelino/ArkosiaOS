org 0x7c00
bits 16

%define ENDL 0Dh
%define NEWL 0Ah

jmp short start
nop

;== FAT 12 BIOS Parameter Block ==;
oemName:            db 'ARKOSIA1'
bytesPerSector:     dw 512
sectorsPerCLuster:  db 1
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

start:
    cli
    xor ax, ax
    mov es, ax
    mov ds, ax
    mov ss, ax 
    mov sp, 0x7c00
    mov si, 0h
    sti

    mov si, msg_hello
    call print

    mov ax, 1
    mov bx, 0x1000
    mov es, bx
    mov bx, 0x0000
    call readDisk
    xchg bx, bx     ; Bochs Debugging

hang:
    hlt


; LBA to CHS 
; For INT 13H Reference
; Sector = CL, Cylinder = CH, Head = DH
; DIV = DX:AX


lba_to_chs:
    push ax
    push dx

    xor dx, dx
    div word [sectorsPerTrack]
    inc dx
    
    push dx

    xor dx, dx
    div word [numbHeads]

    mov ch, dl
    pop dx
    mov cl, dl
    pop dx
    mov dh, al
    pop ax
    ret

readDisk:
    push ax
    push bx
    push cx
    push dx

.retry:
    call lba_to_chs
    mov ah, 0x02
    mov al, 0x01
    mov dl, 0x00

    int 0x13
    jc .error

.success:
    pop ax
    pop bx
    pop cx
    pop dx
    mov si, diskSuccessMsg
    call print
    ret

.error:
    pop ax
    pop bx
    pop cx
    pop dx
    mov si, diskFailedMsg
    call print
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
retry_count: db 3
times 510 - ($-$$) db 0
dw 0xAA55