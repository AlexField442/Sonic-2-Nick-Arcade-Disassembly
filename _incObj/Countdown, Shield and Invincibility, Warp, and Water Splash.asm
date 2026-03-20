;----------------------------------------------------
; Object 0A - drowning bubbles and countdown numbers
;----------------------------------------------------

Obj0A:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj0A_Index(pc,d0.w),d1
		jmp	Obj0A_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj0A_Index:	dc.w Obj0A_Init-Obj0A_Index ; DATA XREF: ROM:Obj0A_Indexo
					; ROM:00011E74o ...
		dc.w Obj0A_Animate-Obj0A_Index
		dc.w Obj0A_ChkWater-Obj0A_Index
		dc.w Obj0A_Display-Obj0A_Index
		dc.w Obj0A_Delete-Obj0A_Index
		dc.w Obj0A_Countdown-Obj0A_Index
		dc.w Obj0A_AirLeft-Obj0A_Index
		dc.w Obj0A_Display-Obj0A_Index
		dc.w Obj0A_Delete-Obj0A_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj0A_Init:				; DATA XREF: ROM:Obj0A_Indexo
		addq.b	#2,routine(a0)
		move.l	#Map_Obj0A_Bubbles,mappings(a0)
		move.w	#$8348,art_tile(a0)
		move.b	#$84,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#1,priority(a0)
		move.b	$28(a0),d0
		bpl.s	loc_11ECC
		addq.b	#8,routine(a0)
		move.l	#Map_Obj0A_Countdown,mappings(a0)
		move.w	#$440,art_tile(a0)
		andi.w	#$7F,d0	; ''
		move.b	d0,$33(a0)
		bra.w	Obj0A_Countdown
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11ECC:				; CODE XREF: ROM:00011EACj
		move.b	d0,anim(a0)
		bsr.w	Adjust2PArtPointer
		move.w	x_pos(a0),$30(a0)
		move.w	#$FF78,y_vel(a0)

Obj0A_Animate:				; DATA XREF: ROM:00011E74o
		lea	(Ani_Obj0A).l,a1
		jsr	(AnimateSprite).l

Obj0A_ChkWater:				; DATA XREF: ROM:00011E76o
		move.w	($FFFFF646).w,d0
		cmp.w	y_pos(a0),d0
		bcs.s	loc_11F0A
		move.b	#6,routine(a0)
		addq.b	#7,anim(a0)
		cmpi.b	#$D,anim(a0)
		beq.s	Obj0A_Display
		bra.s	Obj0A_Display
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11F0A:				; CODE XREF: ROM:00011EF4j
		tst.b	($FFFFF7C7).w
		beq.s	loc_11F14
		addq.w	#4,$30(a0)

loc_11F14:				; CODE XREF: ROM:00011F0Ej
		move.b	angle(a0),d0
		addq.b	#1,angle(a0)
		andi.w	#$7F,d0	; ''
		lea	(Obj0A_WobbleData).l,a1
		move.b	(a1,d0.w),d0
		ext.w	d0
		add.w	$30(a0),d0
		move.w	d0,x_pos(a0)
		bsr.s	Obj0A_ShowNumber
		jsr	(ObjectMove).l
		tst.b	render_flags(a0)
		bpl.s	loc_11F48
		jmp	(DisplaySprite).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11F48:				; CODE XREF: ROM:00011F40j
		jmp	(DeleteObject).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj0A_Display:				; CODE XREF: ROM:00011F06j
					; ROM:00011F08j ...
		bsr.s	Obj0A_ShowNumber
		lea	(Ani_Obj0A).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj0A_Delete:				; DATA XREF: ROM:00011E7Ao
					; ROM:00011E82o
		jmp	(DeleteObject).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj0A_AirLeft:				; DATA XREF: ROM:00011E7Eo
		cmpi.w	#$C,($FFFFFE14).w
		bhi.s	loc_11F9A
		subq.w	#1,$38(a0)
		bne.s	loc_11F82
		move.b	#$E,routine(a0)
		addq.b	#7,anim(a0)
		bra.s	Obj0A_Display
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11F82:				; CODE XREF: ROM:00011F74j
		lea	(Ani_Obj0A).l,a1
		jsr	(AnimateSprite).l
		tst.b	render_flags(a0)
		bpl.s	loc_11F9A
		jmp	(DisplaySprite).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_11F9A:				; CODE XREF: ROM:00011F6Ej
					; ROM:00011F92j
		jmp	(DeleteObject).l

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Obj0A_ShowNumber:			; CODE XREF: ROM:00011F34p
					; ROM:Obj0A_Displayp
		tst.w	$38(a0)
		beq.s	locret_11FEA
		subq.w	#1,$38(a0)
		bne.s	locret_11FEA
		cmpi.b	#7,anim(a0)
		bcc.s	locret_11FEA
		move.w	#$F,$38(a0)
		clr.w	y_vel(a0)
		move.b	#$80,render_flags(a0)
		move.w	x_pos(a0),d0
		sub.w	(Camera_X_pos).w,d0
		addi.w	#$80,d0	; '€'
		move.w	d0,x_pos(a0)
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0	; '€'
		move.w	d0,x_sub(a0)
		move.b	#$C,routine(a0)

