# Assembly language

I've always thought that this were a impossible subject. However, it turns out
to be fairly easy if you understand the big picture.

Processors work by basically reading from memory, performing operations and
writing it back to memory. That's it. When you understand that, you're ready
for the coming topics.

### Machine code

Each processor architecture will have its own
[set of instructions (ISA)](https://en.wikipedia.org/wiki/Instruction_set), so
that you can communicate with the processor using that language. This language
is called is called machine language, the only language that the machine can
understand. It's made of binary data (zeros and ones).

A hypothetical machine code for a processor would look like:

```
0001 00010 11000
```

And it means:

> Perform the operation `0001` (add) on `00010` (register) and `11000`
> (register) parameters. But how can you know that `0001` points to a `add`
> operation? That is where **Assembly** comes in. Assembly is a human-friendly
> representation of machine code. That same instruction, for instance, could be
> expressed in assembly like so:

```asm
ADD eax, ebx ; sum the value on the registers eax and ebx
```

### Registers

A processor have its own internal memory, called registers. Those are fast-
access memory that the processor uses to make operations. You could use only
RAM memory, for instance, but this would have a serious performance impact,
since it's much slower than the processor's.

Different processors will have different types of registers, but it usually
comes down to:

* General-purpose registers
* Special-purpose registers

The general-purpose registers are used to store data, whilst special-purpose
ones are used in order to hold some program state, such as program counter and
status register.

A program counter is used in order to tell the processor which program address
it should read next. The status register is used in order to store the status
of some operations, such as comparisons and bit manipulation.

* More info about [X86 registers](https://en.wikipedia.org/wiki/X86#x86_registers)

### Calling OS system calls

Calling a OS system call through assembly is easy. For that, let's use the 
x86_64 processor architecture on macOS - it's slightly different than the x86.

You first need to write some values into the register, then call the `syscall`
instruction.

```asm
  ; Exit system call
  mov eax, 0x2000001
  mov di, 0x2
  syscall
```

This will call the `exit` function with `2` as a parameter. Here you will find
the ID for all system calls:

* [macOS System Calls](https://sigsegv.pl/osx-bsd-syscalls/)
* [Linux System Calls](https://filippo.io/linux-syscall-table/)

### Conditions and branching

When doing conditions, you will make use of the special registers, because you
will be making jumps across your code.

```asm
mov ah, 1
mov al, 2
cmp ah, al
jle finish

finish:
...
```

This code above will compare the contents on `ah` and `al` and then jump to 
label finish if the former is less than or greater than the latter.

* [x86 Jumps](http://unixwiz.net/techtips/x86-jumps.html)

### Hello world

An example code is available at [asm-hello-world](/asm-hello-world/hello.asm).

Use `make` to build it. It requires `nasm` to be installed in the most recent
version (I've tested on 2.13).

### Links

I would watch these videos in sequence, because the order matters. The first
video is a basic understanding of how processors work and where assembly gets
in. He talks a lot about piece of hardware to enable certain instructions, so
I highly recommend watching the following Ben Eater's videos, as he explains
the relationship between them.

Assembly crash course is fast, but very good as soon as you get the general
idea of how it works. Then, you should watch all the amazing Ben Eater channel,
as he teaches a lot about computers. Lastly, the amazing MIT lectures for the
6.004 course (Computation Structures) - all for free!

[Assembler language by prof. Bill Byrne](https://www.youtube.com/watch?v=6ipFf3vLifU)
[How transistors works](https://www.youtube.com/watch?v=DXvAlwMAxiA)
[Making logic gates from transistors](https://www.youtube.com/watch?v=sTu3LwpF6XI)
[Learn how computers add numbers and build a 4 bit adder circuit](https://www.youtube.com/watch?v=wvJc9CZcvBc)
[Comparing C to machine language](https://www.youtube.com/watch?v=yOyaJXpAYZQ)
[x86 Assembly Crash Course](https://www.youtube.com/watch?v=75gBFiFtAb8)
[Ben Eater Youtube channel](https://www.youtube.com/user/eaterbc/videos)
[MIT 6.004 Lectures](https://www.youtube.com/watch?v=s7svpXgxk1U)
