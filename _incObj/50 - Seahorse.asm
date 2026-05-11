; ===========================================================================
; ---------------------------------------------------------------------------
; Object 50 - Unused seahorse badnik from HPZ (reworked into Aquis in final)
;
; Internal name: "seahorse"
; ---------------------------------------------------------------------------
; OST:
seahorse_unk1:			equ $2A		; word
seahorse_unk2:			equ $2C		; byte
seahorse_shootingflag:		equ $2D		; byte
seahorse_shotsremaining:	equ $2E		; word
seahorse_totalshots:		equ $30		; word
seahorse_range:			equ $32		; word ; range the Seahorse can move(?)
seahorse_range2:		equ $34		; word ; not sure, seems to reset seahorse_range
seahorse_child:			equ $36		; long ; pointer to wing object
seahorse_parent:		equ $36		; long ; pointer to main object
; ---------------------------------------------------------------------------
; Sprite_15F08: Obj50:
Obj_Seahorse:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Seahorse_Index(pc,d0.w),d1
		jmp	Seahorse_Index(pc,d1.w)
; ===========================================================================
; off_15F16: Obj50_Index:
Seahorse_Index:	dc.w Seahorse_Init-Seahorse_Index
		dc.w Seahorse_Main-Seahorse_Index
		dc.w Seahorse_Wing-Seahorse_Index
		dc.w Seahorse_Bullet-Seahorse_Index
		dc.w Seahorse_Routine08-Seahorse_Index
		dc.w Seahorse_Routine0A-Seahorse_Index
; ===========================================================================
; loc_15F22: Obj50_Init:
Seahorse_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_Seahorse,mappings(a0)
		move.w	#$2570,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#$A,collision_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.w	#$FF00,x_vel(a0)
		; How subtype works in this instance is that:
		; - The upper 4 bits is (256 * X) frames of time until Seahorse fires.
		; - The lower 4 bits is (16 * X) pixels Seahorse can move.
		; This block is still in the final, but useless due to the behavior
		; being completely reworked.
		move.b	subtype(a0),d0
		move.b	d0,d1
		andi.w	#$F0,d1
		lsl.w	#4,d1
		move.w	d1,seahorse_shotsremaining(a0)
		move.w	d1,seahorse_totalshots(a0)
		andi.w	#$F,d0
		lsl.w	#4,d0
		subq.w	#1,d0
		move.w	d0,seahorse_range(a0)
		move.w	d0,seahorse_range2(a0)
		move.w	y_pos(a0),seahorse_unk1(a0)

		; create Seahorse wing object
		bsr.w	j_AllocateObject
		bne.s	Seahorse_Main
		move.b	#ObjID_Seahorse,id(a1)
		move.b	#4,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		addi.w	#$A,x_pos(a1)
		addi.w	#-6,y_pos(a1)
		move.l	#MapUnc_Seahorse,mappings(a1)
		move.w	#$24E0,art_tile(a1)
		ori.b	#4,render_flags(a1)
		move.b	#3,priority(a1)
		move.b	status(a0),status(a1)
		move.b	#3,anim(a1)
		move.l	a1,seahorse_child(a0)
		move.l	a0,seahorse_parent(a1)
		bset	#6,status(a0)
; loc_15FDA:
Seahorse_Main:
		lea	(Ani_Seahorse).l,a1
		bsr.w	j_AnimateSprite_3
		move.w	#$39C,(Water_Level_1).w
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Seahorse_SubIndex(pc,d0.w),d1
		jsr	Seahorse_SubIndex(pc,d1.w)
		bsr.w	sub_161D8
		bra.w	loc_1677A
; ===========================================================================
; Obj50_SubIndex:
Seahorse_SubIndex:
		dc.w loc_16046-Seahorse_SubIndex
		dc.w loc_16058-Seahorse_SubIndex
		dc.w Seahorse_Shooting-Seahorse_SubIndex
; ===========================================================================
; loc_16006:
Seahorse_Wing:
		movea.l	seahorse_parent(a0),a1
		; This check is redundant.
		tst.b	(a1)
		beq.w	loc_1676E
		cmpi.b	#ObjID_Seahorse,(a1)
		bne.w	loc_1676E
		btst	#7,status(a1)
		bne.w	loc_1676E
		lea	(Ani_Seahorse).l,a1
		bsr.w	j_AnimateSprite_3
		bra.w	loc_16768
; ===========================================================================
; loc_16030:
Seahorse_Bullet:
		bsr.w	loc_162FC
		bsr.w	j_ObjectMove_4
		lea	(Ani_Seahorse).l,a1
		bsr.w	j_AnimateSprite_3
		bra.w	loc_1677A
; ===========================================================================

loc_16046:
		bsr.w	j_ObjectMove_4
		bsr.w	sub_162DE
		bsr.w	sub_16184
		bsr.w	sub_1611C
		rts
; ===========================================================================

loc_16058:
		bsr.w	j_ObjectMove_4
		bsr.w	sub_162DE
		bsr.w	sub_161A6
		rts
; ===========================================================================
; loc_16066:
Seahorse_Shooting:
		bsr.w	j_ObjectMoveAndFall_2
		bsr.w	sub_162DE
		bsr.w	Seahorse_ChkIfShoot
		bsr.w	sub_160F4
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ

; sub_16078:
Seahorse_ChkIfShoot:
		tst.b	seahorse_shootingflag(a0)
		bne.s	locret_16084
		tst.w	y_vel(a0)
		bpl.s	Seahorse_ShootBullet

locret_16084:
		rts
; ===========================================================================
; loc_16086:
Seahorse_ShootBullet:
		st	seahorse_shootingflag(a0)

		; create bullet object
		bsr.w	j_AllocateObject
		bne.s	locret_160F2
		move.b	#ObjID_Seahorse,id(a1)
		move.b	#6,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	#MapUnc_Seahorse,mappings(a1)
		move.w	#$24E0,art_tile(a1)
		ori.b	#4,render_flags(a1)
		move.b	#3,priority(a1)
		move.b	#$E5,collision_flags(a1)
		move.b	#2,anim(a1)
		move.w	#$C,d0
		move.w	#$10,d1
		move.w	#-$300,d2
		btst	#0,status(a0)
		beq.s	loc_160E6
		neg.w	d1
		neg.w	d2

loc_160E6:
		sub.w	d0,y_pos(a1)
		sub.w	d1,x_pos(a1)
		move.w	d2,x_vel(a1)

locret_160F2:
		rts
; End of function Seahorse_ChkIfShoot


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_160F4:
		move.w	y_pos(a0),d0
		cmp.w	(Water_Level_1).w,d0
		blt.s	locret_1611A
		move.b	#2,routine_secondary(a0)
		move.b	#0,anim(a0)
		move.w	seahorse_totalshots(a0),seahorse_shotsremaining(a0)
		move.w	#$40,y_vel(a0)
		sf	seahorse_shootingflag(a0)

locret_1611A:
		rts
; End of function sub_160F4


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_1611C:
		tst.b	seahorse_unk2(a0)
		beq.s	locret_16182
		move.w	(MainCharacter+x_pos).w,d0
		move.w	(MainCharacter+y_pos).w,d1
		sub.w	y_pos(a0),d1
		bpl.s	locret_16182
		cmpi.w	#-$30,d1
		blt.s	locret_16182
		sub.w	x_pos(a0),d0
		cmpi.w	#$48,d0
		bgt.s	locret_16182
		cmpi.w	#-$48,d0
		blt.s	locret_16182
		tst.w	d0
		bpl.s	loc_1615A
		cmpi.w	#-$28,d0
		bgt.s	locret_16182
		btst	#0,status(a0)
		bne.s	locret_16182
		bra.s	loc_16168
; ===========================================================================

loc_1615A:
		cmpi.w	#$28,d0
		blt.s	locret_16182
		btst	#0,status(a0)
		beq.s	locret_16182

loc_16168:
		moveq	#$20,d0
		cmp.w	seahorse_range(a0),d0
		bgt.s	locret_16182
		move.b	#4,routine_secondary(a0)
		move.b	#1,anim(a0)
		move.w	#-$400,y_vel(a0)

locret_16182:
		rts
; End of function sub_1611C


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_16184:
		subq.w	#1,seahorse_shotsremaining(a0)
		bne.s	locret_161A4
		move.w	seahorse_totalshots(a0),seahorse_shotsremaining(a0)
		addq.b	#2,routine_secondary(a0)
		move.w	#-$40,d0
		tst.b	seahorse_unk2(a0)
		beq.s	loc_161A0
		neg.w	d0

loc_161A0:
		move.w	d0,y_vel(a0)

locret_161A4:
		rts
; End of function sub_16184


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_161A6:
		move.w	y_pos(a0),d0
		tst.b	seahorse_unk2(a0)
		bne.s	loc_161C4
		cmp.w	(Water_Level_1).w,d0
		bgt.s	locret_161C2
		subq.b	#2,routine_secondary(a0)
		st	seahorse_unk2(a0)
		clr.w	y_vel(a0)

locret_161C2:
		rts
; ===========================================================================

loc_161C4:
		cmp.w	seahorse_unk1(a0),d0
		blt.s	locret_161C2
		subq.b	#2,routine_secondary(a0)
		sf	seahorse_unk2(a0)
		clr.w	y_vel(a0)
		rts
; End of function sub_161A6


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_161D8:
		moveq	#$A,d0
		moveq	#-6,d1
		movea.l	seahorse_child(a0),a1
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	status(a0),status(a1)
		move.b	respawn_index(a0),respawn_index(a1)
		move.b	render_flags(a0),render_flags(a1)
		btst	#0,status(a1)
		beq.s	loc_16208
		neg.w	d0

loc_16208:
		add.w	d0,x_pos(a1)
		add.w	d1,y_pos(a1)
		rts
; End of function sub_161D8

