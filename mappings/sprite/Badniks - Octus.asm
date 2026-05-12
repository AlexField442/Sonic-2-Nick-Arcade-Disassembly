.int:		dc.w .jump-.int
		dc.w .sit1-.int
		dc.w .sit2-.int
		dc.w .sit3-.int
		dc.w .angryface-.int
		dc.w .bullet1-.int
		dc.w .bullet2-.int
; word_16CB2:
.jump:		dc.w 2
		dc.w $F00D,    0,    0, -$10
		dc.w	$D,    8,    4, -$10
; word_16CC4:
.sit1:		dc.w 3
		dc.w $F00D,    0,    0, -$10
		dc.w	 9,  $10,    8, -$18
		dc.w	 9,  $16,   $B,	   0
; word_16CDE:
.sit2:		dc.w 3
		dc.w $F00D,    0,    0, -$10
		dc.w	 9,  $1C,   $E, -$18
		dc.w	 9,  $22,  $11,	   0
; word_16CF8:
.sit3:		dc.w 3
		dc.w $F00D,    0,    0, -$10
		dc.w	 9,  $28,  $14, -$18
		dc.w	 9,  $2E,  $17,	   0
; word_16D12:
.angryface:	dc.w 1
		dc.w $F001,  $34,  $1A,   -9
; word_16D1C:
.bullet1:	dc.w 1
		dc.w $F201,  $36,  $1B, -$10
; word_16D26:
.bullet2:	dc.w 1
		dc.w $F201,  $38,  $1C, -$10