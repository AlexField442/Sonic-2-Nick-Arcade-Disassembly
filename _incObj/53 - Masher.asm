; ===========================================================================
; ---------------------------------------------------------------------------
; Object 53 - Masher from EHZ
;
; Internal name: "wfish2"
; ---------------------------------------------------------------------------
; OST:
masher_origY:		equ $30
; ---------------------------------------------------------------------------
; Sprite_174D0: Obj53:
Obj_Masher:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Masher_Index(pc,d0.w),d1
		jsr	Masher_Index(pc,d1.w)
		bra.w	JmpTo7_MarkObjGone
; ===========================================================================
; off_174E2: Obj53_Index:
Masher_Index:	dc.w Masher_Init-Masher_Index
		dc.w Masher_Main-Masher_Index
; ===========================================================================
; loc_174E6: Obj53_Init:
Masher_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_Masher,mappings(a0)
		move.w	#$41C,art_tile(a0)
		bsr.w	JmpTo3_Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#9,collision_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.w	#-$400,y_vel(a0)		; set vertical speed
		move.w	y_pos(a0),masher_origY(a0)	; save original position
; loc_17520: Obj53_Main:
Masher_Main:
		lea	(Ani_Masher).l,a1
		bsr.w	JmpTo9_AnimateSprite
		bsr.w	JmpTo9_ObjectMove
		addi.w	#$18,y_vel(a0)		; apply gravity
		move.w	masher_origY(a0),d0
		cmp.w	y_pos(a0),d0		; has Masher reached its original Y position?
		bcc.s	Masher_Chomping		; if not, branch
		move.w	d0,y_pos(a0)
		move.w	#-$500,y_vel(a0)
; loc_17548:
Masher_Chomping:
		move.b	#1,anim(a0)		; use chomping animation
		subi.w	#$C0,d0
		cmp.w	y_pos(a0),d0
		bcc.s	locret_1756A
		move.b	#0,anim(a0)
		tst.w	y_vel(a0)		; is Masher falling?
		bmi.s	locret_1756A		; if not, branch
		move.b	#2,anim(a0)		; used closed mouth animation

locret_1756A:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; animation scripts
; ---------------------------------------------------------------------------
; Ani_obj53:
Ani_Masher:	dc.w .spawn-Ani_Masher
		dc.w .chomping-Ani_Masher
		dc.w .falling-Ani_Masher
; byte_17572:
.spawn:		dc.b   7,  0,  1,$FF
; byte_17576:
.chomping:	dc.b   3,  0,  1,$FF
; byte_1757A:
.falling:	dc.b   7,  0,$FF
		even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_obj53:
MapUnc_Masher:	include	"mappings/sprite/Badniks - Masher.asm"
		align 4