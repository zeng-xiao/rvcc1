set architecture riscv:rv64
#target remote:7777
gef-remote --qemu-user --qemu-binary rvcc localhost 7777

file rvcc

set args 42

b *main
c
