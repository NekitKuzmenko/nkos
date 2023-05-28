.org 0x8000

.byte 0

boot_entry:

    in $0x92, %al
    or $2, %al
    out %al, $0x92

    xorl %eax, %eax
    movw %cs, %ax
    shll $4, %eax
    addl protected_mode_entry, %eax
    mov %eax, (entry_offset)

    xorl %eax, %eax
    movw %cs, %ax
    shll $4, %eax
    addl GDT, %ax

    movl %eax, (GDT_ptr)
    lgdt (GDTR)

    cli

    in $0x70, %al
    or $0x80, %al
    out %al, $0x70

    movl %cr0, %eax
    or $1, %al
    movl %eax, %cr0

    .byte 0x66
    .byte 0xea

    entry_offset: .long 0
    .word CODE_S


.align 8

GDT:
    null_d: .space 8
    code_d:
        .long 0b0000000000001000
        .byte 0, 0, 0
        .byte 0b10011010
        .byte 0b11001000
        .byte 0
    data_d:
        .long 0b0000000000001000
        .byte 0b00000100, 0b00000100, 0b00000000
        .byte 0b10010010
        .byte 0b11001000
        .byte 0
    video_d:
        .long 9
        .byte 0b00000000, 0b00001000, 0b00000000
        .byte 0b10010010
        .byte 0b11001100
        .byte 0

GDT_size: . - GDT

GDTR: 
    .word GDT_size-1
    GDT_ptr: .long 0


.code32

protected_mode_entry:
