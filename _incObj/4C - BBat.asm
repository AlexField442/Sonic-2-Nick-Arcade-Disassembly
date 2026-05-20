; ===========================================================================
; ---------------------------------------------------------------------------
; Object 4C - BBat (bat badnik from HPZ)
;
; Internal name: "bbat"
; ---------------------------------------------------------------------------
; OST:
bbat_timer:			equ $2A		; word
bbat_detection_timer:		equ $2C		; word ; time until BBat detects the player
bbat_orig_y:			equ $2E		; word
bbat_orientation:		equ $3D		; byte
bbat_unk1:			equ $3E		; byte
bbat_unk2:			equ $3F		; byte ; has something to do with the arc
; ---------------------------------------------------------------------------
; Sprite_16D50: Obj4C:
Obj_BBat:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BBat_Index(pc,d0.w),d1
		jmp	BBat_Index(pc,d1.w)
; ===========================================================================
; off_16D5E: Obj4C_Index:
BBat_Index:	dc.w BBat_Init-BBat_Index
		dc.w BBat_Main-BBat_Index
		dc.w BBat_Attack-BBat_Index
; ===========================================================================
; loc_16D64: Obj4C_Init:
BBat_Init:
		move.l	#MapUnc_BBat,mappings(a0)
		; This should actually be using palette line 0! As a result,
		; the flame and inner ears look quite odd. This was never fixed
		; before it was removed from the game.
		move.w	#$2530,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#$A,collision_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		move.b	#8,x_radius(a0)
		addq.b	#2,routine(a0)
		move.w	y_pos(a0),bbat_orig_y(a0)
		rts
; ===========================================================================
; loc_16DA2:
BBat_Main:
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	BBat_Main_Index(pc,d0.w),d1
		jsr	BBat_Main_Index(pc,d1.w)
		bsr.w	BBat_CalculateArc
		lea	(Ani_BBat).l,a1
		bsr.w	JmpTo7_AnimateSprite
		bra.w	JmpTo5_MarkObjGone
; ===========================================================================
; off_16D62: Obj4C_SubIndex:
BBat_Main_Index:
		dc.w BBat_Wait-BBat_Main_Index
		dc.w BBat_Flapping-BBat_Main_Index
		dc.w BBat_SeekPlayer-BBat_Main_Index

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine for BBat to calculate how its arc should go
; ---------------------------------------------------------------------------
; sub_16DC8:
BBat_CalculateArc:
		move.b	bbat_unk2(a0),d0
		jsr	(CalcSine).l
		asr.w	#6,d0
		add.w	bbat_orig_y(a0),d0
		move.w	d0,y_pos(a0)
		addq.b	#4,bbat_unk2(a0)
		rts
; End of function BBat_CalculateArc

; ---------------------------------------------------------------------------
; Subroutine for the BBat to wait for the player to appear
; ---------------------------------------------------------------------------
; sub_16DE2:
BBat_WaitForPlayer:
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		; Check if player is within 128 pixels of BBat
		cmpi.w	#$80,d0
		bgt.s	locret_16E0E
		cmpi.w	#-$80,d0
		blt.s	locret_16E0E
		move.b	#4,routine_secondary(a0)
		move.b	#2,anim(a0)
		move.w	#8,bbat_timer(a0)
		move.b	#0,bbat_unk1(a0)

locret_16E0E:
		rts
; End of function BBat_WaitForPlayer

; ===========================================================================
; loc_16E10:
BBat_Attack:
		bsr.w	BBat_Move
		bsr.w	BBat_ArcMotion
		bsr.w	BBat_TurnAround
		bsr.w	JmpTo7_ObjectMove
		lea	(Ani_BBat).l,a1
		bsr.w	JmpTo7_AnimateSprite
		bra.w	JmpTo5_MarkObjGone
; ---------------------------------------------------------------------------
		rts
; ===========================================================================
; sub_16E30:
BBat_TurnAround:
		tst.b	bbat_orientation(a0)
		beq.s	locret_16E42
		bset	#0,render_flags(a0)
		bset	#0,status(a0)

locret_16E42:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine for BBat to wait some time while the player is near before moving
; ---------------------------------------------------------------------------
; sub_16E44:
BBat_AttackPlayer:
		subi.w	#1,bbat_detection_timer(a0)
		bpl.s	locret_16E8E
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		; Check if player is within 96 pixels of BBat
		cmpi.w	#$60,d0
		bgt.s	BBat_PlayerOutOfRange
		cmpi.w	#-$60,d0
		blt.s	BBat_PlayerOutOfRange
		tst.w	d0
		bpl.s	loc_16E68
		st	bbat_orientation(a0)

loc_16E68:
		move.b	#$40,bbat_unk2(a0)
		move.w	#$400,inertia(a0)
		move.b	#4,routine(a0)
		move.b	#3,anim(a0)
		move.w	#$C,bbat_timer(a0)
		move.b	#1,bbat_unk1(a0)
		moveq	#0,d0

