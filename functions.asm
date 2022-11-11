funIntegerToAscii:
    push rbx
    push rsi

    mov rax, rcx

    mov rbx, 0


funIntegerToAsciiDivide:

    inc rbx

    mov rdx, 0
    
    mov rsi, 10
    idiv rsi

    add rdx, 48

    push rdx

    cmp rax, 0
    jnz funIntegerToAsciiDivide

funIntegerToAsciiOutput:
    dec rbx

    mov rcx, rsp

    call efiOutputString
    pop rax

    cmp rbx, 0
    jnz funIntegerToAsciiOutput

    pop rsi
    pop rbx
    
    ret


funLoopForever:
    jmp funLoopForever

funDrawLine:
    mov [rcx + rdx], byte 0x00     ; blue
    mov [rcx + rdx + 1], byte 0x00 ; green
    mov [rcx + rdx + 2], byte 0xFF ; red
    mov [rcx + rdx + 3], byte 0xFF ; alpha

    add rdx, 4

    cmp rdx, r8
    jne funDrawLine
    
    ret