; ===========================================================================
; ---------------------------------------------------------------------------
; Object 06 - Twisting spiral pathway in EHZ
;
; Internal name: "sloop"
; ---------------------------------------------------------------------------
; Sprite_14972: Obj06:
Obj_Spiral:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Spiral_Index(pc,d0.w),d1
		jsr	Spiral_Index(pc,d1.w)
		tst.w	(Two_player_mode).w
		beq.s	Spiral_ChkDel
		rts
; ---------------------------------------------------------------------------
; loc_14986:
Spiral_ChkDel:
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.s	Spiral_Delete
		rts
; ---------------------------------------------------------------------------
; loc_1499A:
Spiral_Delete:
		jmp	(DeleteObject).l

; ===========================================================================
; off_149A2: Obj06_Index:
Spiral_Index:	dc.w Spiral_Init-Spiral_Index
		dc.w Spiral_Main-Spiral_Index
; ===========================================================================
; loc_149A6: Obj06_Init:
Spiral_Init:
		addq.b	#2,routine(a0)
		move.b	#$D0,width_pixels(a0)
; loc_149B0: Obj06_Main:
Spiral_Main:
		lea	(MainCharacter).w,a1
		moveq	#3,d6
		bsr.s	sub_149BC
		lea	(Sidekick).w,a1
		addq.b	#1,d6

sub_149BC:
		btst	d6,status(a0)
		bne.w	loc_14A56
		btst	#1,status(a1)
		bne.w	locret_14A54
		btst	#3,status(a1)
		bne.s	loc_14A16
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		tst.w	x_vel(a1)
		bmi.s	loc_149F2
		cmpi.w	#-$C0,d0
		bgt.s	locret_14A54
		cmpi.w	#-$D0,d0
		blt.s	locret_14A54
		bra.s	loc_149FE
; ---------------------------------------------------------------------------

loc_149F2:
		cmpi.w	#$C0,d0
		blt.s	locret_14A54
		cmpi.w	#$D0,d0
		bgt.s	locret_14A54

loc_149FE:
		move.w	y_pos(a1),d1
		sub.w	y_pos(a0),d1
		subi.w	#$10,d1
		cmpi.w	#$30,d1
		bcc.s	locret_14A54
		bsr.w	RideObject_SetRide
		rts
; ===========================================================================

loc_14A16:
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		tst.w	x_vel(a1)
		bmi.s	loc_14A32
		cmpi.w	#-$B0,d0
		bgt.s	locret_14A54
		cmpi.w	#-$C0,d0
		blt.s	locret_14A54
		bra.s	loc_14A3E
; ---------------------------------------------------------------------------

loc_14A32:
		cmpi.w	#$B0,d0
		blt.s	locret_14A54
		cmpi.w	#$C0,d0
		bgt.s	locret_14A54

loc_14A3E:
		move.w	y_pos(a1),d1
		sub.w	y_pos(a0),d1
		subi.w	#$10,d1
		cmpi.w	#$30,d1
		bcc.s	locret_14A54
		bsr.w	RideObject_SetRide

locret_14A54:
		rts
; ===========================================================================

loc_14A56:
		move.w	inertia(a1),d0
		bpl.s	loc_14A5E
		neg.w	d0

loc_14A5E:
		cmpi.w	#$600,d0			; is character travelling at at least his top speed?
		bcs.s	Spiral_CharacterFallsOff	; if not, branch
		btst	#1,status(a1)			; is character considered in the air?
		bne.s	Spiral_CharacterFallsOff	; if yes, branch
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		addi.w	#$D0,d0
		bmi.s	Spiral_CharacterFallsOff
		cmpi.w	#$1A0,d0
		bcs.s	Spiral_MoveCharacter
; loc_14A80:
Spiral_CharacterFallsOff:
		bclr	#3,status(a1)	; clear their 'on-object' bit
		bclr	d6,status(a0)
		move.b	#0,flips_remaining(a1)
		move.b	#4,flip_speed(a1)
		rts
; ===========================================================================
; loc_14A98:
Spiral_MoveCharacter:
		btst	#3,status(a1)	; is the player considered on an object?
		beq.s	locret_14A54	; if not, branch
		move.b	Spiral_CosineTable(pc,d0.w),d1
		ext.w	d1
		move.w	y_pos(a0),d2
		add.w	d1,d2
		moveq	#0,d1
		move.b	y_radius(a1),d1
		subi.w	#$13,d1
		sub.w	d1,d2
		move.w	d2,y_pos(a1)
		lsr.w	#3,d0
		andi.w	#$3F,d0
		move.b	Spiral_FlipAngleTable(pc,d0.w),flip_angle(a1)
		rts
