/*
    Name: Text Function Library

    Action: Provides functions associated with handling text.

    Functions:  TXT_OUT_16B_DEC_F Output a 16 bit number as a 5 character decimal string to the screen
                TXT_OUT_16B_HEX_F Output a 16 bit number as a 4 character hex string to the screen

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

/*
    Name: TXT_OUT_16B_DEC_F

    Action: Output a 16 bit number as a 5 character decimal string to the screen using FWM_TXT_OUTPUT_M

    Entry:  HL contains the binary number to convert
    Exit:   AF,DE,HL are corrupt
            All other registers preserved

    Notes:  Uses Firmware Text Output 

    Version: 1.0 19/08/23 First version
*/
TXT_OUT_16B_DEC_F:
    ld de,10000 
    call @Num1

    ld de,1000 
    call @Num1 
    
    ld de,100 
    call @Num1 
    
    ld de,10 
    call @Num1 
    
    ld de,1

    @Num1 
        xor a 
    @Num2 
        scf
        ccf
        sbc hl,de
        jr  c,@Num3 
        inc a
        jr  @Num2
     @Num3   
        add hl,de
        add a,#30
        FWM_TXT_OUTPUT_M
     ret


/*
    Name: TXT_OUT_16B_HEX_F

    Action: Output a 16 bit number as a 4 character hex string to the screen using FWM_TXT_OUTPUT_M

    Entry:  HL contains the binary number to convert
    Exit:   AF,DE,HL are corrupt
            All other registers preserved

    Notes:  Uses a 8 Bit 2 hex function 

    Version: 1.0 19/08/23 First version
*/
TXT_OUT_16B_HEX_F
    ld a,h
    push hl ;Save L
    
    ;Output the high byte
    call TXT_8B_2_HEX_F
    ld a,h
    FWM_TXT_OUTPUT_M
    ld a,l
    FWM_TXT_OUTPUT_M

    pop hl;Retore L
    ld a,l
   
    ;Output the low byte
    call TXT_8B_2_HEX_F
    ld a,h
    FWM_TXT_OUTPUT_M
    ld a,l
    FWM_TXT_OUTPUT_M

    ret

/*
    Name: TXT_OUT_8B_HEX_F

    Action: Counverts an 8 bit number to hex characters

    Entry:  A contains the binary number to convert
    Exit:   HL contains the hex characters
            AF,DE are corrupt
            All other registers preserved

    Notes:  

    Version: 1.0 19/08/23 First version
*/
TXT_8B_2_HEX_F:
    ld d,a 
    and #F0 
    rrca
    rrca 
    rrca
    rrca
    call Nascii
    ld h,a 
    ld a,d
    and #F 
    call Nascii 
    ld l,a
    ret

Nascii:
    cp 10
    jr c,Nasci
    add a,7

Nasci:
    add a,'0'
    ret 