; ===========================================================================
; ---------------------------------------------------------------------------
; Object 09 - Sonic in Special Stage
; ---------------------------------------------------------------------------
; Sprite_1A3B8: Obj09:
Obj_SSPlayer:
		tst.w	(Debug_placement_mode).w
		beq.s	Obj09_Normal
		bsr.w	S1SS_FixCamera
		bra.w	DebugMode
; ===========================================================================

Obj09_Normal:				; CODE XREF: ROM:0001A3BCj
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj09_Index(pc,d0.w),d1
		jmp	Obj09_Index(pc,d1.w)
; ===========================================================================
Obj09_Index:	dc.w loc_1A3DC-Obj09_Index ; DATA XREF:	ROM:Obj09_Indexo
					; ROM:0001A3D6o ...
		dc.w loc_1A41C-Obj09_Index
		dc.w loc_1A618-Obj09_Index
		dc.w loc_1A66C-Obj09_Index
; ===========================================================================

loc_1A3DC:				; DATA XREF: ROM:Obj09_Indexo
		addq.b	#2,routine(a0)
		move.b	#$E,y_radius(a0)
		move.b	#7,x_radius(a0)
		move.l	#MapUnc_Sonic,mappings(a0)
		move.w	#$780,art_tile(a0)
		bsr.w	JmpTo8_Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#0,priority(a0)
		move.b	#2,anim(a0)
		bset	#2,status(a0)
		bset	#1,status(a0)

loc_1A41C:				; DATA XREF: ROM:0001A3D6o
		tst.w	(Debug_mode_flag).w
		beq.s	loc_1A430
		btst	#4,(Ctrl_1_Press).w
		beq.s	loc_1A430
		move.w	#1,(Debug_placement_mode).w

loc_1A430:				; CODE XREF: ROM:0001A420j
					; ROM:0001A428j
		move.b	#0,$30(a0)
		moveq	#0,d0
		move.b	status(a0),d0
		andi.w	#2,d0
		move.w	Obj09_Modes(pc,d0.w),d1
		jsr	Obj09_Modes(pc,d1.w)
		jsr	(LoadSonicDynPLC).l
		jmp	(DisplaySprite).l
; ===========================================================================
Obj09_Modes:	dc.w Obj09_OnWall-Obj09_Modes ;	DATA XREF: ROM:Obj09_Modeso
					; ROM:0001A456o
		dc.w Obj09_InAir-Obj09_Modes
; ===========================================================================

Obj09_OnWall:				; DATA XREF: ROM:Obj09_Modeso
		bsr.w	Obj09_Jump
		bsr.w	Obj09_Move
		bsr.w	Obj09_Fall
		bra.s	Obj09_Display
; ===========================================================================

Obj09_InAir:				; DATA XREF: ROM:0001A456o
		bsr.w	nullsub_2
		bsr.w	Obj09_Move
		bsr.w	Obj09_Fall

Obj09_Display:				; CODE XREF: ROM:0001A464j
		bsr.w	Obj09_ChkItems
		bsr.w	Obj09_ChkItems2
		jsr	(ObjectMove).l
		bsr.w	S1SS_FixCamera
		move.w	(SS_rotation_angle).w,d0
		add.w	(SS_rotation_speed).w,d0
		move.w	d0,(SS_rotation_angle).w
		jsr	(Sonic_Animate).l
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Obj09_Move:				; CODE XREF: ROM:0001A45Cp
					; ROM:0001A46Ap
		btst	#2,(Ctrl_1_Held_Logical).w
		beq.s	loc_1A4A4
		bsr.w	Obj09_MoveLeft

loc_1A4A4:				; CODE XREF: Obj09_Move+6j
		btst	#3,(Ctrl_1_Held_Logical).w
		beq.s	loc_1A4B0
		bsr.w	Obj09_MoveRight

loc_1A4B0:				; CODE XREF: Obj09_Move+12j
		move.b	(Ctrl_1_Held_Logical).w,d0
		andi.b	#$C,d0
		bne.s	loc_1A4E0
		move.w	inertia(a0),d0
		beq.s	loc_1A4E0
		bmi.s	loc_1A4D2
		subi.w	#$C,d0
		bcc.s	loc_1A4CC
		move.w	#0,d0

loc_1A4CC:				; CODE XREF: Obj09_Move+2Ej
		move.w	d0,inertia(a0)
		bra.s	loc_1A4E0
; ===========================================================================

loc_1A4D2:				; CODE XREF: Obj09_Move+28j
		addi.w	#$C,d0
		bcc.s	loc_1A4DC
		move.w	#0,d0

