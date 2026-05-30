; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to setup background scrolling (actual scrolling is handled
; by DeformBGLayer, this mainly just clears/sets variables)
; ---------------------------------------------------------------------------
; sub_5988:
BgScrollSpeed:
		tst.b	(Last_star_pole_hit).w
		bne.s	loc_59B6
		move.w	d0,(Camera_BG_Y_pos).w
		move.w	d0,(Camera_BG2_Y_pos).w
		move.w	d1,(Camera_BG_X_pos).w
		move.w	d1,(Camera_BG2_X_pos).w
		move.w	d1,(Camera_BG3_X_pos).w
		move.w	d0,(Camera_BG_Y_pos_P2).w
		move.w	d0,(Camera_BG2_Y_pos_P2).w
		move.w	d1,(Camera_BG_X_pos_P2).w
		move.w	d1,(Camera_BG2_X_pos_P2).w
		move.w	d1,(Camera_BG3_X_pos_P2).w

loc_59B6:
		moveq	#0,d2
		move.b	(Current_Zone).w,d2
		add.w	d2,d2
		move.w	BgScroll_Index(pc,d2.w),d2
		jmp	BgScroll_Index(pc,d2.w)
; End of function BgScrollSpeed

; ===========================================================================
; off_59C6:
BgScroll_Index:	dc.w BgScroll_GHZ-BgScroll_Index
		dc.w BgScroll_LZ-BgScroll_Index
		dc.w BgScroll_CPZ-BgScroll_Index
		dc.w BgScroll_EHZ-BgScroll_Index
		dc.w BgScroll_HPZ-BgScroll_Index
		dc.w BgScroll_EHZ-BgScroll_Index
		dc.w BgScroll_S1Ending-BgScroll_Index
; ===========================================================================
; loc_59D4:
BgScroll_GHZ:
		clr.l	(Camera_BG_X_pos).w
		clr.l	(Camera_BG_Y_pos).w
		clr.l	(Camera_BG2_Y_pos).w
		clr.l	(Camera_BG3_Y_pos).w
		lea	(TempArray_LayerDef).w,a2
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(Camera_BG_X_pos_P2).w
		clr.l	(Camera_BG_Y_pos_P2).w
		clr.l	(Camera_BG2_Y_pos_P2).w
		clr.l	(Camera_BG3_Y_pos_P2).w
		rts
; ===========================================================================
; loc_5A00:
BgScroll_LZ:
		asr.l	#1,d0
		move.w	d0,(Camera_BG_Y_pos).w
		rts
; ===========================================================================
; loc_5A08:
BgScroll_CPZ:
		lsr.w	#2,d0
		move.w	d0,(Camera_BG_Y_pos).w
		move.w	d0,(Camera_BG_Y_pos_P2).w
		clr.l	(Camera_BG_X_pos).w
		clr.l	(Camera_BG2_X_pos).w
		rts
; ===========================================================================
; loc_5A1C:
BgScroll_EHZ:
		clr.l	(Camera_BG_X_pos).w
		clr.l	(Camera_BG_Y_pos).w
		clr.l	(Camera_BG2_Y_pos).w
		clr.l	(Camera_BG3_Y_pos).w
		lea	(TempArray_LayerDef).w,a2
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(Camera_BG_X_pos_P2).w
		clr.l	(Camera_BG_Y_pos_P2).w
		clr.l	(Camera_BG2_Y_pos_P2).w
		clr.l	(Camera_BG3_Y_pos_P2).w
		rts
; ===========================================================================
; loc_5A48:
BgScroll_HPZ:
		asr.w	#1,d0
		move.w	d0,(Camera_BG_Y_pos).w
		clr.l	(Camera_BG_X_pos).w
		rts
; ===========================================================================
; This made it all the way into REV00 before it was finally deleted in REV01.
; loc_5A54:
BgScroll_S1SYZ:
		asl.l	#4,d0
		move.l	d0,d2
		asl.l	#1,d0
		add.l	d2,d0
		asr.l	#8,d0
		addq.w	#1,d0
		move.w	d0,(Camera_BG_Y_pos).w
		clr.l	(Camera_BG_X_pos).w
		rts
