; ===========================================================================
; ---------------------------------------------------------------------------
; Object 0C - Strange floating/falling platform object from CPZ
;
; Internal name: "prodai"
; ---------------------------------------------------------------------------
; Sprite_142DC: Obj0C:
Obj_CPZPlatform:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	CPZPlatform_Index(pc,d0.w),d1
		jmp	CPZPlatform_Index(pc,d1.w)
; ===========================================================================
; off_142EA: Obj0C_Index:
CPZPlatform_Index:
		dc.w CPZPlatform_Init-CPZPlatform_Index
		dc.w CPZPlatform_Main-CPZPlatform_Index
; ===========================================================================
; loc_142EE: Obj0C_Init:
CPZPlatform_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_CPZPlatform,mappings(a0)
		move.w	#$E418,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#4,priority(a0)
		move.w	y_pos(a0),d0
		subi.w	#$10,d0
		move.w	d0,$3A(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		andi.w	#$F0,d0
		addi.w	#$10,d0
		move.w	d0,d1
		subq.w	#1,d0
		move.w	d0,$30(a0)
		move.w	d0,$32(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		andi.w	#$F,d0
		move.b	d0,$3E(a0)
		move.b	d0,$3F(a0)
; loc_1434E: Obj0C_Main:
CPZPlatform_Main:
		move.b	$3C(a0),d0
		beq.s	loc_1438C
		cmpi.b	#$80,d0
		bne.s	loc_1439C
		move.b	$3D(a0),d1
		bne.s	loc_1436E
		subq.b	#1,$3E(a0)
		bpl.s	loc_1436E
		move.b	$3F(a0),$3E(a0)
		bra.s	loc_1439C
; ===========================================================================

loc_1436E:
		addq.b	#1,$3D(a0)
		move.b	d1,d0
		bsr.w	JmpTo_CalcSine
		addi.w	#8,d0
		asr.w	#6,d0
		subi.w	#$10,d0
		add.w	$3A(a0),d0
		move.w	d0,y_pos(a0)
		bra.s	loc_143B2
; ===========================================================================

loc_1438C:
		move.w	(Vint_runcount+2).w,d1
		andi.w	#$3FF,d1
		bne.s	loc_143A0
		move.b	#1,$3D(a0)

loc_1439C:
		addq.b	#1,$3C(a0)

loc_143A0:
		bsr.w	JmpTo_CalcSine
		addi.w	#8,d1
		asr.w	#4,d1
		add.w	$3A(a0),d1
		move.w	d1,y_pos(a0)

loc_143B2:
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#9,d3
		move.w	x_pos(a0),d4
		bsr.w	PlatformObject
		bra.w	MarkObjGone
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj0C:
MapUnc_CPZPlatform:	include	"mappings/sprite/CPZ Platform.asm"
		nop