OS := $(shell uname)

CXX=g++
CXX_STANDARD=-std=c++17

########################## link ##########################

LINK=dynamic

ifeq ($(LINK), dynamic)
LINKER=
else ifeq ($(LINK), static)
LINKER=-static
endif

########################## sanitizer ##########################

ifeq ($(CXX), clang++)
ADDRESS_SANITIZER=-fsanitize=address
THREADS_SANITIZER=-fsanitize=thread
else
ADDRESS_SANITIZER=
THREADS_SANITIZER=
endif

########################## version ##########################

VERSION=portable

ifeq ($(VERSION), portable)
COMPILATION_MSG="compiling portable version"
DFLAGS=
else ifeq ($(VERSION), aesni)
COMPILATION_MSG="compiling AES-NI version"
DFLAGS=-DUSE_AESNI -maes
else ifeq ($(VERSION), neon)
COMPILATION_MSG="compiling AES aarch64 neon version"
DFLAGS=-DUSE_ARM_AES -march=armv8-a+crypto
endif

########################## type ##########################

TYPE=release

ifeq ($(TYPE), release)
CXX_FLAGS=-O3 -Wall -Wextra
else ifeq ($(TYPE), debug)
CXX_FLAGS=-O2 -Wall -Wextra $(ADDRESS_SANITIZER)
endif

########################## CLASSIC MAKEFILE ##########################

default:
	@echo "Makefile variables and possible values"
	@echo "The the first element are always the default value"
	@echo "CXX     : g++, clang++"
	@echo "TYPE    : release, debug"
	@echo "VERSION : portable, aesni, neon"
	@echo "LINK    : dynamic, static"
	@echo ""
	@echo "Makefile recipes"

test:
	@clang++ -std=c++17 tests.cpp -o tests.out -fsanitize=address
	@./tests.out

style:
	@clang-format -i -style=file *.cpp *.hpp