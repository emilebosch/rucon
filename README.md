# Rucon

Simple ruby containers

- ruby
- curl
- systemd-nspawn
- squasfs
- overlayfs

## Install

## What?

This is the attempt to make containers easy and understandable. The world is now
filled with cruft and overcomplexification of this. Back to the roots y'all.

Objectives:

- Download containers
- Run cotnainers
- Tweak the f out of what you want.
- Make you understand the concepts.

# Useage

```
bundle
bundle binstub ricon

./bin/rucon fetchfs file:///home/vagrant/base.sqsh my-base
sudo ./bin/rucon mountfs my-base

sudo ./bin/rucon create my-container my-base
sudo ./bin/rucon enter my-container

# passwd root 
# apt-install ruby etc etc
# exit

sudo ./bin/rucon boot my-container
```