loc_1A4DC:				; CODE XREF: Obj09_Move+3Ej
		move.w	d0,inertia(a0)

loc_1A4E0:				; CODE XREF: Obj09_Move+20j
					; Obj09_Move+26j ...
		move.b	(SS_rotation_angle).w,d0
		addi.b	#$20,d0	; ' '
		andi.b	#$C0,d0
		neg.b	d0
		jsr	(CalcSine).l
		muls.w	inertia(a0),d1
		add.l	d1,x_pos(a0)
		muls.w	inertia(a0),d0
		add.l	d0,y_pos(a0)
		movem.l	d0-d1,-(sp)
		move.l	y_pos(a0),d2
		move.l	x_pos(a0),d3
		bsr.w	sub_1A720
		beq.s	loc_1A52A
		movem.l	(sp)+,d0-d1
		sub.l	d1,x_pos(a0)
		sub.l	d0,y_pos(a0)
		move.w	#0,inertia(a0)
		rts
; ===========================================================================

loc_1A52A:				; CODE XREF: Obj09_Move+7Cj
		movem.l	(sp)+,d0-d1
		rts
; End of function Obj09_Move


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Obj09_MoveLeft:				; CODE XREF: Obj09_Move+8p
		bset	#0,status(a0)
		move.w	inertia(a0),d0
		beq.s	loc_1A53E
		bpl.s	loc_1A552

loc_1A53E:				; CODE XREF: Obj09_MoveLeft+Aj
		subi.w	#$C,d0
		cmpi.w	#$F800,d0
		bgt.s	loc_1A54C
		move.w	#$F800,d0

loc_1A54C:				; CODE XREF: Obj09_MoveLeft+16j
		move.w	d0,inertia(a0)
		rts
; ===========================================================================

loc_1A552:				; CODE XREF: Obj09_MoveLeft+Cj
		subi.w	#$40,d0	; '@'
		bcc.s	loc_1A55A
		nop

loc_1A55A:				; CODE XREF: Obj09_MoveLeft+26j
		move.w	d0,inertia(a0)
		rts
; End of function Obj09_MoveLeft


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Obj09_MoveRight:			; CODE XREF: Obj09_Move+14p
		bclr	#0,status(a0)
		move.w	inertia(a0),d0
		bmi.s	loc_1A580
		addi.w	#$C,d0
		cmpi.w	#$800,d0
		blt.s	loc_1A57A
		move.w	#$800,d0

loc_1A57A:				; CODE XREF: Obj09_MoveRight+14j
		move.w	d0,inertia(a0)
		bra.s	locret_1A58C
; ===========================================================================

loc_1A580:				; CODE XREF: Obj09_MoveRight+Aj
		addi.w	#$40,d0	; '@'
		bcc.s	loc_1A588
		nop

loc_1A588:				; CODE XREF: Obj09_MoveRight+24j
		move.w	d0,inertia(a0)

locret_1A58C:				; CODE XREF: Obj09_MoveRight+1Ej
		rts
; End of function Obj09_MoveRight


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Obj09_Jump:				; CODE XREF: ROM:Obj09_OnWallp
		move.b	(Ctrl_1_Press_Logical).w,d0
		andi.b	#$70,d0	; 'p'
		beq.s	locret_1A5D0
		move.b	(SS_rotation_angle).w,d0
		andi.b	#$FC,d0
		neg.b	d0
		subi.b	#$40,d0	; '@'
		jsr	(CalcSine).l
		muls.w	#$680,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	#$680,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		bset	#1,status(a0)
		move.w	#SndID_Jump,d0	; ' '
		jsr	(PlaySound).l

locret_1A5D0:				; CODE XREF: Obj09_Jump+8j
		rts
; End of function Obj09_Jump


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


nullsub_2:				; CODE XREF: ROM:Obj09_InAirp
		rts
; End of function nullsub_2

; ===========================================================================
		move.w	#$FC00,d1
		cmp.w	y_vel(a0),d1
		ble.s	locret_1A5EC
		move.b	(Ctrl_1_Held_Logical).w,d0
		andi.b	#$70,d0	; 'p'
		bne.s	locret_1A5EC
		move.w	d1,y_vel(a0)

locret_1A5EC:				; CODE XREF: ROM:0001A5DCj
					; ROM:0001A5E6j
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


S1SS_FixCamera:				; CODE XREF: ROM:0001A3BEp
					; ROM:0001A480p ...
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		move.w	(Camera_X_pos).w,d0
		subi.w	#$A0,d3	; ' '
		bcs.s	loc_1A606
		sub.w	d3,d0
		sub.w	d0,(Camera_X_pos).w

