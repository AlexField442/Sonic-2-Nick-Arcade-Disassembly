; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to change Sonic's position with a platform
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_F70E:
MvSonicOnPtfm:
		move.w	y_pos(a0),d0
		sub.w	d3,d0
		bra.s	loc_F71E
; ===========================================================================
		; a couple lines of unused/leftover/dead code from Sonic 1 ; a0=object
		move.w	y_pos(a0),d0
		subi.w	#9,d0

loc_F71E:
		tst.b	(Player_override_flag).w
		bmi.s	locret_F746
		cmpi.b	#6,routine(a1)
		bcc.s	locret_F746
		tst.w	(Debug_placement_mode).w
		bne.s	locret_F746
		moveq	#0,d1
		move.b	y_radius(a1),d1
		sub.w	d1,d0
		move.w	d0,y_pos(a1)
		sub.w	x_pos(a0),d2
		sub.w	d2,x_pos(a1)

locret_F746:
		rts
; End of function MvSonicOnPtfm

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to change Sonic's position with a platform
; as if he is moving on a sloped surface
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_F748:
MvSonicOnSlope:
		btst	#3,status(a1)
		beq.s	locret_F788
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		lsr.w	#1,d0
		btst	#0,render_flags(a0)
		beq.s	loc_F768
		not.w	d0
		add.w	d1,d0

loc_F768:
		move.b	(a2,d0.w),d1
		ext.w	d1
		move.w	y_pos(a0),d0
		sub.w	d1,d0
		moveq	#0,d1
		move.b	y_radius(a1),d1
		sub.w	d1,d0
		move.w	d0,y_pos(a1)
		sub.w	x_pos(a0),d2
		sub.w	d2,x_pos(a1)

locret_F788:
		rts
; End of function MvSonicOnSlope