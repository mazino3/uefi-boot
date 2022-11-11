apiVerifySignature:
    mov rcx, [ptrSystemTable]
    mov rcx, [rcx + EFI_SYSTEM_TABLE.Hdr + EFI_TABLE_HEADER.Signature]
    mov rdx, EFI_SYSTEM_TABLE_SIGNATURE
    mov rax, EFI_LOAD_ERROR
    
    cmp rdx, rcx
    jne error
    
    mov rax, EFI_SUCCESS
    
    ret

apiOutputHeader:
    call efiClearScreen
    
    mov rcx, strHeader
    call efiOutputString
    
    mov rcx, [ptrSystemTable]
    mov rcx, [rcx + EFI_SYSTEM_TABLE.FirmwareVendor]
    call efiOutputString
    
    mov rcx, strHeaderV
    call efiOutputString
    
    mov rcx, [ptrSystemTable]
    mov rcx, [rcx + EFI_SYSTEM_TABLE.FirmwareRevision]
    call funIntegerToAscii
    
    ret

apiGetFrameBuffer:
    call efiLocateProtocol

    mov rcx, [ptrInterface]
    mov rcx, [rcx + EFI_GRAPHICS_OUTPUT_PROTOCOL.Mode]
    mov rcx, [rcx + EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE.FrameBufferBase]
    
    mov [ptrFrameBuffer], rcx
    
    ret

apiExitUEFI:
    call efiGetMemoryMap
    call efiExitBootServices
    
    ret

apiLoadKernel:

    mov rcx, [ptrFrameBuffer]

    mov rdx, 0

    mov r8, 1024 * 100
    
    call funDrawLine
    
    ret