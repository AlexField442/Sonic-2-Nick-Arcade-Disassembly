; ===========================================================================
		lea	(VDP_control_port).l,a5
		lea	(VDP_data_port).l,a6
		lea	(Scroll_flags_BG).w,a2
		lea	(Camera_BG_X_pos).w,a3
		lea	(Level_Layout+levelrowsize).w,a4
		move.w	#$6000,d2
		bsr.w	sub_69B2
		lea	(Scroll_flags_BG2).w,a2
		lea	(Camera_BG2_X_pos).w,a3
		bra.w	sub_6A82

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


LoadTilesAsYouMove:
		lea	(VDP_control_port).l,a5
		lea	(VDP_data_port).l,a6
		; update the background
		lea	(Scroll_flags_BG_copy).w,a2
		lea	(Camera_BG_copy).w,a3
		lea	(Level_Layout+levelrowsize).w,a4
		move.w	#$6000,d2
		bsr.w	sub_69B2
		lea	(Scroll_flags_BG2_copy).w,a2
		lea	(Camera_BG2_copy).w,a3
		bsr.w	sub_6A82
		lea	(Scroll_flags_BG3_copy).w,a2
		lea	(Camera_BG3_copy).w,a3
		bsr.w	sub_6B7C
		; then draw the foreground
		tst.w	(Two_player_mode).w
		beq.s	.drawPlayerOne
		lea	(Scroll_flags_copy_P2).w,a2
		lea	(Camera_P2_copy).w,a3
		lea	(Level_Layout).w,a4
		move.w	#$6000,d2
		bsr.w	sub_694C
; loc_689E:
.drawPlayerOne:
		lea	(Scroll_flags_copy).w,a2
		lea	(Camera_RAM_copy).w,a3
		lea	(Level_Layout).w,a4
		move.w	#$4000,d2
		tst.b	(Screen_redraw_flag).w
		beq.s	loc_68E6
		move.b	#0,(Screen_redraw_flag).w
		moveq	#$FFFFFFF0,d4
		moveq	#$F,d6
; loc_68BE:
Draw_EntireScreen:
		; redraw the entire screen; not actually used yet in this prototype
		movem.l	d4-d6,-(sp)
		moveq	#$FFFFFFF0,d5
		move.w	d4,d1
		bsr.w	CalculateVRAMPosition
		move.w	d1,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_6D8C		; draw the current row
		movem.l	(sp)+,d4-d6
		addi.w	#$10,d4			; move onto the next row
		dbf	d6,Draw_EntireScreen	; repeat for all rows
		move.b	#0,(Scroll_flags_copy).w
		rts
; ===========================================================================

loc_68E6:
		tst.b	(a2)			; are any scroll flags set?
		beq.s	locret_694A		; if not, no need to update
		bclr	#0,(a2)
		beq.s	loc_6900
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	CalculateVRAMPosition
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_6D8C

loc_6900:				; CODE XREF: LoadTilesAsYouMove+A2j
		bclr	#1,(a2)
		beq.s	loc_691A
		move.w	#$E0,d4	; 'à'
		moveq	#$FFFFFFF0,d5
		bsr.w	CalculateVRAMPosition
		move.w	#$E0,d4	; 'à'
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_6D8C

loc_691A:				; CODE XREF: LoadTilesAsYouMove+B8j
		bclr	#2,(a2)
		beq.s	loc_6930
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	CalculateVRAMPosition
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_6CFE

loc_6930:				; CODE XREF: LoadTilesAsYouMove+D2j
		bclr	#3,(a2)
		beq.s	locret_694A
		moveq	#$FFFFFFF0,d4
		move.w	#$140,d5
		bsr.w	CalculateVRAMPosition
		moveq	#$FFFFFFF0,d4
		move.w	#$140,d5
		bsr.w	sub_6CFE

locret_694A:				; CODE XREF: LoadTilesAsYouMove+9Cj
					; LoadTilesAsYouMove+E8j
		rts
; End of function LoadTilesAsYouMove


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_694C:				; CODE XREF: LoadTilesAsYouMove+4Ep
		tst.b	(a2)
		beq.s	locret_69B0
		bclr	#0,(a2)
		beq.s	loc_6966
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	CalculateVRAMPosition2
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_6D8C

loc_6966:				; CODE XREF: sub_694C+8j
		bclr	#1,(a2)
		beq.s	loc_6980
		move.w	#$E0,d4	; 'à'
		moveq	#$FFFFFFF0,d5
		bsr.w	CalculateVRAMPosition2
		move.w	#$E0,d4	; 'à'
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_6D8C

loc_6980:				; CODE XREF: sub_694C+1Ej
		bclr	#2,(a2)
		beq.s	loc_6996
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	CalculateVRAMPosition2
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_6CFE

