#!/system/bin/sh
export ALSA_CONFIG_PATH=/data/local/tmp/channeltest/avtp.conf


# channel 2
aplay -D "aaf2" -t raw -f S16_BE -r 48000 -c 2 --period-size=64 --buffer-size=256 channel2.raw

# channel 10
aplay -D "aaf10" -t raw -f S16_BE -r 48000 -c 10 --period-size=64 --buffer-size=256 channel10.raw

# channel 14
aplay -D "aaf14" -t raw -f S16_BE -r 48000 -c 14 --period-size=12 --buffer-size=96 channel14.raw
