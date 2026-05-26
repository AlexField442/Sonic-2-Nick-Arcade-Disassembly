.int:		dc.w .platform1-.int
		dc.w .platform2-.int
		dc.w .platform2-.int
; word_92FE:
.platform1:	dc.w 8
		dc.w $F00D,    0,    0, -$30
		dc.w	$D,    8,    4, -$30
		dc.w $F005,    4,    2, -$10
		dc.w $F005, $804, $802,	   0
		dc.w	 5,   $C,    6, -$10
		dc.w	 5, $80C, $806,	   0
		dc.w $F00D, $800, $800,	 $10
		dc.w	$D, $808, $804,	 $10
; word_9340:
.platform2:	dc.w $C
		dc.w $F005,    0,    0, -$30
		dc.w $F005,    4,    2, -$20
		dc.w $F005,    4,    2, -$10
		dc.w $F005, $804, $802,	   0
		dc.w $F005, $804, $802,	 $10
		dc.w $F005, $800, $800,	 $20
		dc.w	 5,    8,    4, -$30
		dc.w	 5,   $C,    6, -$20
		dc.w	 5,   $C,    6, -$10
		dc.w	 5, $80C, $806,	   0
		dc.w	 5, $80C, $806,	 $10
		dc.w	 5, $808, $804,	 $20