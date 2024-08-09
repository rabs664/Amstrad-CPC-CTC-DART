10 REM SETUP CTC AT F8E0
20 OUT &F8E0,&X01010111:OUT &F8E0,12:'BAUD RATE 9600
30 REM SETUP DART AT F8F2
40 OUT &F8F2,&X00011000 
50 OUT &F8F2,4:OUT &F8F2,&X01000100:'X16 CLOCK MODE,1 STOP,NO PARITY
60 OUT &F8F2,3:OUT &F8F2,&X11000001:'RX 8 BITS,NO FLOW CONTROL,RX ENABLE
70 OUT &F8F2,5:OUT &F8F2,&X01101000:'TX 8 BITS,NO FLOW CONTROL,TX ENABLE
80 OUT &F8F2,1:OUT &F8F2,&X00000000:'DISABLE INTERRUPTS
90 REM SEND "HELLO WORLD"
100 for i=1 to 11
110 read a$
120 out &F8F0,ASC(a$):'Send Char
130 NEXT
131 out &F8F0,13:out &F8F0,10
140 DATA "H","E","L","L","O"," ","W","O","R","L","D"

