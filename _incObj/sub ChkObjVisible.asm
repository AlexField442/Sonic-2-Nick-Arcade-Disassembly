; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check whether an object is off-screen
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


ChkObjectVisible:
		sub.w	(Camera_X_pos).w,d0
		bmi.s	.offscreen
		cmpi.w	#$140,d0
		bge.s	.offscreen
		move.w	y_pos(a0),d1
		sub.w	(Camera_Y_pos).w,d1
		bmi.s	.offscreen
		cmpi.w	#$E0,d1
		bge.s	.offscreen
		moveq	#0,d0
		rts
; loc_D82E:
.offscreen:
		moveq	#1,d0
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check whether an object is off-screen, taking
; into account its width
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


ChkPartiallyVisible:
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		move.w	x_pos(a0),d0
		sub.w	(Camera_X_pos).w,d0
		add.w	d1,d0
		bmi.s	.offscreen
		add.w	d1,d1
		sub.w	d1,d0
		cmpi.w	#$140,d0
		bge.s	.offscreen
		move.w	y_pos(a0),d1
		sub.w	(Camera_Y_pos).w,d1
		bmi.s	.offscreen
		cmpi.w	#$E0,d1
		bge.s	.offscreen
		moveq	#0,d0
		rts
; loc_D862:
.offscreen:
		moveq	#1,d0
		rts
; ===========================================================================
		nop