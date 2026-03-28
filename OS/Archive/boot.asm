[org 0x7C00]
bits 16

;scrolls the screen
int 0x07

mov si, text
call print
jmp loopFunctionality
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

input:
    push bx
    mov bx, userInput
loopInput:
    mov ax, 0
    int 0x16 ; calls bios scan
    
    ;see if its the return key
    cmp al, 0x0D
    je inputEnd

    ;mov al to the userinput
    mov [bx], al
    inc bx

    ;see if we went over the buffer
    mov cx, bx
    sub cx, userInput
    cmp cx, 30
    je inputEnd
    jmp loopInput

inputEnd:
    pop bx
    mov si, newLine
    call print

    mov si, userInput
    call print

clearBuffer:
    ;reset bx
    mov bx, 0
    mov bx, userInput
clearBufferLoop:
    ;clear userInput buffer back to 0
    mov cx, bx
    sub cx, userInput
    cmp cx, 30
    je clearBufferEnd

    ;set buffer stuff to 0
    mov BYTE [bx], 0x0
    inc bx
    jmp clearBufferLoop

clearBufferEnd:
    ret

loopFunctionality:
    call input
    
    call clearBuffer
    
    mov si, newLine
    call print

    jmp loopFunctionality

text:
    db ">> ",0
userInput:
    times 30 db 0, 0

newLine:
    db 0x0A, 0x0D
times 510-($-$$) db 0
db 0x55, 0xaa
