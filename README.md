# SPI
Verilog implementation of the SPI Protocol

## INTRODUCTION :

Serial Peripheral Interface (SPI) is a synchronous four-wire serial communication protocol used by microcontrollers to talk to nearby peripheral devices quickly.
The SPI (Serial Peripheral Interface) protocol is a synchronous, full-duplex, master-slave-based serial communication interface used for short-distance communication, typically between microcontrollers and peripheral devices (like sensors, SD cards, or shift registers).

SPI is a common communication protocol used by many different devices. For example, SD card reader modules, RFID card reader modules, and 2.4 GHz wireless transmitter/receivers all use SPI to communicate with microcontrollers.
One unique benefit of SPI is the fact that data can be transferred without interruption. Any number of bits can be sent or received in a continuous stream. With I2C and UART, data is sent in packets, limited to a specific number of bits. Start and stop conditions define the beginning and end of each packet, so the data is interrupted during transmission.

Devices communicating via SPI are in a master-slave relationship. The master is the controlling device (usually a microcontroller), while the slave (usually a sensor, display, or memory chip) takes instruction from the master. The simplest configuration of SPI is a single master, single slave system, but one master can control more than one slave 