locret_11FEA:				; CODE XREF: Obj0A_ShowNumber+4j
					; Obj0A_ShowNumber+Aj ...
		rts
; End of function Obj0A_ShowNumber

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj0A_WobbleData:dc.b	 0,   0,   0,	0,   0,	  0,   1,   1,	 1,   1,   1,	2,   2,	  2,   2,   2; 0
					; DATA XREF: ROM:00005E84o
					; ROM:00011F20o ...
		dc.b	2,   2,	  3,   3,   3,	 3,   3,   3,	3,   3,	  3,   3,   3,	 3,   3,   3; 16
		dc.b	3,   3,	  3,   3,   3,	 3,   3,   3,	3,   3,	  3,   3,   3,	 3,   3,   2; 32
		dc.b	2,   2,	  2,   2,   2,	 2,   1,   1,	1,   1,	  1,   0,   0,	 0,   0,   0; 48
		dc.b	0,  -1,	 -1,  -1,  -1,	-1,  -2,  -2,  -2,  -2,	 -2,  -3,  -3,	-3,  -3,  -3; 64
		dc.b   -3,  -3,	 -4,  -4,  -4,	-4,  -4,  -4,  -4,  -4,	 -4,  -4,  -4,	-4,  -4,  -4; 80
		dc.b   -4,  -4,	 -4,  -4,  -4,	-4,  -4,  -4,  -4,  -4,	 -4,  -4,  -4,	-4,  -4,  -3; 96
		dc.b   -3,  -3,	 -3,  -3,  -3,	-3,  -2,  -2,  -2,  -2,	 -2,  -1,  -1,	-1,  -1,  -1; 112
		dc.b	0,   0,	  0,   0,   0,	 0,   1,   1,	1,   1,	  1,   2,   2,	 2,   2,   2; 128
		dc.b	2,   2,	  3,   3,   3,	 3,   3,   3,	3,   3,	  3,   3,   3,	 3,   3,   3; 144
		dc.b	3,   3,	  3,   3,   3,	 3,   3,   3,	3,   3,	  3,   3,   3,	 3,   3,   2; 160
		dc.b	2,   2,	  2,   2,   2,	 2,   1,   1,	1,   1,	  1,   0,   0,	 0,   0,   0; 176
		dc.b	0,  -1,	 -1,  -1,  -1,	-1,  -2,  -2,  -2,  -2,	 -2,  -3,  -3,	-3,  -3,  -3; 192
		dc.b   -3,  -3,	 -4,  -4,  -4,	-4,  -4,  -4,  -4,  -4,	 -4,  -4,  -4,	-4,  -4,  -4; 208
		dc.b   -4,  -4,	 -4,  -4,  -4,	-4,  -4,  -4,  -4,  -4,	 -4,  -4,  -4,	-4,  -4,  -3; 224
		dc.b   -3,  -3,	 -3,  -3,  -3,	-3,  -2,  -2,  -2,  -2,	 -2,  -1,  -1,	-1,  -1,  -1; 240
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj0A_Countdown:			; CODE XREF: ROM:00011EC8j
					; DATA XREF: ROM:00011E7Co
		tst.w	$2C(a0)
		bne.w	loc_121D6
		cmpi.b	#6,(MainCharacter+routine).w
		bcc.w	locret_122DC
		btst	#6,(MainCharacter+status).w
		beq.w	locret_122DC
		subq.w	#1,$38(a0)
		bpl.w	loc_121FC
		move.w	#$3B,$38(a0) ; ';'
		move.w	#1,$36(a0)
		jsr	(RandomNumber).l
		andi.w	#1,d0
		move.b	d0,$34(a0)
		move.w	($FFFFFE14).w,d0
		cmpi.w	#$19,d0
		beq.s	loc_12166
		cmpi.w	#$14,d0
		beq.s	loc_12166
		cmpi.w	#$F,d0
		beq.s	loc_12166
		cmpi.w	#$C,d0
		bhi.s	loc_12170
		bne.s	loc_12152
		move.w	#$92,d0	; '’'
		jsr	(PlaySound).l

