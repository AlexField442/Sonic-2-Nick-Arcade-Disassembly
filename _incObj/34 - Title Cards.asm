; ===========================================================================
; ---------------------------------------------------------------------------
; Object 34 - Sonic 1 title cards
;
; Internal name: "zone"
; ---------------------------------------------------------------------------
; OST:
titlecard_mainX:	equ $30		; position for title card to display on
titlecard_finalX:	equ $32		; position for title card to finish on
; ---------------------------------------------------------------------------
; Sprite_B8C8: Obj34:
Obj_TitleCard:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	TitleCard_Index(pc,d0.w),d1
		jmp	TitleCard_Index(pc,d1.w)
; ===========================================================================
; off_B8D6: Obj34_Index:
TitleCard_Index:	dc.w TitleCard_CheckSBZ3-TitleCard_Index
		dc.w TitleCard_CheckPos-TitleCard_Index
		dc.w TitleCard_Wait-TitleCard_Index
		dc.w TitleCard_Wait-TitleCard_Index
; ===========================================================================
; Obj34_CheckLZ4:
TitleCard_CheckSBZ3:
		movea.l	a0,a1
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		cmpi.w	#$103,(Current_ZoneAndAct).w	; is this Scrap Brain Zone 3?
		bne.s	TitleCard_CheckFZ		; if not, branch
		moveq	#5,d0				; load SCRAP BRAIN title card
; Obj34_CheckFZ:
TitleCard_CheckFZ:
		move.w	d0,d2
		cmpi.w	#$502,(Current_ZoneAndAct).w	; is this Final Zone?
		bne.s	TitleCard_LoadConfig		; if not, branch
		moveq	#6,d0				; load FINAL title card
		moveq	#$B,d2
; Obj34_CheckConfig:
TitleCard_LoadConfig:
		lea	(TitleCard_Config).l,a3
		lsl.w	#4,d0
		adda.w	d0,a3
		lea	(TitleCard_ItemData).l,a2
		moveq	#3,d1
; Obj34_Loop:
TitleCard_Loop:
		move.b	#$34,id(a1)		; load Obj_TitleCard
		move.w	(a3),x_pixel(a1)	; load start x-position
		move.w	(a3)+,titlecard_finalX(a1)	; load finish x-position (same as start)
		move.w	(a3)+,titlecard_mainX(a1)	; load main x-position
		move.w	(a2)+,y_pixel(a1)
		move.b	(a2)+,routine(a1)
		move.b	(a2)+,d0
		bne.s	TitleCard_ActNumber
		move.b	d2,d0
; Obj34_ActNumber:
TitleCard_ActNumber:
		cmpi.b	#7,d0
		bne.s	TitleCard_MakeSprite
		add.b	(Current_Act).w,d0
		cmpi.b	#3,(Current_Act).w		; is this "Act 4"?
		bne.s	TitleCard_MakeSprite		; if not, branch
		subq.b	#1,d0				; use Act 3 frame
; Obj34_MakeSprite:
TitleCard_MakeSprite:
		move.b	d0,mapping_frame(a1)
		move.l	#MapUnc_TitleCard,mappings(a1)
		move.w	#$8580,art_tile(a1)
		bsr.w	Adjust2PArtPointer2
		move.b	#$78,width_pixels(a1)
		move.b	#0,render_flags(a1)
		move.b	#0,priority(a1)
		move.w	#60,anim_frame_duration(a1)	; set time delay to 1 second
		lea	$40(a1),a1
		dbf	d1,TitleCard_Loop
; Obj34_CheckPos:
TitleCard_CheckPos:
		moveq	#$10,d1			; set horizontal speed
		move.w	titlecard_mainX(a0),d0
		cmp.w	x_pixel(a0),d0		; has item reached the target destination?
		beq.s	TitleCard_NoMove	; if yes, branch
		bge.s	TitleCard_Move
		neg.w	d1
; Obj34_Move:
TitleCard_Move:
		add.w	d1,x_pixel(a0)		; change item's position
; loc_B98E:
TitleCard_NoMove:
		move.w	x_pixel(a0),d0
		bmi.s	TitleCard_NoDisplay
		cmpi.w	#$200,d0		; has item moved beyond $200 on x-axis?
		bcc.s	TitleCard_NoDisplay	; if yes, branch
		rts
; ---------------------------------------------------------------------------
		bra.w	DisplaySprite
; ===========================================================================
; Obj34_NoDisplay:
TitleCard_NoDisplay:
		rts
; ===========================================================================
; Obj34_Wait:
TitleCard_Wait:
		tst.w	anim_frame_duration(a0)		; is time remaining zero?
		beq.s	TitleCard_CheckPos2		; if yes, branch
		subq.w	#1,anim_frame_duration(a0)	; subtract 1 from time
		rts
; ---------------------------------------------------------------------------
		bra.w	DisplaySprite
; ===========================================================================
; Obj34_CheckPos2:
TitleCard_CheckPos2:
		tst.b	render_flags(a0)
		bpl.s	TitleCard_ChangeArt
		moveq	#$20,d1
		move.w	titlecard_finalX(a0),d0
		cmp.w	x_pixel(a0),d0		; has item reached the finish position?
		beq.s	TitleCard_ChangeArt	; if yes, branch
		bge.s	TitleCard_Move2
		neg.w	d1
; Obj34_Move2:
TitleCard_Move2:
		add.w	d1,x_pixel(a0)		; change item's position
		move.w	x_pixel(a0),d0
		bmi.s	TitleCard_NoDisplay2
		cmpi.w	#$200,d0		; has item moved beyond $200 on x-axis?
		bcc.s	TitleCard_NoDisplay2	; if yes, branch
		rts
; ---------------------------------------------------------------------------
		bra.w	DisplaySprite
; ===========================================================================
; Obj34_NoDisplay2:
TitleCard_NoDisplay2:
		rts
; ===========================================================================
; Obj34_ChangeArt:
TitleCard_ChangeArt:
		cmpi.b	#4,routine(a0)
		bne.s	TitleCard_Delete
		moveq	#2,d0
		jsr	(LoadPLC).l	; load explosion patterns
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		addi.w	#$15,d0
		jsr	(LoadPLC).l	; load animal patterns
; Obj34_Delete:
TitleCard_Delete:
		bra.w	DeleteObject
; ===========================================================================
; Obj34_ItemData:
TitleCard_ItemData:
		dc.w $D0		; y-axis position
		dc.b   2,  0		; routine number, frame number (changes)
		dc.w $E4
		dc.b   2,  6
		dc.w $EA
		dc.b   2,  7
		dc.w $E0
		dc.b   2, $A
; ---------------------------------------------------------------------------
; Title card configuration data
; Format:
; 4 bytes per item (YYYY XXXX)
; 4 items per level (GREEN HILL, ZONE, ACT X, oval)
; ---------------------------------------------------------------------------
; Obj34_Config:
TitleCard_Config:
		dc.w	 0, $120,$FEFC,	$13C, $414, $154, $214,	$154
		dc.w	 0, $120,$FEF4,	$134, $40C, $14C, $20C,	$14C
		dc.w	 0, $120,$FEE0,	$120, $3F8, $138, $1F8,	$138
		dc.w	 0, $120,$FEFC,	$13C, $414, $154, $214,	$154
		dc.w	 0, $120,$FF04,	$144, $41C, $15C, $21C,	$15C
		dc.w	 0, $120,$FF04,	$144, $41C, $15C, $21C,	$15C
		dc.w	 0, $120,$FEE4,	$124, $3EC, $3EC, $1EC,	$12C