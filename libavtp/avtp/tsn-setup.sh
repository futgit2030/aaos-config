#!/vendor/bin/sh
# Ausgabe nach dmesg - als init-Service ist stdout/stderr sonst /dev/null (14.3)
exec 1>/dev/kmsg 2>&1

# PFLICHT: die PATH eines init-Service enthaelt /system/bin nicht zuverlaessig,
# und ip/tc liegen genau dort. Ohne das: "ip: inaccessible or not found".
PATH=/system/bin:/vendor/bin
export PATH

IFACE=eth0
VID=65

# 8021q wird von init geladen (insmod-Builtin in der init.avtp.rc) - ein
# Service mit "capabilities"-Zeile hat kein CAP_SYS_MODULE und bekaeme EPERM.
if [ ! -d /proc/net/vlan ]; then
    echo "tsn-setup: 8021q nicht geladen - VLAN wird uebersprungen"
else
    # idempotent: bei erneutem Lauf sonst "File exists"
    if [ ! -d /sys/class/net/${IFACE}.${VID} ]; then
        ip link add link $IFACE name ${IFACE}.$VID type vlan id $VID \
            egress-qos-map 0:0 3:3 2:2
    fi
    ip link set ${IFACE}.$VID up
fi

# Traffic Shaping (prio + CBS, gemessen): prio als Root, CBS nur am Band der SR-Klasse A.
# SO_PRIORITY 3 -> Band 0 (1:1) -> CBS; alles andere -> Band 1 (1:2), ungedrosselt.
# Geformt wird auf eth0, nicht eth0.2 - VLAN-Pakete laufen am Ende durch die Qdisc von eth0.
# "replace" ist idempotent - ein zweiter Lauf aendert nichts.
if tc qdisc replace dev $IFACE root handle 1: prio bands 2 \
       priomap 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 && \
   tc qdisc replace dev $IFACE parent 1:1 handle 10: cbs \
       idleslope 5760 sendslope -994240 hicredit 9 locredit -89 offload 0; then
    echo "tsn-setup: prio+cbs auf $IFACE aktiv"
else
    echo "tsn-setup: tc fehlgeschlagen - Shaping inaktiv"
fi

# Anzahl HW-TX-Queues: entscheidet ueber die Qdisc-Struktur (13.4)
echo "tsn-setup: TX-Queues =" $(ls -d /sys/class/net/$IFACE/queues/tx-* | wc -l)
