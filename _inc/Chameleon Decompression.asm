; ---------------------------------------------------------------------------
; Chameleon Decompression Algorithm
; LZSS/dictionary-based, uses unrolling for fast decompression speeds

; ARGUMENTS (I think...):
; a0 = starting address
; a1 = starting art tile
; a2 = destination address
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


ChaDec:
		moveq	#0,d0
		move.w	#$7FF,d4
		moveq	#0,d5
		moveq	#0,d6
		move.w	a3,d7
		subq.w	#1,d2
		beq.w	loc_1DCC
		subq.w	#1,d2
		beq.w	loc_1D4E
		subq.w	#1,d2
		beq.w	loc_1CD0
		subq.w	#1,d2
		beq.w	loc_1C52
		subq.w	#1,d2
		beq.w	loc_1BD6
		subq.w	#1,d2
		beq.w	loc_1B58
		subq.w	#1,d2
		beq.w	loc_1ADE

loc_1A62:
		move.b	(a0)+,d1
		add.b	d1,d1
		bcs.s	loc_1ADC
		movea.l	a2,a6
		add.b	d1,d1
		bcs.s	loc_1A84
		move.b	(a1)+,d5
		suba.l	d5,a6
		add.b	d1,d1
		bcc.s	loc_1A78
		move.b	(a6)+,(a2)+

loc_1A78:				; CODE XREF: ChaDec+48j
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1ACC
		bra.w	loc_1BD6
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1A84:				; CODE XREF: ChaDec+40j
		lsl.w	#3,d1
		move.w	d1,d6
		and.w	d4,d6
		move.b	(a1)+,d6
		suba.l	d6,a6
		add.b	d1,d1
		bcs.s	loc_1A98
		add.b	d1,d1
		bcs.s	loc_1AAE
		bra.s	loc_1AB0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1A98:				; CODE XREF: ChaDec+64j
		add.b	d1,d1
		bcc.s	loc_1AAC
		moveq	#0,d0
		move.b	(a1)+,d0
		beq.s	loc_1ABE
		subq.w	#6,d0
		bmi.s	loc_1AC4

loc_1AA6:				; CODE XREF: ChaDec+7Cj
		move.b	(a6)+,(a2)+
		dbf	d0,loc_1AA6

loc_1AAC:				; CODE XREF: ChaDec+6Ej
		move.b	(a6)+,(a2)+

loc_1AAE:				; CODE XREF: ChaDec+68j
		move.b	(a6)+,(a2)+

loc_1AB0:				; CODE XREF: ChaDec+6Aj
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1AD4
		bra.w	loc_1DCC
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1ABE:				; CODE XREF: ChaDec+74j
		move.w	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1AC4:				; CODE XREF: ChaDec+78j
		move.w	#$FFFF,d0
		moveq	#1,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1ACC:				; CODE XREF: ChaDec+52j
		move.w	#1,d0
		moveq	#5,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1AD4:				; CODE XREF: ChaDec+8Cj
		move.w	#1,d0
		moveq	#1,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1ADC:				; CODE XREF: ChaDec+3Aj
		move.b	(a1)+,(a2)+

loc_1ADE:				; CODE XREF: ChaDec+32j
					; ChaDec+186j ...
		add.b	d1,d1
		bcs.s	loc_1B56
		movea.l	a2,a6
		add.b	d1,d1
		bcs.s	loc_1AFE
		move.b	(a1)+,d5
		suba.l	d5,a6
		add.b	d1,d1
		bcc.s	loc_1AF2
		move.b	(a6)+,(a2)+

loc_1AF2:				; CODE XREF: ChaDec+C2j
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1B46
		bra.w	loc_1C52
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1AFE:				; CODE XREF: ChaDec+BAj
		lsl.w	#3,d1
		move.w	d1,d6
		and.w	d4,d6
		move.b	(a1)+,d6
		suba.l	d6,a6
		add.b	d1,d1
		bcs.s	loc_1B12
		add.b	d1,d1
		bcs.s	loc_1B28
		bra.s	loc_1B2A
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1B12:				; CODE XREF: ChaDec+DEj
		add.b	d1,d1
		bcc.s	loc_1B26
		moveq	#0,d0
		move.b	(a1)+,d0
		beq.s	loc_1B38
		subq.w	#6,d0
		bmi.s	loc_1B3E

loc_1B20:				; CODE XREF: ChaDec+F6j
		move.b	(a6)+,(a2)+
		dbf	d0,loc_1B20

loc_1B26:				; CODE XREF: ChaDec+E8j
		move.b	(a6)+,(a2)+

loc_1B28:				; CODE XREF: ChaDec+E2j
		move.b	(a6)+,(a2)+

