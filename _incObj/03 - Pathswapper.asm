; ===========================================================================
; ---------------------------------------------------------------------------
; Object 03 - Collision plane/layer switcher
;
; Internal name: "colichg"
; ---------------------------------------------------------------------------
; Sprite_13E2C: Obj03:
Obj_Pathswapper:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Pathswapper_Index(pc,d0.w),d1
		jsr	Pathswapper_Index(pc,d1.w)
		tst.w	(Debug_mode_flag).w
		beq.w	MarkObjGone2
		jmp	(MarkObjGone).l
; ===========================================================================
; off_13E48: Obj03_Index:
Pathswapper_Index:
		dc.w Pathswapper_Init-Pathswapper_Index
		dc.w Pathswapper_MainX-Pathswapper_Index
		dc.w Pathswapper_MainY-Pathswapper_Index
; ===========================================================================
; loc_13E48: Obj03_Init:
Pathswapper_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_Pathswapper,mappings(a0)
		move.w	#$26BC,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#5,priority(a0)
		move.b	subtype(a0),d0
		btst	#2,d0
		beq.s	Pathswapper_Init_CheckX
; Pathswapper_Init_CheckY:
		addq.b	#2,routine(a0)
		andi.w	#7,d0
		move.b	d0,mapping_frame(a0)
		andi.w	#3,d0
		add.w	d0,d0
		move.w	Obj03_Data(pc,d0.w),$32(a0)
		bra.w	Pathswapper_MainY
; ===========================================================================
; word_13E9C:
Obj03_Data:	dc.w   $20,  $40,  $80,	$100; 0
; ===========================================================================
; loc_13EA4:
Pathswapper_Init_CheckX:
		andi.w	#3,d0
		move.b	d0,mapping_frame(a0)
		add.w	d0,d0
		move.w	Obj03_Data(pc,d0.w),$32(a0)
; loc_13EB4:
Pathswapper_MainX:
		tst.w	(Debug_placement_mode).w
		bne.w	locret_13FB4
		move.w	$30(a0),d5
		move.w	x_pos(a0),d0
		move.w	d0,d1
		subq.w	#8,d0
		addq.w	#8,d1
		move.w	y_pos(a0),d2
		move.w	d2,d3
		move.w	$32(a0),d4
		sub.w	d4,d2
		add.w	d4,d3
		lea	(dword_140B8).l,a2
		moveq	#7,d6

loc_13EE0:
		move.l	(a2)+,d4
		beq.w	loc_13FA8
		movea.l	d4,a1
		move.w	x_pos(a1),d4
		cmp.w	d0,d4
		bcs.w	loc_13F10
		cmp.w	d1,d4
		bcc.w	loc_13F10
		move.w	y_pos(a1),d4
		cmp.w	d2,d4
		bcs.w	loc_13F10
		cmp.w	d3,d4
		bcc.w	loc_13F10
		ori.w	#$8000,d5
		bra.w	loc_13FA8
; ===========================================================================

loc_13F10:
		tst.w	d5
		bpl.w	loc_13FA8
		swap	d0
		move.b	subtype(a0),d0
		bpl.s	loc_13F26
		btst	#1,status(a1)
		bne.s	loc_13FA2

loc_13F26:
		move.w	x_pos(a1),d4
		cmp.w	x_pos(a0),d4
		bcs.s	loc_13F62
		move.b	#$C,top_solid_bit(a1)
		move.b	#$D,lrb_solid_bit(a1)
		btst	#3,d0
		beq.s	loc_13F4E
		move.b	#$E,top_solid_bit(a1)
		move.b	#$F,lrb_solid_bit(a1)

loc_13F4E:
		bclr	#7,art_tile(a1)
		btst	#5,d0
		beq.s	loc_13F92
		bset	#7,art_tile(a1)
		bra.s	loc_13F92
; ===========================================================================

