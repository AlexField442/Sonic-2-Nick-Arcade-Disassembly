; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HudUpdate:
		nop
		lea	(VDP_data_port).l,a6
		tst.w	(Debug_mode_flag).w
		bne.w	loc_1B330
		tst.b	(Update_HUD_score).w
		beq.s	loc_1B266
		clr.b	(Update_HUD_score).w
		move.l	#$5C800003,d0
		move.l	(Score).w,d1
		bsr.w	HUD_Score

loc_1B266:
		tst.b	(Update_HUD_rings).w
		beq.s	loc_1B286
		bpl.s	loc_1B272
		bsr.w	HUD_LoadZero

loc_1B272:
		clr.b	(Update_HUD_rings).w
		move.l	#$5F400003,d0
		moveq	#0,d1
		move.w	(Ring_count).w,d1
		bsr.w	HUD_Rings

loc_1B286:
		tst.b	(Update_HUD_timer).w
		beq.s	loc_1B2E2
		tst.w	(Game_paused).w
		bne.s	loc_1B2E2
		lea	(Timer).w,a1
		cmpi.l	#$93B3B,(a1)+	; if the timer has passed 9:59...
		nop			; ...do nothing since this has been nopped out
		addq.b	#1,-(a1)
		cmpi.b	#$3C,(a1)
		bcs.s	loc_1B2E2
		move.b	#0,(a1)
		addq.b	#1,-(a1)
		cmpi.b	#$3C,(a1)
		bcs.s	loc_1B2C2
		move.b	#0,(a1)
		addq.b	#1,-(a1)
		cmpi.b	#9,(a1)
		bcs.s	loc_1B2C2
		move.b	#9,(a1)

loc_1B2C2:
		move.l	#$5E400003,d0
		moveq	#0,d1
		move.b	(Timer_minute).w,d1
		bsr.w	HUD_Mins
		move.l	#$5EC00003,d0
		moveq	#0,d1
		move.b	(Timer_second).w,d1
		bsr.w	HUD_Secs

loc_1B2E2:
		tst.b	(Update_HUD_lives).w
		beq.s	loc_1B2F0
		clr.b	(Update_HUD_lives).w
		bsr.w	HUD_Lives

loc_1B2F0:
		tst.b	(Update_Bonus_score).w
		beq.s	locret_1B318
		clr.b	(Update_Bonus_score).w
		move.l	#$6E000002,(VDP_control_port).l
		moveq	#0,d1
		move.w	(Bonus_Countdown_1).w,d1
		bsr.w	HUD_TimeRingBonus
		moveq	#0,d1
		move.w	(Bonus_Countdown_2).w,d1
		bsr.w	HUD_TimeRingBonus

locret_1B318:
		rts
; ===========================================================================
; kills the player if the time has reached 9:59, except now it's unused due
; to its "beq" command being noped out above
S1TimeOver:
		clr.b	(Update_HUD_timer).w
		lea	(MainCharacter).w,a0
		movea.l	a0,a2
		bsr.w	KillSonic
		move.b	#1,(Time_Over_flag).w
		rts
; ===========================================================================

loc_1B330:				; CODE XREF: HudUpdate+Cj
		bsr.w	HUDDebug_XY
		tst.b	(Update_HUD_rings).w
		beq.s	loc_1B354
		bpl.s	loc_1B340
		bsr.w	HUD_LoadZero

loc_1B340:				; CODE XREF: HudUpdate+FCj
		clr.b	(Update_HUD_rings).w
		move.l	#$5F400003,d0
		moveq	#0,d1
		move.w	(Ring_count).w,d1
		bsr.w	HUD_Rings

loc_1B354:				; CODE XREF: HudUpdate+FAj
		move.l	#$5EC00003,d0
		moveq	#0,d1
		move.b	(Sprite_count).w,d1
		bsr.w	HUD_Secs
		tst.b	(Update_HUD_lives).w
		beq.s	loc_1B372
		clr.b	(Update_HUD_lives).w
		bsr.w	HUD_Lives

loc_1B372:				; CODE XREF: HudUpdate+12Aj
		tst.b	(Update_Bonus_score).w
		beq.s	locret_1B39A
		clr.b	(Update_Bonus_score).w
		move.l	#$6E000002,(VDP_control_port).l
		moveq	#0,d1
		move.w	(Bonus_Countdown_1).w,d1
		bsr.w	HUD_TimeRingBonus
		moveq	#0,d1
		move.w	(Bonus_Countdown_2).w,d1
		bsr.w	HUD_TimeRingBonus

locret_1B39A:				; CODE XREF: HudUpdate+138j
		rts
; End of function HudUpdate


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HUD_LoadZero:				; CODE XREF: HudUpdate+30p
					; HudUpdate+FEp
		move.l	#$5F400003,(VDP_control_port).l
		lea	HUD_TilesZero(pc),a2
		move.w	#2,d2
		bra.s	loc_1B3CC
