kernel_api_general_error_protection:
    mov ax, 0x1000
    mov ss, ax
    mov ds, ax

    mov sp, 0xFFFF

    jmp 0x1000:0000

kernel_api_general_software_end:
    mov ax, 0x1000
    mov ss, ax
    mov ds, ax

    mov sp, 0xFFFF

    jmp shell
