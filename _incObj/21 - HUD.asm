; ===========================================================================
; ---------------------------------------------------------------------------
; Object 21 - SCORE, TIME, RINGS
;
; Internal name: "score"
; ---------------------------------------------------------------------------
; Sprite_1B028: Obj21:
Obj_HUD:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	HUD_Index(pc,d0.w),d1
		jmp	HUD_Index(pc,d1.w)
; ===========================================================================
; Obj21_Index:
HUD_Index:	dc.w HUD_Init-HUD_Index
		dc.w HUD_Main-HUD_Index
; ===========================================================================
; Obj21_Init:
HUD_Init:
		addq.b	#2,routine(a0)
		move.w	#$90,x_pixel(a0)
		move.w	#$108,y_pixel(a0)
		move.l	#MapUnc_HUD,mappings(a0)
		move.w	#$6CA,art_tile(a0)
		bsr.w	j_Adjust2PArtPointer_8
		move.b	#0,render_flags(a0)
		move.b	#0,priority(a0)
; Obj21_Main:
HUD_Main:
		tst.w	(Ring_count).w
		beq.s	HUD_NoRings
		moveq	#0,d0
		btst	#3,(Level_frame_counter+1).w
		bne.s	HUD_Display
		cmpi.b	#9,(Timer_minute).w
		bne.s	HUD_Display
		addq.w	#2,d0
; loc_1B082: Obj21_Display:
HUD_Display:
		move.b	d0,mapping_frame(a0)
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------
; loc_1B08C: Obj21_NoRings:
HUD_NoRings:
		moveq	#0,d0
		btst	#3,(Level_frame_counter+1).w
		bne.s	HUD_Display2
		addq.w	#1,d0
		cmpi.b	#9,(Timer_minute).w
		bne.s	HUD_Display2
		addq.w	#2,d0
; loc_1B0A2: Obj21_Display2:
HUD_Display2:
		move.b	d0,mapping_frame(a0)
		jmp	(DisplaySprite).l
; ===========================================================================
; ---------------------------------------------------------------------------
; Sprite mappings - SCORE, TIME, RINGS
; ---------------------------------------------------------------------------
; Map_obj21:
MapUnc_HUD:	incbin	"mappings/sprite/obj21.bin"