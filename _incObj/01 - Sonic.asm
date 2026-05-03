; ===========================================================================
; ---------------------------------------------------------------------------
; Object 01 - Sonic
;
; Internal name: "play00"
; ---------------------------------------------------------------------------
; Sprite_F9FC: Obj01:
Obj_Sonic:
		tst.w	(Debug_placement_mode).w	; is debug mode being used?
		beq.s	Sonic_Normal			; if not, branch
		jmp	(DebugMode).l
; ===========================================================================
; Obj01_Normal:
Sonic_Normal:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Sonic_Index(pc,d0.w),d1
		jmp	Sonic_Index(pc,d1.w)
; ===========================================================================
; Obj01_Index:
Sonic_Index:	dc.w Sonic_Init-Sonic_Index		; 0
		dc.w Sonic_Control-Sonic_Index		; 2
		dc.w Sonic_Hurt-Sonic_Index		; 4
		dc.w Sonic_Dead-Sonic_Index		; 6
		dc.w Sonic_ResetLevel-Sonic_Index	; 8
; ===========================================================================
; Obj01_Main: Obj01_Init:
Sonic_Init:
		addq.b	#2,routine(a0)	; => Sonic_Control
		move.b	#$13,y_radius(a0)	; this sets Sonic's collision height (2*pixels)
		move.b	#9,x_radius(a0)
		move.l	#MapUnc_Sonic,mappings(a0)
		move.w	#$780,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#2,priority(a0)
		move.b	#$18,width_pixels(a0)
		move.b	#4,render_flags(a0)
		move.w	#$600,(Sonic_top_speed).w	; set Sonic's top speed
		move.w	#$C,(Sonic_acceleration).w	; set Sonic's acceleration
		move.w	#$80,(Sonic_deceleration).w	; set Sonic's deceleration
		move.b	#$C,top_solid_bit(a0)
		move.b	#$D,lrb_solid_bit(a0)
		move.b	#0,flips_remaining(a0)
		move.b	#4,flip_speed(a0)
		move.w	#0,(Sonic_Pos_Record_Index).w
		move.w	#$3F,d2

loc_FA88:
		bsr.w	Sonic_RecordPos
		move.w	#0,(a1,d0.w)
		dbf	d2,loc_FA88

; ---------------------------------------------------------------------------
; Normal state for Sonic
; ---------------------------------------------------------------------------
; Obj01_Control:
Sonic_Control:
		tst.w	(Debug_mode_flag).w		; is debug cheat enabled?
		beq.s	loc_FAB0			; if not, branch
		btst	#4,(Ctrl_1_Press).w		; is button B pressed?
		beq.s	loc_FAB0			; if not, branch
		move.w	#1,(Debug_placement_mode).w	; change Sonic into ring/item
		clr.b	(Control_Locked).w		; unlock control
		rts
; -----------------------------------------------------------------------

loc_FAB0:
		tst.b	(Control_Locked).w	; are controls locked?
		bne.s	loc_FABC		; if yes, branch
		move.w	(Ctrl_1).w,(Ctrl_1_Logical).w	; copy new held buttons, to enable joypad

loc_FABC:
		btst	#0,(Player_override_flag).w	; is Sonic interacting with another object that holds him in place or controls his movement somehow?
		bne.s	Sonic_ControlsLock	; if yes, branch to skip Sonic's control
		moveq	#0,d0
		move.b	status(a0),d0
		andi.w	#6,d0
		move.w	Sonic_Modes(pc,d0.w),d1
		jsr	Sonic_Modes(pc,d1.w)	; run Sonic's movement control code
; Obj01_ControlsLock:
Sonic_ControlsLock:
		bsr.s	Sonic_Display
		bsr.w	Sonic_RecordPos
		bsr.w	Sonic_Water
		move.b	(Primary_Angle).w,next_tilt(a0)
		move.b	(Secondary_Angle).w,tilt(a0)
		tst.b	(WindTunnel_flag).w
		beq.s	loc_FAFE
		tst.b	anim(a0)
		bne.s	loc_FAFE
		move.b	prev_anim(a0),anim(a0)

loc_FAFE:
		bsr.w	Sonic_Animate
		tst.b	(Player_override_flag).w
		bmi.s	loc_FB0E
		jsr	TouchResponse

loc_FB0E:
		bra.w	LoadSonicDynPLC
; ===========================================================================
; secondary states under state Sonic_Control
; Obj01_Modes:
Sonic_Modes:	dc.w Sonic_MdNormal-Sonic_Modes
		dc.w Sonic_MdAir-Sonic_Modes
		dc.w Sonic_MdRoll-Sonic_Modes
		dc.w Sonic_MdJump-Sonic_Modes

MusicList_Sonic:dc.b MusID_GHZ
		dc.b MusID_LZ
		dc.b MusID_CPZ
		dc.b MusID_EHZ
		dc.b MusID_HPZ
		dc.b MusID_HTZ
		even
; ===========================================================================

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Display:
		move.w	invulnerable_time(a0),d0
		beq.s	.display
		subq.w	#1,invulnerable_time(a0)
		lsr.w	#3,d0
		bcc.s	Sonic_ChkInvin
; loc_FB2E: Obj01_Display:
.display:
		jsr	(DisplaySprite).l
; loc_FB34: Obj01_ChkInvin:
Sonic_ChkInvin:		; Checks if invincibility has expired and (should) disables it if it has
		tst.b	(Invincibility_flag).w
		beq.s	Sonic_ChkShoes
		tst.w	invincibility_time(a0)
		beq.s	Sonic_ChkShoes
		bra.s	Sonic_ChkShoes
; ===========================================================================
; Strange that they disabled the invincibility timer for this build,
; a leftover debugging feature?
		subq.w	#1,invincibility_time(a0)
		bne.s	Sonic_ChkShoes
		tst.b	(Lock_screen).w
		bne.s	Sonic_RmvInvin
		cmpi.w	#$C,(Air_left).w
		bcs.s	Sonic_RmvInvin
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		cmpi.w	#$103,(Current_ZoneAndAct).w
		bne.s	loc_FB66
		moveq	#5,d0

loc_FB66:
		lea	MusicList_Sonic(pc),a1
		move.b	(a1,d0.w),d0
		jsr	(PlayMusic).l
; loc_FB74: Obj01_RmvInvin:
Sonic_RmvInvin:
		move.b	#0,(Invincibility_flag).w
; loc_FB7A: Obj01_ChkShoes:
Sonic_ChkShoes:	; Checks if Speed Shoes have expired and disables them if they have.
		tst.b	(Speedshoes_flag).w
		beq.s	Sonic_ExitChk
		tst.w	speedshoes_time(a0)
		beq.s	Sonic_ExitChk
		subq.w	#1,speedshoes_time(a0)
		bne.s	Sonic_ExitChk
		move.w	#$600,(Sonic_top_speed).w
		move.w	#$C,(Sonic_acceleration).w
		move.w	#$80,(Sonic_deceleration).w
		move.b	#0,(Speedshoes_flag).w
		move.w	#$E3,d0
		jmp	(PlayMusic).l
; ---------------------------------------------------------------------------
; locret_FBAE: Obj01_ExitChk:
Sonic_ExitChk:
		rts
; End of function Sonic_Display

