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

**luks-format** is meant to be complementary to
[crypttab](http://manpages.ubuntu.com/manpages/trusty/man5/crypttab.5.html).
If you want to unlock an encrypted volume at boot and have it stay unlocked,
let `crypttab` handle that for you.

On the other hand, if you want to mount an encrypted volume on demand — and
unmount it when you're done with it so it stays safe — that's where
**luks-format** can help.  By default, 15 minutes after you mount a LUKS
volume, **luks-format** will begin to monitor the mount point and wait for you
to finish using it.  As soon as it's no longer in use, **luks-format** will
unmount the encrypted volume and automatically close it for you.

### Installation

To install the scripts into `/sbin`, run:

    sudo make install

`.deb` and `.rpm` packages are in the works.
