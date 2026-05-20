; ===========================================================================
; ---------------------------------------------------------------------------
; When debug mode is currently in use, you can actually find the original
; source code for it within the leftovers at $50A9C, which includes the
; code that has been commented out below
; ---------------------------------------------------------------------------

DebugMode:
		moveq	#0,d0
		move.b	(Debug_placement_mode).w,d0
		move.w	DebugIndex(pc,d0.w),d1
		jmp	DebugIndex(pc,d1.w)
; ===========================================================================
DebugIndex:	dc.w Debug_Init-DebugIndex
		dc.w Debug_Main-DebugIndex
; ===========================================================================
Debug_Init:
		addq.b	#2,(Debug_placement_mode).w
		move.w	(Camera_Min_Y_pos).w,(Camera_Min_Y_pos_Debug_Copy).w
		move.w	(Camera_Max_Y_pos_target).w,(Camera_Max_Y_pos_Debug_Copy).w
		move.w	#0,(Camera_Min_Y_pos).w
		move.w	#$720,(Camera_Max_Y_pos_target).w
		andi.w	#$7FF,(MainCharacter+y_pos).w
		andi.w	#$7FF,(Camera_Y_pos).w
		andi.w	#$3FF,(Camera_BG_Y_pos).w
		move.b	#0,mapping_frame(a0)
		move.b	#0,anim(a0)

; Debug_CheckSS:
		cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; is this the Special Stage?
		bne.s	loc_1BB04	; if not, branch
		;move.b	#7-1,(Current_Zone).w	; sets the debug object list and resets Special Stage rotation
		;move.w	#0,(SS_rotation_speed).w
		;move.w	#0,(SS_rotation_angle).w
		moveq	#6,d0		; force zone 6's debug object list (was the ending in S1)
		bra.s	loc_1BB0A
; ===========================================================================

loc_1BB04:
		moveq	#0,d0
		move.b	(Current_Zone).w,d0

loc_1BB0A:
		lea	(DebugList).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		cmp.b	(Debug_object).w,d6
		bhi.s	loc_1BB24
		move.b	#0,(Debug_object).w

loc_1BB24:
		bsr.w	LoadDebugObjectSprite
		move.b	#$C,(Debug_Accel_Timer).w
		move.b	#1,(Debug_Speed).w

Debug_Main:
		moveq	#6,d0		; force zone 6's debug object list (was the ending in S1)
		cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; is this the Special Stage?
		beq.s	loc_1BB44	; if yes, branch

		moveq	#0,d0
		move.b	(Current_Zone).w,d0

loc_1BB44:
		lea	(DebugList).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		bsr.w	Debug_Control
		;bsr.w	dirsprset		; I have no idea what this branches to, since it can't be found within the symbol tables
		jmp	(DisplaySprite).l

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Debug_Control:
		moveq	#0,d4
		move.w	#1,d1
		move.b	(Ctrl_1_Press).w,d4
		andi.w	#$F,d4
		bne.s	Debug_Move
		move.b	(Ctrl_1_Held).w,d0
		andi.w	#$F,d0
		bne.s	Debug_ContinueMoving
		move.b	#$C,(Debug_Accel_Timer).w
		move.b	#$F,(Debug_Speed).w
		bra.w	Debug_ControlObjects
; ===========================================================================
; loc_1BB86:
Debug_ContinueMoving:
		subq.b	#1,(Debug_Accel_Timer).w
		bne.s	Debug_TimerNotOver
		move.b	#1,(Debug_Accel_Timer).w
		addq.b	#1,(Debug_Speed).w
		;cmpi.b	#-1,(Debug_Speed).w	; this effectively resets the Debug movement speed when it reaches 255
		bne.s	Debug_Move
		move.b	#-1,(Debug_Speed).w
; loc_1BB9E:
Debug_Move:
		move.b	(Ctrl_1_Held).w,d4
; loc_1BBA2:
Debug_TimerNotOver:
		moveq	#0,d1
		move.b	(Debug_Speed).w,d1
		addq.w	#1,d1
		swap	d1
		asr.l	#4,d1
		move.l	y_pos(a0),d2
		move.l	x_pos(a0),d3

		; move up
		btst	#0,d4
		beq.s	loc_1BBC2
		sub.l	d1,d2
		bcc.s	loc_1BBC2
		moveq	#0,d2

loc_1BBC2:
		; move down
		btst	#1,d4
		beq.s	loc_1BBD8
		add.l	d1,d2
		cmpi.l	#$7FF0000,d2
		bcs.s	loc_1BBD8
		move.l	#$7FF0000,d2

