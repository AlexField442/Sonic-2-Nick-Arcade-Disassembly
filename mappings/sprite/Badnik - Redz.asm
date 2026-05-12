.int:		dc.w .walk1-.int
		dc.w .walk2-.int
		dc.w .walk3-.int
; word_15EC8:
.walk1:		dc.w 1
		dc.w $F00F,    0,    0, -$10
; word_15ED2:
.walk2:		dc.w 1
		dc.w $F00F,  $10,    8, -$10
; word_15EDC:
.walk3:		dc.w 1
		dc.w $F00F,  $20,  $10, -$10