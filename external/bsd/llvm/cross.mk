#	MINIX: create the CMake toolchain file for cross-building LLVM code
#	(runtimes, on-board clang) for MINIX.  Include after bsd.own.mk.

.if !defined(_MINIX_LLVM_CROSS_MK)
_MINIX_LLVM_CROSS_MK=

.include "${.PARSEDIR}/llvm.mk"

# Same per-architecture flags as bsd.own.mk adds to CFLAGS.
MINIX_CPUFLAGS=
.if !empty(MACHINE_ARCH:Mearm*)
MINIX_CPUFLAGS+=	-mno-unaligned-access
.endif

LLVM_TOOLCHAIN_FILE=	${.OBJDIR}/MinixToolchain.cmake

${LLVM_TOOLCHAIN_FILE}: ${LLVM_TOPLEVEL}/cmake/MinixToolchain.cmake.in \
    ${LLVM_TOPLEVEL}/cross.mk
	${TOOL_SED} \
	    -e 's|@MACHINE_ARCH@|${MACHINE_ARCH}|g' \
	    -e 's|@MACHINE_GNU_PLATFORM@|${MACHINE_GNU_PLATFORM}|g' \
	    -e 's|@DESTDIR@|${DESTDIR}|g' \
	    -e 's|@TOOLDIR@|${TOOLDIR}|g' \
	    -e 's|@LLVM_TOPLEVEL@|${LLVM_TOPLEVEL}|g' \
	    -e 's|@MINIX_CPUFLAGS@|${MINIX_CPUFLAGS:[*]}|g' \
	    ${LLVM_TOPLEVEL}/cmake/MinixToolchain.cmake.in > ${.TARGET}

CLEANFILES+=	${LLVM_TOOLCHAIN_FILE}

.endif # !defined(_MINIX_LLVM_CROSS_MK)
