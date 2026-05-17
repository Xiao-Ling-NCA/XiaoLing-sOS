[org 0x0000]
[bits 16]

extern kmain

%macro clear_register 1
    xor %1, %1
%endmacro

%macro clearall 0
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor si, si
    xor di, di
%endmacro

main:
    mov [drive_num], dl ;we keep dl from the previous boot

    clearall
    
    cli
    call setup_ivt
    sti

load_kernel: ;this is where we will need a fat12 driver in assembly
    ;to be implemented later
hard_reset:
    ;this is stuff we have to do in case we were loading from a crash by 0/0
    ;resetting video buffer
    mov ax, 0x0040
    mov es, ax
    mov di, 0x001E
    mov cx, 16
    clear_register ax
    rep stosw ;w gemini optimization, I didnt even know this existed, I was about to use repeated increments

    mov word [es:0x1A], 0x001E
    mov word [es:0x1C], 0x001E

jump_to_kernel:
    ;now we bring all the registers back to the original state
    clearall

    ;setup
    mov bx, 0x2000
    mov ds, bx
    mov es, bx
    mov ss, bx
    mov sp, 0xFFFF
    clear_register bx
    ;now 0x1000:0000 is taken by the second stage bootloader
    ;0x3000:0000 is where the usermode stuff would exist
    jmp 0x2000:0000



setup_ivt:
    ;we setup the place for the IVT table at 0x0000:0000
    clear_register ax
    mov es, ax
    clear_register di

    ;division by 0 problem: abandon program and restart operating system
    mov word [es:di], main
    add di, 2
    mov word [es:di], 0x1000

    ;overflow trap
    mov di, 0x10
    mov word [es:di], not_my_problem_exceptions
    add di, 2
    mov word [es:di], 0x1000

    ;terminate program 0x20
    mov di, 0x80
    mov word [es:di], hard_reset
    add di, 2
    mov word [es:di], 0x1000

    ;for safety, int 0x25 and 0x26 must be re-routed
    mov di, 0x94
    mov word [es:di], not_my_problem_exceptions
    add di, 2
    mov word [es:di], 0x1000

    mov di, 0x98
    mov word [es:di], not_my_problem_exceptions
    add di, 2
    mov word [es:di], 0x1000    

    ;because our OS is a single tasker, we will just copy over the code for termination for 0x27
    mov di, 0x9C
    mov word [es:di], hard_reset
    add di, 2
    mov word [es:di], 0x1000

    ;interrupt 21
    mov di, 0x84
    mov word [es:di], int_21_handler
    add di, 2
    mov word [es:di], 0x1000

    ret

not_my_problem_exceptions:
    iret

int_21_handler:
    ;basic DOS interrupts to implement
    cmp ah, 0x4C
    je int_21_quit_program

int_21_quit_program:
    jmp hard_reset
int_21_open_file:
    ;open file
    jmp int_handler_end
int_21_close_file:
    ;close file
    jmp int_handler_end
int_21_read_io:
    ;read file/device
    jmp int_handler_end

int_handler_end:
    iret


drive_num:
    db 0

%include "../drivers/floppydiskdriver.asm"