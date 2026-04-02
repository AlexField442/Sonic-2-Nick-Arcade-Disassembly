; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


PalCycle_Load:
		moveq	#0,d2
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		add.w	d0,d0
		move.w	PalCycle(pc,d0.w),d0
		jmp	PalCycle(pc,d0.w)
; ---------------------------------------------------------------------------
		rts
; End of function PalCycle_Load

; ===========================================================================
PalCycle:	dc.w PalCycle_GHZ-PalCycle
		dc.w PalCycle_CPZ-PalCycle
		dc.w PalCycle_CPZ-PalCycle
		dc.w PalCycle_EHZ-PalCycle
		dc.w PalCycle_HPZ-PalCycle
		dc.w PalCycle_HTZ-PalCycle
		dc.w PalCycle_GHZ-PalCycle
; ===========================================================================

PalCycle_S1TitleScreen:
		lea	(Pal_S1TitleCyc).l,a0
		bra.s	loc_1E7C
; ===========================================================================

PalCycle_GHZ:
		lea	(Pal_GHZCyc).l,a0

loc_1E7C:
		subq.w	#1,(PalCycle_Timer).w
		bpl.s	locret_1EA2
		move.w	#5,(PalCycle_Timer).w
		move.w	(PalCycle_Frame).w,d0
		addq.w	#1,(PalCycle_Frame).w
		andi.w	#3,d0
		lsl.w	#3,d0
		lea	(Normal_palette_line3+$10).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)

locret_1EA2:
		rts
; ===========================================================================

PalCycle_CPZ:
		subq.w	#1,(PalCycle_Timer).w
		bpl.s	locret_1F14
		move.w	#7,(PalCycle_Timer).w
		lea	(Pal_CPZCyc1).l,a0
		move.w	(PalCycle_Frame).w,d0
		addq.w	#6,(PalCycle_Frame).w
		cmpi.w	#$36,(PalCycle_Frame).w
		bcs.s	loc_1ECC
		move.w	#0,(PalCycle_Frame).w

loc_1ECC:
		lea	(Normal_palette_line4+$18).w,a1
		move.l	(a0,d0.w),(a1)+
		move.w	4(a0,d0.w),(a1)
		lea	(Pal_CPZCyc2).l,a0
		move.w	(PalCycle_Frame2).w,d0
		addq.w	#2,(PalCycle_Frame2).w
		cmpi.w	#$2A,(PalCycle_Frame2).w
		bcs.s	loc_1EF4
		move.w	#0,(PalCycle_Frame2).w

loc_1EF4:
		move.w	(a0,d0.w),(Normal_palette_line4+$1E).w
		lea	(Pal_CPZCyc3).l,a0
		move.w	(PalCycle_Frame3).w,d0
		addq.w	#2,(PalCycle_Frame3).w
		andi.w	#$1E,(PalCycle_Frame3).w
		move.w	(a0,d0.w),(Normal_palette_line3+$1E).w

locret_1F14:
		rts
; ===========================================================================

PalCycle_HPZ:
		subq.w	#1,(PalCycle_Timer).w
		bpl.s	locret_1F56
		move.w	#4,(PalCycle_Timer).w
		lea	(Pal_HPZCyc1).l,a0
		move.w	(PalCycle_Frame).w,d0
		subq.w	#2,(PalCycle_Frame).w
		bcc.s	loc_1F38
		move.w	#6,(PalCycle_Frame).w

loc_1F38:
		lea	(Normal_palette_line4+$12).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)
		lea	(Pal_HPZCyc2).l,a0
		lea	(Underwater_palette_line4+$12).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)

locret_1F56:
		rts
; ===========================================================================

PalCycle_EHZ:
		lea	(Pal_EHZCyc).l,a0
		subq.w	#1,(PalCycle_Timer).w
		bpl.s	locret_1F84
		move.w	#7,(PalCycle_Timer).w
		move.w	(PalCycle_Frame).w,d0
		addq.w	#1,(PalCycle_Frame).w
		andi.w	#3,d0
		lsl.w	#3,d0
		move.l	(a0,d0.w),(Normal_palette_line2+6).w
		move.l	4(a0,d0.w),(Normal_palette_line2+$1C).w

locret_1F84:
		rts
; ===========================================================================

PalCycle_HTZ:
		lea	(Pal_HTZCyc1).l,a0
		subq.w	#1,(PalCycle_Timer).w
		bpl.s	locret_1FB8
		move.w	#0,(PalCycle_Timer).w
		move.w	(PalCycle_Frame).w,d0
		addq.w	#1,(PalCycle_Frame).w
		andi.w	#$F,d0
		move.b	Pal_HTZCyc2(pc,d0.w),(PalCycle_Timer+1).w
		lsl.w	#3,d0
		move.l	(a0,d0.w),(Normal_palette_line2+6).w
		move.l	4(a0,d0.w),(Normal_palette_line2+$1C).w

locret_1FB8:
		rts
; ===========================================================================
Pal_HTZCyc2:	incbin "art/palettes/Hill Top Lava Delay.bin"
Pal_S1TitleCyc:	incbin "art/palettes/S1 Title Water.bin"
Pal_GHZCyc:	incbin "art/palettes/GHZ Water.bin"
Pal_EHZCyc:	incbin "art/palettes/EHZ Water.bin"
Pal_HTZCyc1:	incbin "art/palettes/Hill Top Lava.bin"
Pal_CPZCyc1:	incbin "art/palettes/CPZ Cycle 1.bin"
Pal_CPZCyc2:	incbin "art/palettes/CPZ Cycle 2.bin"
Pal_CPZCyc3:	incbin "art/palettes/CPZ Cycle 3.bin"
Pal_HPZCyc1:	incbin "art/palettes/HPZ Water Cycle.bin"
Pal_HPZCyc2:	incbin "art/palettes/HPZ Underwater Cycle.bin"