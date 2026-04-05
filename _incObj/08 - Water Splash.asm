; ===========================================================================
; ---------------------------------------------------------------------------
; Object 08 - water splash
;
; Internal name: "exit2"
; ---------------------------------------------------------------------------
; Sprite_1255A: Obj08:
Obj_WaterSplash:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	WaterSplash_Index(pc,d0.w),d1
		jmp	WaterSplash_Index(pc,d1.w)
; ===========================================================================
; Obj08_Index:
WaterSplash_Index:	dc.w WaterSplash_Init-WaterSplash_Index
		dc.w WaterSplash_Display-WaterSplash_Index
		dc.w WaterSplash_Delete-WaterSplash_Index
; ===========================================================================
; Obj08_Init:
WaterSplash_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_WaterSplash,mappings(a0)
		ori.b	#4,render_flags(a0)
		move.b	#1,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.w	#$4259,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.w	(MainCharacter+x_pos).w,x_pos(a0)
; Obj08_Display:
WaterSplash_Display:
		move.w	(Water_Level_1).w,y_pos(a0)
		lea	(Ani_WaterSplash).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================
; Obj08_Delete:
WaterSplash_Delete:
		jmp	(DeleteObject).l

; ===========================================================================

include_Ani_WaterSplash:	macro
; animation script
; Ani_obj08:
Ani_WaterSplash:	dc.w byte_129C2-Ani_WaterSplash
byte_129C2:	dc.b   4,  0,  1,  2,$FC
		even
		endm

; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
include_MapUnc_WaterSplash:	macro
; Map_obj08:
MapUnc_WaterSplash:	incbin	"mappings/sprite/obj08.bin"
		endm