loc_1B2A:				; CODE XREF: ChaDec+E4j
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1B4E
		bra.w	loc_1A62
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1B38:				; CODE XREF: ChaDec+EEj
		move.w	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1B3E:				; CODE XREF: ChaDec+F2j
		move.w	#$FFFF,d0
		moveq	#0,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1B46:				; CODE XREF: ChaDec+CCj
		move.w	#1,d0
		moveq	#4,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1B4E:				; CODE XREF: ChaDec+106j
		move.w	#1,d0
		moveq	#0,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1B56:				; CODE XREF: ChaDec+B4j
		move.b	(a1)+,(a2)+

loc_1B58:				; CODE XREF: ChaDec+2Cj
					; ChaDec+202j ...
		add.b	d1,d1
		bcs.s	loc_1BD4
		movea.l	a2,a6
		add.b	d1,d1
		bcs.s	loc_1B78
		move.b	(a1)+,d5
		suba.l	d5,a6
		add.b	d1,d1
		bcc.s	loc_1B6C
		move.b	(a6)+,(a2)+

loc_1B6C:				; CODE XREF: ChaDec+13Cj
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1BC4
		bra.w	loc_1CD0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1B78:				; CODE XREF: ChaDec+134j
		lsl.w	#3,d1
		move.w	d1,d6
		and.w	d4,d6
		move.b	(a1)+,d6
		suba.l	d6,a6
		add.b	d1,d1
		bcs.s	loc_1B8E
		move.b	(a0)+,d1
		add.b	d1,d1
		bcs.s	loc_1BA6
		bra.s	loc_1BA8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1B8E:				; CODE XREF: ChaDec+158j
		move.b	(a0)+,d1
		add.b	d1,d1
		bcc.s	loc_1BA4
		moveq	#0,d0
		move.b	(a1)+,d0
		beq.s	loc_1BB6
		subq.w	#6,d0
		bmi.s	loc_1BBC

loc_1B9E:				; CODE XREF: ChaDec+174j
		move.b	(a6)+,(a2)+
		dbf	d0,loc_1B9E

loc_1BA4:				; CODE XREF: ChaDec+166j
		move.b	(a6)+,(a2)+

loc_1BA6:				; CODE XREF: ChaDec+15Ej
		move.b	(a6)+,(a2)+

loc_1BA8:				; CODE XREF: ChaDec+160j
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1BCC
		bra.w	loc_1ADE
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1BB6:				; CODE XREF: ChaDec+16Cj
		move.w	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1BBC:				; CODE XREF: ChaDec+170j
		move.w	#$FFFF,d0
		moveq	#7,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1BC4:				; CODE XREF: ChaDec+146j
		move.w	#1,d0
		moveq	#3,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1BCC:				; CODE XREF: ChaDec+184j
		move.w	#1,d0
		moveq	#7,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1BD4:				; CODE XREF: ChaDec+12Ej
		move.b	(a1)+,(a2)+

loc_1BD6:				; CODE XREF: ChaDec+26j
					; ChaDec+54j ...
		add.b	d1,d1
		bcs.s	loc_1C50
		movea.l	a2,a6
		add.b	d1,d1
		bcs.s	loc_1BF6
		move.b	(a1)+,d5
		suba.l	d5,a6
		add.b	d1,d1
		bcc.s	loc_1BEA
		move.b	(a6)+,(a2)+

loc_1BEA:				; CODE XREF: ChaDec+1BAj
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1C40
		bra.w	loc_1D4E
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1BF6:				; CODE XREF: ChaDec+1B2j
		lsl.w	#3,d1
		move.b	(a0)+,d1
		move.w	d1,d6
		and.w	d4,d6
		move.b	(a1)+,d6
		suba.l	d6,a6
		add.b	d1,d1
		bcs.s	loc_1C0C
		add.b	d1,d1
		bcs.s	loc_1C22
		bra.s	loc_1C24
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1C0C:				; CODE XREF: ChaDec+1D8j
		add.b	d1,d1
		bcc.s	loc_1C20
		moveq	#0,d0
		move.b	(a1)+,d0
		beq.s	loc_1C32
		subq.w	#6,d0
		bmi.s	loc_1C38

loc_1C1A:				; CODE XREF: ChaDec+1F0j
		move.b	(a6)+,(a2)+
		dbf	d0,loc_1C1A

loc_1C20:				; CODE XREF: ChaDec+1E2j
		move.b	(a6)+,(a2)+

loc_1C22:				; CODE XREF: ChaDec+1DCj
		move.b	(a6)+,(a2)+

