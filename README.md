# Rucon

Simple ruby containers. Aimed as a POC and maybe someday a bit more than that. 

- ruby
- curl
- systemd-nspawn
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
bundle
bundle binstub rucon

sduo ./bin/rucon fetchfs file:///home/vagrant/base.sqsh my-base
sudo ./bin/rucon create my-container my-base
sudo ./bin/rucon enter my-container

# passwd root 
# apt-install ruby etc etc
# exit

sudo ./bin/rucon boot my-container
```