loc_12152:				; CODE XREF: ROM:00012146j
		subq.b	#1,$32(a0)
		bpl.s	loc_12170
		move.b	$33(a0),$32(a0)
		bset	#7,$36(a0)
		bra.s	loc_12170
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12166:				; CODE XREF: ROM:00012132j
					; ROM:00012138j ...
		move.w	#$C2,d0	; 'Â'
		jsr	(PlaySound_Special).l

loc_12170:				; CODE XREF: ROM:00012144j
					; ROM:00012156j ...
		subq.w	#1,($FFFFFE14).w
		bcc.w	loc_121FA
		bsr.w	ResumeMusic
		move.b	#$81,($FFFFF7C8).w
		move.w	#$B2,d0	; '²'
		jsr	(PlaySound_Special).l
		move.b	#$A,$34(a0)
		move.w	#1,$36(a0)
		move.w	#$78,$2C(a0) ; 'x'
		move.l	a0,-(sp)
		lea	(MainCharacter).w,a0
		bsr.w	Sonic_ResetOnFloor
		move.b	#$17,anim(a0)
		bset	#1,status(a0)
		bset	#7,art_tile(a0)
		move.w	#0,y_vel(a0)
		move.w	#0,x_vel(a0)
		move.w	#0,inertia(a0)
		move.b	#1,($FFFFEEDC).w
		movea.l	(sp)+,a0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_121D6:				; CODE XREF: ROM:000120F0j
		subq.w	#1,$2C(a0)
		bne.s	loc_121E4
		move.b	#6,(MainCharacter+routine).w
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_121E4:				; CODE XREF: ROM:000121DAj
		move.l	a0,-(sp)
		lea	(MainCharacter).w,a0
		jsr	(ObjectMove).l
		addi.w	#$10,y_vel(a0)
		movea.l	(sp)+,a0
		bra.s	loc_121FC
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_121FA:				; CODE XREF: ROM:00012174j
		bra.s	loc_1220C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_121FC:				; CODE XREF: ROM:0001210Cj
					; ROM:000121F8j
		tst.w	$36(a0)
		beq.w	locret_122DC
		subq.w	#1,$3A(a0)
		bpl.w	locret_122DC

loc_1220C:				; CODE XREF: ROM:loc_121FAj
		jsr	(RandomNumber).l
		andi.w	#$F,d0
		move.w	d0,$3A(a0)
		jsr	(SingleObjLoad).l
		bne.w	locret_122DC
		move.b	#$A,id(a1)
		move.w	(MainCharacter+x_pos).w,x_pos(a1)
		moveq	#6,d0
		btst	#0,(MainCharacter+status).w
		beq.s	loc_12242
		neg.w	d0
		move.b	#$40,angle(a1) ; '@'

loc_12242:				; CODE XREF: ROM:00012238j
		add.w	d0,x_pos(a1)
		move.w	(MainCharacter+y_pos).w,y_pos(a1)
		move.b	#6,$28(a1)
		tst.w	$2C(a0)
		beq.w	loc_1228E
		andi.w	#7,$3A(a0)
		addi.w	#0,$3A(a0)
		move.w	(MainCharacter+y_pos).w,d0
		subi.w	#$C,d0
		move.w	d0,y_pos(a1)
		jsr	(RandomNumber).l
		move.b	d0,angle(a1)
		move.w	($FFFFFE04).w,d0
		andi.b	#3,d0
		bne.s	loc_122D2
		move.b	#$E,$28(a1)
		bra.s	loc_122D2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1228E:				; CODE XREF: ROM:00012256j
		btst	#7,$36(a0)
		beq.s	loc_122D2
		move.w	($FFFFFE14).w,d2
		lsr.w	#1,d2
		jsr	(RandomNumber).l
		andi.w	#3,d0
		bne.s	loc_122BA
		bset	#6,$36(a0)
		bne.s	loc_122D2
		move.b	d2,$28(a1)
		move.w	#$1C,$38(a1)

loc_122BA:				; CODE XREF: ROM:000122A6j
		tst.b	$34(a0)
		bne.s	loc_122D2
		bset	#6,$36(a0)
		bne.s	loc_122D2
		move.b	d2,$28(a1)
		move.w	#$1C,$38(a1)