; End of function HUD_LoadZero


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HUD_Base:				; CODE XREF: ROM:00003D24p
					; ROM:00005248p
		lea	(VDP_data_port).l,a6
		bsr.w	HUD_Lives
		move.l	#$5C400003,(VDP_control_port).l
		lea	HUD_TilesBase(pc),a2
		move.w	#$E,d2

loc_1B3CC:				; CODE XREF: HUD_LoadZero+12j
		lea	Art_HUD(pc),a1

loc_1B3D0:				; CODE XREF: HUD_Base:loc_1B3E6j
		move.w	#$F,d1
		move.b	(a2)+,d0
		bmi.s	loc_1B3EC
		ext.w	d0
		lsl.w	#5,d0
		lea	(a1,d0.w),a3

loc_1B3E0:				; CODE XREF: HUD_Base+32j
		move.l	(a3)+,(a6)
		dbf	d1,loc_1B3E0

loc_1B3E6:				; CODE XREF: HUD_Base+46j
		dbf	d2,loc_1B3D0
		rts
; ===========================================================================

loc_1B3EC:				; CODE XREF: HUD_Base+26j HUD_Base+42j
		move.l	#0,(a6)
		dbf	d1,loc_1B3EC
		bra.s	loc_1B3E6
; End of function HUD_Base

; ===========================================================================
HUD_TilesBase:	dc.b $16,$FF,$FF,$FF,$FF,$FF,$FF,  0,  0,$14,  0,  0; 0
					; DATA XREF: HUD_Base+14t
HUD_TilesZero:	dc.b $FF,$FF,  0,  0	; 0 ; DATA XREF: HUD_LoadZero+At

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HUDDebug_XY:				; CODE XREF: HudUpdate:loc_1B330p
		move.l	#$5C400003,(VDP_control_port).l
		move.w	(Camera_X_pos).w,d1
		swap	d1
		move.w	(MainCharacter+x_pos).w,d1
		bsr.s	HUDDebug_XY2
		move.w	(Camera_Y_pos).w,d1
		swap	d1
		move.w	(MainCharacter+y_pos).w,d1
; End of function HUDDebug_XY


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HUDDebug_XY2:				; CODE XREF: HUDDebug_XY+14p
		moveq	#7,d6
		lea	(Art_Text).l,a1

loc_1B430:				; CODE XREF: HUDDebug_XY2+32j
		rol.w	#4,d1
		move.w	d1,d2
		andi.w	#$F,d2
		cmpi.w	#$A,d2
		bcs.s	loc_1B442
		addi.w	#7,d2

loc_1B442:				; CODE XREF: HUDDebug_XY2+14j
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		swap	d1
		dbf	d6,loc_1B430
		rts
; End of function HUDDebug_XY2


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HUD_Rings:				; CODE XREF: HudUpdate+44p
					; HudUpdate+112p
		lea	(HUD_100).l,a2
		moveq	#2,d6
		bra.s	loc_1B472
; End of function HUD_Rings


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HUD_Score:				; CODE XREF: HudUpdate+24p
		lea	(HUD_100000).l,a2
		moveq	#5,d6

loc_1B472:				; CODE XREF: HUD_Rings+8j
		moveq	#0,d4
		lea	Art_HUD(pc),a1

loc_1B478:				; CODE XREF: HUD_Score+58j
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1B47C:				; CODE XREF: HUD_Score+18j
		sub.l	d3,d1
		bcs.s	loc_1B484
		addq.w	#1,d2
		bra.s	loc_1B47C
; ===========================================================================

loc_1B484:				; CODE XREF: HUD_Score+14j
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1B48E
		move.w	#1,d4

loc_1B48E:				; CODE XREF: HUD_Score+1Ej
		tst.w	d4
		beq.s	loc_1B4BC
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_1B4BC:				; CODE XREF: HUD_Score+26j
		addi.l	#$400000,d0
		dbf	d6,loc_1B478
		rts
; End of function HUD_Score

; ===========================================================================

HUD_Unk:
		move.l	#$5F800003,(VDP_control_port).l
		lea	(VDP_data_port).l,a6
		lea	(HUD_10).l,a2
		moveq	#1,d6
		moveq	#0,d4
		lea	Art_HUD(pc),a1

loc_1B4E6:				; CODE XREF: ROM:0001B51Aj
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1B4EA:				; CODE XREF: ROM:0001B4F0j
		sub.l	d3,d1
		bcs.s	loc_1B4F2
		addq.w	#1,d2
		bra.s	loc_1B4EA
; ===========================================================================

loc_1B4F2:				; CODE XREF: ROM:0001B4ECj
		add.l	d3,d1
		lsl.w	#6,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		dbf	d6,loc_1B4E6
		rts
