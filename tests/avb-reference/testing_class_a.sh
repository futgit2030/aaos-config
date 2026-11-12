#!/system/bin/sh
export ALSA_CONFIG_PATH=/data/local/tmp/test/avtp.conf

# class a
aplay -D avtp_a --period-size=6 --buffer-size=24 test_48k.wav
