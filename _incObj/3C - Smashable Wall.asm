; ===========================================================================
; ---------------------------------------------------------------------------
; Object 3C - GHZ smashable wall
;
; Internal name: "brkabe"
; ---------------------------------------------------------------------------
; Sprite_C8C4: Obj3C:
Obj_BreakableWall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BreakableWall_Index(pc,d0.w),d1
		jsr	BreakableWall_Index(pc,d1.w)
		bra.w	MarkObjGone
; ===========================================================================
; off_C8D6: Obj3C_Index:
BreakableWall_Index:
		dc.w BreakableWall_Init-BreakableWall_Index
		dc.w BreakableWall_Main-BreakableWall_Index
		dc.w BreakableWall_Fragment-BreakableWall_Index
; ===========================================================================
; loc_C8DC:
BreakableWall_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_BreakableWall,mappings(a0)
		move.w	#$4590,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#4,priority(a0)
		move.b	subtype(a0),mapping_frame(a0)
; loc_C90A:
BreakableWall_Main:
		move.w	(MainCharacter+x_vel).w,$30(a0)
		move.w	#$1B,d1
		move.w	#$20,d2
		move.w	#$20,d3
		move.w	x_pos(a0),d4
		bsr.w	SolidObject
		btst	#5,status(a0)
		bne.s	loc_C92E

locret_C92C:
		rts
; ===========================================================================

loc_C92E:
		lea	(MainCharacter).w,a1
		cmpi.b	#2,anim(a1)
		bne.s	locret_C92C
		move.w	$30(a0),d0
		bpl.s	loc_C942
		neg.w	d0

loc_C942:
		cmpi.w	#$480,d0
		bcs.s	locret_C92C
		move.w	$30(a0),x_vel(a1)
		addq.w	#4,x_pos(a1)
		lea	(BreakableWall_FragSpdRight).l,a4
		move.w	x_pos(a0),d0
		cmp.w	x_pos(a1),d0
		bcs.s	loc_C96E
		subi.w	#8,x_pos(a1)
		lea	(BreakableWall_FragSpdLeft).l,a4

loc_C96E:
		move.w	x_vel(a1),inertia(a1)
		bclr	#5,status(a0)
		bclr	#5,status(a1)
		moveq	#7,d1
		move.w	#$70,d2
		bsr.s	BreakObjectIntoPieces
; loc_C988:
BreakableWall_Fragment:
		bsr.w	ObjectMove
		addi.w	#$70,y_vel(a0)	; apply gravity
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to smash an object into bits
; ---------------------------------------------------------------------------
; sub_C99E:
BreakObjectIntoPieces:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		add.w	d0,d0
		movea.l	mappings(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#2,a3
		bset	#5,render_flags(a0)
		move.b	id(a0),d4
		move.b	render_flags(a0),d5
		movea.l	a0,a1
		bra.s	loc_C9CA
; ===========================================================================

loc_C9C2:
		bsr.w	AllocateObject
		bne.s	loc_CA1C
		addq.w	#8,a3

loc_C9CA:
		move.b	#4,routine(a1)
		move.b	d4,id(a1)
		move.l	a3,mappings(a1)
		move.b	d5,render_flags(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.b	priority(a0),priority(a1)
		move.b	width_pixels(a0),width_pixels(a1)
		move.w	(a4)+,x_vel(a1)
		move.w	(a4)+,y_vel(a1)
		cmpa.l	a0,a1
		bcc.s	loc_CA18
		move.l	a0,-(sp)
		movea.l	a1,a0
		bsr.w	ObjectMove
		add.w	d2,y_vel(a0)
		movea.l	(sp)+,a0
		bsr.w	DisplaySprite2

loc_CA18:
		dbf	d1,loc_C9C2

loc_CA1C:
		move.w	#SndID_SlowSmash,d0
		jmp	(PlaySound).l
; End of function BreakObjectIntoPieces

; ===========================================================================
; word_CA26: Obj3C_FragSpdRight:
BreakableWall_FragSpdRight:
		dc.w  $400,$FB00
		dc.w  $600,$FF00
		dc.w  $600, $100
		dc.w  $400, $500
		dc.w  $600,$FA00
		dc.w  $800,$FE00
		dc.w  $800, $200
		dc.w  $600, $600
; word_CA46: Obj3C_FragSpdLeft:
BreakableWall_FragSpdLeft:
		dc.w $FA00,$FA00
		dc.w $F800,$FE00
		dc.w $F800, $200
		dc.w $FA00, $600
		dc.w $FC00,$FB00
		dc.w $FA00,$FF00
		dc.w $FA00, $100
		dc.w $FC00, $500

; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj3C:
MapUnc_BreakableWall:	include	"mappings/sprite/GHZ Smashable Wall.asm"
		nop