OS:=$(shell uname)
CXX:=g++
CXX_STANDARD:=-std=c++17

########################## link ##########################

LINK:=dynamic

ifeq ($(LINK), dynamic)
LINKER:=
else ifeq ($(LINK), static)
LINKER:=-static
endif

########################## sanitizer ##########################

ifeq ($(CXX), clang++)
ADDRESS_SANITIZER:=-fsanitize=address
THREADS_SANITIZER:=-fsanitize=thread
else
ADDRESS_SANITIZER:=
THREADS_SANITIZER:=
endif

########################## version ##########################

VERSION:=

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

TYPE:=release

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

test:
	$(CXX) $(CXX_STANDARD) $(LINKER) tests.cpp -o tests.out $(DFLAGS) $(CXX_FLAGS)
	./tests.out

clean:
	@rm tests.out microbench.out

clean-cmake:
	rm -r tests Makefile CMakeFiles cmake_install.cmake CMakeCache.txt

style:
	@clang-format -i -style=file *.cpp *.hpp

microbenchmark:
	$(CXX) $(CXX_STANDARD) $(LINKER) microbench.cpp -o microbench1.out -O3
	$(CXX) $(CXX_STANDARD) $(LINKER) microbench.cpp -o microbench2.out -O3 -D_USE_INTEL_AESNI -maes
	@echo "Running micro-benchmarks"
	@echo ""
	@echo "# **micro-benchmark**" > micro-benchmark.md
	@echo "" >> micro-benchmark.md
	@echo "Pure C++ Implementation" >> micro-benchmark.md
	@echo "| AES Operation | key bits | Duration | Megabytes |" >> micro-benchmark.md
	@echo "| --- | --- | --- | --- |" >> micro-benchmark.md
	@./microbench1.out >> micro-benchmark.md
	@echo "" >> micro-benchmark.md
	@echo "AES-NI (Hardware Accelerated)" >> micro-benchmark.md
	@echo "| AES Operation | key bits | Duration | Megabytes |" >> micro-benchmark.md
	@echo "| --- | --- | --- | --- |" >> micro-benchmark.md
	@./microbench2.out >> micro-benchmark.md
	@echo "" >> micro-benchmark.md