; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
; leftover from	Sonic 1

S1SS_ShowLayout:
		bsr.w	sub_19CC2
		bsr.w	sub_19F02
		move.w	d5,-(sp)
		lea	(Level_Layout).w,a1
		move.b	(SS_rotation_angle).w,d0
		andi.b	#$FC,d0
		jsr	(CalcSine).l
		move.w	d0,d4
		move.w	d1,d5
		muls.w	#$18,d4
		muls.w	#$18,d5
		moveq	#0,d2
		move.w	(Camera_X_pos).w,d2
		divu.w	#$18,d2
		swap	d2
		neg.w	d2
		addi.w	#$FF4C,d2
		moveq	#0,d3
		move.w	(Camera_Y_pos).w,d3
		divu.w	#$18,d3
		swap	d3
		neg.w	d3
		addi.w	#$FF4C,d3
		move.w	#$F,d7

loc_19BD0:				; CODE XREF: S1SS_ShowLayout+8Ej
		movem.w	d0-d2,-(sp)
		movem.w	d0-d1,-(sp)
		neg.w	d0
		muls.w	d2,d1
		muls.w	d3,d0
		move.l	d0,d6
		add.l	d1,d6
		movem.w	(sp)+,d0-d1
		muls.w	d2,d0
		muls.w	d3,d1
		add.l	d0,d1
		move.l	d6,d2
		move.w	#$F,d6

loc_19BF2:				; CODE XREF: S1SS_ShowLayout+82j
		move.l	d2,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		move.l	d1,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		add.l	d5,d2
		add.l	d4,d1
		dbf	d6,loc_19BF2
		movem.w	(sp)+,d0-d2
		addi.w	#$18,d3
		dbf	d7,loc_19BD0
		move.w	(sp)+,d5
		lea	(Chunk_Table).l,a0
		moveq	#0,d0
		move.w	(Camera_Y_pos).w,d0
		divu.w	#$18,d0
		mulu.w	#$80,d0	; '€'
		adda.l	d0,a0
		moveq	#0,d0
		move.w	(Camera_X_pos).w,d0
		divu.w	#$18,d0
		adda.w	d0,a0
		lea	(Level_Layout).w,a4
		move.w	#$F,d7

loc_19C3E:				; CODE XREF: S1SS_ShowLayout+124j
		move.w	#$F,d6

loc_19C42:				; CODE XREF: S1SS_ShowLayout+11Cj
		moveq	#0,d0
		move.b	(a0)+,d0
		beq.s	loc_19C9A
		cmpi.b	#$4E,d0	; 'N'
		bhi.s	loc_19C9A
		move.w	(a4),d3
		addi.w	#$120,d3
		cmpi.w	#$70,d3	; 'p'
		bcs.s	loc_19C9A
		cmpi.w	#$1D0,d3
		bcc.s	loc_19C9A
		move.w	2(a4),d2
		addi.w	#$F0,d2	; 'ð'
		cmpi.w	#$70,d2	; 'p'
		bcs.s	loc_19C9A
		cmpi.w	#$170,d2
		bcc.s	loc_19C9A
		lea	(Chunk_Table+$4000).l,a5
		lsl.w	#3,d0
		lea	(a5,d0.w),a5
		movea.l	(a5)+,a1
		move.w	(a5)+,d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		movea.w	(a5)+,a3
		moveq	#0,d1
		move.b	(a1)+,d1
		subq.b	#1,d1
		bmi.s	loc_19C9A
		jsr	(loc_D1CE).l

loc_19C9A:				; CODE XREF: S1SS_ShowLayout+C6j
					; S1SS_ShowLayout+CCj ...
		addq.w	#4,a4
		dbf	d6,loc_19C42
		lea	$70(a0),a0
		dbf	d7,loc_19C3E
		move.b	d5,(Sprite_count).w
		cmpi.b	#$50,d5	; 'P'
		beq.s	loc_19CBA
		move.l	#0,(a2)
		rts
; ===========================================================================

loc_19CBA:				; CODE XREF: S1SS_ShowLayout+130j
		move.b	#0,-5(a2)
		rts
; End of function S1SS_ShowLayout


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_19CC2:				; CODE XREF: S1SS_ShowLayoutp
		lea	(Chunk_Table+$400C).l,a1
		moveq	#0,d0
		move.b	(SS_rotation_angle).w,d0
		lsr.b	#2,d0
		andi.w	#$F,d0
		moveq	#$23,d1	; '#'

