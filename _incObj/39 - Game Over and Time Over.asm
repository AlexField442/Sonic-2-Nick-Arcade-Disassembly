; ===========================================================================
; ---------------------------------------------------------------------------
; Object 39 - Game Over/Time Over text
;
; Internal name: "over"
; ---------------------------------------------------------------------------
; Sprite_BA84: Obj39:
Obj_GameOver:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	GameOver_Index(pc,d0.w),d1
		jmp	GameOver_Index(pc,d1.w)
; ===========================================================================
; Obj39_Index:
GameOver_Index:	dc.w GameOver_Init-GameOver_Index
		dc.w GameOver_Move-GameOver_Index
		dc.w GameOver_Wait-GameOver_Index
; ===========================================================================
; loc_BA98:
GameOver_Init:
		tst.l	(Plc_Buffer).w	; are the pattern load cues empty?
		beq.s	loc_BAA0	; if yes, branch
		rts
; ===========================================================================

loc_BAA0:
		addq.b	#2,routine(a0)
		move.w	#$50,x_pixel(a0)
		btst	#0,mapping_frame(a0)
		beq.s	loc_BAB8
		move.w	#$1F0,8(a0)

loc_BAB8:
		move.w	#$F0,y_pixel(a0)
		move.l	#Map_Obj39,mappings(a0)
		move.w	#$855E,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#0,render_flags(a0)
		move.b	#0,priority(a0)
; loc_BADC:
GameOver_Move:
		moveq	#$10,d1
		cmpi.w	#$120,x_pixel(a0)
		beq.s	loc_BAF2
		bcs.s	loc_BAEA
		neg.w	d1

loc_BAEA:
		add.w	d1,x_pixel(a0)
		bra.w	DisplaySprite
; ===========================================================================

loc_BAF2:
		move.w	#$2D0,anim_frame_duration(a0)
		addq.b	#2,routine(a0)
		; This should be a branch to DisplaySprite; as a result,
		; the text flickers for a frame when the words combine.
		rts
; ===========================================================================
; loc_BAFE:
GameOver_Wait:
		move.b	(Ctrl_1_Press).w,d0
		andi.b	#$70,d0
		bne.s	loc_BB1E
		btst	#0,mapping_frame(a0)
		bne.s	loc_BB42
		tst.w	anim_frame_duration(a0)
		beq.s	loc_BB1E
		subq.w	#1,anim_frame_duration(a0)
		bra.w	DisplaySprite
; ===========================================================================

loc_BB1E:
		tst.b	(Time_Over_flag).w
		bne.s	loc_BB38
		move.b	#GameModeID_ContinueScreen,(Game_Mode).w
		tst.b	(Continue_count).w
		bne.s	loc_BB42
		move.b	#GameModeID_SegaScreen,(Game_Mode).w
		bra.s	loc_BB42
; ===========================================================================

loc_BB38:
		clr.l	(Saved_Timer).w
		move.w	#1,(Level_Inactive_flag).w

loc_BB42:
		bra.w	DisplaySprite