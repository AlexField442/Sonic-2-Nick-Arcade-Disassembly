.int:		dc.w .lift-.int
		dc.w .leftPole-.int
		dc.w .rightPole-.int
		dc.w .brokenVines-.int
; word_151DA:
.lift:		dc.w $A
		dc.w $C105,    0,    0, -$1C
		dc.w $D003,    4,    2, -$1A
		dc.w $F003,    4,    2, -$1A
		dc.w $1001,    8,    4, -$19
		dc.w $D505,   $A,    5,	  $C
		dc.w $E003,   $E,    7,	 $11
		dc.w $1001,  $12,    9,	 $11
		dc.w	 3,   $E,    7,	 $11
		dc.w $200D,  $14,   $A, -$20
		dc.w $200D, $814, $80A,	   0
; word_1522C:
.leftPole:	dc.w 3
		dc.w $D805,  $1C,   $E, -8
		dc.w $E807,  $20,  $10, -8
		dc.w  $807,  $20,  $10, -8
; word_15246:
.rightPole:	dc.w 3
		dc.w $D805,  $28,  $14, -8
		dc.w $E807, $820, $810, -8
		dc.w  $807, $820, $810, -8
; word_15260:
.brokenVines:	dc.w 8
		dc.w $C905,    0,    0, -$1C
		dc.w $D803,    4,    2, -$1A
		dc.w $F803,    4,    2, -$1A
		dc.w $1801,  $2C,  $16, -$1A
		dc.w $DD05,   $A,    5,	  $C
		dc.w $E803,   $E,    7,	 $11
		dc.w $2001,  $2E,  $17,	 $11
		dc.w  $803,   $E,    7,	 $11