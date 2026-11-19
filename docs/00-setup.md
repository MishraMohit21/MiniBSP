# Stage 0: Environment setup
Host: Ubuntu 24.04.4 LTS (Noble Numbat)

Toolchain:
```
aarch64-linux-gnu-gcc    OK  aarch64-linux-gnu-gcc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0
qemu-system-aarch64      OK  QEMU emulator version 8.2.2 (Debian 1:8.2.2+ds-0ubuntu1.18)
make                     OK  GNU Make 4.3
gcc                      OK  gcc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0
bc                       OK  bc 1.07.1
bison                    OK  bison (GNU Bison) 3.8.2
flex                     OK  flex 2.6.4
cpio                     OK  cpio (GNU cpio) 2.15
rsync                    OK  rsync  version 3.2.7  protocol version 31
unzip                    OK  caution:  both -n and -o specified; ignoring -o
wget                     OK  GNU Wget 1.21.4 built on linux-gnu.
git                      OK  git version 2.43.0
openssl/ssl.h            OK
libelf.h                 OK
```

Pinned: Linux 6.6.63, Buildroot 2024.02.9
