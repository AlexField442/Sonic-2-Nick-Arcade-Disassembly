; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


TouchResponse:
		nop
		bsr.w	JmpTo_Touch_Rings
		move.w	x_pos(a0),d2
		move.w	y_pos(a0),d3
		subi.w	#8,d2
		moveq	#0,d5
		move.b	y_radius(a0),d5
		subq.b	#3,d5
		sub.w	d5,d3
		cmpi.b	#$39,mapping_frame(a0) ; '9'
		bne.s	loc_19812
		addi.w	#$C,d3
		moveq	#$A,d5

loc_19812:				; CODE XREF: TouchResponse+22j
		move.w	#$10,d4
		add.w	d5,d5
		lea	(Object_RAM+$800).w,a1
		move.w	#$5F,d6	; '_'

loc_19820:				; CODE XREF: TouchResponse+42j
		move.b	collision_flags(a1),d0
		bne.s	Touch_Height

loc_19826:				; CODE XREF: TouchResponse+B0j
					; TouchResponse+B6j ...
		lea	$40(a1),a1
		dbf	d6,loc_19820
		moveq	#0,d0

locret_19830:
		rts
; ===========================================================================
Touch_Sizes:	dc.b $14,$14		; 0 ; DATA XREF: TouchResponse+98t
		dc.b  $C,$14		; 2
		dc.b $14, $C		; 4
		dc.b   4,$10		; 6
		dc.b  $C,$12		; 8
		dc.b $10,$10		; 10
		dc.b   6,  6		; 12
		dc.b $18, $C		; 14
		dc.b  $C,$10		; 16
		dc.b $10, $C		; 18
		dc.b   8,  8		; 20
		dc.b $14,$10		; 22
		dc.b $14,  8		; 24
		dc.b  $E, $E		; 26
		dc.b $18,$18		; 28
		dc.b $28,$10		; 30
		dc.b $10,$18		; 32
		dc.b   8,$10		; 34
		dc.b $20,$70		; 36
		dc.b $40,$20		; 38
		dc.b $80,$20		; 40
		dc.b $20,$20		; 42
		dc.b   8,  8		; 44
		dc.b   4,  4		; 46
		dc.b $20,  8		; 48
		dc.b  $C, $C		; 50
		dc.b   8,  4		; 52
		dc.b $18,  4		; 54
		dc.b $28,  4		; 56
		dc.b   4,  8		; 58
		dc.b   4,$18		; 60
		dc.b   4,$28		; 62
		dc.b   4,$20		; 64
		dc.b $18,$18		; 66
		dc.b  $C,$18		; 68
		dc.b $48,  8		; 70
; ===========================================================================

