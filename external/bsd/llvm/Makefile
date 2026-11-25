#	MINIX: the on-board compiler.  clang, lld and the LLVM binary
#	utilities from the llvm-project submodule, cross-built for MINIX with
#	CMake, using the tablegens of the cross toolchain (tools/llvm).

.include <bsd.own.mk>
.include "${.CURDIR}/cross.mk"

LLVM_DISTRIBUTION= \
	clang;clang-resource-headers;lld;llvm-ar;llvm-ranlib;llvm-nm; \
	llvm-objcopy;llvm-strip;llvm-objdump;llvm-readobj;llvm-readelf; \
	llvm-size;llvm-strings;llvm-symbolizer;llvm-addr2line;llvm-cxxfilt; \
	llvm-mc

ONBOARD_CMAKE_ARGS= \
	${LLVM_CMAKE_COMMON_ARGS} \
	-DCMAKE_TOOLCHAIN_FILE=${LLVM_TOOLCHAIN_FILE} \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DLLVM_HOST_TRIPLE=${MACHINE_GNU_PLATFORM} \
	-DLLVM_TABLEGEN=${TOOL_LLVM_TBLGEN} \
	-DCLANG_TABLEGEN=${TOOLDIR}/bin/${_TOOL_PREFIX}clang-tblgen \
	-DLLVM_DISTRIBUTION_COMPONENTS="${LLVM_DISTRIBUTION:ts}" \
	-DLLVM_ENABLE_THREADS=OFF \
	-DLLVM_ENABLE_BACKTRACES=ON \
	-DCMAKE_DISABLE_FIND_PACKAGE_Backtrace=ON \
	-DLLVM_ENABLE_LIBEDIT=ON \
	-DLLVM_ENABLE_ZLIB=ON \
	-DLLVM_ENABLE_PIC=OFF

# MINIX programs are linked statically by default (LDSTATIC).
.if ${LDSTATIC:U} == "-static"
ONBOARD_CMAKE_ARGS+=	-DCMAKE_EXE_LINKER_FLAGS=-static
.endif

.if ${MKDEBUG:Uno} != "no"
ONBOARD_CMAKE_ARGS+=	-DCMAKE_C_FLAGS=-g -DCMAKE_CXX_FLAGS=-g
.endif

# The GNU binutils names, and cc/c++/cpp, as links to the LLVM tools.
ONBOARD_LINKS= \
	cc:clang c++:clang cpp:clang \
	ld:ld.lld as:llvm-mc \
	ar:llvm-ar ranlib:llvm-ranlib nm:llvm-nm \
	objcopy:llvm-objcopy strip:llvm-strip objdump:llvm-objdump \
	readelf:llvm-readelf size:llvm-size strings:llvm-strings \
	addr2line:llvm-addr2line c++filt:llvm-cxxfilt

realall: onboard-build

# Configure again whenever the options here change.
build/build.ninja: ${LLVM_TOOLCHAIN_FILE} ${.CURDIR}/Makefile
	rm -rf build
	${TOOL_CMAKE} -S ${LLVM_DIST}/llvm -B build ${ONBOARD_CMAKE_ARGS}

onboard-build: .PHONY llvm-patches .WAIT build/build.ninja
	${TOOL_NINJA} -C build distribution llvm-tblgen clang-tblgen
	rm -rf stage
	env DESTDIR=${.OBJDIR}/stage ${TOOL_NINJA} -C build install-distribution
	cp build/bin/llvm-tblgen build/bin/clang-tblgen stage/usr/bin/
	# clang is installed as clang-<major> plus links; keep a plain clang.
	if [ -h stage/usr/bin/clang ]; then \
		rm stage/usr/bin/clang; \
		mv stage/usr/bin/clang-${LLVM_VERSION_MAJOR} stage/usr/bin/clang; \
	fi
.for l in ${ONBOARD_LINKS}
	ln -sf ${l:C/.*://} stage/usr/bin/${l:C/:.*//}
.endfor
.if ${MKDEBUG:Uno} != "no"
	mkdir -p stage${DEBUGDIR}/usr/bin
	for f in stage/usr/bin/*; do \
		[ -h "$$f" ] && continue; \
		d=stage${DEBUGDIR}/usr/bin/$${f##*/}.debug; \
		${OBJCOPY} --only-keep-debug "$$f" "$$d"; \
		${OBJCOPY} --strip-debug -p -R .gnu_debuglink \
		    --add-gnu-debuglink="$$d" "$$f"; \
	done
.endif

realinstall: onboard-install

onboard-install: .PHONY
	env INSTALL_DIR=${INSTALL_DIR:Q} INSTALL_FILE=${INSTALL_FILE:Q} \
	    INSTALL_SYMLINK=${INSTALL_SYMLINK:Q} \
	    FILEOWN=${BINOWN} FILEGRP=${BINGRP} FILEMODE=${NONBINMODE} \
	    EXECMODE=${BINMODE} \
	    DIRMODE=755 DEBUGMODE=${DEBUGMODE} \
	    ${HOST_SH} ${LLVM_TOPLEVEL}/install-tree.sh stage ${DESTDIR}

clean: clean.onboard
clean.onboard: .PHONY
	-rm -rf build stage

.include <bsd.prog.mk>