loc_13F62:
		move.b	#$C,top_solid_bit(a1)
		move.b	#$D,lrb_solid_bit(a1)
		btst	#4,d0
		beq.s	loc_13F80
		move.b	#$E,top_solid_bit(a1)
		move.b	#$F,lrb_solid_bit(a1)

loc_13F80:
		bclr	#7,art_tile(a1)
		btst	#6,d0
		beq.s	loc_13F92
		bset	#7,art_tile(a1)

loc_13F92:
		tst.w	(Debug_mode_flag).w
		beq.s	loc_13FA2
		move.w	#SndID_Checkpoint,d0
		jsr	(PlaySound).l

loc_13FA2:
		swap	d0
		andi.w	#$7FFF,d5

loc_13FA8:
		add.l	d5,d5
		dbf	d6,loc_13EE0
		swap	d5
		move.b	d5,$30(a0)

locret_13FB4:
		rts
; ===========================================================================
; loc_13FB6:
Pathswapper_MainY:
		tst.w	(Debug_placement_mode).w
		bne.w	locret_140B6
		move.w	$30(a0),d5
		move.w	x_pos(a0),d0
		move.w	d0,d1
		move.w	$32(a0),d4
		sub.w	d4,d0
		add.w	d4,d1
		move.w	y_pos(a0),d2
		move.w	d2,d3
		subq.w	#8,d2
		addq.w	#8,d3
		lea	(dword_140B8).l,a2
		moveq	#7,d6

loc_13FE2:
		move.l	(a2)+,d4
		beq.w	loc_140AA
		movea.l	d4,a1
		move.w	x_pos(a1),d4
		cmp.w	d0,d4
		bcs.w	loc_14012
		cmp.w	d1,d4
		bcc.w	loc_14012
		move.w	y_pos(a1),d4
		cmp.w	d2,d4
		bcs.w	loc_14012
		cmp.w	d3,d4
		bcc.w	loc_14012
		ori.w	#$8000,d5
		bra.w	loc_140AA
; ===========================================================================

loc_14012:
		tst.w	d5
		bpl.w	loc_140AA
		swap	d0
		move.b	subtype(a0),d0
		bpl.s	loc_14028
		btst	#1,status(a1)
		bne.s	loc_140A4

loc_14028:
		move.w	y_pos(a1),d4
		cmp.w	y_pos(a0),d4
		bcs.s	loc_14064
		move.b	#$C,top_solid_bit(a1)
		move.b	#$D,lrb_solid_bit(a1)
		btst	#3,d0
		beq.s	loc_14050
		move.b	#$E,top_solid_bit(a1)
		move.b	#$F,lrb_solid_bit(a1)

loc_14050:
		bclr	#7,art_tile(a1)
		btst	#5,d0
		beq.s	loc_14094
		bset	#7,art_tile(a1)
		bra.s	loc_14094
; ===========================================================================

loc_14064:
		move.b	#$C,top_solid_bit(a1)
		move.b	#$D,lrb_solid_bit(a1)
		btst	#4,d0
		beq.s	loc_14082
		move.b	#$E,top_solid_bit(a1)
		move.b	#$F,lrb_solid_bit(a1)

loc_14082:
		bclr	#7,art_tile(a1)
		btst	#6,d0
		beq.s	loc_14094
		bset	#7,art_tile(a1)

loc_14094:
		tst.w	(Debug_mode_flag).w
		beq.s	loc_140A4
		move.w	#SndID_Checkpoint,d0
		jsr	(PlaySound).l

loc_140A4:
		swap	d0
		andi.w	#$7FFF,d5

loc_140AA:
		add.l	d5,d5
		dbf	d6,loc_13FE2
		swap	d5
		move.b	d5,$30(a0)

locret_140B6:
		rts
; ===========================================================================
dword_140B8:	dc.l MainCharacter
		dc.l Sidekick
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj03:
MapUnc_Pathswapper:	incbin	"mappings/sprite/obj03.bin"