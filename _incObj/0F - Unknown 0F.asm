; ===========================================================================
; ---------------------------------------------------------------------------
; Object 0F - Mappings test?
; ---------------------------------------------------------------------------
; Sprite_B3FE: Obj0F:
Obj_Unknown0F:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Unknown0F_Index(pc,d0.w),d1
		jsr	Unknown0F_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
; off_B410: Obj0F_Index:
Unknown0F_Index:
		dc.w Unknown0F_Init-Unknown0F_Index
		dc.w Unknown0F_CheckC-Unknown0F_Index
		dc.w Unknown0F_CheckC-Unknown0F_Index
; ===========================================================================
; loc_B416:
Unknown0F_Init:
		addq.b	#2,routine(a0)
		move.w	#$90,x_pixel(a0)
		move.w	#$90,y_pixel(a0)
		move.l	#MapUnc_Unknown0F,mappings(a0)
		move.w	#$680,art_tile(a0)
		bsr.w	Adjust2PArtPointer
; loc_B438:
Unknown0F_CheckC:
		move.b	(Ctrl_1_Press).w,d0
		btst	#5,d0			; has C been pressed?
		beq.s	Unknown0F_CheckB	; if not, branch
		addq.b	#1,mapping_frame(a0)	; increment mappings
		andi.b	#$F,mapping_frame(a0)	; if above $F, reset
; loc_B44C:
Unknown0F_CheckB:
		btst	#4,d0		; has B been pressed?
		beq.s	locret_B458	; if not, branch
		; I don't know why, but this line just crashes the game.
		bchg	#0,(Two_player_mode+1).w

locret_B458:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj0F:
MapUnc_Unknown0F:	include	"mappings/sprite/Unknown 0F.asm"
; ---------------------------------------------------------------------------
; animation scripts (unused)
; ---------------------------------------------------------------------------
include_Ani_PressStart macro
; off_B528:
Ani_PressStart:	dc.w .flash-Ani_PressStart
; byte_B52A:
.flash:		dc.b $1F,  0,  1,$FF
		even
		endm
; ---------------------------------------------------------------------------
; sprite mappings (unused)
; ---------------------------------------------------------------------------
include_MapUnc_PressStart macro
; Map_S1Obj0F:
MapUnc_PressStart:	include	"mappings/sprite/Press Start and TM.asm"
		endm