; ===========================================================================
; ---------------------------------------------------------------------------
; Object 4A - Octus (octopus badnik) (unused, but placeable in HPZ)
;
; Internal name: "oct"
; ---------------------------------------------------------------------------
; OST:
octus_start_position:		equ $2A		; word
octus_timer:			equ $2C		; word ; general timer
; ---------------------------------------------------------------------------
; Sprite_16AA0: Obj4A:
Obj_Octus:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Octus_Index(pc,d0.w),d1
		jmp	Octus_Index(pc,d1.w)
; ===========================================================================
; off_16AAE: Obj4A_Index:
Octus_Index:	dc.w Octus_Init-Octus_Index
		dc.w Octus_Main-Octus_Index
		dc.w Octus_Angry-Octus_Index
		dc.w Octus_Bullet-Octus_Index
; ===========================================================================
; loc_16AB6:
Octus_Bullet:
		subi.w	#1,octus_timer(a0)
		bmi.s	loc_16AC0
		rts
; ===========================================================================

loc_16AC0:
		; Unlike the final, the bullet is affected by gravity.
		bsr.w	JmpTo5_ObjectMoveAndFall
		lea	(Ani_Octus).l,a1
		bsr.w	JmpTo6_AnimateSprite
		bra.w	JmpTo4_MarkObjGone
; ===========================================================================
; loc_16AD2:
Octus_Angry:
		; An angry head for Octus. This is still in the final, but
		; goes unused since the code to create it was removed.
		subq.w	#1,octus_timer(a0)
		beq.w	JmpTo7_DeleteObject
		bra.w	JmpTo6_DisplaySprite
; ===========================================================================
; loc_16ADE:
Octus_Init:
		move.l	#MapUnc_Octus,mappings(a0)
		move.w	#$238A,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#$A,collision_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		move.b	#8,x_radius(a0)
		bsr.w	JmpTo5_ObjectMoveAndFall
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_16B3C
		add.w	d1,y_pos(a0)
		move.w	#0,y_vel(a0)
		addq.b	#2,routine(a0)
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		bpl.s	loc_16B3C
		bchg	#0,status(a0)

loc_16B3C:
		move.w	y_pos(a0),octus_start_position(a0)
		rts
; ===========================================================================
; loc_16B44:
Octus_Main:
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Octus_Main_Index(pc,d0.w),d1
		jsr	Octus_Main_Index(pc,d1.w)
		lea	(Ani_Octus).l,a1
		bsr.w	JmpTo6_AnimateSprite
		bra.w	JmpTo4_MarkObjGone
; ===========================================================================
; off_16B60: Obj4A_SubIndex: Octus_SubIndex:
Octus_Main_Index:
		dc.w Octus_WaitForCharacter-Octus_Main_Index
		dc.w Octus_MoveUp-Octus_Main_Index
		dc.w Octus_Hover-Octus_Main_Index
		dc.w Octus_FlyAway-Octus_Main_Index
; ===========================================================================
; loc_16B68: Obj4A_Init:
Octus_WaitForCharacter:
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		cmpi.w	#$80,d0
		bgt.s	locret_16B86
		cmpi.w	#-$80,d0
		blt.s	locret_16B86
		addq.b	#2,routine_secondary(a0)
		move.b	#1,anim(a0)

locret_16B86:
		rts
; ===========================================================================
; loc_16B88: Obj4A_Main:
Octus_MoveUp:
		subi.l	#$18000,y_pos(a0)	; ??? Why you like this STI?
		move.w	octus_start_position(a0),d0
		sub.w	y_pos(a0),d0
		cmpi.w	#$20,d0
		ble.s	locret_16BA8
		addq.b	#2,routine_secondary(a0)
		move.w	#0,octus_timer(a0)

locret_16BA8:
		rts
; ===========================================================================
; loc_16BAA:
Octus_Hover:
		subi.w	#1,octus_timer(a0)
		beq.w	loc_16C76
		bpl.w	locret_16C74
		move.w	#$1E,octus_timer(a0)

		; create angry Octus head
		jsr	(AllocateObject).l
		bne.s	Octus_FireBullet
		move.b	#ObjID_Octus,id(a1)
		move.b	#4,routine(a1)
		move.l	#MapUnc_Octus,mappings(a1)
		move.b	#4,mapping_frame(a1)
		move.w	#$24C6,art_tile(a1)
		move.b	#3,priority(a1)
		move.b	#$10,width_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	#$1E,octus_timer(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	status(a0),status(a1)
; loc_16C10:
Octus_FireBullet:
		; create Octus bullet
		jsr	(AllocateObject).l
		bne.s	locret_16C74
		move.b	#ObjID_Octus,id(a1)
		move.b	#6,routine(a1)
		move.l	#MapUnc_Octus,mappings(a1)
		move.w	#$24C6,art_tile(a1)
		move.b	#4,priority(a1)
		move.b	#$10,width_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	#$F,octus_timer(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	status(a0),status(a1)
		move.b	#2,anim(a1)
		move.w	#-$580,x_vel(a1)
		btst	#0,render_flags(a1)
		beq.s	locret_16C74
		neg.w	x_vel(a1)

locret_16C74:
		rts
; ===========================================================================

loc_16C76:
		addq.b	#2,routine_secondary(a0)
		rts
; ===========================================================================
; loc_16C7C:
Octus_FlyAway:
		move.w	#-6,d0
		btst	#0,render_flags(a0)
		beq.s	loc_16C8A
		neg.w	d0

loc_16C8A:
		add.w	d0,x_pos(a0)
		bra.w	JmpTo4_MarkObjGone
; ===========================================================================
; ---------------------------------------------------------------------------
; animation scripts
; ---------------------------------------------------------------------------
; Ani_Obj4A:
Ani_Octus:	dc.w byte_16C98-Ani_Octus
		dc.w byte_16C9B-Ani_Octus
		dc.w byte_16CA0-Ani_Octus
byte_16C98:	dc.b  $F,  0,$FF
byte_16C9B:	dc.b   3,  1,  2,  3,$FF
byte_16CA0:	dc.b   2,  5,  6,$FF
		even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj4A:
MapUnc_Octus:	include	"mappings/sprite/Badniks - Octus.asm"