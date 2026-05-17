[bits 16]

section .text
;lba expects a 18 sector track
lba_to_chs:
    push bp
    mov bp, sp
    push ax
    push bx

    xor bx, bx
    xor ax, ax

    ;cylinder calculation
    mov al, [head_per_cylinder]
    mov bl, [sectors_per_track]
    mul bl

    mov bl, al

    mov ax, [bp+4] ;lba
    div bl

    mov ch, al

    ;head calculation
    xor bx, bx
    xor ax, ax

    mov ax, [bp + 4] ;lba
    mov bl, [sectors_per_track]
    div bl

    xor ah, ah
    mov bl, [head_per_cylinder]
    div bl
    mov dh, ah

    ;sector calculation
    xor bx, bx
    xor ax, ax

    mov ax, [bp+4]
    mov bl, [sectors_per_track]
    div bl
    inc ah

    mov cl, ah
    
    xor bx, bx
    xor ax, ax

    pop bx
    pop ax
    pop bp
    ret

section .data
head_per_cylinder:
    db 2
sectors_per_track:
    db 18