; ===========================================================================
; loc_5A6A:
BgScroll_S1Ending:
		move.w	(Camera_X_pos).w,d0
		asr.w	#1,d0
		move.w	d0,(Camera_BG_X_pos).w
		move.w	d0,(Camera_BG2_X_pos).w
		asr.w	#2,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		move.w	d0,(Camera_BG3_X_pos).w
		clr.l	(Camera_BG_Y_pos).w
		clr.l	(Camera_BG2_Y_pos).w
		clr.l	(Camera_BG3_Y_pos).w
		lea	(TempArray_LayerDef).w,a2
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(a2)+
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to scroll as the player moves through the level
; ---------------------------------------------------------------------------
; sub_5A9C:
DeformBGLayer:
		tst.b	(Deform_lock).w
		beq.s	loc_5AA4
		rts
; ===========================================================================

loc_5AA4:
		clr.w	(Scroll_flags).w
		clr.w	(Scroll_flags_BG).w
		clr.w	(Scroll_flags_BG2).w
		clr.w	(Scroll_flags_BG3).w
		clr.w	(Scroll_flags_P2).w
		clr.w	(Scroll_flags_BG_P2).w
		clr.w	(Scroll_flags_BG2_P2).w
		clr.w	(Scroll_flags_BG3_P2).w
		lea	(MainCharacter).w,a0
		lea	(Camera_X_pos).w,a1
		lea	(Horiz_block_crossed_flag).w,a2
		lea	(Scroll_flags).w,a3
		lea	(Camera_X_pos_diff).w,a4
		lea	(Horiz_scroll_delay_val).w,a5
		lea	(Sonic_Pos_Record_Buf).w,a6
		bsr.w	ScrollHorizontal
		lea	(Camera_Y_pos).w,a1
		lea	(Verti_block_crossed_flag).w,a2
		lea	(Camera_Y_pos_diff).w,a4
		bsr.w	ScrollVertical
		tst.w	(Two_player_mode).w
		beq.s	loc_5B2A
		lea	(Sidekick).w,a0
		lea	(Camera_X_pos_P2).w,a1
		lea	(Horiz_block_crossed_flag_P2).w,a2
		lea	(Scroll_flags_P2).w,a3
		lea	(Camera_X_pos_diff_P2).w,a4
		lea	(Horiz_scroll_delay_val_P2).w,a5
		lea	(Tails_Pos_Record_Buf).w,a6
		bsr.w	ScrollHorizontal
		lea	(Camera_Y_pos_P2).w,a1
		lea	(Verti_block_crossed_flag_P2).w,a2
		lea	(Camera_Y_pos_diff_P2).w,a4
		bsr.w	ScrollVertical

loc_5B2A:
		bsr.w	DynScreenResizeLoad
		move.w	(Camera_Y_pos).w,(Vscroll_Factor_FG).w
		move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		add.w	d0,d0
		move.w	Deform_Index(pc,d0.w),d0
		jmp	Deform_Index(pc,d0.w)
; End of function DeformBGLayer

; ===========================================================================
Deform_Index:	dc.w Deform_GHZ-Deform_Index
		dc.w Deform_LZ-Deform_Index
		dc.w Deform_CPZ-Deform_Index
		dc.w Deform_EHZ-Deform_Index
		dc.w Deform_HPZ-Deform_Index
		dc.w Deform_HTZ-Deform_Index
		dc.w Deform_GHZ-Deform_Index
