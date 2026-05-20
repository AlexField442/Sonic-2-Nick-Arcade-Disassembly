; ===========================================================================
; ---------------------------------------------------------------------------
; Object 50 - Skyhorse (seahorse badnik with rocket) (unused, but placeable in HPZ)
;
; Internal name: "skyhorse"
; ---------------------------------------------------------------------------
; OST:
skyhorse_origY:			equ seahorse_origY		; word
skyhorse_move_flag:		equ seahorse_move_flag		; byte ; I think this is what it does?
skyhorse_shooting_flag:		equ seahorse_shooting_flag	; byte
skyhorse_max_y:			equ $2E		; word
skyhorse_waiting_time:		equ $30		; word
skyhorse_range:			equ seahorse_range		; word
skyhorse_range2:		equ seahorse_range2		; word
skyhorse_unk:			equ $36		; byte
; ---------------------------------------------------------------------------
; Sprite_16524: Obj51:
Obj_Skyhorse:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Skyhorse_Index(pc,d0.w),d1
		jmp	Skyhorse_Index(pc,d1.w)
; ===========================================================================
; off_16532:
Skyhorse_Index:	dc.w Skyhorse_Init-Skyhorse_Index
		dc.w Skyhorse_Main-Skyhorse_Index
		dc.w Skyhorse_Bullet-Skyhorse_Index
		dc.w 0
		dc.w Seahorse_BulletFall-Skyhorse_Index
		dc.w Seahorse_CreateOil-Skyhorse_Index
; ===========================================================================
; loc_1653E:
Skyhorse_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_Seahorse,mappings(a0)
		move.w	#$2570,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#$A,collision_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#6,anim(a0)
		move.b	subtype(a0),d0
		andi.w	#$F,d0
		move.w	d0,d1
		lsl.w	#5,d1
		subq.w	#1,d1
		move.w	d1,skyhorse_range(a0)
		move.w	d1,skyhorse_range2(a0)
		move.w	y_pos(a0),skyhorse_origY(a0)
		move.w	y_pos(a0),skyhorse_max_y(a0)
		addi.w	#$60,skyhorse_max_y(a0)
		move.w	#-$100,x_vel(a0)
; loc_1659C:
Skyhorse_Main:
		lea	Ani_Seahorse(pc),a1
		bsr.w	JmpTo4_AnimateSprite
		move.w	#$39C,(Water_Level_1).w
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Skyhorse_Main_Index(pc,d0.w),d1
		jsr	Skyhorse_Main_Index(pc,d1.w)
		bra.w	JmpTo3_MarkObjGone
; ===========================================================================
; off_165BC:
Skyhorse_Main_Index:
		dc.w Skyhorse_Fly-Skyhorse_Main_Index
		dc.w Skyhorse_Attack-Skyhorse_Main_Index
; ===========================================================================
; loc_165C0:
Skyhorse_Bullet:
		bsr.w	Seahorse_ShootBullet2
		bsr.w	JmpTo5_ObjectMove
		lea	Ani_Seahorse(pc),a1
		bsr.w	JmpTo4_AnimateSprite
		bra.w	JmpTo3_MarkObjGone
; ===========================================================================
; loc_165D4:
Skyhorse_Fly:
		bsr.w	JmpTo5_ObjectMove
		bsr.w	Seahorse_CheckOrientation
		bsr.w	Skyhorse_FindPlayer
		bsr.w	Skyhorse_SeekPlayer
		bsr.w	Skyhorse_ChkShoot
		rts
; ===========================================================================
; loc_165EA:
Skyhorse_Attack:
		bsr.w	JmpTo5_ObjectMove
		bsr.w	Seahorse_CheckOrientation
		bsr.w	Skyhorse_FindPlayer
		bsr.w	Skyhorse_SeekPlayer
		bsr.w	loc_16600
		rts
; ===========================================================================

loc_16600:
		subq.w	#1,skyhorse_waiting_time(a0)
		beq.s	loc_16614
		move.w	skyhorse_waiting_time(a0),d0
		cmpi.w	#$12,d0
		beq.w	Skyhorse_Shoot
		rts
; ===========================================================================

