as loader.s -o loader.o

ld loader.o -o loader.bin

objcopy --dump-section .text=os.img loader.bin

sudo qemu-system-x86_64 -enable-kvm -m 64M -smp 1 --boot a --fda os.img disk.img