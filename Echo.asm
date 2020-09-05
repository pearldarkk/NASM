section .bss
    inp:        resb 32

section .data

section .text
global _start
_start:
    mov         edx, 32         ; read 32 bytes
    mov         ecx, inp        ; reverse space to store inp
    mov         ebx, 0          ; write to STDIN file
    mov         eax, 3          ; invoke SYS_READ
    int         0x80

    push        eax             ; save input's number of bytes

    pop         edx             ; get number of bytes back
    mov         ecx, inp
    mov         ebx, 1          ; write to STDOUT file
    mov         eax, 4          ; invoke SYS_WRITE
    int         0x80

    mov         edx, 1
    mov         ecx, 0xa
    mov         ebx, 1
    mov         eax, 4

    mov         ebx, 0          ; return 0 status on exit
    mov         eax, 1          ; invoke SYS_EXIT
    int         0x80
    
