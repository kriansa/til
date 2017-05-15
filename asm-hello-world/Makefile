link: compile
	ld -lSystem -macosx_version_min 10.12 -o hello hello.o

compile:
	nasm -f macho64 hello.asm

clean:
	rm hello.o hello

.PHONY: clean
