%ifndef uefi
%define uefi

; Largely based on the UEFI library for fasm by bzt: https://wiki.osdev.org/Uefi.inc

%include "utils.asm"

; Structure Signatures
EFI_SYSTEM_TABLE_SIGNATURE equ 0x5453595320494249

; Error codes
EFI_ERR                 equ 0x8000000000000000
EFI_SUCCESS			    equ 0
EFI_LOAD_ERROR			equ (EFI_ERR | 1)
EFI_INVALID_PARAMETER	equ (EFI_ERR | 2)
EFI_UNSUPPORTED 		equ (EFI_ERR | 3)
EFI_BAD_BUFFER_SIZE		equ (EFI_ERR | 4)
EFI_BUFFER_TOO_SMALL	equ (EFI_ERR | 5)
EFI_NOT_READY			equ (EFI_ERR | 6)
EFI_DEVICE_ERROR		equ (EFI_ERR | 7)
EFI_WRITE_PROTECTED		equ (EFI_ERR | 8)
EFI_OUT_OF_RESOURCES	equ (EFI_ERR | 9)
EFI_VOLUME_CORRUPTED	equ (EFI_ERR | 10)
EFI_VOLUME_FULL 		equ (EFI_ERR | 11)
EFI_NO_MEDIA			equ (EFI_ERR | 12)
EFI_MEDIA_CHANGED		equ (EFI_ERR | 13)
EFI_NOT_FOUND			equ (EFI_ERR | 14)
EFI_ACCESS_DENIED		equ (EFI_ERR | 15)
EFI_NO_RESPONSE 		equ (EFI_ERR | 16)
EFI_NO_MAPPING			equ (EFI_ERR | 17)
EFI_TIMEOUT			    equ (EFI_ERR | 18)
EFI_NOT_STARTED 		equ (EFI_ERR | 19)
EFI_ALREADY_STARTED		equ (EFI_ERR | 20)
EFI_ABORTED			    equ (EFI_ERR | 21)
EFI_ICMP_ERROR			equ (EFI_ERR | 22)
EFI_TFTP_ERROR			equ (EFI_ERR | 23)
EFI_PROTOCOL_ERROR		equ (EFI_ERR | 24)

;structures
struc EFI_TABLE_HEADER
    .Signature    		int64
    .Revision     		int32
    .HeaderSize   		int32
    .CRC32        		int32
    .Reserved     		int32
endstruc

struc EFI_SYSTEM_TABLE
    .Hdr                    structure(EFI_TABLE_HEADER)
    .FirmwareVendor         pointer
    .FirmwareRevision       int64
    .ConsoleInHandle        pointer
    .ConIn 	                pointer
    .ConsoleOutHandle       pointer
    .ConOut	                pointer
    .StandardErrorHandle    pointer
    .StdErr	                pointer
    .RuntimeServices        pointer
    .BootServices	        pointer
    .NumberOfTableEntries   int64
    .ConfigurationTable     pointer
endstruc

struc EFI_BOOT_SERVICES_TABLE
    .Hdr		       	                    structure(EFI_TABLE_HEADER)

    ; Task Priority Services
    .RaisePriority		                    pointer
    .RestorePriority	                    pointer

    ; Memory Services
    .AllocatePages		                    pointer
    .FreePages		                        pointer
    .GetMemoryMap		                    pointer
    .AllocatePool		                    pointer
    .FreePool		                        pointer

    ; Event & Timer Services
    .CreateEvent		                    pointer
    .SetTimer		                        pointer
    .WaitForEvent		                    pointer
    .SignalEvent		                    pointer
    .CloseEvent		                        pointer
    .CheckEvent		                        pointer

    ; Protocol Handler Services
    .InstallProtocolInterface               pointer
    .ReInstallProtocolInterface             pointer
    .UnInstallProtocolInterface             pointer
    .HandleProtocol	                        pointer
    .Void			                        pointer
    .RegisterProtocolNotify                 pointer
    .LocateHandle		                    pointer
    .LocateDevicePath	                    pointer
    .InstallConfigurationTable              pointer

    ; Image Services
    .ImageLoad		                        pointer
    .ImageStart		                        pointer
    .Exit			                        pointer
    .ImageUnLoad		                    pointer
    .ExitBootServices	                    pointer

    ; Miscellaneous Services
    .GetNextMonotonicCount	                pointer
    .Stall			                        pointer
    .SetWatchdogTimer	                    pointer

    ; DriverSupport Services
    .ConnectController	                    pointer
    .DisConnectController	                pointer

    ; Open and Close Protocol Services
    .OpenProtocol		                    pointer
    .CloseProtocol		                    pointer
    .OpenProtocolInformation                pointer

    ; Library Services
    .ProtocolsPerHandle	                    pointer
    .LocateHandleBuffer	                    pointer
    .LocateProtocol	                        pointer
    .InstallMultipleProtocolInterfaces      pointer
    .UnInstallMultipleProtocolInterfaces    pointer

    ; 32-bit CRC Services
    .CalculateCrc32	                        pointer

    ; Miscellaneous Services
    .CopyMem		                        pointer
    .SetMem		                            pointer
    .CreateEventEx                          pointer
