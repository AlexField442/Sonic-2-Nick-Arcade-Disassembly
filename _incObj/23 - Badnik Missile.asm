; ===========================================================================
; ---------------------------------------------------------------------------
; Object 23 - Buzz Bomber/Newtron missile
; ---------------------------------------------------------------------------
; OST:
missile_parent:		equ $3C
; ---------------------------------------------------------------------------
; Sprite_A55E: Obj23:
Obj_Missile:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Missile_Index(pc,d0.w),d1
		jmp	Missile_Index(pc,d1.w)
; ===========================================================================
; Obj23_Index:
Missile_Index:	dc.w Missile_Init-Missile_Index
		dc.w Missile_Animate-Missile_Index
		dc.w Missile_Move-Missile_Index
		dc.w Missile_Delete-Missile_Index
		dc.w Missile_Newtron-Missile_Index
; ===========================================================================
; loc_A576: Obj23_Init:
Missile_Init:
		subq.w	#1,$32(a0)
		bpl.s	Missile_ChkDel
		addq.b	#2,routine(a0)
		move.l	#MapUnc_Missile,mappings(a0)
		move.w	#$2444,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#3,priority(a0)
		move.b	#8,width_pixels(a0)
		andi.b	#3,status(a0)
		tst.b	subtype(a0)	; was the object created by a Newtron?
		beq.s	Missile_Animate	; if not, branch

		move.b	#8,routine(a0)
		move.b	#$87,collision_flags(a0)
		move.b	#1,anim(a0)
		bra.s	Missile_Animate2
; ===========================================================================
; loc_A5C4: Obj23_Animate:
Missile_Animate:
		movea.l	missile_parent(a0),a1
		cmpi.b	#ObjID_Explosion,id(a1)	; is Buzz Bomber destroyed?
		beq.s	Missile_Delete	; if yes, branch
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to	check if the Buzz Bomber which fired the missile has been
; destroyed, and if it has, deletes the missile
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; loc_A5DE: Obj23_ChkDel:
Missile_ChkDel:
		movea.l	missile_parent(a0),a1
		cmpi.b	#ObjID_Explosion,id(a1)	; is Buzz Bomber destroyed?
		beq.s	Missile_Delete	; if yes, branch
		rts
; End of function Missile_ChkDel

; ===========================================================================
; loc_A5EC: Obj23_Move:
Missile_Move:
		btst	#7,status(a0)	; has the missile collided with the level? (flag never set)
		bne.s	Missile_Explode	; if yes, branch
		move.b	#$87,collision_flags(a0)
		move.b	#1,anim(a0)
		bsr.w	ObjectMove
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		move.w	(Camera_Max_Y_pos).w,d0
		addi.w	#$E0,d0
		cmp.w	y_pos(a0),d0
		bcs.s	Missile_Delete
		bra.w	DisplaySprite
; ===========================================================================
; loc_A620: Obj23_Explode:
Missile_Explode:
		move.b	#ObjID_Fizzle,id(a0) ; load Obj24 (unused Buzz Bomber missile explosion)
		move.b	#0,routine(a0)
		bra.w	Obj24
; ===========================================================================
; loc_A630: Obj23_Delete:
Missile_Delete:
		bra.w	DeleteObject
; ===========================================================================
; loc_A634: Obj23_Newtron:
Missile_Newtron:
		tst.b	render_flags(a0)
		bpl.s	Missile_Delete
		bsr.w	ObjectMove
; loc_A63E: Obj23_Animate2:
Missile_Animate2:
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite

; ===========================================================================
; ---------------------------------------------------------------------------
; animation script - Buzz Bomber missile
; ---------------------------------------------------------------------------
include_Ani_Missile: macro
; Ani_obj23:
Ani_Missile:	dc.w byte_A662-Ani_Missile
		dc.w byte_A666-Ani_Missile
byte_A662:	dc.b   7,  0,  1,$FC
byte_A666:	dc.b   1,  2,  3,$FF
		even
		endm

; ---------------------------------------------------------------------------
; sprite mappings - Buzz Bomber missile
; ---------------------------------------------------------------------------
include_MapUnc_Missile: macro
; Map_obj23:
MapUnc_Missile:	incbin	"mappings/sprite/obj23.bin"
		nop
		endm