loc_6996:				; CODE XREF: sub_694C+38j
		bclr	#3,(a2)
		beq.s	locret_69B0
		moveq	#$FFFFFFF0,d4
		move.w	#$140,d5
		bsr.w	CalculateVRAMPosition2
		moveq	#$FFFFFFF0,d4
		move.w	#$140,d5
		bsr.w	sub_6CFE

locret_69B0:				; CODE XREF: sub_694C+2j sub_694C+4Ej
		rts
; End of function sub_694C


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_69B2:				; CODE XREF: ROM:0000683Cp
					; LoadTilesAsYouMove+1Cp
		tst.b	(a2)
		beq.w	locret_6A80
		bclr	#0,(a2)
		beq.s	loc_69CE
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	CalculateVRAMPosition
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_6D8C

loc_69CE:				; CODE XREF: sub_69B2+Aj
		bclr	#1,(a2)
		beq.s	loc_69E8
		move.w	#$E0,d4	; 'à'
		moveq	#$FFFFFFF0,d5
		bsr.w	CalculateVRAMPosition
		move.w	#$E0,d4	; 'à'
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_6D8C

loc_69E8:				; CODE XREF: sub_69B2+20j
		bclr	#2,(a2)
		beq.s	loc_69FE
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	CalculateVRAMPosition
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_6CFE

loc_69FE:				; CODE XREF: sub_69B2+3Aj
		bclr	#3,(a2)
		beq.s	loc_6A18
		moveq	#$FFFFFFF0,d4
		move.w	#$140,d5
		bsr.w	CalculateVRAMPosition
		moveq	#$FFFFFFF0,d4
		move.w	#$140,d5
		bsr.w	sub_6CFE

loc_6A18:				; CODE XREF: sub_69B2+50j
		bclr	#4,(a2)
		beq.s	loc_6A30
		moveq	#$FFFFFFF0,d4
		moveq	#0,d5
		bsr.w	CalculateVRAMPosition_Absolute
		moveq	#$FFFFFFF0,d4
		moveq	#0,d5
		moveq	#$1F,d6
		bsr.w	sub_6D90

loc_6A30:				; CODE XREF: sub_69B2+6Aj
		bclr	#5,(a2)
		beq.s	loc_6A4C
		move.w	#$E0,d4	; 'à'
		moveq	#0,d5
		bsr.w	CalculateVRAMPosition_Absolute
		move.w	#$E0,d4	; 'à'
		moveq	#0,d5
		moveq	#$1F,d6
		bsr.w	sub_6D90

loc_6A4C:				; CODE XREF: sub_69B2+82j
		bclr	#6,(a2)
		beq.s	loc_6A64
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	CalculateVRAMPosition
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		moveq	#$1F,d6
		bsr.w	sub_6D84

loc_6A64:				; CODE XREF: sub_69B2+9Ej
		bclr	#7,(a2)
		beq.s	locret_6A80
		move.w	#$E0,d4	; 'à'
		moveq	#$FFFFFFF0,d5
		bsr.w	CalculateVRAMPosition
		move.w	#$E0,d4	; 'à'
		moveq	#$FFFFFFF0,d5
		moveq	#$1F,d6
		bsr.w	sub_6D84

locret_6A80:				; CODE XREF: sub_69B2+2j sub_69B2+B6j
		rts
; End of function sub_69B2


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6A82:				; CODE XREF: ROM:00006848j
					; LoadTilesAsYouMove+28p
		tst.b	(a2)
		beq.w	locret_6ACE
		cmpi.b	#5,(Current_Zone).w
		beq.w	loc_6AF2
		bclr	#0,(a2)
		beq.s	loc_6AAE
		move.w	#$70,d4	; 'p'
		moveq	#$FFFFFFF0,d5
		bsr.w	CalculateVRAMPosition
		move.w	#$70,d4	; 'p'
		moveq	#$FFFFFFF0,d5
		moveq	#2,d6
		bsr.w	sub_6D00

loc_6AAE:				; CODE XREF: sub_6A82+14j
		bclr	#1,(a2)
		beq.s	locret_6ACE
		move.w	#$70,d4	; 'p'
		move.w	#$140,d5
		bsr.w	CalculateVRAMPosition
		move.w	#$70,d4	; 'p'
		move.w	#$140,d5
		moveq	#2,d6
		bsr.w	sub_6D00

locret_6ACE:				; CODE XREF: sub_6A82+2j sub_6A82+30j
		rts
; ---------------------------------------------------------------------------
; Each row is assigned a background camera to determine how to draw it,
; see BGCameraSections for more information
; byte_6AD0:
SBZ_CameraSections:
		dcb.b	80/16, static1		; background 1 (clouds, static)
		dcb.b	160/16, dynamic3	; background 3 (furthest buildings)
		dcb.b	112/16, dynamic2	; background 2 (closer buildings)
		dcb.b	176/16, dynamic1	; background 1 (closest buildings)
		even
