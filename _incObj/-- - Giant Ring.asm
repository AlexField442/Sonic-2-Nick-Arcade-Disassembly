; ===========================================================================
; ---------------------------------------------------------------------------
; Sonic	1 Object 4B - Giant Ring at end of stage (unused, pointer removed)
;
; Internal name: "bigring"
; ---------------------------------------------------------------------------
; Sprite_AA72: S1Obj4B:
Obj_GiantRing:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	GiantRing_Index(pc,d0.w),d1
		jmp	GiantRing_Index(pc,d1.w)
; ===========================================================================
; off_AA80: S1Obj4B_Index:
GiantRing_Index:
		dc.w GiantRing_Init-GiantRing_Index
		dc.w GiantRing_Main-GiantRing_Index
		dc.w GiantRing_Collect-GiantRing_Index
		dc.w GiantRing_Delete-GiantRing_Index
; ===========================================================================
; loc_AA88:
GiantRing_Init:
		move.l	#MapUnc_GiantRing,mappings(a0)
		move.w	#$2400,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#$40,width_pixels(a0)
		tst.b	render_flags(a0)
		bpl.s	GiantRing_Main
		cmpi.b	#6,(Emerald_count).w
		beq.w	GiantRing_Delete
		cmpi.w	#50,(Ring_count).w
		bcc.s	loc_AAC0
		rts
; ===========================================================================

loc_AAC0:
		addq.b	#2,routine(a0)
		move.b	#2,priority(a0)
		move.b	#$52,collision_flags(a0)
		move.w	#$C40,(BigRingGraphics).w
; loc_AAD6:
GiantRing_Main:
		move.b	(Rings_anim_frame).w,mapping_frame(a0)
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
; loc_AAF4:
GiantRing_Collect:
		subq.b	#2,routine(a0)
		move.b	#0,collision_flags(a0)
		bsr.w	AllocateObject
		bne.w	loc_AB2C
		move.b	#ObjID_RingFlash,id(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	a0,$3C(a1)
		move.w	(MainCharacter+x_pos).w,d0
		cmp.w	x_pos(a0),d0
		bcs.s	loc_AB2C
		bset	#0,render_flags(a1)

loc_AB2C:
		move.w	#SndID_EnterGiantRing,d0
		jsr	(PlaySound).l
		bra.s	GiantRing_Main
; ===========================================================================
; loc_AB38:
GiantRing_Delete:
		bra.w	DeleteObject
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
include_MapUnc_GiantRing macro
; Map_S1Obj4B:
MapUnc_GiantRing:	include	"mappings/sprite/Giant Ring.asm"
		endm