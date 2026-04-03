; ===========================================================================
; ---------------------------------------------------------------------------
; Routines to mark an enemy/monitor/ring/platform as destroyed
; a0 = the object
; ---------------------------------------------------------------------------

MarkObjGone:
		tst.w	(Two_player_mode).w
		beq.s	loc_CE64
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_CE64:
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_CE7C
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_CE7C:
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		beq.s	loc_CE8E
		bclr	#7,2(a2,d0.w)

loc_CE8E:
		bra.w	DeleteObject
; ===========================================================================
; does nothing instead of calling DisplaySprite in the case of no deletion
; loc_CE92:
MarkObjGone2:
		tst.w	(Two_player_mode).w
		beq.s	loc_CE9A
		rts
; ---------------------------------------------------------------------------

loc_CE9A:
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_CEB0
		rts
; ---------------------------------------------------------------------------

loc_CEB0:
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		beq.s	loc_CEC2
		bclr	#7,2(a2,d0.w)

loc_CEC2:
		bra.w	DeleteObject
; ===========================================================================
; first player in two player mode
; loc_CEC6:
MarkObjGone_P1:
		tst.w	(Two_player_mode).w
		bne.s	MarkObjGone_P2
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_CEE4
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_CEE4:
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		beq.s	loc_CEF6
		bclr	#7,2(a2,d0.w)

loc_CEF6:
		bra.w	DeleteObject
; ===========================================================================
; second player in two player mode
; loc_CEFA:
MarkObjGone_P2:
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		move.w	d0,d1
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_CF14
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_CF14:
		sub.w	(Camera_X_pos_coarse_P2).w,d1
		cmpi.w	#$280,d1
		bhi.w	loc_CF24
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_CF24:
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		beq.s	loc_CF36
		bclr	#7,2(a2,d0.w)

loc_CF36:
		bra.w	DeleteObject	; useless branch...