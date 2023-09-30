/*
    Name:   Text Macro Library

    Action: Provides macros and definitions associated with handling text.

    Macros: TXT_PRT_STR_M Outputs a string to the screen

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
    Name:   Control Characters
*/
TXT_BEL=#07 ; Sound Bleeper
TXT_LF=#0A  ; Move cursor down one line
TXT_CR=#0D  ; Move cursor to the left edge of the window on current line

/*
    Name: TXT_OUT_STR_M

    Action: Output a string to the screen using FWM_TXT_OUTPUT_M

    Entry:  HL contains the address of the string to output terminated by +#80

    Exit:   AF corrupt, HL contains the address of the last character in the string
            All other registers preserved

    Notes:  Uses Firmware Text Output 
            String must be terminated with +#80

    Version: 1.0 19/08/23 First version

*/
macro TXT_OUT_STR_M

    @Loop:
        ld a,(hl)      
        bit 7,a
        jr nz,@EndLoop ;Is this the last character?

        FWM_TXT_OUTPUT_M

        inc hl ;Move to next character
        jr @Loop
    @EndLoop:
        sbc #80 ;Remove the string terminator
        FWM_TXT_OUTPUT_M
    
mend