loc_122D2:				; CODE XREF: ROM:00012284j
					; ROM:0001228Cj ...
		subq.b	#1,$34(a0)
		bpl.s	locret_122DC
		clr.w	$36(a0)

locret_122DC:				; CODE XREF: ROM:000120FAj
					; ROM:00012104j ...
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


ResumeMusic:				; CODE XREF: Sonic_Water+1Ap
					; Sonic_Water+62p ...
		cmpi.w	#$C,($FFFFFE14).w
		bhi.s	loc_12310
		move.w	#MusID_LZ,d0
		cmpi.w	#$103,(Current_ZoneAndAct).w
		bne.s	loc_122F6
		move.w	#MusID_HTZ,d0

loc_122F6:				; CODE XREF: ResumeMusic+12j
		tst.b	($FFFFFE2D).w
		beq.s	loc_12300
		move.w	#MusID_Invincible,d0

loc_12300:				; CODE XREF: ResumeMusic+1Cj
		tst.b	($FFFFF7AA).w
		beq.s	loc_1230A
		move.w	#MusID_Boss,d0

loc_1230A:				; CODE XREF: ResumeMusic+26j
		jsr	(PlaySound).l

loc_12310:				; CODE XREF: ResumeMusic+6j
		move.w	#$1E,($FFFFFE14).w
		clr.b	(Object_RAM+$340+$32).w
		rts
; End of function ResumeMusic

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Ani_Obj0A:	dc.w byte_1233A-Ani_Obj0A,byte_12343-Ani_Obj0A;	0
					; DATA XREF: ROM:Obj0A_Animateo
					; ROM:00011F50o ...
		dc.w byte_1234C-Ani_Obj0A,byte_12355-Ani_Obj0A;	2
		dc.w byte_1235E-Ani_Obj0A,byte_12367-Ani_Obj0A;	4
		dc.w byte_12370-Ani_Obj0A,byte_12375-Ani_Obj0A;	6
		dc.w byte_1237D-Ani_Obj0A,byte_12385-Ani_Obj0A;	8
		dc.w byte_1238D-Ani_Obj0A,byte_12395-Ani_Obj0A;	10
		dc.w byte_1239D-Ani_Obj0A,byte_123A5-Ani_Obj0A;	12
		dc.w byte_123A7-Ani_Obj0A; 14
byte_1233A:	dc.b   5,  0,  1,  2,  3,  4,  9, $D,$FC; 0 ; DATA XREF: ROM:Ani_Obj0Ao
byte_12343:	dc.b   5,  0,  1,  2,  3,  4, $C,$12,$FC; 0 ; DATA XREF: ROM:Ani_Obj0Ao
byte_1234C:	dc.b   5,  0,  1,  2,  3,  4, $C,$11,$FC; 0 ; DATA XREF: ROM:Ani_Obj0Ao
byte_12355:	dc.b   5,  0,  1,  2,  3,  4, $B,$10,$FC; 0 ; DATA XREF: ROM:Ani_Obj0Ao
byte_1235E:	dc.b   5,  0,  1,  2,  3,  4,  9, $F,$FC; 0 ; DATA XREF: ROM:Ani_Obj0Ao
byte_12367:	dc.b   5,  0,  1,  2,  3,  4, $A, $E,$FC; 0 ; DATA XREF: ROM:Ani_Obj0Ao
byte_12370:	dc.b  $E,  0,  1,  2,$FC; 0 ; DATA XREF: ROM:Ani_Obj0Ao
byte_12375:	dc.b   7,$16, $D,$16, $D,$16, $D,$FC; 0	; DATA XREF: ROM:Ani_Obj0Ao
byte_1237D:	dc.b   7,$16,$12,$16,$12,$16,$12,$FC; 0	; DATA XREF: ROM:Ani_Obj0Ao
byte_12385:	dc.b   7,$16,$11,$16,$11,$16,$11,$FC; 0	; DATA XREF: ROM:Ani_Obj0Ao
byte_1238D:	dc.b   7,$16,$10,$16,$10,$16,$10,$FC; 0	; DATA XREF: ROM:Ani_Obj0Ao
byte_12395:	dc.b   7,$16, $F,$16, $F,$16, $F,$FC; 0	; DATA XREF: ROM:Ani_Obj0Ao
byte_1239D:	dc.b   7,$16, $E,$16, $E,$16, $E,$FC; 0	; DATA XREF: ROM:Ani_Obj0Ao
byte_123A5:	dc.b  $E,$FC		; 0 ; DATA XREF: ROM:Ani_Obj0Ao
byte_123A7:	dc.b  $E,  1,  2,  3,  4,$FC,  0; 0 ; DATA XREF: ROM:Ani_Obj0Ao
Map_Obj0A_Countdown:dc.w word_123B0-Map_Obj0A_Countdown	; DATA XREF: ROM:00011EB2o
					; ROM:Map_Obj0A_Countdowno
