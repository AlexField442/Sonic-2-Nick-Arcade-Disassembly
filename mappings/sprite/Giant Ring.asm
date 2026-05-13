.int:		dc.w .frame1-.int
		dc.w .frame2-.int
		dc.w .frame3-.int
		dc.w .frame4-.int
; word_AC5E:
.frame1:	dc.w $A
		dc.w $E008,    0,    0, -$18
		dc.w $E008,    3,    1,	   0
		dc.w $E80C,    6,    3, -$20
		dc.w $E80C,   $A,    5,	   0
		dc.w $F007,   $E,    7, -$20
		dc.w $F007,  $16,   $B,	 $10
		dc.w $100C,  $1E,   $F, -$20
		dc.w $100C,  $22,  $11,	   0
		dc.w $1808,  $26,  $13, -$18
		dc.w $1808,  $29,  $14,	   0
; word_ACB0:
.frame2:	dc.w 8
		dc.w $E00C,  $2C,  $16, -$10
		dc.w $E808,  $30,  $18, -$18
		dc.w $E809,  $33,  $19,	   0
		dc.w $F007,  $39,  $1C, -$18
		dc.w $F805,  $41,  $20,	   8
		dc.w  $809,  $45,  $22,	   0
		dc.w $1008,  $4B,  $25, -$18
		dc.w $180C,  $4E,  $27, -$10
; word_ACF2:
.frame3:	dc.w 4
		dc.w $E007,  $52,  $29,  -$C
		dc.w $E003, $852, $829,	   4
		dc.w	 7,  $5A,  $2D,  -$C
		dc.w	 3, $85A, $82D,	   4
; word_AD14:
.frame4:	dc.w 8
		dc.w $E00C, $82C, $816, -$10
		dc.w $E808, $830, $818,	   0
		dc.w $E809, $833, $819, -$18
		dc.w $F007, $839, $81C,	   8
		dc.w $F805, $841, $820, -$18
		dc.w  $809, $845, $822, -$18
		dc.w $1008, $84B, $825,	   0
		dc.w $180C, $84E, $827, -$10