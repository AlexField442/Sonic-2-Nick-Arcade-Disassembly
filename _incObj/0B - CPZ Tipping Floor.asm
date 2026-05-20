; ===========================================================================
; ---------------------------------------------------------------------------
; Object 0B - Section of pipe that tips you off from CPZ
;
; Internal name: "kaiten"
; ---------------------------------------------------------------------------
; OST:
tipfloor_duration_current:	equ $30	; word
tipfloor_duration_initial:	equ $32	; word
tipfloor_delay:			equ $36 ; word
; ---------------------------------------------------------------------------
; Sprite_141B4: Obj0B:
Obj_TippingFloor:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	TippingFloor_Index(pc,d0.w),d1
		jmp	TippingFloor_Index(pc,d1.w)
; ===========================================================================
; off_141C2: Obj0B_Index:
TippingFloor_Index:
		dc.w TippingFloor_Init-TippingFloor_Index
		dc.w TippingFloor_Main-TippingFloor_Index
		dc.w TippingFloor_WaitToTipOver-TippingFloor_Index
; ===========================================================================
; loc_141C8:
TippingFloor_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_TippingFloor,mappings(a0)
		move.w	#$E000,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#4,priority(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		andi.w	#$F0,d0
		addi.w	#$10,d0
		move.w	d0,d1
		subq.w	#1,d0
		move.w	d0,tipfloor_duration_current(a0)
		move.w	d0,tipfloor_duration_initial(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		andi.w	#$F,d0
		addq.w	#1,d0
		lsl.w	#4,d0
		move.b	d0,tipfloor_delay(a0)
; loc_1421C:
TippingFloor_Main:
		move.b	(Vint_runcount+3).w,d0
		add.b	tipfloor_delay(a0),d0
		bne.s	TippingFloor_CheckCollision
		addq.b	#2,routine(a0)
; loc_1422A:
TippingFloor_WaitToTipOver:
		subq.w	#1,tipfloor_duration_current(a0)
		bpl.s	TippingFloor_Animate
		move.w	#$7F,tipfloor_duration_current(a0)
		tst.b	anim(a0)
		beq.s	loc_14242
		move.w	tipfloor_duration_initial(a0),tipfloor_duration_current(a0)

loc_14242:
		bchg	#0,anim(a0)
; loc_14248:
TippingFloor_Animate:
		lea	(Ani_TippingFloor).l,a1
		jsr	(AnimateSprite).l
; loc_14254:
TippingFloor_CheckCollision:
		tst.b	mapping_frame(a0)
		bne.s	TippingFloor_DropCharacter
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#$11,d3
		move.w	x_pos(a0),d4
		bsr.w	PlatformObject
		bra.w	MarkObjGone
; ===========================================================================
; loc_1426E:
TippingFloor_DropCharacter:
		btst	#3,status(a0)	; is Sonic standing on the floor?
		beq.s	loc_14286	; if not, branch
		lea	(MainCharacter).w,a1
		bclr	#3,status(a1)	; clear 'player on-object' bit
		bclr	#3,status(a0) 

loc_14286:
		bra.w	MarkObjGone
; ===========================================================================
; ---------------------------------------------------------------------------
; animation scripts
; ---------------------------------------------------------------------------
; off_1428A:
Ani_TippingFloor:
		dc.w .tipover-Ani_TippingFloor
		dc.w .return-Ani_TippingFloor
; byte_1428E:
.tipover:	dc.b   7,  0,  1,  2,  3,  4,$FE,  1
; byte_14296:
.return:	dc.b   7,  4,  3,  2,  1,  0,$FE,  1
		even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj0B:
MapUnc_TippingFloor:	include	"mappings/sprite/Tripping floor from CPZ.asm"
		nop