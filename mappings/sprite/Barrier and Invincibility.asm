.int:		dc.w .barrier1-.int
		dc.w .barrier2-.int
		dc.w .barrier3-.int
		dc.w .barrier4-.int
		dc.w .barrier5-.int
		dc.w .barrier6-.int
		dc.w .stars1-.int
		dc.w .stars2-.int
		dc.w .stars3-.int
		dc.w .stars4-.int
; word_12636:
.barrier1:	dc.w 4
		dc.w $F005,    0,    0, -$10
		dc.w $F005, $800, $800,	   0
		dc.w	 5,$1000,$1000, -$10
		dc.w	 5,$1800,$1800,	   0
; word_12658:
.barrier2:	dc.w 4
		dc.w $F005,    4,    2, -$10
		dc.w $F005, $804, $802,	   0
		dc.w	 5,$1004,$1002, -$10
		dc.w	 5,$1804,$1802,	   0
; word_1267A:
.barrier3:	dc.w 4
		dc.w $F005,    8,    4, -$10
		dc.w $F005, $808, $804,	   0
		dc.w	 5,$1008,$1004, -$10
		dc.w	 5,$1808,$1804,	   0
; word_1269C:
.barrier4:	dc.w 4
		dc.w $F005,   $C,    6, -$10
		dc.w $F005, $80C, $806,	   0
		dc.w	 5,$100C,$1006, -$10
		dc.w	 5,$180C,$1806,	   0
; word_126BE:
.barrier5:	dc.w 4
		dc.w $F005,  $10,    8, -$10
		dc.w $F005, $810, $808,	   0
		dc.w	 5,$1010,$1008, -$10
		dc.w	 5,$1810,$1808,	   0
; word_126E0:
.barrier6:	dc.w 4
		dc.w $E00B,  $14,   $A, -$18
		dc.w $E00B, $814, $80A,	   0
		dc.w	$B,$1014,$100A, -$18
		dc.w	$B,$1814,$180A,	   0
; word_12702:
.stars1:	dc.w 4
		dc.w $E80A,    0,    0, -$18
		dc.w $E80A,    9,    4,	   0
		dc.w	$A,$1809,$1804, -$18
		dc.w	$A,$1800,$1800,	   0
; word_12724:
.stars2:	dc.w 4
		dc.w $E80A, $809, $804, -$18
		dc.w $E80A, $800, $800,	   0
		dc.w	$A,$1000,$1000, -$18
		dc.w	$A,$1009,$1004,	   0
; word_12746:
.stars3:	dc.w 4
		dc.w $E80A,  $12,    9, -$18
		dc.w $E80A,  $1B,   $D,	   0
		dc.w	$A,$181B,$180D, -$18
		dc.w	$A,$1812,$1809,	   0
; word_12768:
.stars4:	dc.w 4
		dc.w $E80A, $81B, $80D, -$18
		dc.w $E80A, $812, $809,	   0
		dc.w	$A,$1012,$1009, -$18
		dc.w	$A,$101B,$100D,	   0