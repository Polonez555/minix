#	MINIX: build the cross LLVM toolchain (clang, lld and the LLVM
#	binary utilities) from the llvm-project submodule with CMake.

.include <bsd.own.mk>
.include "${NETBSDSRCDIR}/external/bsd/llvm/llvm.mk"

# Binary utilities installed under their GNU names, for the TOOL_*
# variables in bsd.own.mk and for releasetools.
LLVM_TOOL_LINKS= \
	clang:clang clang++:clang clang-cpp:clang \
	ld:ld.lld \
	ar:llvm-ar ranlib:llvm-ranlib nm:llvm-nm \
	objcopy:llvm-objcopy strip:llvm-strip objdump:llvm-objdump \
	readelf:llvm-readelf size:llvm-size strings:llvm-strings

LLVM_DISTRIBUTION= \
	clang;clang-resource-headers;lld;llvm-ar;llvm-ranlib;llvm-nm; \
	llvm-objcopy;llvm-strip;llvm-objdump;llvm-readobj;llvm-readelf; \
	llvm-size;llvm-strings

CMAKE_ARGS= \
	${LLVM_CMAKE_COMMON_ARGS} \
	-DCMAKE_C_COMPILER=${HOST_CC:Q} \
	-DCMAKE_CXX_COMPILER=${HOST_CXX:Q} \
	-DCMAKE_INSTALL_PREFIX=${TOOLDIR} \
	-DLLVM_DISTRIBUTION_COMPONENTS="${LLVM_DISTRIBUTION:ts}"

.configure_done: llvm-patches
	${TOOL_CMAKE} -S ${LLVM_DIST}/llvm -B build ${CMAKE_ARGS}
	@touch ${.TARGET}

.build_done: .configure_done
	${TOOL_NINJA} -C build distribution llvm-tblgen clang-tblgen
	@touch ${.TARGET}

.install_done: .build_done
	# build.sh exports DESTDIR (the MINIX root); the tools go to TOOLDIR.
	env DESTDIR= ${TOOL_NINJA} -C build install-distribution
	mkdir -p ${TOOLDIR}/bin
	${HOST_INSTALL_FILE} -m ${BINMODE} build/bin/llvm-tblgen \
	    ${TOOLDIR}/bin/${_TOOL_PREFIX}llvm-tblgen
	${HOST_INSTALL_FILE} -m ${BINMODE} build/bin/clang-tblgen \
	    ${TOOLDIR}/bin/${_TOOL_PREFIX}clang-tblgen
.for l in ${LLVM_TOOL_LINKS}
	${HOST_INSTALL_SYMLINK} ${l:C/.*://} \
	    ${TOOLDIR}/bin/${MACHINE_GNU_PLATFORM}-${l:C/:.*//}
.endfor
	@touch ${.TARGET}

.if ${USETOOLS} == "yes"
realall: .build_done
realinstall: .install_done
.endif

clean: clean.llvm
clean.llvm: .PHONY
	-rm -rf .*_done build

.include <bsd.hostprog.mk>
