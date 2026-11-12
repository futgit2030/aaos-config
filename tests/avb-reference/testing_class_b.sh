#!/system/bin/sh
export ALSA_CONFIG_PATH=/data/local/tmp/test/avtp.conf

# class b
aplay -D avtp_b --period-size=12 --buffer-size=48 test_48k.wav

