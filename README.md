# VoCore2 Defaut : Firmware Build (OpenWRT) #
---

**\*Note\*:**
This Image/Repo is currently **IN DEVELOPMENT** - Users should and likely will experience issues.

#### What is VoCore2? ####
---
![vocore2](http://vocore.io/img/split1.png)

VoCore is open hardware and runs OpenWrt/LEDE. It has WIFI, USB, UART, 20+ GPIOs but is only one inch square. It will help you to make a smart house, study embedded system or even make the tiniest router in the world.

You will not only get the VoCore but also its full hardware design including schematic, circuit board, bill of materials; full source code (including boot loader), operating system (OpenWRT) and applications. You are able to control ***EVERY BIT*** of your VoCore.

We invite you join us, help our community improve this open source hardware and use your creative skills to make a more wonderful Internet of Things!

http://www.vocore.io

#### What's in this Image? ####
---
This is my first attempt at a Docker Image which contains the needed development environment to customize, validate and build the firmware image/s that can be flashed to the VoCore2 board.  

The platform consists of an Unbuntu 14.04 Trusty core with added OpenWRT source code for the VoCore2 board.  All needed packages are configured and will install upon pull as well a standard .config for building is defaulted.

OpenWRT source is being pulled from [GitHub Repo](https://github.com/noblepepper/openwrt-chaoscalmer) upon load to get the latest branch and potential patches. Currently [Noblepepper](https://github.com/noblepepper) is maintaining the community branch of the source.

# Basic Usage #
---
Run the Container:
```dockerfile
docker run -ti --name <ContainerName> ictinike/vocore2-default
```
Build Tools and Toolchain (**Note:** Tools and Toolchain will build automatically issuing just the `make` command):

```dockerfile
    make Tools/Install
    make Toolchain/Install
```

Update the source FEEDS at a later time:
```dockerfile
    ./scripts/feeds update -a
    ./scripts/feeds install -a
```

However, if you wish to change the build format type you can execute:

```dockerfile
echo "<TARGET_TYPE_BELOW>=y" >> .config
make defconfig
```

Valid Target Types:
* CONFIG_TARGET_ramips_mt7628_VOCORE2-128M
* CONFIG_TARGET_ramips_mt7628_VOCORE2-128M-SD
* CONFIG_TARGET_ramips_mt7628_VOCORE2-LITE
* CONFIG_TARGET_ramips_mt7628_VOCORE2-BETA
* CONFIG_TARGET_ramips_mt7628_VOCORE2-128M-SPIDEV
* CONFIG_TARGET_ramips_mt7628_VOCORE2-128M-FLASHWRITE
* CONFIG_TARGET_ramips_mt7628_VOCORE2-128M-MAX-GPIO

Build firmware:
```dockerfile
    make
```
----

## Build Output ##
---
The build output will be placed in the created `\bin` folder for flashing.
