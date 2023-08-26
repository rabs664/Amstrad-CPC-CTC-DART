/*
    Name:   DART Macro Library

    Action: Provides macros and definitions associated with the Z80 DART.

    Macros: DRT_DEF_ADDR_M  : Defines the adressing for the DART
            DRT_DEF_WR0_M   : Defines the DART Write Register 0
            DRT_DEF_WR1_M   : Defines the DART Write Register 1
            DRT_DEF_WR2_M   : Defines the DART Write Register 2
            DRT_DEF_WR3_M   : Defines the DART Write Register 3
            DRT_DEF_WR4_M   : Defines the DART Write Register 4
            DRT_DEF_WR5_M   : Defines the DART Write Register 5
            DRT_INIT_M      : Initialises the DART with the Write Registers
            DRT_TX_CHAR_M   : Transmits a character
            DRT_RX_CHAR_M   : Reads a character

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


/*
    Name:   DART Definitions
*/
DRT_A_DATA_ADDR=#FBE0 ; Channel A Data Address 
DRT_A_CTRL_ADDR=#FBE2 ; Channel A Control Address
DRT_B_DATA_ADDR=#FBE1 ; Channel B Data Address
DRT_B_CTRL_ADDR=#FBE4 ; Channel B Control Address

; Write Registers
DRT_WR0=0 ; Command Register
DRT_WR1=0 ; Interrupt Register
DRT_WR3=0 ; Rx Register
DRT_WR4=0 ; Rx and TX Control
DRT_WR5=0 ; Tx Register

; Read Registers
DRT_RR0=0 ; Status Register

; Channel Selection
DRT_CHANNEL_A=0
DRT_CHANNEL_B=1

; WR0 Command Definitions
DRT_WR0_NULL_COMMAND=0
DRT_WR0_RESET=3

; WR1 Interrupt Definitions
DRT_WR1_DISABLE_ALL_INT=0

; WR3 Rx Enable
DRT_WR3_RX_ENABLE=1
DRT_WR3_RX_DISABLE=0

; WR3 Auto Enable
DRT_WR3_AUTO_ENABLE=1
DRT_WR3_AUTO_DISABLE=0

; WR3 RX Bits Per Char
DRT_WR3_RX_5_BITS=0
DRT_WR3_RX_7_BITS=1
DRT_WR3_RX_6_BITS=1
DRT_WR3_RX_8_BITS=3

; Parity Definitions in WR4
DRT_WR4_NO_PARITY=0
DRT_WR4_EVEN_PARITY=1
DRT_WR4_ODD_PARITY=3

; Stop Bit Definitions in WR4
DRT_WR4_1_STOP_BIT=1
DRT_WR4_1_PLUS_HALF_STOP_BITS=2
DRT_WR4_2_STOP_BITS=3

; Clock Mode Definitions in WR4
DRT_WR4_X1=0
DRT_WR4_X16=1
DRT_WR4_X32=2
DRT_WR4_X64=3

; WR5 Tx Enable
DRT_WR5_TX_ENABLE=1
DRT_WR5_TX_DISABLE=0

; WR5 RTS Enable
DRT_WR5_RTS_ENABLE=1
DRT_WR5_RTS_DISABLE=0


; WR5 TX Bits Per Char
DRT_WR5_TX_5_BITS=0
DRT_WR5_TX_7_BITS=1
DRT_WR5_TX_6_BITS=1
DRT_WR5_TX_8_BITS=3


; RR0 Status Bits
DRT_RR0_TX_BUFFER_EMPTY_BIT=2
DRT_RR0_RX_CHAR_AVAIL_BIT=0


/*
    Name: DRT_DEF_ADDR_M

    Action: Defines the Data and Control Addresses

    Entry:  Addr is base adress to use

    Exit:   Sets Data and Control address defintions

    Notes:  

    Version: 1.0 19/08/23 First version

*/
macro DRT_DEF_ADDR_M Addr

    DRT_A_DATA_ADDR={Addr}   ; Channel A Data Address 
    DRT_A_CTRL_ADDR={Addr}+2 ; Channel A Control Address
    DRT_B_DATA_ADDR={Addr}+1 ; Channel B Data Address
    DRT_B_CTRL_ADDR={Addr}+4 ; Channel B Control Address
    
    print "DRT INF CHANNEL A DATA ADDR", {hex4}DRT_A_DATA_ADDR
    print "DRT INF CHANNEL A CTRL ADDR", {hex4}DRT_A_CTRL_ADDR
    print "DRT INF CHANNEL B DATA ADDR", {hex4}DRT_B_DATA_ADDR
    print "DRT INF CHANNEL B CTRL ADDR", {hex4}DRT_B_CTRL_ADDR
