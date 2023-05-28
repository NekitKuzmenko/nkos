.align 8

GDT:
    null_d: .space 8
    code_d: 
    data_d:
    video_d:

GDT_size: . - GDT

GDTR: 
    .word GDT_size-1
    GDT_ptr: .long 0

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

entry_offset:
    .long 0
    .word: code_selector

.code32

protected_mode_entry:
