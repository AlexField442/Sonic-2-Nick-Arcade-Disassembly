; ===========================================================================
; ---------------------------------------------------------------------------
; Object 52 - BFish (piranha badnik) (unused, but placeable in HPZ)
;
; Internal name: "bfish"
; ---------------------------------------------------------------------------
; OST:
bfish_biting_flag:		equ $2A		; byte
bfish_unk1:			equ $30		; word
bfish_unk2:			equ $32		; word
bfish_start_position:		equ $34		; word
bfish_speed:			equ $36		; long-word
bfish_wait_timer:		equ $3A		; word
bfish_reset_timer:		equ $3C		; word ; stores a copy of bfish_wait_timer
bfish_unk3:			equ $3E		; word
; ---------------------------------------------------------------------------
; Sprite_15B4C: Obj52:
Obj_BFish:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BFish_Index(pc,d0.w),d1
		jmp	BFish_Index(pc,d1.w)
; ===========================================================================
; off_15B5A: Obj52_Index:
BFish_Index:	dc.w BFish_Init-BFish_Index
		dc.w BFish_Main-BFish_Index
		dc.w BFish_Jumping-BFish_Index
; ===========================================================================
; loc_15B60: Obj52_Init:
BFish_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_BFish,mappings(a0)
		move.w	#$2530,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#$A,collision_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.b	d0,d1
		andi.w	#$F0,d1
		add.w	d1,d1
		add.w	d1,d1
		move.w	d1,bfish_wait_timer(a0)
		move.w	d1,bfish_reset_timer(a0)
		andi.w	#$F,d0
		lsl.w	#6,d0
		subq.w	#1,d0
		move.w	d0,bfish_unk1(a0)
		move.w	d0,bfish_unk2(a0)
		move.w	#-$80,x_vel(a0)
		move.l	#$FFFB8000,bfish_speed(a0)
		move.w	y_pos(a0),bfish_start_position(a0)
		bset	#6,status(a0)
		btst	#0,status(a0)
		beq.s	BFish_Main
		neg.w	x_vel(a0)
; loc_15BD8: Obj52_Main:
BFish_Main:
		cmpi.w	#-1,bfish_wait_timer(a0)
		beq.s	loc_15BE4
		subq.w	#1,bfish_wait_timer(a0)

loc_15BE4:
		subq.w	#1,bfish_unk1(a0)
		bpl.s	loc_15C06
		move.w	bfish_unk2(a0),bfish_unk1(a0)
		neg.w	x_vel(a0)
		bchg	#0,status(a0)
		move.b	#1,prev_anim(a0)
		move.w	bfish_reset_timer(a0),bfish_wait_timer(a0)

loc_15C06:
		lea	(Ani_BFish).l,a1
		bsr.w	JmpTo2_AnimateSprite
		bsr.w	JmpTo3_ObjectMove
		tst.w	bfish_wait_timer(a0)
		bgt.w	JmpTo2_MarkObjGone
		cmpi.w	#-1,bfish_wait_timer(a0)
		beq.w	JmpTo2_MarkObjGone
		move.l	#$FFFB8000,bfish_speed(a0)
		addq.b	#2,routine(a0)
		move.w	#-1,bfish_wait_timer(a0)
		move.b	#2,anim(a0)
		move.w	#1,bfish_unk3(a0)
		bra.w	JmpTo2_MarkObjGone
; ===========================================================================
; loc_15C48:
BFish_Jumping:
		move.w	#$390,(Water_Level_1).w
		lea	(Ani_BFish).l,a1
		bsr.w	JmpTo2_AnimateSprite
		move.w	bfish_unk3(a0),d0
		sub.w	d0,bfish_unk1(a0)
		bsr.w	BFish_Move
		tst.l	bfish_speed(a0)
		bpl.s	BFish_WaterLevel
		move.w	y_pos(a0),d0
		cmp.w	(Water_Level_1).w,d0
		bgt.w	JmpTo2_MarkObjGone
		move.b	#3,anim(a0)
		bclr	#6,status(a0)
		tst.b	bfish_biting_flag(a0)
		bne.w	JmpTo2_MarkObjGone
		move.w	x_vel(a0),d0
		asl.w	#1,d0
		move.w	d0,x_vel(a0)
		addq.w	#1,bfish_unk3(a0)
		st	bfish_biting_flag(a0)
		bra.w	JmpTo2_MarkObjGone
; ===========================================================================
; loc_15CA0:
BFish_WaterLevel:
		move.w	y_pos(a0),d0
		cmp.w	(Water_Level_1).w,d0
		bgt.s	BFish_BelowWater
		move.b	#1,anim(a0)
		bra.w	JmpTo2_MarkObjGone
; ===========================================================================
; loc_15CB4:
BFish_BelowWater:
		move.b	#0,anim(a0)
		bset	#6,status(a0)
		bne.s	loc_15CCE
		move.l	bfish_speed(a0),d0
		asr.l	#1,d0
		move.l	d0,bfish_speed(a0)
		nop

loc_15CCE:
		move.w	bfish_start_position(a0),d0
		cmp.w	y_pos(a0),d0
		bgt.w	JmpTo2_MarkObjGone
		subq.b	#2,routine(a0)
		tst.b	bfish_biting_flag(a0)
		beq.w	JmpTo2_MarkObjGone
		move.w	x_vel(a0),d0
		asr.w	#1,d0
		move.w	d0,x_vel(a0)
		sf	bfish_biting_flag(a0)
		bra.w	JmpTo2_MarkObjGone
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to move BFish
; ---------------------------------------------------------------------------
; sub_15CF8:
BFish_Move:
		move.l	x_pos(a0),d2
		move.l	y_pos(a0),d3
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		add.l	bfish_speed(a0),d3
		btst	#6,status(a0)
		beq.s	loc_15D34
		tst.l	bfish_speed(a0)
		bpl.s	loc_15D2C
		addi.l	#$1000,bfish_speed(a0)
		addi.l	#$1000,bfish_speed(a0)

loc_15D2C:
		subi.l	#$1000,bfish_speed(a0)

loc_15D34:
		addi.l	#$1800,bfish_speed(a0)
		move.l	d2,x_pos(a0)
		move.l	d3,y_pos(a0)
		rts
; End of function BFish_Move

; ===========================================================================
; ---------------------------------------------------------------------------
; animation scripts
; ---------------------------------------------------------------------------
; Ani_Obj52:
Ani_BFish:	dc.w .idle-Ani_BFish
		dc.w .chomping-Ani_BFish
		dc.w .jumping-Ani_BFish
		dc.w .jumpingfast-Ani_BFish
; byte_15D4E:
.idle:		dc.b  $E,  0,  1,$FF
; byte_15D52:
.chomping:	dc.b   3,  0,  1,$FF
; byte_15D56:
.jumping:	dc.b  $E,  2,  3,$FF
; byte_15D5A:
.jumpingfast:	dc.b   3,  2,  3,$FF
		even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj52:
MapUnc_BFish:	include	"mappings/sprite/Badniks - BFish.asm"
		align 4