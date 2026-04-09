.int:		dc.w .move1-.int
		dc.w .move2-.int
		dc.w .free-.int
; word_A020:
.free:		dc.w 1
		dc.w $F406,    0,    0,   -8
; word_A02A:
.move1:		dc.w 1
		dc.w $FC05,    6,    3,   -8
; word_A034:
.move2:		dc.w 1
		dc.w $FC05,   $A,    5,   -8