### If you wish to use extra libraries (math.h for instance),
### add their flags here (-lm in our case) in the "LIBS" variable.

LIBS = -lm

###
CFLAGS  = -std=c99
CFLAGS += -g
CFLAGS += -Wall
CFLAGS += -Wextra
CFLAGS += -pedantic
CFLAGS += -Werror
CFLAGS += -Wmissing-declarations
CFLAGS += -DUNITY_SUPPORT_64

BUILDFLAGS = -Wall
BUILDFLAGS += -g
BUILDFLAGS += -fPIC
BUILDFLAGS += -shared

BUILDLIBS = -ldl

ASANFLAGS  = -fsanitize=address
ASANFLAGS += -fno-common
ASANFLAGS += -fno-omit-frame-pointer

test: tests.out
	@./tests.out

memcheck: test/*.c src/*.c src/*.h
	@echo Compiling $@
	@$(CC) $(ASANFLAGS) $(CFLAGS) src/*.c test/vendor/unity.c test/*.c -o memcheck.out $(LIBS)
	@./memcheck.out
	@echo "Memory check passed"

clean:
	rm -rf *.o *.out *.out.dSYM *.so

tests.out: test/*.c src/*.c src/*.h
	@echo Compiling $@
	@$(CC) $(CFLAGS) src/*.c test/vendor/unity.c test/*.c -o tests.out $(LIBS)

build: src/*.c src/*.h
	@echo Compiling $@
	@$(CC) $(BUILDFLAGS) src/*.c -o libpreloadvaccine.so $(BUILDLIBS)