loc_1C24:				; CODE XREF: ChaDec+1DEj
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1C48
		bra.w	loc_1B58
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1C32:				; CODE XREF: ChaDec+1E8j
		move.w	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1C38:				; CODE XREF: ChaDec+1ECj
		move.w	#$FFFF,d0
		moveq	#6,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1C40:				; CODE XREF: ChaDec+1C4j
		move.w	#1,d0
		moveq	#2,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1C48:
		move.w	#1,d0
		moveq	#6,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1C50:
		move.b	(a1)+,(a2)+

loc_1C52:
		add.b	d1,d1
		bcs.s	loc_1CCE
		movea.l	a2,a6
		add.b	d1,d1
		bcs.s	loc_1C72
		move.b	(a1)+,d5
		suba.l	d5,a6
		add.b	d1,d1
		bcc.s	loc_1C66
		move.b	(a6)+,(a2)+

loc_1C66:
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1CBE
		bra.w	loc_1DCC
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1C72:
		lsl.w	#2,d1
		move.b	(a0)+,d1
		add.w	d1,d1
		move.w	d1,d6
		and.w	d4,d6
		move.b	(a1)+,d6
		suba.l	d6,a6
		add.b	d1,d1
		bcs.s	loc_1C8A
		add.b	d1,d1
		bcs.s	loc_1CA0
		bra.s	loc_1CA2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1C8A:
		add.b	d1,d1
		bcc.s	loc_1C9E
		moveq	#0,d0
		move.b	(a1)+,d0
		beq.s	loc_1CB0
		subq.w	#6,d0
		bmi.s	loc_1CB6

loc_1C98:
		move.b	(a6)+,(a2)+
		dbf	d0,loc_1C98

loc_1C9E:
		move.b	(a6)+,(a2)+

loc_1CA0:
		move.b	(a6)+,(a2)+

loc_1CA2:
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1CC6
		bra.w	loc_1BD6
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1CB0:
		move.w	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1CB6:				; CODE XREF: ChaDec+26Aj
		move.w	#$FFFF,d0
		moveq	#5,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1CBE:				; CODE XREF: ChaDec+240j
		move.w	#1,d0
		moveq	#1,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1CC6:				; CODE XREF: ChaDec+27Ej
		move.w	#1,d0
		moveq	#5,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1CCE:				; CODE XREF: ChaDec+228j
		move.b	(a1)+,(a2)+

loc_1CD0:				; CODE XREF: ChaDec+1Aj
					; ChaDec+148j ...
		add.b	d1,d1
		bcs.s	loc_1D4C
		movea.l	a2,a6
		add.b	d1,d1
		bcs.s	loc_1CF0
		move.b	(a1)+,d5
		suba.l	d5,a6
		add.b	d1,d1
		bcc.s	loc_1CE4
		move.b	(a6)+,(a2)+

loc_1CE4:				; CODE XREF: ChaDec+2B4j
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1D3C
		bra.w	loc_1A62
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1CF0:				; CODE XREF: ChaDec+2ACj
		add.w	d1,d1
		move.b	(a0)+,d1
		lsl.w	#2,d1
		move.w	d1,d6
		and.w	d4,d6
		move.b	(a1)+,d6
		suba.l	d6,a6
		add.b	d1,d1
		bcs.s	loc_1D08
		add.b	d1,d1
		bcs.s	loc_1D1E
		bra.s	loc_1D20
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1D08:				; CODE XREF: ChaDec+2D4j
		add.b	d1,d1
		bcc.s	loc_1D1C
		moveq	#0,d0
		move.b	(a1)+,d0
		beq.s	loc_1D2E
		subq.w	#6,d0
		bmi.s	loc_1D34

loc_1D16:				; CODE XREF: ChaDec+2ECj
		move.b	(a6)+,(a2)+
		dbf	d0,loc_1D16

loc_1D1C:				; CODE XREF: ChaDec+2DEj
		move.b	(a6)+,(a2)+

loc_1D1E:				; CODE XREF: ChaDec+2D8j
		move.b	(a6)+,(a2)+

loc_1D20:				; CODE XREF: ChaDec+2DAj
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1D44
		bra.w	loc_1C52
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1D2E:				; CODE XREF: ChaDec+2E4j
		move.w	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1D34:				; CODE XREF: ChaDec+2E8j
		move.w	#$FFFF,d0
		moveq	#4,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1D3C:				; CODE XREF: ChaDec+2BEj
		move.w	#1,d0
		moveq	#8,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1D44:				; CODE XREF: ChaDec+2FCj
		move.w	#1,d0
		moveq	#4,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1D4C:				; CODE XREF: ChaDec+2A6j
		move.b	(a1)+,(a2)+

