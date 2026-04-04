; ===========================================================================
; ---------------------------------------------------------------------------
; Object 4F - Redz (dinosaur badnik) from HPZ
;
; Internal name: "redz"
; ---------------------------------------------------------------------------
; OST:
redz_waittimer:		equ $30
; ---------------------------------------------------------------------------
; Sprite_15DA4: Obj4F:
Obj_Redz:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Redz_Index(pc,d0.w),d1
		jmp	Redz_Index(pc,d1.w)
; ===========================================================================
; Obj4F_Index:
Redz_Index:	dc.w Redz_Init-Redz_Index
		dc.w Redz_Main-Redz_Index
		dc.w Redz_Delete-Redz_Index
; ===========================================================================
; Obj4F_Init:
Redz_Init:
		move.l	#MapUnc_Redz,mappings(a0)
		move.w	#$500,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		move.b	#6,x_radius(a0)
		move.b	#$C,collision_flags(a0)
		bsr.w	j_ObjectMoveAndFall_1
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	locret_15E0C
		add.w	d1,y_pos(a0)

loc_15DFC:
		move.w	#0,y_vel(a0)
		addq.b	#2,routine(a0)
		bchg	#0,status(a0)

locret_15E0C:
		rts
; ===========================================================================
; Obj4F_Main:
Redz_Main:
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Redz_SubIndex(pc,d0.w),d1
		jsr	Redz_SubIndex(pc,d1.w)
		lea	(Ani_Redz).l,a1
		bsr.w	j_AnimateSprite_2
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	Redz_ChkDel
		bra.w	loc_15EE8
; ---------------------------------------------------------------------------
; loc_15E3E:
Redz_ChkDel:
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		beq.s	loc_15E50
		bclr	#7,2(a2,d0.w)

loc_15E50:
		bra.w	JmpTo4_DeleteObject
; ===========================================================================
; Obj4F_SubIndex:
Redz_SubIndex:	dc.w Redz_Move-Redz_SubIndex
		dc.w Redz_ChkFloor-Redz_SubIndex
; ===========================================================================
; loc_15E58: Obj4F_MoveLeft:
Redz_Move:
		subq.w	#1,redz_waittimer(a0)	; is Redz not moving?
		bpl.s	locret_15E7A	; if yes, branch
		addq.b	#2,routine_secondary(a0)
		move.w	#$FF80,x_vel(a0)
		move.b	#1,anim(a0)
		bchg	#0,status(a0)
		bne.s	locret_15E7A
		neg.w	x_vel(a0)

locret_15E7A:
		rts
; ===========================================================================
; loc_15E7C: Obj4F_ChkFloor:
Redz_ChkFloor:
		bsr.w	j_ObjectMove_3
		jsr	(ObjHitFloor).l
		cmpi.w	#-8,d1
		blt.s	Redz_StopMoving
		cmpi.w	#$C,d1
		bge.s	Redz_StopMoving
		add.w	d1,y_pos(a0)
		rts
; ---------------------------------------------------------------------------
; loc_15E98: Obj4F_StopMoving:
Redz_StopMoving:
		subq.b	#2,routine_secondary(a0)
		move.w	#(1*60)-1,redz_waittimer(a0)	; pause for 1 second
		move.w	#0,x_vel(a0)
		move.b	#0,anim(a0)
		rts
; ===========================================================================
; Obj4F_Delete:
Redz_Delete:
		bra.w	JmpTo4_DeleteObject
; ===========================================================================
; animation script
Ani_Redz:	dc.w .wait-Ani_Redz
		dc.w .move-Ani_Redz
; byte_15EB8:
.wait:		dc.b   9,  1,$FF
; byte_15EBB:
.move:		dc.b   9,  0,  1,  2,  1,$FF
		even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_obj4F:
MapUnc_Redz:	include	"mappings/sprite/Redz.asm"
		align 4