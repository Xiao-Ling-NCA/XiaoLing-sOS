;print string onto bios
print:
    push bp
    mov bp, sp
    
    ;<address (2 bytes)> , <return address (2 bytes)>, <base pointer (2 bytes)>

    mov si, [bp+4]

    push ax
    mov ah, 0x0E

    jmp print_loop

print_loop:
    lodsb
    cmp al, 0
    je print_end
    int 0x10
    jmp print_loop

print_end:
    pop ax
    pop bp
    ret

;print but with enter
println:
    push bp
    mov bp, sp
    
    ;<address (2 bytes)> , <return address (2 bytes)>, <base pointer (2 bytes)>

    mov si, [bp+4]

    push ax
    mov ah, 0x0E

    jmp println_loop

println_loop:
    lodsb
    cmp al, 0
    je println_end
    int 0x10
    jmp println_end

println_end:
    ;hit enter

    mov al, 0x0D
    int 0x10

    mov al, 0x0A
    int 0x10

    pop ax
    pop bp
    ret

print_char:
    push bp
    mov bp, sp
    push ax

    mov ax, [bp+4]
    mov ah, 0x0E
    int 0x10

    pop ax
    pop bp

    ret

;clear screen
clear_screen:
    mov byte ah, 0x0
    mov byte al, 0x03
    int 0x10
    ret

get_char_at_cursor:
    push bp
    mov bp, sp

    mov ah, 0x08
    mov bh, 0x00

    int 0x10

    pop bp
    ret

get_cursor_position:
    push bp
    mov bp, sp

    mov ax, 0x00
    mov ah, 0x03
    mov bh, 0x00
    int 0x10

    pop bp
    ret

set_cursor_position:
    push bp
    mov bp, sp
    mov ah, 0x02
    mov bh, 0x00

    int 0x10

;moves cursor up
cursor_up:
    push bp
    mov bp, sp

    push ax
    push bx
    push dx

    call get_cursor_position
    dec dh

    call set_cursor_position

    pop dx
    pop bx
    pop ax

    pop bp
    ret

cursor_down:
    push bp
    mov bp, sp

    push ax
    push bx
    push dx

    call get_cursor_position
    inc dh

    call set_cursor_position

    pop dx
    pop bx
    pop ax

    pop bp
    ret  

cursor_left:
    push bp
    mov bp, sp

    push ax
    push bx
    push dx

    call get_cursor_position
    dec dl 

    call set_cursor_position

    pop dx
    pop bx
    pop ax

    pop bp
    ret

cursor_right:
    push bp
    mov bp, sp

    push ax
    push bx
    push dx

    call get_cursor_position
    inc dl

    call set_cursor_position

    pop dx
    pop bx
    pop ax

    pop bp
    ret
cursor_horizontal_reset:
    push bp
    mov bp, sp

    push ax
    push bx
    push dx

    call get_cursor_position
    mov dh, 0x00

    call set_cursor_position

    pop dx
    pop bx
    pop ax

    pop bp
    ret