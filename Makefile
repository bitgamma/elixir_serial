# Variables to override
#
# CC            C compiler
# CROSSCOMPILE	crosscompiler prefix, if any
# CFLAGS	compiler flags for compiling all C files
# LDFLAGS	linker flags for linking all binaries
# MIX		path to mix


LDFLAGS +=
CFLAGS ?= -O2 -Wall -Wextra -Wno-unused-parameter
CC ?= $(CROSSCOMPILER)gcc
MIX ?= mix

.PHONY: all elixir-code clean

all: elixir-code

elixir-code:
	$(MIX) compile

%.o: %.c
	$(CC) -c $(CFLAGS) -o $@ $<

priv/serial: src/serial.c
	@mkdir -p priv
	$(CC) $^ $(LDFLAGS) -o $@

clean:
	$(MIX) clean
	rm -f priv/serial src/*.o

realclean:
	rm -fr _build priv/serial src/*.o
