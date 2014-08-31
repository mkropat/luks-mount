PREFIX	= /usr/local

SBIN	= $(DESTDIR)/sbin
MAN	= $(DESTDIR)/$(PREFIX)/share/man

VERSION			= 0.2
PACKAGE_DIR		= luks-mount-$(VERSION)
PACKAGE_FILE		= luks-mount_$(VERSION).tar.bz2
PACKAGE_ORIG_FILE	= luks-mount_$(VERSION).orig.tar.bz2

AUTHOR	= Michael Kropat <mail@michael.kropat.name>
DATE	= $(shell date '+%b %d, %Y')
SCRIPTS	= mount.crypto_LUKS umount.crypto_LUKS
FILES	= t README.md LICENSE.txt Makefile lib $(SCRIPTS)
PAGES	= mount.crypto_LUKS.8 umount.crypto_LUKS.8

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


##### make dist #####

.PHONY: dist
dist: $(PACKAGE_FILE)

$(PACKAGE_FILE): $(FILES)
	tar --transform 's,^,$(PACKAGE_DIR)/,S' -cjf "$@" $^


### make deb deb-src deb-clean ###

.PHONY: deb deb-src deb-clean

deb: luks-mount_$(VERSION)-1_all.deb

luks-mount_$(VERSION)-1_all.deb: $(PACKAGE_FILE) debian/copyright
	@hash dpkg-buildpackage 2>/dev/null || { \
		echo "ERROR: can't find dpkg-buildpackage. Did you run \`sudo apt-get install debhelper devscripts\`?" >&2; exit 1; \
	}
	dpkg-buildpackage -b -tc
	mv "../$@" .
	mv ../luks-mount_$(VERSION)-1_*.changes .

deb-src: luks-mount_$(VERSION)-1_source.changes

luks-mount_$(VERSION)-1_source.changes: $(PACKAGE_FILE) $(PACKAGE_ORIG_FILE) debian/copyright
	@hash dpkg-buildpackage 2>/dev/null || { echo "ERROR: can't find debuild. Did you run \`sudo apt-get install debhelper devscripts\`?" >&2; exit 1; }
	tar xf "$<"
	cp -r debian "$(PACKAGE_DIR)"
	(cd "$(PACKAGE_DIR)"; debuild -S)

$(PACKAGE_ORIG_FILE): $(PACKAGE_FILE)
	cp "$<" "$@"

debian/copyright: LICENSE.txt
	cp "$<" "$@"

deb-clean:
	-debian/rules clean
	-rm -f *.build *.changes *.dsc *.debian.tar.gz *.orig.tar.bz2
	-rm -rf $(PACKAGE_DIR)
	-rm -f debian/copyright
