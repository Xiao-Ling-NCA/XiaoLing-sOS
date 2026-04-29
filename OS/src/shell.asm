shell:
    call recieve_char_and_print

    jmp shell

get_input_at_prev_line:
    mov cx, 0
    cmp cx, 81
    je get_input_at_prev_line_end

    inc cx
    jmp get_input_at_prev_line
get_input_at_prev_line_end:
    ret

;This is a function that gets user input and displays it out on the screen
;i kept the character in al for a good reason
recieve_char_and_print:
    push bp
    mov bp, sp

    mov ah, 0x00
    int 0x16

    cmp al,0x08
    je r_c_a_p_case_backspace

    cmp al, 0x0D
    je r_c_a_p_case_enter

    jmp r_c_a_p_case_default
r_c_a_p_case_backspace:
    push ax
    call print_char

    push word 0x00
    call print_char

    pop ax
    mov ax, 0

    call print_char

    pop ax 
    jmp recieve_char_and_print_end

r_c_a_p_case_enter:
    push word 0x0D
    call print_char

    pop ax
    mov ax, 0x0A
    push ax

    call print_char

    pop ax
    
    jmp recieve_char_and_print_end

r_c_a_p_case_default:
    push ax
    call print_char
    pop ax

recieve_char_and_print_end:
    pop bp
    ret

user_input_buffer:
    times 81 db 0