; ---------------------------------------------------------------------------

loc_6AF2:				; CODE XREF: sub_6A82+Cj
		moveq	#$FFFFFFF0,d4
		bclr	#0,(a2)
		bne.s	loc_6B04
		bclr	#1,(a2)
		beq.s	loc_6B4C
		move.w	#$E0,d4	; 'à'

loc_6B04:				; CODE XREF: sub_6A82+76j
		lea	SBZ_CameraSections+1(pc),a0
		move.w	(Camera_BG_Y_pos).w,d0
		add.w	d4,d0
		andi.w	#$1F0,d0
		lsr.w	#4,d0
		move.b	(a0,d0.w),d0
		lea	(word_6C78).l,a3
		movea.w	(a3,d0.w),a3
		beq.s	loc_6B38
		moveq	#$FFFFFFF0,d5
		movem.l	d4-d5,-(sp)
		bsr.w	CalculateVRAMPosition
		movem.l	(sp)+,d4-d5
		bsr.w	sub_6D8C
		bra.s	loc_6B4C
; ===========================================================================

loc_6B38:				; CODE XREF: sub_6A82+A0j
		moveq	#0,d5
		movem.l	d4-d5,-(sp)
		bsr.w	CalculateVRAMPosition_Absolute
		movem.l	(sp)+,d4-d5
		moveq	#$1F,d6
		bsr.w	sub_6D90

loc_6B4C:				; CODE XREF: sub_6A82+7Cj sub_6A82+B4j
		tst.b	(a2)
		bne.s	loc_6B52
		rts
; ===========================================================================

loc_6B52:				; CODE XREF: sub_6A82+CCj
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		move.b	(a2),d0
		andi.b	#$A8,d0
		beq.s	loc_6B66
		lsr.b	#1,d0
		move.b	d0,(a2)
		move.w	#$140,d5

loc_6B66:				; CODE XREF: sub_6A82+DAj
		lea	SBZ_CameraSections(pc),a0
		move.w	(Camera_BG_Y_pos).w,d0
		andi.w	#$1F0,d0
		lsr.w	#4,d0
		lea	(a0,d0.w),a0
		bra.w	loc_6C80
; End of function sub_6A82


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6B7C:				; CODE XREF: LoadTilesAsYouMove+34p
		tst.b	(a2)
		beq.w	locret_6BC8
		cmpi.b	#2,(Current_Zone).w
		beq.w	loc_6C0C
		bclr	#0,(a2)
		beq.s	loc_6BA8
		move.w	#$40,d4	; '@'
		moveq	#$FFFFFFF0,d5
		bsr.w	CalculateVRAMPosition
		move.w	#$40,d4	; '@'
		moveq	#$FFFFFFF0,d5
		moveq	#2,d6
		bsr.w	sub_6D00

loc_6BA8:				; CODE XREF: sub_6B7C+14j
		bclr	#1,(a2)
		beq.s	locret_6BC8
		move.w	#$40,d4	; '@'
		move.w	#$140,d5
		bsr.w	CalculateVRAMPosition
		move.w	#$40,d4	; '@'
		move.w	#$140,d5
		moveq	#2,d6
		bsr.w	sub_6D00

locret_6BC8:				; CODE XREF: sub_6B7C+2j sub_6B7C+30j
		rts
; ---------------------------------------------------------------------------
; Each row is assigned a background camera to determine how to draw it,
; see BGCameraSections for more information
; byte_6BCA:
MZ_CameraSections:
		dcb.b	16/16, static1		; background 1 (just above the screen, static)
		dcb.b	304/16, dynamic1	; background 1 (above ground)
		dcb.b	720/16, dynamic2	; background 2 (underground)
		even
; ---------------------------------------------------------------------------

loc_6C0C:				; CODE XREF: sub_6B7C+Cj
		moveq	#$FFFFFFF0,d4
		bclr	#0,(a2)
		bne.s	loc_6C1E
		bclr	#1,(a2)
		beq.s	loc_6C48
		move.w	#$E0,d4	; 'à'

loc_6C1E:				; CODE XREF: sub_6B7C+96j
		lea	MZ_CameraSections+1(pc),a0
		move.w	(Camera_BG_Y_pos).w,d0
		add.w	d4,d0
		andi.w	#$3F0,d0
		lsr.w	#4,d0
		move.b	(a0,d0.w),d0
		movea.w	word_6C78(pc,d0.w),a3
		moveq	#$FFFFFFF0,d5
		movem.l	d4-d5,-(sp)
		bsr.w	CalculateVRAMPosition
		movem.l	(sp)+,d4-d5
		bsr.w	sub_6D8C

