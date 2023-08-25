/*
    Name:  DART RSX Routines

    Action: Simple test of DART with transmit and then receive

    RSX: 
        INITS : Initialises the Serial Link
                Parameters

        LOADS : Loads file from Serial Llink
                Parameters
                    Memory Location to Load file
                    Number of expected bytes in file

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


include "fwmlim01.asm"
include "keylim01.asm"
include "drtlim01.asm"
include "ctclim01.asm"
include "txtlim01.asm"

Init: 
ld hl,WorkSpace
ld bc,JumpTable
call #BCD1 ; Register the RSX routines

WorkSpace: 
DEFB 0,0,0,0 

JumpTable: 
DEFW NameTable
JP InitS ;0 Initialise the Serial Link
JP LoadS ;1 Load from Serial Link

ret

NameTable: 
DEFB "INIT","S"+#80
DEFB "LOAD","S"+#80
DEFB #00


/*
    Name: INITS

    Action: Initialises the Serial Link

    Entry:  
        None

    Exit: 

    Notes:  

    Version: 1.0 19/08/23 First version

*/ 
InitS:
    ;Setup the CTC
    CTC_DEF_ADDR_M #F8E0            ; Base address of CTC
    CTC_DEF_CW_M 1,1,1,0,1,0,1,0    ; Counter, Time Constant to follow, Divide by 16, No interrupts
    CTC_INIT_M 0,12                 ; 9600 BAUD where DART WR4=X16

    ;Setup the DART
    DRT_DEF_ADDR_M #F8F0            ; Base address of DART
    ; 8 BITS, 1 STOP, NO PARITY
    DRT_INIT_M DRT_CHANNEL_A, DRT_WR4_NO_PARITY, DRT_WR4_1_STOP_BIT, DRT_WR4_X16, DRT_WR3_RX_8_BITS, DRT_WR5_TX_8_BITS, DRT_WR1_DISABLE_ALL_INT

    ret

/*
    Name: LOADS

    Action: Reads number of expected bytes from serial link and stores at provided memory location

    Entry:  
        Memory Location
        Number of expected bytes

    Exit: 

    Notes:  

    Version: 1.0 19/08/23 First version

*/ 
LoadS:
    ; set the size of the file
    ld l,(IX+0)
    ld h,(ix+1)
    push hl ; Byte Count on stack

    ; load the address to put the binary program
    ld l,(ix+2)
    ld h,(ix+3)
    push hl ; Memory location on stack

    ld hl,LoadingPrompt
    TXT_OUT_STR_M

    pop hl  ; Restore the memory location
    push hl ; Then put back for safe keeping
    call TXT_OUT_16B_HEX_F ; Print the memory location

    ld hl,Space
    TXT_OUT_STR_M ; Print a space

    GetCharLoop:

        DRT_RX_CHAR_M DRT_CHANNEL_A ;load the char in A
        jp c,Complete ; If C Flag = 1 then error so end

        pop hl,de ;Get the Memory location and Byte count

        ld (hl),a   ;Store the byte in memory
        inc hl      ;Move to next memory location
        
        ;Decrement the byte count 
        dec de
    
        push de,hl ;Save the byte count and memory location

        ; Set the col position to print the byte count after the "LOADING" prompt
        ld a,15  
        FWM_TXT_SET_COLUMN_M
        
        ;Print the Byte Count
        ld hl,de ; put the Byte Count in hl ; RASM special LD HL,DE => LD H,D:LD L,E
        Call TXT_OUT_16B_DEC_F ; Print how many bytes remaining

        pop hl,de ;Restore the variables memory location and byte count
        push de,hl;The put them back again for safe keeping

        ;Check to see if no more bytes need to be loaded
        ld a,d
        or e
        jp nz, GetCharLoop 

    Complete:
    pop hl,de     ;clean up the stack

    ret

include "txtlif01.asm"

LoadingPrompt:
DEFB "LOADING ","&"+#80
Space:
DEFB " "+#80

save 'drtrsx02.bin',#8000,1300,DSK,'dsk\drtrsx02.dsk'

