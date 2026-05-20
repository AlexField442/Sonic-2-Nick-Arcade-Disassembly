.int:		dc.w .normal-.int
		dc.w .hit1-.int
		dc.w .hit2-.int
; word_13998:
.normal:	dc.w 2
		dc.w $F007,    0,    0, -$10
		dc.w $F007, $800, $800,	   0
; word_139AA:
.hit1:		dc.w 2
		dc.w $F406,    8,    4,  -$C
		dc.w $F402, $808, $804,	   4
; word_139BC:
.hit2:		dc.w 2
		dc.w $F007,   $E,    7, -$10
		dc.w $F007, $80E, $807,	   0