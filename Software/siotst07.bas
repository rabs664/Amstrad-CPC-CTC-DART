10 REM SETUP WINDOWS FOR SEND AND RECEIVE TEXT
20 MODE 2
30 WINDOW #1,1,80,2,12:LOCATE 1,1:PRINT "SEND";
40 WINDOW #2,1,80,15,25:LOCATE 1,14:PRINT "RECEIVE";
50 '
60 REM SETUP CTC AT F8E0
70 OUT &F8E0,&X1010111:OUT &F8E0,12:'BAUD RATE 9600
80 '
90 REM SETUP DART AT F8F2
100 OUT &F8F2,&X11000:'Reset Channel 
110 OUT &F8F2,4:OUT &F8F2,&X1000100:'X16 CLOCK MODE,1 STOP,NO PARITY
120 OUT &F8F2,3:OUT &F8F2,&X11000001:'RX 8 BITS,NO FLOW CONTROL,RX ENABLE
130 OUT &F8F2,5:OUT &F8F2,&X1101000:'TX 8 BITS,NO FLOW CONTROL,TX ENABLE
140 OUT &F8F2,1:OUT &F8F2,&X0:'DISABLE INTERRUPTS
150 '
160 REM SETUP WATCH FOR INCOMING CHAR
170 EVERY 1,1 GOSUB 270:'Every 50th of a second look for a incoming char
180 '
190 REM SEND CHAR AT F8F0
200 txchar$=INKEY$:'Read keybaord
210 IF txchar$="" THEN 200:'Nothing to send
220 OUT &F8F0,ASC(txchar$):'Elese something to send
230 PRINT #1,txchar$;:IF txchar$=CHR$(13) THEN PRINT #1,CHR$(10);:'PRINT char sent TO screen
235 IF txchar$=CHR$(13) THEN OUT &F8F0,10
240 GOTO 200:'Go get another char to send
250 '
260 REM WATCH FOR INCOMING CHAR AT F8F0
270 rxstatus=INP(&F8F2):'Is there a char to receive
280 rxready=rxstatus AND 1
290 IF rxready=1 THEN rxchar=INP(&F8F0) ELSE RETURN
300 PRINT #2,CHR$(rxchar);:IF CHR$(rxchar)=CHR$(13) THEN PRINT #2,CHR$(10);:'Print received char
310 GOTO 270:'Quickly go see if there is another char to read

