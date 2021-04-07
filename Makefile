# GCC variables
CC = gcc
CFLAGS = -g -O2 -Wall
LFLAGS = -lwiringPi

all:	lab5a lab5b fuse lab5_avr lab5_avr.hex flash

lab5a:	lab5a.o
	$(CC) $(LFLAGS) -o lab5a lab5a.o

lab5a.o:	lab5a.c
	$(CC) $(CFLAGS) -c lab5a.c

lab5b:	lab5b.o
	$(CC) $(LFLAGS) -o lab5b lab5b.o

lab5b.o:	lab5b.c
	$(CC) $(CFLAGS) -c lab5b.c

# Compile avr code and flash it to the board
fuse: lab5_avrdude_gpio.conf
	avrdude -C ./lab5_avrdude_gpio.conf -c pi_1 -p m88p -U lfuse:w:0xe2:m -U hfuse:w:0xdf:m -U efuse:w:0xf9:m

lab5_avr: lab5_avr.c
	avr-gcc -mmcu=atmega88pa lab5_avr.c -o lab5_avr

lab5_avr.hex: lab5_avr
	avr-objcopy -j .text -j .data -O ihex lab5_avr lab5_avr.hex

flash: lab5_avr.hex lab5_avrdude_gpio.conf
	avrdude -C lab5_avrdude_gpio.conf -c pi_1 -p m88p -U flash:w:lab5_avr.hex:i

clean:
	rm -f *~ *.o *.hex lab5a lab5b lab5a_avr lab5b_avr

