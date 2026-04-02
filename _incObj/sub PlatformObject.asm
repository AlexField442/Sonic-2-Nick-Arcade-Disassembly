; ---------------------------------------------------------------------------
; Subroutine to collide Sonic/Tails with the top of a platform
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
;
; input variables:
; d1 = object width
; d3 = object height / 2
; d4 = object x-axis position
;
; address registers:
; a0 = the object to check collision with
; a1 = Sonic or Tails (set inside these subroutines)
; sub_F78A:
PlatformObject:
		lea	(MainCharacter).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		bsr.s	PlatformObject_SingleCharacter
		movem.l	(sp)+,d1-d4
		lea	(Sidekick).w,a1
		addq.b	#1,d6
; sub_F7A0:
PlatformObject_SingleCharacter:
		btst	d6,status(a0)
		beq.w	PlatformObject_cont
		move.w	d1,d2
		add.w	d2,d2
		btst	#1,status(a1)
		bne.s	loc_F7C4
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	loc_F7C4
		cmp.w	d2,d0
		bcs.s	loc_F7D2

loc_F7C4:
		bclr	#3,status(a1)
		bclr	d6,status(a0)
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_F7D2:
		move.w	d4,d2
		bsr.w	MvSonicOnPtfm
		moveq	#0,d4
		rts
; End of function PlatformObject

; ---------------------------------------------------------------------------
; Subroutine to collide Sonic/Tails with the top of a sloped platform like a seesaw
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
;
; input variables:
; d1 = object width
; d3 = object height
; d4 = object x-axis position
;
; address registers:
; a0 = the object to check collision with
; a1 = Sonic or Tails (set inside these subroutines)
; a2 = height data for slope
; sub_F7DC:
SlopedPlatform:
		lea	(MainCharacter).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		bsr.s	SlopedPlatform_SingleCharacter
		movem.l	(sp)+,d1-d4
		lea	(Sidekick).w,a1
		addq.b	#1,d6
; sub_F7F2:
SlopedPlatform_SingleCharacter:
		btst	d6,status(a0)
		beq.w	SlopedPlatform_cont
		move.w	d1,d2
		add.w	d2,d2
		btst	#1,status(a1)
		bne.s	loc_F816
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	loc_F816
		cmp.w	d2,d0
		bcs.s	loc_F824

loc_F816:
		bclr	#3,status(a1)
		bclr	d6,status(a0)
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_F824:
		move.w	d4,d2
		bsr.w	sub_F748
		moveq	#0,d4
		rts
; End of function SlopedPlatform

; ===========================================================================
; sub_F82E:
PlatformObject2:
		lea	(MainCharacter).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		bsr.s	PlatformObject2_SingleCharacter
		movem.l	(sp)+,d1-d4
		lea	(Sidekick).w,a1
		addq.b	#1,d6
; sub_F844:
PlatformObject2_SingleCharacter:
		btst	d6,status(a0)
		beq.w	PlatformObject2_cont
		move.w	d1,d2
		add.w	d2,d2
		btst	#1,status(a1)
		bne.s	loc_F868
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	loc_F868
		cmp.w	d2,d0
		bcs.s	loc_F876

loc_F868:
		bclr	#3,status(a1)
		bclr	d6,status(a0)
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_F876:
		move.w	d4,d2
		bsr.w	MvSonicOnPtfm
		moveq	#0,d4
		rts
; End of function PlatformObject2

; ===========================================================================
; Used only by EHZ/HPZ log bridges. Very similar to PlatformObject_cont, but
; d2 already has the full width of the log.
; sub_F880:
PlatformObject11_cont:
		tst.w	y_vel(a1)
		bmi.w	locret_F966
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.w	locret_F966
		cmp.w	d2,d0
		bcc.w	locret_F966
		bra.s	loc_F8BC
; ===========================================================================
; loc_F89E:
PlatformObject_cont:
		tst.w	y_vel(a1)
		bmi.w	locret_F966
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.w	locret_F966
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.w	locret_F966

loc_F8BC:
		move.w	y_pos(a0),d0
		sub.w	d3,d0
; loc_F8C2:
PlatformObject_ChkYRange:
		move.w	y_pos(a1),d2
		move.b	y_radius(a1),d1
		ext.w	d1
		add.w	d2,d1
		addq.w	#4,d1
		sub.w	d1,d0
		bhi.w	locret_F966
		cmpi.w	#$FFF0,d0
		bcs.w	locret_F966
		tst.b	(Player_override_flag).w
		bmi.w	locret_F966
		cmpi.b	#6,routine(a1)
		bcc.w	locret_F966
		add.w	d0,d2
		addq.w	#3,d2
		move.w	d2,y_pos(a1)
; sub_F8F8:
RideObject_SetRide:
		btst	#3,status(a1)
		beq.s	loc_F916
		moveq	#0,d0
		move.b	interact(a1),d0
		lsl.w	#6,d0
		addi.l	#Object_RAM,d0
		movea.l	d0,a3
		bclr	#3,status(a3)

loc_F916:
		move.w	a0,d0
		subi.w	#Object_RAM,d0
		lsr.w	#6,d0
		andi.w	#$7F,d0
		move.b	d0,interact(a1)
		move.b	#0,angle(a1)
		move.w	#0,y_vel(a1)
		move.w	x_vel(a1),inertia(a1)
		btst	#1,status(a1)
		beq.s	loc_F95C
		move.l	a0,-(sp)
		movea.l	a1,a0
		move.w	a0,d1
		subi.w	#Object_RAM,d1
		bne.s	loc_F954
		jsr	(Sonic_ResetOnFloor).l
		bra.s	loc_F95A
; ===========================================================================

loc_F954:
		jsr	(Tails_ResetTailsOnFloor).l

loc_F95A:
		movea.l	(sp)+,a0

loc_F95C:
		bset	#3,status(a1)
		bset	d6,status(a0)

locret_F966:
		rts
; ===========================================================================
; loc_F968:
SlopedPlatform_cont:
		tst.w	y_vel(a1)
		bmi.w	locret_F966
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	locret_F966
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.s	locret_F966
		btst	#0,render_flags(a0)
		beq.s	loc_F98E
		not.w	d0
		add.w	d1,d0

loc_F98E:
		lsr.w	#1,d0
		move.b	(a2,d0.w),d3
		ext.w	d3
		move.w	y_pos(a0),d0
		sub.w	d3,d0
		bra.w	PlatformObject_ChkYRange
; ===========================================================================
; loc_F9A0:
PlatformObject2_cont:
		tst.w	y_vel(a1)
		bmi.w	locret_F966
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.w	locret_F966
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.w	locret_F966
		move.w	y_pos(a0),d0
		sub.w	d3,d0
		bra.w	PlatformObject_ChkYRange

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to stop Sonic/Tails on terrain if they are being dragged
; onto it by an object
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_F9C8:
DropOnFloor:
		move.w	d1,d2
		add.w	d2,d2
		lea	(MainCharacter).w,a1
		btst	#1,status(a1)
		bne.s	loc_F9E8
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	loc_F9E8
		cmp.w	d2,d0
		bcs.s	locret_F9FA

loc_F9E8:
		bclr	#3,status(a1)
		move.b	#2,routine(a0)
		bclr	#3,status(a0)

locret_F9FA:
		rts
; End of function DropOnFloor