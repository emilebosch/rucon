# Rucon

Simple ruby containers. Aimed as a POC and maybe someday a bit more than that. 

- ruby
- curl
- [systemd-nspawn](http://www.freedesktop.org/software/systemd/man/systemd-nspawn.html)
- squasfs
- overlayfs

## Install

Not ready for installation yet. Only if you're hacking on this repo. 

## What?

This is the attempt to make containers easy and understandable. The world is now
filled with cruft and overcomplexification of this. Back to the roots y'all.

Objectives:

- Download containers
- Run containers
- Tweak the f out of what you want.
- Make you understand the concepts.

# Usage

```
rucon fetchfs file:///home/vagrant/base.sqsh my-base
rucon create my-container my-base
rucon enter my-container
rucon boot my-container
```