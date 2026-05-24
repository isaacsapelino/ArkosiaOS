org 0x0

start:

    mov si, msg_hello
    call print

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

msg_hello: db 'Hello World', 0
times 510-($-$$) db 0