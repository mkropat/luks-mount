PREFIX	= /usr/local

SBIN	= $(DESTDIR)/sbin
MAN	= $(DESTDIR)/$(PREFIX)/share/man

VERSION			= 0.1
PACKAGE_DIR		= luks-mount-$(VERSION)
PACKAGE_FILE		= luks-mount_$(VERSION).tar.bz2
PACKAGE_ORIG_FILE	= luks-mount_$(VERSION).orig.tar.bz2

AUTHOR	= Michael Kropat <mail@michael.kropat.name>
DATE	= $(shell date '+%b %d, %Y')
SCRIPTS	= mount.crypto_LUKS umount.crypto_LUKS
PAGES	= mount.crypto_LUKS.8 umount.crypto_LUKS.8
FILES	= t README.md LICENSE.txt Makefile $(SCRIPTS)

.PHONY: all check test install uninstall clean

all: $(PAGES)

mount.crypto_LUKS.8: README.man.md
	pandoc --from=markdown --standalone --output="$@" "$<"

umount.crypto_LUKS.8: mount.crypto_LUKS.8
	ln -s "$<" "$@"

README.man.md: README.md
	echo '% mount.crypto_LUKS(8) luks-mount | $(VERSION)' >"$@"
	echo '% $(AUTHOR)' >>"$@"
	echo '% $(DATE)' >>"$@"
	perl -ne 's/^#{1,3}/#/; print if ! (/^# Installation/ ... /^# /) || /^# (?!Installation)/' "$<" >>"$@"

check: test

test:
	-checkbashisms $(SCRIPTS)
	-shellcheck $(SCRIPTS)
	"$(SHELL)" t/test_mount
	"$(SHELL)" t/test_umount

install:
	mkdir -p "$(SBIN)"
	cp $(SCRIPTS) "$(SBIN)"

uninstall:
	-rm -f "$(SBIN)/mount.crypto_LUKS" "$(SBIN)/umount.crypto_LUKS"

clean:
	-rm -f $(PAGES) README.man.md