loc_1D4E:				; CODE XREF: ChaDec+14j
					; ChaDec+1C6j ...
		add.b	d1,d1
		bcs.s	loc_1DCA
		movea.l	a2,a6
		add.b	d1,d1
		bcs.s	loc_1D70
		move.b	(a0)+,d1
		move.b	(a1)+,d5
		suba.l	d5,a6
		add.b	d1,d1
		bcc.s	loc_1D64
		move.b	(a6)+,(a2)+

loc_1D64:				; CODE XREF: ChaDec+334j
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1DBA
		bra.w	loc_1ADE
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1D70:				; CODE XREF: ChaDec+32Aj
		move.b	(a0)+,d1
		lsl.w	#3,d1
		move.w	d1,d6
		and.w	d4,d6
		move.b	(a1)+,d6
		suba.l	d6,a6
		add.b	d1,d1
		bcs.s	loc_1D86
		add.b	d1,d1
		bcs.s	loc_1D9C
		bra.s	loc_1D9E
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1D86:				; CODE XREF: ChaDec+352j
		add.b	d1,d1
		bcc.s	loc_1D9A
		moveq	#0,d0
		move.b	(a1)+,d0
		beq.s	loc_1DAC
		subq.w	#6,d0
		bmi.s	loc_1DB2

loc_1D94:				; CODE XREF: ChaDec+36Aj
		move.b	(a6)+,(a2)+
		dbf	d0,loc_1D94

loc_1D9A:				; CODE XREF: ChaDec+35Cj
		move.b	(a6)+,(a2)+

loc_1D9C:				; CODE XREF: ChaDec+356j
		move.b	(a6)+,(a2)+

loc_1D9E:				; CODE XREF: ChaDec+358j
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1DC2
		bra.w	loc_1CD0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1DAC:				; CODE XREF: ChaDec+362j
		move.w	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1DB2:				; CODE XREF: ChaDec+366j
		move.w	#$FFFF,d0
		moveq	#3,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1DBA:				; CODE XREF: ChaDec+33Ej
		move.w	#1,d0
		moveq	#7,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1DC2:				; CODE XREF: ChaDec+37Aj
		move.w	#1,d0
		moveq	#3,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1DCA:				; CODE XREF: ChaDec+324j
		move.b	(a1)+,(a2)+

loc_1DCC:
		add.b	d1,d1
		bcs.s	loc_1E46
		move.b	(a0)+,d1
		movea.l	a2,a6
		add.b	d1,d1
		bcs.s	loc_1DEE
		move.b	(a1)+,d5
		suba.l	d5,a6
		add.b	d1,d1
		bcc.s	loc_1DE2
		move.b	(a6)+,(a2)+

loc_1DE2:				; CODE XREF: ChaDec+3B2j
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1E36
		bra.w	loc_1B58
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1DEE:				; CODE XREF: ChaDec+3AAj
		lsl.w	#3,d1
		move.w	d1,d6
		and.w	d4,d6
		move.b	(a1)+,d6
		suba.l	d6,a6
		add.b	d1,d1
		bcs.s	loc_1E02
		add.b	d1,d1
		bcs.s	loc_1E18
		bra.s	loc_1E1A
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1E02:				; CODE XREF: ChaDec+3CEj
		add.b	d1,d1
		bcc.s	loc_1E16
		moveq	#0,d0
		move.b	(a1)+,d0
		beq.s	loc_1E28
		subq.w	#6,d0
		bmi.s	loc_1E2E

loc_1E10:				; CODE XREF: ChaDec+3E6j
		move.b	(a6)+,(a2)+
		dbf	d0,loc_1E10

loc_1E16:				; CODE XREF: ChaDec+3D8j
		move.b	(a6)+,(a2)+

loc_1E18:				; CODE XREF: ChaDec+3D2j
		move.b	(a6)+,(a2)+

loc_1E1A:				; CODE XREF: ChaDec+3D4j
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		move.b	(a6)+,(a2)+
		cmp.w	a2,d7
		bls.s	loc_1E3E
		bra.w	loc_1D4E
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1E28:				; CODE XREF: ChaDec+3DEj
		move.w	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1E2E:				; CODE XREF: ChaDec+3E2j
		move.w	#$FFFF,d0
		moveq	#2,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1E36:				; CODE XREF: ChaDec+3BCj
		move.w	#1,d0
		moveq	#6,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1E3E:				; CODE XREF: ChaDec+3F6j
		move.w	#1,d0
		moveq	#2,d2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1E46:				; CODE XREF: ChaDec+3A2j
		move.b	(a1)+,(a2)+
		bra.w	loc_1A62
; End of function ChaDec