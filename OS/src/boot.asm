[org 0x7C00]
[bits 16]

mov ax, 0
mov ds, ax

;immediately save the boot number
mov [diskNum], dl

boot:
    call loadingKernelOntoMemory
    jmp loadKernel

loadingKernelOntoMemory:
    mov si, 0x0000 ;prevent any shenanegans
    mov ax, 0x2000
    mov es, ax
    mov bx, 0x0000
    
    ;imma start trying some stuff rq here dont mind me
    mov ah, 0x02
    mov al, 2 ; reads 1 sector
    mov ch, 0 ; cylinder 0
    mov cl, 2 ; setor 2
    mov dh, 0 ; head 0
    mov dl, [diskNum]

    int 0x13

    jc diskReadFailure

    ret

loadKernel:
    cli

    ; People give me crap about using 2x64kb segments.
    ; Since the 8086 has 1MB of ram, 
    ; using 128kb of space for data, code and stack is big
    ; But I always ask them this: what cpu runs your operating system?
    ; Exactly. 
    ; The easier the engineering, the more time I get to goon

    ;stack segment
    mov ax, 0x3000
    mov ss, ax 
    mov sp, 0xFFFF ;sets stack pointer at the top of the entire 64kb segment
    ;data segment
    mov ax, 0x2000
    mov ds, ax
    mov es, ax
    sti 
magicstuff:
    ;ts is so peak
    jmp 0x2000:0000
    
    ;to prevent my stupidity, emergency hang is here
    ;i dont think it even does anything
    ;But I hope that it stops print fr.
    jmp $

print:
    mov ah, 0x0E
printLoop:
    lodsb
    cmp al, 0
    je printEnd
    int 0x10
    jmp printLoop
printEnd:
    ret    

diskReadFailure:
    pusha
    mov ax, 0
    mov si, diskFailedMsg
    call print
    popa

    jmp $

diskNum:
    db 0
diskFailedMsg:
    db "Failed to read disk :(",0

times 510-($-$$) db 0
db 0x55, 0xaa
