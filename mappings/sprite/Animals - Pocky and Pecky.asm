.int:		dc.w .move1-.int
		dc.w .move2-.int
		dc.w .free-.int
; word_9FFC:
.free:		dc.w 1
		dc.w $F406,    0,    0,   -8
; word_A006:
.move1:		dc.w 1
		dc.w $F406,    6,    3,   -8
; word_A010:
.move2:		dc.w 1
		dc.w $F406,   $C,    6,   -8