.int:		dc.w .seahorseidle-.int
		dc.w .wing1-.int
		dc.w .wing2-.int
		dc.w .seahorsemad1-.int
		dc.w .seahorsemad2-.int
		dc.w .bullet1-.int
		dc.w .bullet2-.int
		dc.w .bullet3-.int
		dc.w .oilspurt-.int
		dc.w .skyhorseidle1-.int
		dc.w .skyhorseidle2-.int
		dc.w .skyhorsemad1-.int
		dc.w .skyhorsemad2-.int
; word_163F2:
.seahorseidle:	dc.w 3
		dc.w $E80D,    0,    0, -$10
		dc.w $F809,  $16,   $B,   -8
		dc.w  $805,  $24,  $12,   -8
; word_1640C:
.wing1:		dc.w 1
		dc.w $F805,  $28,  $14,   -8
; word_16416:
.wing2:		dc.w 1
		dc.w $F805,  $2C,  $16,   -8
; word_16420:
.seahorsemad1:	dc.w 4
		dc.w $E809,    8,    4, -$10
		dc.w $E801,   $E,    7,	   8
		dc.w $F809,  $16,   $B,   -8
		dc.w  $805,  $24,  $12,   -8
; word_16442:
.seahorsemad2:	dc.w 4
		dc.w $E809,  $10,    8, -$10
		dc.w $E801,   $E,    7,	   8
		dc.w $F809,  $16,   $B,   -8
		dc.w  $805,  $24,  $12,   -8
; word_16464:
.bullet1:	dc.w 1
		dc.w $F801,  $30,  $18,   -4
; word_1646E:
.bullet2:	dc.w 1
		dc.w $F801,  $32,  $19,   -4
; word_16478:
.bullet3:	dc.w 1
		dc.w $F801,  $34,  $1A,   -4
; word_16482:
.oilspurt:	dc.w 1
		dc.w $F80D,  $36,  $1B, -$10
; word_1648C:
.skyhorseidle1:	dc.w 4
		dc.w $E80D,    0,    0, -$10
		dc.w $F805,  $1C,   $E,   -8
		dc.w $F801,  $20,  $10,	   8
		dc.w  $805,  $24,  $12,   -8
; word_164AE:
.skyhorseidle2:	dc.w 4
		dc.w $E80D,    0,    0, -$10
		dc.w $F805,  $1C,   $E,   -8
		dc.w $F801,  $22,  $11,	   8
		dc.w  $805,  $24,  $12,   -8
; word_164D0:
.skyhorsemad1:	dc.w 5
		dc.w $E809,    8,    4, -$10
		dc.w $E801,   $E,    7,	   8
		dc.w $F805,  $1C,   $E,   -8
		dc.w $F801,  $20,  $10,	   8
		dc.w  $805,  $24,  $12,   -8
; word_164FA:
.skyhorsemad2:	dc.w 5
		dc.w $E809,  $10,    8, -$10
		dc.w $E801,   $E,    7,	   8
		dc.w $F805,  $1C,   $E,   -8
		dc.w $F801,  $22,  $11,	   8
		dc.w  $805,  $24,  $12,   -8