Touch_Height:				; CODE XREF: TouchResponse+3Cj
		andi.w	#$3F,d0	; '?'
		add.w	d0,d0
		lea	Touch_Sizes-2(pc,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	x_pos(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	loc_1989C
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_198A2
		bra.w	loc_19826
; ===========================================================================

loc_1989C:				; CODE XREF: TouchResponse+A8j
		cmp.w	d4,d0
		bhi.w	loc_19826

loc_198A2:				; CODE XREF: TouchResponse+AEj
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	y_pos(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	loc_198BA
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_198C0
		bra.w	loc_19826
; ===========================================================================

loc_198BA:				; CODE XREF: TouchResponse+C6j
		cmp.w	d5,d0
		bhi.w	loc_19826

loc_198C0:				; CODE XREF: TouchResponse+CCj
		move.b	collision_flags(a1),d1
		andi.b	#$C0,d1
		beq.w	loc_1993A
		cmpi.b	#$C0,d1
		beq.w	Touch_Special
		tst.b	d1
		bmi.w	loc_199F2
		move.b	collision_flags(a1),d0
		andi.b	#$3F,d0	; '?'
		cmpi.b	#6,d0
		beq.s	loc_198FA
		cmpi.w	#$5A,invulnerable_time(a0) ; 'Z'
		bcc.w	locret_198F8
		move.b	#4,routine(a1)

locret_198F8:				; CODE XREF: TouchResponse+106j
		rts
; ===========================================================================

loc_198FA:				; CODE XREF: TouchResponse+FEj
		tst.w	y_vel(a0)
		bpl.s	loc_19926
		move.w	y_pos(a0),d0
		subi.w	#$10,d0
		cmp.w	y_pos(a1),d0
		bcs.s	locret_19938

loc_1990E:
		neg.w	y_vel(a0)

loc_19912:
		move.w	#$FE80,y_vel(a1)
		tst.b	routine_secondary(a1)
		bne.s	locret_19938
		move.b	#4,routine_secondary(a1)
		rts
; ===========================================================================

loc_19926:				; CODE XREF: TouchResponse+116j
		cmpi.b	#2,anim(a0)
		bne.s	locret_19938
		neg.w	y_vel(a0)
		move.b	#4,routine(a1)

locret_19938:				; CODE XREF: TouchResponse+124j
					; TouchResponse+134j ...
		rts
; ===========================================================================

loc_1993A:				; CODE XREF: TouchResponse+E0j
					; TouchResponse:loc_19B56j
		tst.b	(Invincibility_flag).w
		bne.s	loc_19952
		cmpi.b	#9,anim(a0)
		beq.s	loc_19952
		cmpi.b	#2,anim(a0)
		bne.w	loc_199F2

loc_19952:				; CODE XREF: TouchResponse+156j
					; TouchResponse+15Ej
		tst.b	collision_property(a1)
		beq.s	Touch_KillEnemy
		neg.w	x_vel(a0)
		neg.w	y_vel(a0)
		asr	x_vel(a0)
		asr	y_vel(a0)
		move.b	#0,collision_flags(a1)
		subq.b	#1,collision_property(a1)
		bne.s	locret_1997A
		bset	#7,status(a1)

locret_1997A:				; CODE XREF: TouchResponse+18Aj
		rts
; ===========================================================================

Touch_KillEnemy:			; CODE XREF: TouchResponse+16Ej
		bset	#7,status(a1)
		moveq	#0,d0
		move.w	(Chain_Bonus_counter).w,d0
		addq.w	#2,(Chain_Bonus_counter).w
		cmpi.w	#6,d0
		bcs.s	loc_19994
		moveq	#6,d0

loc_19994:				; CODE XREF: TouchResponse+1A8j
		move.w	d0,combo(a1)
		move.w	Enemy_Points(pc,d0.w),d0
		cmpi.w	#$20,(Chain_Bonus_counter).w ; ' '
		bcs.s	loc_199AE
		move.w	#$3E8,d0
		move.w	#$A,combo(a1)

loc_199AE:				; CODE XREF: TouchResponse+1BAj
		bsr.w	AddPoints
		move.b	#ObjID_Explosion,id(a1) ; '''
		move.b	#0,routine(a1)
		tst.w	y_vel(a0)
		bmi.s	loc_199D4
		move.w	y_pos(a0),d0
		cmp.w	y_pos(a1),d0
		bcc.s	loc_199DC
		neg.w	y_vel(a0)
		rts
; ===========================================================================

loc_199D4:				; CODE XREF: TouchResponse+1DAj
		addi.w	#$100,y_vel(a0)
		rts
; ===========================================================================

loc_199DC:				; CODE XREF: TouchResponse+1E4j
		subi.w	#$100,y_vel(a0)
		rts
; ===========================================================================
Enemy_Points:
		dc.w	10,   20,   50,	 100; 0
; ===========================================================================

loc_199EC:				; CODE XREF: TouchResponse:Touch_Caterkillerj
		bset	#7,status(a1)

loc_199F2:				; CODE XREF: TouchResponse+EEj
					; TouchResponse+166j ...
		tst.b	(Invincibility_flag).w
		beq.s	Touch_Hurt

loc_199F8:				; CODE XREF: TouchResponse+21Aj
		moveq	#$FFFFFFFF,d0
		rts
; ===========================================================================

Touch_Hurt:				; CODE XREF: TouchResponse+20Ej
		nop
		tst.w	invulnerable_time(a0)
		bne.s	loc_199F8
		movea.l	a1,a2
; End of function TouchResponse


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HurtSonic:				; CODE XREF: ROM:0000C75Ep
		tst.b	(Shield_flag).w
		bne.s	HurtShield
		tst.w	(Ring_count).w

loc_19A10:
		beq.w	Hurt_NoRings
		jsr	(AllocateObject).l
		bne.s	HurtShield
		move.b	#ObjID_LostRings,id(a1) ; '7'
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)

HurtShield:				; CODE XREF: HurtSonic+4j
					; HurtSonic+14j ...
		move.b	#0,(Shield_flag).w
		move.b	#4,routine(a0)
		bsr.w	JmpTo_Sonic_ResetOnFloor
		bset	#1,status(a0)
		move.w	#$FC00,y_vel(a0)
		move.w	#$FE00,x_vel(a0)
		btst	#6,status(a0)
		beq.s	Hurt_Reverse
		move.w	#$FE00,y_vel(a0)
		move.w	#$FF00,x_vel(a0)

Hurt_Reverse:				; CODE XREF: HurtSonic+50j
		move.w	x_pos(a0),d0
		cmp.w	x_pos(a2),d0
		bcs.s	Hurt_ChkSpikes
		neg.w	x_vel(a0)

Hurt_ChkSpikes:				; CODE XREF: HurtSonic+66j
		move.w	#0,inertia(a0)
		move.b	#$1A,anim(a0)
		move.w	#$78,invulnerable_time(a0) ; 'x'
		move.w	#SndID_Hurt,d0	; '£'
		cmpi.b	#ObjID_Spikes,(a2) ; '6'
		bne.s	loc_19A98
		cmpi.b	#$16,(a2)
		bne.s	loc_19A98
		move.w	#SndID_HurtBySpikes,d0	; '¦'

loc_19A98:				; CODE XREF: HurtSonic+86j
					; HurtSonic+8Cj
		jsr	(PlaySound).l
		moveq	#$FFFFFFFF,d0
		rts
; ===========================================================================

Hurt_NoRings:				; CODE XREF: HurtSonic:loc_19A10j
		tst.w	(Debug_mode_flag).w
		bne.w	HurtShield
; End of function HurtSonic


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


KillSonic:				; CODE XREF: sub_F456+268p
					; Sonic_LevelBound:JmpTo_KillSonicj ...
		tst.w	(Debug_placement_mode).w
		bne.s	Kill_NoDeath
		move.b	#0,(Invincibility_flag).w
		move.b	#6,routine(a0)
		bsr.w	JmpTo_Sonic_ResetOnFloor
		bset	#1,status(a0)
		move.w	#$F900,y_vel(a0)
		move.w	#0,x_vel(a0)
		move.w	#0,inertia(a0)
		move.w	y_pos(a0),$38(a0)
		move.b	#$18,anim(a0)
		bset	#7,art_tile(a0)
		move.w	#SndID_Hurt,d0	; '£'
		cmpi.b	#ObjID_Spikes,(a2) ; '6'
		bne.s	loc_19AF8
		move.w	#SndID_HurtBySpikes,d0	; '¦'

loc_19AF8:				; CODE XREF: KillSonic+48j
		jsr	(PlaySound).l

Kill_NoDeath:				; CODE XREF: KillSonic+4j
		moveq	#$FFFFFFFF,d0
		rts
; End of function KillSonic

; ===========================================================================
; START	OF FUNCTION CHUNK FOR TouchResponse

Touch_Special:				; CODE XREF: TouchResponse+E8j
		move.b	collision_flags(a1),d1
		andi.b	#$3F,d1	; '?'
		cmpi.b	#$B,d1
		beq.s	Touch_Caterkiller
		cmpi.b	#$C,d1
		beq.s	Touch_Yadrin
		cmpi.b	#$17,d1
		beq.s	Touch_D7
		cmpi.b	#$21,d1	; '!'
		beq.s	Touch_E1
		rts
; ===========================================================================

Touch_Caterkiller:			; CODE XREF: TouchResponse+326j
		bra.w	loc_199EC
; ===========================================================================

Touch_Yadrin:				; CODE XREF: TouchResponse+32Cj
		sub.w	d0,d5
		cmpi.w	#8,d5
		bcc.s	loc_19B56
		move.w	x_pos(a1),d0
		subq.w	#4,d0
		btst	#0,status(a1)
		beq.s	loc_19B42
		subi.w	#$10,d0

loc_19B42:				; CODE XREF: TouchResponse+354j
		sub.w	d2,d0
		bcc.s	loc_19B4E
		addi.w	#$18,d0
		bcs.s	loc_19B52
		bra.s	loc_19B56
; ===========================================================================

loc_19B4E:				; CODE XREF: TouchResponse+35Cj
		cmp.w	d4,d0
		bhi.s	loc_19B56

loc_19B52:				; CODE XREF: TouchResponse+362j
		bra.w	loc_199F2
; ===========================================================================

loc_19B56:				; CODE XREF: TouchResponse+346j
					; TouchResponse+364j ...
		bra.w	loc_1993A
; ===========================================================================

Touch_D7:				; CODE XREF: TouchResponse+332j
		move.w	a0,d1
		subi.w	#Object_RAM,d1
		beq.s	loc_19B66
		addq.b	#1,collision_property(a1)

loc_19B66:				; CODE XREF: TouchResponse+378j
		addq.b	#1,collision_property(a1)
		rts
; ===========================================================================

Touch_E1:				; CODE XREF: TouchResponse+338j
		addq.b	#1,collision_property(a1)
		rts
; END OF FUNCTION CHUNK	FOR TouchResponse
; ===========================================================================
		nop