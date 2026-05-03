; ===========================================================================
; ---------------------------------------------------------------------------
; Object 7D - hidden points at the end of a level
;
; Internal name: "bten"
; ---------------------------------------------------------------------------
; OST:
hiddenpoints_timer:	equ $30	; time to display before deletion
; ---------------------------------------------------------------------------
; Sprite_13770: Obj7D:
Obj_HiddenPoints:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	HiddenPoints_Index(pc,d0.w),d1
		jmp	HiddenPoints_Index(pc,d1.w)
; ===========================================================================
; off_1377E: Obj7D_Index:
HiddenPoints_Index:
		dc.w HiddenPoints_Init-HiddenPoints_Index
		dc.w HiddenPoints_ChkDel2-HiddenPoints_Index
; ===========================================================================
; loc_13782: Obj7D_Main:
HiddenPoints_Init:
		moveq	#$10,d2
		move.w	d2,d3
		add.w	d3,d3
		lea	(MainCharacter).w,a1
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d2,d0
		cmp.w	d3,d0
		bcc.s	HiddenPoints_ChkDel
		move.w	y_pos(a1),d1
		sub.w	y_pos(a0),d1
		add.w	d2,d1
		cmp.w	d3,d1
		bcc.s	HiddenPoints_ChkDel
		tst.w	(Debug_placement_mode).w
		bne.s	HiddenPoints_ChkDel
		tst.b	(EnterSS_flag).w
		bne.s	HiddenPoints_ChkDel
		addq.b	#2,routine(a0)
		move.l	#MapUnc_HiddenPoints,mappings(a0)
		move.w	#$84B6,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#0,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	subtype(a0),mapping_frame(a0)
		move.w	#$77,hiddenpoints_timer(a0)
		move.w	#$C9,d0
		jsr	(PlaySound).l
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.w	HiddenPoints_Reward(pc,d0.w),d0
		jsr	(AddPoints).l
; loc_13804:
HiddenPoints_ChkDel:
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.s	HiddenPoints_Delete
		rts
; ---------------------------------------------------------------------------
; loc_13818:
HiddenPoints_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
; Obj7D_Points:
HiddenPoints_Reward:
		dc.w	0
		dc.w	1000
		dc.w	100
		; This should actually be 10; as a result, the 100 points bonus
		; only gives you 10 points.
		dc.w	1
; ===========================================================================
; loc_13826: Obj7D_DelayDelete:
HiddenPoints_ChkDel2:
		subq.w	#1,hiddenpoints_timer(a0)
		bmi.s	HiddenPoints_Delete2
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.s	HiddenPoints_Delete2
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------
; loc_13844:
HiddenPoints_Delete2:
		jmp	(DeleteObject).l
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
MapUnc_HiddenPoints:	include	"mappings/sprite/Hidden Points.asm"
		nop