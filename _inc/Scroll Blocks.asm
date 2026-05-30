; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to setup horizontal and vertical scrolling flags
; ---------------------------------------------------------------------------
; loc_66B6: ScrollBlock1:
BGScroll_SetupXY:
		move.l	(Camera_BG_X_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(Camera_BG_X_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(Horiz_block_crossed_flag_BG).w,d3
		eor.b	d3,d1
		bne.s	loc_66EA
		eori.b	#$10,(Horiz_block_crossed_flag_BG).w
		sub.l	d2,d0
		bpl.s	loc_66E4
		bset	#2,(Scroll_flags_BG).w
		bra.s	loc_66EA
; ===========================================================================

loc_66E4:
		bset	#3,(Scroll_flags_BG).w

loc_66EA:
		move.l	(Camera_BG_Y_pos).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(Camera_BG_Y_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(Verti_block_crossed_flag_BG).w,d2
		eor.b	d2,d1
		bne.s	locret_671E
		eori.b	#$10,(Verti_block_crossed_flag_BG).w
		sub.l	d3,d0
		bpl.s	loc_6718
		bset	#0,(Scroll_flags_BG).w
		rts
; ===========================================================================

loc_6718:
		bset	#1,(Scroll_flags_BG).w

locret_671E:
		rts
; End of function BGScroll_SetupXY

; ---------------------------------------------------------------------------
; Subroutine to setup vertical scrolling flags
; ---------------------------------------------------------------------------
; loc_6720: ScrollBlock2:
BGScroll_SetupY:
		move.l	(Camera_BG_Y_pos).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(Camera_BG_Y_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(Verti_block_crossed_flag_BG).w,d2
		eor.b	d2,d1
		bne.s	locret_6752
		eori.b	#$10,(Verti_block_crossed_flag_BG).w
		sub.l	d3,d0
		bpl.s	loc_674C
		bset	d6,(Scroll_flags_BG).w
		rts
; ===========================================================================

loc_674C:
		addq.b	#1,d6
		bset	d6,(Scroll_flags_BG).w

locret_6752:
		rts
; End of function BGScroll_SetupY

; ---------------------------------------------------------------------------
; Subroutine to setup vertical scrolling flags based on the absolute position
; ---------------------------------------------------------------------------
; loc_6754: ScrollBlock3:
BGScroll_SetupYAbsolute:
		move.w	(Camera_BG_Y_pos).w,d3
		move.w	d0,(Camera_BG_Y_pos).w
		move.w	d0,d1
		andi.w	#$10,d1
		move.b	(Verti_block_crossed_flag_BG).w,d2
		eor.b	d2,d1
		bne.s	locret_6782
		eori.b	#$10,(Verti_block_crossed_flag_BG).w
		sub.w	d3,d0
		bpl.s	loc_677C
		bset	#0,(Scroll_flags_BG).w
		rts
; ===========================================================================

loc_677C:
		bset	#1,(Scroll_flags_BG).w

locret_6782:
		rts
; End of function BGScroll_SetupYAbsolute

; ---------------------------------------------------------------------------
; Subroutine to setup scroll flags for layer 1
; ---------------------------------------------------------------------------
; loc_6784: ScrollBlock4:
BGScroll_SetupBlock1:
		move.l	(Camera_BG_X_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(Camera_BG_X_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(Horiz_block_crossed_flag_BG).w,d3
		eor.b	d3,d1
		bne.s	locret_67B6
		eori.b	#$10,(Horiz_block_crossed_flag_BG).w
		sub.l	d2,d0
		bpl.s	loc_67B0
		bset	d6,(Scroll_flags_BG).w
		bra.s	locret_67B6
; ===========================================================================

loc_67B0:
		addq.b	#1,d6
		bset	d6,(Scroll_flags_BG).w

locret_67B6:
		rts
; End of function BGScroll_SetupBlock1

; ---------------------------------------------------------------------------
; Subroutine to setup scroll flags for layer 2
; ---------------------------------------------------------------------------
; loc_67B8: ScrollBlock5:
BGScroll_SetupBlock2:
		move.l	(Camera_BG2_X_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(Camera_BG2_X_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(Horiz_block_crossed_flag_BG2).w,d3
		eor.b	d3,d1
		bne.s	locret_67EA
		eori.b	#$10,(Horiz_block_crossed_flag_BG2).w
		sub.l	d2,d0
		bpl.s	loc_67E4
		bset	d6,(Scroll_flags_BG2).w
		bra.s	locret_67EA
; ===========================================================================

loc_67E4:
		addq.b	#1,d6
		bset	d6,(Scroll_flags_BG2).w

locret_67EA:
		rts
; End of function BGScroll_SetupBlock2

; ---------------------------------------------------------------------------
; Subroutine to setup scroll flags for layer 3
; ---------------------------------------------------------------------------
; loc_67EC: ScrollBlock6:
BGScroll_SetupBlock3:
		move.l	(Camera_BG3_X_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(Camera_BG3_X_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(Horiz_block_crossed_flag_BG3).w,d3
		eor.b	d3,d1
		bne.s	locret_681E
		eori.b	#$10,(Horiz_block_crossed_flag_BG3).w
		sub.l	d2,d0
		bpl.s	loc_6818
		bset	d6,(Scroll_flags_BG3).w
		bra.s	locret_681E
; ===========================================================================

loc_6818:
		addq.b	#1,d6
		bset	d6,(Scroll_flags_BG3).w

locret_681E:
		rts
; End of function BGScroll_SetupBlock3