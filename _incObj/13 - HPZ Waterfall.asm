; ===========================================================================
; ---------------------------------------------------------------------------
; Object 13 - Waterfall from Hidden Palace Zone
;
; Internal name: "wfall"
; ---------------------------------------------------------------------------
; OST:
hpzwaterfall_child1_y_pos:	equ $34 ; word
hpzwaterfall_child2_y_pos:	equ $36 ; word
hpzwaterfall_child1:		equ $38	; long-word ; pointer to first stream
hpzwaterfall_child2:		equ $3C	; long-word ; pointer to second stream (if it exists)
; ---------------------------------------------------------------------------
; Sprite_14458: Obj13:
Obj_HPZWaterfall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	HPZWaterfall_Index(pc,d0.w),d1
		jmp	HPZWaterfall_Index(pc,d1.w)
; ===========================================================================
; off_14466: Obj13_Index:
HPZWaterfall_Index:
		dc.w HPZWaterfall_Init-HPZWaterfall_Index
		dc.w HPZWaterfall_Main-HPZWaterfall_Index
		dc.w HPZWaterfall_ChkDel2-HPZWaterfall_Index
; ===========================================================================
; loc_1446C:
HPZWaterfall_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_HPZWaterfall,mappings(a0)
		move.w	#$E315,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#1,priority(a0)
		move.b	#$12,mapping_frame(a0)
		bsr.s	HPZWaterfall_CreateStream
		move.b	#$A0,y_radius(a1)
		bset	#4,render_flags(a1)
		move.l	a1,hpzwaterfall_child1(a0)
		move.w	y_pos(a0),hpzwaterfall_child1_y_pos(a0)
		move.w	y_pos(a0),hpzwaterfall_child2_y_pos(a0)
		cmpi.b	#$10,subtype(a0)
		bcs.s	HPZWaterfall_SetLength
		bsr.s	HPZWaterfall_CreateStream
		move.l	a1,hpzwaterfall_child2(a0)
		move.w	y_pos(a0),y_pos(a1)
		addi.w	#$98,y_pos(a1)
		bra.s	HPZWaterfall_SetLength

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to create the stream of the waterfall
; ---------------------------------------------------------------------------
; sub_144D4:
HPZWaterfall_CreateStream:
		jsr	(AllocateObjectAfterCurrent).l
		bne.s	locret_14516
		move.b	#ObjID_HPZWaterfall,id(a1)
		addq.b	#4,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	#MapUnc_HPZWaterfall,mappings(a1)
		move.w	#$E315,art_tile(a1)
		bsr.w	Adjust2PArtPointer2
		move.b	#4,render_flags(a1)
		move.b	#$10,width_pixels(a1)
		move.b	#1,priority(a1)

locret_14516:
		rts
; End of function HPZWaterfall_CreateStream

; ===========================================================================
; loc_14518:
HPZWaterfall_SetLength:
		moveq	#0,d1
		move.b	subtype(a0),d1
		move.w	hpzwaterfall_child1_y_pos(a0),d0
		subi.w	#$78,d0
		lsl.w	#4,d1
		add.w	d1,d0
		move.w	d0,y_pos(a0)
		move.w	d0,hpzwaterfall_child1_y_pos(a0)
; loc_14532:
HPZWaterfall_Main:
		movea.l	hpzwaterfall_child1(a0),a1
		move.b	#$12,mapping_frame(a0)
		move.w	hpzwaterfall_child1_y_pos(a0),d0
		move.w	(Water_Level_1).w,d1
		cmp.w	d0,d1
		bcc.s	loc_1454A
		move.w	d1,d0

loc_1454A:
		move.w	d0,y_pos(a0)
		sub.w	hpzwaterfall_child2_y_pos(a0),d0
		addi.w	#$80,d0
		bmi.s	HPZWaterfall_ChkDel
		lsr.w	#4,d0
		move.w	d0,d1
		cmpi.w	#$F,d0
		bcs.s	loc_14564
		moveq	#$F,d0

loc_14564:
		move.b	d0,mapping_frame(a1)
		cmpi.b	#$10,subtype(a0)
		bcs.s	loc_14584
		movea.l	hpzwaterfall_child2(a0),a1
		subi.w	#$F,d1
		bcc.s	loc_1457C
		moveq	#0,d1

loc_1457C:
		addi.w	#$13,d1
		move.b	d1,mapping_frame(a1)

loc_14584:
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
; loc_1459C:
HPZWaterfall_ChkDel:
		moveq	#$13,d0
		move.b	d0,mapping_frame(a0)
		move.b	d0,mapping_frame(a1)
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ===========================================================================
; loc_145BC:
HPZWaterfall_ChkDel2:
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj13:
MapUnc_HPZWaterfall:	include	"mappings/sprite/Waterfalls from HPZ.asm"