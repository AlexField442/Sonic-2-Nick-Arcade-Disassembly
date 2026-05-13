; ===========================================================================
; ---------------------------------------------------------------------------
; Object 25 - Rings (ones placed in debug mode, not in-level)
;
; Internal name: "ring"
; ---------------------------------------------------------------------------
; OST:
ring_x_pos_main:		equ $32		; word ; x-position of "main" ring
ring_number:			equ $34		; byte ; which ring in the group of 1-7 rings it is
; ---------------------------------------------------------------------------
; Sprite_A7E4: Obj25:
Obj_Ring:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Ring_Index(pc,d0.w),d1
		jmp	Ring_Index(pc,d1.w)
; ===========================================================================
; off_A7F2: Obj25_Index:
Ring_Index:	dc.w loc_A81C-Ring_Index
		dc.w loc_A88A-Ring_Index
		dc.w loc_A8A6-Ring_Index
		dc.w loc_A8CC-Ring_Index
		dc.w loc_A8DA-Ring_Index
; Leftover from Sonic 1, where the ring object handled loading rings. With
; the new ring manager, this goes unused.
; Ring_PosData:
		dc.b $10,  0,$18,  0
		dc.b $20,  0,  0,$10
		dc.b   0,$18,  0,$20
		dc.b $10,$10,$18,$18
		dc.b $20,$20,$F0,$10
		dc.b $E8,$18,$E0,$20
		dc.b $10,  8,$18,$10
		dc.b $F0,  8,$E8,$10
; ===========================================================================

loc_A81C:
		movea.l	a0,a1
		moveq	#0,d1
		move.w	x_pos(a0),d2
		move.w	y_pos(a0),d3
		bra.s	loc_A832
; ===========================================================================

loc_A82A:
		swap	d1
		bsr.w	AllocateObject
		bne.s	loc_A88A

loc_A832:
		move.b	#ObjID_Ring,id(a1)
		addq.b	#2,routine(a1)
		move.w	d2,x_pos(a1)
		move.w	x_pos(a0),ring_x_pos_main(a1)
		move.w	d3,y_pos(a1)
		move.l	#MapUnc_Ring,mappings(a1)
		move.w	#$26BC,art_tile(a1)
		bsr.w	Adjust2PArtPointer2
		move.b	#4,render_flags(a1)
		move.b	#2,priority(a1)
		move.b	#$47,collision_flags(a1)
		move.b	#8,width_pixels(a1)
		move.b	respawn_index(a0),respawn_index(a1)
		move.b	d1,ring_number(a1)
		addq.w	#1,d1
		add.w	d5,d2
		add.w	d6,d3
		swap	d1
		dbf	d1,loc_A82A

