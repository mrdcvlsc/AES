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
DFLAGS=-D_USE_INTEL_AESNI -maes
else ifeq ($(VERSION), neon)
COMPILATION_MSG="compiling AES aarch64 neon version"
DFLAGS=-D_USE_ARM_NEON_AES -march=armv8-a+crypto
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
	@echo "Recipes : test"
	@echo "CXX     : g++, clang++"
	@echo "TYPE    : release, debug"
	@echo "VERSION : portable, aesni, neon"
	@echo "LINK    : dynamic, static"
	@echo ""
	@echo "Makefile recipes"

test:
	$(CXX) $(CXX_STANDARD) tests.cpp -o tests.out $(DFLAGS) $(CXX_FLAGS)
	./tests.out

clean:
	@rm tests.out

style:
	@clang-format -i -style=file *.cpp *.hpp