loc_1A606:				; CODE XREF: S1SS_FixCamera+10j
		move.w	(Camera_Y_pos).w,d0
		subi.w	#$70,d2	; 'p'
		bcs.s	locret_1A616
		sub.w	d2,d0
		sub.w	d0,(Camera_Y_pos).w

locret_1A616:				; CODE XREF: S1SS_FixCamera+20j
		rts
; End of function S1SS_FixCamera

; ===========================================================================

loc_1A618:				; DATA XREF: ROM:0001A3D8o
		addi.w	#$40,(SS_rotation_speed).w ; '@'
		cmpi.w	#$1800,(SS_rotation_speed).w
		bne.s	loc_1A62C
		move.b	#GameModeID_Level,(Game_Mode).w

loc_1A62C:				; CODE XREF: ROM:0001A624j
		cmpi.w	#$3000,(SS_rotation_speed).w
		blt.s	loc_1A64A
		move.w	#0,(SS_rotation_speed).w
		move.w	#$4000,(SS_rotation_angle).w
		addq.b	#2,routine(a0)
		move.w	#$3C,$38(a0) ; '<'

loc_1A64A:				; CODE XREF: ROM:0001A632j
		move.w	(SS_rotation_angle).w,d0
		add.w	(SS_rotation_speed).w,d0
		move.w	d0,(SS_rotation_angle).w
		jsr	(Sonic_Animate).l
		jsr	(LoadSonicDynPLC).l
		bsr.w	S1SS_FixCamera
		jmp	(DisplaySprite).l
; ===========================================================================

loc_1A66C:				; DATA XREF: ROM:0001A3DAo
		subq.w	#1,$38(a0)
		bne.s	loc_1A678
		move.b	#GameModeID_Level,(Game_Mode).w

loc_1A678:				; CODE XREF: ROM:0001A670j
		jsr	(Sonic_Animate).l
		jsr	(LoadSonicDynPLC).l
		bsr.w	S1SS_FixCamera
		jmp	(DisplaySprite).l

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Obj09_Fall:				; CODE XREF: ROM:0001A460p
					; ROM:0001A46Ep
		move.l	y_pos(a0),d2
		move.l	x_pos(a0),d3
		move.b	(SS_rotation_angle).w,d0
		andi.b	#$FC,d0
		jsr	(CalcSine).l
		move.w	x_vel(a0),d4
		ext.l	d4
		asl.l	#8,d4
		muls.w	#$2A,d0	; '*'
		add.l	d4,d0
		move.w	y_vel(a0),d4
		ext.l	d4
		asl.l	#8,d4
		muls.w	#$2A,d1	; '*'
		add.l	d4,d1
		add.l	d0,d3
		bsr.w	sub_1A720
		beq.s	loc_1A6E8
		sub.l	d0,d3
		moveq	#0,d0
		move.w	d0,x_vel(a0)
		bclr	#1,status(a0)
		add.l	d1,d2
		bsr.w	sub_1A720
		beq.s	loc_1A6FE
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,y_vel(a0)
		rts
; ===========================================================================

loc_1A6E8:				; CODE XREF: Obj09_Fall+38j
		add.l	d1,d2
		bsr.w	sub_1A720
		beq.s	loc_1A70C
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,y_vel(a0)
		bclr	#1,status(a0)

loc_1A6FE:				; CODE XREF: Obj09_Fall+4Ej
		asr.l	#8,d0
		asr.l	#8,d1
		move.w	d0,x_vel(a0)
		move.w	d1,y_vel(a0)
		rts
; ===========================================================================

loc_1A70C:				; CODE XREF: Obj09_Fall+60j
		asr.l	#8,d0
		asr.l	#8,d1
		move.w	d0,x_vel(a0)
		move.w	d1,y_vel(a0)
		bset	#1,status(a0)
		rts
; End of function Obj09_Fall


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_1A720:				; CODE XREF: Obj09_Move+78p
					; Obj09_Fall+34p ...
		lea	(Chunk_Table).l,a1
		moveq	#0,d4
		swap	d2
		move.w	d2,d4
		swap	d2
		addi.w	#$44,d4	; 'D'
		divu.w	#$18,d4
		mulu.w	#$80,d4	; '€'
		adda.l	d4,a1
		moveq	#0,d4
		swap	d3
		move.w	d3,d4
		swap	d3
		addi.w	#$14,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		moveq	#0,d5
		move.b	(a1)+,d4
		bsr.s	sub_1A768
		move.b	(a1)+,d4
		bsr.s	sub_1A768
		adda.w	#$7E,a1	; '~'
		move.b	(a1)+,d4
		bsr.s	sub_1A768
		move.b	(a1)+,d4
		bsr.s	sub_1A768
		tst.b	d5
		rts