loc_A88A:
		move.b	(Rings_anim_frame).w,mapping_frame(a0)
		move.w	ring_x_pos_main(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.s	loc_A8DA
		bra.w	DisplaySprite
; ===========================================================================

loc_A8A6:
		addq.b	#2,routine(a0)
		move.b	#0,collision_flags(a0)
		move.b	#1,priority(a0)
		bsr.w	CollectRing
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		move.b	ring_number(a0),d1
		bset	d1,2(a2,d0.w)

loc_A8CC:
		lea	(Ani_Ring).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ===========================================================================

loc_A8DA:
		bra.w	DeleteObject

; ---------------------------------------------------------------------------
; Subroutine to add a ring to the ring count
; ---------------------------------------------------------------------------
; sub_A8DE:
CollectRing:
		addq.w	#1,(Ring_count).w
		ori.b	#1,(Update_HUD_rings).w
		move.w	#SndID_Ring,d0
		cmpi.w	#100,(Ring_count).w
		bcs.s	loc_A918
		bset	#1,(Extra_life_flags).w
		beq.s	loc_A90C
		cmpi.w	#200,(Ring_count).w
		bcs.s	loc_A918
		bset	#2,(Extra_life_flags).w
		bne.s	loc_A918

loc_A90C:
		addq.b	#1,(Life_count).w
		addq.b	#1,(Update_HUD_lives).w
		move.w	#MusID_ExtraLife,d0

loc_A918:
		jmp	(PlaySound).l
; End of function CollectRing

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 37 - Rings flying out of you when you get hit
;
; Internal name: "flyring"
; --------------------------------------------------------------------------
; Sprite_A91E: Obj37:
Obj_LostRings:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	LostRings_Index(pc,d0.w),d1
		jmp	LostRings_Index(pc,d1.w)
; ===========================================================================
; off_A92C: Obj37_Index:
LostRings_Index:
		dc.w loc_A936-LostRings_Index
		dc.w loc_A9FA-LostRings_Index
		dc.w loc_AA4C-LostRings_Index
		dc.w loc_AA60-LostRings_Index
		dc.w loc_AA6E-LostRings_Index
; ===========================================================================

loc_A936:
		movea.l	a0,a1
		moveq	#0,d5
		move.w	(Ring_count).w,d5
		moveq	#32,d0
		cmp.w	d0,d5
		bcs.s	loc_A946
		move.w	d0,d5

loc_A946:
		subq.w	#1,d5
		move.w	#$288,d4
		bra.s	loc_A956
; ===========================================================================

loc_A94E:
		bsr.w	AllocateObject
		bne.w	loc_A9DE

loc_A956:
		move.b	#ObjID_LostRings,id(a1)
		addq.b	#2,routine(a1)
		move.b	#8,y_radius(a1)
		move.b	#8,x_radius(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	#MapUnc_Ring,mappings(a1)
		move.w	#$26BC,art_tile(a1)
		bsr.w	Adjust2PArtPointer2
		move.b	#4,render_flags(a1)
		move.b	#3,priority(a1)
		move.b	#$47,collision_flags(a1)
		move.b	#8,width_pixels(a1)
		move.b	#$FF,(Ring_spill_anim_counter).w
		tst.w	d4
		bmi.s	loc_A9CE
		move.w	d4,d0
		bsr.w	CalcSine
		move.w	d4,d2
		lsr.w	#8,d2
		asl.w	d2,d0
		asl.w	d2,d1
		move.w	d0,d2
		move.w	d1,d3
		addi.b	#$10,d4
		bcc.s	loc_A9CE
		subi.w	#$80,d4
		bcc.s	loc_A9CE
		move.w	#$288,d4

loc_A9CE:
		move.w	d2,x_vel(a1)
		move.w	d3,y_vel(a1)
		neg.w	d2
		neg.w	d4
		dbf	d5,loc_A94E

loc_A9DE:
		move.w	#0,(Ring_count).w
		move.b	#$80,(Update_HUD_rings).w
		move.b	#0,(Extra_life_flags).w
		move.w	#SndID_RingSpill,d0
		jsr	(PlaySound).l

loc_A9FA:
		move.b	(Ring_spill_anim_frame).w,mapping_frame(a0)
		bsr.w	ObjectMove
		addi.w	#$18,y_vel(a0)
		bmi.s	loc_AA34
		move.b	(Vint_runcount+3).w,d0
		add.b	d7,d0
		andi.b	#3,d0
		bne.s	loc_AA34
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_AA34
		add.w	d1,y_pos(a0)
		move.w	y_vel(a0),d0
		asr.w	#2,d0
		sub.w	d0,y_vel(a0)
		neg.w	y_vel(a0)

loc_AA34:
		tst.b	(Ring_spill_anim_counter).w
		beq.s	loc_AA6E
		move.w	(Camera_Max_Y_pos).w,d0
		addi.w	#$E0,d0
		cmp.w	y_pos(a0),d0
		bcs.s	loc_AA6E
		bra.w	DisplaySprite
; ===========================================================================

loc_AA4C:
		addq.b	#2,routine(a0)
		move.b	#0,collision_flags(a0)
		move.b	#1,priority(a0)
		bsr.w	CollectRing

loc_AA60:
		lea	(Ani_Ring).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ===========================================================================

loc_AA6E:
		bra.w	DeleteObject
; ==========================================================================
; --------------------------------------------------------------------------
; animation scripts
; --------------------------------------------------------------------------
include_Ani_Ring macro
; Ani_Obj25:
Ani_Ring:	dc.w .spin-Ani_Ring
; byte_ABEC:
.spin:		dc.b   5,  4,  5,  6,  7,$FC
		even
		endm
; --------------------------------------------------------------------------
; sprite mappings
; --------------------------------------------------------------------------
include_MapUnc_Ring macro
; Map_Obj25:
MapUnc_Ring:	include	"mappings/sprite/Rings (object).asm"
		endm