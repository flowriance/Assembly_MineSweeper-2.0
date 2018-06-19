;--------------------Minigame--------------------
;
; Course: 	Systemnahe Programmierung 1
; Author:	Denny Flämig & Florian Christof
;
EQU	GEDRUECKTL, 0x40
EQU	GEDRUECKTH, 0x41
EQU	ZUFZAHLL, 0x42
EQU	ZUFZAHLH, 0x43

	ORG 00H
BEGIN:	MOV P0,#00000011B 	;// initializes P0 as output port
	MOV R2,#3D		;// initialize number of free minefields + 1
	MOV ZUFZAHLL,#11100011B
	MOV ZUFZAHLH,#00000001B
	
; -----------------
; Polling of Matrix-Keypad
;------------------

BACK:	MOV P1,#11111111B 	;// loads P1 with all 1's
     	CLR P1.0  		;// makes row 1 low
     	JB P1.4,NEXT1  		;// checks whether column 1 is low and jumps to NEXT1 if not low
	MOV R1, #00000000B
	MOV R0, #10000000B
     	ACALL CHECK  		;// calls CHECK subroutine
NEXT1:	INC DPTR
	JB P1.5,NEXT2 		;// checks whether column 2 is low and so on...
	MOV R0, #01000000B
      	ACALL CHECK
NEXT2:	INC DPTR
	JB P1.6,NEXT4
	MOV R0, #00100000B
      	ACALL CHECK
NEXT4:	INC DPTR
	SETB P1.0
      	CLR P1.1
      	JB P1.4,NEXT5
      	MOV R0, #00010000B
      	ACALL CHECK
NEXT5:	INC DPTR
	JB P1.5,NEXT6
	MOV R0, #00001000B
      	ACALL CHECK
NEXT6:	INC DPTR
	JB P1.6,NEXT8
	MOV R0, #00000100B
      	ACALL CHECK
NEXT8:	INC DPTR
	SETB P1.1
      	CLR P1.2
      	JB P1.4,NEXT9
      	MOV R0, #00000010B
      	ACALL CHECK
NEXT9:	INC DPTR
	JB P1.5,NEXT10
	MOV R0, #00000001B
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
CHECKPLAYERWON:	MOV A, R1
		JNZ CHECKPLAYERWONREGISTER2
		MOV A,GEDRUECKTL
		ORL A, R0
		MOV R0,A
		CJNE A,GEDRUECKTL, UNPRESSEDL
		JMP BACK
CHECKPLAYERWONREGISTER2:	MOV A,GEDRUECKTH
				ORL A, R1
				MOV R1, A
				CJNE A, GEDRUECKTH, UNPRESSEDH
				JMP BACK
UNPRESSEDH:	MOV A,R1
		ORL A, ZUFZAHLH
		CJNE A, ZUFZAHLH, UNPRESSEDL
		MOV GEDRUECKTL, R1
		JMP Backjump
UNPRESSEDL:	MOV A,R0
		ORL A, ZUFZAHLL
		CJNE A, ZUFZAHLL, BOMB
		MOV GEDRUECKTL, R0
		JMP Backjump
BACKJUMP:	DEC R2
		Mov A,R2
		JZ WIN	
		JMP BACK		
	
;// Set WIN-LED
WIN:	CLR P0.1
	JMP RESTARTINIT

;// Set LOOSE-LED
BOMB: 	CLR P0.0
	JMP RESTARTINIT

;// Restart game
RESTARTINIT:	MOV P1,#11111111B 	;// loads P1 with all 1's
		CLR P1.3  		;// makes row 1 low
RESTART:	JB P1.7,RESTART
		JMP BEGIN_JUMP
     END
