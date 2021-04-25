# PiZero+DHT22 temperature/humidity sensor in a docker container

## Information
This fork of [hvalev's solution](https://github.com/hvalev/dht22mqtt-homeassistant-docker) is designed to run on Raspberry Pi Zeros. It uses a depreciated version of the Adafruit Python DHT library to avoid issues with [DHT sensor not found](https://github.com/adafruit/Adafruit_CircuitPython_DHT/issues/49).

You should be able to use the DHT11, DHT22 or AM2302 temperature and humidity sensors as with hvalev's original solution, but this has only been tested with the DHT22. Like the original, this will automatically filter out outliers and send accurate data to the MQTT broker, with autodiscovery for home assistant. A condition has been added where filtering is not applied if enough data has not yet been gathered, which will allow the container to start reporting data to MQTT immediately.

## How to run it
Unlike the original, you will need to build this on your Pi Zero which will take a few minutes. The below docker-compose should get you started:

```
version: '2'

services:
  dht22mqtt:
    container_name: dht22mqtt
    build:
      context: 'https://github.com/JGtHb/dht22mqtt-homeassistant-docker.git#main'
    environment:
      - broker=192.168.1.2
      - topic=dht22
      - device_id=room1_dht22
      - pin=2
      - device_type=dht22
      - poll=20
      - unit=C
    restart: unless-stopped
    privileged: true
```

## Parameters
The container offers the following configurable environment variables:</br>
| Parameter | Possible values | Description | Default |
| --------- | --------------- | ----------- | ------- |
| ```topic``` |  | MQTT topic to submit to. | ```dht22```  |
| ```device_id``` |  | Unique identifier for the device. \*If you have multiple, you could use something like ```bedroom_dht22```. | ```room1_dht22``` |
| ```broker``` |  | MQTT broker ip address. | ```192.168.1.2``` |
| ```pin``` |  | GPIO data pin your sensor is hooked up to. | ```2``` |
| ```poll``` |  | Sampling rate in seconds.  | ```20``` |
| ```device_type``` | ```dht11```, ```dht22```, or ```am2303``` | Sensor type.  | ```dht22``` |
| ```unit``` | ```C``` or ```F``` | Measurement unit for temperature in Celsius or Fahrenheit. | ```C``` |
| ```mqtt_chatter``` | ```essential\|ha\|full``` | Controls how much information is relayed over to the MQTT broker. Possible ***non-mutually exclusive*** values are: ```essential``` - enables basic MQTT communications required to connect and transmit data to the zigbee broker; ```ha``` enables home assistant discovery protocol; ```full``` enables sending information about the outlier detection algorithm internals over to the MQTT broker. | ```essential\|ha``` |
| ```logging``` | ```log2stdout\|log2file``` | Logging strategy. Possible ***non-mutually exclusive*** values are: ```log2stdout``` - forwards logs to stdout, inspectable through ```docker logs dht22mqtt``` and ```log2file``` which logs temperature and humidity readings to files timestamped at containers' start. | ```none``` |
| ```filtering``` | ```enabled``` or ```none``` | Enables outlier filtering. Disabling this setting will transmit the raw temperature and humidity values to MQTT and(or) the log. | ```enabled``` |
----------------------------------
