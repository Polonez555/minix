#	MINIX: common settings for building LLVM from the llvm-project
#	submodule with CMake and Ninja.

.if !defined(_MINIX_LLVM_MK)
_MINIX_LLVM_MK=

LLVM_VERSION=		23.1.6
LLVM_VERSION_MAJOR=	23

LLVM_TOPLEVEL:=		${.PARSEDIR}
LLVM_DIST:=		${.PARSEDIR}/dist
LLVM_PATCHDIR:=		${.PARSEDIR}/patches
LLVM_APPLY_PATCHES:=	${.PARSEDIR}/apply-patches.sh

TOOL_CMAKE?=		cmake
TOOL_NINJA?=		ninja

# Targets built into every LLVM: MINIX runs on i386 and ARM.
LLVM_TARGETS=		X86;ARM

# Options shared by the cross toolchain and the on-board build.
LLVM_CMAKE_COMMON_ARGS= \
	-G Ninja \
	-DCMAKE_BUILD_TYPE=Release \
	-DLLVM_ENABLE_PROJECTS="clang;lld" \
	-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS}" \
	-DLLVM_DEFAULT_TARGET_TRIPLE=${MACHINE_GNU_PLATFORM} \
	-DLLVM_INCLUDE_TESTS=OFF \
	-DLLVM_INCLUDE_BENCHMARKS=OFF \
	-DLLVM_INCLUDE_EXAMPLES=OFF \
	-DLLVM_INCLUDE_DOCS=OFF \
	-DLLVM_ENABLE_BINDINGS=OFF \
	-DLLVM_ENABLE_ZLIB=OFF \
	-DLLVM_ENABLE_ZSTD=OFF \
	-DLLVM_ENABLE_LIBXML2=OFF \
	-DCLANG_ENABLE_ARCMT=OFF \
	-DCLANG_ENABLE_STATIC_ANALYZER=OFF

# Applying the patches is cheap and idempotent, so it runs on every build.
llvm-patches: .PHONY
	${HOST_SH} ${LLVM_APPLY_PATCHES} ${LLVM_DIST} ${LLVM_PATCHDIR}

.endif # !defined(_MINIX_LLVM_MK)
