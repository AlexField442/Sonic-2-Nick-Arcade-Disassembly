; ===========================================================================
;----------------------------------------------------------------------------
; Object 02 - Tails
;----------------------------------------------------------------------------

Obj02:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj02_Index(pc,d0.w),d1
		jmp	Obj02_Index(pc,d1.w)
; ===========================================================================
Obj02_Index:	dc.w Obj02_Init-Obj02_Index		; 0
		dc.w Obj02_Control-Obj02_Index		; 2
		dc.w Obj02_Hurt-Obj02_Index		; 4
		dc.w Obj02_Dead-Obj02_Index		; 6
		dc.w Obj02_ResetLevel-Obj02_Index	; 8
; ===========================================================================
; Obj02_Main:
Obj02_Init:
		addq.b	#2,routine(a0)
		move.b	#$F,y_radius(a0)
		move.b	#9,x_radius(a0)
		move.l	#Map_Tails,mappings(a0)
		move.w	#$7A0,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#2,priority(a0)
		move.b	#$18,width_pixels(a0)
		move.b	#$84,render_flags(a0)
		move.w	#$600,(Sonic_top_speed).w
		move.w	#$C,(Sonic_acceleration).w
		move.w	#$80,(Sonic_deceleration).w
		move.b	#$C,top_solid_bit(a0)
		move.b	#$D,lrb_solid_bit(a0)
		move.b	#0,flips_remaining(a0)
		move.b	#4,flip_speed(a0)
		move.b	#5,(Object_RAM+$1C0).w	; load Tails' tails at $B1C0

; ---------------------------------------------------------------------------
; Normal state for Tails
; ---------------------------------------------------------------------------
Obj02_Control:
		bsr.w	Tails_Control
		btst	#0,($FFFFF7C8).w	; is Tails interacting with another object that holds him in place or controls his movement somehow?
		bne.s	Obj02_ControlsLock	; if yes, branch to skip Tails' control
		moveq	#0,d0
		move.b	status(a0),d0
		andi.w	#6,d0
		move.w	Obj02_Modes(pc,d0.w),d1
		jsr	Obj02_Modes(pc,d1.w)	; run Tails' movement code

Obj02_ControlsLock:
		bsr.s	Tails_Display
		bsr.w	RecordTailsMoves
		move.b	($FFFFF768).w,next_tilt(a0)
		move.b	($FFFFF76A).w,tilt(a0)
		bsr.w	Tails_Animate
		tst.b	($FFFFF7C8).w
		bmi.s	loc_10CFC
		jsr	(TouchResponse).l

loc_10CFC:
		bsr.w	LoadTailsDynPLC
		rts
; ===========================================================================
Obj02_Modes:	dc.w Obj02_MdNormal-Obj02_Modes
		dc.w Obj02_MdJump-Obj02_Modes
		dc.w Obj02_MdRoll-Obj02_Modes
		dc.w Obj02_MdJump2-Obj02_Modes
; ===========================================================================
; same as Sonic's...
MusicList_Tails:dc.b MusID_GHZ
		dc.b MusID_LZ
		dc.b MusID_CPZ
		dc.b MusID_EHZ
		dc.b MusID_HPZ
		dc.b MusID_HTZ
		even

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Tails_Display:
		move.w	invulnerable_time(a0),d0
		beq.s	Obj02_Display
		subq.w	#1,invulnerable_time(a0)
		lsr.w	#3,d0
		bcc.s	Obj02_ChkInvinc
; loc_10D1E:
Obj02_Display:
		jsr	(DisplaySprite).l
; loc_10D24:
Obj02_ChkInvinc:
		; checks if invincibility has expired and disables it if it has,
		; and unlike Sonic's version, functions normally...
		tst.b	($FFFFFE2D).w
		beq.s	Obj02_ChkShoes
		tst.w	invincibility_time(a0)
		beq.s	Obj02_ChkShoes
		subq.w	#1,invincibility_time(a0)
		bne.s	Obj02_ChkShoes
		tst.b	($FFFFF7AA).w
		bne.s	Obj02_RmvInvin
		cmpi.w	#$C,($FFFFFE14).w
		bcs.s	Obj02_RmvInvin
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		cmpi.w	#$103,(Current_ZoneAndAct).w
		bne.s	loc_10D54
		moveq	#5,d0

loc_10D54:
		lea	MusicList_Tails(pc),a1
		move.b	(a1,d0.w),d0
		jsr	(PlaySound).l
; loc_10D62:
Obj02_RmvInvin:
		move.b	#0,($FFFFFE2D).w
; loc_10D68:
Obj02_ChkShoes:
		; checks if Speed Shoes have expired and disables them if they have
		tst.b	($FFFFFE2E).w
		beq.s	Obj02_ExitChk
		tst.w	speedshoes_time(a0)
		beq.s	Obj02_ExitChk
		subq.w	#1,speedshoes_time(a0)
		bne.s	Obj02_ExitChk
		move.w	#$600,(Sonic_top_speed).w
		move.w	#$C,(Sonic_acceleration).w
		move.w	#$80,(Sonic_deceleration).w
; Obj02_RmvSpeed:
		move.b	#0,($FFFFFE2E).w
		move.w	#$E3,d0		; slow down tempo
		jmp	(PlaySound).l
; ===========================================================================
; locret_10D9C:
Obj02_ExitChk:
		rts
; End of function Tails_Display


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_Control:				; CODE XREF: ROM:Obj02_Controlp
		move.b	($FFFFF606).w,d0
		andi.b	#$7F,d0
		beq.s	TailsC_NoKeysPressed
		move.w	#0,(unk_F700).w
		move.w	#$12C,(Tails_control_counter).w
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

TailsC_NoKeysPressed:			; CODE XREF: Tails_Control+8j
		tst.w	(Tails_control_counter).w
		beq.s	TailsCPU_Control
		subq.w	#1,(Tails_control_counter).w
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; TailsC_DoControl:
TailsCPU_Control:
		move.w	(Tails_CPU_routine).w,d0
		move.w	TailsCPU_States(pc,d0.w),d0
		jmp	TailsCPU_States(pc,d0.w)
; ===========================================================================
; TailsC_Index:
TailsCPU_States:
		dc.w TailsC_00-TailsCPU_States
		dc.w TailsC_02-TailsCPU_States
		dc.w TailsC_04-TailsCPU_States
		dc.w TailsC_CopySonicMoves-TailsCPU_States
; ===========================================================================

TailsC_00:
		move.w	#6,(Tails_CPU_routine).w
		rts
; ===========================================================================

TailsC_02:
		move.w	#6,(Tails_CPU_routine).w
		rts
; ===========================================================================
		move.w	#$40,(unk_F706).w ; '@'
		move.w	#4,(Tails_CPU_routine).w

TailsC_04:
		move.w	#6,(Tails_CPU_routine).w
		rts
; ===========================================================================
		move.w	(unk_F706).w,d1
		subq.w	#1,d1
		cmpi.w	#$10,d1
		bne.s	loc_10E0C
		move.w	#6,(Tails_CPU_routine).w

loc_10E0C:
		move.w	d1,(unk_F706).w
		lea	(Tails_Pos_Record_Buf_OLD).w,a1
		lsl.b	#2,d1
		addq.b	#4,d1
		move.w	($FFFFEEE0).w,d0
		sub.b	d1,d0
		move.w	(a1,d0.w),x_pos(a0)
		move.w	2(a1,d0.w),y_pos(a0)
		rts
; ===========================================================================

TailsC_CopySonicMoves:			; DATA XREF: ROM:00010DD4o
		move.w	(MainCharacter+x_pos).w,d0
		sub.w	x_pos(a0),d0
		bpl.s	loc_10E38
		neg.w	d0

loc_10E38:				; CODE XREF: ROM:00010E34j
		cmpi.w	#$C0,d0	; 'À'
		bcs.s	loc_10E40
		nop

loc_10E40:				; CODE XREF: ROM:00010E3Cj
		lea	(Sonic_Pos_Record_Buf).w,a1
		move.w	#$10,d1
		lsl.b	#2,d1
		addq.b	#4,d1
		move.w	(Sonic_Pos_Record_Index).w,d0
		sub.b	d1,d0
		lea	(Sonic_Stat_Record_Buf).w,a1
		move.w	(a1,d0.w),($FFFFF606).w
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


