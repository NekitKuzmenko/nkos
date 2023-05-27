kernel_loaded_string: .asciz "Kernel was successfully loaded!"

kernel_entry:

    leaw (kernel_loaded_string), %si
    call print_string
