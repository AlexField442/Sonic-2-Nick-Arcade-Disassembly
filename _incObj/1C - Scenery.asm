; ===========================================================================
; ---------------------------------------------------------------------------
; Object 1C - Decorative sprites; i.e. bridge stakes, zipline pegs, etc.
;
; Internal name: "bgspr"
; ---------------------------------------------------------------------------
; Sprite_93A4: Obj1C:
Obj_Scenery:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Scenery_Index(pc,d0.w),d1
		jmp	Scenery_Index(pc,d1.w)
; ===========================================================================
; off_93B2: Obj1C_Index:
Scenery_Index:	dc.w Scenery_Init-Scenery_Index
		dc.w Scenery_Main-Scenery_Index
		dc.w Scenery_Animate-Scenery_Index
; ===========================================================================
; dword_93B8: Obj1C_Conf:
Scenery_InitData:
		; mappings
		; art_tile
		; mapping_frame, width_pixels, priority, collision_flags (not used)
		dc.l	MapUnc_HPZBridge
		dc.w	$6300
		dc.b	3,  4,  1,  0
		dc.l	MapUnc_HPZOrb
		dc.w	$E35A
		dc.b	0,$10,  1,  0
		dc.l	MapUnc_EHZBridge
		dc.w	$43C6
		dc.b	1,  4,  1,  0
		dc.l	MapUnc_GHZBridge
		dc.w	$44C6
		dc.b	1,$10,  1,  0
		dc.l	MapUnc_HTZLift
		dc.w	$43E6
		dc.b	1,  8,  4,  0
		dc.l	MapUnc_HTZLift
		dc.w	$43E6
		dc.b	2,  8,  4,  0
; ===========================================================================
; loc_93F4:
Scenery_Init:
		addq.b	#2,routine(a0)
		move.b	subtype(a0),d0
		andi.w	#$F,d0
		mulu.w	#$A,d0
		lea	Scenery_InitData(pc,d0.w),a1
		move.l	(a1)+,mappings(a0)
		move.w	(a1)+,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	(a1)+,mapping_frame(a0)
		move.b	(a1)+,width_pixels(a0)
		move.b	(a1)+,priority(a0)
		move.b	(a1)+,collision_flags(a0)
		; In this build, the HPZ bridge stake and glowing orbs are a subtype of this
		; object, with the upper 4 bits of subtype being used to determine if it
		; should be animated. The final split them (and the MTZ lava bubble) into
		; a separate 'animated' scenery object ($71).
		move.b	subtype(a0),d0
		andi.w	#$F0,d0
		beq.s	Scenery_Main
		addq.b	#2,routine(a0)
		lsr.b	#4,d0
		subq.b	#1,d0
		move.b	d0,anim(a0)
		bra.s	Scenery_Animate
; ===========================================================================
; loc_9442:
Scenery_Main:
		tst.w	(Two_player_mode).w
		beq.s	loc_944C
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_944C:
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
; loc_9464:
Scenery_Animate:
		lea	(Ani_Scenery).l,a1
		bsr.w	AnimateSprite
		tst.w	(Two_player_mode).w
		beq.s	loc_9478
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_9478:
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
; ---------------------------------------------------------------------------
; animation scripts
; ---------------------------------------------------------------------------
; Ani_Obj1C:
Ani_Scenery:	dc.w .HPZstake-Ani_Scenery
		dc.w .glowingorb-Ani_Scenery
; byte_9494:
.HPZstake:	dc.b   8,  3,  3,  4,  5,  5,  4,$FF
; byte_949C:
.glowingorb:	dc.b   5,  0,  0,  0,  1,  2,  3,  3
		dc.b   2,  1,  2,  3,  3,  1,$FF
		even

; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj1C_01:
MapUnc_HPZOrb:	include	"mappings/sprite/Glowing orb from HPZ.asm"