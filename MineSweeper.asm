;--------------------Minigame--------------------
;
; Course: 	Systemnahe Programmierung 1
; Author:	Denny Flämig & Florian Christof
;
	ORG 00H

	MOV A,#00B
	ANL A,#01B
BEGIN:	MOV A,#11111111B 	;// loads A with all 1's
	MOV P0,#00000011B 	;// initializes P0 as output port
	MOV R2,#3D		;// initialize number of free minefields + 1
	MOV R0,#11100011B
	MOV R1,#00000001B
	MOV R3,#11100011B
	MOV R4,#00000001B
; -----------------
; Polling of Matrix-Keypad
;------------------

BACK:	MOV DPTR,#RANDOM_NUMBER ;// moves starting address of RANDOM_NUMBER to DPTR
	MOV P1,#11111111B 	;// loads P1 with all 1's
     	CLR P1.0  		;// makes row 1 low
     	JB P1.4,NEXT1  		;// checks whether column 1 is low and jumps to NEXT1 if not low
	MOV R0, #00000001B
     	ACALL CHECK  		;// calls CHECK subroutine
NEXT1:	INC DPTR
	JB P1.5,NEXT2 		;// checks whether column 2 is low and so on...
	MOV R0, #00000010B
      	ACALL CHECK
NEXT2:	INC DPTR
	JB P1.6,NEXT4
	MOV R0, #00000100B
      	ACALL CHECK
NEXT4:	INC DPTR
	SETB P1.0
      	CLR P1.1
      	JB P1.4,NEXT5
      	MOV R0, #00001000B
      	ACALL CHECK
NEXT5:	INC DPTR
	JB P1.5,NEXT6
	MOV R0, #00010000B
      	ACALL CHECK
NEXT6:	INC DPTR
	JB P1.6,NEXT8
	MOV R0, #00100000B
      	ACALL CHECK
NEXT8:	INC DPTR
	SETB P1.1
      	CLR P1.2
      	JB P1.4,NEXT9
      	MOV R0, #01000000B
      	ACALL CHECK
NEXT9:	INC DPTR
	JB P1.5,NEXT10
	MOV R0, #10000000B
      	ACALL CHECK
NEXT10:	INC DPTR
	JB P1.6,BACK_JUMP
	MOV R1, #00000001B
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
CHECKPLAYERWON:	
	MOV A,R2
	JNZ CHECKBOMB
	JMP WIN

;// Set WIN-LED
WIN:	CLR P0.1
	JMP RESTARTINIT

;// Compare value with database value
CHECKBOMB:	MOV A,#0H
	MOVC A,@A+DPTR
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

ORG 300h
RANDOM_NUMBER:	DB 00000001B ;// Look up table starts here
		DB 0B ;// 0 means no bomb at this field
		DB 0B ;// 1 means bomb
		DB 0B
		DB 0B
     		DB 0B
     		DB 0B
     		DB 0B
    		DB 0B
     END
