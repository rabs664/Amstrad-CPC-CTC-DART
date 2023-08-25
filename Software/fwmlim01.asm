/*
    Name:   Firmware Macro Library

    Action: Provides macros and definitions associated with CPC Firmware.

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
010   &BB1E   KM TEST KEY
      Action: Tests if a  particular  key  (or  joystick direction or
              button) is pressed
      Entry:  A contains the key/joystick nurnber
      Exit:   If the requested key  is  pressed,  then Zero is false;
              otherwise Zero is true for  both,  Carry is false A and
              C holds  the  Shift and Control status
              and others are preserved
      Notes:  After calling this, C will hold  the state of shift and
              control - if bit 7 is set then Control was pressed, and
              if bit 5 is set then Shift was pressed

              21/08/23 BB Added preservation of HL as having problems
              where HL looked like it was being corrupted 
*/
macro FWM_KM_TEST_KEY_M
    push hl    
    call #BB1E
    pop hl
mend

/*
030   &BB5A   TXT OUTPUT
      Action: Output a character or control code  (&00 to &1F) to the
              screen
      Entry:  A contains the character to output
      Exit:   All registers are preserved
      Notes:  Any control codes are obeyed  and nothing is printed if
              the VDU is disabled;  characters  are printed using the
              TXT OUT  ACTION  routine;  if  using  graphics printing
              mode, then control codes are printed and not obeyed
*/
macro FWM_TXT_OUTPUT_M
    call #BB5A
mend

/*
037   &BB6F   TXT SET COLUMN
      Action: Sets the cursor's horizontal position
      Entry:  A contains the logical column number to move the cursor
              to
      Exit:   AF and HL are corrupt, and  all the other registers are
              preserved
      Notes:  See also TXT SET CURSOR
*/
macro FWM_TXT_SET_COLUMN_M
        push af
        push hl
        call #BB6F
        pop hl
        pop af
mend