; ===========================================================================
; ---------------------------------------------------------------------------
; Green Hill deformation routine
; ---------------------------------------------------------------------------
; loc_5B58:
Deform_GHZ:
		tst.w	(Two_player_mode).w
		bne.w	Deform_GHZ_2P
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d6
		bsr.w	BGScroll_SetupBlock3
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#0,d6
		bsr.w	BGScroll_SetupBlock2
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	(Camera_Y_pos).w,d0
		andi.w	#$7FF,d0
		lsr.w	#5,d0
		neg.w	d0
		addi.w	#$20,d0
		bpl.s	loc_5B9A
		moveq	#0,d0

loc_5B9A:
		move.w	d0,d4
		move.w	d0,(Vscroll_Factor_BG).w
		move.w	(Camera_X_pos).w,d0
		cmpi.b	#GameModeID_TitleScreen,(Game_Mode).w
		bne.s	loc_5BAE
		moveq	#0,d0

loc_5BAE:
		neg.w	d0
		swap	d0
		lea	(TempArray_LayerDef).w,a2
		addi.l	#$10000,(a2)+
		addi.l	#$C000,(a2)+
		addi.l	#$8000,(a2)+
		move.w	(TempArray_LayerDef).w,d0
		add.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0
		move.w	#$1F,d1
		sub.w	d4,d1
		bcs.s	loc_5BE0

loc_5BDA:
		move.l	d0,(a1)+
		dbf	d1,loc_5BDA

loc_5BE0:
		move.w	(TempArray_LayerDef+4).w,d0
		add.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0
		move.w	#$F,d1

loc_5BEE:
		move.l	d0,(a1)+
		dbf	d1,loc_5BEE
		move.w	(TempArray_LayerDef+8).w,d0
		add.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0
		move.w	#$F,d1

loc_5C02:
		move.l	d0,(a1)+
		dbf	d1,loc_5C02
		move.w	#$2F,d1
		move.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0

loc_5C12:
		move.l	d0,(a1)+
		dbf	d1,loc_5C12
		move.w	#$27,d1
		move.w	(Camera_BG2_X_pos).w,d0
		neg.w	d0

loc_5C22:
		move.l	d0,(a1)+
		dbf	d1,loc_5C22
		move.w	(Camera_BG2_X_pos).w,d0
		move.w	(Camera_X_pos).w,d2
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2
		ext.l	d2
		asl.l	#8,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#$47,d1
		add.w	d4,d1

loc_5C48:
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,loc_5C48
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Green Hill 2-player deformation routine
; ---------------------------------------------------------------------------
; loc_5C5A:
Deform_GHZ_2P:
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d6
		bsr.w	BGScroll_SetupBlock3
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#0,d6
		bsr.w	BGScroll_SetupBlock2
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	(Camera_Y_pos).w,d0
		andi.w	#$7FF,d0
		lsr.w	#5,d0
		neg.w	d0
		addi.w	#$20,d0
		bpl.s	loc_5C94
		moveq	#0,d0

loc_5C94:
		andi.w	#-2,d0
		move.w	d0,d4
		lsr.w	#1,d4
		move.w	d0,(Vscroll_Factor_BG).w
		andi.l	#$FFFEFFFE,(Vscroll_Factor).w
		move.w	(Camera_X_pos).w,d0
		cmpi.b	#GameModeID_TitleScreen,(Game_Mode).w
		bne.s	loc_5CB6
		moveq	#0,d0

loc_5CB6:
		neg.w	d0
		swap	d0
		lea	(TempArray_LayerDef).w,a2
		addi.l	#$10000,(a2)+
		addi.l	#$C000,(a2)+
		addi.l	#$8000,(a2)+
		move.w	(TempArray_LayerDef).w,d0
		add.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0
		move.w	#$F,d1
		sub.w	d4,d1
		bcs.s	loc_5CE8

loc_5CE2:
		move.l	d0,(a1)+
		dbf	d1,loc_5CE2

loc_5CE8:
		move.w	(TempArray_LayerDef+4).w,d0
		add.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0
		move.w	#7,d1

loc_5CF6:
		move.l	d0,(a1)+
		dbf	d1,loc_5CF6
		move.w	(TempArray_LayerDef+8).w,d0
		add.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0
		move.w	#7,d1