loc_16614:
		subq.b	#2,routine_secondary(a0)
		move.b	#6,anim(a0)
		move.w	#$B4,skyhorse_waiting_time(a0)
		rts
; ===========================================================================
; loc_16626:
Skyhorse_FindPlayer:
		sf	skyhorse_shooting_flag(a0)
		sf	skyhorse_move_flag(a0)
		sf	skyhorse_unk(a0)
		move.w	(MainCharacter+x_pos).w,d0
		sub.w	x_pos(a0),d0
		bpl.s	.playerisleft
		btst	#0,status(a0)
		bne.s	loc_1664E
		bra.s	loc_16652
; ===========================================================================
; loc_16646:
.playerisleft:
		btst	#0,status(a0)
		bne.s	loc_16652

loc_1664E:
		st	skyhorse_move_flag(a0)

loc_16652:
		move.w	(MainCharacter+y_pos).w,d0
		sub.w	y_pos(a0),d0
		cmpi.w	#-4,d0
		blt.s	locret_16676
		cmpi.w	#4,d0
		bgt.s	loc_16672
		st	skyhorse_shooting_flag(a0)
		move.w	#0,y_vel(a0)
		rts
; ===========================================================================

loc_16672:
		st	skyhorse_unk(a0)

locret_16676:
		rts
; ===========================================================================
; loc_16678:
Skyhorse_ChkShoot:
		tst.b	skyhorse_move_flag(a0)
		bne.s	locret_1669C
		subq.w	#1,skyhorse_waiting_time(a0)
		bgt.s	locret_1669C
		tst.b	skyhorse_shooting_flag(a0)
		beq.s	locret_1669C
		move.b	#7,anim(a0)
		move.w	#$24,skyhorse_waiting_time(a0)
		addi.b	#2,routine_secondary(a0)

locret_1669C:
		rts
; ===========================================================================
; loc_1669E:
Skyhorse_Shoot:
		bsr.w	JmpTo_AllocateObject
		bne.s	locret_16706
		move.b	#ObjID_Skyhorse,id(a1)
		move.b	#4,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	#MapUnc_Seahorse,mappings(a1)
		move.w	#$24E0,art_tile(a1)
		ori.b	#4,render_flags(a1)
		move.b	#3,priority(a1)
		move.b	#2,anim(a1)
		move.b	#$E5,collision_flags(a1)
		move.w	#$C,d0
		move.w	#$10,d1
		move.w	#-$300,d2
		btst	#0,status(a0)
		beq.s	loc_166FA
		neg.w	d1
		neg.w	d2

loc_166FA:
		sub.w	d0,y_pos(a1)
		sub.w	d1,x_pos(a1)
		move.w	d2,x_vel(a1)

locret_16706:
		rts
; ===========================================================================
; loc_16708:
Skyhorse_SeekPlayer:
		tst.b	skyhorse_shooting_flag(a0)
		bne.s	locret_16766
		tst.b	skyhorse_unk(a0)
		beq.s	loc_16738
		move.w	skyhorse_max_y(a0),d0
		cmp.w	y_pos(a0),d0
		ble.s	loc_1675C
		tst.b	skyhorse_move_flag(a0)
		beq.s	.playerabove
		move.w	skyhorse_origY(a0),d0
		cmp.w	y_pos(a0),d0
		bge.s	loc_1675C
		rts
; ===========================================================================
; loc_16730:
.playerabove:
		move.w	#$180,y_vel(a0)
		rts
; ===========================================================================

loc_16738:
		move.w	skyhorse_origY(a0),d0
		cmp.w	y_pos(a0),d0
		bge.s	loc_1675C
		tst.b	skyhorse_move_flag(a0)
		beq.s	.playerbelow
		move.w	skyhorse_max_y(a0),d0
		cmp.w	y_pos(a0),d0
		ble.s	loc_1675C
		rts
; ===========================================================================
; loc_16754:
.playerbelow:
		move.w	#-$180,y_vel(a0)
		rts
; ===========================================================================

loc_1675C:
		move.w	d0,y_pos(a0)
		move.w	#0,y_vel(a0)

locret_16766:
		rts