mend

/*
    Name: DRT_DEF_WR0_M

    Action: Defines Write Register 0

    Entry:  
        REG : The register Number which should be 0
        CMD : Reset

    Exit:   Sets Definition for Write Register 0

    Notes:  

    Version: 1.0 19/08/23 First version

*/
macro DRT_DEF_WR0_M REG,CMD

    DRT_WR0 = ({CMD}<<3)+{REG}

    print "DRT INF WR0",{hex2}DRT_WR0
    print "DRT INF WR0 REG",{int}{REG}

    if {CMD}==DRT_WR0_RESET
        print "DRT INF WR0 CHANNEL RESET"
    endif
    
mend

/*
    Name: DRT_DEF_WR1_M

    Action: Defines Write Register 1

    Entry:  
        INTER: Disable Interrupts

    Exit:   Sets Definition for Write Register 1

    Notes:  

    Version: 1.0 19/08/23 First version

*/
macro DRT_DEF_WR1_M INTER

    DRT_WR1={INTER}

    print "DRT INF WR1",{hex2}DRT_WR1

    switch {INTER}
        case DRT_WR1_DISABLE_ALL_INT    : print "DRT INF WR1 All Interrupts Disabled" : break
        default                         : print "DRT ERR WR1 Bad Interrupt Definition"
    endswitch
mend

/*
    Name: DRT_DEF_WR3_M

    Action: Defines Write Register 3

    Entry:  
        RXBITS: Number of Receive Bits, 5 6, 7 or 8

    Exit:   Sets Definition for Write Register 3

    Notes:  

    Version: 1.0 19/08/23 First version

*/
macro DRT_DEF_WR3_M RXBITS

    DRT_WR3 = ({RXBITS}<<6)+DRT_WR3_RX_ENABLE

    print "DRT INF WR3",{hex2}DRT_WR3

    switch {RXBITS}
        case DRT_WR3_RX_5_BITS     : print "DRT INF WR3 RX 5 BITS"     : break
        case DRT_WR3_RX_6_BITS     : print "DRT INF WR3 RX 6 BITS"     : break
        case DRT_WR3_RX_7_BITS     : print "DRT INF WR3 RX 7 BITS"     : break
        case DRT_WR3_RX_8_BITS     : print "DRT INF WR3 RX 8 BITS"     : break
        default                    : print "DRT ERR WR3 Bad Rx Bits Definition"
    endswitch

mend

/*
    Name: DRT_DEF_WR4_M

    Action: Defines Write Register 4

    Entry:  
        PARITY: None,Odd,Even
        STOP: 1, 1 1/2, 2
        CLOCK_MODE: x1, x16, x32, x64

    Exit:   Sets Definition for Write Register 4

    Notes:  

    Version: 1.0 19/08/23 First version

*/   
macro DRT_DEF_WR4_M PARITY,STOP,CLOCK_MODE

    DRT_WR4 = ({CLOCK_MODE}<<6)+({STOP}<<2)+{PARITY}

    print "DRT INF WR4",{hex2}DRT_WR4

    switch {PARITY}
        case DRT_WR4_NO_PARITY     : print "DRT INF WR4 NO PARITY"     : break
        case DRT_WR4_EVEN_PARITY   : print "DRT INF WR4 EVEN PARITY"   : break
        case DRT_WR4_ODD_PARITY    : print "DRT INF WR4 ODD PARITY"    : break
        default                    : print "DRT ERR WR4 Bad Parity Definition"
    endswitch

    switch {STOP}
        case DRT_WR4_1_STOP_BIT             : print "DRT INF WR4 1 STOP BIT"        : break
        case DRT_WR4_1_PLUS_HALF_STOP_BITS  : print "DRT INF WR4 1 1/2 STOP BITS"   : break
        case DRT_WR4_2_STOP_BITS            : print "DRT INF WR4 2 STOP BITS"       : break
        default                             : print "DRT ERR WR4 Bad Stop Bit Definition"
    endswitch
    
    switch {CLOCK_MODE}
        case DRT_WR4_X1     : print "DRT INF WR4 CLOCK MODE X1"     : break
        case DRT_WR4_X16    : print "DRT INF WR4 CLOCK MODE X16"    : break
        case DRT_WR4_X32    : print "DRT INF WR4 CLOCK MODE X32"    : break
        case DRT_WR4_X64    : print "DRT INF WR4 CLOCK MODE X64"    : break
        default             : print "DRT ERR WR4 Bad Clock Mode Definiton"
    endswitch

