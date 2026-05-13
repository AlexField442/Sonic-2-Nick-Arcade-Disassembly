.int:		dc.w .frame1-.int
		dc.w .frame2-.int
		dc.w .frame3-.int
		dc.w .frame4-.int
		dc.w .frame5-.int
		dc.w .frame6-.int
		dc.w .frame7-.int
		dc.w .frame8-.int
; word_AD66:
.frame1:	dc.w 2
		dc.w $E00F,    0,    0,	   0
		dc.w	$F,$1000,$1000,	   0
; word_AD78:
.frame2:	dc.w 4
		dc.w $E00F,  $10,    8, -$10
		dc.w $E007,  $20,  $10,	 $10
		dc.w	$F,$1010,$1008, -$10
		dc.w	 7,$1020,$1010,	 $10
; word_AD9A:
.frame3:	dc.w 4
		dc.w $E00F,  $28,  $14, -$18
		dc.w $E00B,  $38,  $1C,	   8
		dc.w	$F,$1028,$1014, -$18
		dc.w	$B,$1038,$101C,	   8
; word_ADBC:
.frame4:	dc.w 4
		dc.w $E00F, $834, $81A, -$20
		dc.w $E00F,  $34,  $1A,	   0
		dc.w	$F,$1834,$181A, -$20
		dc.w	$F,$1034,$101A,	   0
; word_ADDE:
.frame5:	dc.w 4
		dc.w $E00B, $838, $81C, -$20
		dc.w $E00F, $828, $814,   -8
		dc.w	$B,$1838,$181C, -$20
		dc.w	$F,$1828,$1814,   -8
; word_AE00:
.frame6:	dc.w 4
		dc.w $E007, $820, $810, -$20
		dc.w $E00F, $810, $808, -$10
		dc.w	 7,$1820,$1810, -$20
		dc.w	$F,$1810,$1808, -$10
; word_AE22:
.frame7:	dc.w 2
		dc.w $E00F, $800, $800, -$20
		dc.w	$F,$1800,$1800, -$20
; word_AE34:
.frame8:	dc.w 4
		dc.w $E00F,  $44,  $22, -$20
		dc.w $E00F, $844, $822,	   0
		dc.w	$F,$1044,$1022, -$20
		dc.w	$F,$1844,$1822,	   0