loc_19CD6:				; CODE XREF: sub_19CC2+18j
		move.w	d0,(a1)
		addq.w	#8,a1
		dbf	d1,loc_19CD6
		lea	(Chunk_Table+$4005).l,a1
		subq.b	#1,(Rings_anim_counter).w
		bpl.s	loc_19CFA
		move.b	#7,(Rings_anim_counter).w
		addq.b	#1,(Rings_anim_frame).w
		andi.b	#3,(Rings_anim_frame).w

loc_19CFA:				; CODE XREF: sub_19CC2+26j
		move.b	(Rings_anim_frame).w,$1D0(a1)
		subq.b	#1,(Unknown_anim_counter).w
		bpl.s	loc_19D16
		move.b	#7,(Unknown_anim_counter).w
		addq.b	#1,(Unknown_anim_frame).w
		andi.b	#1,(Unknown_anim_frame).w

loc_19D16:				; CODE XREF: sub_19CC2+42j
		move.b	(Unknown_anim_frame).w,d0
		move.b	d0,$138(a1)

loc_19D1E:
		move.b	d0,$160(a1)
		move.b	d0,$148(a1)
		move.b	d0,$150(a1)
		move.b	d0,$1D8(a1)
		move.b	d0,$1E0(a1)
		move.b	d0,$1E8(a1)
		move.b	d0,$1F0(a1)
		move.b	d0,$1F8(a1)
		move.b	d0,$200(a1)
		subq.b	#1,(Ring_spill_anim_counter).w
		bpl.s	loc_19D58
		move.b	#4,(Ring_spill_anim_counter).w
		addq.b	#1,(Ring_spill_anim_frame).w
		andi.b	#3,(Ring_spill_anim_frame).w

loc_19D58:				; CODE XREF: sub_19CC2+84j
		move.b	(Ring_spill_anim_frame).w,d0
		move.b	d0,$168(a1)
		move.b	d0,$170(a1)
		move.b	d0,$178(a1)
		move.b	d0,$180(a1)
		subq.b	#1,(Logspike_anim_counter).w
		bpl.s	loc_19D82
		move.b	#7,(Logspike_anim_counter).w
		subq.b	#1,(Logspike_anim_frame).w
		andi.b	#7,(Logspike_anim_frame).w

loc_19D82:				; CODE XREF: sub_19CC2+AEj
		lea	(Chunk_Table+$4016).l,a1
		lea	(S1SS_WaRiVramSet).l,a0
		moveq	#0,d0
		move.b	(Logspike_anim_frame).w,d0
		add.w	d0,d0
		lea	(a0,d0.w),a0
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		move.w	8(a0),$20(a1)
		move.w	$A(a0),$28(a1)
		move.w	$C(a0),$30(a1)
		move.w	$E(a0),$38(a1)
		adda.w	#$20,a0	; ' '
		adda.w	#$48,a1	; 'H'
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		move.w	8(a0),$20(a1)
		move.w	$A(a0),$28(a1)
		move.w	$C(a0),$30(a1)
		move.w	$E(a0),$38(a1)
		adda.w	#$20,a0	; ' '
		adda.w	#$48,a1	; 'H'
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		move.w	8(a0),$20(a1)
		move.w	$A(a0),$28(a1)
		move.w	$C(a0),$30(a1)
		move.w	$E(a0),$38(a1)
		adda.w	#$20,a0	; ' '
		adda.w	#$48,a1	; 'H'
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		move.w	8(a0),$20(a1)
		move.w	$A(a0),$28(a1)
		move.w	$C(a0),$30(a1)
		move.w	$E(a0),$38(a1)
		adda.w	#$20,a0	; ' '
		adda.w	#$48,a1	; 'H'
		rts
; End of function sub_19CC2