loc_5D0A:
		move.l	d0,(a1)+
		dbf	d1,loc_5D0A
		move.w	#$17,d1
		move.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0

loc_5D1A:
		move.l	d0,(a1)+
		dbf	d1,loc_5D1A
		move.w	#$17,d1
		move.w	(Camera_BG2_X_pos).w,d0
		neg.w	d0

loc_5D2A:
		move.l	d0,(a1)+
		dbf	d1,loc_5D2A
		move.w	(Camera_BG2_X_pos).w,d0
		move.w	(Camera_X_pos).w,d2
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2
		ext.l	d2
		asl.l	#8,d2
		add.l	d2,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#$23,d1
		add.w	d4,d1

loc_5D52:
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,loc_5D52
		move.w	(Camera_X_pos_diff_P2).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		add.l	d4,(Camera_BG3_X_pos_P2).w
		move.w	(Camera_X_pos_diff_P2).w,d4
		ext.l	d4
		asl.l	#7,d4
		add.l	d4,(Camera_BG2_X_pos_P2).w
		lea	($FFFFE1C0).w,a1
		move.w	(Camera_Y_pos_P2).w,d0
		andi.w	#$7FF,d0
		lsr.w	#5,d0
		neg.w	d0
		addi.w	#$20,d0
		bpl.s	loc_5D98
		moveq	#0,d0

loc_5D98:
		andi.w	#-2,d0
		move.w	d0,d4
		lsr.w	#1,d4
		move.w	d0,(Vscroll_Factor_P2_BG).w
		subi.w	#$E0,(Vscroll_Factor_P2_BG).w
		move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
		subi.w	#$E0,(Vscroll_Factor_P2_FG).w
		andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w
		move.w	(Camera_X_pos_P2).w,d0
		cmpi.b	#GameModeID_TitleScreen,(Game_Mode).w
		bne.s	loc_5DCC
		moveq	#0,d0

loc_5DCC:
		neg.w	d0
		swap	d0
		move.w	(TempArray_LayerDef).w,d0
		add.w	(Camera_BG3_X_pos_P2).w,d0
		neg.w	d0
		move.w	#$F,d1
		sub.w	d4,d1
		bcs.s	loc_5DE8

loc_5DE2:
		move.l	d0,(a1)+
		dbf	d1,loc_5DE2

loc_5DE8:
		move.w	(TempArray_LayerDef+4).w,d0
		add.w	(Camera_BG3_X_pos_P2).w,d0
		neg.w	d0
		move.w	#7,d1

loc_5DF6:
		move.l	d0,(a1)+
		dbf	d1,loc_5DF6
		move.w	(TempArray_LayerDef+8).w,d0
		add.w	(Camera_BG3_X_pos_P2).w,d0
		neg.w	d0
		move.w	#7,d1

loc_5E0A:
		move.l	d0,(a1)+
		dbf	d1,loc_5E0A
		move.w	#$17,d1
		move.w	(Camera_BG3_X_pos_P2).w,d0
		neg.w	d0

loc_5E1A:
		move.l	d0,(a1)+
		dbf	d1,loc_5E1A
		move.w	#$17,d1
		move.w	(Camera_BG2_X_pos_P2).w,d0
		neg.w	d0

loc_5E2A:
		move.l	d0,(a1)+
		dbf	d1,loc_5E2A
		move.w	(Camera_BG2_X_pos_P2).w,d0
		move.w	(Camera_X_pos_P2).w,d2
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2
		ext.l	d2
		asl.l	#8,d2
		add.l	d2,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#$23,d1
		add.w	d4,d1

