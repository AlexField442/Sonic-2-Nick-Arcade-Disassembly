; ===========================================================================
; ---------------------------------------------------------------------------
; Object 3A - End of level results screen
; ---------------------------------------------------------------------------
; Sprite_BB46: Obj3A:
Obj_Results:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Results_Index(pc,d0.w),d1
		jmp	Results_Index(pc,d1.w)
; ===========================================================================
; Obj3A_Index:
Results_Index:	dc.w Results_ChkPLC-Results_Index
		dc.w Results_ChkPos-Results_Index
		dc.w Results_Wait-Results_Index
		dc.w Results_NextLevel-Results_Index
; ===========================================================================
; loc_BB5C: Obj3A_ChkPLC:
Results_ChkPLC:
		tst.l	(Plc_Buffer).w
		beq.s	Results_Config
		rts
; ---------------------------------------------------------------------------
; loc_BB64: Obj3A_Config:
Results_Config:
		movea.l	a0,a1
		lea	(Results_Conf).l,a2
		moveq	#6,d1
; loc_BB6E: Obj3A_Init:
Results_Init:
		move.b	#$3A,id(a1)
		move.w	(a2),x_pixel(a1)
		move.w	(a2)+,$32(a1)
		move.w	(a2)+,$30(a1)
		move.w	(a2)+,y_pixel(a1)
		move.b	(a2)+,routine(a1)
		move.b	(a2)+,d0
		cmpi.b	#6,d0
		bne.s	loc_BB94
		add.b	(Current_Act).w,d0

loc_BB94:
		move.b	d0,mapping_frame(a1)
		move.l	#Map_Obj3A,mappings(a1)
		move.w	#$8580,art_tile(a1)
		bsr.w	Adjust2PArtPointer2
		move.b	#0,render_flags(a1)
		lea	$40(a1),a1
		dbf	d1,Results_Init
; loc_BBB8: Obj3A_ChkPos:
Results_ChkPos:
		moveq	#$10,d1
		move.w	$30(a0),d0
		cmp.w	x_pixel(a0),d0
		beq.s	loc_BBEA
		bge.s	Results_Move
		neg.w	d1
; loc_BBC8: Obj3A_Move:
Results_Move:
		add.w	d1,x_pixel(a0)

loc_BBCC:
		move.w	x_pixel(a0),d0
		bmi.s	locret_BBDE
		cmpi.w	#$200,d0
		bcc.s	locret_BBDE
		rts
; ---------------------------------------------------------------------------
		bra.w	DisplaySprite
; ===========================================================================

locret_BBDE:
		rts
; ===========================================================================

loc_BBE0:
		move.b	#$E,routine(a0)
		bra.w	Results_MoveBack
; ===========================================================================

loc_BBEA:
		cmpi.b	#$E,(Object_RAM+$700+routine).w
		beq.s	loc_BBE0
		cmpi.b	#4,mapping_frame(a0)
		bne.s	loc_BBCC
		addq.b	#2,routine(a0)
		move.w	#$B4,anim_frame_duration(a0)
; loc_BC04: Obj3A_Wait:
Results_Wait:
		subq.w	#1,anim_frame_duration(a0)
		bne.s	locret_BC0E
		addq.b	#2,routine(a0)

locret_BC0E:
		rts
; ---------------------------------------------------------------------------
		bra.w	DisplaySprite
; ===========================================================================
; Obj3A_TimeBonus:
Results_TimeBonus:
		bsr.w	DisplaySprite
		move.b	#1,(Update_Bonus_score).w
		moveq	#0,d0
		tst.w	(Bonus_Countdown_1).w
		beq.s	Results_RingBonus
		addi.w	#$A,d0
		subi.w	#$A,(Bonus_Countdown_1).w
; loc_BC30: Obj3A_RingBonus:
Results_RingBonus:
		tst.w	(Bonus_Countdown_2).w
		beq.s	Results_ChkBonus
		addi.w	#$A,d0
		subi.w	#$A,(Bonus_Countdown_2).w