; ===========================================================================
S1SS_WaRiVramSet:dc.w  $142,$6142, $142, $142, $142, $142, $142,$6142; 0
					; DATA XREF: sub_19CC2+C6o
		dc.w  $142,$6142, $142,	$142, $142, $142, $142,$6142; 8
		dc.w $2142, $142,$2142,$2142,$2142,$2142,$2142,	$142; 16
		dc.w $2142, $142,$2142,$2142,$2142,$2142,$2142,	$142; 24
		dc.w $4142,$2142,$4142,$4142,$4142,$4142,$4142,$2142; 32
		dc.w $4142,$2142,$4142,$4142,$4142,$4142,$4142,$2142; 40
		dc.w $6142,$4142,$6142,$6142,$6142,$6142,$6142,$4142; 48
		dc.w $6142,$4142,$6142,$6142,$6142,$6142,$6142,$4142; 56

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_19EEC:				; CODE XREF: Obj09_ChkItems+40p
					; Obj09_ChkItems+7Cp ...
		lea	(Chunk_Table+$4400).l,a2
		move.w	#$1F,d0

loc_19EF6:				; CODE XREF: sub_19EEC+10j
		tst.b	(a2)
		beq.s	locret_19F00
		addq.w	#8,a2
		dbf	d0,loc_19EF6

locret_19F00:				; CODE XREF: sub_19EEC+Cj
		rts
; End of function sub_19EEC


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_19F02:				; CODE XREF: S1SS_ShowLayout+4p
		lea	(Chunk_Table+$4400).l,a0
		move.w	#$1F,d7

loc_19F0C:				; CODE XREF: sub_19F02:loc_19F1Cj
		moveq	#0,d0
		move.b	(a0),d0
		beq.s	loc_19F1A
		lsl.w	#2,d0
		movea.l	S1SS_AniIndex-4(pc,d0.w),a1
		jsr	(a1)

loc_19F1A:				; CODE XREF: sub_19F02+Ej
		addq.w	#8,a0

loc_19F1C:
		dbf	d7,loc_19F0C
		rts
; End of function sub_19F02

; ===========================================================================
S1SS_AniIndex:	dc.l loc_19F3A		; DATA XREF: sub_19F02+12t
		dc.l loc_19F6A
		dc.l loc_19FA0
		dc.l loc_19FD0
		dc.l loc_1A006
		dc.l loc_1A046
; ===========================================================================

loc_19F3A:				; DATA XREF: ROM:S1SS_AniIndexo
		subq.b	#1,2(a0)
		bpl.s	locret_19F62
		move.b	#5,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	byte_19F64(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_19F62
		clr.l	(a0)
		clr.l	4(a0)

locret_19F62:				; CODE XREF: ROM:00019F3Ej
					; ROM:00019F5Aj
		rts
; ===========================================================================
byte_19F64:	dc.b $42,$43,$44,$45,  0,  0; 0
; ===========================================================================

loc_19F6A:				; DATA XREF: ROM:00019F26o
		subq.b	#1,2(a0)
		bpl.s	locret_19F98
		move.b	#7,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	byte_19F9A(pc,d0.w),d0
		bne.s	loc_19F96
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#$25,(a1) ; '%'
		rts
; ===========================================================================

loc_19F96:				; CODE XREF: ROM:00019F88j
		move.b	d0,(a1)

locret_19F98:				; CODE XREF: ROM:00019F6Ej
		rts
; ===========================================================================
byte_19F9A:	dc.b $32,$33,$32,$33,  0,  0; 0
; ===========================================================================

loc_19FA0:				; DATA XREF: ROM:00019F2Ao
		subq.b	#1,2(a0)
		bpl.s	locret_19FC8
		move.b	#5,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	byte_19FCA(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_19FC8
		clr.l	(a0)
		clr.l	4(a0)

locret_19FC8:				; CODE XREF: ROM:00019FA4j
					; ROM:00019FC0j
		rts
; ===========================================================================
byte_19FCA:	dc.b $46,$47,$48,$49,  0,  0; 0
; ===========================================================================

loc_19FD0:				; DATA XREF: ROM:00019F2Eo
		subq.b	#1,2(a0)
		bpl.s	locret_19FFE
		move.b	#7,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	byte_1A000(pc,d0.w),d0
		bne.s	loc_19FFC
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#$2B,(a1) ; '+'
		rts
; ===========================================================================

loc_19FFC:				; CODE XREF: ROM:00019FEEj
		move.b	d0,(a1)

locret_19FFE:				; CODE XREF: ROM:00019FD4j
		rts
; ===========================================================================
byte_1A000:	dc.b $2B,$31,$2B,$31,  0,  0; 0
; ===========================================================================

