; ===========================================================================
; ---------------------------------------------------------------------------
; Object 1A - Collapsing ledge from GHZ and HPZ
;
; Internal name: "break"
; ---------------------------------------------------------------------------
; OST:
ledge_timer:			equ $38		; byte ; time between touching the ledge and it collapsing
ledge_flag:			equ $3A		; byte
ledge_slopepointer:		equ $3C		; long-word ; pointer to slope
; ---------------------------------------------------------------------------
; Sprite_8C44: Obj1A:
Obj_CollapsingLedge:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	CollapsingLedge_Index(pc,d0.w),d1
		jmp	CollapsingLedge_Index(pc,d1.w)
; ===========================================================================
; off_8C52: Obj1A_Index:
CollapsingLedge_Index:
		dc.w CollapsingLedge_Init-CollapsingLedge_Index
		dc.w CollapsingLedge_Main-CollapsingLedge_Index
		dc.w CollapsingLedge_Fragment-CollapsingLedge_Index
; ===========================================================================
; loc_8C58:
CollapsingLedge_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_GHZCollapsingLedge,mappings(a0)
		move.w	#$4000,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#7,ledge_timer(a0)
		move.b	subtype(a0),mapping_frame(a0)
		cmpi.b	#4,(Current_Zone).w
		bne.s	loc_8CB0
		move.l	#MapUnc_HPZCollapsingLedge,mappings(a0)
		move.w	#$434A,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#$30,width_pixels(a0)
		move.l	#CollapsingLedge_HPZ,ledge_slopepointer(a0)
		bra.s	CollapsingLedge_Main
; ===========================================================================

loc_8CB0:
		move.l	#CollapsingLedge_GHZ,ledge_slopepointer(a0)
		move.b	#$34,width_pixels(a0)
		move.b	#$38,y_radius(a0)
		bset	#4,render_flags(a0)
; loc_8CCA:
CollapsingLedge_Main:
		tst.b	ledge_flag(a0)
		beq.s	loc_8CDC
		tst.b	ledge_timer(a0)
		beq.w	loc_8E58
		subq.b	#1,ledge_timer(a0)

loc_8CDC:
		move.b	status(a0),d0
		andi.b	#$18,d0
		beq.s	sub_8CEC
		move.b	#1,ledge_flag(a0)

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_8CEC:
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		movea.l	ledge_slopepointer(a0),a2
		move.w	x_pos(a0),d4
		bsr.w	SlopedPlatform
		bra.w	MarkObjGone
; End of function sub_8CEC

; ===========================================================================
; loc_8D02:
CollapsingLedge_Fragment:
		tst.b	ledge_timer(a0)
		beq.s	CollapsingLedge_FragmentFall
		tst.b	ledge_flag(a0)
		bne.s	loc_8D16
		subq.b	#1,ledge_timer(a0)
		bra.w	DisplaySprite
; ===========================================================================

loc_8D16:
		bsr.w	sub_8CEC
		subq.b	#1,ledge_timer(a0)
		bne.s	locret_8D44
		lea	(MainCharacter).w,a1
		bsr.s	sub_8D2A
		lea	(Sidekick).w,a1

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_8D2A:
		btst	#3,status(a1)
		beq.s	locret_8D44
		bclr	#3,status(a1)
		bclr	#5,status(a1)
		move.b	#1,prev_anim(a1)

locret_8D44:
		rts
; End of function sub_8D2A

; ===========================================================================
; loc_8D46:
CollapsingLedge_FragmentFall:
		bsr.w	ObjectMoveAndFall
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
include_CollapsingLedge_GHZ macro
CollapsingLedge_GHZ:
		dc.b $20,$20,$20,$20
		dc.b $20,$20,$20,$20
		dc.b $21,$21,$22,$22
		dc.b $23,$23,$24,$24
		dc.b $25,$25,$26,$26
		dc.b $27,$27,$28,$28
		dc.b $29,$29,$2A,$2A
		dc.b $2B,$2B,$2C,$2C
		dc.b $2D,$2D,$2E,$2E
		dc.b $2F,$2F,$30,$30
		dc.b $30,$30,$30,$30
		dc.b $30,$30,$30,$30
		endm

include_CollapsingLedge_HPZ macro
CollapsingLedge_HPZ:
		dc.b $10,$10,$10,$10
		dc.b $10,$10,$10,$10
		dc.b $10,$10,$10,$10
		dc.b $10,$10,$10,$10
		dc.b $10,$10,$10,$10
		dc.b $10,$10,$10,$10
		dc.b $10,$10,$10,$10
		dc.b $10,$10,$10,$10
		dc.b $10,$10,$10,$10
		dc.b $10,$10,$10,$10
		dc.b $10,$10,$10,$10
		dc.b $10,$10,$10,$10
		endm
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------

include_MapUnc_GHZCollapsingLedge macro
; Map_Obj1A:
MapUnc_GHZCollapsingLedge:	include	"mappings/sprite/GHZ Collapsing Ledge.asm"
		endm

include_MapUnc_HPZCollapsingLedge macro
; Map_Obj1A_HPZ:
MapUnc_HPZCollapsingLedge:	include	"mappings/sprite/HPZ Collapsing Ledge.asm"
		nop
		endm