.int:		dc.w .stand-.int
		dc.w .walk1-.int
		dc.w .walk2-.int
		dc.w .walk3-.int
		dc.w .fire-.int
		dc.w .projectile1-.int
		dc.w .projectile2-.int
; word_A33A:
.stand:		dc.w 4
		dc.w $F009,    0,    0, -$18
		dc.w $F009, $800, $800,	   0
		dc.w	 5,    6,    3, -$10
		dc.w	 5, $806, $803,	   0
; word_A35C:
.walk1:		dc.w 4
		dc.w $F009,   $A,    5, -$18
		dc.w $F009,  $10,    8,	   0
		dc.w	 5,  $16,   $B, -$10
		dc.w	 9,  $1A,   $D,	   0
; word_A37E:
.walk2:		dc.w 4
		dc.w $EC09,    0,    0, -$18
		dc.w $EC09, $800, $800,	   0
		dc.w $FC05, $806, $803,	   0
		dc.w $FC06,  $20,  $10, -$10
; word_A3A0:
.walk3:		dc.w 4
		dc.w $EC09,   $A,    5, -$18
		dc.w $EC09,  $10,    8,	   0
		dc.w $FC09,  $26,  $13,	   0
		dc.w $FC06,  $2C,  $16, -$10
; word_A3C2:
.fire:		dc.w 6
		dc.w $F004,  $32,  $19, -$10
		dc.w $F004, $832, $819,	   0
		dc.w $F809,  $34,  $1A, -$18
		dc.w $F809, $834, $81A,	   0
		dc.w  $804,  $3A,  $1D, -$10
		dc.w  $804, $83A, $81D,	   0
; word_A3F4:
.projectile1:	dc.w 1
		dc.w $F805,  $3C,  $1E,  -8
; word_A3FE:
.projectile2:	dc.w 1
		dc.w $F805,  $40,  $20,  -8