loc_1BBD8:
		; move left
		btst	#2,d4
		beq.s	loc_1BBE4
		sub.l	d1,d3
		bcc.s	loc_1BBE4
		moveq	#0,d3

loc_1BBE4:
		; move right
		btst	#3,d4
		beq.s	loc_1BBEC
		add.l	d1,d3

loc_1BBEC:
		move.l	d2,y_pos(a0)
		move.l	d3,x_pos(a0)
; loc_1BBF4:
Debug_ControlObjects:
		btst	#6,(Ctrl_1_Held).w
		beq.s	Debug_SpawnObject
		btst	#5,(Ctrl_1_Press).w
		beq.s	Debug_CycleObjects
		; cycle backwards through the object list
		subq.b	#1,(Debug_object).w
		bcc.s	loc_1BC28
		add.b	d6,(Debug_object).w
		bra.s	loc_1BC28
; ===========================================================================
; loc_1BC10:
Debug_CycleObjects:
		btst	#6,(Ctrl_1_Press).w
		beq.s	Debug_SpawnObject
		addq.b	#1,(Debug_object).w
		cmp.b	(Debug_object).w,d6
		bhi.s	loc_1BC28
		move.b	#0,(Debug_object).w

loc_1BC28:
		bra.w	LoadDebugObjectSprite
; ===========================================================================
; loc_1BC2C:
Debug_SpawnObject:
		btst	#5,(Ctrl_1_Press).w
		beq.s	Debug_ExitDebugMode
		; spawn object
		jsr	(AllocateObject).l
		bne.s	Debug_ExitDebugMode
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	mappings(a0),id(a1) ; load obj
		move.b	render_flags(a0),render_flags(a1)
		move.b	render_flags(a0),status(a1)
		andi.b	#$7F,status(a1)
		moveq	#0,d0
		move.b	(Debug_object).w,d0
		lsl.w	#3,d0
		move.b	4(a2,d0.w),subtype(a1)
		rts
; ===========================================================================
; loc_1BC70:
Debug_ExitDebugMode:
		btst	#4,(Ctrl_1_Press).w
		beq.s	locret_1BCCA
		; exit Debug Mode
		moveq	#0,d0
		move.w	d0,(Debug_placement_mode).w
		move.l	#MapUnc_Sonic,(MainCharacter+mappings).w
		move.w	#$780,(MainCharacter+art_tile).w
		tst.w	(Two_player_mode).w
		beq.s	loc_1BC98
		move.w	#$3C0,(MainCharacter+art_tile).w

loc_1BC98:
		move.b	d0,(MainCharacter+anim).w
		move.w	d0,x_sub(a0)
		move.w	d0,y_sub(a0)
		move.w	(Camera_Min_Y_pos_Debug_Copy).w,(Camera_Min_Y_pos).w
		move.w	(Camera_Max_Y_pos_Debug_Copy).w,(Camera_Max_Y_pos_target).w
		cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; is this the Special Stage?
		bne.s	locret_1BCCA		; if not, branch

		;clr.w	(SS_rotation_angle).w		; again, this resets the Special Stage rotation
		;move.w	#$40,(SS_rotation_speed).w	; and Sonic's art for whatever reason
		;move.l	#MapUnc_Sonic,($FFFFD004).w
		;move.w	#$780,($FFFFD002).w

		move.b	#2,(MainCharacter+anim).w
		bset	#2,(MainCharacter+status).w
		bset	#1,(MainCharacter+status).w

locret_1BCCA:
		rts
; End of function Debug_Control


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1BCCC: Debug_ShowItem:
LoadDebugObjectSprite:
		moveq	#0,d0
		move.b	(Debug_object).w,d0
		lsl.w	#3,d0
		move.l	(a2,d0.w),mappings(a0)
		move.w	6(a2,d0.w),art_tile(a0)
		move.b	5(a2,d0.w),mapping_frame(a0)
		;move.b	4(a2,d0.w),subtype(a0)		; this is useless since we already loaded it earlier
		bsr.w	JmpTo10_Adjust2PArtPointer
		rts
; End of function Debug_ShowItem

; ===========================================================================
DebugList:	dc.w Debug_GHZ-DebugList
		dc.w Debug_CPZ-DebugList
		dc.w Debug_CPZ-DebugList
		dc.w Debug_EHZ-DebugList
		dc.w Debug_HPZ-DebugList
		dc.w Debug_HTZ-DebugList
		dc.w Debug_HPZ-DebugList

