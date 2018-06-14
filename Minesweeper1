BEGIN:	ORG 00H
	
	MOV A,#11111111B ;// loads A with all 1's
	MOV P0,#00000000B ;// initializes P0 as output port
	MOV R2,#4D

BACK:	MOV DPTR,#RANDOM_NUMBER ;// moves starting address of LUT to DPTR
	INC R2
	MOV P1,#11111111B ;// loads P1 with all 1's
     	CLR P1.0  ;// makes row 1 low
     	JB P1.4,NEXT1  ;// checks whether column 1 is low and jumps to NEXT1 if not low
     	MOV R0,#00000000B   ;// loads a with 0B if column is low (that means key 1 is pressed)
     	ACALL CHECK  ;// calls DISPLAY subroutine     	
NEXT1:	INC DPTR
	JB P1.5,NEXT2 ;// checks whether column 2 is low and so on...
     	MOV R0,#00000001B  
      	ACALL CHECK
NEXT2:	INC DPTR
	JB P1.6,NEXT3 
	MOV R0,#00000010B  
      	ACALL CHECK
NEXT3:	INC DPTR
	JB P1.7,NEXT4 
     	MOV R0,#00000011B  
      	ACALL CHECK
NEXT4:	INC DPTR
SETB P1.0
      	CLR P1.1
      	JB P1.4,NEXT5
     	MOV R0,#00000100B  
      	ACALL CHECK
      	
NEXT5:	INC DPTR
	JB P1.5,NEXT6
     	MOV R0,#00000101B  
      	ACALL CHECK
      	
NEXT6:	INC DPTR
JB P1.6,NEXT7
     	MOV R0,#00000110B  
      	ACALL CHECK
      	
NEXT7:	JB P1.7,NEXT8
     	MOV R0,#00000111B  
      	ACALL CHECK
NEXT8:	INC DPTR
	SETB P1.1
      	CLR P1.2
      	JB P1.4,NEXT9
     	MOV R0,#00001000B
      	ACALL CHECK
      	
NEXT9:	INC DPTR
	JB P1.5,NEXT10
     	MOV R0,#00001001B
      	ACALL CHECK
      	
NEXT10:	INC DPTR
	JB P1.6,NEXT11
     	MOV R0,#00001010B
       	ACALL CHECK
       	
NEXT11:	INC DPTR
	JB P1.7,NEXT12
     	MOV R0,#00001011B
       	ACALL CHECK
       	
NEXT12:	INC DPTR
SETB P1.2
       	CLR P1.3
       	JB P1.4,NEXT13
     	MOV R0,#00001100B
       	ACALL CHECK
       
NEXT13:	INC DPTR
JB P1.5,NEXT14
     	MOV R0,#00001101B
       	ACALL CHECK
       	
NEXT14:	INC DPTR
JB P1.6,NEXT15
     	MOV R0,#00001110B
       	ACALL CHECK
       	
NEXT15:	INC DPTR
JB P1.7,INTERMEDIATE_BACK2
    	MOV R0,#00001111B
       	ACALL CHECK
       	LJMP BACK
INTERMEDIATE_BACK2: JMP BACK
INTERMEDIATE_BACK: 
MOV A,#0B	;//Gedrücktes Feld zur Bombe machen, damit der 
	MOVX @DPTR,A	;//Counter nicht ausgetrickst werden kann.
JMP BACK  ;//Sprung, da JNZ nicht weit genug springen kann

CHECK:	MOV A,R2
	JNZ CHECK1
	JMP WIN
CHECK1:	MOVX A,@DPTR
	JNZ INTERMEDIATE_BACK
	;MOV A, #00000001B
	;MOVX @DPTR,A
	JMP BOMB
BOMB:	MOV P0,#10001000B
	;MOV A,#11111111B
	CLR P1.3
LOOP:	JB P1.7, LOOP
	MOV DPTR,#RANDOM_NUMBER ;// moves starting address of LUT to DPTR
	MOV A,#11111111B ;// loads A with all 1's
	MOV P0,#00000000B ;// initializes P0 as output port
	MOV R2,#4D
	JMP BACK
WIN:	MOV P0,#00010001B
	;MOV A,#11111111B
	JMP LOOP


RANDOM_NUMBER:	DB 1B ;// Look up table starts here
		DB 1B ;// 0 bei zufallszahl an stelle 2
		DB 1B
		DB 1B
		DB 1B
     		DB 1B
     		DB 1B
     		DB 1B ;// 1 bei zufallszahl an stelle  8
    		DB 1B
    		DB 1B
    		DB 1B
   		DB 1B
  		DB 1B
  		DB 1B
   		DB 1B
		DB 1B
     END