mend

/*
    Name: DRT_DEF_WR5_M

    Action: Defines Write Register 5

    Entry:  
        TXBITS: Number of Transmit bits 5,6,7 or 8 

    Exit:   Sets Definition for Write Register 5

    Notes:  

    Version: 1.0 19/08/23 First version

*/ 
macro DRT_DEF_WR5_M TXBITS

    DRT_WR5 = ({TXBITS}<<5)+(DRT_WR5_TX_ENABLE<<3)

    print "DRT INF WR5",{hex2}DRT_WR5

    switch {TXBITS}
        case DRT_WR5_TX_5_BITS     : print "DRT INF WR5 TX 5 BITS"     : break
        case DRT_WR5_TX_6_BITS     : print "DRT INF WR5 TX 6 BITS"     : break
        case DRT_WR5_TX_7_BITS     : print "DRT INF WR5 TX 7 BITS"     : break
        case DRT_WR5_TX_8_BITS     : print "DRT INF WR5 TX 8 BITS"     : break
        default                    : print "DRT ERR WR5 Bad Tx Bits Definition"
    endswitch

mend

/*
    Name: DRT_INIT_M

    Action: Initialises the DART

    Entry:  
        CHAN: Channel
        PARITY: Parity
        STOP: Stop Bits
        CLOCK_MODE: Clock Mode 
        RXBITS: Receive Bits
        TXBITS: Transmit Bits
        INTER: Interrupt

    Exit:   Outputs all the write registers
            BC and AF corrupt, all other registers preserved

    Notes:  

    Version: 1.0 19/08/23 First version

*/ 
macro DRT_INIT_M CHAN,PARITY,STOP,CLOCK_MODE,RXBITS,TXBITS,INTER

    switch {CHAN}
        case DRT_CHANNEL_A 
            ld bc,DRT_A_CTRL_ADDR
            print "DRT INF INIT CHANNEL A"
            break
        case DRT_CHANNEL_B
            ld bc,DRT_B_CTRL_ADDR 
            print "DRT INF INIT CHANNEL B"
        default
            print "DRT ERR Bad Channel Selected"
    endswitch
    
    ; Reset Channel
    DRT_DEF_WR0_M 0,DRT_WR0_RESET
    ld a,DRT_WR0
    out (c),a

    ; Select WR4
    DRT_DEF_WR0_M 4,DRT_WR0_NULL_COMMAND
    ld a,DRT_WR0
    out (c),a
    
    ; Write to WR4
    DRT_DEF_WR4_M {PARITY},{STOP},{CLOCK_MODE}
    ld a,DRT_WR4
    out (c),a

    ; Select WR3
    DRT_DEF_WR0_M 3,DRT_WR0_NULL_COMMAND
    ld a,DRT_WR0
    out (c),a

    ; Write to WR3
    DRT_DEF_WR3_M {RXBITS}
    ld a,DRT_WR3
    out (c),a

    ; Select WR5
    DRT_DEF_WR0_M 5,DRT_WR0_NULL_COMMAND
    ld a,DRT_WR0
    out (c),a

    ; Write to WR5
    DRT_DEF_WR5_M {TXBITS}
    ld a,DRT_WR5
    out (c),a

    ; Select WR1
    DRT_DEF_WR0_M 1,DRT_WR0_NULL_COMMAND
    ld a,DRT_WR0
    out (c),a

    ; Write to WR1
    DRT_DEF_WR1_M {INTER}
    ld a,DRT_WR1
    out (c),a
    
