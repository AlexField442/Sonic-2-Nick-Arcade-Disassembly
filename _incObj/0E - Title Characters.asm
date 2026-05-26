; ===========================================================================
; ---------------------------------------------------------------------------
; Object 0E - Sonic and Tails from the title screen
; ---------------------------------------------------------------------------
; off_B378: Obj0E:
Obj_TitleCharacters:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	TitleCharacters_Index(pc,d0.w),d1
		jmp	TitleCharacters_Index(pc,d1.w)
; ===========================================================================
; off_B386: Obj0E_Index:
TitleCharacters_Index:
		dc.w TitleCharacters_Init-TitleCharacters_Index
		dc.w TitleCharacters_Display-TitleCharacters_Index
		dc.w TitleCharacters_RiseUp-TitleCharacters_Index
		dc.w TitleCharacters_Display2-TitleCharacters_Index
; ===========================================================================
; loc_B38E:
TitleCharacters_Init:
		addq.b	#2,routine(a0)
		move.w	#$148,x_pixel(a0)
		move.w	#$C4,y_pixel(a0)
		move.l	#MapUnc_TitleCharacters,mappings(a0)
		move.w	#$4200,art_tile(a0)
		move.b	#1,priority(a0)
		move.b	#$1D,anim_frame_duration+1(a0)
		tst.b	mapping_frame(a0)
		beq.s	TitleCharacters_Display
		move.w	#$FC,x_pixel(a0)
		move.w	#$CC,y_pixel(a0)
		move.w	#$2200,art_tile(a0)
; loc_B3D0:
TitleCharacters_Display:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		subq.b	#1,anim_frame_duration+1(a0)
		bpl.s	locret_B3E2
		addq.b	#2,routine(a0)
		bra.w	DisplaySprite
; ===========================================================================

locret_B3E2:
		rts
; ===========================================================================
; loc_B3E4:
TitleCharacters_RiseUp:
		subi.w	#8,y_pixel(a0)
		cmpi.w	#$96,y_pixel(a0)
		bne.s	loc_B3F6
		addq.b	#2,routine(a0)

loc_B3F6:
		bra.w	DisplaySprite
; ===========================================================================
; loc_B3FA:
TitleCharacters_Display2:
		bra.w	DisplaySprite
; ===========================================================================
; ---------------------------------------------------------------------------
; animation scripts (unused)
; ---------------------------------------------------------------------------
include_Ani_TitleSonS1 macro
; off_B51A:
Ani_TitleSonS1:	dc.w .titlesonic-Ani_TitleSonS1
; byte_B51C:
.titlesonic:	dc.b   7,  0,  1,  2,  3,  4,  5,  6
		dc.b   7,$FE,  2
		even
		endm
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
include_MapUnc_TitleCharacters macro
; Map_Obj0E:
MapUnc_TitleCharacters:	include	"mappings/sprite/Title Screen Characters.asm"
		nop
		endm