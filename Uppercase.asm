section         .bss
    s:          resb 33

section         .text
global          _start
_start:
    mov         edx, 33
    mov         ecx, s
    mov         ebx, 0
    mov         eax, 3
    int         0x80
    
    push        eax             ; strlen

    call        toUpper

    pop         edx
    mov         ecx, s
    mov         ebx, 1
    mov         eax, 4
    int         0x80

    mov         edx, 1
    mov         ecx, 0xa
    mov         ebx, 1
    mov         eax, 4
    int         0x80

    mov         ebx, 0
    mov         eax, 1
    int         0x80

toUpper:
    xor         eax, eax        ; clear eax
    mov         al, [ecx]       ; move one byte into al
    cmp         al, 0           ; if end
    jz          .break
    cmp         al, 'a'         ; compare with 'a'
    jl          .nextchar
    cmp         al, 'z'         ; compare with 'z'
    jg          .nextchar 
    sub         al, 0x20        ; to uppercase
    mov         [ecx], al
    
    .nextchar:
        inc     ecx
        jmp     toUpper

    .break:
        ret
