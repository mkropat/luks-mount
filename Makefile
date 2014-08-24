SBIN	= $(DESTDIR)/sbin

FILES	= mount.crypto_LUKS umount.crypto_LUKS

.PHONY: check test install uninstall

check: test

test:
	-checkbashisms $(FILES)
	-shellcheck $(FILES)
	"$(SHELL)" t/test_mount
	"$(SHELL)" t/test_umount

install:
	cp $(FILES) "$(SBIN)"

uninstall:
	-rm -f "$(SBIN)/mount.crypto_LUKS" "$(SBIN)/umount.crypto_LUKS"
