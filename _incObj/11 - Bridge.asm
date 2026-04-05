; ===========================================================================
; ---------------------------------------------------------------------------
; Object 11 - Bridge
;
; Internal name: "hashi"
; ---------------------------------------------------------------------------
; OST:
bridge_child1:	equ $30		; pointer to first set of bridge segments
bridge_child2:	equ $34		; pointer to second set of bridge segments, if applicable
; ---------------------------------------------------------------------------
; Sprite_7BA0: Obj11:
Obj_Bridge:
		btst	#6,render_flags(a0)	; is this a child sprite object?
		bne.w	.drawChild		; if yes, branch
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Bridge_Index(pc,d0.w),d1
		jmp	Bridge_Index(pc,d1.w)
; ===========================================================================
; loc_7BB8:
.drawChild:	; child sprite objects only need to be drawn
		moveq	#3,d0
		bra.w	DisplaySprite3
; ===========================================================================
; off_7BBE: Obj11_Index:
Bridge_Index:	dc.w Bridge_Init-Bridge_Index
		dc.w Bridge_GHZEHZ-Bridge_Index
		dc.w Bridge_Display-Bridge_Index
		dc.w Bridge_HPZ-Bridge_Index
; ===========================================================================
; loc_7BC6:
Bridge_Init:
		addq.b	#2,routine(a0)
		move.l	#Map_obj11_GHZ,mappings(a0)
		move.w	#$44C6,art_tile(a0)
		move.b	#3,priority(a0)
		cmpi.b	#3,(Current_Zone).w
		bne.s	.notEHZ
		move.l	#Map_obj11,mappings(a0)
		move.w	#$43C6,art_tile(a0)
		move.b	#3,priority(a0)
; loc_7BFA:
.notEHZ:
		cmpi.b	#4,(Current_Zone).w
		bne.s	.notHPZ
		addq.b	#4,routine(a0)
		move.l	#Map_obj11_HPZ,mappings(a0)
		move.w	#$6300,art_tile(a0)
; loc_7C14:
.notHPZ:
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$80,width_pixels(a0)
		move.w	y_pos(a0),d2
		move.w	d2,$3C(a0)
		move.w	x_pos(a0),d3
		lea	subtype(a0),a2		; copy bridge subtype to a2
		moveq	#0,d1
		move.b	(a2),d1			; d1 = subtype
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0			; (d0 div 2) * 16
		sub.w	d0,d3			; x position of left half
		swap	d1			; store subtype in high word for later
		move.w	#8,d1
		bsr.s	Bridge_MakeSegments
		move.w	subtype(a1),d0
		subq.w	#8,d0
		move.w	d0,x_pos(a1)		; center of first subsprite object
		move.l	a1,bridge_child1(a0)	; pointer to first subsprite object
		swap	d1			; retrieve subtype
		subq.w	#8,d1
		bls.s	loc_7C74
		; else, create a second subsprite object for the rest of the bridge
		move.w	d1,d4
		bsr.s	Bridge_MakeSegments
		move.l	a1,bridge_child2(a0)	; pointer to second subsprite object
		move.w	d4,d0
		add.w	d0,d0
		add.w	d4,d0
		move.w	$10(a1,d0.w),d0
		subq.w	#8,d0
		move.w	d0,x_pos(a1)		; center of second subsprite object

loc_7C74:
		bra.s	Bridge_GHZEHZ

; ---------------------------------------------------------------------------
; Subroutine to create individual bridge segments using subsprites
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; sub_7C76:
Bridge_MakeSegments:
		bsr.w	AllocateObjectAfterCurrent
		bne.s	locret_7CC6
		move.b	id(a0),id(a1)	; load Obj_Bridge
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.b	render_flags(a0),render_flags(a1)
		bset	#6,render_flags(a1)
		move.b	#$40,$E(a1)
		move.b	d1,$F(a1)
		subq.b	#1,d1
		lea	$10(a1),a2	; starting address for subsprite data

loc_7CB6:
		move.w	d3,(a2)+
		move.w	d2,(a2)+
		move.w	#0,(a2)+
		addi.w	#$10,d3		; width of a log, x_pos for next log
		dbf	d1,loc_7CB6	; repeat for d1 logs

locret_7CC6:
		rts
; End of function Bridge_MakeSegments

; ===========================================================================
; loc_7CC8:
Bridge_GHZEHZ:
		move.b	status(a0),d0
		andi.b	#$18,d0
		bne.s	loc_7CDE
		tst.b	$3E(a0)
		beq.s	loc_7D0A
		subq.b	#4,$3E(a0)
		bra.s	loc_7D06
; ===========================================================================

