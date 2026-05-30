; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load pattern load cues (aka to queue pattern load requests)
;
; d0 = index of PLC list (see ArtLoadCues)
;
; This is technically designed for 16 slots per cue, but due to an oversight,
; only 15 slots can actually be used.
; ---------------------------------------------------------------------------
; sub_1670: PLCLoad:
LoadPLC:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		lea	(Plc_Buffer).w,a2

loc_1688:
		tst.l	(a2)
		beq.s	loc_1690
		addq.w	#6,a2
		bra.s	loc_1688
; ---------------------------------------------------------------------------

loc_1690:
		move.w	(a1)+,d0
		bmi.s	loc_169C

loc_1694:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		dbf	d0,loc_1694

loc_169C:
		movem.l	(sp)+,a1-a2
		rts
; End of function LoadPLC

; ---------------------------------------------------------------------------
; Subroutine to load pattern load cues while also clearing the PLC first
;
; d0 = index of PLC list
; ---------------------------------------------------------------------------
; sub_16A2: PLCLoad2:
LoadPLC2:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		bsr.s	ClearPLC
		lea	(Plc_Buffer).w,a2
		move.w	(a1)+,d0
		bmi.s	loc_16C8

loc_16C0:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		dbf	d0,loc_16C0

loc_16C8:
		movem.l	(sp)+,a1-a2
		rts
; End of function LoadPLC2

; ---------------------------------------------------------------------------
; Subroutine to clear the pattern load cue
; ---------------------------------------------------------------------------
; sub_16CE:
ClearPLC:
		lea	(Plc_Buffer).w,a2
		moveq	#$1F,d0

loc_16D4:
		clr.l	(a2)+
		dbf	d0,loc_16D4
		rts
; End of function ClearPLC

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	check the PLC buffer and begin decompression if it contains
; anything. ProcessPLC handles the actual decompression during VBlank
; ---------------------------------------------------------------------------
; sub_16DC: RunPLC:
RunPLC_RAM:
		tst.l	(Plc_Buffer).w		; are there any PLC entries left to process?
		beq.s	locret_1730		; if not, branch
		tst.w	(Plc_PatternsLeft).w	; is art already being decompressed?
		bne.s	locret_1730		; if yes, branch

		movea.l	(Plc_Buffer).w,a0
		lea	NemDec_WriteAndStay(pc),a3
		nop
		lea	(Decomp_Buffer).w,a1
		move.w	(a0)+,d2
		bpl.s	loc_16FE
		adda.w	#$A,a3

loc_16FE:
		andi.w	#$7FFF,d2
		; This should actually be at the end of this function. Having it
		; here creates a potential race condition where an interrupt may
		; get execute the PLC processor before it is fully initialized,
		; causing the game to crash. This was fixed in Sonic 3.
		move.w	d2,(Plc_PatternsLeft).w		; save section counter
		bsr.w	NemDecPrepare			; decompress the huffman tree RLE table
		move.b	(a0)+,d5			; load lookup field
		asl.w	#8,d5
		move.b	(a0)+,d5
		moveq	#$10,d6				; prepare bit shift counter (shifting up to a word in size)
		moveq	#0,d0
		move.l	a0,(Plc_Buffer).w		; store current entry address
		move.l	a3,(Plc_PtrNemCode).w		; store dumping routine (XOR/Non-XOR)
		move.l	d0,(Plc_RepeatCount).w		; clear RLE dump counter
		move.l	d0,(Plc_PaletteIndex).w		; clear RLE dump nibble
		move.l	d0,(Plc_PreviousRow).w		; clear previous XOR dump
		move.l	d5,(Plc_DataWord).w		; store lookup field
		move.l	d6,(Plc_ShiftValue).w		; store bit shift counter

locret_1730:
		rts
