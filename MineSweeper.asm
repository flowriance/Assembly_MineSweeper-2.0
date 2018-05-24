ORG 00H
MOV DPTR,#RANDOM_NUMBER ;// moves starting address of LUT to DPTR
MOV A,#11111111B ;// loads A with all 1's
MOV P0,#00000000B ;// initializes P0 as output port

BACK:MOV P1,#11111111B ;// loads P1 with all 1's
     CLR P1.0  ;// makes row 1 low
     JB P1.4,NEXT1  ;// checks whether column 1 is low and jumps to NEXT1 if not low
     MOV R0,#00000000B   ;// loads a with 0B if column is low (that means key 1 is pressed)
     ACALL CHECK  ;// calls DISPLAY subroutine
NEXT1:JB P1.5,NEXT2 ;// checks whether column 2 is low and so on...
     MOV R0,#00000001B  
      ACALL CHECK
NEXT2:JB P1.6,NEXT3 
     MOV R0,#00000010B  
      ACALL CHECK
NEXT3:JB P1.7,NEXT4 
     MOV R0,#00000011B  
      ACALL CHECK
NEXT4:SETB P1.0
      CLR P1.1
      JB P1.4,NEXT5
     MOV R0,#00000100B  
      ACALL CHECK
NEXT5:JB P1.5,NEXT6
     MOV R0,#00000101B  
      ACALL CHECK
NEXT6:JB P1.6,NEXT7
     MOV R0,#00000110B  
      ACALL CHECK
NEXT7:JB P1.7,NEXT8
     MOV R0,#00000111B  
      ACALL CHECK
NEXT8:SETB P1.1
      CLR P1.2
      JB P1.4,NEXT9
     MOV R0,#00001000B
      ACALL CHECK
NEXT9:JB P1.5,NEXT10
     MOV R0,#00001001B
      ACALL CHECK
NEXT10:JB P1.6,NEXT11
     MOV R0,#00001010B
       ACALL CHECK
NEXT11:JB P1.7,NEXT12
     MOV R0,#00001011B
       ACALL CHECK
NEXT12:SETB P1.2
       CLR P1.3
       JB P1.4,NEXT13
     MOV R0,#00001100B
       ACALL CHECK
NEXT13:JB P1.5,NEXT14
     MOV R0,#00001101B
       ACALL CHECK
NEXT14:JB P1.6,NEXT15
     MOV R0,#00001110B
       ACALL CHECK
NEXT15:JB P1.7,BACK
     MOV R0,#00001111B  
       ACALL CHECK
       LJMP BACK

CHECK:
	MOV A,R0
	MOVC A,@A+DPTR
	JNZ BACK
	
	MOV A,R0
	JMP @A+DPTR
	Mov A, #00000001B
	MOVX @DPTR,A
	JMP BOMB
	
BOMB:	
	
	

JUMP1:


RANDOM_NUMBER:	DB 0B ;// Look up table starts here
		DB 0B ;// 0 bei zufallszahl an stelle 2
		DB 0B
		DB 0B
		DB 0B
     		DB 0B
     		DB 0B
     		DB 0B ;// 1 bei zufallszahl an stelle  8
    		DB 0B
    		DB 0B
    		DB 0B
   		DB 0B
  		DB 0B
  		DB 0B
   		DB 0B
		DB 0B
     END