RecordTailsMoves:			; CODE XREF: ROM:00010CDCp
		move.w	($FFFFEED6).w,d0
		lea	(Tails_Pos_Record_Buf).w,a1
		lea	(a1,d0.w),a1
		move.w	x_pos(a0),(a1)+
		move.w	y_pos(a0),(a1)+
		addq.b	#4,($FFFFEED7).w
		rts
; End of function RecordTailsMoves

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj02_MdNormal:				; DATA XREF: ROM:Obj02_Modeso
		bsr.w	Tails_Spindash
		bsr.w	Tails_Jump
		bsr.w	Tails_SlopeResist
		bsr.w	Tails_Move
		bsr.w	Tails_Roll
		bsr.w	Tails_LevelBoundaries
		jsr	(ObjectMove).l
		bsr.w	AnglePos
		bsr.w	Tails_SlopeRepel
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj02_MdJump:				; DATA XREF: ROM:00010D04o
		bsr.w	Tails_JumpHeight
		bsr.w	Tails_ChgJumpDir
		bsr.w	Tails_LevelBoundaries
		jsr	(ObjectMoveAndFall).l
		btst	#6,status(a0)
		beq.s	loc_10EC0
		subi.w	#$28,y_vel(a0) ; '('

loc_10EC0:				; CODE XREF: ROM:00010EB8j
		bsr.w	Tails_JumpAngle
		bsr.w	Tails_Floor
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj02_MdRoll:				; DATA XREF: ROM:00010D06o
		bsr.w	Tails_Jump
		bsr.w	Tails_RollRepel
		bsr.w	Tails_RollSpeed
		bsr.w	Tails_LevelBoundaries
		jsr	(ObjectMove).l
		bsr.w	AnglePos
		bsr.w	Tails_SlopeRepel
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj02_MdJump2:				; DATA XREF: ROM:00010D08o
		bsr.w	Tails_JumpHeight
		bsr.w	Tails_ChgJumpDir
		bsr.w	Tails_LevelBoundaries
		jsr	(ObjectMoveAndFall).l
		btst	#6,status(a0)
		beq.s	loc_10F0A
		subi.w	#$28,y_vel(a0) ; '('

loc_10F0A:				; CODE XREF: ROM:00010F02j
		bsr.w	Tails_JumpAngle
		bsr.w	Tails_Floor
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_Move:				; CODE XREF: ROM:00010E84p
		move.w	(Sonic_top_speed).w,d6
		move.w	(Sonic_acceleration).w,d5
		move.w	(Sonic_deceleration).w,d4
		tst.b	($FFFFF7CA).w
		bne.w	loc_11026
		tst.w	move_lock(a0)
		bne.w	loc_10FFA
		btst	#2,($FFFFF606).w
		beq.s	loc_10F3C
		bsr.w	Tails_MoveLeft

loc_10F3C:				; CODE XREF: Tails_Move+22j
		btst	#3,($FFFFF606).w
		beq.s	loc_10F48
		bsr.w	Tails_MoveRight

loc_10F48:				; CODE XREF: Tails_Move+2Ej
		move.b	angle(a0),d0
		addi.b	#$20,d0	; ' '
		andi.b	#$C0,d0
		bne.w	loc_10FFA
		tst.w	inertia(a0)
		bne.w	loc_10FFA
		bclr	#5,status(a0)
		move.b	#5,anim(a0)
		btst	#3,status(a0)
		beq.s	Tails_Balance
		moveq	#0,d0
		move.b	interact(a0),d0
		lsl.w	#6,d0
		lea	(MainCharacter).w,a1
		lea	(a1,d0.w),a1
		tst.b	status(a1)
		bmi.s	Tails_LookUp
		moveq	#0,d1
		move.b	width_pixels(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#4,d2
		add.w	x_pos(a0),d1
		sub.w	x_pos(a1),d1
		cmpi.w	#4,d1
		blt.s	loc_10FCE
		cmp.w	d2,d1
		bge.s	loc_10FBE
		bra.s	Tails_LookUp
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Tails_Balance:				; CODE XREF: Tails_Move+5Ej
		jsr	(ObjHitFloor).l
		cmpi.w	#$C,d1
		blt.s	Tails_LookUp
		cmpi.b	#3,next_tilt(a0)
		bne.s	loc_10FC6

loc_10FBE:				; CODE XREF: Tails_Move+92j
		bclr	#0,status(a0)
		bra.s	loc_10FD4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_10FC6:				; CODE XREF: Tails_Move+A8j
		cmpi.b	#3,tilt(a0)
		bne.s	Tails_LookUp

loc_10FCE:				; CODE XREF: Tails_Move+8Ej
		bset	#0,status(a0)

loc_10FD4:				; CODE XREF: Tails_Move+B0j
		move.b	#6,anim(a0)
		bra.s	loc_10FFA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Tails_LookUp:				; CODE XREF: Tails_Move+74j
					; Tails_Move+94j ...
		btst	#0,($FFFFF606).w
		beq.s	Tails_Duck
		move.b	#7,anim(a0)
		bra.s	loc_10FFA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Tails_Duck:				; CODE XREF: Tails_Move+CEj
		btst	#1,($FFFFF606).w
		beq.s	loc_10FFA
		move.b	#8,anim(a0)

loc_10FFA:				; CODE XREF: Tails_Move+18j
					; Tails_Move+40j ...
		move.b	($FFFFF606).w,d0

loc_10FFE:
		andi.b	#$C,d0
		bne.s	loc_11026
		move.w	inertia(a0),d0
		beq.s	loc_11026
		bmi.s	loc_1101A
		sub.w	d5,d0
		bcc.s	loc_11014
		move.w	#0,d0

loc_11014:				; CODE XREF: Tails_Move+FAj
		move.w	d0,inertia(a0)
		bra.s	loc_11026
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1101A:				; CODE XREF: Tails_Move+F6j
		add.w	d5,d0
		bcc.s	loc_11022
		move.w	#0,d0

loc_11022:				; CODE XREF: Tails_Move+108j
		move.w	d0,inertia(a0)

loc_11026:				; CODE XREF: Tails_Move+10j
					; Tails_Move+EEj ...
		move.b	angle(a0),d0
		jsr	(CalcSine).l
		muls.w	inertia(a0),d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	inertia(a0),d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)

loc_11044:				; CODE XREF: Tails_RollSpeed+AEj
		move.b	angle(a0),d0
		addi.b	#$40,d0	; '@'
		bmi.s	locret_110B4
		move.b	#$40,d1	; '@'
		tst.w	inertia(a0)
		beq.s	locret_110B4
		bmi.s	loc_1105C
		neg.w	d1

