# Amstrad CPC CTC DART
Simple Z80 CTC and DART board compatible with the Amstrad CPC and MX4 connector

![assembled-board](https://github.com/rabs664/Amstrad-CPC-CTC-DART/blob/main/Images/assembled-board.jpg)

## Objective
Prototyping board to learn about the Z80 CTC and DART, and how to write Z80 assembly using an Amstrad CPC.

## Background
Part of a number of modular cards using Z80 associated peripherals and the Amstrad CPC.

See also;
[Amstrad CPC 2855 PIO](https://github.com/rabs664/Amstrad-CPC-8255-PIO), [Amstrad CPC Z80 CTC](https://github.com/rabs664/Amstrad-CPC-Z80-CTC) and [Amstrad CPC Z80 DART](https://github.com/rabs664/Amstrad-CPC-Z80-DART)

## Backplane
[CPC Amstrad Expansion Backplane by revaldinho](https://github.com/revaldinho/cpc_ram_expansion/wiki/CPC-Expansion-Backplane)

## IO Addressing
The IO Address can be selected using jumpers, supporting the following base address.

* F8XX
* F9XX
* FAXX
* FBXX

The CTC is then adressed at XXEO and the DART at XXF0.

See [CPC Wiki IO Port Summary](https://www.cpcwiki.eu/index.php/I/O_Port_Summary) for a list of known IO ports used on the Amstrad CPC.

## Testing
The CTC DART board has been built and simple testing has been completed on an Amstrad CPC 6128.

Note also an FTDI Serial Adapter was used to connect to a Tera Term session.


## PCBs
PCBs are available from Seeed Studio, waiting for approval.

## Components
This [Digi-Key](https://www.digikey.co.uk/en/mylists/list/81SQJULUKE) List contains all components excluding the Z80 CTC, DART and FTDI Serial Adapter.

## Assembler
[RASM](https://github.com/EdouardBERGE/rasm)

## Resources
[Zed80 Website](http://zed80.com/Z80-RETRO/index_Home.html)

[CPCWiki](https://www.cpcwiki.eu/index.php/Main_Page)

Z80 Application by James W Coffron ISBN 0-89588-094-6

## Acknowledgements
[@revaldinho](https://github.com/revaldinho)

Don Prefontaine 

Peter Murray

[@EdouardBERGE](https://github.com/EdouardBERGE)

# Release History
## Version 1.0
* First Release
## Version 2.0
* FTDI interface moved to support hardare flow control
