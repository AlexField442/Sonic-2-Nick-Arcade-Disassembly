; ---------------------------------------------------------------------------
; Subroutine to calculate arctangent of y/x
; d1 = input x
; d2 = input y
; d0 = output angle (360 degrees == 256)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


CalcAngle:
		movem.l	d3-d4,-(sp)
		moveq	#0,d3
		moveq	#0,d4
		move.w	d1,d3
		move.w	d2,d4
		or.w	d3,d4
		beq.s	CalcAngle_Zero	 ; special case return if x and y are both 0
		move.w	d2,d4
		tst.w	d3		; calculate absolute value of x
		bpl.w	loc_2F68
		neg.w	d3

loc_2F68:
		tst.w	d4		; calculate absolute value of y
		bpl.w	loc_2F70
		neg.w	d4

loc_2F70:
		cmp.w	d3,d4
		bcc.w	loc_2F82
		lsl.l	#8,d4
		divu.w	d3,d4
		moveq	#0,d0
		move.b	AngleData(pc,d4.w),d0
		bra.s	loc_2F8C
; ---------------------------------------------------------------------------

loc_2F82:
		lsl.l	#8,d3
		divu.w	d4,d3
		moveq	#$40,d0
		sub.b	AngleData(pc,d3.w),d0

loc_2F8C:
		tst.w	d1
		bpl.w	loc_2F98
		neg.w	d0
		addi.w	#$80,d0

loc_2F98:
		tst.w	d2
		bpl.w	loc_2FA4
		neg.w	d0
		addi.w	#$100,d0

loc_2FA4:
		movem.l	(sp)+,d3-d4
		rts
; ===========================================================================
; loc_2FAA:
CalcAngle_Zero:
		move.w	#$40,d0
		movem.l	(sp)+,d3-d4
		rts
; End of function CalcAngle

; ===========================================================================
AngleData:	dc.b   0,  0,  0,  0,  1,  1,  1,  1; 0
		dc.b   1,  1,  2,  2,  2,  2,  2,  2; 8
		dc.b   3,  3,  3,  3,  3,  3,  3,  4; 16
		dc.b   4,  4,  4,  4,  4,  5,  5,  5; 24
		dc.b   5,  5,  5,  6,  6,  6,  6,  6; 32
		dc.b   6,  6,  7,  7,  7,  7,  7,  7; 40
		dc.b   8,  8,  8,  8,  8,  8,  8,  9; 48
		dc.b   9,  9,  9,  9,  9, $A, $A, $A; 56
		dc.b  $A, $A, $A, $A, $B, $B, $B, $B; 64
		dc.b  $B, $B, $B, $C, $C, $C, $C, $C; 72
		dc.b  $C, $C, $D, $D, $D, $D, $D, $D; 80
		dc.b  $D, $E, $E, $E, $E, $E, $E, $E; 88
		dc.b  $F, $F, $F, $F, $F, $F, $F,$10; 96
		dc.b $10,$10,$10,$10,$10,$10,$11,$11; 104
		dc.b $11,$11,$11,$11,$11,$11,$12,$12; 112
		dc.b $12,$12,$12,$12,$12,$13,$13,$13; 120
		dc.b $13,$13,$13,$13,$13,$14,$14,$14; 128
		dc.b $14,$14,$14,$14,$14,$15,$15,$15; 136
		dc.b $15,$15,$15,$15,$15,$15,$16,$16; 144
		dc.b $16,$16,$16,$16,$16,$16,$17,$17; 152
		dc.b $17,$17,$17,$17,$17,$17,$17,$18; 160
		dc.b $18,$18,$18,$18,$18,$18,$18,$18; 168
		dc.b $19,$19,$19,$19,$19,$19,$19,$19; 176
		dc.b $19,$19,$1A,$1A,$1A,$1A,$1A,$1A; 184
		dc.b $1A,$1A,$1A,$1B,$1B,$1B,$1B,$1B; 192
		dc.b $1B,$1B,$1B,$1B,$1B,$1C,$1C,$1C; 200
		dc.b $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C; 208
		dc.b $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D; 216
		dc.b $1D,$1D,$1D,$1E,$1E,$1E,$1E,$1E; 224
		dc.b $1E,$1E,$1E,$1E,$1E,$1E,$1F,$1F; 232
		dc.b $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F; 240
		dc.b $1F,$1F,$20,$20,$20,$20,$20,$20; 248
		dc.b $20,  0		; 256
; ===========================================================================
		nop