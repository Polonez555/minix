#	MINIX: libc++, libc++abi and libunwind from the llvm-project
#	submodule, cross-built with CMake and installed like bsd.lib.mk
#	installs a library (lib*.a, lib*_pic.a, lib*.so.1.0 and links).

.include <bsd.own.mk>
.include "${NETBSDSRCDIR}/external/bsd/llvm/cross.mk"

RUNTIMES_CMAKE_ARGS= \
	-G Ninja \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_TOOLCHAIN_FILE=${LLVM_TOOLCHAIN_FILE} \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind" \
	-DLIBCXX_CXX_ABI=libcxxabi \
	-DLIBCXXABI_USE_LLVM_UNWINDER=ON \
	-DLIBCXX_ENABLE_THREADS=OFF \
	-DLIBCXX_HAS_PTHREAD_API=OFF \
	-DLIBCXX_ENABLE_MONOTONIC_CLOCK=OFF \
	-DLIBCXXABI_ENABLE_THREADS=OFF \
	-DLIBCXXABI_HAS_PTHREAD_API=OFF \
	-DLIBUNWIND_ENABLE_THREADS=OFF \
	-DLIBCXX_INSTALL_MODULES=OFF \
	-DLIBCXX_INCLUDE_TESTS=OFF \
	-DLIBCXX_INCLUDE_BENCHMARKS=OFF \
	-DLIBCXX_INCLUDE_DOCS=OFF \
	-DLIBCXXABI_INCLUDE_TESTS=OFF \
	-DLIBUNWIND_INCLUDE_TESTS=OFF \
	-DLIBUNWIND_INCLUDE_DOCS=OFF \
	-DLLVM_INCLUDE_TESTS=OFF

# The runtimes being built are what clang++ links by default.
RUNTIMES_CFLAGS=
RUNTIMES_CXXFLAGS=	-nostdlib++
.if ${MKDEBUG:Uno} != "no"
RUNTIMES_CFLAGS+=	-g
RUNTIMES_CXXFLAGS+=	-g
.endif
RUNTIMES_CMAKE_ARGS+= \
	-DCMAKE_C_FLAGS="${RUNTIMES_CFLAGS}" \
	-DCMAKE_CXX_FLAGS="${RUNTIMES_CXXFLAGS}"

_SHARED=	${MKPIC:Uyes:S/no/OFF/:S/yes/ON/}
RUNTIMES_SHARED_ARGS= \
	-DLIBCXX_ENABLE_SHARED=${_SHARED} \
	-DLIBCXXABI_ENABLE_SHARED=${_SHARED} \
	-DLIBUNWIND_ENABLE_SHARED=${_SHARED}

# The *_pic.a archives come from a second, static-only build with PIC.
RUNTIMES_PIC_ARGS= \
	-DCMAKE_POSITION_INDEPENDENT_CODE=ON \
	-DLIBCXX_ENABLE_SHARED=OFF \
	-DLIBCXXABI_ENABLE_SHARED=OFF \
	-DLIBUNWIND_ENABLE_SHARED=OFF

RUNTIMES_LIBS=	c++ c++abi unwind

realall: runtimes-build

# Configure again whenever the options here change.
build/build.ninja: ${LLVM_TOOLCHAIN_FILE} ${.CURDIR}/Makefile
	rm -rf build
	${TOOL_CMAKE} -S ${LLVM_DIST}/runtimes -B build \
	    ${RUNTIMES_CMAKE_ARGS} ${RUNTIMES_SHARED_ARGS}

build-pic/build.ninja: ${LLVM_TOOLCHAIN_FILE} ${.CURDIR}/Makefile
	rm -rf build-pic
	${TOOL_CMAKE} -S ${LLVM_DIST}/runtimes -B build-pic \
	    ${RUNTIMES_CMAKE_ARGS} ${RUNTIMES_PIC_ARGS}

_RUNTIMES_NINJA=	build/build.ninja
.if ${MKPIC} != "no" && ${MKPICINSTALL} != "no"
_RUNTIMES_NINJA+=	build-pic/build.ninja
.endif

runtimes-build: .PHONY llvm-patches .WAIT ${_RUNTIMES_NINJA}
	${TOOL_NINJA} -C build
.if ${MKPIC} != "no" && ${MKPICINSTALL} != "no"
	${TOOL_NINJA} -C build-pic
.endif
	rm -rf stage
	env DESTDIR=${.OBJDIR}/stage ${TOOL_NINJA} -C build install
.if ${MKPIC} != "no" && ${MKPICINSTALL} != "no"
.for l in ${RUNTIMES_LIBS}
	cp build-pic/lib/lib${l}.a stage/usr/lib/lib${l}_pic.a
.endfor
.endif
.if ${MKPIC} != "no" && ${MKDEBUG:Uno} != "no"
	mkdir -p stage${DEBUGDIR}/usr/lib
.for l in ${RUNTIMES_LIBS}
	${OBJCOPY} --only-keep-debug stage/usr/lib/lib${l}.so.1.0 \
	    stage${DEBUGDIR}/usr/lib/lib${l}.so.1.0.debug
	${OBJCOPY} --strip-debug -p -R .gnu_debuglink \
	    --add-gnu-debuglink=stage${DEBUGDIR}/usr/lib/lib${l}.so.1.0.debug \
	    stage/usr/lib/lib${l}.so.1.0
.endfor
.endif
.if ${MKSTATICLIB} == "no"
	rm -f ${RUNTIMES_LIBS:@l@stage/usr/lib/lib${l}.a@}
.endif

realinstall: runtimes-install

runtimes-install: .PHONY
	env INSTALL_DIR=${INSTALL_DIR:Q} INSTALL_FILE=${INSTALL_FILE:Q} \
	    INSTALL_SYMLINK=${INSTALL_SYMLINK:Q} \
	    FILEOWN=${LIBOWN} FILEGRP=${LIBGRP} FILEMODE=${LIBMODE} \
	    EXECMODE=${LIBMODE} \
	    DIRMODE=755 DEBUGMODE=${DEBUGMODE} \
	    ${HOST_SH} ${LLVM_TOPLEVEL}/install-tree.sh stage ${DESTDIR}

clean: clean.runtimes
clean.runtimes: .PHONY
	-rm -rf build build-pic stage

.include <bsd.prog.mk>
