; ===========================================================================
; ---------------------------------------------------------------------------
; Sonic 1 Object 53 - Collapsing floor
;
; Internal name: "break2"
; ---------------------------------------------------------------------------
; OST:
collapse_timer:			equ $38		; byte ; time between touching the floor and it collapsing
collapse_flag:			equ $3A		; byte
; ---------------------------------------------------------------------------
; Sprite_8D56: S1Obj_53:
Obj_CollapsingFloor:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	CollapsingFloor_Index(pc,d0.w),d1
		jmp	CollapsingFloor_Index(pc,d1.w)
; ===========================================================================
; off_8D64: S1Obj_53_Index:
CollapsingFloor_Index:
		dc.w CollapsingFloor_Init-CollapsingFloor_Index
		dc.w CollapsingFloor_Main-CollapsingFloor_Index
		dc.w CollapsingFloor_Fragment-CollapsingFloor_Index
; ===========================================================================
; loc_8D6A:
CollapsingFloor_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_CollapsingFloor,mappings(a0)
		move.w	#$42B8,art_tile(a0)
		cmpi.b	#3,(Current_Zone).w	; is this "Star Light" Zone
		bne.s	loc_8D8E		; if not, branch
		move.w	#$44E0,art_tile(a0)
		addq.b	#2,mapping_frame(a0)

loc_8D8E:
		cmpi.b	#5,(Current_Zone).w	; is this "Scrap Brain" Zone?
		bne.s	loc_8D9C		; if not, branch
		move.w	#$43F5,art_tile(a0)

loc_8D9C:
		ori.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#7,collapse_timer(a0)
		move.b	#$44,width_pixels(a0)
; loc_8DB4:
CollapsingFloor_Main:
		tst.b	collapse_flag(a0)
		beq.s	loc_8DC6
		tst.b	collapse_timer(a0)
		beq.w	loc_8E3E
		subq.b	#1,collapse_timer(a0)

loc_8DC6:
		move.b	status(a0),d0
		andi.b	#$18,d0
		beq.s	sub_8DD6
		move.b	#1,collapse_flag(a0)

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_8DD6:
		move.w	#$20,d1
		move.w	#8,d3
		move.w	x_pos(a0),d4
		bsr.w	PlatformObject
		bra.w	MarkObjGone
; End of function sub_8DD6

; ===========================================================================
; loc_8DEA:
CollapsingFloor_Fragment:
		tst.b	collapse_timer(a0)
		beq.s	CollapsingFloor_FragmentFall
		tst.b	collapse_flag(a0)
		bne.s	loc_8DFE
		subq.b	#1,collapse_timer(a0)
		bra.w	DisplaySprite
; ===========================================================================

loc_8DFE:
		bsr.w	sub_8DD6
		subq.b	#1,collapse_timer(a0)
		bne.s	locret_8E2C
		lea	(MainCharacter).w,a1
		bsr.s	sub_8E12
		lea	(Sidekick).w,a1

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_8E12:
		btst	#3,status(a1)
		beq.s	locret_8E2C
		bclr	#3,status(a1)
		bclr	#5,status(a1)
		move.b	#1,prev_anim(a1)

locret_8E2C:
		rts
; End of function sub_8E12

; ===========================================================================
; loc_8E2E:
CollapsingFloor_FragmentFall:
		bsr.w	ObjectMoveAndFall
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================

loc_8E3E:
		lea	(byte_8F17).l,a4
		btst	#0,subtype(a0)
		beq.s	loc_8E52
		lea	(byte_8F1F).l,a4

loc_8E52:
		addq.b	#1,mapping_frame(a0)
		bra.s	loc_8E70
; ===========================================================================

loc_8E58:
		lea	(byte_8EF2).l,a4
		cmpi.b	#4,(Current_Zone).w
		bne.s	loc_8E6C
		lea	(byte_8F0B).l,a4

loc_8E6C:
		addq.b	#2,mapping_frame(a0)

loc_8E70:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		add.w	d0,d0
		movea.l	mappings(a0),a3
		adda.w	(a3,d0.w),a3
		move.w	(a3)+,d1
		subq.w	#1,d1
		bset	#5,render_flags(a0)
		move.b	id(a0),d4
		move.b	render_flags(a0),d5
		movea.l	a0,a1
		bra.s	loc_8E9E
; ===========================================================================

loc_8E96:
		bsr.w	AllocateObject
		bne.s	loc_8EE4
		addq.w	#8,a3

loc_8E9E:
		move.b	#4,routine(a1)
		move.b	d4,id(a1)
		move.l	a3,mappings(a1)
		move.b	d5,render_flags(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.b	priority(a0),priority(a1)
		move.b	width_pixels(a0),width_pixels(a1)
		move.b	y_radius(a0),y_radius(a1)
		move.b	(a4)+,collapse_timer(a1)
		cmpa.l	a0,a1
		bcc.s	loc_8EE0
		bsr.w	DisplaySprite2

loc_8EE0:
		dbf	d1,loc_8E96

loc_8EE4:
		bsr.w	DisplaySprite
		move.w	#SndID_Smash,d0
		jmp	(PlaySound).l
; ===========================================================================
byte_8EF2:	dc.b $1C,$18,$14,$10
		dc.b $1A,$16,$12, $E
		dc.b  $A,  6,$18,$14
		dc.b $10, $C,  8,  4
		dc.b $16,$12, $E, $A
		dc.b   6,  2,$14,$10
		dc.b  $C
byte_8F0B:	dc.b $18,$1C,$20,$1E
		dc.b $1A,$16,  6, $E
		dc.b $14,$12, $A,  2
byte_8F17:	dc.b $1E,$16, $E,  6
		dc.b $1A,$12, $A,  2
byte_8F1F:	dc.b $16,$1E,$1A,$12
		dc.b   6, $E, $A,  2
		even
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------

include_MapUnc_CollapsingFloor macro
; Map_S1Obj53:
MapUnc_CollapsingFloor:	include	"mappings/sprite/Collapsing Floor.asm"
	endm