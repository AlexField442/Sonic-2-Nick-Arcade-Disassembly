; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to set level boundaries and start positions
; ---------------------------------------------------------------------------
; sub_5720:
LevelSizeLoad:
		clr.w	(Scroll_flags).w
		clr.w	(Scroll_flags_BG).w
		clr.w	(Scroll_flags_BG2).w
		clr.w	(Scroll_flags_BG3).w
		clr.w	(Scroll_flags_P2).w
		clr.w	(Scroll_flags_BG_P2).w
		clr.w	(Scroll_flags_BG2_P2).w
		clr.w	(Scroll_flags_BG3_P2).w
		clr.w	(Scroll_flags_copy).w
		clr.w	(Scroll_flags_BG_copy).w
		clr.w	(Scroll_flags_BG2_copy).w
		clr.w	(Scroll_flags_BG3_copy).w
		clr.w	(Scroll_flags_copy_P2).w
		clr.w	(Scroll_flags_BG_copy_P2).w
		clr.w	(Scroll_flags_BG2_copy_P2).w
		clr.w	(Scroll_flags_BG3_copy_P2).w
		clr.b	(Deform_lock).w
		moveq	#0,d0
		move.b	d0,(Dynamic_Resize_Routine).w
		move.w	(Current_ZoneAndAct).w,d0
		lsl.b	#6,d0
		lsr.w	#3,d0
		lea	LevelSizeArray(pc,d0.w),a0
		move.l	(a0)+,d0
		move.l	d0,(Camera_Min_X_pos).w
		move.l	d0,(Camera_Min_X_pos_target).w
		move.l	(a0)+,d0
		move.l	d0,(Camera_Min_Y_pos).w
		move.l	d0,(Camera_Min_Y_pos_target).w
		move.w	#$1010,(Horiz_block_crossed_flag).w
		move.w	#$60,(Camera_Y_pos_bias).w
		bra.w	LevelSize_CheckLamp
; ===========================================================================
; dword_579A:
LevelSizeArray:
		dc.w	 0,  $24BF,     0,	$300		; GHZ1
		dc.w	 0,  $1EBF,     0,	$300		; GHZ2
		dc.w	 0,  $2960,     0,	$300		; GHZ3
		dc.w	 0,  $2ABF,     0,	$300		; GHZ4
		dc.w	 0,  $3FFF,     0,	$720		; LZ1
		dc.w	 0,  $3FFF,     0,	$720		; LZ2
		dc.w	 0,  $3FFF,     0,	$720		; LZ3
		dc.w	 0,  $3FFF,     0,	$720		; LZ4
		dc.w	 0,  $3FFF,     0,	$720		; CPZ1
		dc.w	 0,  $3FFF,     0,	$720		; CPZ2
		dc.w	 0,  $3FFF,     0,	$720		; CPZ3
		dc.w	 0,  $3FFF,     0,	$720		; CPZ4
		dc.w	 0,  $29A0,     0,	$320		; EHZ1
		dc.w	 0,  $2940,     0,	$420		; EHZ2
		; This level size fits perfectly with Hill Top, implying that
		; it used to occupy Emerald Hill 3 and 4 before overwriting
		; Sonic 1's Scrap Brain Zone
		dc.w	 0,  $25C0,     0,	$720		; EHZ3
		dc.w	 0,  $3FFF,     0,	$720		; EHZ4
		dc.w	 0,  $3FFF,     0,	$720		; HPZ1
		dc.w	 0,  $3FFF,     0,	$720		; HPZ2
		dc.w	 0,  $3FFF,     0,	$720		; HPZ3
		dc.w	 0,  $3FFF,     0,	$720		; HPZ4
		dc.w	 0,  $3FFF,     0,	$720		; HTZ1
		dc.w	 0,  $3FFF, -$100,	$720		; HTZ2
		dc.w $2080,  $3FFF,  $510,	$720		; HTZ3
		dc.w	 0,  $3FFF,     0,	$720		; HTZ4
		dc.w	 0,  $500,   $110,	$110		; S1 Ending 1
		dc.w	 0,  $DC0,   $110,	$110		; S1 Ending 2
		dc.w	 0,  $2FFF,     0,	$320		; S1 Ending 3
		dc.w	 0,  $2FFF,     0,	$320		; S1 Ending 4
; ===========================================================================
; dword_587A:
S1EndingStartLoc:
		dc.w	$50,	$3B0	; GHZ1-1
		dc.w	$EA0,	$46C	; MZ2
		dc.w	$1750,  $BD	; SYZ3
		dc.w	$A00,	$62C	; LZ3
		dc.w	$BB0,	$4C	; SLZ3
		dc.w	$1570,	$16C	; SBZ1
		dc.w	$1B0,	$72C	; SBZ2
		dc.w	$1400,	$2AC	; GHZ1-2
