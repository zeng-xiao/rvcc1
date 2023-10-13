#!/usr/bin/env bash
set -Exeo pipefail

# qemu-riscv64
export PATH=$PATH:~/Downloads/tools/install.qemu.git/bin

elf=rvcc

currentPath=$(pwd)

if [[ -f $elf ]]; then
  ps -ef | grep 'qemu-risc' | grep -v 'grep'| awk '{print $2}'| xargs kill -9 > /dev/null 2>&1 &
  sleep 0.1
  qemu-riscv64 -L ~/Downloads/tools/gcc-13/daily/out/riscv-linux-toolchain/sysroot -g 7777 $elf "42" &

(cat << HERE
set architecture riscv:rv64
#target remote:7777
gef-remote --qemu-user --qemu-binary $elf localhost 7777

file $elf

set args 42

b *main
c
HERE
) > $currentPath/.gdbinit

echo "add-auto-load-safe-path $currentPath/.gdbinit" >> ~/.gdbinit

riscv64-unknown-elf-gdb

else
  echo "$elf doesn't exist!"
fi