mend

/*
    Name: DRT_TX_CHAR_M

    Action: Waits for the transmit buffer to be empty and then sends a character

    Entry:  
        CHAN: Channel
        A: Character to send

    Exit:   C Flag =1 if ESC pressed, BC corrupt. All other registers preserved

    Notes:  

    Version: 1.0 19/08/23 First version

*/ 
macro DRT_TX_CHAR_M CHAN

    switch {CHAN}
        case DRT_CHANNEL_A 
            ld bc,DRT_A_CTRL_ADDR
            print "DRT INF TX CHANNEL A"
            break
        case DRT_CHANNEL_B
            ld bc,DRT_B_CTRL_ADDR 
            print "DRT INF TX CHANNEL B"
        default
            print "DRT ERR Bad Channel Selected"
    endswitch

    push af ; Save the chacater to transmit

    @TxBufferStatusLoop:
        push bc             ; Save the address because test key sets C

        ld a,KEY_ESC        ; Test for ESC being pressed
        FWM_KM_TEST_KEY_M
        jp nz,@EscLoop      ; If ESC has been pressed exit 

        pop bc              ; Restore the address
        in a,(c)
        bit DRT_RR0_TX_BUFFER_EMPTY_BIT,a ; Wait for transmit buffer to be empty
        jp z,@TxBufferStatusLoop

    switch {CHAN}
        case DRT_CHANNEL_A 
            ld bc,DRT_A_DATA_ADDR
            print "DRT INF TX CHANNEL A"
            break
        case DRT_CHANNEL_B
            ld bc,DRT_B_DATA_ADDR 
            print "DRT INF TX CHANNEL B"
        default
            print "DRT ERR Bad Channel Selected"
    endswitch

    pop af          ; Restore the character to transmit
    out (c),a       ; Transmit the character
    
    scf
    ccf ; Set C Flag = 0 for no error

    jr @ExitMacro   ; Jump past exit with error

    @EscLoop:
        pop bc
        pop af
        scf ; Set C Flag = 1 for error

    @ExitMacro:
        NOP ; Safe filler
mend

/*
    Name: DRT_RX_CHAR_M

    Action: Waits for an available character and then reads it

    Entry:  
        CHAN: Channel

    Exit:  A=Received char, C Flag =1 if ESC pressed, BC corrupt. All other registers preserved

    Notes:  

    Version: 1.0 19/08/23 First version

*/ 
macro DRT_RX_CHAR_M CHAN

    switch {CHAN}
        case DRT_CHANNEL_A 
            ld bc,DRT_A_CTRL_ADDR
            print "DRT INF TX CHANNEL A"
            break
        case DRT_CHANNEL_B
            ld bc,DRT_B_CTRL_ADDR 
            print "DRT INF TX CHANNEL B"
        default
            print "DRT ERR Bad Channel Selected"
    endswitch

    @RxBufferStatusLoop:
        push bc             ; Save the address because test key sets C

        ld a,KEY_ESC        ;Test for ESC being pressed
        FWM_KM_TEST_KEY_M
        jp nz,@EscLoop      ; If ESC has been pressed exit 

        pop bc ; Restore the address

        in a,(c)
        bit DRT_RR0_RX_CHAR_AVAIL_BIT,a ; Is a character available?
        jp z,@RxBufferStatusLoop


   switch {CHAN}
        case DRT_CHANNEL_A 
            ld bc,DRT_A_DATA_ADDR
            print "DRT INF TX CHANNEL A"
            break
        case DRT_CHANNEL_B
            ld bc,DRT_B_DATA_ADDR 
            print "DRT INF TX CHANNEL B"
        default
            print "DRT ERR Bad Channel Selected"
    endswitch

    in a,(C) ;Read a Char

    scf
    ccf ; Set C Flag = 0 for no error

    jr @ExitMacro   ; Jump past exit with error

    @EscLoop:
        pop bc
        scf ; Set C Flag = 1 for error

    @ExitMacro:
        NOP ; Safe filler
mend