loc_5E52:
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,loc_5E52
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Labyrinth deformation routine
; ---------------------------------------------------------------------------
; loc_5E64:
Deform_LZ:
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#7,d4
		move.w	(Camera_Y_pos_diff).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	BGScroll_SetupXY
		move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
		lea	(Deform_LZ_Data1).l,a3
		lea	(Obj0A_WobbleData).l,a2
		move.b	(Camera_X_pos_disposition).w,d2
		move.b	d2,d3
		addi.w	#$80,(Camera_X_pos_disposition).w
		add.w	(Camera_BG_Y_pos).w,d2
		andi.w	#$FF,d2
		add.w	(Camera_Y_pos).w,d3
		andi.w	#$FF,d3
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	#$DF,d1
		move.w	(Camera_X_pos).w,d0
		neg.w	d0
		move.w	d0,d6
		swap	d0
		move.w	(Camera_BG_X_pos).w,d0
		neg.w	d0
		move.w	(Water_Level_1).w,d4
		move.w	(Camera_Y_pos).w,d5

loc_5EC6:
		cmp.w	d4,d5
		bge.s	loc_5ED8
		move.l	d0,(a1)+
		addq.w	#1,d5
		addq.b	#1,d2
		addq.b	#1,d3
		dbf	d1,loc_5EC6
		rts
; ===========================================================================

loc_5ED8:
		move.b	(a3,d3.w),d4
		ext.w	d4
		add.w	d6,d4
		move.w	d4,(a1)+
		move.b	(a2,d2.w),d4
		ext.w	d4
		add.w	d0,d4
		move.w	d4,(a1)+
		addq.b	#1,d2
		addq.b	#1,d3
		dbf	d1,loc_5ED8
		rts
; ===========================================================================
; byte_5EF6:
Deform_LZ_Data1:
		dc.b   1,  1,  2,  2,  3,  3,  3,  3,  2,  2,  1,  1,  0,  0,  0,  0
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b  -1, -1, -2, -2, -3, -3, -3, -3, -2, -2, -1, -1,  0,  0,  0,  0
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b   1,  1,  2,  2,  3,  3,  3,  3,  2,  2,  1,  1,  0,  0,  0,  0
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0

; ===========================================================================
; ---------------------------------------------------------------------------
; Chemical Plant deformation routine
; ---------------------------------------------------------------------------
; loc_5FF6:
Deform_CPZ:
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.w	(Camera_Y_pos_diff).w,d5
		ext.l	d5
		asl.l	#6,d5
		bsr.w	BGScroll_SetupXY
		move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	#$DF,d1
		move.w	(Camera_X_pos).w,d0
		neg.w	d0
		swap	d0
		move.w	(Camera_BG_X_pos).w,d0
		neg.w	d0

loc_6026:
		move.l	d0,(a1)+
		dbf	d1,loc_6026
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; While CPZ uses a basic static background in this build, the developers have
; already started on the final deformation routine. It is VERY broken at this
; point, not redrawing tiles correctly.
; ---------------------------------------------------------------------------
; loc_602E:
Deform_CPZ_Advanced:
		; update scroll flags to dynamically reload the background
		; as the player moves around
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.w	(Camera_Y_pos_diff).w,d5
		ext.l	d5
		asl.l	#6,d5
		bsr.w	BGScroll_SetupXY

		; ditto
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#4,d6
		bsr.w	BGScroll_SetupBlock2

		; update the background's vertical scrolling
		move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

		; merge BG1's and BG2's scroll flags into BG3...
		move.b	(Scroll_flags_BG).w,d0
		or.b	(Scroll_flags_BG2).w,d0
		move.b	d0,(Scroll_flags_BG3).w

		; ...then clear BG1's and BG2's scroll flags, as it's
		; designed to use its own dynamic background loader
		clr.b	(Scroll_flags_BG).w
		clr.b	(Scroll_flags_BG2).w
		lea	(TempArray_LayerDef).w,a1
		move.w	(Camera_BG_X_pos).w,d0
		neg.w	d0
		move.w	#$12,d1

loc_6078:
		move.w	d0,(a1)+
		dbf	d1,loc_6078
		move.w	(Camera_BG2_X_pos).w,d0
		neg.w	d0
		move.w	#$1C,d1