; ===========================================================================
; Obj50_Routine08:
Seahorse_Routine08:
		bsr.w	j_ObjectMoveAndFall_2
		bsr.w	sub_16228
		lea	(Ani_Seahorse).l,a1
		bsr.w	j_AnimateSprite_3
		bra.w	loc_1677A

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_16228:
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_16242
		add.w	d1,y_pos(a0)
		move.w	y_vel(a0),d0
		asr.w	#1,d0
		neg.w	d0
		move.w	d0,y_vel(a0)

loc_16242:
		subi.b	#1,collision_property(a0)
		beq.w	loc_1676E
		rts
; End of function sub_16228

; ===========================================================================
; Obj50_Routine0A:
Seahorse_Routine0A:
		bsr.w	sub_1629E
		tst.b	routine_secondary(a0)
		beq.s	locret_1628E
		subi.w	#1,seahorse_unk2(a0)
		beq.w	loc_1676E
		move.w	(MainCharacter+x_pos).w,x_pos(a0)
		move.w	(MainCharacter+y_pos).w,y_pos(a0)
		addi.w	#$C,y_pos(a0)
		subi.b	#1,seahorse_unk1(a0)
		bne.s	loc_16290
		move.b	#3,seahorse_unk1(a0)
		bchg	#0,status(a0)
		bchg	#0,render_flags(a0)

locret_1628E:
		rts
; ===========================================================================

loc_16290:
		lea	(Ani_Seahorse).l,a1
		bsr.w	j_AnimateSprite_3
		bra.w	loc_16768

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_1629E:
		tst.b	routine_secondary(a0)
		bne.s	locret_162DC
		move.b	(MainCharacter+routine).w,d0
		cmpi.b	#2,d0
		bne.s	locret_162DC
		move.w	(MainCharacter+x_pos).w,x_pos(a0)
		move.w	(MainCharacter+y_pos).w,y_pos(a0)
		ori.b	#4,render_flags(a0)
		move.b	#1,priority(a0)
		move.b	#5,anim(a0)
		st	routine_secondary(a0)
		move.w	#$12C,seahorse_unk2(a0)
		move.b	#3,seahorse_unk1(a0)

locret_162DC:
		rts
; End of function sub_1629E


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_162DE:
		subq.w	#1,seahorse_range(a0)
		bpl.s	locret_162FA
		move.w	seahorse_range2(a0),seahorse_range(a0)
		neg.w	x_vel(a0)
		bchg	#0,status(a0)
		move.b	#1,prev_anim(a0)

locret_162FA:
		rts
; End of function sub_162DE

; ===========================================================================

loc_162FC:
		tst.b	collision_property(a0)
		beq.w	locret_1639E
		moveq	#2,d3

loc_16306:
		bsr.w	j_AllocateObject
		bne.s	loc_16378
		move.b	id(a0),id(a1)
		move.b	#8,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	#$24E0,art_tile(a1)
		ori.b	#4,render_flags(a1)
		move.b	#3,priority(a1)
		move.w	#-$100,y_vel(a1)
		move.b	#4,anim(a1)
		move.b	#$78,collision_property(a1)
		cmpi.w	#1,d3
		beq.s	loc_16372
		blt.s	loc_16364
		move.w	#$C0,x_vel(a1)
		addi.w	#-$C0,y_vel(a1)
		bra.s	loc_16378
; ===========================================================================

loc_16364:
		move.w	#-$100,x_vel(a1)
		addi.w	#-$40,y_vel(a1)
		bra.s	loc_16378
; ===========================================================================

loc_16372:
		move.w	#$40,x_vel(a1)

loc_16378:
		dbf	d3,loc_16306
		bsr.w	j_AllocateObject
		bne.s	loc_1639A
		move.b	id(a0),id(a1)
		move.b	#$A,routine(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	#$24E0,art_tile(a1)

loc_1639A:
		bra.w	loc_1676E
; ===========================================================================

locret_1639E:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; animation script
; ---------------------------------------------------------------------------
; Ani_Obj50:
Ani_Seahorse:	dc.w byte_163B0-Ani_Seahorse
		dc.w byte_163B3-Ani_Seahorse
		dc.w byte_163BB-Ani_Seahorse
		dc.w byte_163C1-Ani_Seahorse
		dc.w byte_163C5-Ani_Seahorse
		dc.w byte_163C8-Ani_Seahorse
		dc.w byte_163CB-Ani_Seahorse
		dc.w byte_163CF-Ani_Seahorse
byte_163B0:	dc.b  $E,  0,$FF
byte_163B3:	dc.b   5,  3,  4,  3,  4,  3,  4,$FF
byte_163BB:	dc.b   3,  5,  6,  7,  6,$FF
byte_163C1:	dc.b   3,  1,  2,$FF
byte_163C5:	dc.b   1,  5,$FF
byte_163C8:	dc.b  $E,  8,$FF
byte_163CB:	dc.b   1,  9, $A,$FF
byte_163CF:	dc.b   5, $B, $C, $B, $C, $B, $C,$FF
		even

; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj50:
MapUnc_Seahorse:	include	"mappings/sprite/Badniks - Seahorse & Skyhorse.asm"