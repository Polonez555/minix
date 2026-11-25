.include <bsd.own.mk>

# Makefile for Reincarnation Server (RS)
PROG=	rs
SRCS=	exec.c main.c request.c manager.c table.c utility.c error.c update.c

.if ${USE_PCI} != "no"
CPPFLAGS+= -DUSE_PCI
.endif

.if ${USE_PCI} != "no"
CPPFLAGS+= -DUSE_PCI
.endif

DPADD+=	${LIBSYS} ${LIBEXEC}
LDADD+=	-lsys -lexec

CPPFLAGS+=	-I${NETBSDSRCDIR}/minix

.if defined(__MINIX)
# clang 23: %s gets a void * that points to a string; harmless.
COPTS.utility.c+=	-Wno-error=format
.endif

.include <minix.service.mk>
