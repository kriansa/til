global _main 

section .text

_main:
  ; Write system call
  mov eax, 0x2000004
  mov di, 0x1
  mov rsi, msg
  mov rdx, msg.len
  syscall

_exit:
  ; Exit system call
  mov eax, 0x2000001
  mov di, 0x2
  syscall

section .data
  msg db "Hello world!", 0xa ; 0xa (10 in decimal) is a line-break
  .len equ $ - msg