loc_6C48:				; CODE XREF: sub_6B7C+9Cj
		tst.b	(a2)
		bne.s	loc_6C4E
		rts
; ===========================================================================

loc_6C4E:				; CODE XREF: sub_6B7C+CEj
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		move.b	(a2),d0
		andi.b	#$A8,d0
		beq.s	loc_6C62
		lsr.b	#1,d0
		move.b	d0,(a2)
		move.w	#$140,d5

loc_6C62:				; CODE XREF: sub_6B7C+DCj
		lea	MZ_CameraSections(pc),a0
		move.w	(Camera_BG_Y_pos).w,d0
		andi.w	#$7F0,d0
		lsr.w	#4,d0
		lea	(a0,d0.w),a0
		bra.w	loc_6C80
; ===========================================================================
word_6C78:	dc.w $EE68,$EE68,$EE70,$EE78; 0	; DATA XREF: sub_6A82+96o
; ===========================================================================

loc_6C80:				; CODE XREF: sub_6A82+F6j sub_6B7C+F8j
		tst.w	(Two_player_mode).w
		bne.s	loc_6CC2
		moveq	#$F,d6
		move.l	#$800000,d7

loc_6C8E:				; CODE XREF: sub_6B7C+13Ej
		moveq	#0,d0
		move.b	(a0)+,d0
		btst	d0,(a2)
		beq.s	loc_6CB6
		movea.w	word_6C78(pc,d0.w),a3
		movem.l	d4-d5/a0,-(sp)
		movem.l	d4-d5,-(sp)
		bsr.w	sub_7040
		movem.l	(sp)+,d4-d5
		bsr.w	CalculateVRAMPosition
		bsr.w	sub_6F70
		movem.l	(sp)+,d4-d5/a0

loc_6CB6:				; CODE XREF: sub_6B7C+118j
		addi.w	#$10,d4
		dbf	d6,loc_6C8E
		clr.b	(a2)
		rts
; ===========================================================================

loc_6CC2:				; CODE XREF: sub_6B7C+108j
		moveq	#$F,d6
		move.l	#$800000,d7

loc_6CCA:				; CODE XREF: sub_6B7C+17Aj
		moveq	#0,d0
		move.b	(a0)+,d0
		btst	d0,(a2)
		beq.s	loc_6CF2
		movea.w	word_6C78(pc,d0.w),a3
		movem.l	d4-d5/a0,-(sp)
		movem.l	d4-d5,-(sp)
		bsr.w	sub_7040
		movem.l	(sp)+,d4-d5
		bsr.w	CalculateVRAMPosition
		bsr.w	sub_6FF6
		movem.l	(sp)+,d4-d5/a0

loc_6CF2:				; CODE XREF: sub_6B7C+154j
		addi.w	#$10,d4
		dbf	d6,loc_6CCA
		clr.b	(a2)
		rts
; End of function sub_6B7C


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6CFE:				; CODE XREF: LoadTilesAsYouMove+E0p
					; LoadTilesAsYouMove+FAp ...
		moveq	#$F,d6
; End of function sub_6CFE


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6D00:				; CODE XREF: sub_6A82+28p sub_6A82+48p ...
		add.w	(a3),d5
		add.w	4(a3),d4
		move.l	#$800000,d7
		move.l	d0,d1
		bsr.w	sub_6E98
		tst.w	(Two_player_mode).w
		bne.s	loc_6D4E

loc_6D18:				; CODE XREF: sub_6D00:loc_6D48j
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		lea	(Block_Table).w,a1
		adda.w	d3,a1
		move.l	d1,d0
		bsr.w	sub_6F70
		adda.w	#$10,a0
		addi.w	#$100,d1
		andi.w	#$FFF,d1
		addi.w	#$10,d4
		move.w	d4,d0
		andi.w	#$70,d0	; 'p'
		bne.s	loc_6D48
		bsr.w	sub_6E98

loc_6D48:				; CODE XREF: sub_6D00+42j
		dbf	d6,loc_6D18
		rts
; ===========================================================================

loc_6D4E:				; CODE XREF: sub_6D00+16j
					; sub_6D00:loc_6D7Ej
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		lea	(Block_Table).w,a1
		adda.w	d3,a1
		move.l	d1,d0
		bsr.w	sub_6FF6
		adda.w	#$10,a0
		addi.w	#$80,d1	; '€'
		andi.w	#$FFF,d1
		addi.w	#$10,d4
		move.w	d4,d0
		andi.w	#$70,d0	; 'p'
		bne.s	loc_6D7E
		bsr.w	sub_6E98

loc_6D7E:				; CODE XREF: sub_6D00+78j
		dbf	d6,loc_6D4E
		rts
