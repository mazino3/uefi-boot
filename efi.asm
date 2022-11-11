EFI_SUCCESS                       equ 0
EFI_LOAD_ERROR                    equ 0x8000000000000001 ; 9223372036854775809
EFI_INVALID_PARAMETER             equ 0x8000000000000002 ; 9223372036854775810
EFI_UNSUPPORTED                   equ 0x8000000000000003 ; 9223372036854775811
EFI_BAD_BUFFER_SIZE               equ 0x8000000000000004 ; 9223372036854775812
EFI_BUFFER_TOO_SMALL              equ 0x8000000000000005 ; 9223372036854775813
EFI_NOT_READY                     equ 0x8000000000000006 ; 9223372036854775814
EFI_NOT_FOUND                     equ 0x8000000000000014 ; 9223372036854775828

EFI_SYSTEM_TABLE_SIGNATURE        equ 0x5453595320494249

EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID db 0xde, 0xa9, 0x42, 0x90, 0xdc, 0x23, 0x38, 0x4a
                                  db 0x96, 0xfb, 0x7a, 0xde, 0xd0, 0x80, 0x51, 0x6a

%macro UINTN 0
    RESQ 1
    alignb 8
%endmacro

%macro UINT32 0
    RESD 1
    alignb 4
%endmacro

%macro UINT64 0
    RESQ 1
    alignb 8
%endmacro

%macro EFI_HANDLE 0
    RESQ 1
    alignb 8
%endmacro

%macro POINTER 0
    RESQ 1
    alignb 8
%endmacro

struc EFI_TABLE_HEADER
    .Signature  UINT64
    .Revision   UINT32
    .HeaderSize UINT32
    .CRC32      UINT32
    .Reserved   UINT32
endstruc

struc EFI_SYSTEM_TABLE
    .Hdr                  RESB EFI_TABLE_HEADER_size
    .FirmwareVendor       POINTER
    .FirmwareRevision     UINT32
    .ConsoleInHandle      EFI_HANDLE
    .ConIn                POINTER
    .ConsoleOutHandle     EFI_HANDLE
    .ConOut               POINTER
    .StandardErrorHandle  EFI_HANDLE
    .StdErr               POINTER
    .RuntimeServices      POINTER
    .BootServices         POINTER
    .NumberOfTableEntries UINTN
    .ConfigurationTable   POINTER
endstruc

struc EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL
    .Reset             POINTER
    .OutputString      POINTER
    .TestString        POINTER
    .QueryMode         POINTER
    .SetMode           POINTER
    .SetAttribute      POINTER
    .ClearScreen       POINTER
    .SetCursorPosition POINTER
    .EnableCursor      POINTER
    .Mode              POINTER
endstruc

struc EFI_BOOT_SERVICES
    .Hdr                                 RESB EFI_TABLE_HEADER_size
    .RaiseTPL                            POINTER
    .RestoreTPL                          POINTER
    .AllocatePages                       POINTER
    .FreePages                           POINTER
    .GetMemoryMap                        POINTER
    .AllocatePool                        POINTER
    .FreePool                            POINTER
    .CreateEvent                         POINTER
    .SetTimer                            POINTER
    .WaitForEvent                        POINTER
    .SignalEvent                         POINTER
    .CloseEvent                          POINTER
    .CheckEvent                          POINTER
    .InstallProtocolInterface            POINTER
    .ReinstallProtocolInterface          POINTER
    .UninstallProtocolInterface          POINTER
    .HandleProtocol                      POINTER
    .Reserved                            POINTER
    .RegisterProtocolNotify              POINTER
    .LocateHandle                        POINTER
    .LocateDevicePath                    POINTER
    .InstallConfigurationTable           POINTER
    .LoadImage                           POINTER
    .StartImage                          POINTER
    .Exit                                POINTER
    .UnloadImage                         POINTER
    .ExitBootServices                    POINTER
    .GetNextMonotonicCount               POINTER
    .Stall                               POINTER
    .SetWatchdogTimer                    POINTER
    .ConnectController                   POINTER
    .DisconnectController                POINTER
    .OpenProtocol                        POINTER
    .CloseProtocol                       POINTER
    .OpenProtocolInformation             POINTER
    .ProtocolsPerHandle                  POINTER
    .LocateHandleBuffer                  POINTER
    .LocateProtocol                      POINTER
    .InstallMultipleProtocolInterfaces   POINTER
    .UninstallMultipleProtocolInterfaces POINTER
    .CalculateCrc32                      POINTER
    .CopyMem                             POINTER
    .SetMem                              POINTER
    .CreateEventEx                       POINTER
