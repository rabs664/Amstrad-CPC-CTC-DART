/*
    Name:  DART Test

    Action: Simple test of DART with transmit and then receive

    Macros: None

    Version:    1.0 19/08/23 First version

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

org #8000

include "drtlim01.asm"
include "ctclim01.asm"
include "txtlim01.asm"
include "fwmlim01.asm"
include "keylim01.asm"

    ;Setup the CTC
    CTC_DEF_ADDR_M #F8E0            ; Base address of CTC
    CTC_DEF_CW_M 1,1,1,0,1,0,1,0    ; Counter, Time Constant to follow, Divide by 16, No interrupts
    CTC_INIT_M 0,12                 ; 9600 BAUD where DART WR4=X16

    ;Setup the DART
    DRT_DEF_ADDR_M #F8F0            ; Base address of DART
    ; 8 BITS, 1 STOP, NO PARITY
    DRT_INIT_M DRT_CHANNEL_A, DRT_WR4_NO_PARITY, DRT_WR4_1_STOP_BIT, DRT_WR4_X16, DRT_WR3_RX_8_BITS, DRT_WR5_TX_8_BITS, DRT_WR1_DISABLE_ALL_INT

    /*

        Transmit test

    */
    
    ld hl,TxStr ; Get the test string to transmit

    TxLoop:
        ld a,(hl)      
        bit 7,a
        jp nz,TxEndLoop ;Is this the last character?

        DRT_TX_CHAR_M DRT_CHANNEL_A ; Transmit the character

        jp c,EndTest ; If C Flag = 1 then error so end test

        inc hl ;Move to next character

        jr TxLoop

    TxEndLoop:
        sbc #80 ;Remove the string terminator
    
        DRT_TX_CHAR_M DRT_CHANNEL_A ; Transmit the character

        jr c,EndTest ; If C Flag = 1 then error so end test
    

    /*

        Receive test

    */
    RxLoop:

        DRT_RX_CHAR_M DRT_CHANNEL_A ; Receive a character

        jp c,EndTest ; If C Flag = 1 then error so end test

        FWM_TXT_OUTPUT_M ; Print the character to screen

        jr RxLoop ; Keep waiting for next character

    EndTest:
        ret

 
    TxStr:
    DEFB "0123456789 ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxy","z"+#80


save 'drttst10.bin',#8000,1300,DSK,'dsk\drttst10.dsk'