; End of function sub_6D00


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6D84:				; CODE XREF: sub_69B2+AEp sub_69B2+CAp ...
		add.w	(a3),d5
		add.w	4(a3),d4
		bra.s	loc_6D94
; End of function sub_6D84


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6D8C:				; CODE XREF: LoadTilesAsYouMove+82p
					; LoadTilesAsYouMove+B0p ...
		moveq	#$15,d6
		add.w	(a3),d5
; End of function sub_6D8C


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6D90:				; CODE XREF: sub_69B2+7Ap sub_69B2+96p ...
		add.w	4(a3),d4

loc_6D94:				; CODE XREF: sub_6D84+6j
		tst.w	(Two_player_mode).w
		bne.s	loc_6E12
		move.l	a2,-(sp)
		move.w	d6,-(sp)
		lea	(Block_cache).w,a2
		move.l	d0,d1
		or.w	d2,d1
		swap	d1
		move.l	d1,-(sp)
		move.l	d1,(a5)
		swap	d1
		bsr.w	sub_6E98

loc_6DB2:				; CODE XREF: sub_6D90:loc_6DE4j
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		lea	(Block_Table).w,a1
		adda.w	d3,a1
		bsr.w	sub_6ED0
		addq.w	#2,a0
		addq.b	#4,d1
		bpl.s	loc_6DD4
		andi.b	#$7F,d1	; ''
		swap	d1
		move.l	d1,(a5)
		swap	d1

loc_6DD4:				; CODE XREF: sub_6D90+38j
		addi.w	#$10,d5
		move.w	d5,d0
		andi.w	#$70,d0	; 'p'
		bne.s	loc_6DE4
		bsr.w	sub_6E98

loc_6DE4:				; CODE XREF: sub_6D90+4Ej
		dbf	d6,loc_6DB2
		move.l	(sp)+,d1
		addi.l	#$800000,d1
		lea	(Block_cache).w,a2
		move.l	d1,(a5)
		swap	d1
		move.w	(sp)+,d6

loc_6DFA:				; CODE XREF: sub_6D90:loc_6E0Aj
		move.l	(a2)+,(a6)
		addq.b	#4,d1
		bmi.s	loc_6E0A
		ori.b	#$80,d1
		swap	d1
		move.l	d1,(a5)
		swap	d1

loc_6E0A:				; CODE XREF: sub_6D90+6Ej
		dbf	d6,loc_6DFA
		movea.l	(sp)+,a2
		rts
; ===========================================================================

loc_6E12:				; CODE XREF: sub_6D90+8j
		move.l	d0,d1
		or.w	d2,d1
		swap	d1
		move.l	d1,(a5)
		swap	d1
		tst.b	d1
		bmi.s	loc_6E5C
		bsr.w	sub_6E98

loc_6E24:				; CODE XREF: sub_6D90:loc_6E56j
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		lea	(Block_Table).w,a1
		adda.w	d3,a1
		bsr.w	sub_6F32
		addq.w	#2,a0
		addq.b	#4,d1
		bpl.s	loc_6E46
		andi.b	#$7F,d1	; ''
		swap	d1
		move.l	d1,(a5)
		swap	d1

loc_6E46:				; CODE XREF: sub_6D90+AAj
		addi.w	#$10,d5
		move.w	d5,d0
		andi.w	#$70,d0	; 'p'
		bne.s	loc_6E56
		bsr.w	sub_6E98

loc_6E56:				; CODE XREF: sub_6D90+C0j
		dbf	d6,loc_6E24
		rts
; ===========================================================================

loc_6E5C:				; CODE XREF: sub_6D90+8Ej
		bsr.w	sub_6E98

loc_6E60:				; CODE XREF: sub_6D90:loc_6E92j
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		lea	(Block_Table).w,a1
		adda.w	d3,a1
		bsr.w	sub_6F32
		addq.w	#2,a0
		addq.b	#4,d1
		bmi.s	loc_6E82
		ori.b	#$80,d1
		swap	d1
		move.l	d1,(a5)
		swap	d1

loc_6E82:				; CODE XREF: sub_6D90+E6j
		addi.w	#$10,d5
		move.w	d5,d0
		andi.w	#$70,d0	; 'p'
		bne.s	loc_6E92
		bsr.w	sub_6E98

loc_6E92:				; CODE XREF: sub_6D90+FCj
		dbf	d6,loc_6E60
		rts
; End of function sub_6D90


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6E98:				; CODE XREF: sub_6D00+Ep sub_6D00+44p	...
		movem.l	d4-d5,-(sp)
		move.w	d4,d3
		add.w	d3,d3
		andi.w	#$F00,d3
		lsr.w	#3,d5
		move.w	d5,d0
		lsr.w	#4,d0
		andi.w	#$7F,d0	; ''
		add.w	d3,d0
		moveq	#$FFFFFFFF,d3
		move.b	(a4,d0.w),d3
		andi.w	#$FF,d3
		lsl.w	#7,d3
		andi.w	#$70,d4	; 'p'
		andi.w	#$E,d5
		add.w	d4,d3
		add.w	d5,d3
		movea.l	d3,a0
		movem.l	(sp)+,d4-d5
		rts
