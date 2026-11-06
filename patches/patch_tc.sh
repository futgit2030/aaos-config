#/bin/bash

cd ~/aaos17/

# 0. Altstand bereinigen: q_taprio.c darf weder in den srcs stehen noch im Verzeichnis liegen
sed -i '/"q_taprio.c",/d' external/iproute2/tc/Android.bp
rm -f external/iproute2/tc/q_taprio.c
grep -n 'q_taprio' external/iproute2/tc/Android.bp        # muss leer sein
ls external/iproute2/tc/q_taprio.c 2>/dev/null            # muss leer sein

# 1. Quellen aus einem definierten Release holen
git clone --depth 1 -b v6.7.0 https://github.com/iproute2/iproute2.git /tmp/ip2
cp /tmp/ip2/tc/q_cbs.c /tmp/ip2/tc/q_etf.c external/iproute2/tc/

# 2. uapi-Header: kennt er die Attribute? Wenn nicht -> aus DEMSELBEN Release nehmen
grep -c 'TCA_ETF_DELTA\|TCA_CBS_PARMS' external/iproute2/include/uapi/linux/pkt_sched.h
cp /tmp/ip2/include/uapi/linux/pkt_sched.h \
   external/iproute2/include/uapi/linux/pkt_sched.h          # nur bei Ergebnis 0 oder 1

# 3. utils.h: json_print.h einbinden wie upstream (sonst 'print_string' undeclared)
grep -q '#include "json_print.h"' external/iproute2/include/utils.h || \
  sed -i 's/^#include "rtm_map.h"$/&\n#include "json_print.h"/' \
      external/iproute2/include/utils.h
grep -n 'rtm_map.h\|json_print.h' external/iproute2/include/utils.h   # beide Zeilen da?

# 4. srcs des cc_binary "tc" ergaenzen (direkt hinter q_mqprio.c) - nur wenn noch nicht drin
grep -c '"q_mqprio.c",' external/iproute2/tc/Android.bp             # muss 1 sein
grep -q '"q_cbs.c",' external/iproute2/tc/Android.bp || \
  sed -i 's/^\(\s*\)"q_mqprio.c",$/&\n\1"q_cbs.c",\n\1"q_etf.c",/' \
      external/iproute2/tc/Android.bp
grep -c '"q_cbs.c",\|"q_etf.c",' external/iproute2/tc/Android.bp   # muss 2 sein, nicht 4

# 5. Linkt json_print.c mit? (sonst Linkfehler 'undefined symbol: print_string')
grep -rn 'json_print\.c' external/iproute2/*/Android.bp \
  || echo 'FEHLT -> "json_print.c" in die srcs von libiprouteutil (lib/Android.bp)'