endstruc

struc EFI_RUNTIME_SERVICES_TABLE
    .Hdr		       	    structure(EFI_TABLE_HEADER)
    .GetTime		        pointer
    .SetTime		        pointer
    .GetWakeUpTime		    pointer
    .SetWakeUpTime		    pointer
    .SetVirtualAddressMap	pointer
    .ConvertPointer	        pointer
    .GetVariable		    pointer
    .GetNextVariableName	pointer
    .SetVariable		    pointer
    .GetNextHighMonoCount	pointer
    .ResetSystem		    pointer
endstruc

struc SIMPLE_TEXT_INPUT_PROTOCOL
    .Reset			pointer
    .ReadKeyStroke	pointer
    .WaitForKey	    pointer
endstruc

struc EFI_GRAPHICS_OUTPUT_PROTOCOL
    .QueryMode	pointer
    .SetMode	pointer
    .Blt		pointer
    .Mode		pointer
endstruc

struc EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE
    .MaxMode		    int32
    .CurrentMode		int32
    .ModeInfo		    pointer
    .SizeOfModeInfo     int32
    .FrameBufferBase	pointer
    .FrameBufferSize	int32
endstruc

struc EFI_GRAPHICS_OUTPUT_MODE_INFORMATION
    .Version		        int32
    .HorizontalResolution	int32
    .VerticalResolution	    int32
    .PixelFormat		    int32
    .RedMask		        int32
    .GreenMask		        int32
    .BlueMask		        int32
    .Reserved		        int32
    .PixelsPerScanline	    int32
endstruc

struc EFI_TIME
    .Year		int16
    .Month		int8
    .Day		int8
    .Hour	    int8
    .Minute		int8
    .Second		int8
    .Pad1		int8
    .Nanosecond	int32
    .TimeZone	int16
    .Daylight	int8
    .Pad2		int8
endstruc

%macro efiCall 1
    sub rsp, 4 * 8 ; Room for rcx, rdx, r8 and r9
    call [%1]
    add rsp, 4 * 8
%endmacro

section .text

; A function to initialize the UEFI module
; Input:
;   R10 = EFI Handle
;   R11 = EFI System Table Address
; Output:
;   RAX = 0 if successful, -1 otherwise
efiInit:
    fnEnter

    ; Sanity checks
    or R10, R10
    jz efiInit_err

    or R11, R11
    jz efiInit_err

    mov rdx, EFI_SYSTEM_TABLE_SIGNATURE
    cmp rdx, [r11 + EFI_TABLE_HEADER.Signature]
    jne efiInit_err

    mov rdx, EFI_SYSTEM_TABLE_size
    cmp rdx, [r11 + EFI_TABLE_HEADER.HeaderSize]
    jl efiInit_err

    ; Save important resource handles and services
    mov [rel efiHandle], R10
    mov [rel efiSystemTable], R11

    fnReturn 0
efiInit_err:
    fnReturn -1

efiFirmwareVendor:
    fnEnter
    mov rbx, [rel efiSystemTable]
    mov rbx, [rbx + EFI_SYSTEM_TABLE.FirmwareVendor]
    fnReturn 0

efiFirmwareRevision:
    fnEnter
    mov rbx, [rel efiSystemTable]
    mov rbx, [rbx + EFI_SYSTEM_TABLE.FirmwareRevision]
    fnReturn 0

section .data
    ; GUIDs
    EFI_GRAPHICS_OUTPUT_PROTOCOL_UUID   db dword 0x9042a9de, word 0x23dc, word 0x4a38, 0x96,0xfb,0x7a,0xde,0xd0,0x80,0x51,0x6a

    efiHandle       dq 0
    efiSystemTable  dq 0
%endif