; End of function sub_6E98


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6ED0:				; CODE XREF: sub_6D90+30p
		btst	#3,(a0)
		bne.s	loc_6EFC
		btst	#2,(a0)
		bne.s	loc_6EE2
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a2)+
		rts
; ===========================================================================

loc_6EE2:				; CODE XREF: sub_6ED0+Aj
		move.l	(a1)+,d3
		eori.l	#$8000800,d3
		swap	d3
		move.l	d3,(a6)
		move.l	(a1)+,d3
		eori.l	#$8000800,d3
		swap	d3
		move.l	d3,(a2)+
		rts
; ===========================================================================

loc_6EFC:				; CODE XREF: sub_6ED0+4j
		btst	#2,(a0)
		bne.s	loc_6F18
		move.l	(a1)+,d0
		move.l	(a1)+,d3
		eori.l	#$10001000,d3
		move.l	d3,(a6)
		eori.l	#$10001000,d0
		move.l	d0,(a2)+
		rts
; ===========================================================================

loc_6F18:				; CODE XREF: sub_6ED0+30j
		move.l	(a1)+,d0
		move.l	(a1)+,d3
		eori.l	#$18001800,d3
		swap	d3
		move.l	d3,(a6)
		eori.l	#$18001800,d0
		swap	d0
		move.l	d0,(a2)+
		rts
; End of function sub_6ED0


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6F32:				; CODE XREF: sub_6D90+A2p sub_6D90+DEp
		btst	#3,(a0)
		bne.s	loc_6F50
		btst	#2,(a0)
		bne.s	loc_6F42
		move.l	(a1)+,(a6)
		rts
; ===========================================================================

loc_6F42:				; CODE XREF: sub_6F32+Aj
		move.l	(a1)+,d3
		eori.l	#$8000800,d3
		swap	d3
		move.l	d3,(a6)
		rts
; ===========================================================================

loc_6F50:				; CODE XREF: sub_6F32+4j
		btst	#2,(a0)
		bne.s	loc_6F62
		move.l	(a1)+,d3
		eori.l	#$10001000,d3
		move.l	d3,(a6)
		rts
; ===========================================================================

loc_6F62:				; CODE XREF: sub_6F32+22j
		move.l	(a1)+,d3
		eori.l	#$18001800,d3
		swap	d3
		move.l	d3,(a6)
		rts
; End of function sub_6F32


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6F70:				; CODE XREF: sub_6B7C+132p
					; sub_6D00+28p
		or.w	d2,d0
		swap	d0
		btst	#3,(a0)
		bne.s	loc_6FAC
		btst	#2,(a0)
		bne.s	loc_6F8C
		move.l	d0,(a5)
		move.l	(a1)+,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.l	(a1)+,(a6)
		rts
; ===========================================================================

loc_6F8C:				; CODE XREF: sub_6F70+Ej
		move.l	d0,(a5)
		move.l	(a1)+,d3
		eori.l	#$8000800,d3
		swap	d3
		move.l	d3,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.l	(a1)+,d3
		eori.l	#$8000800,d3
		swap	d3
		move.l	d3,(a6)
		rts
; ===========================================================================

loc_6FAC:				; CODE XREF: sub_6F70+8j
		btst	#2,(a0)
		bne.s	loc_6FD2
		move.l	d5,-(sp)
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d3
		eori.l	#$10001000,d3
		move.l	d3,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$10001000,d5
		move.l	d5,(a6)
		move.l	(sp)+,d5
		rts
; ===========================================================================

loc_6FD2:				; CODE XREF: sub_6F70+40j
		move.l	d5,-(sp)
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d3
		eori.l	#$18001800,d3
		swap	d3
		move.l	d3,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$18001800,d5
		swap	d5
		move.l	d5,(a6)
		move.l	(sp)+,d5
		rts
; End of function sub_6F70


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6FF6:				; CODE XREF: sub_6B7C+16Ep
					; sub_6D00+5Ep
		or.w	d2,d0
		swap	d0
		btst	#3,(a0)
		bne.s	loc_701C
		btst	#2,(a0)
		bne.s	loc_700C
		move.l	d0,(a5)
		move.l	(a1)+,(a6)
		rts
; ===========================================================================

loc_700C:				; CODE XREF: sub_6FF6+Ej
		move.l	d0,(a5)
		move.l	(a1)+,d3
		eori.l	#$8000800,d3
		swap	d3
		move.l	d3,(a6)
		rts
; ===========================================================================