endstruc

struc EFI_RUNTIME_SERVICES
    .Hdr                       RESB EFI_TABLE_HEADER_size
    .GetTime                   POINTER
    .SetTime                   POINTER
    .GetWakeupTime             POINTER
    .SetWakeupTime             POINTER
    .SetVirtualAddressMap      POINTER
    .ConvertPointer            POINTER
    .GetVariable               POINTER
    .GetNextVariableName       POINTER
    .SetVariable               POINTER
    .GetNextHighMonotonicCount POINTER
    .ResetSystem               POINTER
    .UpdateCapsule             POINTER
    .QueryCapsuleCapabilities  POINTER
    .QueryVariableInfo         POINTER
endstruc

struc EFI_GRAPHICS_OUTPUT_PROTOCOL
    .QueryMode POINTER
    .SetMode   POINTER
    .Blt       POINTER
    .Mode      POINTER
endstruc

struc EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE
    .MaxMode         UINT32
    .Mode            UINT32
    .Info            POINTER
    .SizeOfInfo      UINTN
    .FrameBufferBase UINT64
    .FrameBufferSize UINTN
endstruc

struc EFI_MEMORY_DESCRIPTOR
    .Type          UINT32
    .PhysicalStart POINTER
    .VirtualStart  POINTER
    .NumberOfPages UINT64
    .Attribute     UINT64
endstruc


efiOutputString:
    mov rdx, rcx
    mov rcx, [ptrSystemTable]

    mov rcx, [rcx + EFI_SYSTEM_TABLE.ConOut]

    call [rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.OutputString]

    cmp rax, EFI_SUCCESS
    jne errorCode
    
    ret

efiClearScreen:
    mov rcx, [ptrSystemTable]

    mov rcx, [rcx + EFI_SYSTEM_TABLE.ConOut]

    call [rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.ClearScreen]

    cmp rax, EFI_SUCCESS
    jne errorCode
    
    ret

efiLocateProtocol:

    mov rax, [ptrSystemTable]

    mov rax, [rax + EFI_SYSTEM_TABLE.BootServices]

    mov rcx, EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID

    mov rdx, 0

    lea r8, [ptrInterface]

    call [rax + EFI_BOOT_SERVICES.LocateProtocol]

    cmp rax, EFI_SUCCESS
    jne errorCode
    
    ret

efiGetMemoryMap:
    mov rax, [ptrSystemTable]

    mov rax, [rax + EFI_SYSTEM_TABLE.BootServices]

    lea rcx, [intMemoryMapSize]
    
    lea rdx, [bufMemoryMap]

    lea r8, [ptrMemoryMapKey]

    lea r9, [ptrMemoryMapDescSize]

    lea r10, [ptrMemoryMapDescVersion]

    mov rbx, rsp

    push r10

    call [rax + EFI_BOOT_SERVICES.GetMemoryMap]

    cmp rax, EFI_SUCCESS
    jne errorCode

    mov rsp, rbx
    
    ret

efiExitBootServices:
    mov rax, [ptrSystemTable]

    mov rax, [rax + EFI_SYSTEM_TABLE.BootServices]

    mov rcx, [hndImageHandle]

    mov rdx, [ptrMemoryMapKey]

    call [rax + EFI_BOOT_SERVICES.ExitBootServices]
    
    cmp rax, EFI_SUCCESS
    jne errorCode
    
    ret