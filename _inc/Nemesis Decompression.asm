; ---------------------------------------------------------------------------
; START OF NEMESIS DECOMPRESSOR

; For format explanation see http://info.sonicretro.org/Nemesis_compression
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Nemesis decompression to VRAM
NemDec:
		movem.l	d0-a1/a3-a5,-(sp)
		lea	(NemDec_WriteAndStay).l,a3	; write all data to the same location
		lea	(VDP_data_port).l,a4		; specifically, to the VDP data port
		bra.s	NemDecMain

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Nemesis decompression to RAM
; input: a4 = starting address of destination

NemDecToRAM:
		movem.l	d0-a1/a3-a5,-(sp)
		lea	(NemDec_WriteAndAdvance).l,a3	; advance to the next location after each write

; loc_154C:
NemDecMain:
		lea	(Decomp_Buffer).w,a1
		move.w	(a0)+,d2
		lsl.w	#1,d2
		bcc.s	loc_155A
		adda.w	#$A,a3

loc_155A:
		lsl.w	#2,d2
		movea.w	d2,a5
		moveq	#8,d3
		moveq	#0,d2
		moveq	#0,d4
		bsr.w	NemDecPrepare
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5
		move.w	#$10,d6
		bsr.s	NemDecRun
		movem.l	(sp)+,d0-a1/a3-a5
		rts
; End of function NemDec


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; part of the Nemesis decompressor
; sub_157A:
NemDecRun:
		move.w	d6,d7
		subq.w	#8,d7
		move.w	d5,d1
		lsr.w	d7,d1
		cmpi.b	#$FC,d1
		bcc.s	loc_15C6
		andi.w	#$FF,d1
		add.w	d1,d1
		move.b	(a1,d1.w),d0
		ext.w	d0
		sub.w	d0,d6
		cmpi.w	#9,d6
		bcc.s	loc_15A2
		addq.w	#8,d6
		asl.w	#8,d5
		move.b	(a0)+,d5

loc_15A2:
		move.b	1(a1,d1.w),d1
		move.w	d1,d0
		andi.w	#$F,d1
		andi.w	#$F0,d0

loc_15B0:
		lsr.w	#4,d0

loc_15B2:
		lsl.l	#4,d4
		or.b	d1,d4
		subq.w	#1,d3
		bne.s	NemDec_WriteIter_Part2
		jmp	(a3)		; dynamic jump! to NemDec_WriteAndStay, NemDec_WriteAndAdvance, NemDec_WriteAndStay_XOR, or NemDec_WriteAndAdvance_XOR
; ===========================================================================
; NemDec3:
NemDec_WriteIter:
		moveq	#0,d4
		moveq	#8,d3
; loc_15C0:
NemDec_WriteIter_Part2:
		dbf	d0,loc_15B2
		bra.s	NemDecRun
; ===========================================================================

loc_15C6:
		subq.w	#6,d6
		cmpi.w	#9,d6
		bcc.s	loc_15D4
		addq.w	#8,d6
		asl.w	#8,d5
		move.b	(a0)+,d5

loc_15D4:
		subq.w	#7,d6
		move.w	d5,d1
		lsr.w	d6,d1
		move.w	d1,d0
		andi.w	#$F,d1
		andi.w	#$70,d0
		cmpi.w	#9,d6
		bcc.s	loc_15B0
		addq.w	#8,d6
		asl.w	#8,d5
		move.b	(a0)+,d5
		bra.s	loc_15B0
; End of function NemDecRun

; ===========================================================================

NemDec_WriteAndStay:
		move.l	d4,(a4)
		subq.w	#1,a5
		move.w	a5,d4
		bne.s	NemDec_WriteIter
		rts
; ---------------------------------------------------------------------------

NemDec_WriteAndStay_XOR:
		eor.l	d4,d2
		move.l	d2,(a4)
		subq.w	#1,a5
		move.w	a5,d4
		bne.s	NemDec_WriteIter
		rts
; ===========================================================================

NemDec_WriteAndAdvance:
		move.l	d4,(a4)+
		subq.w	#1,a5
		move.w	a5,d4
		bne.s	NemDec_WriteIter
		rts
; ---------------------------------------------------------------------------

NemDec_WriteAndAdvance_XOR:
		eor.l	d4,d2
		move.l	d2,(a4)+
		subq.w	#1,a5
		move.w	a5,d4
		bne.s	NemDec_WriteIter
		rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Part of the Nemesis decompressor

NemDecPrepare:
		move.b	(a0)+,d0

loc_1620:
		cmpi.b	#$FF,d0
		bne.s	loc_1628
		rts
; ---------------------------------------------------------------------------

loc_1628:
		move.w	d0,d7

loc_162A:
		move.b	(a0)+,d0
		cmpi.b	#$80,d0
		bcc.s	loc_1620
		move.b	d0,d1
		andi.w	#$F,d7
		andi.w	#$70,d1
		or.w	d1,d7
		andi.w	#$F,d0
		move.b	d0,d1
		lsl.w	#8,d1
		or.w	d1,d7
		moveq	#8,d1
		sub.w	d0,d1
		bne.s	loc_1658
		move.b	(a0)+,d0
		add.w	d0,d0
		move.w	d7,(a1,d0.w)
		bra.s	loc_162A
; ---------------------------------------------------------------------------

loc_1658:
		move.b	(a0)+,d0
		lsl.w	d1,d0
		add.w	d0,d0
		moveq	#1,d5
		lsl.w	d1,d5
		subq.w	#1,d5

loc_1664:
		move.w	d7,(a1,d0.w)
		addq.w	#2,d0
		dbf	d5,loc_1664
		bra.s	loc_162A
; End of function NemDecPrepare