loc_6088:
		move.w	d0,(a1)+
		dbf	d1,loc_6088
		lea	(TempArray_LayerDef).w,a2
		move.w	(Camera_BG_Y_pos).w,d0
		andi.w	#$3F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		bra.w	Deform_All

; ===========================================================================
; ---------------------------------------------------------------------------
; Title screen deformation routine
; ---------------------------------------------------------------------------
; loc_60A4:
Deform_TitleScreen:
		move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
		move.w	(Camera_X_pos).w,d0
		cmpi.w	#$1C00,d0
		bcc.s	loc_60B6
		addq.w	#8,d0

loc_60B6:
		move.w	d0,(Camera_X_pos).w
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	(Camera_X_pos).w,d2
		neg.w	d2
		moveq	#0,d0
		bra.s	loc_60E4

; ===========================================================================
; ---------------------------------------------------------------------------
; Emerald Hill deformation routine
; ---------------------------------------------------------------------------
; loc_60C8:
Deform_EHZ:
		tst.w	(Two_player_mode).w
		bne.w	Deform_EHZ_2P
		move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	(Camera_X_pos).w,d0
		neg.w	d0
		move.w	d0,d2
		swap	d0

loc_60E4:
		move.w	#0,d0
		move.w	#$15,d1

loc_60EC:
		move.l	d0,(a1)+
		dbf	d1,loc_60EC
		move.w	d2,d0
		asr.w	#6,d0
		move.w	#$39,d1

loc_60FA:
		move.l	d0,(a1)+
		dbf	d1,loc_60FA
		move.w	d0,d3
		move.b	(Vint_runcount+3).w,d1
		andi.w	#7,d1
		bne.s	loc_6110
		subq.w	#1,(TempArray_LayerDef).w

loc_6110:
		move.w	(TempArray_LayerDef).w,d1
		andi.w	#$1F,d1
		lea	(Deform_EHZ_Data).l,a2
		lea	(a2,d1.w),a2
		move.w	#$14,d1

loc_6126:
		move.b	(a2)+,d0
		ext.w	d0
		add.w	d3,d0
		move.l	d0,(a1)+
		dbf	d1,loc_6126
		move.w	#0,d0
		move.w	#$A,d1

loc_613A:
		move.l	d0,(a1)+
		dbf	d1,loc_613A
		move.w	d2,d0
		asr.w	#4,d0
		move.w	#$F,d1

loc_6148:
		move.l	d0,(a1)+
		dbf	d1,loc_6148
		move.w	d2,d0
		asr.w	#4,d0
		move.w	d0,d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	#$F,d1

loc_615C:
		move.l	d0,(a1)+
		dbf	d1,loc_615C
		move.l	d0,d4
		swap	d4
		move.w	d2,d0
		asr.w	#1,d0
		move.w	d2,d1
		asr.w	#3,d1
		sub.w	d1,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$30,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#3,d3
		move.w	#$E,d1

loc_6188:
		move.w	d4,(a1)+
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,loc_6188
		move.w	#8,d1

loc_619A:
		move.w	d4,(a1)+
		move.w	d3,(a1)+
		move.w	d4,(a1)+
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		add.l	d0,d3
		swap	d3
		dbf	d1,loc_619A
		move.w	#$E,d1

loc_61B2:
		move.w	d4,(a1)+
		move.w	d3,(a1)+
		move.w	d4,(a1)+
		move.w	d3,(a1)+
		move.w	d4,(a1)+
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		add.l	d0,d3
		add.l	d0,d3
		swap	d3
		dbf	d1,loc_61B2
		rts
; ===========================================================================
; byte_61CE:
Deform_EHZ_Data:
		dc.b   1,  2,  1,  3,  1,  2,  2,  1,  2,  3,  1,  2,  1,  2,  0,  0
		dc.b   2,  0,  3,  2,  2,  3,  2,  2,  1,  3,  0,  0,  1,  0,  1,  3
		dc.b   1,  2,  1,  3,  1,  2,  2,  1,  2,  3,  1,  2,  1,  2,  0,  0
		dc.b   2,  0,  3,  2,  2,  3,  2,  2,  1,  3,  0,  0,  1,  0,  1,  3