; loc_BC40: Obj3A_ChkBonus:
Results_ChkBonus:
		tst.w	d0
		bne.s	Results_AddBonus
		move.w	#$C5,d0
		jsr	(PlaySound_Special).l
		addq.b	#2,routine(a0)
		cmpi.w	#$501,(Current_ZoneAndAct).w
		bne.s	Results_SetDelay
		addq.b	#4,routine(a0)
; loc_BC5E: Obj3A_SetDelay:
Results_SetDelay:
		move.w	#$B4,anim_frame_duration(a0)

locret_BC64:
		rts
; ===========================================================================
; loc_BC66: Obj3A_AddBonus:
Results_AddBonus:
		jsr	(AddPoints).l
		move.b	(Vint_runcount+3).w,d0
		andi.b	#3,d0
		bne.s	locret_BC64
		move.w	#$CD,d0
		jmp	(PlaySound_Special).l
; ===========================================================================
; loc_BC80: Obj3A_NextLevel:
Results_NextLevel:
		move.b	(Current_Zone).w,d0
		andi.w	#7,d0
		lsl.w	#3,d0
		move.b	(Current_Act).w,d1
		andi.w	#3,d1
		add.w	d1,d1
		add.w	d1,d0
		move.w	LevelOrder(pc,d0.w),d0
		move.w	d0,(Current_ZoneAndAct).w
		tst.w	d0
		bne.s	Results_ChkSS
		move.b	#GameModeID_SegaScreen,(Game_Mode).w
		bra.s	locret_BCC2
; ===========================================================================
; loc_BCAA: Obj3A_ChkSS:
Results_ChkSS:
		clr.b	(Last_star_pole_hit).w
		tst.b	(EnterSS_flag).w
		beq.s	loc_BCBC
		move.b	#GameModeID_SpecialStage,(Game_Mode).w
		bra.s	locret_BCC2
; ===========================================================================

loc_BCBC:
		move.w	#1,(Level_Inactive_flag).w

locret_BCC2:
		rts
; ---------------------------------------------------------------------------
		bra.w	DisplaySprite
; ===========================================================================
LevelOrder:	dc.w	 1,    2, $200,	   0
		dc.w  $101, $102, $300,	$502
		dc.w  $201, $202, $400,	   0
		dc.w  $301, $302, $500,	   0
		dc.w  $401, $402, $100,	   0
		dc.w  $501, $103,    0,	   0
; ===========================================================================
; loc_BCF8: Obj3A_MoveBack:
Results_MoveBack:
		moveq	#$20,d1
		move.w	$32(a0),d0
		cmp.w	x_pixel(a0),d0
		beq.s	loc_BD1E
		bge.s	loc_BD08
		neg.w	d1

loc_BD08:
		add.w	d1,x_pixel(a0)
		move.w	x_pixel(a0),d0
		bmi.s	locret_BD1C
		cmpi.w	#$200,d0
		bcc.s	locret_BD1C
		bra.w	DisplaySprite
; ===========================================================================

locret_BD1C:
		rts
; ===========================================================================

loc_BD1E:
		cmpi.b	#4,mapping_frame(a0)
		bne.w	DeleteObject
		addq.b	#2,routine(a0)
		clr.b	(Control_Locked).w
		move.w	#MusID_FZ,d0
		jmp	(PlaySound).l
; ---------------------------------------------------------------------------
; Obj3A_SetBoundary:
Results_SetBoundary:
		addq.w	#2,(Camera_Max_X_pos).w
		cmpi.w	#$2100,(Camera_Max_X_pos).w
		beq.w	DeleteObject
		rts
; ===========================================================================
; Obj3A_Conf:
Results_Conf:	dc.w	 4, $124,  $BC,	$200
		dc.w $FEE0, $120,  $D0,	$201
		dc.w  $40C, $14C,  $D6,	$206
		dc.w  $520, $120,  $EC,	$202
		dc.w  $540, $120,  $FC,	$203
		dc.w  $560, $120, $10C,	$204
		dc.w  $20C, $14C,  $CC,	$205