loc_701C:				; CODE XREF: sub_6FF6+8j
		btst	#2,(a0)
		bne.s	loc_7030
		move.l	d0,(a5)
		move.l	(a1)+,d3
		eori.l	#$10001000,d3
		move.l	d3,(a6)
		rts
; ===========================================================================

loc_7030:				; CODE XREF: sub_6FF6+2Aj
		move.l	d0,(a5)
		move.l	(a1)+,d3
		eori.l	#$18001800,d3
		swap	d3
		move.l	d3,(a6)
		rts
; End of function sub_6FF6


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_7040:				; CODE XREF: sub_6B7C+126p
					; sub_6B7C+162p
		add.w	(a3),d5
		add.w	4(a3),d4
		lea	(Block_Table).w,a1
		move.w	d4,d3
		add.w	d3,d3
		andi.w	#$F00,d3
		lsr.w	#3,d5
		move.w	d5,d0
		lsr.w	#4,d0
		andi.w	#$7F,d0	; ''
		add.w	d3,d0
		moveq	#$FFFFFFFF,d3
		move.b	(a4,d0.w),d3
		andi.w	#$FF,d3
		lsl.w	#7,d3
		andi.w	#$70,d4	; 'p'
		andi.w	#$E,d5
		add.w	d4,d3
		add.w	d5,d3
		movea.l	d3,a0
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		adda.w	d3,a1
		rts
; End of function sub_7040


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
; sub_7084:
CalculateVRAMPosition:
		add.w	(a3),d5
; sub_7086:
CalculateVRAMPosition_Absolute:
		tst.w	(Two_player_mode).w
		bne.s	CalculateVRAMPosition_TwoPlayer
		add.w	4(a3),d4
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#3,d0
		swap	d0
		move.w	d4,d0
		rts
; ===========================================================================
; loc_70A6:
CalculateVRAMPosition_TwoPlayer:
		add.w	4(a3),d4
		andi.w	#$1F0,d4
		andi.w	#$1F0,d5
		lsl.w	#3,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#3,d0
		swap	d0
		move.w	d4,d0
		rts
; End of function CalculateVRAMPosition


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
; sub_70C0:
CalculateVRAMPosition2:
		tst.w	(Two_player_mode).w
		bne.s	CalculateVRAMPosition2_PlayerTwo
		add.w	4(a3),d4
		add.w	(a3),d5
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#2,d0
		swap	d0
		move.w	d4,d0
		rts
; ===========================================================================
; In Sonic 1, this was unused but was part of an abandoned set of functions
; that would effectively create a third scrolling layer (at the cost of the
; background appearing cut-off at the bottom), similar to one that was seen
; in the Tokyo Toy Show '90 demo
;
; Now, it is instead used to draw player two's screen in interlaced mode
; loc_70E2:
CalculateVRAMPosition2_PlayerTwo:
		add.w	4(a3),d4
		add.w	(a3),d5
		andi.w	#$1F0,d4
		andi.w	#$1F0,d5
		lsl.w	#3,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#2,d0
		swap	d0
		move.w	d4,d0
		rts
; End of function CalculateVRAMPosition2

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load the level's initial state into VRAM; the final game
; would considerably cut down on this, instead just loading the background
; while the foreground is loaded in DrawLevelTitleCard
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


LoadTilesFromStart:
		lea	(VDP_control_port).l,a5
		lea	(VDP_data_port).l,a6
		tst.w	(Two_player_mode).w	; is this two player mode?
		beq.s	loc_711E		; if not, branch
		lea	(Camera_X_pos_P2).w,a3
		lea	(Level_Layout).w,a4
		move.w	#$6000,d2
		bsr.s	LoadTilesFromStart_2p

loc_711E:
		lea	(Camera_X_pos).w,a3
		lea	(Level_Layout).w,a4
		move.w	#$4000,d2
		bsr.s	LoadTilesFromStart2
		lea	(Camera_BG_X_pos).w,a3
		lea	(Level_Layout+levelrowsize).w,a4
		move.w	#$6000,d2
		tst.b	(Current_Zone).w
		beq.w	DrawBackground_GHZ

LoadTilesFromStart2:
		moveq	#-16,d4
		moveq	#256/16-1,d6

loc_7144:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	CalculateVRAMPosition
		move.w	d1,d4
		moveq	#0,d5
		moveq	#512/16-1,d6
		move	#$2700,sr
		bsr.w	sub_6D84
		move	#$2300,sr
		movem.l	(sp)+,d4-d6
		addi.w	#16,d4
		dbf	d6,loc_7144
		rts
; ---------------------------------------------------------------------------
; This is still in the final game, unused
LoadTilesFromStart_2p:
		moveq	#-16,d4
		moveq	#256/16-1,d6

