# $NetBSD: Makefile,v 1.1 2013/02/23 14:16:50 jmmv Exp $

KYUA_LIBS=	store utils

.include <bsd.init.mk>

.PATH:		${SRCDIR}/engine
.PATH:		${SRCDIR}/engine/drivers

LIB=		engine

WARNS?=		3

SRCS=		action.cpp \
		config.cpp \
		context.cpp \
		exceptions.cpp \
		filters.cpp \
		kyuafile.cpp \
		metadata.cpp \
		test_case.cpp \
		test_program.cpp \
		test_result.cpp \
		testers.cpp

# engine/drivers subdirectory.
SRCS+=		debug_test.cpp \
		list_tests.cpp \
		run_tests.cpp \
		scan_action.cpp

.if defined(__MINIX)
NOCLANGERROR=	yes
.endif # defined(__MINIX)
.if defined(__MINIX)
# filters.cpp uses std::inserter without <iterator>, which the old
# libc++ included indirectly.
COPTS.filters.cpp+=	-include iterator
.endif

.include <bsd.lib.mk>
