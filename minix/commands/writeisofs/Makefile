PROG=	writeisofs
MAN=

CPPFLAGS+= -I${NETBSDSRCDIR}/minix/include/arch/${MACHINE_ARCH}/include

.if defined(__MINIX)
# clang 23 (not 3.6): byte values stored in char on purpose, not a bug.
COPTS.writeisofs.c+=	-Wno-error=constant-conversion
.endif

.include <bsd.prog.mk>