; ===========================================================================
; loc_589A:
LevelSize_CheckLamp:
		tst.b	(Last_star_pole_hit).w	; did Sonic hit any checkpoints?
		beq.s	LevelSize_StartLoc	; if not, branch

		jsr	(Checkpoint_LoadData).l
		move.w	(MainCharacter+x_pos).w,d1
		move.w	(MainCharacter+y_pos).w,d0
		bra.s	LevelSize_StartLocLoaded
; ===========================================================================
; loc_58B0:
LevelSize_StartLoc:
		move.w	(Current_ZoneAndAct).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	StartLocArray(pc,d0.w),a1	; load Sonic's start location
		tst.w	(Demo_mode_flag).w	; is this the credits demos?
		bpl.s	loc_58CE		; if not, branch

		move.w	(Ending_demo_number).w,d0
		subq.w	#1,d0
		lsl.w	#2,d0
		lea	S1EndingStartLoc(pc,d0.w),a1	; load credits start locations

loc_58CE:
		moveq	#0,d1
		move.w	(a1)+,d1
		move.w	d1,(MainCharacter+x_pos).w
		moveq	#0,d0
		move.w	(a1),d0
		move.w	d0,(MainCharacter+y_pos).w

LevelSize_StartLocLoaded:
		subi.w	#160,d1		; is Sonic more than 160px from left edge?
		bcc.s	loc_58E6	; if yes, branch
		moveq	#0,d1

loc_58E6:
		move.w	(Camera_Max_X_pos).w,d2
		cmp.w	d2,d1		; is Sonic inside the right edge?
		bcs.s	loc_58F0	; if yes, branch
		move.w	d2,d1

loc_58F0:
		move.w	d1,(Camera_X_pos).w	; set horizontal screen position
		move.w	d1,(Camera_X_pos_P2).w

		subi.w	#96,d0
		bcc.s	loc_5900
		moveq	#0,d0

loc_5900:
		cmp.w	(Camera_Max_Y_pos).w,d0	; is Sonic above the bottom edge?
		blt.s	loc_590A		; if yes, branch
		move.w	(Camera_Max_Y_pos).w,d0

loc_590A:
		move.w	d0,(Camera_Y_pos).w	; set vertical screen position
		move.w	d0,(Camera_Y_pos_P2).w
		bsr.w	BgScrollSpeed
		rts
; End of function LevelSizeLoad

; ===========================================================================
; ---------------------------------------------------------------------------
; Sonic start position array
;
; Most haven't been changed from Sonic 1, hence their names; placeholder entries
; use $0080, $00A8, whereas later versions use Emerald Hill's start positions
; ---------------------------------------------------------------------------
StartLocArray:	incbin	"startpos/GHZ_1.bin"		; GHZ1
		incbin	"startpos/GHZ_2.bin"		; GHZ2
		incbin	"startpos/GHZ_3.bin"		; GHZ3
		dc.w   $80,  $A8			; GHZ4
		incbin	"startpos/LZ_1.bin"		; LZ1
		incbin	"startpos/LZ_2.bin"		; LZ2
		incbin	"startpos/LZ_3.bin"		; LZ3
		incbin	"startpos/SBZ_3.bin"		; LZ4
		incbin	"startpos/CPZ_1.bin"		; CPZ1
		incbin	"startpos/MZ_2.bin"		; CPZ2
		incbin	"startpos/MZ_3.bin"		; CPZ3
		dc.w   $80,  $A8			; CPZ4
		incbin	"startpos/EHZ_1.bin"		; EHZ1
		incbin	"startpos/EHZ_2.bin"		; EHZ2
		incbin	"startpos/HTZ_1_OLD.bin"	; EHZ3
		dc.w   $80,  $A8			; EHZ4
		incbin	"startpos/HPZ_1.bin"		; HPZ1
		incbin	"startpos/SYZ_2.bin"		; HPZ2
		incbin	"startpos/SYZ_3.bin"		; HPZ3
		dc.w   $80,  $A8			; HPZ4
		incbin	"startpos/HTZ_1.bin"		; HTZ1
		incbin	"startpos/HTZ_2.bin"		; HTZ2
		incbin	"startpos/FZ.bin"		; HTZ3
		dc.w   $80,  $A8			; HTZ4
		incbin	"startpos/Good Ending.bin"	; S1 Ending (Good)
		incbin	"startpos/Bad Ending.bin"	; S1 Ending (Bad)
		dc.w   $80,  $A8			; S1 Ending 3
		dc.w   $80,  $A8			; S1 Ending 4