; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to add points to the score counter
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


AddPoints:
		move.b	#1,(Update_HUD_score).w
		lea	(Score).w,a3
		add.l	d0,(a3)
		move.l	#999999,d1
		cmp.l	(a3),d1
		bhi.s	loc_1B214
		move.l	d1,(a3)

loc_1B214:
		move.l	(a3),d0
		cmp.l	(Next_Extra_life_score).w,d0
		bcs.s	locret_1B23C
		addi.l	#5000,(Next_Extra_life_score).w
		tst.b	(Graphics_flags).w	; is this a Japanese console?
		bmi.s	locret_1B23C	; if not, branch
		addq.b	#1,(Life_count).w
		addq.b	#1,(Update_HUD_lives).w
		move.w	#MusID_ExtraLife,d0
		jmp	(PlaySound).l

locret_1B23C:
		rts
; End of function AddPoints