; ---------------------------------------------------------------------------
; Subroutine to record Sonic's previous positions for invincibility stars
; and input/status flags for Tails' AI to follow
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_FBB2: CopySonicMovesForTails:
Sonic_RecordPos:
		move.w	(Sonic_Pos_Record_Index).w,d0
		lea	(Sonic_Pos_Record_Buf).w,a1
		lea	(a1,d0.w),a1
		move.w	x_pos(a0),(a1)+
		move.w	y_pos(a0),(a1)+
		addq.b	#4,(Sonic_Pos_Record_Index+1).w

		lea	(Sonic_Stat_Record_Buf).w,a1
		move.w	(Ctrl_1).w,(a1,d0.w)
		rts
; End of function Sonic_RecordPos

; ===========================================================================
; ---------------------------------------------------------------------------
; Seemingly an earlier subroutine to copy Sonic's status flags for Tails' AI
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Unused_RecordPos:
		move.w	(unk_EEE0).w,d0
		subq.b	#4,d0
		lea	(unk_E600).w,a1
		lea	(a1,d0.w),a2
		move.w	x_pos(a0),d1
		swap	d1
		move.w	y_pos(a0),d1
		cmp.l	(a2),d1
		beq.s	locret_FC02
		addq.b	#4,d0
		lea	(a1,d0.w),a2
		move.w	x_pos(a0),(a2)+
		move.w	y_pos(a0),(a2)
		addq.b	#4,(unk_EEE0+1).w

locret_FC02:
		rts
; End of subroutine Unused_RecordPos

; ---------------------------------------------------------------------------
; Subroutine for Sonic when he's underwater
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_FC06:
Sonic_Water:
		tst.b	(Water_flag).w
		bne.s	Sonic_InWater

locret_FC0A:
		rts
; ---------------------------------------------------------------------------
; loc_FC0E: Obj01_InLevelWithWater: Obj01_InWater:
Sonic_InWater:
		move.w	(Water_Level_1).w,d0
		cmp.w	y_pos(a0),d0	; is Sonic above water?
		bge.s	Sonic_OutWater	; if yes, branch

		bset	#6,status(a0)	; set underwater flag
		bne.s	locret_FC0A	; if already underwater, branch

		bsr.w	ResumeMusic
		move.b	#ObjID_SmallBubbles,(Sonic_BreathingBubbles+id).w	; load Obj0A (sonic's breathing bubbles) at $FFFFB340
		move.b	#$81,(Sonic_BreathingBubbles+subtype).w
		move.w	#$300,(Sonic_top_speed).w
		move.w	#6,(Sonic_acceleration).w
		move.w	#$40,(Sonic_deceleration).w
		asr	x_vel(a0)
		asr	y_vel(a0)	; memory oprands can only be shifted one at a time
		asr	y_vel(a0)
		beq.s	locret_FC0A
		move.b	#ObjID_WaterSplash,(Sonic_WaterSplash+id).w	; splash animation
		move.w	#$AA,d0			; splash sound
		jmp	(PlaySound).l

; ---------------------------------------------------------------------------
; Obj01_NotInWater: Obj01_OutWater:
Sonic_OutWater:
		bclr	#6,status(a0)	; unset underwater flag
		beq.s	locret_FC0A	; if already unset, branch

		bsr.w	ResumeMusic
		move.w	#$600,(Sonic_top_speed).w
		move.w	#$C,(Sonic_acceleration).w
		move.w	#$80,(Sonic_deceleration).w
		asl	y_vel(a0)
		beq.w	locret_FC0A
		move.b	#ObjID_WaterSplash,(Sonic_WaterSplash+id).w	; splash animation
		cmpi.w	#$F000,y_vel(a0)
		bgt.s	loc_FC98
		move.w	#$F000,y_vel(a0)	; limit upward y velocity exiting the water

loc_FC98:
		move.w	#$AA,d0		; splash sound
		jmp	(PlaySound).l
; End of function Sonic_Water

; ===========================================================================
; ---------------------------------------------------------------------------
; Start of subroutine Sonic_MdNormal
; Called if Sonic is neither airborne nor rolling this frame
; ---------------------------------------------------------------------------
; Obj01_MdNormal:
Sonic_MdNormal:
		bsr.w	Sonic_CheckSpindash
		bsr.w	Sonic_Jump
		bsr.w	Sonic_SlopeResist
		bsr.w	Sonic_Move
		bsr.w	Sonic_Roll
		bsr.w	Sonic_LevelBound
		jsr	(ObjectMove).l
		bsr.w	AnglePos
		bsr.w	Sonic_SlopeRepel
		rts
; End of subroutine Sonic_MdNormal

; ===========================================================================
; Start of subroutine Sonic_MdAir
; Called if Sonic is airborne, but not in a ball (thus, probably not jumping)
; Obj01_MdJump: Obj01_MdAir:
Sonic_MdAir:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_ChgJumpDir
		bsr.w	Sonic_LevelBound
		jsr	(ObjectMoveAndFall).l
		btst	#6,status(a0)	; is Sonic underwater?
		beq.s	loc_FCEA	; if not, branch
		subi.w	#$28,y_vel(a0)	; reduce gravity by $28 ($38-$28=$10)

loc_FCEA:
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_DoLevelCollision
		rts
; End of subroutine Sonic_MdAir

; ===========================================================================
; Start of subroutine Sonic_MdRoll
; Called if Sonic is in a ball, but not airborne (thus, probably rolling)
; Obj01_MdRoll:
Sonic_MdRoll:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_RollRepel
		bsr.w	Sonic_RollSpeed
		bsr.w	Sonic_LevelBound
		jsr	(ObjectMove).l
		bsr.w	AnglePos
		bsr.w	Sonic_SlopeRepel
		rts
; End of subroutine Sonic_MdRoll

; ===========================================================================
; Start of subroutine Sonic_MdJump
; Called if Sonic is in a ball and airborne (he could be jumping but not necessarily)
; Notes: This is identical to Sonic_MdAir, at least at this outer level.
;        Why they gave it a separate copy of the code, I don't know.
; Obj01_MdJump2: Obj01_MdJump:
Sonic_MdJump:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_ChgJumpDir
		bsr.w	Sonic_LevelBound
		jsr	(ObjectMoveAndFall).l
		btst	#6,status(a0)	; is Sonic underwater?
		beq.s	loc_FD34	; if not, branch
		subi.w	#$28,y_vel(a0)	; reduce gravity by $28 ($38-$28=$10)

loc_FD34:
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_DoLevelCollision
		rts
; End of subroutine Sonic_MdJump

; ---------------------------------------------------------------------------
; Subroutine to make Sonic walk/run
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Move:
		move.w	(Sonic_top_speed).w,d6
		move.w	(Sonic_acceleration).w,d5
		move.w	(Sonic_deceleration).w,d4
		tst.b	(Sliding_flag).w
		bne.w	Sonic_Traction
		tst.w	move_lock(a0)
		bne.w	Sonic_UpdateSpeedOnGround
		btst	#2,(Ctrl_1_Held_Logical).w	; is left being pressed?
		beq.s	loc_FD66		; if not, branch
		bsr.w	Sonic_MoveLeft

loc_FD66:
		btst	#3,(Ctrl_1_Held_Logical).w	; is right being pressed?
		beq.s	loc_FD72		; if not, branch
		bsr.w	Sonic_MoveRight

loc_FD72:
		move.b	angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0				; is Sonic on a slope?
		bne.w	Sonic_UpdateSpeedOnGround	; if yes, branch
		tst.w	inertia(a0)			; is Sonic moving?
		bne.w	Sonic_UpdateSpeedOnGround	; if yes, branch
		bclr	#5,status(a0)
		cmpi.b	#$B,anim(a0)	; use "standing" animation
		beq.s	loc_FD9E
		move.b	#5,anim(a0)

