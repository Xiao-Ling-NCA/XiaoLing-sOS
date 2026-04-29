[org 0x0000] ;i jus did this cus i wus scared of memory stuff
[bits 16]
main:
    call clear_screen

    push entered_kernel
    call print
    pop bx
    mov bx, 0

    ;YAY WE GOT GENERAL PROTECTION NOW
    call ivt

    ;now we can do shell stuff which is cool
    jmp shell

entered_kernel:
    db "Welcome to XiaoLingOS",0


%include "src/shell.asm"
%include "src/bios-tools.asm"
%include "src/setup-ivt.asm"
%include "src/kernel-api.asm"