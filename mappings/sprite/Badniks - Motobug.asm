.int:		dc.w .move1-.int
		dc.w .move2-.int
		dc.w .move3-.int
		dc.w .smoke1-.int
		dc.w .smoke2-.int
		dc.w .smoke3-.int
		dc.w .blank-.int
; word_F3AA:
.move1:		dc.w 4
		dc.w $F00D,    0,    0, -$14
		dc.w	$C,    8,    4, -$14
		dc.w $F801,   $C,    6,	  $C
		dc.w  $808,   $E,    7,  -$C
; word_F3CC:
.move2:		dc.w 4
		dc.w $F10D,    0,    0, -$14
		dc.w  $10C,    8,    4, -$14
		dc.w $F901,   $C,    6,	  $C
		dc.w  $908,  $11,    8,  -$C
; word_F3EE:
.move3:		dc.w 5	
		dc.w $F00D,    0,    0, -$14
		dc.w	$C,  $14,   $A, -$14
		dc.w $F801,   $C,    6,	  $C
		dc.w  $804,  $18,   $C, -$14
		dc.w  $804,  $12,    9,   -4
; word_F418:
.smoke1:	dc.w 1
		dc.w $FA00,  $1A,   $D,	 $10
; word_F422:
.smoke2:	dc.w 1
		dc.w $FA00,  $1B,   $D,	 $10
; word_F42C:
.smoke3:	dc.w 1
		dc.w $FA00,  $1C,   $E,	 $10
; word_F436:
.blank:		dc.w 0