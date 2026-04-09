.int:		dc.w .move1-.int
		dc.w .move2-.int
		dc.w .free-.int
; word_A044:
.free:		dc.w 1
		dc.w $F406,    0,    0,   -8
; word_A04E:
.move1:		dc.w 1
		dc.w $FC09,    6,    3,  -$C
; word_A058:
.move2:		dc.w 1
		dc.w $FC09,   $C,    6,  -$C