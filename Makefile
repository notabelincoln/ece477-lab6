# GCC variables
CC = gcc
CFLAGS = -g -O2 -Wall
AVRFLAGS = -O3
AVRTARGET = lab6_avr.c

all:	avr rpi

avr: fuse lab6_avr lab6_avr.hex flash
rpi: lab6a lab6b

lab6a:	lab6a.o
	$(CC) -o lab6a lab6a.o

lab6a.o:	lab6a.c
	$(CC) $(CFLAGS) -c lab6a.c

lab6b:	lab6b.o
	$(CC) -o lab6b lab6b.o

lab6b.o:	lab6b.c
	$(CC) $(CFLAGS) -c lab6b.c

# Compile avr code and flash it to the board
fuse: avrdude_gpio.conf
	avrdude -C ./avrdude_gpio.conf -c pi_1 -p m88p -U lfuse:w:0xe2:m -U hfuse:w:0xdf:m -U efuse:w:0xf9:m

eeprom:
	avrdude -C ./avrdude_gpio.conf -c pi_1 -p m88p -U eeprom:w:0x04,0x01:m

lab6_avr: $(AVRTARGET)
	avr-gcc -mmcu=atmega88pa $(AVRFLAGS) $(AVRTARGET) -o lab6_avr

lab6_avr.hex: lab6_avr
	avr-objcopy -j .text -j .data -O ihex lab6_avr lab6_avr.hex

flash: lab6_avr.hex avrdude_gpio.conf
	avrdude -C avrdude_gpio.conf -c pi_1 -p m88p -U flash:w:lab6_avr.hex:i

clean:
	rm -f *~ *.o *.hex lab6a lab6b lab6_avr