; ===========================================================================
; byte_14ACC: Obj06_PlayerAngleArray:
Spiral_FlipAngleTable:
		dc.b   0,  0,  1,  1
		dc.b $16,$16,$16,$16
		dc.b $2C,$2C,$2C,$2C
		dc.b $42,$42,$42,$42
		dc.b $58,$58,$58,$58
		dc.b $6E,$6E,$6E,$6E
		dc.b $84,$84,$84,$84
		dc.b $9A,$9A,$9A,$9A
		dc.b $B0,$B0,$B0,$B0
		dc.b $C6,$C6,$C6,$C6
		dc.b $DC,$DC,$DC,$DC
		dc.b $F2,$F2,$F2,$F2
		dc.b   1,  1,  0,  0
; byte_14B00: Obj06_PlayerDeltaYArray:
Spiral_CosineTable:
		dc.b  $20, $20,	$20, $20, $20, $20, $20, $20, $20, $20,	$20, $20, $20, $20, $20, $20
		dc.b  $20, $20,	$20, $20, $20, $20, $20, $20, $20, $20,	$20, $20, $20, $20, $1F, $1F
		dc.b  $1F, $1F,	$1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F,	$1F, $1F, $1F, $1E, $1E, $1E
		dc.b  $1E, $1E,	$1E, $1E, $1E, $1E, $1D, $1D, $1D, $1D,	$1D, $1C, $1C, $1C, $1C, $1B
		dc.b  $1B, $1B,	$1B, $1A, $1A, $1A, $19, $19, $19, $18,	$18, $18, $17, $17, $16, $16
		dc.b  $15, $15,	$14, $14, $13, $12, $12, $11, $10, $10,	 $F,  $E,  $E,	$D,  $C,  $C
		dc.b   $B,  $A,	 $A,   9,   8,	 8,   7,   6,	6,   5,	  4,   4,   3,	 2,   2,   1
		dc.b	0,  -1,	 -2,  -2,  -3,	-4,  -4,  -5,  -6,  -7,	 -7,  -8,  -9,	-9, -$A, -$A
		dc.b  -$B, -$B,	-$C, -$C, -$D, -$E, -$E, -$F, -$F,-$10,-$10,-$11,-$11,-$12,-$12,-$13
		dc.b -$13,-$13,-$14,-$15,-$15,-$16,-$16,-$17,-$17,-$18,-$18,-$19,-$19,-$1A,-$1A,-$1B
		dc.b -$1B,-$1C,-$1C,-$1C,-$1D,-$1D,-$1E,-$1E,-$1E,-$1F,-$1F,-$1F,-$20,-$20,-$20,-$21
		dc.b -$21,-$21,-$21,-$22,-$22,-$22,-$23,-$23,-$23,-$23,-$23,-$23,-$23,-$23,-$24,-$24
		dc.b -$24,-$24,-$24,-$24,-$24,-$24,-$24,-$25,-$25,-$25,-$25,-$25,-$25,-$25,-$25,-$25
		dc.b -$25,-$25,-$25,-$25,-$25,-$25,-$25,-$25,-$25,-$25,-$25,-$25,-$25,-$25,-$25,-$25
		dc.b -$25,-$25,-$25,-$25,-$24,-$24,-$24,-$24,-$24,-$24,-$24,-$23,-$23,-$23,-$23,-$23
		dc.b -$23,-$23,-$23,-$22,-$22,-$22,-$21,-$21,-$21,-$21,-$20,-$20,-$20,-$1F,-$1F,-$1F
		dc.b -$1E,-$1E,-$1E,-$1D,-$1D,-$1C,-$1C,-$1C,-$1B,-$1B,-$1A,-$1A,-$19,-$19,-$18,-$18
		dc.b -$17,-$17,-$16,-$16,-$15,-$15,-$14,-$13,-$13,-$12,-$12,-$11,-$10,-$10, -$F, -$E
		dc.b  -$E, -$D,	-$C, -$B, -$B, -$A,  -9,  -8,  -7,  -7,	 -6,  -5,  -4,	-3,  -2,  -1
		dc.b	0,   1,	  2,   3,   4,	 5,   6,   7,	8,   8,	  9,  $A,  $A,	$B,  $C,  $D
		dc.b   $D,  $E,	 $E,  $F,  $F, $10, $10, $11, $11, $12,	$12, $13, $13, $14, $14, $15
		dc.b  $15, $16,	$16, $17, $17, $18, $18, $18, $19, $19,	$19, $19, $1A, $1A, $1A, $1A
		dc.b  $1B, $1B,	$1B, $1B, $1C, $1C, $1C, $1C, $1C, $1C,	$1D, $1D, $1D, $1D, $1D, $1D
		dc.b  $1D, $1E,	$1E, $1E, $1E, $1E, $1E, $1E, $1F, $1F,	$1F, $1F, $1F, $1F, $1F, $1F
		dc.b  $1F, $1F,	$20, $20, $20, $20, $20, $20, $20, $20,	$20, $20, $20, $20, $20, $20
		dc.b  $20, $20,	$20, $20, $20, $20, $20, $20, $20, $20,	$20, $20, $20, $20, $20, $20
		nop