loc_7174:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	CalculateVRAMPosition2
		move.w	d1,d4
		moveq	#0,d5
		moveq	#512/16-1,d6
		move	#$2700,sr
		bsr.w	sub_6D84
		move	#$2300,sr
		movem.l	(sp)+,d4-d6
		addi.w	#16,d4
		dbf	d6,loc_7174
		rts
; End of function LoadTilesFromStart

; ===========================================================================
; ---------------------------------------------------------------------------
; Stage-specific background drawing routines
; Green Hill Zone
; ---------------------------------------------------------------------------
; loc_71A0:
DrawBackground_GHZ:
		moveq	#0,d4		; start drawing at the top of the screen
		moveq	#$F,d6		; 16 blocks per column
; loc_71A4:
.drawRow:
		movem.l	d4-d6,-(sp)
		lea	(GHZ_CameraSections).l,a0
		move.w	(Camera_BG_Y_pos).w,d0
		add.w	d4,d0
		andi.w	#$F0,d0
		bsr.w	Draw_BackgroundRow
		movem.l	(sp)+,d4-d6
		; after we finish drawing the current row, head down to the next one
		addi.w	#16,d4
		dbf	d6,.drawRow
		rts
; ---------------------------------------------------------------------------
; Each row is assigned a background camera to determine how to draw it,
; see BGCameraSections for more information
; byte_71CA:
GHZ_CameraSections:
		dcb.b	64/16, static1		; background 1 (clouds, static)
		dcb.b	48/16, dynamic3		; background 3 (mountains)
		dcb.b	48/16, dynamic2		; background 2 (hills/bushes)
		dcb.b	96/16, static1		; background 1 (water, static)
; End of function DrawBackground_GHZ

; ---------------------------------------------------------------------------
; Marble Zone
; ---------------------------------------------------------------------------
; loc_71DA:
DrawBackground_MZ:
		moveq	#-16,d4		; start drawing just above the top of the screen
		moveq	#$F,d6		; 16 blocks per column

loc_71DE:
		movem.l	d4-d6,-(sp)
		lea	MZ_CameraSections+1(pc),a0
		move.w	(Camera_BG_Y_pos).w,d0
		add.w	d4,d0
		andi.w	#$3F0,d0
		bsr.w	Draw_BackgroundRow
		movem.l	(sp)+,d4-d6
		; after we finish drawing the current row, head down to the next one
		addi.w	#16,d4
		dbf	d6,loc_71DE
		rts
; End of function DrawBackground_MZ

; ---------------------------------------------------------------------------
; Scrap Brain Zone
; ---------------------------------------------------------------------------
; loc_7200:
DrawBackground_SBZ:
		moveq	#-16,d4		; start drawing just above the top of the screen
		moveq	#$F,d6		; 16 blocks per column

loc_7206:
		movem.l	d4-d6,-(sp)
		lea	SBZ_CameraSections+1(pc),a0
		move.w	(Camera_BG_Y_pos).w,d0
		add.w	d4,d0
		andi.w	#$1F0,d0
		bsr.w	Draw_BackgroundRow
		movem.l	(sp)+,d4-d6
		; after we finish drawing the current row, head down to the next one
		addi.w	#16,d4
		dbf	d6,loc_7206
		rts
; End of function DrawBackground_MZ

; ===========================================================================
; This is a lookup table which the game uses to know what background the
; block rows should update their tiles relative to, allowing for larger
; backgrounds than normally possible.
; word_722A:
BGCameraSections:
		dc.w Camera_BG_X_pos		; Background A (static)
		dc.w Camera_BG_X_pos		; Background A (dynamic)
		dc.w Camera_BG2_X_pos		; Background B (dynamic)
		dc.w Camera_BG3_X_pos		; Background C (dynamic)

; ---------------------------------------------------------------------------
; Subroutine to draw background block rows depending on the camera type
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_7232:
Draw_BackgroundRow:
		lsr.w	#4,d0
		move.b	(a0,d0.w),d0
		movea.w	BGCameraSections(pc,d0.w),a3	; get camera type
		beq.s	.staticRow		; if it's staic, branch

		moveq	#-16,d5			; start drawing a row of blocks
		movem.l	d4-d5,-(sp)
		bsr.w	CalculateVRAMPosition
		movem.l	(sp)+,d4-d5
		move	#$2700,sr
		bsr.w	sub_6D8C
		move	#$2300,sr
		rts
; ---------------------------------------------------------------------------
; loc_725A:
.staticRow:
		moveq	#0,d5			; draw a static row of blocks
		movem.l	d4-d5,-(sp)
		bsr.w	CalculateVRAMPosition_Absolute
		movem.l	(sp)+,d4-d5
		moveq	#$1F,d6
		bsr.w	sub_6D90
		rts
; End of function Draw_BackgroundRow