; ===========================================================================
; ---------------------------------------------------------------------------
; Emerald Hill 2-player deformation routine
; ---------------------------------------------------------------------------
; loc_620E:
Deform_EHZ_2P:
		move.b	(Vint_runcount+3).w,d1
		andi.w	#7,d1
		bne.s	loc_621C
		subq.w	#1,(TempArray_LayerDef).w

loc_621C:
		move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
		andi.l	#$FFFEFFFE,(Vscroll_Factor).w
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	(Camera_X_pos).w,d0
		move.w	#$A,d1
		bsr.s	sub_6264
		moveq	#0,d0
		move.w	d0,(Vscroll_Factor_P2_BG).w
		subi.w	#$E0,(Vscroll_Factor_P2_BG).w
		move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w

loc_624A:
		subi.w	#$E0,(Vscroll_Factor_P2_FG).w
		andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w
		lea	($FFFFE1B0).w,a1
		move.w	(Camera_X_pos_P2).w,d0
		move.w	#$E,d1

sub_6264:
		neg.w	d0
		move.w	d0,d2
		swap	d0
		move.w	#0,d0

loc_626E:
		move.l	d0,(a1)+
		dbf	d1,loc_626E
		move.w	d2,d0
		asr.w	#6,d0
		move.w	#$1C,d1

loc_627C:
		move.l	d0,(a1)+
		dbf	d1,loc_627C
		move.w	d0,d3
		move.w	(TempArray_LayerDef).w,d1
		andi.w	#$1F,d1
		lea	Deform_EHZ_Data(pc),a2
		lea	(a2,d1.w),a2
		move.w	#$A,d1

loc_6298:
		move.b	(a2)+,d0
		ext.w	d0
		add.w	d3,d0
		move.l	d0,(a1)+
		dbf	d1,loc_6298
		move.w	#0,d0
		move.w	#4,d1

loc_62AC:
		move.l	d0,(a1)+
		dbf	d1,loc_62AC
		move.w	d2,d0
		asr.w	#4,d0
		move.w	#7,d1

loc_62BA:
		move.l	d0,(a1)+
		dbf	d1,loc_62BA
		move.w	d2,d0
		asr.w	#4,d0
		move.w	d0,d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	#7,d1

loc_62CE:
		move.l	d0,(a1)+
		dbf	d1,loc_62CE
		move.w	d2,d0
		asr.w	#1,d0
		move.w	d2,d1
		asr.w	#3,d1
		sub.w	d1,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$30,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#3,d3
		move.w	#$27,d1

loc_62F6:
		move.w	d2,(a1)+
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,loc_62F6
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; General deformation routine
; ---------------------------------------------------------------------------
; loc_6306:
Deform_All:
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	#$E,d1
		move.w	(Camera_X_pos).w,d0
		neg.w	d0
		swap	d0
		andi.w	#$F,d2
		add.w	d2,d2
		move.w	(a2)+,d0
		jmp	loc_6324(pc,d2.w)
; ===========================================================================

loc_6322:
		move.w	(a2)+,d0

loc_6324:
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		dbf	d1,loc_6322
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Hidden Palace deformation routine
; ---------------------------------------------------------------------------
; loc_634A:
Deform_HPZ:
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#6,d4
		moveq	#2,d6
		bsr.w	BGScroll_SetupBlock1
		move.w	(Camera_Y_pos_diff).w,d5
		ext.l	d5
		asl.l	#7,d5
		moveq	#6,d6
		bsr.w	BGScroll_SetupY
		move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
		lea	(TempArray_LayerDef).w,a1
		move.w	(Camera_X_pos).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#1,d0
		move.w	#7,d1

