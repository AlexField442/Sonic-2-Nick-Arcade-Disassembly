.int:		dc.w .idle1-.int
		dc.w .idle2-.int
		dc.w .jumping1-.int
		dc.w .jumping2-.int
; word_15D66:
.idle1:		dc.w 1
		dc.w $F00F,    0,    0, -$10
; word_15D70:
.idle2:		dc.w 1
		dc.w $F00F,  $10,    8, -$10
; word_15D7A:
.jumping1:	dc.w 1
		dc.w $F00F,  $20,  $10, -$10
; word_15D84:
.jumping2:	dc.w 1
		dc.w $F00F,  $30,  $18, -$10