; ===========================================================================
HUD_100000:	dc.l 100000		; DATA XREF: HUD_Scoreo
HUD_10000:	dc.l 10000
HUD_1000:	dc.l 1000		; DATA XREF: HUD_TimeRingBonust
HUD_100:	dc.l 100		; DATA XREF: HUD_Ringso
HUD_10:		dc.l 10			; DATA XREF: ROM:0001B4D8o HUD_Secst ...
HUD_1:		dc.l 1			; DATA XREF: HUD_Minst

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HUD_Mins:				; CODE XREF: HudUpdate+90p
		lea	HUD_1(pc),a2
		moveq	#0,d6
		bra.s	loc_1B546
; End of function HUD_Mins


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HUD_Secs:				; CODE XREF: HudUpdate+A0p
					; HudUpdate+122p
		lea	HUD_10(pc),a2
		moveq	#1,d6

loc_1B546:				; CODE XREF: HUD_Mins+6j
		moveq	#0,d4

loc_1B548:
		lea	Art_HUD(pc),a1

loc_1B54C:				; CODE XREF: HUD_Secs+52j
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1B550:				; CODE XREF: HUD_Secs+16j
		sub.l	d3,d1
		bcs.s	loc_1B558
		addq.w	#1,d2
		bra.s	loc_1B550
; ===========================================================================

loc_1B558:				; CODE XREF: HUD_Secs+12j
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1B562
		move.w	#1,d4

loc_1B562:				; CODE XREF: HUD_Secs+1Cj
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		addi.l	#$400000,d0
		dbf	d6,loc_1B54C
		rts
; End of function HUD_Secs


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HUD_TimeRingBonus:			; CODE XREF: HudUpdate+CCp
					; HudUpdate+D6p ...
		lea	HUD_1000(pc),a2
		moveq	#3,d6
		moveq	#0,d4
		lea	Art_HUD(pc),a1

loc_1B5A4:				; CODE XREF: HUD_TimeRingBonus:loc_1B5E4j
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1B5A8:				; CODE XREF: HUD_TimeRingBonus+16j
		sub.l	d3,d1
		bcs.s	loc_1B5B0
		addq.w	#1,d2
		bra.s	loc_1B5A8
; ===========================================================================

loc_1B5B0:				; CODE XREF: HUD_TimeRingBonus+12j
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1B5BA
		move.w	#1,d4

loc_1B5BA:				; CODE XREF: HUD_TimeRingBonus+1Cj
		tst.w	d4
		beq.s	loc_1B5EA
		lsl.w	#6,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_1B5E4:				; CODE XREF: HUD_TimeRingBonus+5Ej
		dbf	d6,loc_1B5A4
		rts
; ===========================================================================

loc_1B5EA:				; CODE XREF: HUD_TimeRingBonus+24j
		moveq	#$F,d5

loc_1B5EC:				; CODE XREF: HUD_TimeRingBonus+5Aj
		move.l	#0,(a6)
		dbf	d5,loc_1B5EC
		bra.s	loc_1B5E4
; End of function HUD_TimeRingBonus


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HUD_Lives:				; CODE XREF: HudUpdate+AEp
					; HudUpdate+130p ...
		move.l	#$7BA00003,d0
		moveq	#0,d1
		move.b	(Life_count).w,d1
		lea	HUD_10(pc),a2
		moveq	#1,d6
		moveq	#0,d4
		lea	Art_LivesNums(pc),a1

loc_1B610:				; CODE XREF: HUD_Lives+52j
		move.l	d0,4(a6)
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1B618:				; CODE XREF: HUD_Lives+26j
		sub.l	d3,d1
		bcs.s	loc_1B620
		addq.w	#1,d2
		bra.s	loc_1B618
; ===========================================================================

loc_1B620:				; CODE XREF: HUD_Lives+22j
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1B62A
		move.w	#1,d4

loc_1B62A:				; CODE XREF: HUD_Lives+2Cj
		tst.w	d4
		beq.s	loc_1B650

loc_1B62E:				; CODE XREF: HUD_Lives+5Aj
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_1B644:				; CODE XREF: HUD_Lives+68j
		addi.l	#$400000,d0
		dbf	d6,loc_1B610
		rts
; ===========================================================================

loc_1B650:				; CODE XREF: HUD_Lives+34j
		tst.w	d6
		beq.s	loc_1B62E
		moveq	#7,d5

loc_1B656:				; CODE XREF: HUD_Lives+64j
		move.l	#0,(a6)
		dbf	d5,loc_1B656
		bra.s	loc_1B644
; End of function HUD_Lives

; ===========================================================================
Art_HUD:	incbin	"art/uncompressed/Big and small numbers used on counters - 1.bin"
		even
Art_LivesNums:	incbin	"art/uncompressed/Big and small numbers used on counters - 2.bin"
		even
; ===========================================================================
		nop