loc_FD9E:
		btst	#3,status(a0)
		beq.s	Sonic_Balance
		moveq	#0,d0
		move.b	interact(a0),d0
		lsl.w	#6,d0
		lea	(MainCharacter).w,a1	; a1=character
		lea	(a1,d0.w),a1		; a1=object
		tst.b	status(a1)
		bmi.s	Sonic_LookUp
		moveq	#0,d1
		move.b	width_pixels(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#4,d2
		add.w	x_pos(a0),d1
		sub.w	x_pos(a1),d1
		cmpi.w	#4,d1
		blt.s	loc_FE00
		cmp.w	d2,d1
		bge.s	loc_FDF0
		bra.s	Sonic_LookUp
; ---------------------------------------------------------------------------

Sonic_Balance:
		jsr	(ChkFloorEdge).l
		cmpi.w	#$C,d1
		blt.s	Sonic_LookUp
		cmpi.b	#3,next_tilt(a0)
		bne.s	loc_FDF8

loc_FDF0:
		bclr	#0,status(a0)
		bra.s	loc_FE06
; ---------------------------------------------------------------------------

loc_FDF8:
		cmpi.b	#3,tilt(a0)
		bne.s	Sonic_LookUp

loc_FE00:
		bset	#0,status(a0)

loc_FE06:
		move.b	#6,anim(a0)
		bra.s	Sonic_UpdateSpeedOnGround
; ---------------------------------------------------------------------------

Sonic_LookUp:
		btst	#0,(Ctrl_1_Held_Logical).w	; is up being pressed?
		beq.s	Sonic_Duck		; if not, branch
		move.b	#7,anim(a0)		; use "looking up" animation
		bra.s	Sonic_UpdateSpeedOnGround
; ---------------------------------------------------------------------------

Sonic_Duck:
		btst	#1,(Ctrl_1_Held_Logical).w	; is down being pressed?
		beq.s	Sonic_UpdateSpeedOnGround	; if not, branch
		move.b	#8,anim(a0)			; use "ducking" animation

; ---------------------------------------------------------------------------
; updates Sonic's speed on the ground
; ---------------------------------------------------------------------------
; loc_FE2C: Obj01_UpdateSpeedOnGround:
Sonic_UpdateSpeedOnGround:
		move.b	(Ctrl_1_Held_Logical).w,d0
		andi.b	#$C,d0		; is left/right being pressed?
		bne.s	Sonic_Traction	; if yes, branch
		move.w	inertia(a0),d0
		beq.s	Sonic_Traction
		bmi.s	Sonic_SettleLeft

; slow down when facing right and not pressing a direction
; Sonic_SettleRight:
		sub.w	d5,d0
		bcc.s	loc_FE46
		move.w	#0,d0

loc_FE46:
		move.w	d0,inertia(a0)
		bra.s	Sonic_Traction
; ---------------------------------------------------------------------------
; slow down when facing left and not pressing a direction
; loc_FE4C: Obj01_SettleLeft:
Sonic_SettleLeft:
		add.w	d5,d0
		bcc.s	loc_FE54
		move.w	#0,d0

loc_FE54:
		move.w	d0,inertia(a0)

; increase or decrease speed on the ground
; loc_FE58: Obj01_Traction:
Sonic_Traction:
		move.b	angle(a0),d0
		jsr	(CalcSine).l
		muls.w	inertia(a0),d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	inertia(a0),d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)

; stops Sonic from running through walls that meet the ground
; loc_FE76: Obj01_CheckWallsOnGround:
Sonic_CheckWallsOnGround:
		move.b	angle(a0),d0
		addi.b	#$40,d0
		bmi.s	locret_FEF6
		move.b	#$40,d1		; rotate 90 degress clockwise
		tst.w	inertia(a0)	; check if Sonic's moving
		beq.s	locret_FEF6	; if not, branch
		bmi.s	loc_FE8E	; if negative, branch
		neg.w	d1		; rotate counterclockwise

