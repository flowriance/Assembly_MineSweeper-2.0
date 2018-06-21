# MineSweeper 2.0
Assembler Game to learn Assembly with 8051.

Functionality is only tested with Simulator, not with real Hardware. 

Used IDE: MCU8051IDE

## Spielkonzept

<img src="https://lh6.googleusercontent.com/WqLQcZFvpoNfw9CroAAxEZW-YxSs1ogLmg7UthbLCTAVPiCO0neAFLljHNp8UZhN39vGHVuNiLWGqlt2iiMA=w2736-h1552" height="400px" />

Das Spielkonzept ist inspiriert durch die Spiele Hit The Frog und Minesweeper. 

Auf dem Minenfeld (Taster 1-9) sind mindestens 3 Bomben versteckt.
Der Spieler muss durch raten versuchen, nur die Felder ohne Bombe zu drücken.

Drückt der Spieler auf eine Bombe hat er verloren und die rote “Loose” LED leuchtet auf. Hat der Spieler alle freien Felder gedrückt hat er gewonnen und die grüne “Win” LED leuchtet. 

Mit dem Knopf Restart Game kann der Spieler ein neues Spiel starten.
