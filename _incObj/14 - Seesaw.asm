; ===========================================================================
; ---------------------------------------------------------------------------
; Object 14 - Seesaw from Hill Top Zone (and Emerald Hill Zone's debug list)
;
; Internal name: "sisoo"
; ---------------------------------------------------------------------------
; OST:
seesaw_origX:		equ $30			; original x-axis position
seesaw_origY:		equ $34			; original x-axis position
seesaw_speed:		equ $38			; speed of collision
seesaw_frame:		equ $3A
seesaw_parent:		equ $3C
; ---------------------------------------------------------------------------
; Sprite_14CA0: Obj14:
Obj_Seesaw:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Seesaw_Index(pc,d0.w),d1
		jsr	Seesaw_Index(pc,d1.w)
		move.w	seesaw_origX(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
; Obj14_Index:
Seesaw_Index:	dc.w Seesaw_Init-Seesaw_Index
		dc.w Seesaw_Main-Seesaw_Index
		dc.w Seesaw_CheckSide-Seesaw_Index
		dc.w Seesaw_Ball-Seesaw_Index
		dc.w Seesaw_MoveBall-Seesaw_Index
		dc.w Seesaw_BallFall-Seesaw_Index
; ===========================================================================
; loc_14CD2:
Seesaw_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_Seesaw,mappings(a0)
		move.w	#$3CE,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$30,width_pixels(a0)
		move.w	x_pos(a0),seesaw_origX(a0)
		tst.b	subtype(a0)	; does this Seesaw have a ball?
		bne.s	loc_14D2C	; if not, branch

		bsr.w	AllocateObjectAfterCurrent
		bne.s	loc_14D2C
		move.b	#ObjID_Seesaw,id(a1)	; load Obj_Seesaw (ball) object
		addq.b	#6,routine(a1)		; use Seesaw_Ball routine
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	status(a0),status(a1)
		move.l	a0,seesaw_parent(a1)

loc_14D2C:
		btst	#0,status(a0)		; is the Seesaw flipped?
		beq.s	loc_14D3A		; if not, branch
		move.b	#2,mapping_frame(a0)	; use different frame (duplicate, so no visible change)

loc_14D3A:
		move.b	mapping_frame(a0),seesaw_frame(a0)
; loc_14D40:
Seesaw_Main:
		move.b	seesaw_frame(a0),d1
		btst	#3,status(a0)
		beq.s	loc_14D9A
		moveq	#2,d1
		lea	(MainCharacter).w,a1
		move.w	x_pos(a0),d0
		sub.w	x_pos(a1),d0
		bcc.s	loc_14D60
		neg.w	d0
		moveq	#0,d1

loc_14D60:
		cmpi.w	#8,d0
		bcc.s	loc_14D68
		moveq	#1,d1

loc_14D68:
		btst	#4,status(a0)
		beq.s	loc_14DBE
		moveq	#2,d2
		lea	(Sidekick).w,a1
		move.w	x_pos(a0),d0
		sub.w	x_pos(a1),d0
		bcc.s	loc_14D84
		neg.w	d0
		moveq	#0,d2

loc_14D84:
		cmpi.w	#8,d0
		bcc.s	loc_14D8C
		moveq	#1,d2

loc_14D8C:
		add.w	d2,d1
		cmpi.w	#3,d1
		bne.s	loc_14D96
		addq.w	#1,d1

loc_14D96:
		lsr.w	#1,d1
		bra.s	loc_14DBE
; ===========================================================================

loc_14D9A:
		btst	#4,status(a0)
		beq.s	loc_14DBE
		moveq	#2,d1
		lea	(Sidekick).w,a1
		move.w	x_pos(a0),d0
		sub.w	x_pos(a1),d0
		bcc.s	loc_14DB6
		neg.w	d0
		moveq	#0,d1

loc_14DB6:
		cmpi.w	#8,d0
		bcc.s	loc_14DBE
		moveq	#1,d1

loc_14DBE:
		bsr.w	Seesaw_ChangeFrame
		lea	(Seesaw_SlopeData).l,a2
		btst	#0,mapping_frame(a0)	; is the Seesaw flat?
		beq.s	loc_14DD6		; if not, branch
		lea	(Seesaw_FlatData).l,a2

loc_14DD6:
		lea	(MainCharacter).w,a1
		move.w	y_vel(a1),seesaw_speed(a0)
		move.w	x_pos(a0),-(sp)
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#8,d3
		move.w	(sp)+,d4
		bra.w	SlopedPlatform
; ===========================================================================
; locret_14DF2:
Seesaw_CheckSide:
		rts
; ---------------------------------------------------------------------------
		moveq	#2,d1
		lea	(MainCharacter).w,a1
		move.w	x_pos(a0),d0		; is Sonic on the left side of the Seesaw?
		sub.w	x_pos(a1),d0		; if yes, branch
		bcc.s	loc_14E08
		neg.w	d0
		moveq	#0,d1

loc_14E08:
		cmpi.w	#8,d0
		bcc.s	Seesaw_ChangeFrame
		moveq	#1,d1

; ---------------------------------------------------------------------------
; Subroutine to set the correct graphics for the Seesaw
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_14E10:
Seesaw_ChangeFrame:
		move.b	mapping_frame(a0),d0
		cmp.b	d1,d0		; does frame need to change?
		beq.s	locret_14E3A	; if not, branch
		bcc.s	loc_14E1C
		addq.b	#2,d0

loc_14E1C:
		subq.b	#1,d0
		move.b	d0,mapping_frame(a0)
		move.b	d1,seesaw_frame(a0)
		bclr	#0,render_flags(a0)
		btst	#1,mapping_frame(a0)
		beq.s	locret_14E3A
		bset	#0,render_flags(a0)

locret_14E3A:
		rts
; End of function Seesaw_CheckSide

; ===========================================================================
; loc_14E3C:
Seesaw_Ball:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_SeesawBall,mappings(a0)
		move.w	#$3CE,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$8B,collision_flags(a0)
		move.b	#$C,width_pixels(a0)
		move.w	x_pos(a0),seesaw_origX(a0)
		addi.w	#$28,x_pos(a0)
		addi.w	#$10,y_pos(a0)
		move.w	y_pos(a0),seesaw_origY(a0)
		move.b	#1,mapping_frame(a0)
		btst	#0,status(a0)		; is the Seesaw flipped?
		beq.s	Seesaw_MoveBall		; if not, branch
		subi.w	#$50,x_pos(a0)		; move ball to the other side
		move.b	#2,seesaw_frame(a0)
; loc_14E9C:
Seesaw_MoveBall:
		movea.l	seesaw_parent(a0),a1
		moveq	#0,d0
		move.b	seesaw_frame(a0),d0
		sub.b	seesaw_frame(a1),d0
		beq.s	loc_14EF2
		bcc.s	loc_14EB0
		neg.b	d0

loc_14EB0:
		move.w	#$F7E8,d1
		move.w	#$FEEC,d2
		cmpi.b	#1,d0
		beq.s	loc_14ED6
		move.w	#$F510,d1
		move.w	#$FF34,d2
		cmpi.w	#$A00,seesaw_speed(a1)
		blt.s	loc_14ED6
		move.w	#$F200,d1
		move.w	#$FF60,d2

loc_14ED6:
		move.w	d1,y_vel(a0)
		move.w	d2,x_vel(a0)
		move.w	x_pos(a0),d0
		sub.w	seesaw_origX(a0),d0
		bcc.s	loc_14EEC
		neg.w	x_vel(a0)

loc_14EEC:
		addq.b	#2,routine(a0)
		bra.s	Seesaw_BallFall
; ===========================================================================

loc_14EF2:
		lea	(Seesaw_YOffsets).l,a2
		moveq	#0,d0
		move.b	mapping_frame(a1),d0
		move.w	#$28,d2
		move.w	x_pos(a0),d1
		sub.w	seesaw_origX(a0),d1
		bcc.s	loc_14F10
		neg.w	d2
		addq.w	#2,d0

loc_14F10:
		add.w	d0,d0
		move.w	seesaw_origY(a0),d1
		add.w	(a2,d0.w),d1
		move.w	d1,y_pos(a0)
		add.w	seesaw_origX(a0),d2
		move.w	d2,x_pos(a0)
		clr.w	y_sub(a0)
		clr.w	x_sub(a0)
		rts
; ===========================================================================
; loc_14F30:
Seesaw_BallFall:
		tst.w	y_vel(a0)
		bpl.s	loc_14F4E
		bsr.w	j_ObjectMoveAndFall
		move.w	seesaw_origY(a0),d0
		subi.w	#$2F,d0
		cmp.w	y_pos(a0),d0
		bgt.s	locret_14F4C
		bsr.w	j_ObjectMoveAndFall

locret_14F4C:
		rts
; ===========================================================================

loc_14F4E:
		bsr.w	j_ObjectMoveAndFall
		movea.l	seesaw_parent(a0),a1
		lea	(Seesaw_YOffsets).l,a2
		moveq	#0,d0
		move.b	mapping_frame(a1),d0
		move.w	x_pos(a0),d1
		sub.w	seesaw_origX(a0),d1
		bcc.s	loc_14F6E
		addq.w	#2,d0

loc_14F6E:
		add.w	d0,d0
		move.w	seesaw_origY(a0),d1
		add.w	(a2,d0.w),d1
		cmp.w	y_pos(a0),d1
		bgt.s	locret_14FC2
		movea.l	seesaw_parent(a0),a1
		moveq	#2,d1
		tst.w	x_vel(a0)
		bmi.s	loc_14F8C
		moveq	#0,d1

loc_14F8C:
		move.b	d1,seesaw_frame(a1)
		move.b	d1,seesaw_frame(a0)
		cmp.b	mapping_frame(a1),d1
		beq.s	loc_14FB6
		lea	(MainCharacter).w,a2
		bclr	#3,status(a1)
		beq.s	loc_14FA8
		bsr.s	Seesaw_LaunchPlayer

loc_14FA8:
		lea	(Sidekick).w,a2
		bclr	#4,status(a1)
		beq.s	loc_14FB6
		bsr.s	Seesaw_LaunchPlayer

loc_14FB6:
		clr.w	x_vel(a0)
		clr.w	y_vel(a0)
		subq.b	#2,routine(a0)

locret_14FC2:
		rts
; ===========================================================================
; sub_14FC4:
Seesaw_LaunchPlayer:
		move.w	y_vel(a0),y_vel(a2)
		neg.w	y_vel(a2)
		bset	#1,status(a2)
		bclr	#3,status(a2)
		clr.b	jumping(a2)
		move.b	#$10,anim(a2)
		move.b	#2,routine(a2)
		move.w	#$CC,d0
		jmp	(PlaySound).l
; End of function sub_14FC4

; ===========================================================================
; Heights of the contact point of the ball on the seesaw
; word_14FF4:
Seesaw_YOffsets:	dc.w	 -8,  -$1C,  -$2F,  -$1C,    -8		; low, balanced, high, balanced, low

; byte_14FFE:
Seesaw_SlopeData:
		dc.b  $14, $14,	$16, $18, $1A, $1C, $1A
		dc.b  $18, $16,	$14, $13, $12, $11, $10
		dc.b   $F,  $E,	 $D,  $C,  $B,	$A,   9
		dc.b	8,   7,	  6,   5,   4,	 3,   2
		dc.b	1,   0,	 -1,  -2,  -3,	-4,  -5
		dc.b   -6,  -7,	 -8,  -9, -$A, -$B, -$C
		dc.b  -$D, -$E,	-$E, -$E, -$E, -$E, -$E
; byte_1502F:
Seesaw_FlatData:
		dc.b	5,   5,	  5,   5,   5,	 5,   5
		dc.b	5,   5,	  5,   5,   5,	 5,   5
		dc.b	5,   5,	  5,   5,   5,	 5,   5
		dc.b	5,   5,	  5,   5,   5,	 5,   5
		dc.b	5,   5,	  5,   5,   5,	 5,   5
		dc.b	5,   5,	  5,   5,   5,	 5,   5
		dc.b	5,   5,	  5,   5,   5,	 5,   0
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_obj14:
MapUnc_Seesaw:		include	"mappings/sprite/Seesaw.asm"
; Map_obj14b:
MapUnc_SeesawBall:	include	"mappings/sprite/Seesaw Ball.asm"

; ===========================================================================
		nop