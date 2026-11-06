# Enabling additional kernel flags

File: arch/arm64/configs/bcm2712_gki.fragment

```
#
# AVB / TSN (IEEE 1722 AVTP)
#
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CBS=y
CONFIG_NET_SCH_ETF=y
CONFIG_NET_SCH_TAPRIO=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_CLS_FLOWER=y
CONFIG_NET_ACT_VLAN=y

#
# ALSA Loopback
#
CONFIG_SND_DRIVERS=y
CONFIG_SND_ALOOP=y

#
# PHY-Treiber: faellt bei der Regenerierung sonst weg
#
CONFIG_BROADCOM_PHY=y
```
