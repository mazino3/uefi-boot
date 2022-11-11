bits 64

default rel

section .text

global start

%include "functions.asm"
%include "efi.asm"
%include "api.asm"

start:

    mov [ptrUEFI], rsp
    
    sub rsp, 4 * 8

    mov [hndImageHandle], rcx

    mov [ptrSystemTable], rdx

    call apiVerifySignature

    call apiOutputHeader

    call apiGetFrameBuffer

    call apiExitUEFI

    call apiLoadKernel
    
    add rsp, 4 * 8
    mov rax, EFI_SUCCESS
    ret

error:

    mov rsp, [ptrUEFI]
    ret

errorCode:
    push rax

    mov rcx, strErrorCode
    call efiOutputString

    mov rcx, [rsp]
    call funIntegerToAscii

    pop rax
    
    jmp error

codesize equ $ - $$

section .reloc


section .data
    strHeader               db   __utf16__ `Meow de test UEFI 64bits asm \r\nRunning on \0`
    strHeaderV              db   __utf16__ ` v\0`
    strErrorCode            db   __utf16__ `\r\n\nError Code #\0`
    strDebugText            db   __utf16__ `\r\n\nDebug: \0`

    ptrUEFI                 dq   0

    hndImageHandle          dq   0

    ptrSystemTable          dq   0

    ptrInterface            dq   0

    intMemoryMapSize        dq   EFI_MEMORY_DESCRIPTOR_size * 1024
    bufMemoryMap            resb EFI_MEMORY_DESCRIPTOR_size * 1024
    ptrMemoryMapKey         dq   0
    ptrMemoryMapDescSize    dq   0
    ptrMemoryMapDescVersion dq   0

    ptrFrameBuffer          dq   0

datasize equ $ - $$