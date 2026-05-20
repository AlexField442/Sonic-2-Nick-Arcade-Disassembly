; ===========================================================================
; ===========================================================================
; ---------------------------------------------------------------------------
; Object 04 - Surface of the water
; Internal name: "water"
; ---------------------------------------------------------------------------
; OST:
water_origX:			equ $30 ; word ; leftover from Sonic 1
water_freeze:			equ $32 ; byte ; 0 = animation, 1 = no animation
; ---------------------------------------------------------------------------
; Sprite_154D4: Obj04:
Obj_WaterSurface:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	WaterSurface_Index(pc,d0.w),d1
		jmp	WaterSurface_Index(pc,d1.w)
; ===========================================================================
; off_154E2: Obj04_Index:
WaterSurface_Index:
		dc.w WaterSurface_Init-WaterSurface_Index
		dc.w WaterSurface_Main-WaterSurface_Index
; ===========================================================================
; loc_154E6: Obj04_Init:
WaterSurface_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_WaterSurface,mappings(a0)
		move.w	#$8400,art_tile(a0)
		bsr.w	JmpTo_Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$80,width_pixels(a0)
		move.w	x_pos(a0),water_origX(a0)
; loc_1550E: Obj04_Main:
WaterSurface_Main:
		move.w	(Water_Level_1).w,d1
		move.w	d1,y_pos(a0)
		tst.b	water_freeze(a0)
		bne.s	WaterSurface_Animate
		btst	#7,(Ctrl_1_Press).w	; is Start button pressed?
		beq.s	WaterSurface_Display	; if not, branch
		addq.b	#3,mapping_frame(a0)	; use different frames
		move.b	#1,water_freeze(a0)	; stop animation
		bra.s	WaterSurface_Display
; ===========================================================================
; loc_15530:
WaterSurface_Animate:
		tst.w	(Game_paused).w		; is the game paused?
		bne.s	WaterSurface_Display	; if yes, branch
		move.b	#0,water_freeze(a0)	; resume animation
		subq.b	#3,mapping_frame(a0)	; use normal frames
; loc_15540:
WaterSurface_Display:
		lea	(Ani_WaterSurface).l,a1
		moveq	#0,d1
		move.b	anim_frame(a0),d1
		move.b	(a1,d1.w),mapping_frame(a0)
		addq.b	#1,anim_frame(a0)
		andi.b	#$3F,anim_frame(a0)
		bra.w	JmpTo3_DisplaySprite
; ===========================================================================
; ---------------------------------------------------------------------------
; animation script (custom format, only has frame data)
; ---------------------------------------------------------------------------
; byte_15560: Obj04_FrameData:
Ani_WaterSurface:
		dc.b   0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1
		dc.b   1,  2,  1,  2,  1,  2,  1,  2,  1,  2,  1,  2,  1,  2,  1,  2
		dc.b   2,  1,  2,  1,  2,  1,  2,  1,  2,  1,  2,  1,  2,  1,  2,  1
		dc.b   1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj04:
MapUnc_WaterSurface:	include	"mappings/sprite/Water Surface.asm"