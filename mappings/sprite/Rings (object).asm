.int:		dc.w .spin1-.int
		dc.w .spin2-.int
		dc.w .spin3-.int
		dc.w .spin4-.int
		dc.w .sparkle1-.int
		dc.w .sparkle2-.int
		dc.w .sparkle3-.int
		dc.w .sparkle4-.int
		dc.w .blank-.int
; word_AC04:
.spin1:		dc.w 1
		dc.w $F805,    0,    0,   -8
; word_AC0E:
.spin2:		dc.w 1
		dc.w $F805,    4,    2,   -8
; word_AC18:
.spin3:		dc.w 1
		dc.w $F801,    8,    4,   -4
; word_AC22:
.spin4:		dc.w 1
		dc.w $F805, $804, $802,   -8
; word_AC2C:
.sparkle1:	dc.w 1
		dc.w $F805,   $A,    5,   -8
; word_AC36:
.sparkle2:	dc.w 1
		dc.w $F805,$180A,$1805,   -8
; word_AC40:
.sparkle3:	dc.w 1
		dc.w $F805, $80A, $805,   -8
; word_AC4A:
.sparkle4:	dc.w 1
		dc.w $F805,$100A,$1005,   -8
; word_AC54:
.blank:		dc.w 0