; End of function sub_1A720


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_1A768:				; CODE XREF: sub_1A720+32p
					; sub_1A720+36p ...
		beq.s	locret_1A77C
		cmpi.b	#$28,d4	; '('
		beq.s	locret_1A77C
		cmpi.b	#$3A,d4	; ':'
		bcs.s	loc_1A77E
		cmpi.b	#$4B,d4	; 'K'
		bcc.s	loc_1A77E

locret_1A77C:				; CODE XREF: sub_1A768j sub_1A768+6j
		rts
; ===========================================================================

loc_1A77E:				; CODE XREF: sub_1A768+Cj
					; sub_1A768+12j
		move.b	d4,$30(a0)
		move.l	a1,$32(a0)
		moveq	#-1,d5
		rts
; End of function sub_1A768


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Obj09_ChkItems:
		lea	(Chunk_Table).l,a1
		moveq	#0,d4
		move.w	y_pos(a0),d4
		addi.w	#$50,d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#0,d4
		move.w	x_pos(a0),d4
		addi.w	#$20,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		move.b	(a1),d4
		bne.s	loc_1A7C4
		tst.b	$3A(a0)
		bne.w	loc_1A894
		moveq	#0,d4
		rts
; ===========================================================================

loc_1A7C4:
		cmpi.b	#$3A,d4
		bne.s	loc_1A800
		bsr.w	sub_19EEC
		bne.s	loc_1A7D8
		move.b	#1,(a2)
		move.l	a1,4(a2)

loc_1A7D8:
		jsr	(CollectRing).l
		cmpi.w	#50,(Ring_count).w
		bcs.s	loc_1A7FC
		bset	#0,(Extra_life_flags).w
		bne.s	loc_1A7FC
		addq.b	#1,(Continue_count).w
		move.w	#SndID_ContinueJingle,d0
		jsr	(PlayMusic).l

loc_1A7FC:
		moveq	#0,d4
		rts
; ===========================================================================

loc_1A800:
		cmpi.b	#$28,d4
		bne.s	loc_1A82A
		bsr.w	sub_19EEC
		bne.s	loc_1A814
		move.b	#3,(a2)
		move.l	a1,4(a2)

loc_1A814:
		addq.b	#1,(Life_count).w
		addq.b	#1,(Update_HUD_lives).w
		move.w	#MusID_ExtraLife,d0
		jsr	(PlayMusic).l
		moveq	#0,d4
		rts
; ===========================================================================

loc_1A82A:
		cmpi.b	#$3B,d4
		bcs.s	loc_1A870
		cmpi.b	#$40,d4
		bhi.s	loc_1A870
		bsr.w	sub_19EEC
		bne.s	loc_1A844
		move.b	#5,(a2)
		move.l	a1,4(a2)

loc_1A844:
		cmpi.b	#6,(Emerald_count).w
		beq.s	loc_1A862
		subi.b	#$3B,d4
		moveq	#0,d0
		move.b	(Emerald_count).w,d0
		lea	(Emeralds_array).w,a2
		move.b	d4,(a2,d0.w)
		addq.b	#1,(Emerald_count).w

loc_1A862:
		move.w	#MusID_Emerald,d0
		jsr	(PlaySound).l
		moveq	#0,d4
		rts
; ===========================================================================

loc_1A870:
		cmpi.b	#$41,d4
		bne.s	loc_1A87C
		move.b	#1,$3A(a0)

loc_1A87C:
		cmpi.b	#$4A,d4
		bne.s	loc_1A890
		cmpi.b	#1,$3A(a0)
		bne.s	loc_1A890
		move.b	#2,$3A(a0)

loc_1A890:
		moveq	#-1,d4
		rts
; ===========================================================================

loc_1A894:
		cmpi.b	#2,$3A(a0)
		bne.s	loc_1A8BE
		lea	(Chunk_Table+$1020).l,a1
		moveq	#$3F,d1

loc_1A8A4:
		moveq	#$3F,d2

loc_1A8A6:
		cmpi.b	#$41,(a1)
		bne.s	loc_1A8B0
		move.b	#$2C,(a1)