loc_FE8E:
		move.b	angle(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		bsr.w	CalcRoomInFront
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	locret_FEF6
		asl.w	#8,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	loc_FEF2
		cmpi.b	#$40,d0
		beq.s	loc_FED8
		cmpi.b	#$80,d0
		beq.s	loc_FED2
		cmpi.w	#$600,x_vel(a0)		; is Sonic at max speed?
		bge.s	Sonic_WallRecoil	; if yes, branch
		add.w	d1,x_vel(a0)
		bset	#5,status(a0)
		move.w	#0,inertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_FED2:
		sub.w	d1,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_FED8:
		cmpi.w	#$FA00,x_vel(a0)	; is Sonic at max speed?
		ble.s	Sonic_WallRecoil	; if yes, branch
		sub.w	d1,x_vel(a0)
		bset	#5,status(a0)
		move.w	#0,inertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_FEF2:
		add.w	d1,y_vel(a0)

locret_FEF6:
		rts

; ---------------------------------------------------------------------------
; Subroutine to recoil Sonic off a wall if moving a top speed
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_WallRecoil:
		move.b	#4,routine(a0)
		bsr.w	Sonic_ResetOnFloor
		bset	#1,status(a0)
		move.w	#-$200,d0
		tst.w	x_vel(a0)
		bpl.s	Sonic_WallRecoil_Right
		neg.w	d0

Sonic_WallRecoil_Right:
		move.w	d0,x_vel(a0)
		move.w	#-$400,y_vel(a0)
		move.w	#0,inertia(a0)
		move.b	#$A,anim(a0)
		move.b	#1,routine_secondary(a0)
		move.w	#$A3,d0
		jsr	(PlaySound).l
		rts
; End of function Sonic_Move


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_MoveLeft:
		move.w	inertia(a0),d0
		beq.s	loc_FF44
		bpl.s	Sonic_TurnLeft

loc_FF44:
		bset	#0,status(a0)
		bne.s	loc_FF58
		bclr	#5,status(a0)
		move.b	#1,prev_anim(a0)

loc_FF58:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_FF64
		move.w	d1,d0

loc_FF64:
		move.w	d0,inertia(a0)
		move.b	#0,anim(a0)
		rts
; ---------------------------------------------------------------------------
; loc_FF70:
Sonic_TurnLeft:
		sub.w	d4,d0
		bcc.s	loc_FF78
		move.w	#$FF80,d0

loc_FF78:
		move.w	d0,inertia(a0)
		move.b	angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_FFA6
		cmpi.w	#$400,d0
		blt.s	locret_FFA6
		move.b	#$D,anim(a0)
		bclr	#0,status(a0)
		move.w	#$A4,d0
		jsr	(PlaySound).l

locret_FFA6:
		rts
; End of function Sonic_MoveLeft


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_MoveRight:
		move.w	inertia(a0),d0
		bmi.s	Sonic_TurnRight
		bclr	#0,status(a0)
		beq.s	loc_FFC2
		bclr	#5,status(a0)
		move.b	#1,prev_anim(a0)

loc_FFC2:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_FFCA
		move.w	d6,d0

loc_FFCA:
		move.w	d0,inertia(a0)
		move.b	#0,anim(a0)
		rts
; ---------------------------------------------------------------------------
; loc_FFD6:
Sonic_TurnRight:
		add.w	d4,d0
		bcc.s	loc_FFDE
		move.w	#$80,d0

loc_FFDE:
		move.w	d0,inertia(a0)
		move.b	angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_1000C
		cmpi.w	#$FC00,d0
		bgt.s	locret_1000C
		move.b	#$D,anim(a0)

loc_FFFC:
		bset	#0,status(a0)
		move.w	#$A4,d0
		jsr	(PlaySound).l

locret_1000C:
		rts
; End of function Sonic_MoveRight


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; loc_1000E:
Sonic_RollSpeed:
		move.w	(Sonic_top_speed).w,d6
		asl.w	#1,d6
		move.w	(Sonic_acceleration).w,d5
		asr.w	#1,d5
		move.w	(Sonic_deceleration).w,d4
		asr.w	#2,d4
		tst.b	(Sliding_flag).w
		bne.w	loc_1008A
		tst.w	move_lock(a0)
		bne.s	loc_10046
		btst	#2,(Ctrl_1_Held_Logical).w
		beq.s	loc_1003A
		bsr.w	Sonic_RollLeft

loc_1003A:
		btst	#3,(Ctrl_1_Held_Logical).w
		beq.s	loc_10046
		bsr.w	Sonic_RollRight

loc_10046:
		move.w	inertia(a0),d0
		beq.s	loc_10068
		bmi.s	loc_1005C
		sub.w	d5,d0
		bcc.s	loc_10056
		move.w	#0,d0

loc_10056:
		move.w	d0,inertia(a0)
		bra.s	loc_10068
; ===========================================================================

loc_1005C:
		add.w	d5,d0
		bcc.s	loc_10064
		move.w	#0,d0

loc_10064:
		move.w	d0,inertia(a0)

loc_10068:
		tst.w	inertia(a0)
		bne.s	loc_1008A
		bclr	#2,status(a0)
		move.b	#$13,y_radius(a0)
		move.b	#9,x_radius(a0)
		move.b	#5,anim(a0)
		subq.w	#5,y_pos(a0)

loc_1008A:
		move.b	angle(a0),d0
		jsr	(CalcSine).l
		muls.w	inertia(a0),d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		muls.w	inertia(a0),d1
		asr.l	#8,d1
		cmpi.w	#$1000,d1
		ble.s	loc_100AE
		move.w	#$1000,d1

loc_100AE:
		cmpi.w	#$F000,d1
		bge.s	loc_100B8
		move.w	#$F000,d1

loc_100B8:
		move.w	d1,x_vel(a0)
		bra.w	Sonic_CheckWallsOnGround
; End of function Sonic_RollSpeed


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollLeft:
		move.w	inertia(a0),d0
		beq.s	loc_100C8
		bpl.s	loc_100D6

loc_100C8:
		bset	#0,status(a0)
		move.b	#2,anim(a0)
		rts
; ===========================================================================

loc_100D6:
		sub.w	d4,d0
		bcc.s	loc_100DE
		move.w	#$FF80,d0

loc_100DE:
		move.w	d0,inertia(a0)
		rts
; End of function Sonic_RollLeft


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollRight:
		move.w	inertia(a0),d0
		bmi.s	loc_100F8
		bclr	#0,status(a0)
		move.b	#2,anim(a0)
		rts
; ===========================================================================

loc_100F8:
		add.w	d4,d0
		bcc.s	loc_10100
		move.w	#$80,d0

loc_10100:
		move.w	d0,inertia(a0)
		rts
; End of function Sonic_RollRight


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_ChgJumpDir:
		move.w	(Sonic_top_speed).w,d6
		move.w	(Sonic_acceleration).w,d5
		asl.w	#1,d5
		btst	#4,status(a0)
		bne.s	loc_10150
		move.w	x_vel(a0),d0
		btst	#2,(Ctrl_1_Held_Logical).w
		beq.s	loc_10136
		bset	#0,status(a0)
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_10136
		move.w	d1,d0

loc_10136:
		btst	#3,(Ctrl_1_Held_Logical).w
		beq.s	loc_1014C
		bclr	#0,status(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_1014C
		move.w	d6,d0

loc_1014C:
		move.w	d0,x_vel(a0)

loc_10150:
		cmpi.w	#$60,(Camera_Y_pos_bias).w
		beq.s	loc_10162
		bcc.s	loc_1015E
		addq.w	#4,(Camera_Y_pos_bias).w

loc_1015E:
		subq.w	#2,(Camera_Y_pos_bias).w

loc_10162:
		cmpi.w	#$FC00,y_vel(a0)
		bcs.s	locret_10190
		move.w	x_vel(a0),d0
		move.w	d0,d1
		asr.w	#5,d1
		beq.s	locret_10190
		bmi.s	loc_10184
		sub.w	d1,d0
		bcc.s	loc_1017E
		move.w	#0,d0

loc_1017E:
		move.w	d0,x_vel(a0)
		rts
; ===========================================================================

loc_10184:
		sub.w	d1,d0
		bcs.s	loc_1018C
		move.w	#0,d0

loc_1018C:
		move.w	d0,x_vel(a0)

locret_10190:
		rts
; End of function Sonic_ChgJumpDir


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Sonic_LevelBoundaries:
Sonic_LevelBound:
		move.l	x_pos(a0),d1
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(Camera_Min_X_pos).w,d0
		addi.w	#$10,d0
		cmp.w	d1,d0
		bhi.s	loc_101FA
		move.w	(Camera_Max_X_pos).w,d0
		addi.w	#$128,d0
		tst.b	(Lock_screen).w
		bne.s	loc_101C0
		addi.w	#$40,d0

loc_101C0:
		cmp.w	d1,d0
		bls.s	loc_101FA

loc_101C4:
		move.w	(Camera_Max_Y_pos).w,d0
		addi.w	#$E0,d0
		cmp.w	y_pos(a0),d0
		blt.s	loc_101D4
		rts
; ===========================================================================

loc_101D4:
		cmpi.w	#$501,(Current_ZoneAndAct).w
		bne.w	JmpTo_KillSonic
		cmpi.w	#$2000,(MainCharacter+x_pos).w
		bcs.w	JmpTo_KillSonic
		clr.b	(Last_star_pole_hit).w
		move.w	#1,(Level_Inactive_flag).w
		move.w	#$103,(Current_ZoneAndAct).w
		rts
; ===========================================================================

loc_101FA:
		move.w	d0,x_pos(a0)
		move.w	#0,x_sub(a0)
		move.w	#0,x_vel(a0)
		move.w	#0,inertia(a0)
		bra.s	loc_101C4
; End of function Sonic_LevelBound


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Roll:
		tst.b	(Sliding_flag).w
		bne.s	Sonic_NoRoll
		move.w	inertia(a0),d0
		bpl.s	loc_10220
		neg.w	d0

loc_10220:
		cmpi.w	#$80,d0
		bcs.s	Sonic_NoRoll
		move.b	(Ctrl_1_Held_Logical).w,d0
		andi.b	#$C,d0
		bne.s	Sonic_NoRoll
		btst	#1,(Ctrl_1_Held_Logical).w
		bne.s	loc_1023A
; locret_10238: Obj01_NoRoll:
Sonic_NoRoll:
		rts
; ===========================================================================

loc_1023A:
		btst	#2,status(a0)
		beq.s	Sonic_DoRoll
		rts
; ===========================================================================
; Obj01_DoRoll:
Sonic_DoRoll:
		bset	#2,status(a0)
		move.b	#$E,y_radius(a0)
		move.b	#7,x_radius(a0)
		move.b	#2,anim(a0)
		addq.w	#5,y_pos(a0)
		move.w	#$BE,d0
		jsr	(PlaySound).l
		tst.w	inertia(a0)
		bne.s	locret_10276
		move.w	#$200,inertia(a0)

locret_10276:
		rts
; End of function Sonic_Roll


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Jump:
		move.b	(Ctrl_1_Press_Logical).w,d0
		andi.b	#$70,d0
		beq.w	locret_1031C
		moveq	#0,d0
		move.b	angle(a0),d0
		addi.b	#$80,d0
		bsr.w	sub_13102
		cmpi.w	#6,d1
		blt.w	locret_1031C
		move.w	#$680,d2
		btst	#6,status(a0)
		beq.s	loc_102AA
		move.w	#$380,d2

loc_102AA:
		moveq	#0,d0
		move.b	angle(a0),d0
		subi.b	#$40,d0
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
		move.w	#$A0,d0
		jsr	(PlaySound).l
		move.b	#$13,y_radius(a0)
		move.b	#9,x_radius(a0)
		btst	#2,status(a0)
		bne.s	loc_1031E
		move.b	#$E,y_radius(a0)
		move.b	#7,x_radius(a0)
		move.b	#2,anim(a0)
		bset	#2,status(a0)
		addq.w	#5,y_pos(a0)

locret_1031C:
		rts
; ===========================================================================

loc_1031E:
		bset	#4,status(a0)
		rts
; End of function Sonic_Jump


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_JumpHeight:
		tst.b	jumping(a0)
		beq.s	loc_10352
		move.w	#$FC00,d1
		btst	#6,status(a0)
		beq.s	loc_1033C
		move.w	#$FE00,d1

loc_1033C:
		cmp.w	y_vel(a0),d1
		ble.s	locret_10350
		move.b	(Ctrl_1_Held_Logical).w,d0
		andi.b	#$70,d0
		bne.s	locret_10350
		move.w	d1,y_vel(a0)

locret_10350:
		rts
; ===========================================================================

loc_10352:
		cmpi.w	#$F040,y_vel(a0)
		bge.s	locret_10360
		move.w	#$F040,y_vel(a0)

locret_10360:
		rts
; End of function Sonic_JumpHeight

; ---------------------------------------------------------------------------
; Subroutine to check for starting to charge a spindash
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Sonic_Spindash:
Sonic_CheckSpindash:
		tst.b	spindash_flag(a0)
		bne.s	Sonic_UpdateSpindash
		cmpi.b	#8,anim(a0)
		bne.s	locret_10394
		move.b	(Ctrl_1_Press_Logical).w,d0
		andi.b	#$70,d0
		beq.w	locret_10394
		move.b	#9,anim(a0)
		move.w	#$BE,d0
		jsr	(PlaySound).l
		addq.l	#4,sp
		move.b	#1,spindash_flag(a0)

locret_10394:
		rts
; ===========================================================================
; loc_10396:
Sonic_UpdateSpindash:
		move.b	(Ctrl_1_Held_Logical).w,d0
		btst	#1,d0
		bne.s	Sonic_ChargingSpindash

		; unleash the charged spindash and start rolling quickly:
		move.b	#$E,y_radius(a0)
		move.b	#7,x_radius(a0)
		move.b	#2,anim(a0)
		addq.w	#5,y_pos(a0)	; add the difference between Sonic's rolling and standing heights
		move.b	#0,spindash_flag(a0)
		move.w	#$2000,(Horiz_scroll_delay_val).w
		move.w	#$800,inertia(a0)
		btst	#0,status(a0)
		beq.s	loc_103D4
		neg.w	inertia(a0)

loc_103D4:
		bset	#2,status(a0)
		rts
; ===========================================================================
; loc_103DC:
Sonic_ChargingSpindash:
		move.b	(Ctrl_1_Press_Logical).w,d0
		andi.b	#$70,d0	
		beq.w	loc_103EA
		nop

loc_103EA:
		addq.l	#4,sp
		rts
; End of function Sonic_CheckSpindash


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_SlopeResist:
		move.b	angle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_10422
		move.b	angle(a0),d0

loc_10400:
		jsr	(CalcSine).l
		muls.w	#$20,d0
		asr.l	#8,d0
		tst.w	inertia(a0)
		beq.s	locret_10422
		bmi.s	loc_1041E
		tst.w	d0
		beq.s	locret_1041C
		add.w	d0,inertia(a0)

locret_1041C:
		rts
; ===========================================================================

loc_1041E:
		add.w	d0,inertia(a0)

locret_10422:
		rts
; End of function Sonic_SlopeResist


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollRepel:
		move.b	angle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_1045E
		move.b	angle(a0),d0
		jsr	(CalcSine).l
		muls.w	#$50,d0
		asr.l	#8,d0
		tst.w	inertia(a0)
		bmi.s	loc_10454
		tst.w	d0
		bpl.s	loc_1044E
		asr.l	#2,d0

loc_1044E:
		add.w	d0,inertia(a0)
		rts
; ===========================================================================

loc_10454:
		tst.w	d0
		bmi.s	loc_1045A
		asr.l	#2,d0

loc_1045A:
		add.w	d0,inertia(a0)

locret_1045E:
		rts
; End of function Sonic_RollRepel


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_SlopeRepel:
		nop
		tst.b	stick_to_convex(a0)
		bne.s	locret_1049A
		tst.w	move_lock(a0)
		bne.s	loc_1049C
		move.b	angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	locret_1049A
		move.w	inertia(a0),d0
		bpl.s	loc_10484
		neg.w	d0

loc_10484:
		cmpi.w	#$280,d0
		bcc.s	locret_1049A
		clr.w	inertia(a0)
		bset	#1,status(a0)
		move.w	#$1E,move_lock(a0)

locret_1049A:
		rts
; ===========================================================================

loc_1049C:
		subq.w	#1,move_lock(a0)
		rts
; End of function Sonic_SlopeRepel


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_JumpAngle:
		move.b	angle(a0),d0
		beq.s	loc_104BC
		bpl.s	loc_104B2
		addq.b	#2,d0
		bcc.s	loc_104B0
		moveq	#0,d0

loc_104B0:
		bra.s	loc_104B8
; ===========================================================================

loc_104B2:
		subq.b	#2,d0
		bcc.s	loc_104B8
		moveq	#0,d0

loc_104B8:
		move.b	d0,angle(a0)

loc_104BC:
		move.b	flip_angle(a0),d0
		beq.s	locret_104FA
		tst.w	inertia(a0)
		bmi.s	loc_104E0
		move.b	flip_speed(a0),d1
		add.b	d1,d0
		bcc.s	loc_104DE
		subq.b	#1,flips_remaining(a0)
		bcc.s	loc_104DE
		move.b	#0,flips_remaining(a0)
		moveq	#0,d0

loc_104DE:
		bra.s	loc_104F6
; ===========================================================================

loc_104E0:
		move.b	flip_speed(a0),d1
		sub.b	d1,d0
		bcc.s	loc_104F6
		subq.b	#1,flips_remaining(a0)
		bcc.s	loc_104F6
		move.b	#0,flips_remaining(a0)
		moveq	#0,d0

loc_104F6:
		move.b	d0,flip_angle(a0)

locret_104FA:
		rts
; End of function Sonic_JumpAngle


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Sonic_Floor:
Sonic_DoLevelCollision:
		move.l	#Primary_Collision,(Collision_addr).w
		cmpi.b	#$C,top_solid_bit(a0)
		beq.s	loc_10514
		move.l	#Secondary_Collision,(Collision_addr).w

loc_10514:
		move.b	lrb_solid_bit(a0),d5
		move.w	x_vel(a0),d1
		move.w	y_vel(a0),d2
		jsr	(CalcAngle).l
		subi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	Sonic_HitLeftWall
		cmpi.b	#$80,d0
		beq.w	Sonic_HitCeilingAndWalls
		cmpi.b	#$C0,d0
		beq.w	Sonic_HitRightWall
		bsr.w	CheckLeftWallDist
		tst.w	d1
		bpl.s	loc_10558
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_10558:
		bsr.w	CheckRightWallDist
		tst.w	d1
		bpl.s	loc_1056A
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_1056A:
		bsr.w	Sonic_CheckFloor
		tst.w	d1
		bpl.s	locret_105E2
		move.b	y_vel(a0),d2
		addq.b	#8,d2
		neg.b	d2
		cmp.b	d2,d1
		bge.s	loc_10582
		cmp.b	d2,d0
		blt.s	locret_105E2

loc_10582:
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#0,anim(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_105C0
		move.b	d3,d0
		addi.b	#$10,d0
		andi.b	#$20,d0
		beq.s	loc_105B2
		asr	y_vel(a0)
		bra.s	loc_105D4
; ===========================================================================

loc_105B2:
		move.w	#0,y_vel(a0)
		move.w	x_vel(a0),inertia(a0)
		rts
; ===========================================================================

loc_105C0:
		move.w	#0,x_vel(a0)
		cmpi.w	#$FC0,y_vel(a0)
		ble.s	loc_105D4
		move.w	#$FC0,y_vel(a0)

loc_105D4:
		move.w	y_vel(a0),inertia(a0)
		tst.b	d3
		bpl.s	locret_105E2
		neg.w	inertia(a0)

locret_105E2:
		rts
; ===========================================================================
; loc_105E4:
Sonic_HitLeftWall:
		bsr.w	CheckLeftWallDist
		tst.w	d1
		bpl.s	Sonic_HitCeiling
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		move.w	y_vel(a0),inertia(a0)
		rts
; ===========================================================================
; loc_105FE:
Sonic_HitCeiling:
		bsr.w	Sonic_CheckCeiling
		tst.w	d1
		bpl.s	Sonic_HitFloor
		sub.w	d1,y_pos(a0)
		tst.w	y_vel(a0)
		bpl.s	locret_10616
		move.w	#0,y_vel(a0)

locret_10616:
		rts
; ===========================================================================
; loc_10618:
Sonic_HitFloor:
		tst.w	y_vel(a0)
		bmi.s	locret_10644
		bsr.w	Sonic_CheckFloor
		tst.w	d1
		bpl.s	locret_10644
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#0,anim(a0)
		move.w	#0,y_vel(a0)
		move.w	x_vel(a0),inertia(a0)

locret_10644:
		rts
; ===========================================================================
; loc_10646:
Sonic_HitCeilingAndWalls:
		bsr.w	CheckLeftWallDist
		tst.w	d1
		bpl.s	loc_10658
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_10658:
		bsr.w	CheckRightWallDist
		tst.w	d1
		bpl.s	loc_1066A
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_1066A:
		bsr.w	Sonic_CheckCeiling
		tst.w	d1
		bpl.s	locret_106A0
		sub.w	d1,y_pos(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_1068A
		move.w	#0,y_vel(a0)
		rts
; ===========================================================================

loc_1068A:
		move.b	d3,angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.w	y_vel(a0),inertia(a0)
		tst.b	d3
		bpl.s	locret_106A0
		neg.w	inertia(a0)

locret_106A0:
		rts
; ===========================================================================
; loc_106A2:
Sonic_HitRightWall:
		bsr.w	CheckRightWallDist
		tst.w	d1
		bpl.s	Sonic_HitCeiling2
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		move.w	y_vel(a0),inertia(a0)
		rts
; ===========================================================================
; loc_106BC:
Sonic_HitCeiling2:
		bsr.w	Sonic_CheckCeiling
		tst.w	d1
		bpl.s	Sonic_HitFloor2
		sub.w	d1,y_pos(a0)
		tst.w	y_vel(a0)
		bpl.s	locret_106D4
		move.w	#0,y_vel(a0)

locret_106D4:
		rts
; ===========================================================================
; loc_106D6:
Sonic_HitFloor2:
		tst.w	y_vel(a0)
		bmi.s	locret_10702
		bsr.w	Sonic_CheckFloor
		tst.w	d1
		bpl.s	locret_10702
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#0,anim(a0)
		move.w	#0,y_vel(a0)
		move.w	x_vel(a0),inertia(a0)

locret_10702:
		rts
; End of function Sonic_DoLevelCollision

; ---------------------------------------------------------------------------
; Subroutine to reset variables when Sonic touches the ground
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_10704:
Sonic_ResetOnFloor:
		btst	#4,status(a0)			; is Sonic roll-jumping?
		beq.s	Sonic_ResetOnFloor_Part2	; if not, branch (useless check...)
		nop
		nop
		nop
; loc_10712:
Sonic_ResetOnFloor_Part2:
		bclr	#5,status(a0)		; clear pushing flag
		bclr	#1,status(a0)		; clear airborne flag
		bclr	#4,status(a0)		; clear roll-jumping flag
		btst	#2,status(a0)			; is Sonic rolling?
		beq.s	Sonic_ResetOnFloor_Part3	; if not, branch
		bclr	#2,status(a0)		; clear rolling flag
		move.b	#$13,y_radius(a0)	; reset Sonic's width and height
		move.b	#9,x_radius(a0)
		move.b	#0,anim(a0)
		subq.w	#5,y_pos(a0)		; reset Sonic's Y-position (to stop him from clipping)
; loc_10748:
Sonic_ResetOnFloor_Part3:
		move.b	#0,jumping(a0)
		move.w	#0,(Chain_Bonus_counter).w
		move.b	#0,flip_angle(a0)
		rts
; End of function Sonic_ResetOnFloor

; ===========================================================================
; Obj01_Hurt:
Sonic_Hurt:
		tst.b	routine_secondary(a0)
		bmi.w	loc_107E8
		jsr	(ObjectMove).l
		addi.w	#$30,y_vel(a0)
		btst	#6,status(a0)
		beq.s	loc_1077E
		subi.w	#$20,y_vel(a0)

loc_1077E:
		bsr.w	Sonic_HurtStop
		bsr.w	Sonic_LevelBound
		bsr.w	Sonic_RecordPos
		bsr.w	Sonic_Animate
		bsr.w	LoadSonicDynPLC
		jmp	(DisplaySprite).l

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_HurtStop:
		move.w	(Camera_Max_Y_pos).w,d0
		addi.w	#$E0,d0	; 'à'
		cmp.w	y_pos(a0),d0
		bcs.w	JmpTo_KillSonic
		bsr.w	Sonic_DoLevelCollision
		btst	#1,status(a0)
		bne.s	locret_107E6
		moveq	#0,d0
		move.w	d0,y_vel(a0)
		move.w	d0,x_vel(a0)
		move.w	d0,inertia(a0)
		tst.b	routine_secondary(a0)
		beq.s	loc_107D6
		move.b	#$FF,routine_secondary(a0)
		move.b	#$B,anim(a0)
		rts
; ===========================================================================

loc_107D6:
		move.b	#0,anim(a0)
		subq.b	#2,routine(a0)
		move.w	#$78,invulnerable_time(a0)

locret_107E6:
		rts
; End of function Sonic_HurtStop

; ===========================================================================

loc_107E8:
		cmpi.b	#$B,anim(a0)
		bne.s	loc_107FA
		move.b	(Ctrl_1_Press).w,d0
		andi.b	#$7F,d0
		beq.s	loc_10804

loc_107FA:
		subq.b	#2,routine(a0)
		move.b	#0,routine_secondary(a0)

loc_10804:
		bsr.w	Sonic_RecordPos
		bsr.w	Sonic_Animate
		bsr.w	LoadSonicDynPLC
		jmp	(DisplaySprite).l
; ===========================================================================
; Obj01_Death: Obj01_Dead:
Sonic_Dead:
		bsr.w	Sonic_GameOver
		jsr	(ObjectMoveAndFall).l
		bsr.w	Sonic_RecordPos
		bsr.w	Sonic_Animate
		bsr.w	LoadSonicDynPLC
		jmp	(DisplaySprite).l

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_GameOver:
		move.w	(Camera_Max_Y_pos).w,d0
		addi.w	#$100,d0
		cmp.w	y_pos(a0),d0
		bcc.w	locret_108B4
		move.w	#$FFC8,y_vel(a0)
		addq.b	#2,routine(a0)
		clr.b	(Update_HUD_timer).w
		addq.b	#1,(Update_HUD_lives).w
		subq.b	#1,(Life_count).w
		bne.s	loc_10888
		move.w	#0,$3A(a0)
		move.b	#ObjID_GameOver,(GameOver_GameText+id).w
		move.b	#ObjID_GameOver,(GameOver_OverText+id).w
		move.b	#1,(GameOver_OverText+mapping_frame).w
		clr.b	(Time_Over_flag).w

loc_10876:
		move.w	#MusID_GameOver,d0
		jsr	(PlayMusic).l
		moveq	#PLCID_GameOver,d0
		jmp	(LoadPLC).l
; ===========================================================================

loc_10888:
		move.w	#$3C,$3A(a0)
		tst.b	(Time_Over_flag).w
		beq.s	locret_108B4
		move.w	#0,$3A(a0)
		move.b	#ObjID_GameOver,(TimeOver_TimeText+id).w
		move.b	#ObjID_GameOver,(TimeOver_OverText+id).w
		move.b	#2,(TimeOver_TimeText+mapping_frame).w
		move.b	#3,(TimeOver_OverText+mapping_frame).w
		bra.s	loc_10876
; ===========================================================================

locret_108B4:
		rts
; End of function Sonic_GameOver

; ===========================================================================
; Obj01_ResetLevel:
Sonic_ResetLevel:
		tst.w	$3A(a0)
		beq.s	locret_108C8
		subq.w	#1,$3A(a0)
		bne.s	locret_108C8
		move.w	#1,(Level_Inactive_flag).w

locret_108C8:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to animate Sonic's sprites
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Animate:
		lea	(SonicAniData).l,a1
		moveq	#0,d0
		move.b	anim(a0),d0
		cmp.b	prev_anim(a0),d0
		beq.s	SonicAnimate_Do
		move.b	d0,prev_anim(a0)
		move.b	#0,anim_frame(a0)
		move.b	#0,anim_frame_duration(a0)
; loc_108EC:
SonicAnimate_Do:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		move.b	(a1),d0
		bmi.s	SonicAnimate_WalkRun
		move.b	status(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,render_flags(a0)
		or.b	d1,render_flags(a0)
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	SonicAnimate_Delay
		move.b	d0,anim_frame_duration(a0)
; sub_10912:
SonicAnimate_Do2:
		moveq	#0,d1
		move.b	anim_frame(a0),d1
		move.b	1(a1,d1.w),d0
		cmpi.b	#$F0,d0
		bcc.s	SonicAnimate_CmdFF
; loc_10922:
SonicAnimate_Next:
		move.b	d0,mapping_frame(a0)
		addq.b	#1,anim_frame(a0)
; locret_1092A:
SonicAnimate_Delay:
		rts
; ===========================================================================
; loc_1092C:
SonicAnimate_CmdFF:
		addq.b	#1,d0
		bne.s	SonicAnimate_CmdFE
		move.b	#0,anim_frame(a0)
		move.b	1(a1),d0
		bra.s	SonicAnimate_Next
; ===========================================================================
; loc_1093C:
SonicAnimate_CmdFE:
		addq.b	#1,d0
		bne.s	SonicAnimate_CmdFD
		move.b	2(a1,d1.w),d0
		sub.b	d0,anim_frame(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	SonicAnimate_Next
; ===========================================================================
; loc_10950:
SonicAnimate_CmdFD:
		addq.b	#1,d0
		bne.s	SonicAnimate_End
		move.b	2(a1,d1.w),anim(a0)
; locret_1095A:
SonicAnimate_End:
		rts
; ===========================================================================
; loc_1095C:
SonicAnimate_WalkRun:
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	SonicAnimate_Delay
		addq.b	#1,d0
		bne.w	SonicAnimate_Roll
		moveq	#0,d0
		move.b	flip_angle(a0),d0
		bne.w	SonicAnimate_Tumble
		moveq	#0,d1
		move.b	angle(a0),d0
		move.b	status(a0),d2
		andi.b	#1,d2
		bne.s	loc_10984
		not.b	d0

loc_10984:
		addi.b	#$10,d0
		bpl.s	loc_1098C
		moveq	#3,d1

loc_1098C:
		andi.b	#$FC,render_flags(a0)
		eor.b	d1,d2
		or.b	d2,render_flags(a0)
		btst	#5,status(a0)
		bne.w	SonicAnimate_Push
		lsr.b	#4,d0
		andi.b	#6,d0
		move.w	inertia(a0),d2
		bpl.s	loc_109B0
		neg.w	d2

loc_109B0:
		lea	(SonicAni_Run).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_109C2
		lea	(SonicAni_Walk).l,a1

loc_109C2:
		move.b	d0,d1
		lsr.b	#1,d1
		add.b	d1,d0
		add.b	d0,d0
		add.b	d0,d0
		move.b	d0,d3
		neg.w	d2
		addi.w	#$800,d2
		bpl.s	loc_109D8
		moveq	#0,d2

loc_109D8:
		lsr.w	#8,d2
		lsr.w	#1,d2
		move.b	d2,anim_frame_duration(a0)
		bsr.w	SonicAnimate_Do2
		add.b	d3,mapping_frame(a0)
		rts
; ===========================================================================
; loc_109EA:
SonicAnimate_Tumble:
		move.b	flip_angle(a0),d0
		moveq	#0,d1
		move.b	status(a0),d2
		andi.b	#1,d2
		bne.s	SonicAnimate_TumbleLeft

		andi.b	#$FC,render_flags(a0)
		moveq	#0,d2
		or.b	d2,render_flags(a0)
		addi.b	#$B,d0
		divu.w	#$16,d0
		addi.b	#$9B,d0
		move.b	d0,mapping_frame(a0)
		move.b	#0,anim_frame_duration(a0)
		rts
; ---------------------------------------------------------------------------
; loc_10A1E:
SonicAnimate_TumbleLeft:
		moveq	#3,d2
		andi.b	#$FC,render_flags(a0)
		or.b	d2,render_flags(a0)
		neg.b	d0
		addi.b	#$8F,d0
		divu.w	#$16,d0
		addi.b	#$9B,d0
		move.b	d0,mapping_frame(a0)
		move.b	#0,anim_frame_duration(a0)
		rts
; ===========================================================================
; loc_10A44:
SonicAnimate_Roll:
		addq.b	#1,d0
		bne.s	SonicAnimate_Push
		move.w	inertia(a0),d2
		bpl.s	loc_10A50
		neg.w	d2

loc_10A50:
		lea	(SonicAni_Roll2).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_10A62
		lea	(SonicAni_Roll).l,a1

loc_10A62:
		neg.w	d2
		addi.w	#$400,d2
		bpl.s	loc_10A6C
		moveq	#0,d2

loc_10A6C:
		lsr.w	#8,d2
		move.b	d2,anim_frame_duration(a0)
		move.b	status(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,render_flags(a0)
		or.b	d1,render_flags(a0)
		bra.w	SonicAnimate_Do2
; ===========================================================================
; loc_10A88:
SonicAnimate_Push:
		move.w	inertia(a0),d2
		bmi.s	loc_10A90
		neg.w	d2

loc_10A90:
		addi.w	#$800,d2
		bpl.s	loc_10A98
		moveq	#0,d2

loc_10A98:
		lsr.w	#6,d2
		move.b	d2,anim_frame_duration(a0)
		lea	(SonicAni_Push).l,a1
		move.b	status(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,render_flags(a0)
		or.b	d1,render_flags(a0)
		bra.w	SonicAnimate_Do2
; End of function Sonic_Animate

; ===========================================================================
; ---------------------------------------------------------------------------
; Animation script - Sonic
; ---------------------------------------------------------------------------
SonicAniData:	dc.w SonicAni_Walk-SonicAniData
		dc.w SonicAni_Run-SonicAniData
		dc.w SonicAni_Roll-SonicAniData
		dc.w SonicAni_Roll2-SonicAniData
		dc.w SonicAni_Push-SonicAniData
		dc.w SonicAni_Wait-SonicAniData
		dc.w SonicAni_Balance-SonicAniData
		dc.w SonicAni_LookUp-SonicAniData
		dc.w SonicAni_Duck-SonicAniData
		dc.w SonicAni_Spindash-SonicAniData
		dc.w SonicAni_WallRecoil1-SonicAniData
		dc.w SonicAni_WallRecoil2-SonicAniData
		dc.w SonicAni_0C-SonicAniData
		dc.w SonicAni_Stop-SonicAniData
		dc.w SonicAni_Float1-SonicAniData
		dc.w SonicAni_Float2-SonicAniData
		dc.w SonicAni_10-SonicAniData
		dc.w SonicAni_S1LZHang-SonicAniData
		dc.w SonicAni_Unused12-SonicAniData
		dc.w SonicAni_Unused13-SonicAniData
		dc.w SonicAni_Unused14-SonicAniData
		dc.w SonicAni_Bubble-SonicAniData
		dc.w SonicAni_Death1-SonicAniData
		dc.w SonicAni_Drown-SonicAniData
		dc.w SonicAni_Death2-SonicAniData
		dc.w SonicAni_Unused19-SonicAniData
		dc.w SonicAni_Hurt-SonicAniData
		dc.w SonicAni_S1LZSlide-SonicAniData
		dc.w SonicAni_1C-SonicAniData
		dc.w SonicAni_Float3-SonicAniData
		dc.w SonicAni_1E-SonicAniData
SonicAni_Walk:		dc.b $FF,$10,$11,$12,$13,$14,$15,$16,$17, $C, $D, $E, $F,$FF
SonicAni_Run:		dc.b $FF,$3C,$3D,$3E,$3F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
SonicAni_Roll:		dc.b $FE,$6C,$70,$6D,$70,$6E,$70,$6F,$70,$FF
SonicAni_Roll2:		dc.b $FE,$6C,$70,$6D,$70,$6E,$70,$6F,$70,$FF
SonicAni_Push:		dc.b $FD,$77,$78,$79,$7A,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
SonicAni_Wait:		dc.b   7,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1
			dc.b   1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  2
			dc.b   3,  3,  3,  4,  4,  5,  5,$FE,  4
SonicAni_Balance:	dc.b	7,$89,$8A,$FF
SonicAni_LookUp:	dc.b   5,  6,  7,$FE,  1
SonicAni_Duck:		dc.b   5,$7F,$80,$FE,  1
SonicAni_Spindash:	dc.b	 0,$71,$72,$71,$73,$71,$74,$71,$75,$71,$76,$71,$FF
SonicAni_WallRecoil1:	dc.b $3F,$82,$FF
SonicAni_WallRecoil2:	dc.b   7, 8, 8, 9,$FD,	5
SonicAni_0C:		dc.b   7,  9,$FD,  5
SonicAni_Stop:		dc.b   3,$81,$82,$83,$84,$85,$86,$87,$88,$FE,  2
SonicAni_Float1:	dc.b   7,$94,$96,$FF
SonicAni_Float2:	dc.b   7,$91,$92,$93,$94,$95,$FF
SonicAni_10:		dc.b $2F,$7E,$FD,  0
SonicAni_S1LZHang:	dc.b	 5,$8F,$90,$FF
SonicAni_Unused12:	dc.b	$F,$43,$43,$43,$FE,  1
SonicAni_Unused13:	dc.b	$F,$43,$44,$FE,	 1
SonicAni_Unused14:	dc.b $3F,$49,$FF
SonicAni_Bubble:	dc.b  $B,$97,$97,$12,$13,$FD,  0
SonicAni_Death1:	dc.b $20,$9A,$FF
SonicAni_Drown:		dc.b $20,$99,$FF
SonicAni_Death2:	dc.b $20,$98,$FF
SonicAni_Unused19:	dc.b	 3,$4E,$4F,$50,$51,$52,	 0,$FE,	 1
SonicAni_Hurt:		dc.b $40,$8D,$FF
SonicAni_S1LZSlide:	dc.b	  9,$8D,$8E,$FF
SonicAni_1C:		dc.b $77,  0,$FD,  0
SonicAni_Float3:	dc.b   3,$91,$92,$93,$94,$95,$FF
SonicAni_1E:		dc.b   3,$3C,$FD,  0
	even

; ---------------------------------------------------------------------------
; Sonic pattern loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


LoadSonicDynPLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		cmp.b	(Sonic_LastLoadedDPLC).w,d0
		beq.s	locret_10C34
		move.b	d0,(Sonic_LastLoadedDPLC).w
		lea	(SonicDynPLC).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	locret_10C34
		move.w	#$F000,d4
; loc_10C08:
SPLC_ReadEntry:
		moveq	#0,d1
		move.w	(a2)+,d1
		move.w	d1,d3
		lsr.w	#8,d3
		andi.w	#$F0,d3
		addi.w	#$10,d3
		andi.w	#$FFF,d1
		lsl.l	#5,d1
		addi.l	#Art_Sonic,d1
		move.w	d4,d2
		add.w	d3,d4
		add.w	d3,d4
		jsr	(QueueDMATransfer).l
		dbf	d5,SPLC_ReadEntry

locret_10C34:
		rts
; End of function LoadSonicDynPLC

; ===========================================================================
		nop