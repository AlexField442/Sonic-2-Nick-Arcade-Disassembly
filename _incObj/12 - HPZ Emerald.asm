; ===========================================================================
; ---------------------------------------------------------------------------
; Object 12 - Emerald from Hidden Palace Zone (that was eaten by Tails)
;
; Internal name: "gem"
; ---------------------------------------------------------------------------
; Sprite_143DC: Obj12:
Obj_HPZEmerald:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	HPZEmerald_Index(pc,d0.w),d1
		jmp	HPZEmerald_Index(pc,d1.w)
; ===========================================================================
; off_143EA: Obj12_Index:
HPZEmerald_Index:
		dc.w HPZEmerald_Init-HPZEmerald_Index
		dc.w HPZEmerald_Display-HPZEmerald_Index
; ===========================================================================
; loc_143EE: Obj12_Init:
HPZEmerald_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_HPZEmerald,mappings(a0)
		move.w	#$6392,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$20,width_pixels(a0)
		move.b	#4,priority(a0)
; loc_14416: Obj12_Display:
HPZEmerald_Display:
		move.w	#$20,d1
		move.w	#$10,d2
		move.w	#$10,d3
		move.w	x_pos(a0),d4
		bsr.w	SolidObject
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
MapUnc_HPZEmerald:	include	"mappings/sprite/Emerald from HPZ.asm"
		nop