/*
    Name:   Serial IO (SIO) Function Library

    Action: Provides functions and definitions associated with Serial IO.

    Macros: SIO_Init_F        : Initialises the CTC amd DART
            SIO_Put_Char_F    : Transmits a character
            SIO_Put_Str_F     : Transmites a string
            SIO_Put_Line_F    : Transmits a string and terminates with CRLF
            SIO_Get_Char_F    : Reads a character
            SIO_Get_Line_F    : Reads a string until ENTER (CR) is pressed
            SIO_Get_Bin_F     : Reads a block of data

    Notes: Uses Firmware macro libary to test for ESC key

    Version:    1.0 19/08/23 First version
                1.1 26/08/23 Corrected defintion of 1 Stop bit for WR4.

    This file is part of the RAB664 distribution (hhttps://gist.github.com/rabs664).
    Copyright (c) 2023 Robert Bewes.
  
    This program is free software: you can redistribute it and/or modify  
    it under the terms of the GNU General Public License as published by  
    the Free Software Foundation, version 3.
 
    This program is distributed in the hope that it will be useful, but 
    WITHOUT ANY WARRANTY; without even the implied warranty of 
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
    General Public License for more details.
 
    You should have received a copy of the GNU General Public License 
    along with this program. If not, see <http://www.gnu.org/licenses/>.

*/


; CTC and DART Address
SIO_CTC_ADDR=#F8E0          
SIO_DART_DATA_ADDR=#F8F0     
SIO_DART_CTRL_ADDR=#F8F2    

SIO_CTC_DATA:
/*
CTC Control Word
    7 0 Disable Int 
    6 1 Counter
    5 0 Not Used 
    4 1 Positive Edge 
    3 0 Not used
    2 1 Time Constant to follow
    1 1 Reset
    0 1 Control Word
*/ 
DEFB %01010111 ; #57 
               
/* 
BAUD Clock Frequency
 
    Assuming a BAUD clock frequency of 1843200 and assuming the DART divides the CTC output by 16
    then the Time Constant for a required BAUD needs to be

    TC            BAUD
    1             115200 
    2             57600 
    3             38400 
    4             28800 
    6             19200 
    8             14400 
    12            9600 
    24            4800 
    48            2400 
    96            1200 
    192           600
*/
DEFB 12 ; Times Constant for 9600 BAUD

SIO_DART_DATA:
/*
    WR0
    7-6 00  Null Code 
    5-3 011 Channel Reset
    2-0 000 Register 0
*/
DEFB %00011000 ; #18

/* 
    WR4
    7-6 01  X16
    5-4 00  8 Bits
    3-2 01  1 Stop
    1-0 00  NO Parity
*/
DEFB 4,%01000100 ; #44

/*
    WR3
    7-6 11  RX 8 Bits
    5   0   No Flow Control (1 for RTS/CTS)
    0   1   RX Enable
*/
DEFB 3,%11100001 ; #C1 (#E1 for RTS/CTS)

/*
    WR5
    6-5 11 TX 8 Bits
    3   1  TX Enable
    2   0  No FLow Control (1 for RTS/CTS)
*/
DEFB 5,%01101100 ; #68 (#6C for RTS/CTS)

/*
    WR1
    7-0 0 Disable all Interrputs
*/
DEFB 1,%00000000 ; #00


/*
    Name: SIO_Init_F

    Action: Initialises the CTC and DART

    Entry:  
        None

    Exit:   
        All Registers corrupted

    Notes:  

    Version: 1.0 07/09/23 First version

*/
SIO_Init_F:

    ; Initialise the CTC
    ld hl, SIO_CTC_DATA
    ld bc, SIO_CTC_ADDR

    ld a,2
    .Init_CTC:
        ld e,(hl)
        out (c),e
        inc hl
        dec a
    jr nz,.Init_CTC

    ; Initialise the DART
    ld hl,SIO_DART_DATA
    ld bc,SIO_DART_CTRL_ADDR

    ld a,9
    .Init_DART:
        ld e,(hl)
        out (c),e
        inc hl
        dec a
    jr nz,.Init_DART:

ret

/*
    Name: SIO_Put_Char_F

    Action: Waits for the transmit buffer to be empty and then sends a character

    Entry:  
        E Character to send

    Exit:   
        C Flag = 1 if ESC pressed, BC corrupt. All other registers preserved

    Notes:

    Version: 1.0 08/09/23 First version

*/ 
SIO_Put_Char_F:
; Preserve HL
push hl

    .Loop:
        ; If ESC has been pressed exit 
        ld a,66       
        call #BB1E ; Firmware call to Test Key
        jp nz,.Esc

        ; Wait for transmit buffer to be empty RR0 Bit 2=1
        ld bc,SIO_DART_CTRL_ADDR 
        in a,(c)
        bit 2,a

    jp z,.Loop

    ;Put Char
    ld bc,SIO_DART_DATA_ADDR
    out (c),e       
    
    ; Set C Flag = 0 for no error
    scf
    ccf
    ; Jump past exit with error
    jr .End

    .Esc:
    ; Set C Flag = 1 for error
    scf

