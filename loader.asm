.code16

.text

    .globl _start

_start:

    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %ss
    movw %ax, %es
    movw $0x7FFC, %sp

    jmp boot

    loading_kernel_string: .asciz "Loading kernel sectors..."
    disk_id: .byte 0

print_string:

    cld

    movb $0x0e, %ah

    lodsb

    cmpb $0, %al
    jne print_string_loop
    ret

print_string_loop:

    int $0x10

    lodsb

    cmpb $0, %al
    jne print_string_loop
    ret

boot:

    leaw (loading_kernel_string), %si
    call print_string

    movb $0x02, %ah
    movb $1, %al
    movb $0, %ch
    movb $0, %dh
    movb $2, %cl
    movw $0x8000, %bx
    int $0x13

    movw 0x8000, %si
    call print_string

    jmp kernel_entry

    . = _start + 510
    .byte 0x55
    .byte 0xaa

.include "kernel.asm"

. = _start + 0x1000