loc_637E:
		move.w	d0,(a1)+
		dbf	d1,loc_637E
		move.w	d2,d0
		asr.w	#3,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#8,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#1,d3
		lea	(TempArray_LayerDef+$60).w,a2
		swap	d3
		add.l	d0,d3
		swap	d3
		move.w	d3,(a1)+
		move.w	d3,(a1)+
		move.w	d3,(a1)+
		move.w	d3,-(a2)
		move.w	d3,-(a2)
		move.w	d3,-(a2)
		swap	d3
		add.l	d0,d3
		swap	d3
		move.w	d3,(a1)+
		move.w	d3,(a1)+
		move.w	d3,-(a2)
		move.w	d3,-(a2)
		swap	d3
		add.l	d0,d3
		swap	d3
		move.w	d3,(a1)+
		move.w	d3,-(a2)
		swap	d3
		add.l	d0,d3
		swap	d3
		move.w	d3,(a1)+
		move.w	d3,-(a2)
		move.w	(Camera_BG_X_pos).w,d0
		neg.w	d0
		move.w	#$19,d1

loc_63E0:
		move.w	d0,(a1)+
		dbf	d1,loc_63E0
		adda.w	#$E,a1
		move.w	d2,d0
		asr.w	#1,d0
		move.w	#$17,d1

loc_63F2:
		move.w	d0,(a1)+
		dbf	d1,loc_63F2
		lea	(TempArray_LayerDef).w,a2
		move.w	(Camera_BG_Y_pos).w,d0
		move.w	d0,d2
		andi.w	#$3F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		bra.w	Deform_All
; ===========================================================================
; ---------------------------------------------------------------------------
; Hill Top deformation routine
; ---------------------------------------------------------------------------
; loc_6410:
Deform_HTZ:
		move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	(Camera_X_pos).w,d0
		neg.w	d0
		move.w	d0,d2
		swap	d0
		move.w	d2,d0
		asr.w	#3,d0
		move.w	#$7F,d1

loc_642C:
		move.l	d0,(a1)+
		dbf	d1,loc_642C
		move.l	d0,d4
		move.w	d2,d0
		asr.w	#1,d0
		move.w	d2,d1
		asr.w	#3,d1
		sub.w	d1,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$18,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#3,d3
		swap	d3
		add.l	d0,d3
		swap	d3
		move.w	d3,d4
		move.l	d4,(a1)+
		move.l	d4,(a1)+
		move.l	d4,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		move.w	d3,d4
		move.l	d4,(a1)+
		move.l	d4,(a1)+
		move.l	d4,(a1)+
		move.l	d4,(a1)+
		move.l	d4,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		move.w	d3,d4
		move.w	#6,d1

loc_647E:
		move.l	d4,(a1)+
		dbf	d1,loc_647E
		swap	d3
		add.l	d0,d3
		add.l	d0,d3
		swap	d3
		move.w	d3,d4
		move.w	#7,d1

loc_6492:
		move.l	d4,(a1)+
		dbf	d1,loc_6492
		swap	d3
		add.l	d0,d3
		add.l	d0,d3
		swap	d3
		move.w	d3,d4
		move.w	#9,d1

loc_64A6:
		move.l	d4,(a1)+
		dbf	d1,loc_64A6
		swap	d3
		add.l	d0,d3
		add.l	d0,d3
		add.l	d0,d3
		swap	d3
		move.w	d3,d4
		move.w	#$E,d1

loc_64BC:
		move.l	d4,(a1)+
		dbf	d1,loc_64BC
		swap	d3
		add.l	d0,d3
		add.l	d0,d3
		add.l	d0,d3
		swap	d3
		move.w	#2,d2

loc_64D0:
		move.w	d3,d4
		move.w	#$F,d1

loc_64D6:
		move.l	d4,(a1)+
		dbf	d1,loc_64D6
		swap	d3
		add.l	d0,d3
		add.l	d0,d3
		add.l	d0,d3
		add.l	d0,d3
		swap	d3
		dbf	d2,loc_64D0
		rts