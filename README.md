Vybrid Boot Shim
================

Redirect Vybrid boot flow to different devices by using (undocumented)
SRC_GPR9/GRP10 registers.

## Compile

Make sure CROSS_COMPILE is set to a ARM cross compiler.

```
${CROSS_COMPILE}gcc -marm -mno-thumb-interwork -mabi=aapcs-linux -mword-relocations -march=armv7-a  -mno-unaligned-access -c -o shim.o shim.S
${CROSS_COMPILE}objcopy -O binary shim.o shim.bin
```

Create a header required by the Vybrid/i.MX boot ROM's (mkimage from U-Boot)

```
mkimage -n imximage.cfg -T imximage -e 0x3f408000 -d shim.bin shim.imx
```

Finally, the boot ROM requires the image to be padded by 0x400 bytes to boot
from NAND

```
(dd bs=1024 count=1 if=/dev/zero 2>/dev/null) | cat - shim.imx > shim-nand.imx
```

## Flash

Copy the file shim-nand.imx on a SD-Card and flash it to NAND using:

```
fatload mmc 0:1 ${loadaddr} shim-nand.imx && nand erase.part u-boot && nand erase.part u-boot-env && nand write ${loadaddr} u-boot
```