; macro for the header of a debug list
debugheader macro *
\*:	dc.w (\*_End-\*-2)/8
	endm

; macro for a debug object entry
debugobj macro mappings,id,subtype,frame,vram
	dc.l	mappings+(id<<24)
	dc.b	subtype, frame
	dc.w	vram
	endm

Debug_GHZ:	debugheader
		debugobj MapUnc_Ring, ObjID_Ring, 0, 0, $26BC
		debugobj Map_Obj26, ObjID_Monitor, 0, 0, $680
		debugobj MapUnc_Crabmeat, ObjID_Crabmeat, 0, 0, $400
		debugobj MapUnc_BuzzBomber, ObjID_BuzzBomber, 0, 0, $444
		debugobj Map_Obj2B, ObjID_Chopper, 0, 0, $470
		debugobj Map_Obj36, ObjID_Spikes, 0, 0, $4A0
		debugobj Map_Obj18, ObjID_Platform, 0, 0, $4000
		debugobj Map_Obj3B, ObjID_PurpleRock, 0, 0, $66C0
		debugobj MapUnc_Motobug, ObjID_Motobug, 0, 0, $4E0
		debugobj Map_obj41_GHZ, ObjID_Spring, 0, 0, $4A8
		debugobj Map_obj42, ObjID_Newtron, 0, 0, $249B
		debugobj Map_obj44, ObjID_GHZWall, 0, 0, $434C
		debugobj MapUnc_Checkpoint, ObjID_Checkpoint, 1, 0, $26BC
		debugobj Map_Obj03, ObjID_Pathswapper, 0, 0, $26BC
Debug_GHZ_End:

Debug_CPZ:	debugheader
		debugobj MapUnc_Ring, ObjID_Ring, 0, 0, $26BC
		debugobj Map_Obj26, ObjID_Monitor, 0, 0, $680
		debugobj Map_obj41_GHZ, ObjID_Spring, 0, 0, $4A8
		debugobj Map_Obj03, ObjID_Pathswapper, 0, 0, $7BC
		debugobj MapUnc_TippingFloor, ObjID_TippingFloor, 0, 0, $E000
		debugobj MapUnc_CPZPlatform, ObjID_CPZPlatform, 0, 0, $E418
		debugobj Map_Obj15_CPZ, ObjID_SwingingPlatform, 8, 0, $2418
		debugobj Map_Obj03, ObjID_Pathswapper, 9, 1, $26BC
		debugobj Map_Obj03, ObjID_Pathswapper, $D, 5, $26BC
		debugobj Map_Obj19, ObjID_Platform2, 1, 0, $6400
		debugobj Map_Obj36, ObjID_Spikes, 0, 0, $2434
		debugobj Map_obj41, ObjID_Spring, $81, 0, $45C
		debugobj Map_obj41, ObjID_Spring, $90, 3, $470
		debugobj Map_obj41, ObjID_Spring, $A0, 6, $45C
		debugobj Map_obj41, ObjID_Spring, $30, 7, $43C
		debugobj Map_obj41, ObjID_Spring, $40, $A, $43C
Debug_CPZ_End:

Debug_EHZ:	debugheader
		debugobj MapUnc_Ring, ObjID_Ring, 0, 0, $26BC
		debugobj Map_Obj26, ObjID_Monitor, 0, 0, $680
		debugobj MapUnc_Checkpoint, ObjID_Checkpoint, 1, 0, $47C
		debugobj Map_Obj03, ObjID_Pathswapper, 0, 0, $26BC
		debugobj MapUnc_EHZWaterfall, ObjID_EHZWaterfall, 0, 0, $23AE
		debugobj MapUnc_EHZWaterfall, ObjID_EHZWaterfall, 2, 3, $23AE
		debugobj MapUnc_EHZWaterfall, ObjID_EHZWaterfall, 4, 5, $23AE
		debugobj Map_obj18_EHZ, ObjID_Platform, 1, 0, $4000
		debugobj Map_obj18_EHZ, ObjID_Platform, $A, 1, $4000
		debugobj Map_Obj36, ObjID_Spikes, 0, 0, $2434
		debugobj MapUnc_Seesaw, ObjID_Seesaw, 0, 0, $3CE
		debugobj Map_obj41, ObjID_Spring, $81, 0, $45C
		debugobj Map_obj41, ObjID_Spring, $90, 3, $470
		debugobj Map_obj41, ObjID_Spring, $A0, 6, $45C
		debugobj Map_obj41, ObjID_Spring, $30, 7, $43C
		debugobj Map_obj41, ObjID_Spring, $40, $A, $43C
		debugobj MapUnc_Buzzer, ObjID_Buzzer, 0, 0, $3E6
		debugobj Map_obj54, ObjID_Snail, 0, 0, $402
		debugobj MapUnc_Masher, ObjID_Masher, 0, 0, $41C