; End of function RunPLC_RAM

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to decompress and dump a specified number of Nemesis-compressed
; PLC tiles from the PLC process list to VRAM. These are called from VBlank,
; probably done to smooth out level loading because of how slow Nemesis is.
;
; (note: Process"D"PLC is an old misnomer!)
; ---------------------------------------------------------------------------
; sub_1732: ProcessDPLC:
ProcessPLC_9Tiles:
		tst.w	(Plc_PatternsLeft).w		; is art being decompressed?
		beq.w	locret_17CA			; if not, branch

		; Around Beta 4, this was nerfed to only decompress
		; 6 tiles per frame instead of 9.
		move.w	#9,(Plc_FramePatternsLeft).w	; decompress 9 tiles per frame
		moveq	#0,d0
		move.w	(Plc_Buffer+4).w,d0		; load VRAM address for this frame
		addi.w	#$120,(Plc_Buffer+4).w		; increment VRAM address for next frame
		bra.s	ProcessPLC
; ---------------------------------------------------------------------------
; loc_174E: ProcessDPLC2:
ProcessPLC_3Tiles:
		tst.w	(Plc_PatternsLeft).w		; is art being decompressed?
		beq.s	locret_17CA			; if not, branch

		move.w	#3,(Plc_FramePatternsLeft).w	; decompress 3 tiles per frame
		moveq	#0,d0
		move.w	(Plc_Buffer+4).w,d0		; load VRAM address for this frame
		addi.w	#$60,(Plc_Buffer+4).w		; increment VRAM address for next frame
; loc_1766: ProcessDPLC_Main:
ProcessPLC:
		lea	(VDP_control_port).l,a4
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(a4)
		subq.w	#4,a4
		movea.l	(Plc_Buffer).w,a0		; load current entry address
		movea.l	(Plc_PtrNemCode).w,a3		; load dumping routine to use (XOR/Non-XOR)
		move.l	(Plc_RepeatCount).w,d0		; load RLE dump counter
		move.l	(Plc_PaletteIndex).w,d1		; load RLE dump nibble
		move.l	(Plc_PreviousRow).w,d2		; load previous XOR dump
		move.l	(Plc_DataWord).w,d5		; load lookup field
		move.l	(Plc_ShiftValue).w,d6		; load bit shift counter
		lea	(Decomp_Buffer).w,a1		; load RLE huffman buffer

loc_179A:
		movea.w	#8,a5				; set size of data to decompress (20 bytes, 1 tile)
		bsr.w	NemDec_WriteIter
		subq.w	#1,(Plc_PatternsLeft).w
		beq.s	ProcessPLC_Pop			; if there are no tiles left, branch
		subq.w	#1,(Plc_FramePatternsLeft).w
		bne.s	loc_179A			; if the decompressor is still running, branch

		move.l	a0,(Plc_Buffer).w		; store current entry address
		move.l	a3,(Plc_PtrNemCode).w		; store dumping routine to use (XOR/Non-XOR)
		move.l	d0,(Plc_RepeatCount).w		; store RLE dump counter
		move.l	d1,(Plc_PaletteIndex).w		; store RLE dump nibble
		move.l	d2,(Plc_PreviousRow).w		; store previous XOR dump
		move.l	d5,(Plc_DataWord).w		; store lookup field
		move.l	d6,(Plc_ShiftValue).w		; store bit shift counter

locret_17CA:
		rts
; ===========================================================================
; pop one request off the buffer so that the next one can be filled
; loc_17CC: ProcessDPLC_Pop:
ProcessPLC_Pop:
		lea	(Plc_Buffer).w,a0	; load PLC process list
		moveq	#$15,d0

loc_17D2:
		move.l	6(a0),(a0)+	; shift contents of PLC buffer up 6 bytes
		dbf	d0,loc_17D2	; repeat until finished
		rts
; End of function ProcessPLC

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to execute a pattern load cue directly from the ROM
; rather than loading them into the queue first
; ---------------------------------------------------------------------------
; sub_17DC:
RunPLC_ROM:
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		move.w	(a1)+,d1

loc_17EE:
		movea.l	(a1)+,a0
		moveq	#0,d0
		move.w	(a1)+,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(VDP_control_port).l
		bsr.w	NemDec
		dbf	d1,loc_17EE
		rts
; End of function RunPLC_ROM