.End:
pop hl
ret

/*
    Name: SIO_Put_Str_F

    Action: Transmits a String ending with +#80

    Entry:  
        HL Address of String to Put

    Exit:   
        C Flag = 1 if ESC pressed, BC corrupt. All other registers preserved

    Notes:  

    Version: 1.0 08/09/23 First version

*/ 
SIO_Put_Str_F:

    .Loop:
        ; Check for last char
        ld a,(hl)      
        bit 7,a
        jp nz,.LastChar

        ; Put the char
        ld e,a
        call SIO_Put_Char_F

        ; Check for ESC
        jp c,.End

        ;Move to next char
        inc hl

    jr .Loop

    ;Last Char to Put
    .LastChar:
        sbc #80 ;Remove the string terminator
        
        ;Put Char
        ld e,a
        call SIO_Put_Char_F

.End:
ret

/*
    Name: SIO_Put_Line_F

    Action: Calls SIO_Put_Str and also puts a CR and FL

    Entry:  
        HL Address of String to Put

    Exit:   
        C Flag =1 if ESC pressed, BC corrupt. All other registers preserved

    Notes:  

    Version: 1.0 08/09/23 First version

*/ 
SIO_Put_Line_F:

    Call SIO_Put_Str_F

    jr c,.End ; If C Flag = 1 then ESC has been pressed

    ;Put Line Feed and Carriage Return
    ld e, #0D ; CR
    call SIO_Put_Char_F

    jr c,.End ; If C Flag = 1 then ESC has been pressed

    ld e, #0A ; LF
    call SIO_Put_Char_F

.End:
ret
    
    
/*
    Name: SIO_Get_Char_F

    Action: Waits for an available character and then reads it

    Entry:  
        None

    Exit:  
        A Received char, C Flag = 1 if ESC pressed, BC corrupt. All other registers preserved

    Notes:  

    Version: 1.0 19/08/23 First version

*/ 
SIO_Get_Char_F:
; Preserve HL
push hl

    .Loop:
        ; If ESC has been pressed exit 
        ld a,66       
        call #BB1E ; Firmware call to Test Key
        jp nz,.Esc

        ; Is Char available? RR0 Bit 0=1
        ld bc,SIO_DART_CTRL_ADDR 
        in a,(c)
        bit 0,a

    jp z,.Loop

    ; Get a char
    ld bc,SIO_DART_DATA_ADDR
    in a,(C)

    ; Set C Flag = 0 for no ESC
    scf
    ccf
    ; Jump past exit with ESC
    jr .End

    .Esc:
    ; Set C Flag = 1 for ESC
    scf

.End:
pop hl
ret

/*
    Name: SIO_Get_Line_F

    Action: Get characters until a ENTER is pressed (CR)

    Entry:  
        HL Address of where to place chars

    Exit:  
        C Flag = 1 if ESC pressed, BC corrupt, HL contains address of last char and DE contains number of chars read. All other registers preserved

    Notes:  

    Version: 1.0 19/08/23 First version

*/ 
SIO_Get_Line_F:
    ; Reset the char counter
    ld de,0

    .Loop:
        call SIO_GET_CHAR_F
        ; Check for ESC
        jp c,.Esc

        ; Check for CR
        cp a,#0D
        jp z,.LastChar

        ; Put the char in memory
        ld (hl),a      

        ; Move to next memory address to put char
        inc hl

        ; Increment Char Counter
        inc de
    jr .Loop

    .LastChar:
    ; Set C Flag = 0 for no ESC
    scf
    ccf
    ; Jump past exit with ESC
    jr .End

    .Esc:
    ; Set C Flag = 1 for ESC
    scf

.End:
ret

/*
    Name: SIO_Get_Bin_F

    Action: Get a specified number of bytes

    Entry:  
        HL Address of where to place data
        DE Number of Bytes to get

    Exit:  
        C Flag = 1 if ESC pressed, BC corrupt, HL contains address of last byte and DE contains number of bytes remaining to be read. All other registers preserved

    Notes:  

    Version: 1.0 19/08/23 First version

*/ 
SIO_Get_Bin_F:

    .Loop:
        call SIO_GET_CHAR_F
        ; Check for ESC
        jp c,.Esc

        ; Put the Byte in memory
        ld (hl),a      

        ; Move to next memory address to put byte
        inc hl

        ; Decrement Byte Counter
        dec de

        ; Test to see if more bytes are to be read, is de=0?
        ld a,d
        or e

    jr nz, .Loop ; Are there bytes remaning?

    ; Set C Flag = 0 for no ESC
    scf
    ccf
    ; Jump past exit with ESC
    jr .End

    .Esc:
    ; Set C Flag = 1 for ESC
    scf

.End:
ret