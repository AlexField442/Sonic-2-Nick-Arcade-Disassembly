; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to scroll the camera horizontally
; ---------------------------------------------------------------------------
; sub_64EE:
ScrollHorizontal:
		move.w	(a1),d4
		bsr.s	sub_6514
		move.w	(a1),d0
		andi.w	#$10,d0
		move.b	(a2),d1
		eor.b	d1,d0
		bne.s	locret_6512
		eori.b	#$10,(a2)
		move.w	(a1),d0
		sub.w	d4,d0
		bpl.s	loc_650E
		bset	#2,(a3)
		rts
; ===========================================================================

loc_650E:
		bset	#3,(a3)

locret_6512:
		rts
; ===========================================================================

sub_6514:
		move.w	(a5),d1
		beq.s	loc_6536
		subi.w	#$100,d1
		move.w	d1,(a5)
		moveq	#0,d1
		move.b	(a5),d1
		lsl.b	#2,d1
		addq.b	#4,d1
		move.w	2(a5),d0
		sub.b	d1,d0
		move.w	(a6,d0.w),d0
		andi.w	#$3FFF,d0
		bra.s	loc_653A
; ===========================================================================

loc_6536:
		move.w	x_pos(a0),d0

loc_653A:
		sub.w	(a1),d0
		subi.w	#$90,d0
		blt.s	loc_654C
		subi.w	#$10,d0
		bge.s	loc_6564
		clr.w	(a4)
		rts
; ===========================================================================

loc_654C:
		cmpi.w	#-$10,d0
		bgt.s	loc_6556
		move.w	#-$10,d0

loc_6556:
		add.w	(a1),d0
		cmp.w	(Camera_Min_X_pos).w,d0
		bgt.s	loc_657A
		move.w	(Camera_Min_X_pos).w,d0
		bra.s	loc_657A
; ===========================================================================

loc_6564:
		cmpi.w	#$10,d0
		bcs.s	loc_656E
		move.w	#$10,d0

loc_656E:
		add.w	(a1),d0
		cmp.w	(Camera_Max_X_pos).w,d0
		blt.s	loc_657A
		move.w	(Camera_Max_X_pos).w,d0

loc_657A:
		move.w	d0,d1
		sub.w	(a1),d1
		asl.w	#8,d1
		move.w	d0,(a1)
		move.w	d1,(a4)
		rts
; End of function ScrollHorizontal

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to scroll the camera vertically
; ---------------------------------------------------------------------------
; sub_6586:
ScrollVertical:
		moveq	#0,d1
		move.w	y_pos(a0),d0
		sub.w	(a1),d0
		btst	#2,status(a0)
		beq.s	loc_6598
		subq.w	#5,d0

loc_6598:
		btst	#1,status(a0)
		beq.s	loc_65B8
		addi.w	#$20,d0
		sub.w	(Camera_Y_pos_bias).w,d0
		bcs.s	loc_6602
		subi.w	#$40,d0
		bcc.s	loc_6602
		tst.b	(Camera_Max_Y_Pos_Changing).w
		bne.s	loc_6614
		bra.s	loc_65C4
; ===========================================================================

loc_65B8:
		sub.w	(Camera_Y_pos_bias).w,d0
		bne.s	loc_65C8
		tst.b	(Camera_Max_Y_Pos_Changing).w
		bne.s	loc_6614

loc_65C4:
		clr.w	(a4)
		rts
; ===========================================================================

loc_65C8:
		cmpi.w	#$60,(Camera_Y_pos_bias).w
		bne.s	loc_65F0
		move.w	$14(a0),d1
		bpl.s	loc_65D8
		neg.w	d1

loc_65D8:
		cmpi.w	#$800,d1
		bcc.s	loc_6602
		move.w	#$600,d1
		cmpi.w	#6,d0
		bgt.s	loc_665C
		cmpi.w	#-6,d0
		blt.s	loc_662A
		bra.s	loc_661A
; ===========================================================================

loc_65F0:
		move.w	#$200,d1
		cmpi.w	#2,d0
		bgt.s	loc_665C
		cmpi.w	#-2,d0
		blt.s	loc_662A
		bra.s	loc_661A
; ===========================================================================

loc_6602:
		move.w	#$1000,d1
		cmpi.w	#$10,d0
		bgt.s	loc_665C
		cmpi.w	#-$10,d0
		blt.s	loc_662A
		bra.s	loc_661A
; ===========================================================================

loc_6614:
		moveq	#0,d0
		move.b	d0,(Camera_Max_Y_Pos_Changing).w

loc_661A:
		moveq	#0,d1
		move.w	d0,d1
		add.w	(a1),d1
		tst.w	d0
		bpl.w	loc_6664
		bra.w	loc_6634
; ===========================================================================

loc_662A:
		neg.w	d1
		ext.l	d1
		asl.l	#8,d1
		add.l	(a1),d1
		swap	d1

loc_6634:
		cmp.w	(Camera_Min_Y_pos).w,d1
		bgt.s	loc_6686
		cmpi.w	#-$100,d1
		bgt.s	loc_6656
		andi.w	#$7FF,d1
		andi.w	#$7FF,y_pos(a0)
		andi.w	#$7FF,(a1)
		andi.w	#$3FF,x_pos(a1)
		bra.s	loc_6686
; ===========================================================================

loc_6656:
		move.w	(Camera_Min_Y_pos).w,d1
		bra.s	loc_6686
; ===========================================================================

loc_665C:
		ext.l	d1
		asl.l	#8,d1
		add.l	(a1),d1
		swap	d1

loc_6664:
		cmp.w	(Camera_Max_Y_pos).w,d1
		blt.s	loc_6686
		subi.w	#$800,d1
		bcs.s	loc_6682
		andi.w	#$7FF,y_pos(a0)
		subi.w	#$800,(a1)
		andi.w	#$3FF,x_pos(a1)
		bra.s	loc_6686
; ===========================================================================

loc_6682:
		move.w	(Camera_Max_Y_pos).w,d1

loc_6686:
		move.w	(a1),d4
		swap	d1
		move.l	d1,d3
		sub.l	(a1),d3
		ror.l	#8,d3
		move.w	d3,(a4)
		move.l	d1,(a1)
		move.w	(a1),d0
		andi.w	#$10,d0
		move.b	(a2),d1
		eor.b	d1,d0
		bne.s	locret_66B4
		eori.b	#$10,(a2)
		move.w	(a1),d0
		sub.w	d4,d0
		bpl.s	loc_66B0
		bset	#0,(a3)
		rts
; ===========================================================================

loc_66B0:
		bset	#1,(a3)

locret_66B4:
		rts
; End of function ScrollVertical