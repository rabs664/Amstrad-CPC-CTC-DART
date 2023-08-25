/*
    Name:   CTC Macro Library

    Action: Provides macros and definitions associated with the Z80 CTC.

    Macros: CTC_DEF_ADDR_M    ;Defines the adressing for the CTC
            CTC_DEF_CW_M      ;Defines the CTC Control Word
            CTC_INIT_M        ;Initialises the CTC

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
    Name:   CTC Definitions
*/
CTC_C0=#F9E0        ;Channel 0 Address
CTC_C1=CTC_C0+1     ;Channel 1 Address
CTC_C2=CTC_C1+1     ;Channel 2 Address
CTC_C3=CTC_C2+1     ;Channel 3 Address
CTC_CW=#00          ;CTC Control Word

/*
    Name: CTC_DEF_ADDR_M

    Action: Defines the Channel Addresses used by macros

    Entry:  Addr is base adress to use

    Exit:   Sets channel address defintions

    Notes:  

    Version: 1.0 19/08/23 First version

*/
macro CTC_DEF_ADDR_M Addr

    CTC_C0={Addr}         ;Channel 0 Address
    CTC_C1=CTC_C0 + 1     ;Channel 1 Address
    CTC_C2=CTC_C1 + 1     ;Channel 2 Address
    CTC_C3=CTC_C2 + 1     ;Channel 3 Address
    
    print 'CTC C0', {hex4}CTC_C0
    print 'CTC C1', {hex4}CTC_C1
    print 'CTC C2', {hex4}CTC_C2
    print 'CTC C3', {hex4}CTC_C3
mend

/*
    Name: CTC_DEF_ADDR_M

    Action: Defiines the control word for the CTC

    Entry:  
        INTEN    = bit  7 Interrupt             1 = Enabled                                         0 = Disabled
        MODE     = bit  6 Mode                  1 = Counter                                         0 = Timer
        PS*      = bit  5 PreScaler             1 = Divide by 256                                   0 = Divide by 16
        TRIGE    = bit  4 Positive Edge         1 = Postive Edge Starts Timer or Counter            0 = Negative Edge
        TRIG     = bit  3 Trigger               1 = Start on External Trigger                       0 = Start when Time Constant is loaded
        TCF      = bit  2 Time Constant Follows 1 = Next Byte is a Time constant
        CHANRES  = bit  1 Channel Reset         1 = Reset
        CR       = bit  0 Control Register      1 = this is a Control Register Byte

    Exit:   Sets control word definition
            All registers preserved

    Notes:  

    Version: 1.0 19/08/23 First version

*/
macro CTC_DEF_CW_M CR,CHANRES,TCF,TRIG,TRIGE,PS,MODE,INTEN

    CTC_CW = ({INTEN} << 7) + ({MODE} << 6) + ({PS} << 5) + ({TRIGE} << 4) + ({TRIG} << 3) + ({TCF} << 2) + ({CHANRES}  << 1) + {CR}

    print 'CTC CW',{hex2}CTC_CW

    if {CR}==1
        print 'Bit 0 = 1 Control Register Byte'
    endif
    
    if {CHANRES}==1 
        print 'Bit 1 = 1 Channel Reset, Stop Counting and Resume when time Constant is loaded' 
    endif

    if {TCF}==1
        print 'Bit 2 = 1 Time Constant to follow'
    endif
       
    if {TRIG}==1
        print 'Bit 3 = 1 External Trigger'
    else
        print 'Bit 3 = 0 Start as soon as Time Constant is loaded'
    endif
    
    if {TRIGE}==1
        print 'Bit 4 = 1 Use Positive Edge'
    else
        print 'Bit 4 = 0 Use Negative Edge'
    endif

    if {PS}==1
        print 'Bit 5 = 1 Divide by 256'
    else
        print 'Bit 5 = 0 Divide by 16'
    endif

    if {MODE}==1
        print 'Bit 6 = 1 Channel is Counter'
    else
        print 'Bit 6 = 0 Channel is Timer'
    endif
    
    if {INTEN}==1
        print 'Bit 7 = 1 Interrupt Enabled'
    else
        print 'Bit 7 = 0 Interrupt Disabled'
    endif

mend

/*
    Name: CTC_INIT_M

    Action: Initialises the CTC

    Entry:  
        CHAN     = Channel to initisalise
        TC       = Time Contstant

    Exit:   A and BC corrupted. 
            All other registers preserved 

    Notes:  

    Version: 1.0 19/08/23 First version

*/
macro CTC_INIT_M CHAN,TC

    if {CHAN}==0 
        ld bc,CTC_C0
    endif
    if {CHAN}==1
        ld bc,CTC_C1
    endif
    if {CHAN}==2
        ld bc,CTC_C2
    endif
    if {CHAN}==3
        ld bc,CTC_C3
    endif
    
    ld a,CTC_CW
    out (c),a
    
    if {TC}!=0
        ld a,{TC}
        out (c),a
    endif

    print 'Time Constant = ',{hex2}{TC}

mend