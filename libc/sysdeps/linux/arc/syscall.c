/*
 * Copyright (C) 2013 Synopsys, Inc. (www.synopsys.com)
 *
 * Licensed under the LGPL v2.1 or later, see the file COPYING.LIB in this tarball.
 */

#include <features.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/syscall.h>

#ifdef __HS__
#include <stdarg.h>
extern long syscall (long int sysnum, ...);

long arc_wrapper_syscall (long int sysnum, long a, long b, long c, long d, long e, long f)
{
  return INLINE_SYSCALL_NCS(sysnum, 6, a, b, c, d, e, f);
}

long syscall (long int sysnum, ...)
{
  va_list ap;
  long a, b, c, d, e, f;

  va_start (ap, sysnum);
  a = va_arg (ap, long);
  b = va_arg (ap, long);
  c = va_arg (ap, long);
  d = va_arg (ap, long);
  e = va_arg (ap, long);
  f = va_arg (ap, long);
  va_end(ap);

  return arc_wrapper_syscall(sysnum, a, b, c, d, e, f);
}

#else

extern long syscall(long int sysnum, long a, long b, long c, long d, long e, long f);

long syscall(long int sysnum, long a, long b, long c, long d, long e, long f)
{
	return INLINE_SYSCALL_NCS(sysnum, 6, a, b, c, d, e, f);
}

#endif
