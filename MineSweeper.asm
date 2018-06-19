;--------------------Minigame--------------------
;
; Course: 	Systemnahe Programmierung 1
; Author:	Denny Flämig & Florian Christof
;
	ORG 00H
BEGIN:	MOV A,#11111111B 	;// loads A with all 1's
	MOV P0,#00000011B 	;// initializes P0 as output port
	MOV R2,#4D		;// initialize number of free minefields + 1

; -----------------
; Polling of Matrix-Keypad
;------------------

BACK:	MOV DPTR,#RANDOM_NUMBER ;// moves starting address of RANDOM_NUMBER to DPTR
	MOV P1,#11111111B 	;// loads P1 with all 1's
     	CLR P1.0  		;// makes row 1 low
     	JB P1.4,NEXT1  		;// checks whether column 1 is low and jumps to NEXT1 if not low
     	MOV R0,#00000000B   	;// loads a with 0B if column is low (that means key 1 is pressed)
     	ACALL CHECK  		;// calls CHECK subroutine
NEXT1:	INC DPTR
	JB P1.5,NEXT2 		;// checks whether column 2 is low and so on...
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
	JB P1.7,BACK_JUMP
    	MOV R0,#00001111B
       	ACALL CHECK
       	LJMP BACK

; -----------------
; Jump-Points
;------------------

BEGIN_JUMP:	JMP BEGIN
BACK_JUMP:	JMP BACK

; -----------------
; Gamelogic
;------------------

;//Wait until Player leaves the Button
CHECK:	JB P1.4, CHECK1
	JMP CHECK
CHECK1:	JB P1.5, CHECK2
	JMP CHECK1
CHECK2: JB P1.6, CHECK3
	JMP CHECK2
CHECK3:	JB P1.7, CHECKPLAYERWON
	JMP CHECK3

;// CHECK if player found all fields
CHECKPLAYERWON:	MOV A,R2
	JNZ CHECKBOMB
	JMP WIN

;// Set WIN-LED
WIN:	CLR P0.1
	JMP RESTARTINIT

;// Compare value with database value
CHECKBOMB:	MOVX A,@DPTR
	JNZ BOMB
	JMP NOBOMB

;// Set LOOSE-LED
BOMB: 	CLR P0.0
	JMP RESTARTINIT

;// Set pressed field as bomb
NOBOMB:	MOV A, #01B
	MOVX @DPTR, A
	DEC R2
	JMP BACK_JUMP

;// Restart game
RESTARTINIT:	MOV P1,#11111111B 	;// loads P1 with all 1's
		CLR P1.3  		;// makes row 1 low
RESTART:	JB P1.7,RESTART
		JMP BEGIN_JUMP

; -----------------
; Database
;------------------

RANDOM_NUMBER:	DB 0B ;// Look up table starts here
		DB 0B ;// 0 means no bomb at this field
		DB 0B ;// 1 means bomb
		DB 0B
		DB 0B
     		DB 0B
     		DB 0B
     		DB 0B
    		DB 0B
    		DB 0B
    		DB 0B
   		DB 0B
  		DB 0B
  		DB 0B
   		DB 0B
		DB 0B
     END
