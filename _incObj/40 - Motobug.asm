; ===========================================================================
; ---------------------------------------------------------------------------
; Object 40 - GHZ Motobug
;
; Internal name: "musi"
; ---------------------------------------------------------------------------
; Sprite_F248: Obj40:
Obj_Motobug:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Motobug_Index(pc,d0.w),d1
		jmp	Motobug_Index(pc,d1.w)
; ===========================================================================
; off_F256: Obj40_Index:
Motobug_Index:	dc.w Motobug_Init-Motobug_Index
		dc.w Motobug_Main-Motobug_Index
		dc.w Motobug_Animate-Motobug_Index
		dc.w Motobug_Delete-Motobug_Index
; ===========================================================================
; loc_F25E: Obj40_Init:
Motobug_Init:
		move.l	#MapUnc_Motobug,mappings(a0)
		move.w	#$4E0,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$14,width_pixels(a0)
		tst.b	anim(a0)
		bne.s	Motobug_Smoke
		move.b	#$E,y_radius(a0)
		move.b	#8,x_radius(a0)
		move.b	#$C,collision_flags(a0)
		bsr.w	ObjectMoveAndFall
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	locret_F2BC
		add.w	d1,y_pos(a0)
		move.w	#0,y_vel(a0)
		addq.b	#2,routine(a0)
		bchg	#0,status(a0)

locret_F2BC:
		rts
; ===========================================================================
; loc_F2BE: Obj40_Smoke:
Motobug_Smoke:
		addq.b	#4,routine(a0)
		bra.w	Motobug_Animate
; ===========================================================================
; loc_F2C6: Obj40_Main:
Motobug_Main:
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Motobug_Main_Index(pc,d0.w),d1
		jsr	Motobug_Main_Index(pc,d1.w)
		lea	(Ani_Motobug).l,a1
		bsr.w	AnimateSprite
		bra.w	MarkObjGone
; ===========================================================================
; off_F2E2 Obj40_Main_Index:
Motobug_Main_Index:
		dc.w Motobug_Move-Motobug_Main_Index
		dc.w Motobug_Floor-Motobug_Main_Index
; ===========================================================================
; loc_F2E6: Obj40_Move:
Motobug_Move:
		subq.w	#1,$30(a0)
		bpl.s	locret_F308
		addq.b	#2,routine_secondary(a0)
		move.w	#-$100,x_vel(a0)
		move.b	#1,anim(a0)
		bchg	#0,status(a0)
		bne.s	locret_F308
		neg.w	x_vel(a0)

locret_F308:
		rts
; ===========================================================================
; loc_F30A: Obj40_Floor:
Motobug_Floor:
		bsr.w	ObjectMove
		jsr	(ObjHitFloor).l
		cmpi.w	#-8,d1
		blt.s	Motobug_StopMoving
		cmpi.w	#$C,d1
		bge.s	Motobug_StopMoving
		add.w	d1,y_pos(a0)
		subq.b	#1,$33(a0)
		bpl.s	locret_F354
		move.b	#$F,$33(a0)
		bsr.w	AllocateObject
		bne.s	locret_F354
		move.b	#ObjID_Motobug,id(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	status(a0),status(a1)
		move.b	#2,anim(a1)

locret_F354:
		rts
; ---------------------------------------------------------------------------
; loc_F356: Obj40_StopMoving:
Motobug_StopMoving:
		subq.b	#2,routine_secondary(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,x_vel(a0)
		move.b	#0,anim(a0)
		rts
; ===========================================================================
; loc_F36E: Obj40_Animate:
Motobug_Animate:
		lea	(Ani_Motobug).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ===========================================================================
; loc_F37C: Obj40_Delete:
Motobug_Delete:
		bra.w	DeleteObject
; ===========================================================================
; animation script Ani_obj40:
Ani_Motobug:	dc.w byte_F386-Ani_Motobug
		dc.w byte_F389-Ani_Motobug
		dc.w byte_F38F-Ani_Motobug
byte_F386:	dc.b  $F,  2,$FF
byte_F389:	dc.b   7,  0,  1,  0,  2,$FF
byte_F38F:	dc.b   1,  3,  6,  3,  6,  4,  6,  4
		dc.b   6,  4,  6,  5,$FC
		even

; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_obj40:
MapUnc_Motobug:	include	"mappings/sprite/Badniks - Motobug.asm"