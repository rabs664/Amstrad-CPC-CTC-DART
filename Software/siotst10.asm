/*
    Name:  Serial IO Test

    Action: Simple test of Serial IO

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

    ; Initialise the Serial Link
    call SIO_Init_F


    /*
        Test 1 Put Char
    */
    Test1:

    ld hl,Test1HeaderStr
    call Print_Line_F

    ld hl,PressAnyKey
    call Print_Line_F
    call #BB18 ; Wait for a key

    ld e,'X'
    call SIO_Put_Char_F



    /*
        Test 2 Put Sting
    */
    Test2:

    ld hl,Test2HeaderStr
    call Print_Line_F

    ld hl,PressAnyKey
    call Print_Line_F
    call #BB18 ; Wait for a key

    ld hl,Test2Str
    call SIO_Put_Str_F


    /*
        Test 3 Put Line
    */
    Test3:

    ld hl,Test3HeaderStr
    call Print_Line_F

    ld hl,PressAnyKey
    call Print_Line_F
    call #BB18 ; Wait for a key

    ld hl,Test3Str
    call SIO_Put_Line_F



    /*
        Test 4 Get Get Char
    */
    Test4:

    ld hl,Test4HeaderStr
    call Print_Line_F

    ld hl,PressAnyKey
    call Print_Line_F
    call #BB18 ; Wait for a key

    call SIO_Get_Char_F
    add a,#80 ; terminate the char

    ld hl,Test4Char
    ld (hl),a
    call Print_Line_F


    /*
        Test 5 Get Line
    */
    Test5:

    ld hl,Test5HeaderStr ; HL points at the Test Sting 5 Buffer
    call Print_Line_F

    ld hl,PressAnyKey
    call Print_Line_F
    call #BB18 ; Wait for a key

    ld hl,Test5Str ; Set loacation to put string
    call SIO_GET_LINE_F
    jp c,EndTest ; Check for EC

    ld hl,Test5Str ; Rest pointer to start of string

    .PrintLoop:
        ld a,(hl)

        call #BB5A ; Output Char to screen

        inc hl ; move to next char memory address
        dec de ; decrement number of chars printed

        ld a,d ; Test if DE is 0
        or e

    jp nz, .PrintLoop ; More to print

    ld hl,NewLine
    call Print_Line_F ; 


    /*
        Test 6 Get Bin
    */
    Test6:
    ld hl,Test6HeaderStr ; HL points at the Test Sting 5 Buffer
    call Print_Line_F

    ld hl,PressAnyKey
    call Print_Line_F
    call #BB18 ; Wait for a key

    ld hl,Test6Data ; HL points at the Test 6 Buffer
    ld de,10        ; DE Holds number of Bytes to get

    call SIO_GET_BIN_F
    jp c,EndTest ; Check for EC

    ld hl,Test6Data ; Restore the data pointer
    ld de,10        ; Reset number of bytes

    .PrintLoop:
        ld a,(hl)

        push hl ; save memory pointer
        
        call Print_Hex_F

        pop hl ; restore memory pointer

        inc hl ; move to next char memory address
        dec de ; decrement number of chars printed

        ld a,d ; Test if DE is 0
        or e

    jp nz, .PrintLoop ; More to print


EndTest:
ret
    
/*
    Data Buffers
*/
Test1HeaderStr:
DEFB "TEST 1 PUT CHAR, Should See X on Termina","l"+#80

Test2HeaderStr:
DEFB "TEST 2 PUT STRING, Should see Hello Word on Termina","l"+#80

Test3HeaderStr:
DEFB "TEST 3 PUT LINE, Should see Hello Again on Termina","l"+#80

Test4HeaderStr:
DEFB "TEST 4 GET CHAR, Press a key on Termnial, Check CPC scree","n"+#80

Test5HeaderStr:
DEFB "TEST 5 GET LINE, Type a String on Terminal and press ENTER, Check CPC scree","n"+#80

Test6HeaderStr:
DEFB "TEST 6 GET BIN, Enter 10 Characters on Terminal, Check CPC scree","n"+#80


Test2Str:
DEFB "HELLO WORL","D"+#80

Test3Str:
DEFB "HELLO AGAI","N"+#80

Test4Char:
DEFB " "

Test5Str:
DEFB "                                                                                                                   ",+#80

Test6Data:
DEFB "                                                                                                                   "

PressAnyKey:
DEFB "Press Any Key to Start Tes","t"+#80

NewLine:
DEFB " ",#80

/*
    Includes

*/
include "siolif01.asm"



/*
    Functions
*/

/*
    Name: Print_Line_F

    Action: Prints a Line of text, terminated with +#80 and prints CRLF

    Entry:  
        HL Address of where to place data

    Exit:  

*/ 
Print_Line_F:

   .Loop:
        ; Check for last char
        ld a,(hl)      
        bit 7,a
        jp nz,.LastChar

        ; Output Char to screen
        call #BB5A

        ;Move to next char
        inc hl

    jr .Loop

    ;Last Char to Output
    .LastChar:
        sbc #80 ;Remove the string terminator
        
        ; Output Char to screen
        call #BB5A

    ;Put Line Feed and Carriage Return
    ld a, #0D ; CR
    call #BB5A

    ld a, #0A ; LF
    call #BB5A

ret

/*
    Name: Print_Hex_F

    Action: Prints a byte as hex, followed by a space

    Entry:  
        A holds byte to print

    Exit:  

*/ 
Print_Hex_F:
    ld b,a 
    and #F0 
    rrca
    rrca 
    rrca
    rrca
    call Nascii
    ld h,a 
    ld a,b
    and #F 
    call Nascii 
    ld l,a

    ld a,h
    call #BB5A ; Output High Byte to screen

    ld a,l
    call #BB5A ; Output Low Byte to screen

    ld a, " "
    call #BB5A ; Output space to screen

    ret

Nascii:
    cp 10
    jr c,Nasi
    add a,7

Nasi:
    add a,'0'
    ret  



.EndTest:
ret

save 'siotst10.bin',#8000,1300,DSK,'siotst10.dsk'