word_123B0:	dc.w 1			; DATA XREF: ROM:Map_Obj0A_Countdowno
		dc.w $E80E,    0,    0,$FFF2; 0

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 38 - shield and invincibility stars
; ---------------------------------------------------------------------------

Obj38:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj38_Index(pc,d0.w),d1
		jmp	Obj38_Index(pc,d1.w)
; ===========================================================================
Obj38_Index:	dc.w Obj38_Init-Obj38_Index
		dc.w Obj38_Shield-Obj38_Index
		dc.w Obj38_Stars-Obj38_Index
; ===========================================================================

Obj38_Init:
		addq.b	#2,routine(a0)
		move.l	#Map_obj38,mappings(a0)
		move.b	#4,render_flags(a0)
		move.b	#1,priority(a0)
		move.b	#$18,width_pixels(a0)
		tst.b	anim(a0)	; is this the shield?
		bne.s	loc_1240C	; if not, branch
		move.w	#$4BE,art_tile(a0)
		cmpi.b	#3,(Current_Zone).w	; is this Emerald Hill Zone?
		bne.s	loc_12406		; if not, branch
		move.w	#$560,art_tile(a0)

loc_12406:
		bsr.w	Adjust2PArtPointer
		rts
; ===========================================================================

loc_1240C:
		addq.b	#2,routine(a0)
		move.l	#Map_Sonic,mappings(a0)
		move.w	#$4DE,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#2,priority(a0)
		rts
; ===========================================================================

Obj38_Shield:
		tst.b	($FFFFFE2D).w	; is Sonic invincible?
		bne.s	locret_1245A	; if yes, branch
		tst.b	($FFFFFE2C).w	; does Sonic have a shield?
		beq.s	Obj38_Delete	; if not, branch
		move.w	(MainCharacter+x_pos).w,x_pos(a0)
		move.w	(MainCharacter+y_pos).w,y_pos(a0)
		move.b	(MainCharacter+status).w,status(a0)
		lea	(Ani_obj38).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------

locret_1245A:
		rts
; ===========================================================================
; loc_1245C:
Obj38_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
; This code has some connection to Unused_RecordPos, as both use Tails'
; old position buffer for something

Obj38_Stars:
		tst.b	($FFFFFE2D).w	; is Sonic invincible?
		beq.s	Obj38_Delete2	; if not, branch
		move.w	($FFFFEEE0).w,d0
		move.b	anim(a0),d1
		subq.b	#1,d1
		move.b	#$3F,d1
		lsl.b	#2,d1
		addi.b	#4,d1
		sub.b	d1,d0
		lea	(Tails_Pos_Record_Buf_OLD).w,a1
		lea	(a1,d0.w),a1
		move.w	(a1)+,d0
		andi.w	#$3FFF,d0
		move.w	d0,x_pos(a0)
		move.w	(a1)+,d0
		andi.w	#$7FF,d0
		move.w	d0,y_pos(a0)
		move.b	(MainCharacter+status).w,status(a0)
		move.b	(MainCharacter+mapping_frame).w,mapping_frame(a0)
		move.b	(MainCharacter+render_flags).w,render_flags(a0)
		jmp	(DisplaySprite).l
; ===========================================================================
; loc_124B2:
Obj38_Delete2:
		jmp	(DeleteObject).l

; ===========================================================================
; ---------------------------------------------------------------------------
; Sonic	1 Object 4A - giant ring entry effect from prototype
; ---------------------------------------------------------------------------
; OST:
warp_vanishtime:	equ $30		; time for Sonic to vanish for
; ---------------------------------------------------------------------------

S1Obj4A:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	S1Obj4A_Index(pc,d0.w),d1
		jmp	S1Obj4A_Index(pc,d1.w)
; ===========================================================================
S1Obj4A_Index:	dc.w S1Obj4A_Init-S1Obj4A_Index
		dc.w S1Obj4A_RmvSonic-S1Obj4A_Index
		dc.w S1Obj4A_LoadSonic-S1Obj4A_Index
; ===========================================================================

