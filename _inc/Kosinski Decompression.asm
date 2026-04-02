; ---------------------------------------------------------------------------
; Kosinski Decompression Algorithm
; LZSS/dictionary-based, only function that stores variables on the stack

; ARGUMENTS:
; a0 = source address
; a1 = destination address

; MORE INFO:
; http://info.sonicretro.org/Kosinski_compression
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


KosDec:
		subq.l	#2,sp	; make space for two bytes on the stack
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5	; copy first description field
		moveq	#$F,d4	; copy 16 bits in a byte
; loc_1998:
KosDec_Loop:
		lsr.w	#1,d5	; bit which is shifted out goes into C flag
		move	sr,d6
		dbf	d4,KosDec_ChkBit
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5	; get next descriptor field in neccesary
		moveq	#$F,d4	; reset bit counter
; loc_19AA:
KosDec_ChkBit:
		move	d6,ccr		; was the bit set?
		bcc.s	KosDec_Match	; if not, branch (C flag clear means bit was clear)
		move.b	(a0)+,(a1)+	; otherwise, copy byte as-is
		bra.s	KosDec_Loop
; ===========================================================================
; loc_19B2:
KosDec_Match:
		moveq	#0,d3
		lsr.w	#1,d5	; get next bit
		move	sr,d6
		dbf	d4,KosDec_ChkBit2
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4
; loc_19C6:
KosDec_ChkBit2:
		move	d6,ccr		; was the bit set?
		bcs.s	KosDec_FullMatch; if yes, branch
		lsr.w	#1,d5		; bit which is shifted out goes into X flag
		dbf	d4,loc_19DA
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

loc_19DA:
		roxl.w	#1,d3	; get high repeat count bit (shift X flag in)
		lsr.w	#1,d5
		dbf	d4,loc_19EC
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

loc_19EC:
		roxl.w	#1,d3		; get low repeat count bit
		addq.w	#1,d3		; increment repeat count
		moveq	#-1,d2
		move.b	(a0)+,d2	; calculate offset
		bra.s	KosDec_MatchLoop
; ===========================================================================
; loc_19F6:
KosDec_FullMatch:
		move.b	(a0)+,d0	; get first byte
		move.b	(a0)+,d1	; get second byte
		moveq	#-1,d2
		move.b	d1,d2
		lsl.w	#5,d2
		move.b	d0,d2	; calculate offset
		andi.w	#7,d1	; does a third byte need to be read?
		beq.s	KosDec_FullMatch2	; if it does, branch
		move.b	d1,d3	; copy repeat count
		addq.w	#1,d3	; and increment it
; loc_1A0C:
KosDec_MatchLoop:
		move.b	(a1,d2.w),d0
		move.b	d0,(a1)+	; copy appropriate byte
		dbf	d3,KosDec_MatchLoop	; and repeat the copying
		bra.s	KosDec_Loop
; ===========================================================================
; loc_1A18:
KosDec_FullMatch2:
		move.b	(a0)+,d1
		beq.s	KosDec_Done	; 0 indicates end of compressed data
		cmpi.b	#1,d1
		beq.w	KosDec_Loop	; 1 indicates a new description needs to be read
		move.b	d1,d3		; otherwise, copy repeat count
		bra.s	KosDec_MatchLoop
; ===========================================================================
; loc_1A28:
KosDec_Done:
		addq.l	#2,sp	; restore stack pointer to original state
		rts
; End of function KosDec