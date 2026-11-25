# Makefile for libmthread

LIB=	mthread

SRCS=	\
	allocate.c \
	attribute.c \
	condition.c \
	event.c \
	key.c \
	misc.c \
	mutex.c \
	pthread_compat.c \
	queue.c \
	rwlock.c \
	scheduler.c \

WARNS?=	4

CFLAGS+= -fno-builtin

# Found by clang 23, fix later: pthread_mutex_trylock() calls itself.
COPTS.pthread_compat.c+=	-Wno-error=infinite-recursion

.include <bsd.lib.mk>