loc_1A006:				; DATA XREF: ROM:00019F32o
		subq.b	#1,2(a0)
		bpl.s	locret_1A03E
		move.b	#5,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	byte_1A040(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_1A03E
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#4,(MainCharacter+routine).w
		move.w	#SndID_SSGoal,d0	; '¨'
		jsr	(PlaySound).l

locret_1A03E:				; CODE XREF: ROM:0001A00Aj
					; ROM:0001A026j
		rts
; ===========================================================================
byte_1A040:	dc.b $46,$47,$48,$49,  0,  0; 0
; ===========================================================================

loc_1A046:				; DATA XREF: ROM:00019F36o
		subq.b	#1,2(a0)
		bpl.s	locret_1A072
		move.b	#1,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	byte_1A074(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_1A072
		move.b	4(a0),(a1)
		clr.l	(a0)
		clr.l	4(a0)

locret_1A072:				; CODE XREF: ROM:0001A04Aj
					; ROM:0001A066j
		rts
; ===========================================================================
byte_1A074:	dc.b $4B,$4C,$4D,$4E,$4B,$4C,$4D,$4E; 0
		dc.b   0,  0		; 8
S1SS_LayoutIndex:dc.l S1SS_1,S1SS_2	 ; 0
		dc.l S1SS_3,S1SS_4	; 2
		dc.l S1SS_5,S1SS_6	; 4
S1SS_StartLoc:	dc.w  $3D0, $2E0	; 0
		dc.w  $328, $574	; 2
		dc.w  $4E4, $2E0	; 4
		dc.w  $3AD, $2E0	; 6
		dc.w  $340, $6B8	; 8
		dc.w  $49B, $358	; 10

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


S1SS_Load:				; CODE XREF: ROM:000050E0p
					; S1SS_Load+34j
		moveq	#0,d0
		move.b	(Current_SpecialStage).w,d0
		addq.b	#1,(Current_SpecialStage).w
		cmpi.b	#6,(Current_SpecialStage).w
		bcs.s	loc_1A0C6
		move.b	#0,(Current_SpecialStage).w

loc_1A0C6:				; CODE XREF: S1SS_Load+10j
		cmpi.b	#6,(Emerald_count).w
		beq.s	loc_1A0E8
		moveq	#0,d1
		move.b	(Emerald_count).w,d1
		subq.b	#1,d1
		bcs.s	loc_1A0E8
		lea	(Emeralds_array).w,a3

loc_1A0DC:				; CODE XREF: S1SS_Load:loc_1A0E4j
		cmp.b	(a3,d1.w),d0
		bne.s	loc_1A0E4
		bra.s	S1SS_Load
; ===========================================================================

loc_1A0E4:				; CODE XREF: S1SS_Load+32j
		dbf	d1,loc_1A0DC

loc_1A0E8:				; CODE XREF: S1SS_Load+1Ej
					; S1SS_Load+28j
		lsl.w	#2,d0
		lea	S1SS_StartLoc(pc,d0.w),a1
		move.w	(a1)+,(MainCharacter+x_pos).w
		move.w	(a1)+,(MainCharacter+y_pos).w
		movea.l	S1SS_LayoutIndex(pc,d0.w),a0
		lea	(Chunk_Table+$4000).l,a1
		move.w	#0,d0
		jsr	(EniDec).l
		lea	(Chunk_Table).l,a1
		move.w	#$FFF,d0

loc_1A114:				; CODE XREF: S1SS_Load+68j
		clr.l	(a1)+
		dbf	d0,loc_1A114
		lea	(Chunk_Table+$1020).l,a1
		lea	(Chunk_Table+$4000).l,a0
		moveq	#$3F,d1	; '?'

loc_1A128:				; CODE XREF: S1SS_Load+86j
		moveq	#$3F,d2	; '?'

loc_1A12A:				; CODE XREF: S1SS_Load+7Ej
		move.b	(a0)+,(a1)+
		dbf	d2,loc_1A12A
		lea	$40(a1),a1
		dbf	d1,loc_1A128
		lea	(Chunk_Table+$4008).l,a1
		lea	(S1SS_MapIndex).l,a0
		moveq	#$4D,d1	; 'M'

loc_1A146:				; CODE XREF: S1SS_Load+A6j
		move.l	(a0)+,(a1)+
		move.w	#0,(a1)+
		move.b	-4(a0),-1(a1)
		move.w	(a0)+,(a1)+
		dbf	d1,loc_1A146
		lea	(Chunk_Table+$4400).l,a1
		move.w	#$3F,d1	; '?'

