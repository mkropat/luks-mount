## luks-mount

*Teach mount(8) to mount LUKS containers directly*

Building on [the technique pioneered by Tobias
Kienzler](http://unix.stackexchange.com/a/52183/49971), **luks-mount** extends
the `mount` command so it can mount LUKS volumes directly, handling all the
`cryptsetup` work itself.

In other words, this:

    cryptsetup luksOpen /dev/mapper/somevg-somevol somevol
    mount /dev/mapper/somevol /some/mountpoint

Becomes simplified to:

    mount /dev/mapper/somevg-somevol /some/mountpoint

Or simply:

    mount /some/mountpoint

Once you've added an entry to `/etc/fstab` like:

    UUID=... /some/mountpoint crypto_LUKS defaults,noauto 0 1

### Automatic Unmounting

**luks-mount** is meant to be complementary to
[crypttab](http://manpages.ubuntu.com/manpages/trusty/man5/crypttab.5.html).
If you want to unlock an encrypted volume at boot and have it stay unlocked,
let `crypttab` handle that for you.

On the other hand, if you want to mount an encrypted volume on demand — and
unmount it when you're done with it so it stays safe — that's where
**luks-mount** can help.  By default, 15 minutes after you mount a LUKS
volume, **luks-mount** will begin to monitor the mount point and wait for you
to finish using it.  As soon as it's no longer in use, **luks-mount** will
unmount the encrypted volume and automatically close it for you.

### Installation

#### Ubuntu and Linux Mint

    sudo add-apt-repository ppa:mkropat/ppa
    sudo apt-get update
    sudo apt-get install luks-mount

#### Debian and Friends

    git clone https://github.com/mkropat/luks-mount.git
    cd luks-mount
    make deb
    sudo dpkg -i luks-mount*all.deb
    sudo apt-get install -f	# if there were missing dependencies

#### From Source

    git clone https://github.com/mkropat/luks-mount.git
    cd luks-mount
    make && sudo make install

