.int:		dc.w .blank-.int
		dc.w .pressstart-.int
		dc.w .spritemask-.int
		dc.w .tm-.int
; word_B536:
.blank:		dc.w 0
; word_B538:
.pressstart:	dc.w 6
		dc.w	$C,  $F0,  $78,	   0
		dc.w	 0,  $F3,  $79,	 $20
		dc.w	 0,  $F3,  $79,	 $30
		dc.w	$C,  $F4,  $7A,	 $38
		dc.w	 8,  $F8,  $7C,	 $60
		dc.w	 8,  $FB,  $7D,	 $78
; word_B56A:
.spritemask:	dc.w $1E
		dc.w $B80F,    0,    0, -$80
		dc.w $B80F,    0,    0, -$80
		dc.w $B80F,    0,    0, -$80
		dc.w $B80F,    0,    0, -$80
		dc.w $B80F,    0,    0, -$80
		dc.w $B80F,    0,    0, -$80
		dc.w $B80F,    0,    0, -$80
		dc.w $B80F,    0,    0, -$80
		dc.w $B80F,    0,    0, -$80
		dc.w $B80F,    0,    0, -$80
		dc.w $D80F,    0,    0, -$80
		dc.w $D80F,    0,    0, -$80
		dc.w $D80F,    0,    0, -$80
		dc.w $D80F,    0,    0, -$80
		dc.w $D80F,    0,    0, -$80
		dc.w $D80F,    0,    0, -$80
		dc.w $D80F,    0,    0, -$80
		dc.w $D80F,    0,    0, -$80
		dc.w $D80F,    0,    0, -$80
		dc.w $D80F,    0,    0, -$80
		dc.w $F80F,    0,    0, -$80
		dc.w $F80F,    0,    0, -$80
		dc.w $F80F,    0,    0, -$80
		dc.w $F80F,    0,    0, -$80
		dc.w $F80F,    0,    0, -$80
		dc.w $F80F,    0,    0, -$80
		dc.w $F80F,    0,    0, -$80
		dc.w $F80F,    0,    0, -$80
		dc.w $F80F,    0,    0, -$80
		dc.w $F80F,    0,    0, -$80
; word_B65C:
.tm:		dc.w 1
		dc.w $FC04,    0,    0,   -8