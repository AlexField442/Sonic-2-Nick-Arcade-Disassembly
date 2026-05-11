; ===========================================================================
; ---------------------------------------------------------------------------
; Object 29 - "100 points" text
;
; Internal name: "ten"
; ---------------------------------------------------------------------------
; Sprite_9FA0: Obj29:
Obj_Points:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Points_Index(pc,d0.w),d1
		jmp	Points_Index(pc,d1.w)
; ===========================================================================
; off_9FAE: Obj29_Index:
Points_Index:	dc.w Points_Init-Points_Index
		dc.w Points_Main-Points_Index
; ===========================================================================
; loc_9FB2:
Points_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_Points,mappings(a0)
		move.w	#$4AC,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#1,priority(a0)
		move.b	#8,width_pixels(a0)
		move.w	#-$300,y_vel(a0)
; loc_9FE0:
Points_Main:
		tst.w	y_vel(a0)
		bpl.w	DeleteObject
		bsr.w	ObjectMove
		addi.w	#$18,y_vel(a0)
		bra.w	DisplaySprite
; ===========================================================================
; ---------------------------------------------------------------------------
; Sprite mappings
; ---------------------------------------------------------------------------
include_MapUnc_Points: macro
; Map_Obj29:
MapUnc_Points:	include	"mappings/sprite/Points.asm"
		nop
	endm