loc_1A162:				; CODE XREF: S1SS_Load+B6j
		clr.l	(a1)+
		dbf	d1,loc_1A162
		rts
; End of function S1SS_Load

; ===========================================================================
S1SS_MapIndex:	dc.l S1Map_SS_R		; DATA XREF: S1SS_Load+90o
		dc.w $142
		dc.l S1Map_SS_R
		dc.w $142
		dc.l S1Map_SS_R
		dc.w $142
		dc.l S1Map_SS_R
		dc.w $142
		dc.l S1Map_SS_R
		dc.w $142
		dc.l S1Map_SS_R
		dc.w $142
		dc.l S1Map_SS_R
		dc.w $142
		dc.l S1Map_SS_R
		dc.w $142
		dc.l S1Map_SS_R
		dc.w $142
		dc.l S1Map_SS_R
		dc.w $2142
		dc.l S1Map_SS_R
		dc.w $2142
		dc.l S1Map_SS_R
		dc.w $2142
		dc.l S1Map_SS_R
		dc.w $2142
		dc.l S1Map_SS_R
		dc.w $2142
		dc.l S1Map_SS_R
		dc.w $2142
		dc.l S1Map_SS_R
		dc.w $2142
		dc.l S1Map_SS_R
		dc.w $2142
		dc.l S1Map_SS_R
		dc.w $2142
		dc.l S1Map_SS_R
		dc.w $4142
		dc.l S1Map_SS_R
		dc.w $4142
		dc.l S1Map_SS_R
		dc.w $4142
		dc.l S1Map_SS_R
		dc.w $4142
		dc.l S1Map_SS_R
		dc.w $4142
		dc.l S1Map_SS_R
		dc.w $4142
		dc.l S1Map_SS_R
		dc.w $4142
		dc.l S1Map_SS_R
		dc.w $4142
		dc.l S1Map_SS_R
		dc.w $4142
		dc.l S1Map_SS_R
		dc.w $6142
		dc.l S1Map_SS_R
		dc.w $6142
		dc.l S1Map_SS_R
		dc.w $6142
		dc.l S1Map_SS_R
		dc.w $6142
		dc.l S1Map_SS_R
		dc.w $6142
		dc.l S1Map_SS_R
		dc.w $6142
		dc.l S1Map_SS_R
		dc.w $6142
		dc.l S1Map_SS_R
		dc.w $6142
		dc.l S1Map_SS_R
		dc.w $6142
		dc.l MapUnc_Bumper
		dc.w $23B
		dc.l S1Map_SS_R
		dc.w $570
		dc.l S1Map_SS_R
		dc.w $251
		dc.l S1Map_SS_R
		dc.w $370
		dc.l S1Map_SS_Up
		dc.w $263
		dc.l S1Map_SS_Down
		dc.w $263
		dc.l S1Map_SS_R
		dc.w $22F0
		dc.l S1Map_SS_Glass
		dc.w $470
		dc.l S1Map_SS_Glass
		dc.w $5F0
		dc.l S1Map_SS_Glass
		dc.w $65F0
		dc.l S1Map_SS_Glass
		dc.w $25F0
		dc.l S1Map_SS_Glass
		dc.w $45F0
		dc.l S1Map_SS_R
		dc.w $2F0
		dc.l MapUnc_Bumper+$1000000
		dc.w $23B
		dc.l MapUnc_Bumper+$2000000
		dc.w $23B
		dc.l S1Map_SS_R
		dc.w $797
		dc.l S1Map_SS_R
		dc.w $7A0
		dc.l S1Map_SS_R
		dc.w $7A9
		dc.l S1Map_SS_R
		dc.w $797
		dc.l S1Map_SS_R
		dc.w $7A0
		dc.l S1Map_SS_R
		dc.w $7A9
		dc.l MapUnc_Ring
		dc.w $27B2
		dc.l S1Map_SS_Chaos3
		dc.w $770
		dc.l S1Map_SS_Chaos3
		dc.w $2770
		dc.l S1Map_SS_Chaos3
		dc.w $4770
		dc.l S1Map_SS_Chaos3
		dc.w $6770
		dc.l S1Map_SS_Chaos1
		dc.w $770
		dc.l S1Map_SS_Chaos2
		dc.w $770
		dc.l S1Map_SS_R
		dc.w $4F0
		dc.l MapUnc_Ring+$4000000
		dc.w $27B2
		dc.l MapUnc_Ring+$5000000
		dc.w $27B2
		dc.l MapUnc_Ring+$6000000
		dc.w $27B2
		dc.l MapUnc_Ring+$7000000
		dc.w $27B2
		dc.l S1Map_SS_Glass
		dc.w $23F0
		dc.l S1Map_SS_Glass+$1000000
		dc.w $23F0
		dc.l S1Map_SS_Glass+$2000000
		dc.w $23F0
		dc.l S1Map_SS_Glass+$3000000
		dc.w $23F0
		dc.l S1Map_SS_R+$2000000
		dc.w $4F0
		dc.l S1Map_SS_Glass
		dc.w $5F0
		dc.l S1Map_SS_Glass
		dc.w $65F0
		dc.l S1Map_SS_Glass
		dc.w $25F0
		dc.l S1Map_SS_Glass
		dc.w $45F0
