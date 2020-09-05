section .bss
    a:          resb    10
    b:          resb    10
    s:          resb    10
    st:         resd    1

section .data

section .text
global  _start
_start:
    mov         edx, 10         ; number of bytes to read
    mov         ecx, a          ; reversed space to store input a 
    mov         ebx, 0          ; write to STDIN file
    mov         eax, 3          ; invoke SYS_READ (kernel opcode 3)
    int         0x80            ; call kernel
   
    mov         edx, 10         ; number of bytes to read
    mov         ecx, b          ; reversed space to store input b
    mov         ebx, 0          ; write to STDIN file
    mov         eax, 3          ; invoke SYS_READ (kernel opcode 3)
    int         0x80            ; call kernel
    
    mov         edx, 0          ; edx is initialized to 0 
    mov         eax, a          ; move buffer a to eax
    call        atoi            ; convert a (string) to a (integer)
    add         edx, eax        ; add eax to edx

    mov         eax, b          ; move buffer b to eax
    call        atoi            ; convert string to integer
    add         eax, edx        ; add edx to eax (eax hold sum of 2 user inputs)
    
    call        iprint          ; print out the result

    mov         eax, 4
    mov         ebx, 1
    mov         ecx, 0xa        ; print linefeed
    mov         edx, 1
    int         0x80

    mov         ebx, 0          ; return 0 status on exit - "No ERRORS"
    mov         eax, 1          ; invoke SYS_EXIT (kernel opcode 1)
    int         0x80            ; call kernel

atoi:
    push        esi
    push        ecx
    push        ebx
    push        edx

    mov         esi, eax        ; move pointer in eax into esi (eax hold the buffer number)
    mov         eax, 0          ; initialized eax with 0
    mov         ecx, 0          ; initialized ecx with 0

    .loop:
        xor             ebx, ebx    ; reset lower upper bytes of ebx with 0
        mov             bl, [esi + ecx] ;move a single byte into ebx register lower half
        cmp             bl, 48      ; compare ebx lowerhalf against '0'
        jl              .break      ; if less jump to atoi.break
        cmp             bl, 57      ; compare ebx lowerhalf against '9'
        jg              .break      ; if greater jump to atoi.break

        sub             bl, 48      ; subtract ebx lowerhalf to 48 (make '0' become 0)
        add             eax, ebx    ; add ebx to integer value in eax
        mov             ebx, 10     ; move 10 into ebx
        mul             ebx         ; multiply eax by ebx 
        inc             ecx         ; increment ecx (counter register)
        jmp             .loop       ; continue loop

    .break:
        cmp             ecx, 0      ; compare ecx value against 0
        je              .res        ; if equals jump to atoi.res
        mov             ebx, 10     ; move 10 into ebx
        div             ebx         ; divide eax by ebx (10)

    .res:
        pop     edx
        pop     ebx
        pop     ecx
        pop     esi

        ret                     ; result is in eax

iprint:
    push        edi
    push        edx
    push        ebx

    mov         dword[st], 0    ; st <- 0
    mov         edi, s          ; edi points to sumstring
    add         edi, 9          ; move to the last element of string
    xor         edx, edx        ; clear

    .nz:
        mov             ebx, 10         ; move 10 to ebx
        div             ebx             ; divide by 10
        add             edx, '0'        ; int to ascii
        mov             byte[edi], dl   ; put into string
        dec             edi             ; move to next char
        inc             dword[st]       ; inc char count
        xor             edx, edx
        cmp             eax, 0          ; remainder = 0?
        jne             .nz             ; not = 0 -> continue
        
    inc         edi             
    mov         ecx, edi            ; edi again points to sumstring
    mov         edx, [st]           ; number of byte = st 
    mov         eax, 4
    mov         ebx, 1
    int         0x80

    pop         ebx
    pop         edx
    pop         edi

    ret
