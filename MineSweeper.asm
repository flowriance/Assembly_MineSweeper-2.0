;--------------------Minigame--------------------
;
; Course: 	Systemnahe Programmierung 1
; Author:	Denny Flämig & Florian Christof
;

ZUF8R 		EQU 0x20
GEDRUECKTL 	EQU 0x40
GEDRUECKTH 	EQU 0x41
ZUFZAHLL 	EQU 0x42
ZUFZAHLH 	EQU 0x43

	ORG 00H
BEGIN:	call ZUFALL 
	MOV ZUFZAHLL,A
	call ZUFALL 
	ANL A, #00000001B
	MOV ZUFZAHLH,A
	MOV P0,#11111111B 	;// initializes P0 as output port
	MOV R2,#3D		;// initialize number of free minefields - 1

; -----------------
; Polling of Matrix-Keypad
;------------------

BACK:	MOV P1,#11111111B 	;// loads P1 with all 1's
	MOV R1, #00000000B
     	CLR P1.0  		;// makes row 1 low
     	JB P1.4,NEXT1  		;// checks whether column 1 is low and jumps to NEXT1 if not low
	MOV R0, #10000000B
     	JMP CHECK  		;// calls CHECK subroutine
NEXT1:	JB P1.5,NEXT2 		;// checks whether column 2 is low and so on...
	MOV R0, #01000000B
      	JMP CHECK
NEXT2:	JB P1.6,NEXT4
	MOV R0, #00100000B
      	JMP CHECK
NEXT4:	SETB P1.0
      	CLR P1.1
      	JB P1.4,NEXT5
      	MOV R0, #00010000B
      	JMP CHECK
NEXT5:	JB P1.5,NEXT6
	MOV R0, #00001000B
      	JMP CHECK
NEXT6:	JB P1.6,NEXT8
	MOV R0, #00000100B
      	JMP CHECK
NEXT8:	SETB P1.1
      	CLR P1.2
      	JB P1.4,NEXT9
      	MOV R0, #00000010B
      	JMP CHECK
NEXT9:	JB P1.5,NEXT10
	MOV R0, #00000001B
      	JMP CHECK
NEXT10:	JB P1.6,BACK
	MOV R1, #00000001B
       	JMP CHECK
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

;// CHECK if player has pressed the button before
;// 
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
				
;// Unpressed - Executed if the button is pressed for the first time
;// ((ZufZahl || R1) == ZufZahl)
UNPRESSEDH:	MOV A,R1
		ORL A, ZUFZAHLH
		CJNE A, ZUFZAHLH, BOMB
		MOV GEDRUECKTL, R1
		JMP COUNTER
UNPRESSEDL:	MOV A,R0
		ORL A, ZUFZAHLL
		CJNE A, ZUFZAHLL, BOMB
		MOV GEDRUECKTL, R0
		JMP COUNTER

;// Decrease and Compare Counter
COUNTER:	DEC R2
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
RESTARTINIT:	Mov GEDRUECKTH, #0H
		Mov GEDRUECKTL, #0H
		MOV P1,#11111111B 	;// loads P1 with all 1's
		CLR P1.3  		;// makes row 1 low
RESTART:	JB P1.7,RESTART
		JMP BEGIN_JUMP

; ------ Zufallszahlengenerator-----------------
ZUFALL:	mov	A, ZUF8R   ; initialisiere A mit ZUF8R
	jnz	ZUB
	cpl	A
	mov	ZUF8R, A
ZUB:	anl	a, #10111000b
	mov	C, P
	mov	A, ZUF8R
	rlc	A
	mov	ZUF8R, A
	ret
END