; ===========================================================================
; Rather humourously, these sprite mappings are stored in the Sonic 1 format
; ---------------------------------------------------------------------------
; Sprite mappings - 'R'
; ---------------------------------------------------------------------------
S1Map_SS_R:	dc.w byte_1A344-S1Map_SS_R
		dc.w byte_1A34A-S1Map_SS_R
		dc.w word_1A350-S1Map_SS_R
byte_1A344:	dc.b 1
		dc.b $F4, $A,  0,  0,$F4
byte_1A34A:	dc.b 1
		dc.b $F4, $A,  0,  9,$F4
word_1A350:	dc.w 0
; ---------------------------------------------------------------------------
; Sprite mappings - Glass
; ---------------------------------------------------------------------------
S1Map_SS_Glass:	dc.w byte_1A35A-S1Map_SS_Glass
		dc.w byte_1A360-S1Map_SS_Glass
		dc.w byte_1A366-S1Map_SS_Glass
		dc.w byte_1A36C-S1Map_SS_Glass
byte_1A35A:	dc.b 1
		dc.b $F4, $A,  0,  0,$F4
byte_1A360:	dc.b 1
		dc.b $F4, $A,  8,  0,$F4
byte_1A366:	dc.b 1
		dc.b $F4, $A,$18,  0,$F4
byte_1A36C:	dc.b 1
		dc.b $F4, $A,$10,  0,$F4
; ---------------------------------------------------------------------------
; Sprite mappings - 'Up'
; ---------------------------------------------------------------------------
S1Map_SS_Up:	dc.w byte_1A376-S1Map_SS_Up
		dc.w byte_1A37C-S1Map_SS_Up
byte_1A376:	dc.b 1
		dc.b $F4, $A,  0,  0,$F4
byte_1A37C:	dc.b 1
		dc.b $F4, $A,  0,$12,$F4
; ---------------------------------------------------------------------------
; Sprite mappings - 'Down'
; ---------------------------------------------------------------------------
S1Map_SS_Down:	dc.w byte_1A386-S1Map_SS_Down
		dc.w byte_1A38C-S1Map_SS_Down
byte_1A386:	dc.b 1
		dc.b $F4, $A,  0,  9,$F4
byte_1A38C:	dc.b 1
		dc.b $F4, $A,  0,$12,$F4
; ---------------------------------------------------------------------------
; Sprite mappings - Chaos Emeralds
; Merged together; can't split to file in a useful way...
; ---------------------------------------------------------------------------
S1Map_SS_Chaos1:dc.w byte_1A39E-S1Map_SS_Chaos1
		dc.w byte_1A3B0-S1Map_SS_Chaos1
S1Map_SS_Chaos2:dc.w byte_1A3A4-S1Map_SS_Chaos2
		dc.w byte_1A3B0-S1Map_SS_Chaos2
S1Map_SS_Chaos3:dc.w byte_1A3AA-S1Map_SS_Chaos3
		dc.w byte_1A3B0-S1Map_SS_Chaos3
byte_1A39E:	dc.b 1
		dc.b $F8,  5,  0,  0,$F8
byte_1A3A4:	dc.b 1
		dc.b $F8,  5,  0,  4,$F8
byte_1A3AA:	dc.b 1
		dc.b $F8,  5,  0,  8,$F8
byte_1A3B0:	dc.b 1
		dc.b $F8,  5,  0, $C,$F8
; ===========================================================================
		nop