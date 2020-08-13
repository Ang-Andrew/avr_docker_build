DIR = $(CURDIR)
SRC = $(wildcard $(DIR)/*.c)
OUTPUT = $(patsubst %.c,%.o,$(SRC))
DEVICE = atmega328p
COMPILE = avr-gcc -Wall -Os -mmcu=$(DEVICE)

.phony: debug clean docker_run docker_build

$(OUTPUT):
	$(COMPILE) -c -o $(OUTPUT) $(SRC)
	$(COMPILE) -o $(patsubst %.o,%.elf,$(OUTPUT)) $(OUTPUT)
	avr-objcopy -O ihex -R .eeprom blink_led blink_led.hex

docker_run:
	sudo docker run --rm -it -v ${PWD}:/mount avr bash

docker_build:
	sudo docker build -t avr .

clean:
	rm -rf *.hex *.o *.elf

debug:
	@echo SRC : $(SRC)
	@echo OUTPUT : $(OUTPUT)