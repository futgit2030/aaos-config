# Patch for broken EEE modes in some Raspberry Pi 5 variants

File: common/arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b.dts

```
 	phy1: ethernet-phy@1 {
 		reg = <0x1>;
 		brcm,powerdown-enable;
+		eee-broken-100tx;
+		eee-broken-1000t;
 	};
```
