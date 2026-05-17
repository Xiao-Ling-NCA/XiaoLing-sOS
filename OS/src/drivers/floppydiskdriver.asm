[bits 16]
[org 0x0000]

section .text
    lba_to_chs:
        push bp
        mov bp, sp

        push ax
        push bx
        push dx
        push si

        mov si, sp ;si now becomes our "variable stack" where it tells us where variables end

        xor ax, ax
        xor bx, bx
        xor dx, dx
        
        ;1. temp value
        mov ax, [bp + 4]
        mov bl, [sectors_per_track] ;since was defined as byte, I now need to do this bullshit forever
        div bx

        ;4. increment remainder and move to cl
        inc dx
        mov cl, dl

        ;back to step 1
        push ax ;temp value onto the stack

        ;2. cylinder
        xor ax, ax
        xor bx, bx
        xor dx, dx
        
        mov ax, [si - 2] ; this SHOULD hold the temp value??
        mov bl, [heads_per_cylinder] ; converts to word for 16 bit division
        div bx
        mov ch, al

        ;3. head
        mov bx, dx ; temp mod head per cylinder
        mov sp, si ; reset sp (like arena allocation but for the unhinged)
        pop si
        pop dx
        mov dh, bl ;bl holds the lower portion of head count which is convenient on the 8086
        
        pop bx
        pop ax

        pop bp
        ret

    ;expects in the following order: num sectors , es, bx, lba
    load_sector:
        push bp
        mov bp, sp

        pusha
        push es

        push [bp + 4]
        call lba_to_chs

        pop [bp + 4]
        mov bx, [bp + 8]
        mov es, bx
        mov bx, [bp + 6]

        mov ax, [bp + 10]
        mov ah, 0x02 

        int 0x13

        pop es
        popa

        pop bp
        ret

section .data
    heads_per_cylinder:
        db 2
    sectors_per_track:
        db 18
