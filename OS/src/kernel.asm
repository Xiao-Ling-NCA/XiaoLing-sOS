[org 0x0000] ;i jus did this cus i wus scared of memory stuff
[bits 16]
main:
    mov si, entered_kernel
    call print
    mov si, newLine
    call print

;=======================Main Shell================================
SHELL:
    call input
    jmp SHELL

;=======================PrintChar=================================
;Assumes that character is already loaded into al
printChar:
    mov ah, 0x0E
    int 0x10
    mov ax, 0
    ret
;=======================Print Function============================
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
;======================Shell Input===============================
input:
    push bx
    mov si, userCMD
    call print
    mov bx, userInput
loopInput:
    mov ax, 0
    int 0x16 ; calls bios scan
    
    ;see if its the return key
    cmp al, 0x0D
    je inputEnd
    
    ;see if its backspace
    cmp al, 0x08
    jne continueInput
    
    push cx
    call removeCharFromInputBuffer
    pop cx

    ;i didnt feel like calling print 3 times. just do it in quick succession

    mov al, 0x20
    int 0x10
    
    mov al, 0x08
    int 0x10

continueInput:
    ;mov al to the userinput
    mov [bx], al
    ;print user's character
    call printChar
    inc bx

    ;see if we went over the buffer
    mov cx, bx
    sub cx, userInput
    cmp cx, 76
    je inputEnd
    jmp loopInput

inputEnd:
    pop bx
    mov si, newLine
    call print

;==========Remove Character from input buffer====================
removeCharFromInputBuffer:
    sub bx, 1
    mov BYTE [bx], 0
    ret

;==========================ClearInputBuffer=====================
clearInputBuffer:
    ;reset bx
    mov bx, 0
    mov bx, userInput
clearInputBufferLoop:
    ;clear userInput buffer back to 0
    mov cx, bx
    sub cx, userInput
    cmp cx, 76
    je clearInputBufferEnd

    ;set buffer stuff to 0
    mov BYTE [bx], 0x0
    inc bx
    jmp clearInputBufferLoop

clearInputBufferEnd:
    ret

;======================Data Stuff================================
entered_kernel:
    db "Welcome to XiaoLingOS",0

userInput:
    times 76 db 0, 0

userCMD:
    db ">> ",0

newLine:
    db 0x0A, 0x0D,0

times 1024-($-$$) db 0