S1Obj4A_Init:
		tst.l	(Plc_Buffer).w	; are the pattern load cues empty?
		beq.s	loc_124D4	; if yes, branch
		rts
; ---------------------------------------------------------------------------

loc_124D4:
		addq.b	#2,routine(a0)
		move.l	#Map_S1obj4A,mappings(a0)
		move.b	#4,render_flags(a0)
		move.b	#1,priority(a0)
		move.b	#$38,width_pixels(a0)
		move.w	#$541,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.w	#60*2,warp_vanishtime(a0)	; set vanishing time to 2 seconds

S1Obj4A_RmvSonic:
		move.w	(MainCharacter+x_pos).w,x_pos(a0)
		move.w	(MainCharacter+y_pos).w,y_pos(a0)
		move.b	(MainCharacter+status).w,status(a0)
		lea	(Ani_S1obj4A).l,a1
		jsr	(AnimateSprite).l
		cmpi.b	#2,mapping_frame(a0)
		bne.s	loc_1253E
		tst.b	(MainCharacter).w	; is this Sonic?
		beq.s	loc_1253E		; if not, branch
		move.b	#0,(MainCharacter).w	; set Sonic's object ID to 0
		move.w	#$A8,d0
		jsr	(PlaySound_Special).l	; play Special Stage entry sound effect

loc_1253E:
		jmp	(DisplaySprite).l
; ===========================================================================

S1Obj4A_LoadSonic:
		subq.w	#1,warp_vanishtime(a0)	; subtract 1 from vanishing time
		bne.s	locret_12556		; if there's any time left, branch
		move.b	#1,(MainCharacter).w	; set Sonic's object ID to 1
		jmp	(DeleteObject).l
; ---------------------------------------------------------------------------

locret_12556:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 08 - water splash
; ---------------------------------------------------------------------------

Obj08:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj08_Index(pc,d0.w),d1
		jmp	Obj08_Index(pc,d1.w)
; ===========================================================================
Obj08_Index:	dc.w Obj08_Init-Obj08_Index
		dc.w Obj08_Display-Obj08_Index
		dc.w Obj08_Delete-Obj08_Index
; ===========================================================================

Obj08_Init:
		addq.b	#2,routine(a0)
		move.l	#Map_obj08,mappings(a0)
		ori.b	#4,render_flags(a0)
		move.b	#1,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.w	#$4259,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.w	(MainCharacter+x_pos).w,x_pos(a0)

Obj08_Display:
		move.w	($FFFFF646).w,y_pos(a0)
		lea	(Ani_obj08).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================

Obj08_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
; animation script
Ani_obj38:	dc.w byte_125C2-Ani_obj38
		dc.w byte_125CE-Ani_obj38
		dc.w byte_125D4-Ani_obj38
		dc.w byte_125EE-Ani_obj38
		dc.w byte_12608-Ani_obj38
byte_125C2:	dc.b   0,  5,  0,  5,  1,  5,  2,  5,  3,  5,  4,$FF
byte_125CE:	dc.b   5,  4,  5,  6,  7,$FF
byte_125D4:	dc.b   0,  4,  4,  0,  4,  4,  0,  5,  5,  0,  5,  5,  0,  6,  6,  0
		dc.b   6,  6,  0,  7,  7,  0,  7,  7,  0,$FF
byte_125EE:	dc.b   0,  4,  4,  0,  4,  0,  0,  5,  5,  0,  5,  0,  0,  6,  6,  0
		dc.b   6,  0,  0,  7,  7,  0,  7,  0,  0,$FF
byte_12608:	dc.b   0,  4,  0,  0,  4,  0,  0,  5,  0,  0,  5,  0,  0,  6,  0,  0
		dc.b   6,  0,  0,  7,  0,  0,  7,  0,  0,$FF

; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
Map_obj38:	incbin	"mappings/sprite/obj38.bin"

; animation script
Ani_S1obj4A:	dc.w byte_1278C-Ani_S1obj4A
byte_1278C:	dc.b   5,  0,  1,  0,  1,  0,  7,  1,  7,  2,  7,  3,  7,  4,  7,  5
		dc.b   7,  6,  7,$FC

; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
Map_S1obj4A:	incbin	"mappings/sprite/obj4A_S1.bin"

; animation script
Ani_obj08:	dc.w byte_129C2-Ani_obj08
byte_129C2:	dc.b   4,  0,  1,  2,$FC,  0

; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
Map_obj08:	incbin	"mappings/sprite/obj08.bin"