loc_7CDE:
		andi.b	#$10,d0
		beq.s	loc_7CFA
		move.b	$3F(a0),d0
		sub.b	$3B(a0),d0
		beq.s	loc_7CFA
		bcc.s	loc_7CF6
		addq.b	#1,$3F(a0)
		bra.s	loc_7CFA
; ===========================================================================

loc_7CF6:
		subq.b	#1,$3F(a0)

loc_7CFA:
		cmpi.b	#$40,$3E(a0)
		beq.s	loc_7D06
		addq.b	#4,$3E(a0)

loc_7D06:
		bsr.w	Bridge_Depress

loc_7D0A:
		moveq	#0,d1
		move.b	subtype(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		add.w	d2,d2
		moveq	#8,d3
		move.w	x_pos(a0),d4
		bsr.w	sub_7DC0
; loc_7D22:
Bridge_Unload:
		tst.w	(Two_player_mode).w	; are we in two player mode?
		beq.s	Bridge_ChkDel		; if not, branch
		rts
; ---------------------------------------------------------------------------
; loc_7D2A:
Bridge_ChkDel:
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.s	Bridge_DeleteChild
		rts
; ---------------------------------------------------------------------------
; loc_7D3E:
Bridge_DeleteChild:
		; delete first subsprite object
		movea.l	bridge_child1(a0),a1	; a1=object
		bsr.w	DeleteObject2
		cmpi.b	#8,subtype(a0)		; does this bridge have more than 8 logs?
		bls.s	Bridge_Delete		; if not, branch
		; delete second subsprite object
		movea.l	bridge_child2(a0),a1	; a1=object
		bsr.w	DeleteObject2
; loc_7D56:
Bridge_Delete:
		bra.w	DeleteObject
; ===========================================================================
; loc_7D5A:
Bridge_Display:
		bra.w	DisplaySprite
; ===========================================================================
; loc_7D5E:
Bridge_HPZ:
		move.b	status(a0),d0
		andi.b	#$18,d0
		bne.s	loc_7D74
		tst.b	$3E(a0)
		beq.s	loc_7DA0
		subq.b	#4,$3E(a0)
		bra.s	loc_7D9C
; ===========================================================================

loc_7D74:
		andi.b	#$10,d0
		beq.s	loc_7D90
		move.b	$3F(a0),d0
		sub.b	$3B(a0),d0
		beq.s	loc_7D90
		bcc.s	loc_7D8C
		addq.b	#1,$3F(a0)
		bra.s	loc_7D90
; ===========================================================================

loc_7D8C:
		subq.b	#1,$3F(a0)

loc_7D90:
		cmpi.b	#$40,$3E(a0)
		beq.s	loc_7D9C
		addq.b	#4,$3E(a0)

loc_7D9C:
		bsr.w	Bridge_Depress

loc_7DA0:
		moveq	#0,d1
		move.b	subtype(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		add.w	d2,d2
		moveq	#8,d3
		move.w	x_pos(a0),d4
		bsr.w	sub_7DC0
		bsr.w	sub_7E60
		bra.w	Bridge_Unload

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_7DC0:
		lea	(Sidekick).w,a1
		moveq	#4,d6
		moveq	#$3B,d5
		movem.l	d1-d4,-(sp)
		bsr.s	sub_7DDA
		movem.l	(sp)+,d1-d4
		lea	(MainCharacter).w,a1
		subq.b	#1,d6
		moveq	#$3F,d5

sub_7DDA:
		btst	d6,status(a0)
		beq.s	loc_7E3E
		btst	#1,status(a1)
		bne.s	loc_7DFA
		moveq	#0,d0
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	loc_7DFA
		cmp.w	d2,d0
		bcs.s	loc_7E08

loc_7DFA:
		bclr	#3,status(a1)
		bclr	d6,status(a0)
		moveq	#0,d4
		rts
; ===========================================================================

loc_7E08:
		lsr.w	#4,d0
		move.b	d0,(a0,d5.w)
		movea.l	bridge_child1(a0),a2
		cmpi.w	#8,d0
		bcs.s	loc_7E20
		movea.l	bridge_child2(a0),a2
		subi.w	#8,d0

loc_7E20:
		add.w	d0,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		move.w	$12(a2,d0.w),d0
		subq.w	#8,d0
		moveq	#0,d1
		move.b	$16(a1),d1
		sub.w	d1,d0
		move.w	d0,y_pos(a1)
		moveq	#0,d4
		rts
; ===========================================================================

loc_7E3E:
		move.w	d1,-(sp)
		bsr.w	PlatformObject11_cont
		move.w	(sp)+,d1
		btst	d6,status(a0)
		beq.s	locret_7E5E
		moveq	#0,d0
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		lsr.w	#4,d0
		move.b	d0,(a0,d5.w)

locret_7E5E:
		rts
; End of function sub_7DDA


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_7E60:
		moveq	#0,d0
		tst.w	(MainCharacter+x_vel).w
		bne.s	loc_7E72
		move.b	(Vint_runcount+3).w,d0
		andi.w	#$1C,d0
		lsr.w	#1,d0

loc_7E72:
		moveq	#0,d2
		move.b	byte_7E9E+1(pc,d0.w),d2
		swap	d2
		move.b	byte_7E9E(pc,d0.w),d2
		moveq	#0,d0
		tst.w	(Sidekick+x_vel).w
		bne.s	loc_7E90
		move.b	(Vint_runcount+3).w,d0
		andi.w	#$1C,d0
		lsr.w	#1,d0

loc_7E90:
		moveq	#0,d6
		move.b	byte_7E9E+1(pc,d0.w),d6
		swap	d6
		move.b	byte_7E9E(pc,d0.w),d6
		bra.s	loc_7EAE
; ===========================================================================
byte_7E9E:	dc.b	1,  2,  1,  2,  1,  2,  1,  2,  0,  1,  0,  0,  0,  0,  0,  1
; ===========================================================================

loc_7EAE:
		moveq	#-2,d3
		moveq	#-2,d4
		move.b	status(a0),d0
		andi.b	#8,d0
		beq.s	loc_7EC0
		move.b	$3F(a0),d3

loc_7EC0:
		move.b	status(a0),d0
		andi.b	#$10,d0
		beq.s	loc_7ECE
		move.b	$3B(a0),d4

loc_7ECE:
		movea.l	bridge_child1(a0),a1
		lea	$45(a1),a2
		lea	$15(a1),a1
		moveq	#0,d1
		move.b	subtype(a0),d1
		subq.b	#1,d1
		moveq	#0,d5

loc_7EE4:
		moveq	#0,d0
		subq.w	#1,d3
		cmp.b	d3,d5
		bne.s	loc_7EEE
		move.w	d2,d0

loc_7EEE:
		addq.w	#2,d3
		cmp.b	d3,d5
		bne.s	loc_7EF6
		move.w	d2,d0

loc_7EF6:
		subq.w	#1,d3
		subq.w	#1,d4
		cmp.b	d4,d5
		bne.s	loc_7F00
		move.w	d6,d0

loc_7F00:
		addq.w	#2,d4
		cmp.b	d4,d5
		bne.s	loc_7F08
		move.w	d6,d0

loc_7F08:
		subq.w	#1,d4
		cmp.b	d3,d5
		bne.s	loc_7F14
		swap	d2
		move.w	d2,d0
		swap	d2

loc_7F14:
		cmp.b	d4,d5
		bne.s	loc_7F1E
		swap	d6
		move.w	d6,d0
		swap	d6

loc_7F1E:
		move.b	d0,(a1)
		addq.w	#1,d5
		addq.w	#6,a1
		cmpa.w	a2,a1
		bne.s	loc_7F30
		movea.l	bridge_child2(a0),a1
		lea	$15(a1),a1

loc_7F30:
		dbf	d1,loc_7EE4
		rts
; End of function sub_7E60

; ---------------------------------------------------------------------------
; Subroutine to make the bridge push down where Sonic or Tails are standing
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; sub_7F36:
Bridge_Depress:
		move.b	$3E(a0),d0
		bsr.w	CalcSine
		move.w	d0,d4
		lea	(Bridge_BendData2).l,a4
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#4,d0
		moveq	#0,d3
		move.b	$3F(a0),d3
		move.w	d3,d2
		add.w	d0,d3
		moveq	#0,d5
		; This "-$80" is here since Sonic 2 removed support for bridges
		; with less than eight logs, not that it was used in Sonic 1.
		lea	(Bridge_BendData-$80).l,a5
		move.b	(a5,d3.w),d5

loc_7F64:
		andi.w	#$F,d3
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		movea.l	bridge_child1(a0),a1
		lea	$42(a1),a2
		lea	$12(a1),a1

loc_7F7A:
		moveq	#0,d0
		move.b	(a3)+,d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	$3C(a0),d0
		move.w	d0,(a1)
		addq.w	#6,a1
		cmpa.w	a2,a1
		bne.s	loc_7F9A
		movea.l	bridge_child2(a0),a1
		lea	$12(a1),a1

loc_7F9A:
		dbf	d2,loc_7F7A
		moveq	#0,d0
		move.b	subtype(a0),d0
		moveq	#0,d3
		move.b	$3F(a0),d3
		addq.b	#1,d3
		sub.b	d0,d3
		neg.b	d3
		bmi.s	locret_7FE4
		move.w	d3,d2
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		adda.w	d2,a3
		subq.w	#1,d2
		bcs.s	locret_7FE4

loc_7FC0:
		moveq	#0,d0
		move.b	-(a3),d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	$3C(a0),d0
		move.w	d0,(a1)
		addq.w	#6,a1
		cmpa.w	a2,a1
		bne.s	loc_7FE0
		movea.l	bridge_child2(a0),a1
		lea	$12(a1),a1

loc_7FE0:
		dbf	d2,loc_7FC0

locret_7FE4:
		rts
; End of function Bridge_Depress

; ===========================================================================
; seems to be bridge piece vertical position offset data
; byte_7FE6: Obj11_BendData:
Bridge_BendData:
		dc.b   2,  4,  6,  8,  8,  6,  4,  2,  0,  0,  0,  0,  0,  0,  0,  0	; 8 logs
		dc.b   2,  4,  6,  8, $A,  8,  6,  4,  2,  0,  0,  0,  0,  0,  0,  0	; 9 logs
		dc.b   2,  4,  6,  8, $A, $A,  8,  6,  4,  2,  0,  0,  0,  0,  0,  0	; 10 logs
		dc.b   2,  4,  6,  8, $A, $C, $A,  8,  6,  4,  2,  0,  0,  0,  0,  0	; 11 logs
		dc.b   2,  4,  6,  8, $A, $C, $C, $A,  8,  6,  4,  2,  0,  0,  0,  0	; 12 logs
		dc.b   2,  4,  6,  8, $A, $C, $E, $C, $A,  8,  6,  4,  2,  0,  0,  0	; 13 logs
		dc.b   2,  4,  6,  8, $A, $C, $E, $E, $C, $A,  8,  6,  4,  2,  0,  0	; 14 logs
		dc.b   2,  4,  6,  8, $A, $C, $E,$10, $E, $C, $A,  8,  6,  4,  2,  0	; 15 logs
		dc.b   2,  4,  6,  8, $A, $C, $E,$10,$10, $E, $C, $A,  8,  6,  4,  2	; 16 logs

; something else important for bridge depression to work (phase? bridge size adjustment?)
; byte_8066: Obj11_BendData2:
Bridge_BendData2:
		dc.b $FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b $B5,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b $7E,$DB,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b $61,$B5,$EC,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b $4A,$93,$CD,$F3,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b $3E,$7E,$B0,$DB,$F6,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b $38,$6D,$9D,$C5,$E4,$F8,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b $31,$61,$8E,$B5,$D4,$EC,$FB,$FF,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b $2B,$56,$7E,$A2,$C1,$DB,$EE,$FB,$FF,  0,  0,  0,  0,  0,  0,  0
		dc.b $25,$4A,$73,$93,$B0,$CD,$E1,$F3,$FC,$FF,  0,  0,  0,  0,  0,  0
		dc.b $1F,$44,$67,$88,$A7,$BD,$D4,$E7,$F4,$FD,$FF,  0,  0,  0,  0,  0
		dc.b $1F,$3E,$5C,$7E,$98,$B0,$C9,$DB,$EA,$F6,$FD,$FF,  0,  0,  0,  0
		dc.b $19,$38,$56,$73,$8E,$A7,$BD,$D1,$E1,$EE,$F8,$FE,$FF,  0,  0,  0
		dc.b $19,$38,$50,$6D,$83,$9D,$B0,$C5,$D8,$E4,$F1,$F8,$FE,$FF,  0,  0
		dc.b $19,$31,$4A,$67,$7E,$93,$A7,$BD,$CD,$DB,$E7,$F3,$F9,$FE,$FF,  0
		dc.b $19,$31,$4A,$61,$78,$8E,$A2,$B5,$C5,$D4,$E1,$EC,$F4,$FB,$FE,$FF
		even

; ---------------------------------------------------------------------------
; Sprite mappings - GHZ bridge
; ---------------------------------------------------------------------------
Map_obj11_GHZ:	incbin	"mappings/sprite/obj11_GHZ.bin"
; ---------------------------------------------------------------------------
; Sprite mappings - HPZ bridge
; ---------------------------------------------------------------------------
Map_obj11_HPZ:	incbin	"mappings/sprite/obj11_HPZ.bin"
; ---------------------------------------------------------------------------
; Sprite mappings - EHZ bridge
; ---------------------------------------------------------------------------
Map_obj11:	incbin	"mappings/sprite/obj11.bin"
		nop