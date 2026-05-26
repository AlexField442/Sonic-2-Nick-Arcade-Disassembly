; ===========================================================================
; ---------------------------------------------------------------------------
; Object 3B - Purple rock from GHZ
;
; Internal name: "jyama"
; --------------------------------------------------------------------------
; Sprite_C848: Obj3B:
Obj_PurpleRock:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	PurpleRock_Index(pc,d0.w),d1
		jmp	PurpleRock_Index(pc,d1.w)
; ===========================================================================
; off_C856: Obj3B_Index:
PurpleRock_Index:
		dc.w PurpleRock_Init-PurpleRock_Index
		dc.w PurpleRock_Main-PurpleRock_Index
; ===========================================================================
; loc_C85A:
PurpleRock_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_PurpleRock,mappings(a0)
		move.w	#$66C0,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$13,width_pixels(a0)
		move.b	#4,priority(a0)
; loc_C882:
PurpleRock_Main:
		move.w	#$1B,d1
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
; Map_Obj3B:
MapUnc_PurpleRock:	include	"mappings/sprite/GHZ Purple Rock.asm"
		align 4