loc_1105C:				; CODE XREF: Tails_Move+144j
		move.b	angle(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		bsr.w	CalcRoomInFront
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	locret_110B4
		asl.w	#8,d1
		addi.b	#$20,d0	; ' '
		andi.b	#$C0,d0
		beq.s	loc_110B0
		cmpi.b	#$40,d0	; '@'
		beq.s	loc_1109E
		cmpi.b	#$80,d0
		beq.s	loc_11098
		add.w	d1,x_vel(a0)
		bset	#5,status(a0)
		move.w	#0,inertia(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11098:				; CODE XREF: Tails_Move+170j
		sub.w	d1,y_vel(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1109E:				; CODE XREF: Tails_Move+16Aj
		sub.w	d1,x_vel(a0)
		bset	#5,status(a0)
		move.w	#0,inertia(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_110B0:				; CODE XREF: Tails_Move+164j
		add.w	d1,y_vel(a0)

locret_110B4:				; CODE XREF: Tails_Move+138j
					; Tails_Move+142j ...
		rts
; End of function Tails_Move


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_MoveLeft:				; CODE XREF: Tails_Move+24p
		move.w	inertia(a0),d0
		beq.s	loc_110BE
		bpl.s	loc_110EA

loc_110BE:				; CODE XREF: Tails_MoveLeft+4j
		bset	#0,status(a0)
		bne.s	loc_110D2
		bclr	#5,status(a0)
		move.b	#1,prev_anim(a0)

loc_110D2:				; CODE XREF: Tails_MoveLeft+Ej
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_110DE
		move.w	d1,d0

loc_110DE:				; CODE XREF: Tails_MoveLeft+24j
		move.w	d0,inertia(a0)
		move.b	#0,anim(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_110EA:				; CODE XREF: Tails_MoveLeft+6j
		sub.w	d4,d0
		bcc.s	loc_110F2
		move.w	#$FF80,d0

loc_110F2:				; CODE XREF: Tails_MoveLeft+36j
		move.w	d0,inertia(a0)
		move.b	angle(a0),d0
		addi.b	#$20,d0	; ' '
		andi.b	#$C0,d0
		bne.s	locret_11120
		cmpi.w	#$400,d0
		blt.s	locret_11120
		move.b	#$D,anim(a0)
		bclr	#0,status(a0)
		move.w	#$A4,d0	; '¤'
		jsr	(PlaySound_Special).l

locret_11120:				; CODE XREF: Tails_MoveLeft+4Cj
					; Tails_MoveLeft+52j
		rts
; End of function Tails_MoveLeft


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_MoveRight:			; CODE XREF: Tails_Move+30p
		move.w	inertia(a0),d0
		bmi.s	loc_11150
		bclr	#0,status(a0)
		beq.s	loc_1113C
		bclr	#5,status(a0)
		move.b	#1,prev_anim(a0)

loc_1113C:				; CODE XREF: Tails_MoveRight+Cj
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_11144
		move.w	d6,d0

loc_11144:				; CODE XREF: Tails_MoveRight+1Ej
		move.w	d0,inertia(a0)
		move.b	#0,anim(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11150:				; CODE XREF: Tails_MoveRight+4j
		add.w	d4,d0
		bcc.s	loc_11158
		move.w	#$80,d0	; '€'

loc_11158:				; CODE XREF: Tails_MoveRight+30j
		move.w	d0,inertia(a0)
		move.b	angle(a0),d0
		addi.b	#$20,d0	; ' '
		andi.b	#$C0,d0
		bne.s	locret_11186
		cmpi.w	#$FC00,d0
		bgt.s	locret_11186
		move.b	#$D,anim(a0)
		bset	#0,status(a0)
		move.w	#$A4,d0	; '¤'
		jsr	(PlaySound_Special).l

locret_11186:				; CODE XREF: Tails_MoveRight+46j
					; Tails_MoveRight+4Cj
		rts
; End of function Tails_MoveRight


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_RollSpeed:			; CODE XREF: ROM:00010ED2p
		move.w	(Sonic_top_speed).w,d6
		asl.w	#1,d6
		move.w	(Sonic_acceleration).w,d5
		asr.w	#1,d5
		move.w	(Sonic_deceleration).w,d4
		asr.w	#2,d4
		tst.b	($FFFFF7CA).w
		bne.w	loc_11204
		tst.w	move_lock(a0)
		bne.s	loc_111C0
		btst	#2,($FFFFF606).w
		beq.s	loc_111B4
		bsr.w	Tails_RollLeft

loc_111B4:				; CODE XREF: Tails_RollSpeed+26j
		btst	#3,($FFFFF606).w
		beq.s	loc_111C0
		bsr.w	Tails_RollRight

loc_111C0:				; CODE XREF: Tails_RollSpeed+1Ej
					; Tails_RollSpeed+32j
		move.w	inertia(a0),d0
		beq.s	loc_111E2
		bmi.s	loc_111D6
		sub.w	d5,d0
		bcc.s	loc_111D0
		move.w	#0,d0

loc_111D0:				; CODE XREF: Tails_RollSpeed+42j
		move.w	d0,inertia(a0)
		bra.s	loc_111E2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_111D6:				; CODE XREF: Tails_RollSpeed+3Ej
		add.w	d5,d0
		bcc.s	loc_111DE
		move.w	#0,d0

loc_111DE:				; CODE XREF: Tails_RollSpeed+50j
		move.w	d0,inertia(a0)

loc_111E2:				; CODE XREF: Tails_RollSpeed+3Cj
					; Tails_RollSpeed+4Cj
		tst.w	inertia(a0)
		bne.s	loc_11204
		bclr	#2,status(a0)
		move.b	#$F,y_radius(a0)
		move.b	#9,x_radius(a0)
		move.b	#5,anim(a0)
		subq.w	#5,y_pos(a0)

loc_11204:				; CODE XREF: Tails_RollSpeed+16j
					; Tails_RollSpeed+5Ej
		move.b	angle(a0),d0
		jsr	(CalcSine).l
		muls.w	inertia(a0),d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		muls.w	inertia(a0),d1
		asr.l	#8,d1
		cmpi.w	#$1000,d1
		ble.s	loc_11228
		move.w	#$1000,d1

loc_11228:				; CODE XREF: Tails_RollSpeed+9Aj
		cmpi.w	#$F000,d1
		bge.s	loc_11232
		move.w	#$F000,d1

loc_11232:				; CODE XREF: Tails_RollSpeed+A4j
		move.w	d1,x_vel(a0)
		bra.w	loc_11044
; End of function Tails_RollSpeed


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_RollLeft:				; CODE XREF: Tails_RollSpeed+28p
		move.w	inertia(a0),d0
		beq.s	loc_11242
		bpl.s	loc_11250

loc_11242:				; CODE XREF: Tails_RollLeft+4j
		bset	#0,status(a0)
		move.b	#2,anim(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11250:				; CODE XREF: Tails_RollLeft+6j
		sub.w	d4,d0
		bcc.s	loc_11258
		move.w	#$FF80,d0

loc_11258:				; CODE XREF: Tails_RollLeft+18j
		move.w	d0,inertia(a0)
		rts
; End of function Tails_RollLeft


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_RollRight:			; CODE XREF: Tails_RollSpeed+34p
		move.w	inertia(a0),d0
		bmi.s	loc_11272
		bclr	#0,status(a0)
		move.b	#2,anim(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11272:				; CODE XREF: Tails_RollRight+4j
		add.w	d4,d0
		bcc.s	loc_1127A
		move.w	#$80,d0	; '€'

loc_1127A:				; CODE XREF: Tails_RollRight+16j
		move.w	d0,inertia(a0)
		rts
; End of function Tails_RollRight


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_ChgJumpDir:			; CODE XREF: ROM:00010EA4p
					; ROM:00010EEEp
		move.w	(Sonic_top_speed).w,d6
		move.w	(Sonic_acceleration).w,d5
		asl.w	#1,d5
		btst	#4,status(a0)
		bne.s	loc_112CA
		move.w	x_vel(a0),d0
		btst	#2,($FFFFF606).w
		beq.s	loc_112B0
		bset	#0,status(a0)
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_112B0
		move.w	d1,d0

loc_112B0:				; CODE XREF: Tails_ChgJumpDir+1Cj
					; Tails_ChgJumpDir+2Cj
		btst	#3,($FFFFF606).w
		beq.s	loc_112C6
		bclr	#0,status(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_112C6
		move.w	d6,d0

loc_112C6:				; CODE XREF: Tails_ChgJumpDir+36j
					; Tails_ChgJumpDir+42j
		move.w	d0,x_vel(a0)

loc_112CA:				; CODE XREF: Tails_ChgJumpDir+10j
		cmpi.w	#$60,($FFFFEED8).w ; '`'
		beq.s	loc_112DC
		bcc.s	loc_112D8
		addq.w	#4,($FFFFEED8).w

loc_112D8:				; CODE XREF: Tails_ChgJumpDir+52j
		subq.w	#2,($FFFFEED8).w

loc_112DC:				; CODE XREF: Tails_ChgJumpDir+50j
		cmpi.w	#$FC00,y_vel(a0)
		bcs.s	locret_1130A
		move.w	x_vel(a0),d0
		move.w	d0,d1
		asr.w	#5,d1
		beq.s	locret_1130A
		bmi.s	loc_112FE
		sub.w	d1,d0
		bcc.s	loc_112F8
		move.w	#0,d0

loc_112F8:				; CODE XREF: Tails_ChgJumpDir+72j
		move.w	d0,x_vel(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_112FE:				; CODE XREF: Tails_ChgJumpDir+6Ej
		sub.w	d1,d0
		bcs.s	loc_11306
		move.w	#0,d0

loc_11306:				; CODE XREF: Tails_ChgJumpDir+80j
		move.w	d0,x_vel(a0)

locret_1130A:				; CODE XREF: Tails_ChgJumpDir+62j
					; Tails_ChgJumpDir+6Cj
		rts
; End of function Tails_ChgJumpDir


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_LevelBoundaries:			; CODE XREF: ROM:00010E8Cp
					; ROM:00010EA8p ...

; FUNCTION CHUNK AT 00011E5C SIZE 00000006 BYTES

		move.l	x_pos(a0),d1
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(Camera_Min_X_pos).w,d0
		addi.w	#$10,d0
		cmp.w	d1,d0
		bhi.s	loc_11374
		move.w	(Camera_Max_X_pos).w,d0
		addi.w	#$128,d0
		tst.b	($FFFFF7AA).w
		bne.s	loc_1133A
		addi.w	#$40,d0	; '@'

loc_1133A:				; CODE XREF: Tails_LevelBoundaries+28j
		cmp.w	d1,d0
		bls.s	loc_11374

loc_1133E:				; CODE XREF: Tails_LevelBoundaries+7Ej
		move.w	(Camera_Max_Y_pos).w,d0
		addi.w	#$E0,d0	; 'à'
		cmp.w	y_pos(a0),d0
		blt.s	loc_1134E
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1134E:				; CODE XREF: Tails_LevelBoundaries+3Ej
		cmpi.w	#$501,(Current_ZoneAndAct).w
		bne.w	KillTails
		cmpi.w	#$2000,x_pos(a0)
		bcs.w	KillTails
		clr.b	($FFFFFE30).w
		move.w	#1,($FFFFFE02).w
		move.w	#$103,(Current_ZoneAndAct).w
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11374:				; CODE XREF: Tails_LevelBoundaries+1Aj
					; Tails_LevelBoundaries+30j
		move.w	d0,x_pos(a0)
		move.w	#0,x_sub(a0)
		move.w	#0,x_vel(a0)
		move.w	#0,inertia(a0)
		bra.s	loc_1133E
; End of function Tails_LevelBoundaries


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_Roll:				; CODE XREF: ROM:00010E88p
		tst.b	($FFFFF7CA).w
		bne.s	locret_113B2
		move.w	inertia(a0),d0
		bpl.s	loc_1139A
		neg.w	d0

loc_1139A:				; CODE XREF: Tails_Roll+Aj
		cmpi.w	#$80,d0	; '€'
		bcs.s	locret_113B2
		move.b	($FFFFF606).w,d0
		andi.b	#$C,d0
		bne.s	locret_113B2
		btst	#1,($FFFFF606).w
		bne.s	loc_113B4

locret_113B2:				; CODE XREF: Tails_Roll+4j
					; Tails_Roll+12j ...
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_113B4:				; CODE XREF: Tails_Roll+24j
		btst	#2,status(a0)
		beq.s	loc_113BE
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_113BE:				; CODE XREF: Tails_Roll+2Ej
		bset	#2,status(a0)
		move.b	#$E,y_radius(a0)
		move.b	#7,x_radius(a0)
		move.b	#2,anim(a0)
		addq.w	#5,y_pos(a0)
		move.w	#$BE,d0	; '¾'
		jsr	(PlaySound_Special).l
		tst.w	inertia(a0)
		bne.s	locret_113F0
		move.w	#$200,inertia(a0)

locret_113F0:				; CODE XREF: Tails_Roll+5Cj
		rts
; End of function Tails_Roll


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_Jump:				; CODE XREF: ROM:00010E7Cp
					; ROM:Obj02_MdRollp
		move.b	($FFFFF607).w,d0
		andi.b	#$70,d0	; 'p'
		beq.w	locret_11496
		moveq	#0,d0
		move.b	angle(a0),d0

loc_11404:
		addi.b	#$80,d0

loc_11408:
		bsr.w	sub_13102
		cmpi.w	#6,d1
		blt.w	locret_11496
		move.w	#$680,d2
		btst	#6,status(a0)
		beq.s	loc_11424
		move.w	#$380,d2

loc_11424:				; CODE XREF: Tails_Jump+2Cj
		moveq	#0,d0
		move.b	angle(a0),d0
		subi.b	#$40,d0	; '@'
		jsr	(CalcSine).l
		muls.w	d2,d1
		asr.l	#8,d1
		add.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		add.w	d0,y_vel(a0)
		bset	#1,status(a0)
		bclr	#5,status(a0)
		addq.l	#4,sp
		move.b	#1,jumping(a0)
		clr.b	stick_to_convex(a0)
		move.w	#$A0,d0	; ' '
		jsr	(PlaySound_Special).l
		move.b	#$F,y_radius(a0)
		move.b	#9,x_radius(a0)
		btst	#2,status(a0)
		bne.s	loc_11498
		move.b	#$E,y_radius(a0)
		move.b	#7,x_radius(a0)
		move.b	#2,anim(a0)
		bset	#2,status(a0)
		addq.w	#5,y_pos(a0)

locret_11496:				; CODE XREF: Tails_Jump+8j
					; Tails_Jump+1Ej
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11498:				; CODE XREF: Tails_Jump+86j
		bset	#4,status(a0)
		rts
; End of function Tails_Jump


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_JumpHeight:			; CODE XREF: ROM:Obj02_MdJumpp
					; ROM:Obj02_MdJump2p
		tst.b	jumping(a0)
		beq.s	loc_114CC
		move.w	#$FC00,d1
		btst	#6,status(a0)
		beq.s	loc_114B6
		move.w	#$FE00,d1

loc_114B6:				; CODE XREF: Tails_JumpHeight+10j
		cmp.w	y_vel(a0),d1
		ble.s	locret_114CA
		move.b	($FFFFF606).w,d0
		andi.b	#$70,d0	; 'p'
		bne.s	locret_114CA
		move.w	d1,y_vel(a0)

locret_114CA:				; CODE XREF: Tails_JumpHeight+1Aj
					; Tails_JumpHeight+24j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_114CC:				; CODE XREF: Tails_JumpHeight+4j
		cmpi.w	#$F040,y_vel(a0)
		bge.s	locret_114DA
		move.w	#$F040,y_vel(a0)

locret_114DA:				; CODE XREF: Tails_JumpHeight+32j
		rts
; End of function Tails_JumpHeight


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_Spindash:				; CODE XREF: ROM:Obj02_MdNormalp
		tst.b	spindash_flag(a0)
		bne.s	loc_11510
		cmpi.b	#8,anim(a0)
		bne.s	locret_1150E
		move.b	($FFFFF607).w,d0
		andi.b	#$70,d0	; 'p'
		beq.w	locret_1150E
		move.b	#9,anim(a0)
		move.w	#$BE,d0	; '¾'
		jsr	(PlaySound_Special).l
		addq.l	#4,sp
		move.b	#1,spindash_flag(a0)

locret_1150E:				; CODE XREF: Tails_Spindash+Cj
					; Tails_Spindash+16j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11510:				; CODE XREF: Tails_Spindash+4j
		move.b	($FFFFF606).w,d0
		btst	#1,d0
		bne.s	loc_11556
		move.b	#$E,y_radius(a0)
		move.b	#7,x_radius(a0)
		move.b	#2,anim(a0)
		addq.w	#5,y_pos(a0)
		move.b	#0,spindash_flag(a0)
		move.w	#$2000,(Horiz_scroll_delay_val).w
		move.w	#$800,inertia(a0)
		btst	#0,status(a0)
		beq.s	loc_1154E
		neg.w	inertia(a0)

loc_1154E:				; CODE XREF: Tails_Spindash+6Cj
		bset	#2,status(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11556:				; CODE XREF: Tails_Spindash+3Cj
		move.b	($FFFFF607).w,d0
		andi.b	#$70,d0	; 'p'
		beq.w	loc_11564
		nop

loc_11564:				; CODE XREF: Tails_Spindash+82j
		addq.l	#4,sp
		rts
; End of function Tails_Spindash


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_SlopeResist:			; CODE XREF: ROM:00010E80p
		move.b	angle(a0),d0
		addi.b	#$60,d0	; '`'
		cmpi.b	#$C0,d0
		bcc.s	locret_1159C
		move.b	angle(a0),d0
		jsr	(CalcSine).l
		muls.w	#$20,d0	; ' '
		asr.l	#8,d0
		tst.w	inertia(a0)
		beq.s	locret_1159C
		bmi.s	loc_11598
		tst.w	d0
		beq.s	locret_11596
		add.w	d0,inertia(a0)

locret_11596:				; CODE XREF: Tails_SlopeResist+28j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11598:				; CODE XREF: Tails_SlopeResist+24j
		add.w	d0,inertia(a0)

locret_1159C:				; CODE XREF: Tails_SlopeResist+Cj
					; Tails_SlopeResist+22j
		rts
; End of function Tails_SlopeResist


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_RollRepel:			; CODE XREF: ROM:00010ECEp
		move.b	angle(a0),d0
		addi.b	#$60,d0	; '`'
		cmpi.b	#$C0,d0
		bcc.s	locret_115D8
		move.b	angle(a0),d0
		jsr	(CalcSine).l
		muls.w	#$50,d0	; 'P'
		asr.l	#8,d0
		tst.w	inertia(a0)
		bmi.s	loc_115CE
		tst.w	d0
		bpl.s	loc_115C8
		asr.l	#2,d0

loc_115C8:				; CODE XREF: Tails_RollRepel+26j
		add.w	d0,inertia(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_115CE:				; CODE XREF: Tails_RollRepel+22j
		tst.w	d0
		bmi.s	loc_115D4
		asr.l	#2,d0

loc_115D4:				; CODE XREF: Tails_RollRepel+32j
		add.w	d0,inertia(a0)

locret_115D8:				; CODE XREF: Tails_RollRepel+Cj
		rts
; End of function Tails_RollRepel


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_SlopeRepel:			; CODE XREF: ROM:00010E9Ap
					; ROM:00010EE4p
		nop
		tst.b	stick_to_convex(a0)
		bne.s	locret_11614
		tst.w	move_lock(a0)
		bne.s	loc_11616
		move.b	angle(a0),d0
		addi.b	#$20,d0	; ' '
		andi.b	#$C0,d0
		beq.s	locret_11614
		move.w	inertia(a0),d0
		bpl.s	loc_115FE
		neg.w	d0

loc_115FE:				; CODE XREF: Tails_SlopeRepel+20j
		cmpi.w	#$280,d0
		bcc.s	locret_11614
		clr.w	inertia(a0)
		bset	#1,status(a0)
		move.w	#$1E,move_lock(a0)

locret_11614:				; CODE XREF: Tails_SlopeRepel+6j
					; Tails_SlopeRepel+1Aj	...
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11616:				; CODE XREF: Tails_SlopeRepel+Cj
		subq.w	#1,move_lock(a0)
		rts
; End of function Tails_SlopeRepel


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_JumpAngle:			; CODE XREF: ROM:loc_10EC0p
					; ROM:loc_10F0Ap
		move.b	angle(a0),d0
		beq.s	loc_11636
		bpl.s	loc_1162C
		addq.b	#2,d0
		bcc.s	loc_1162A
		moveq	#0,d0

loc_1162A:				; CODE XREF: Tails_JumpAngle+Aj
		bra.s	loc_11632
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1162C:				; CODE XREF: Tails_JumpAngle+6j
		subq.b	#2,d0
		bcc.s	loc_11632
		moveq	#0,d0

loc_11632:				; CODE XREF: Tails_JumpAngle:loc_1162Aj
					; Tails_JumpAngle+12j
		move.b	d0,angle(a0)

loc_11636:				; CODE XREF: Tails_JumpAngle+4j
		move.b	flip_angle(a0),d0
		beq.s	locret_11674
		tst.w	inertia(a0)
		bmi.s	loc_1165A
		move.b	flip_speed(a0),d1
		add.b	d1,d0
		bcc.s	loc_11658
		subq.b	#1,flips_remaining(a0)
		bcc.s	loc_11658
		move.b	#0,flips_remaining(a0)
		moveq	#0,d0

loc_11658:				; CODE XREF: Tails_JumpAngle+2Cj
					; Tails_JumpAngle+32j
		bra.s	loc_11670
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1165A:				; CODE XREF: Tails_JumpAngle+24j
		move.b	flip_speed(a0),d1
		sub.b	d1,d0
		bcc.s	loc_11670
		subq.b	#1,flips_remaining(a0)
		bcc.s	loc_11670
		move.b	#0,flips_remaining(a0)
		moveq	#0,d0

loc_11670:				; CODE XREF: Tails_JumpAngle:loc_11658j
					; Tails_JumpAngle+44j ...
		move.b	d0,flip_angle(a0)

locret_11674:				; CODE XREF: Tails_JumpAngle+1Ej
		rts
; End of function Tails_JumpAngle


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_Floor:				; CODE XREF: ROM:00010EC4p
					; ROM:00010F0Ep ...
		move.b	lrb_solid_bit(a0),d5
		move.w	x_vel(a0),d1
		move.w	y_vel(a0),d2
		jsr	(CalcAngle).l
		subi.b	#$20,d0	; ' '
		andi.b	#$C0,d0
		cmpi.b	#$40,d0	; '@'
		beq.w	loc_11746
		cmpi.b	#$80,d0
		beq.w	loc_117A8
		cmpi.b	#$C0,d0
		beq.w	loc_11804
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_116BA
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_116BA:				; CODE XREF: Tails_Floor+38j
		bsr.w	sub_132EE
		tst.w	d1
		bpl.s	loc_116CC
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_116CC:				; CODE XREF: Tails_Floor+4Aj
		bsr.w	loc_13146
		tst.w	d1
		bpl.s	locret_11744
		move.b	y_vel(a0),d2
		addq.b	#8,d2
		neg.b	d2
		cmp.b	d2,d1
		bge.s	loc_116E4
		cmp.b	d2,d0
		blt.s	locret_11744

loc_116E4:				; CODE XREF: Tails_Floor+68j
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		bsr.w	Tails_ResetTailsOnFloor
		move.b	#0,anim(a0)
		move.b	d3,d0
		addi.b	#$20,d0	; ' '
		andi.b	#$40,d0	; '@'
		bne.s	loc_11722
		move.b	d3,d0
		addi.b	#$10,d0
		andi.b	#$20,d0	; ' '
		beq.s	loc_11714
		asr	y_vel(a0)
		bra.s	loc_11736
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11714:				; CODE XREF: Tails_Floor+96j
		move.w	#0,y_vel(a0)
		move.w	x_vel(a0),inertia(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11722:				; CODE XREF: Tails_Floor+8Aj
		move.w	#0,x_vel(a0)
		cmpi.w	#$FC0,y_vel(a0)
		ble.s	loc_11736
		move.w	#$FC0,y_vel(a0)

loc_11736:				; CODE XREF: Tails_Floor+9Cj
					; Tails_Floor+B8j
		move.w	y_vel(a0),inertia(a0)
		tst.b	d3
		bpl.s	locret_11744
		neg.w	inertia(a0)

locret_11744:				; CODE XREF: Tails_Floor+5Cj
					; Tails_Floor+6Cj ...
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11746:				; CODE XREF: Tails_Floor+1Ej
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_11760
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		move.w	y_vel(a0),inertia(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11760:				; CODE XREF: Tails_Floor+D6j
		bsr.w	Sonic_DontRunOnWalls
		tst.w	d1
		bpl.s	loc_1177A
		sub.w	d1,y_pos(a0)
		tst.w	y_vel(a0)
		bpl.s	locret_11778
		move.w	#0,y_vel(a0)

locret_11778:				; CODE XREF: Tails_Floor+FAj
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1177A:				; CODE XREF: Tails_Floor+F0j
		tst.w	y_vel(a0)
		bmi.s	locret_117A6
		bsr.w	loc_13146
		tst.w	d1
		bpl.s	locret_117A6
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		bsr.w	Tails_ResetTailsOnFloor
		move.b	#0,anim(a0)
		move.w	#0,y_vel(a0)
		move.w	x_vel(a0),inertia(a0)

locret_117A6:				; CODE XREF: Tails_Floor+108j
					; Tails_Floor+110j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_117A8:				; CODE XREF: Tails_Floor+26j
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_117BA
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_117BA:				; CODE XREF: Tails_Floor+138j
		bsr.w	sub_132EE
		tst.w	d1
		bpl.s	loc_117CC
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_117CC:				; CODE XREF: Tails_Floor+14Aj
		bsr.w	Sonic_DontRunOnWalls
		tst.w	d1
		bpl.s	locret_11802
		sub.w	d1,y_pos(a0)
		move.b	d3,d0
		addi.b	#$20,d0	; ' '
		andi.b	#$40,d0	; '@'
		bne.s	loc_117EC
		move.w	#0,y_vel(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_117EC:				; CODE XREF: Tails_Floor+16Cj
		move.b	d3,angle(a0)
		bsr.w	Tails_ResetTailsOnFloor
		move.w	y_vel(a0),inertia(a0)
		tst.b	d3
		bpl.s	locret_11802
		neg.w	inertia(a0)

locret_11802:				; CODE XREF: Tails_Floor+15Cj
					; Tails_Floor+186j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11804:				; CODE XREF: Tails_Floor+2Ej
		bsr.w	sub_132EE
		tst.w	d1
		bpl.s	loc_1181E
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		move.w	y_vel(a0),inertia(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1181E:				; CODE XREF: Tails_Floor+194j
		bsr.w	Sonic_DontRunOnWalls
		tst.w	d1
		bpl.s	loc_11838
		sub.w	d1,y_pos(a0)
		tst.w	y_vel(a0)
		bpl.s	locret_11836
		move.w	#0,y_vel(a0)

locret_11836:				; CODE XREF: Tails_Floor+1B8j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11838:				; CODE XREF: Tails_Floor+1AEj
		tst.w	y_vel(a0)
		bmi.s	locret_11864
		bsr.w	loc_13146
		tst.w	d1
		bpl.s	locret_11864
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		bsr.w	Tails_ResetTailsOnFloor
		move.b	#0,anim(a0)
		move.w	#0,y_vel(a0)
		move.w	x_vel(a0),inertia(a0)

locret_11864:				; CODE XREF: Tails_Floor+1C6j
					; Tails_Floor+1CEj
		rts
; End of function Tails_Floor


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_ResetTailsOnFloor:		; CODE XREF: RideObject_SetRide:loc_F954p
					; Tails_Floor+76p ...
		btst	#4,status(a0)
		beq.s	loc_11874
		nop
		nop
		nop

loc_11874:				; CODE XREF: Tails_ResetTailsOnFloor+6j
		bclr	#5,status(a0)
		bclr	#1,status(a0)
		bclr	#4,status(a0)
		btst	#2,status(a0)
		beq.s	loc_118AA
		bclr	#2,status(a0)
		move.b	#$F,y_radius(a0)
		move.b	#9,x_radius(a0)
		move.b	#0,anim(a0)
		subq.w	#1,y_pos(a0)

loc_118AA:				; CODE XREF: Tails_ResetTailsOnFloor+26j
		move.b	#0,jumping(a0)
		move.w	#0,($FFFFF7D0).w
		move.b	#0,flip_angle(a0)
		rts
; End of function Tails_ResetTailsOnFloor

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj02_Hurt:				; DATA XREF: ROM:Obj02_Indexo
		jsr	(ObjectMove).l
		addi.w	#$30,y_vel(a0) ; '0'
		btst	#6,status(a0)
		beq.s	loc_118D8
		subi.w	#$20,y_vel(a0) ; ' '

loc_118D8:				; CODE XREF: ROM:000118D0j
		bsr.w	Tails_HurtStop
		bsr.w	Tails_LevelBoundaries
		bsr.w	Tails_Animate
		bsr.w	LoadTailsDynPLC
		jmp	(DisplaySprite).l

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_HurtStop:				; CODE XREF: ROM:loc_118D8p
		move.w	(Camera_Max_Y_pos).w,d0
		addi.w	#$E0,d0	; 'à'
		cmp.w	y_pos(a0),d0
		bcs.w	KillTails
		bsr.w	Tails_Floor
		btst	#1,status(a0)
		bne.s	locret_1192A
		moveq	#0,d0
		move.w	d0,y_vel(a0)
		move.w	d0,x_vel(a0)
		move.w	d0,inertia(a0)
		move.b	#0,anim(a0)
		move.b	#2,routine(a0)
		move.w	#$78,invulnerable_time(a0) ; 'x'

locret_1192A:				; CODE XREF: Tails_HurtStop+1Aj
		rts
; End of function Tails_HurtStop

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj02_Dead:				; DATA XREF: ROM:Obj02_Indexo
		bsr.w	Tails_GameOver
		jsr	(ObjectMoveAndFall).l
		bsr.w	Tails_Animate
		bsr.w	LoadTailsDynPLC
		jmp	(DisplaySprite).l

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_GameOver:				; CODE XREF: ROM:Obj02_Deadp
		move.w	(Camera_Max_Y_pos).w,d0
		addi.w	#$100,d0
		cmp.w	y_pos(a0),d0
		bcc.w	locret_11986
		move.w	(MainCharacter+x_pos).w,d0
		subi.w	#$40,d0	; '@'
		move.w	d0,x_pos(a0)
		move.w	(MainCharacter+y_pos).w,d0
		subi.w	#$80,d0	; '€'
		move.w	d0,y_pos(a0)
		move.b	#2,routine(a0)
		andi.w	#$7FFF,art_tile(a0)
		move.b	#$C,top_solid_bit(a0)
		move.b	#$D,lrb_solid_bit(a0)
		nop

locret_11986:				; CODE XREF: Tails_GameOver+Cj
		rts
; End of function Tails_GameOver

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj02_ResetLevel:			; DATA XREF: ROM:Obj02_Indexo
		tst.w	$3A(a0)
		beq.s	locret_1199A
		subq.w	#1,$3A(a0)
		bne.s	locret_1199A
		move.w	#1,($FFFFFE02).w

locret_1199A:				; CODE XREF: ROM:0001198Cj
					; ROM:00011992j
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Tails_Animate:				; CODE XREF: ROM:00010CECp
					; ROM:000118E0p ...

; FUNCTION CHUNK AT 00011A2E SIZE 000001AE BYTES

		lea	(TailsAniData).l,a1

Tails_Animate2:				; CODE XREF: ROM:00011DECp
		moveq	#0,d0
		move.b	anim(a0),d0
		cmp.b	prev_anim(a0),d0
		beq.s	loc_119BE
		move.b	d0,prev_anim(a0)
		move.b	#0,anim_frame(a0)
		move.b	#0,anim_frame_duration(a0)

loc_119BE:				; CODE XREF: Tails_Animate+10j
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		move.b	(a1),d0
		bmi.s	loc_11A2E
		move.b	status(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,render_flags(a0)
		or.b	d1,render_flags(a0)
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	locret_119FC
		move.b	d0,anim_frame_duration(a0)
; End of function Tails_Animate


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_119E4:				; CODE XREF: Tails_Animate+10Ep
					; Tails_Animate+1B2j ...
		moveq	#0,d1
		move.b	anim_frame(a0),d1
		move.b	1(a1,d1.w),d0
		cmpi.b	#$F0,d0
		bcc.s	loc_119FE

loc_119F4:				; CODE XREF: sub_119E4+28j
					; sub_119E4+3Cj
		move.b	d0,mapping_frame(a0)
		addq.b	#1,anim_frame(a0)

locret_119FC:				; CODE XREF: Tails_Animate+42j
					; Tails_Animate+96j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_119FE:				; CODE XREF: sub_119E4+Ej
		addq.b	#1,d0
		bne.s	loc_11A0E
		move.b	#0,anim_frame(a0)
		move.b	1(a1),d0
		bra.s	loc_119F4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11A0E:				; CODE XREF: sub_119E4+1Cj
		addq.b	#1,d0
		bne.s	loc_11A22
		move.b	2(a1,d1.w),d0
		sub.b	d0,anim_frame(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	loc_119F4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11A22:				; CODE XREF: sub_119E4+2Cj
		addq.b	#1,d0
		bne.s	locret_11A2C
		move.b	2(a1,d1.w),anim(a0)

locret_11A2C:				; CODE XREF: sub_119E4+40j
		rts
; End of function sub_119E4

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; START	OF FUNCTION CHUNK FOR Tails_Animate

loc_11A2E:				; CODE XREF: Tails_Animate+2Aj
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	locret_119FC
		addq.b	#1,d0
		bne.w	loc_11B0E
		moveq	#0,d0
		move.b	flip_angle(a0),d0
		bne.w	loc_11AB4
		moveq	#0,d1
		move.b	angle(a0),d0
		move.b	status(a0),d2
		andi.b	#1,d2
		bne.s	loc_11A56
		not.b	d0

loc_11A56:				; CODE XREF: Tails_Animate+B6j
		addi.b	#$10,d0
		bpl.s	loc_11A5E
		moveq	#3,d1

loc_11A5E:				; CODE XREF: Tails_Animate+BEj
		andi.b	#$FC,render_flags(a0)
		eor.b	d1,d2
		or.b	d2,render_flags(a0)
		lsr.b	#4,d0
		andi.b	#6,d0
		move.w	inertia(a0),d2
		bpl.s	loc_11A78
		neg.w	d2

loc_11A78:				; CODE XREF: Tails_Animate+D8j
		move.b	d0,d3
		add.b	d3,d3
		add.b	d3,d3
		lea	(TailsAni_Walk).l,a1
		cmpi.w	#$600,d2
		bcs.s	loc_11A9A
		lea	(TailsAni_Run).l,a1
		move.b	d0,d1
		lsr.b	#1,d1
		add.b	d1,d0
		add.b	d0,d0
		move.b	d0,d3

loc_11A9A:				; CODE XREF: Tails_Animate+ECj
		neg.w	d2
		addi.w	#$800,d2
		bpl.s	loc_11AA4
		moveq	#0,d2

loc_11AA4:				; CODE XREF: Tails_Animate+104j
		lsr.w	#8,d2
		move.b	d2,anim_frame_duration(a0)
		bsr.w	sub_119E4
		add.b	d3,mapping_frame(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11AB4:				; CODE XREF: Tails_Animate+A4j
		move.b	flip_angle(a0),d0
		moveq	#0,d1
		move.b	status(a0),d2
		andi.b	#1,d2
		bne.s	loc_11AE8
		andi.b	#$FC,render_flags(a0)
		moveq	#0,d2
		or.b	d2,render_flags(a0)
		addi.b	#$B,d0
		divu.w	#$16,d0
		addi.b	#$75,d0	; 'u'
		move.b	d0,mapping_frame(a0)
		move.b	#0,anim_frame_duration(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11AE8:				; CODE XREF: Tails_Animate+126j
		moveq	#3,d2
		andi.b	#$FC,render_flags(a0)
		or.b	d2,render_flags(a0)
		neg.b	d0
		addi.b	#$8F,d0
		divu.w	#$16,d0
		addi.b	#$75,d0	; 'u'
		move.b	d0,mapping_frame(a0)
		move.b	#0,anim_frame_duration(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11B0E:				; CODE XREF: Tails_Animate+9Aj
		addq.b	#1,d0
		bne.s	loc_11B52
		move.w	inertia(a0),d2
		bpl.s	loc_11B1A
		neg.w	d2

loc_11B1A:				; CODE XREF: Tails_Animate+17Aj
		lea	(TailsAni_Roll2).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_11B2C
		lea	(TailsAni_Roll).l,a1

loc_11B2C:				; CODE XREF: Tails_Animate+188j
		neg.w	d2
		addi.w	#$400,d2
		bpl.s	loc_11B36
		moveq	#0,d2

loc_11B36:				; CODE XREF: Tails_Animate+196j
		lsr.w	#8,d2
		move.b	d2,anim_frame_duration(a0)
		move.b	status(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,render_flags(a0)
		or.b	d1,render_flags(a0)
		bra.w	sub_119E4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11B52:				; CODE XREF: Tails_Animate+174j
		addq.b	#1,d0
		bne.s	loc_11B88
		move.w	inertia(a0),d2
		bmi.s	loc_11B5E
		neg.w	d2

loc_11B5E:				; CODE XREF: Tails_Animate+1BEj
		addi.w	#$800,d2
		bpl.s	loc_11B66
		moveq	#0,d2

loc_11B66:				; CODE XREF: Tails_Animate+1C6j
		lsr.w	#6,d2
		move.b	d2,anim_frame_duration(a0)
		lea	(TailsAni_Push_NoArt).l,a1
		move.b	status(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,render_flags(a0)
		or.b	d1,render_flags(a0)
		bra.w	sub_119E4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11B88:				; CODE XREF: Tails_Animate+1B8j
		move.w	(Sidekick+x_vel).w,d1
		move.w	(Sidekick+y_vel).w,d2
		jsr	(CalcAngle).l
		moveq	#0,d1
		move.b	status(a0),d2
		andi.b	#1,d2
		bne.s	loc_11BA6
		not.b	d0
		bra.s	loc_11BAA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11BA6:				; CODE XREF: Tails_Animate+204j
		addi.b	#$80,d0

loc_11BAA:				; CODE XREF: Tails_Animate+208j
		addi.b	#$10,d0
		bpl.s	loc_11BB2
		moveq	#3,d1

loc_11BB2:				; CODE XREF: Tails_Animate+212j
		andi.b	#$FC,render_flags(a0)
		eor.b	d1,d2
		or.b	d2,render_flags(a0)
		lsr.b	#3,d0
		andi.b	#$C,d0
		move.b	d0,d3
		lea	(byte_11E3C).l,a1
		move.b	#3,anim_frame_duration(a0)
		bsr.w	sub_119E4
		add.b	d3,mapping_frame(a0)
		rts
; END OF FUNCTION CHUNK	FOR Tails_Animate
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
TailsAniData:	dc.w TailsAni_Walk-TailsAniData,TailsAni_Run-TailsAniData; 0
					; DATA XREF: Tails_Animateo
					; ROM:TailsAniDatao ...
		dc.w TailsAni_Roll-TailsAniData,TailsAni_Roll2-TailsAniData; 2
		dc.w TailsAni_Push_NoArt-TailsAniData,TailsAni_Wait-TailsAniData; 4
		dc.w TailsAni_Balance_NoArt-TailsAniData,TailsAni_LookUp-TailsAniData; 6
		dc.w TailsAni_Duck-TailsAniData,TailsAni_Spindash-TailsAniData;	8
		dc.w TailsAni_0A-TailsAniData,TailsAni_0B-TailsAniData;	10
		dc.w TailsAni_0C-TailsAniData,TailsAni_Stop-TailsAniData; 12
		dc.w TailsAni_Fly-TailsAniData,TailsAni_0F-TailsAniData; 14
		dc.w TailsAni_Jump-TailsAniData,TailsAni_11-TailsAniData; 16
		dc.w TailsAni_12-TailsAniData,TailsAni_13-TailsAniData;	18
		dc.w TailsAni_14-TailsAniData,TailsAni_15-TailsAniData;	20
		dc.w TailsAni_Death1-TailsAniData,TailsAni_UnusedDrown-TailsAniData; 22
		dc.w TailsAni_Death2-TailsAniData,TailsAni_19-TailsAniData; 24
		dc.w TailsAni_1A-TailsAniData,TailsAni_1B-TailsAniData;	26
		dc.w TailsAni_1C-TailsAniData,TailsAni_1D-TailsAniData;	28
		dc.w TailsAni_1E-TailsAniData; 30
TailsAni_Walk:	dc.b $FF,$10,$11,$12,$13,$14,$15, $E, $F,$FF; 0
					; DATA XREF: Tails_Animate+E2o
					; ROM:TailsAniDatao
TailsAni_Run:	dc.b $FF,$2E,$2F,$30,$31,$FF,$FF,$FF,$FF,$FF; 0
					; DATA XREF: Tails_Animate+EEo
					; ROM:TailsAniDatao
TailsAni_Roll:	dc.b   1,$48,$47,$46,$FF; 0 ; DATA XREF: Tails_Animate+18Ao
					; ROM:TailsAniDatao
TailsAni_Roll2:	dc.b   1,$48,$47,$46,$FF; 0 ; DATA XREF: Tails_Animate:loc_11B1Ao
					; ROM:TailsAniDatao
TailsAni_Push_NoArt:dc.b $FD,  9, $A, $B, $C, $D, $E,$FF; 0 ; DATA XREF: Tails_Animate+1D0o
					; ROM:TailsAniDatao
TailsAni_Wait:	dc.b   7,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  3,  2,  1,  1,  1; 0
					; DATA XREF: ROM:TailsAniDatao
		dc.b   1,  1,  1,  1,  1,  3,  2,  1,  1,  1,  1,  1,  1,  1,  1,  1; 16
		dc.b   5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5; 32
		dc.b   6,  7,  8,  7,  8,  7,  8,  7,  8,  7,  8,  6,$FE,$1C; 48
TailsAni_Balance_NoArt:dc.b $1F,  1,  2,  3,  4,  5,  6,  7,  8,$FF; 0
					; DATA XREF: ROM:TailsAniDatao
TailsAni_LookUp:dc.b $3F,  4,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_Duck:	dc.b $3F,$5B,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_Spindash:dc.b	 0,$60,$61,$62,$FF; 0 ;	DATA XREF: ROM:TailsAniDatao
TailsAni_0A:	dc.b $3F,$82,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_0B:	dc.b   7,  8,  8,  9,$FD,  5; 0	; DATA XREF: ROM:TailsAniDatao
TailsAni_0C:	dc.b   7,  9,$FD,  5	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_Stop:	dc.b   7,  1,  2,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_Fly:	dc.b   7,$5E,$5F,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_0F:	dc.b   7,  1,  2,  3,  4,  5,$FF; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_Jump:	dc.b   3,$59,$5A,$59,$5A,$59,$5A,$59,$5A,$59,$5A,$59,$5A,$FD,  0; 0
					; DATA XREF: ROM:TailsAniDatao
TailsAni_11:	dc.b   4,  1,  2,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_12:	dc.b  $F,  1,  2,  3,$FE,  1; 0	; DATA XREF: ROM:TailsAniDatao
TailsAni_13:	dc.b  $F,  1,  2,$FE,  1; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_14:	dc.b $3F,  1,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_15:	dc.b  $B,  1,  2,  3,  4,$FD,  0; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_Death1:dc.b $20,$5D,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_UnusedDrown:dc.b $2F,$5D,$FF	     ; 0 ; DATA	XREF: ROM:TailsAniDatao
TailsAni_Death2:dc.b   3,$5D,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_19:	dc.b   3,$5D,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_1A:	dc.b   3,$5C,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_1B:	dc.b   7,  1,  1,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_1C:	dc.b $77,  0,$FD,  0	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_1D:	dc.b   3,  1,  2,  3,  4,  5,  6,  7,  8,$FF; 0
					; DATA XREF: ROM:TailsAniDatao
TailsAni_1E:	dc.b   3,  1,  2,  3,  4,  5,  6,  7,  8,$FF

; ===========================================================================
; ---------------------------------------------------------------------------
; Tails' Tails pattern loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; LoadTailsDynPLC_F600:
LoadTailsTailsDynPLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		cmp.b	(TailsTails_LastLoadedDPLC).w,d0
		beq.s	locret_11D7C
		move.b	d0,(TailsTails_LastLoadedDPLC).w
		lea	(TailsDynPLC).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	locret_11D7C
		move.w	#$F600,d4
		bra.s	TPLC_ReadEntry
; End of function LoadTailsTailsDynPLC

; ---------------------------------------------------------------------------
; Tails pattern loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


LoadTailsDynPLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		cmp.b	(Tails_LastLoadedDPLC).w,d0
		beq.s	locret_11D7C
		move.b	d0,(Tails_LastLoadedDPLC).w
		lea	(TailsDynPLC).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	locret_11D7C
		move.w	#$F400,d4
; loc_11D50:
TPLC_ReadEntry:
		moveq	#0,d1
		move.w	(a2)+,d1
		move.w	d1,d3
		lsr.w	#8,d3
		andi.w	#$F0,d3
		addi.w	#$10,d3
		andi.w	#$FFF,d1
		lsl.l	#5,d1
		addi.l	#Art_Tails,d1
		move.w	d4,d2
		add.w	d3,d4
		add.w	d3,d4
		jsr	(QueueDMATransfer).l
		dbf	d5,TPLC_ReadEntry

locret_11D7C:
		rts
; End of function LoadTailsDynPLC

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 05 - Tails' tails
; ---------------------------------------------------------------------------

Obj05:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj05_Index(pc,d0.w),d1
		jmp	Obj05_Index(pc,d1.w)
; ===========================================================================
Obj05_Index:	dc.w Obj05_Init-Obj05_Index
		dc.w Obj05_Main-Obj05_Index
; ===========================================================================

Obj05_Init:
		addq.b	#2,routine(a0)
		move.l	#Map_Tails,mappings(a0)
		move.w	#$7B0,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#2,priority(a0)
		move.b	#$18,width_pixels(a0)
		move.b	#4,render_flags(a0)

Obj05_Main:
		move.b	(Sidekick+$26).w,angle(a0)
		move.b	(Sidekick+status).w,status(a0)
		move.w	(Sidekick+x_pos).w,x_pos(a0)
		move.w	(Sidekick+y_pos).w,y_pos(a0)
		moveq	#0,d0
		move.b	(Sidekick+anim).w,d0
		cmp.b	$30(a0),d0
		beq.s	loc_11DE6
		move.b	d0,$30(a0)
		move.b	Obj05_Animations(pc,d0.w),anim(a0)

loc_11DE6:
		lea	(Obj05_AniData).l,a1
		bsr.w	Tails_Animate2
		bsr.w	LoadTailsTailsDynPLC
		jsr	(DisplaySprite).l
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj05_Animations:dc.b	0,  0		 ; 0
		dc.b   3,  3		; 2
		dc.b   0,  1		; 4
		dc.b   0,  2		; 6
		dc.b   1,  7		; 8
		dc.b   0,  0		; 10
		dc.b   0,  0		; 12
		dc.b   0,  0		; 14
		dc.b   0,  0		; 16
		dc.b   0,  0		; 18
		dc.b   0,  0		; 20
		dc.b   0,  0		; 22
		dc.b   0,  0		; 24
		dc.b   0,  0		; 26
		dc.b   0,  0		; 28
Obj05_AniData:	dc.w byte_11E2A-Obj05_AniData ;	DATA XREF: ROM:loc_11DE6o
					; ROM:Obj05_AniDatao ...
		dc.w byte_11E2D-Obj05_AniData
		dc.w byte_11E34-Obj05_AniData
		dc.w byte_11E3C-Obj05_AniData
		dc.w byte_11E42-Obj05_AniData
		dc.w byte_11E48-Obj05_AniData
		dc.w byte_11E4E-Obj05_AniData
		dc.w byte_11E54-Obj05_AniData
byte_11E2A:	dc.b $20,  0,$FF	; 0 ; DATA XREF: ROM:Obj05_AniDatao
byte_11E2D:	dc.b   7,  9, $A, $B, $C, $D,$FF; 0 ; DATA XREF: ROM:00011E1Co
byte_11E34:	dc.b   3,  9, $A, $B, $C, $D,$FD,  1; 0	; DATA XREF: ROM:00011E1Eo
byte_11E3C:	dc.b $FC,$49,$4A,$4B,$4C,$FF; 0	; DATA XREF: Tails_Animate+22Ao
					; ROM:00011E20o
byte_11E42:	dc.b   3,$4D,$4E,$4F,$50,$FF; 0	; DATA XREF: ROM:00011E22o
byte_11E48:	dc.b   3,$51,$52,$53,$54,$FF; 0	; DATA XREF: ROM:00011E24o
byte_11E4E:	dc.b   3,$55,$56,$57,$58,$FF; 0	; DATA XREF: ROM:00011E26o
byte_11E54:	dc.b   2,$81,$82,$83,$84,$FF; 0	; DATA XREF: ROM:00011E28o