Debug_EHZ_End:
		debugobj MapUnc_Redz, ObjID_Redz, 0, 0, $500
		debugobj MapUnc_BFish, ObjID_BFish, 0, 0, $2530
		debugobj MapUnc_Seahorse, ObjID_Seahorse, 0, 0, $2570
		debugobj MapUnc_Seahorse, ObjID_Skyhorse, 0, 0, $2570
		debugobj Map_Obj4D, ObjID_Stego, 0, 0, $23C4
		debugobj MapUnc_Buzzer, ObjID_Buzzer, 0, 0, $32C
		debugobj Map_Obj4E, ObjID_Gator, 0, 0, $2300
		debugobj MapUnc_BBat, ObjID_BBat, 0, 0, $2350
		debugobj MapUnc_Octus, ObjID_Octus, 0, 0, $238A

Debug_HTZ:	debugheader
		debugobj MapUnc_Ring, ObjID_Ring, 0, 0, $26BC
		debugobj Map_Obj26, ObjID_Monitor, 0, 0, $680
		debugobj MapUnc_Checkpoint, ObjID_Checkpoint, 1, 0, $47C
		debugobj Map_Obj03, ObjID_Pathswapper, 0, 0, $26BC
		debugobj Map_obj18_EHZ, ObjID_Platform, 1, 0, $4000
		debugobj Map_obj18_EHZ, ObjID_Platform, $A, 1, $4000
		debugobj Map_Obj36, ObjID_Spikes, 0, 0, $2434
		debugobj MapUnc_Seesaw, ObjID_Seesaw, 0, 0, $3CE
		debugobj Map_obj41, ObjID_Spring, $81, 0, $45C
		debugobj Map_obj41, ObjID_Spring, $90, 3, $470
		debugobj Map_obj41, ObjID_Spring, $A0, 6, $45C
		debugobj Map_obj41, ObjID_Spring, $30, 7, $43C
		debugobj Map_obj41, ObjID_Spring, $40, $A, $43C
		debugobj MapUnc_HTZLift, ObjID_HTZLift, 0, 0, $43E6
		debugobj MapUnc_HTZLift, ObjID_Scenery, 4, 1, $43E6
		debugobj MapUnc_HTZLift, ObjID_Scenery, 5, 2, $43E6
		debugobj MapUnc_Buzzer, ObjID_Buzzer, 0, 0, $3E6
		debugobj Map_obj54, ObjID_Snail, 0, 0, $402
		debugobj MapUnc_Masher, ObjID_Masher, 0, 0, $41C
Debug_HTZ_End:

Debug_HPZ:	debugheader
		debugobj MapUnc_Ring, ObjID_Ring, 0, 0, $26BC
		debugobj Map_Obj26, ObjID_Monitor, 0, 0, $680
		debugobj MapUnc_HPZOrb, ObjID_Scenery, $21, 3, $E485
		debugobj MapUnc_HPZWaterfall, ObjID_HPZWaterfall, 4, 4, $E415
		debugobj Map_Obj1A_HPZ, ObjID_CollapsingPltfm, 0, 0, $4475
		debugobj Map_Obj03, ObjID_Pathswapper, 0, 0, $26BC
		debugobj MapUnc_Redz, ObjID_Redz, 0, 0, $500
		debugobj MapUnc_BFish, ObjID_BFish, 0, 0, $2530
		debugobj MapUnc_Seahorse, ObjID_Seahorse, 0, 0, $2570
		debugobj MapUnc_Seahorse, ObjID_Skyhorse, 0, 0, $2570
		debugobj Map_Obj4D, ObjID_Stego, 0, 0, $23C4
		debugobj MapUnc_Buzzer, ObjID_Buzzer, 0, 0, $32C
		debugobj Map_Obj4E, ObjID_Gator, 0, 0, $2300
		debugobj MapUnc_BBat, ObjID_BBat, 0, 0, $2350
		debugobj MapUnc_Octus, ObjID_Octus, 0, 0, $238A
Debug_HPZ_End: