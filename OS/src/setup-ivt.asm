; i know there isnt a lot of these interrupts,
; however, its clearly enough for a 16 bit environment
; I made a general error protection
; I also made a software end. What else do you want twin.
; if you need print and println and all the stuff in bios-tools, you better learn how to do far jumps or write your own
; I have zero idea on how software engineering works LMAO yall are on your own

ivt:
    ;we're moving ds where the IVT is
    push ds
    mov ax, 0
    mov ds, ax

    ;we'll setup divide by zero
    mov word [0x0000], kernel_api_general_error_protection
    mov word [0x0002], 0x1000

    ;this is how the software ends
    mov word [0x0200], kernel_api_general_software_end
    mov word [0x0202], 0x1000

    pop ds 
    ret