loc_1A8B0:
		addq.w	#1,a1
		dbf	d2,loc_1A8A6
		lea	$40(a1),a1
		dbf	d1,loc_1A8A4

loc_1A8BE:
		clr.b	$3A(a0)
		moveq	#0,d4
		rts
; End of function Obj09_ChkItems


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Obj09_ChkItems2:
		move.b	$30(a0),d0
		bne.s	loc_1A8E6
		subq.b	#1,$36(a0)
		bpl.s	loc_1A8D8
		move.b	#0,$36(a0)

loc_1A8D8:
		subq.b	#1,$37(a0)
		bpl.s	locret_1A8E4
		move.b	#0,$37(a0)

locret_1A8E4:
		rts
; ===========================================================================

loc_1A8E6:
		cmpi.b	#$25,d0
		bne.s	loc_1A95E
		move.l	$32(a0),d1
		subi.l	#$FFFF0001,d1
		move.w	d1,d2
		andi.w	#$7F,d1
		mulu.w	#$18,d1
		subi.w	#$14,d1
		lsr.w	#7,d2
		andi.w	#$7F,d2
		mulu.w	#$18,d2
		subi.w	#$44,d2
		sub.w	x_pos(a0),d1
		sub.w	y_pos(a0),d2
		jsr	(CalcAngle).l
		jsr	(CalcSine).l
		muls.w	#$F900,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	#$F900,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		bset	#1,status(a0)
		bsr.w	sub_19EEC
		bne.s	loc_1A954
		move.b	#2,(a2)
		move.l	$32(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)

loc_1A954:
		move.w	#SndID_Bumper,d0
		jmp	(PlaySound).l
; ===========================================================================

loc_1A95E:
		cmpi.b	#$27,d0
		bne.s	loc_1A974
		addq.b	#2,routine(a0)
		move.w	#SndID_SSGoal,d0
		jsr	(PlaySound).l
		rts
; ===========================================================================

loc_1A974:
		cmpi.b	#$29,d0
		bne.s	loc_1A9A8
		tst.b	$36(a0)
		bne.w	locret_1AA58
		move.b	#$1E,$36(a0)
		btst	#6,(SS_rotation_speed+1).w
		beq.s	loc_1A99E
		asl	(SS_rotation_speed).w
		movea.l	$32(a0),a1
		subq.l	#1,a1
		move.b	#$2A,(a1)

loc_1A99E:
		move.w	#SndID_SSItem,d0
		jmp	(PlaySound).l
; ===========================================================================

loc_1A9A8:
		cmpi.b	#$2A,d0
		bne.s	loc_1A9DC
		tst.b	$36(a0)
		bne.w	locret_1AA58
		move.b	#$1E,$36(a0)
		btst	#6,(SS_rotation_speed+1).w
		bne.s	loc_1A9D2
		asr	(SS_rotation_speed).w
		movea.l	$32(a0),a1
		subq.l	#1,a1
		move.b	#$29,(a1)

loc_1A9D2:
		move.w	#SndID_SSItem,d0
		jmp	(PlaySound).l
; ===========================================================================

loc_1A9DC:
		cmpi.b	#$2B,d0
		bne.s	loc_1AA12
		tst.b	$37(a0)
		bne.w	locret_1AA58
		move.b	#$1E,$37(a0)
		bsr.w	sub_19EEC
		bne.s	loc_1AA04
		move.b	#4,(a2)
		move.l	$32(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)

loc_1AA04:
		neg.w	(SS_rotation_speed).w
		move.w	#SndID_SSItem,d0
		jmp	(PlaySound).l
; ===========================================================================

loc_1AA12:
		cmpi.b	#$2D,d0
		beq.s	loc_1AA2A
		cmpi.b	#$2E,d0
		beq.s	loc_1AA2A
		cmpi.b	#$2F,d0
		beq.s	loc_1AA2A
		cmpi.b	#$30,d0
		bne.s	locret_1AA58

loc_1AA2A:
		bsr.w	sub_19EEC
		bne.s	loc_1AA4E
		move.b	#6,(a2)
		movea.l	$32(a0),a1
		subq.l	#1,a1
		move.l	a1,4(a2)
		move.b	(a1),d0
		addq.b	#1,d0
		cmpi.b	#$30,d0
		bls.s	loc_1AA4A
		clr.b	d0

loc_1AA4A:
		move.b	d0,4(a2)

loc_1AA4E:
		move.w	#SndID_SSGlass,d0
		jmp	(PlaySound).l
; ===========================================================================

locret_1AA58:
		rts
; End of function Obj09_ChkItems2