locret_16E8E:
		rts
; ===========================================================================
; If the player has exited its detection range, resume idle behavior.
; loc_16E90:
BBat_PlayerOutOfRange:
		cmpi.w	#$80,d0
		bgt.s	loc_16E9C
		cmpi.w	#-$80,d0
		bgt.s	locret_16E8E

loc_16E9C:
		move.b	#1,anim(a0)
		move.b	#0,routine_secondary(a0)
		move.w	#$18,bbat_timer(a0)
		rts
; End of function BBat_AttackPlayer

; ---------------------------------------------------------------------------
; Subroutine to apply an arc-like motion to the BBat's movement
; ---------------------------------------------------------------------------
; sub_16EB0:
BBat_ArcMotion:
		tst.b	bbat_orientation(a0)
		bne.s	loc_16ECA
		moveq	#0,d0
		move.b	bbat_unk2(a0),d0
		cmpi.w	#$C0,d0
		bge.s	loc_16EDE
		addq.b	#2,d0
		move.b	d0,bbat_unk2(a0)
		rts
; ===========================================================================

loc_16ECA:
		moveq	#0,d0
		move.b	bbat_unk2(a0),d0
		cmpi.w	#$C0,d0
		beq.s	loc_16EDE
		subq.b	#2,d0
		move.b	d0,bbat_unk2(a0)
		rts
; ===========================================================================

loc_16EDE:
		sf	bbat_orientation(a0)
		move.b	#0,anim(a0)
		move.b	#2,routine(a0)
		move.b	#0,routine_secondary(a0)
		move.w	#$18,bbat_timer(a0)
		move.b	#1,anim(a0)
		bclr	#0,render_flags(a0)
		bclr	#0,status(a0)
		rts
; End of function BBat_ArcMotion

; ---------------------------------------------------------------------------
; Subroutine for the BBat to start moving downwards
; ---------------------------------------------------------------------------
; sub_16F0E:
BBat_Move:
		move.b	bbat_unk2(a0),d0
		jsr	(CalcSine).l
		muls.w	inertia(a0),d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	inertia(a0),d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		rts
; End of function BBat_Move

; ===========================================================================
; loc_16F2E:
BBat_Wait:
		subi.w	#1,bbat_timer(a0)
		bpl.s	locret_16F64
		bsr.w	BBat_WaitForPlayer
		beq.s	locret_16F64
		jsr	(RandomNumber).l
		andi.b	#$FF,d0
		bne.s	locret_16F64
		move.w	#$18,bbat_timer(a0)
		move.w	#$1E,bbat_detection_timer(a0)
		addq.b	#2,routine_secondary(a0)
		move.b	#1,anim(a0)
		move.b	#0,bbat_unk1(a0)

locret_16F64:
		rts
; ===========================================================================
; loc_16F66:
BBat_Flapping:
		subq.b	#1,bbat_timer(a0)
		bpl.s	locret_16F70
		subq.b	#2,routine_secondary(a0)

locret_16F70:
		rts
; ===========================================================================
; loc_16F72:
BBat_SeekPlayer:
		bsr.w	BBat_AttackPlayer
		beq.s	locret_16FB8
		subi.w	#1,bbat_timer(a0)
		bne.s	locret_16FB8
		move.b	bbat_unk1(a0),d0
		beq.s	loc_16FA0
		move.b	#0,bbat_unk1(a0)
		move.w	#8,bbat_timer(a0)
		bset	#0,render_flags(a0)
		bset	#0,status(a0)
		rts
; ===========================================================================

loc_16FA0:
		move.b	#1,bbat_unk1(a0)
		move.w	#$C,bbat_timer(a0)
		bclr	#0,render_flags(a0)
		bclr	#0,status(a0)

locret_16FB8:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; animation scripts
; ---------------------------------------------------------------------------
; Ani_Obj4C:
Ani_BBat:	dc.w byte_16FC2-Ani_BBat
		dc.w byte_16FC6-Ani_BBat
		dc.w byte_16FD5-Ani_BBat
		dc.w byte_16FE6-Ani_BBat
byte_16FC2:	dc.b   1,  0,  5,$FF
byte_16FC6:	dc.b   1,  1,  6,  1,  6,  2,  7,  2,  7,  1,  6,  1,  6,$FD,  0
byte_16FD5:	dc.b   1,  1,  6,  1,  6,  2,  7,  3,  8,  4,  9,  4,  9,  3,  8,$FE
		dc.b  $A
byte_16FE6:	dc.b   3, $A, $B, $C, $D, $E,$FF
		even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj4C:
MapUnc_BBat:	include	"mappings/sprite/Badniks - BBat.asm"
		align 4