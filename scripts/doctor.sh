#!/usr/bin/env bash
fail=0
for t in aarch64-linux-gnu-gcc qemu-system-aarch64 make gcc bc bison flex cpio rsync unzip wget git; do
  if command -v "$t" >/dev/null; then
    printf '%-24s OK  %s\n' "$t" "$("$t" --version 2>&1 | head -1)"
  else
    printf '%-24s MISSING\n' "$t"; fail=1
  fi
done
for h in openssl/ssl.h libelf.h; do
  echo "#include <$h>" | gcc -E -x c - >/dev/null 2>&1 \
    && printf '%-24s OK\n' "$h" || { printf '%-24s MISSING\n' "$h"; fail=1; }
done
exit $fail
