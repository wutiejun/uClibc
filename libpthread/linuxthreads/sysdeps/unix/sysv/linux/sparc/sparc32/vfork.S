/* Copyright (C) 2003 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Contributed by Jakub Jelinek <jakub@redhat.com>, 2003.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */

#include <sysdep-cancel.h>

	.text
#ifdef SHARED
.LLGETPC0:
	retl
	 add	%o7, %o0, %o0
#endif
ENTRY(__vfork)
#ifdef SHARED
	mov	%o7, %o1
	sethi	%hi(_GLOBAL_OFFSET_TABLE_-4), %o0
	call	.LLGETPC0
	 add	%o0, %lo(_GLOBAL_OFFSET_TABLE_+4), %o0
	sethi	%hi(__libc_pthread_functions), %o2
	mov	%o1, %o7
	or	%o2, %lo(__libc_pthread_functions), %o2
	ld	[%o0 + %o2], %o2
	ld	[%o2], %o2
	cmp	%o2, 0
#else
	.weak	pthread_create
	sethi	%hi(pthread_create), %o0
	orcc	%o0, %lo(pthread_create), %o0
#endif
#if defined SHARED && !defined BROKEN_SPARC_WDISP22
	bne	HIDDEN_JUMPTARGET(fork)
#else
	bne	1f
#endif
	 mov	__NR_vfork, %g1
	ta	0x10
	bcs	__syscall_error_handler
	 nop
	sub	%o1, 1, %o1
	retl
	 and	%o0, %o1, %o0
#if !defined SHARED || defined BROKEN_SPARC_WDISP22
1:	mov	%o7, %g1
	call	HIDDEN_JUMPTARGET(fork)
	 mov	%g1, %o7
#endif
	SYSCALL_ERROR_HANDLER
PSEUDO_END (__vfork)
libc_hidden_def (__vfork)
weak_alias (__vfork, vfork)
