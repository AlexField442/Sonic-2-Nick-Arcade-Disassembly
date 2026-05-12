.int:		dc.w .flying-.int
		dc.w .shooting-.int
		dc.w .unused-.int
		dc.w .flame1-.int
		dc.w .flame2-.int
		dc.w .bullet1-.int
		dc.w .bullet2-.int
; word_16A04:
.flying:	dc.w 2
		dc.w $F809,    0,    0, -$18
		dc.w $F809,    6,    3,	   0
; word_16A16:
.shooting:	dc.w 3
		dc.w $F809,    0,    0, -$18
		dc.w $F805,   $C,    6,	   0
		dc.w  $805,  $10,    8,	   2
; word_16A30:
.unused:	dc.w 3				; This is likely the remnant of a second shooting
		dc.w $F809,    0,    0, -$18	; frame; Tom Payne's archives include a sprite of
		dc.w $F805,   $C,    6,	   0	; the Buzzer with its abdomen expanded.
		dc.w  $805,  $14,   $A,	   2
; word_16A4A:
.flame1:	dc.w 1
		dc.w $F001,  $14,   $A,	   4
; word_16A54:
.flame2:	dc.w 1
		dc.w $F001,  $16,   $B,	   4
; word_16A5E:
.bullet1:	dc.w 1
		dc.w $1001,  $18,   $C,	   9
; word_16A68:
.bullet2:	dc.w 1
		dc.w $1001,  $1A,   $D,	   9