# Reference AVB Streams Class A + B


1. Download Sample-WAV (e.g. https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.wav)
2. Convert File to correct format:
```
sox ff-16b-2c-44100hz.wav -r 48000 test_48k.wav
````

3. Send Class A or Class B stream via shell scripts:
```
# class a
./testing_class_a.sh


# class b
./testing_class_b.sh
```



