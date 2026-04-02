.int:		dc.w .tiny-.int
		dc.w .huge-.int
		dc.w .blank-.int
		dc.w .small-.int
		dc.w .blank-.int
		dc.w .large-.int
; word_1574E:
.tiny:		dc.w 2
		dc.w $800D,    0,    0, -$20
		dc.w $800D,    0,    0,	   0
; word_15760:
.huge:		dc.w $12
		dc.w $800D,    0,    0, -$20
		dc.w $800D,    0,    0,	   0
		dc.w $800F,    8,    4, -$20
		dc.w $800F,    8,    4,	   0
		dc.w $A00F,    8,    4, -$20
		dc.w $A00F,    8,    4,	   0
		dc.w $C00F,    8,    4, -$20
		dc.w $C00F,    8,    4,	   0
		dc.w $E00F,    8,    4, -$20
		dc.w $E00F,    8,    4,	   0
		dc.w	$F,    8,    4, -$20
		dc.w	$F,    8,    4,	   0
		dc.w $200F,    8,    4, -$20
		dc.w $200F,    8,    4,	   0
		dc.w $400F,    8,    4, -$20
		dc.w $400F,    8,    4,	   0
		dc.w $600F,    8,    4, -$20
		dc.w $600F,    8,    4,	   0
; word_157F2:
.blank:		dc.w 0
; word_157F4:
.small:		dc.w 4
		dc.w $E00F,    8,    4, -$20
		dc.w $E00F,    8,    4,	   0
		dc.w	$F,    8,    4, -$20
		dc.w	$F,    8,    4,	   0
; word_15816:
.large:		dc.w $A
		dc.w $C00F,    8,    4, -$20
		dc.w $C00F,    8,    4,	   0
		dc.w $E00F,    8,    4, -$20
		dc.w $E00F,    8,    4,	   0
		dc.w	$F,    8,    4, -$20
		dc.w	$F,    8,    4,	   0
		dc.w $200F,    8,    4, -$20
		dc.w $200F,    8,    4,	   0
		dc.w $400F,    8,    4, -$20
		dc.w $400F,    8,    4,	   0