; ---------------------------------------------------------------------------
; Subroutine to animate a sprite using an animation script
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


AnimateSprite:
		moveq	#0,d0
		move.b	anim(a0),d0	; move animation number to d0
		cmp.b	prev_anim(a0),d0	; is animation set to change?
		beq.s	Anim_Run	; if not, branch
		move.b	d0,prev_anim(a0)	; set previous animation to current one
		move.b	#0,anim_frame(a0)	; reset animation
		move.b	#0,anim_frame_duration(a0)	; reset frame duration
; loc_CF64:
Anim_Run:
		subq.b	#1,anim_frame_duration(a0)	; subtract 1 from frame duration
		bpl.s	Anim_Wait	; if time remains, branch
		add.w	d0,d0
		adda.w	(a1,d0.w),a1	; calculate address of appropriate animation script
		move.b	(a1),anim_frame_duration(a0)	; load frame duration
		moveq	#0,d1
		move.b	anim_frame(a0),d1	; load current frame number
		move.b	1(a1,d1.w),d0	; read sprite number from script
		bmi.s	Anim_End_FF	; if animation is complete, branch
; loc_CF80:
Anim_Next:
		move.b	d0,d1		; move animation number to current frame number
		andi.b	#$1F,d0
		move.b	d0,mapping_frame(a0)	; load sprite number
		move.b	status(a0),d0	; match the orientation dictated by the object
		rol.b	#3,d1		; with the orientation used by the object engine
		eor.b	d0,d1
		andi.b	#3,d1
		andi.b	#$FC,render_flags(a0)
		or.b	d1,render_flags(a0)
		addq.b	#1,anim_frame(a0)	; next frame number
; locret_CFA4:
Anim_Wait:
		rts
; ===========================================================================
; loc_CFA6:
Anim_End_FF:
		addq.b	#1,d0		; is the end flag = $FF ?
		bne.s	Anim_End_FE	; if not, branch
		move.b	#0,anim_frame(a0)	; restart the animation
		move.b	1(a1),d0	; read sprite number
		bra.s	Anim_Next
; ===========================================================================
; loc_CFB6:
Anim_End_FE:
		addq.b	#1,d0		; is the end flag = $FE ?
		bne.s	Anim_End_FD	; if not, branch
		move.b	2(a1,d1.w),d0	; read the next byte in the script
		sub.b	d0,anim_frame(a0)	; jump back d0 bytes in the script
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0	; read sprite number
		bra.s	Anim_Next
; ===========================================================================
; loc_CFCA:
Anim_End_FD:
		addq.b	#1,d0		; is the end flag = $FD ?
		bne.s	Anim_End_FC	; if not, branch
		move.b	2(a1,d1.w),anim(a0)	; read next byte, run that animation
		rts
; ===========================================================================
; loc_CFD6:
Anim_End_FC:
		addq.b	#1,d0		; is the end flag = $FC ?
		bne.s	Anim_End_FB	; if not, branch
		addq.b	#2,routine(a0)	; jump to next routine
		rts
; ===========================================================================
; loc_CFE0:
Anim_End_FB:
		addq.b	#1,d0		; is the end flag = $FB ?
		bne.s	Anim_End_FA	; if not, branch
		move.b	#0,anim_frame(a0)	; reset animation
		clr.b	routine_secondary(a0)		; reset 2nd routine counter
		rts
; ===========================================================================
; loc_CFF0:
Anim_End_FA:
		addq.b	#1,d0		; is the end flag = $FA ?
		bne.s	Anim_End	; if not, branch
		addq.b	#2,routine_secondary(a0)	; jump to next routine
		rts
; ===========================================================================
; locret_CFFA:
Anim_End:
		rts
; End of function AnimateSprite