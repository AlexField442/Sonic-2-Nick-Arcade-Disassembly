; ===========================================================================
; ---------------------------------------------------------------------------
; Object 3E - Animal capsule at end of zone
;
; Internal name: "masin"
; --------------------------------------------------------------------------
; Sprite_194E4: Obj3E:
Obj_Capsule:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj3E_Index(pc,d0.w),d1
		jsr	Obj3E_Index(pc,d1.w)
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.s	Capsule_Delete
		jmp	(DisplaySprite).l
; ===========================================================================
; loc_1950A:
Capsule_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
; off_19510:
Obj3E_Index:	dc.w Obj3E_Init-Obj3E_Index
		dc.w Obj3E_BodyMain-Obj3E_Index
		dc.w Obj3E_Switched-Obj3E_Index
		dc.w Obj3E_Explosion-Obj3E_Index
		dc.w Obj3E_Explosion-Obj3E_Index
		dc.w Obj3E_Explosion-Obj3E_Index
		dc.w Obj3E_Animals-Obj3E_Index
		dc.w Obj3E_EndAct-Obj3E_Index
; byte_19520:
Obj3E_Var:	dc.b   2,$20,  4,  0
		dc.b   4, $C,  5,  1
		dc.b   6,$10,  4,  3
		dc.b   8,$10,  3,  5
; ===========================================================================
; loc_19530:
Obj3E_Init:
		move.l	#MapUnc_Capsule,mappings(a0)
		move.w	#$49D,art_tile(a0)
		bsr.w	JmpTo7_Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.w	y_pos(a0),$30(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#2,d0
		lea	Obj3E_Var(pc,d0.w),a1
		move.b	(a1)+,routine(a0)
		move.b	(a1)+,width_pixels(a0)
		move.b	(a1)+,priority(a0)
		move.b	(a1)+,mapping_frame(a0)
		cmpi.w	#8,d0
		bne.s	locret_1957C
		move.b	#6,collision_flags(a0)
		move.b	#8,collision_property(a0)

locret_1957C:
		rts
; ===========================================================================
; loc_1957E:
Obj3E_BodyMain:	
		cmpi.b	#2,(Boss_defeated_flag).w
		beq.s	loc_1959C
		move.w	#$2B,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	x_pos(a0),d4
		jmp	(SolidObject).l
; ===========================================================================

loc_1959C:
		tst.b	routine_secondary(a0)
		beq.s	loc_195B2
		clr.b	routine_secondary(a0)
		bclr	#3,(MainCharacter+status).w
		bset	#1,(MainCharacter+status).w

loc_195B2:
		move.b	#2,mapping_frame(a0)
		rts
; ===========================================================================
; loc_195BA:
Obj3E_Switched:
		move.w	#$17,d1
		move.w	#8,d2
		move.w	#8,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObject).l
		lea	(Ani_Capsule).l,a1
		jsr	(AnimateSprite).l
		move.w	$30(a0),y_pos(a0)
		move.b	status(a0),d0
		andi.b	#$18,d0
		beq.s	locret_19620
		addq.w	#8,y_pos(a0)
		move.b	#$A,routine(a0)
		move.w	#$3C,anim_frame_duration(a0)
		clr.b	(Update_HUD_timer).w
		clr.b	(Lock_screen).w
		move.b	#1,(Control_Locked).w
		move.w	#$800,(Ctrl_1_Logical).w
		clr.b	routine_secondary(a0)
		bclr	#3,(MainCharacter+status).w
		bset	#1,(MainCharacter+status).w

locret_19620:
		rts
; ===========================================================================
; loc_19622:
Obj3E_Explosion:
		moveq	#7,d0
		and.b	(Vint_runcount+3).w,d0
		bne.s	loc_19660
		jsr	(AllocateObject).l
		bne.s	loc_19660
		move.b	#ObjID_BossExplosion,id(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		jsr	(RandomNumber).l
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,x_pos(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,y_pos(a1)

loc_19660:
		subq.w	#1,anim_frame_duration(a0)
		beq.s	loc_19668
		rts
; ===========================================================================

loc_19668:
		move.b	#2,(Boss_defeated_flag).w
		move.b	#$C,routine(a0)
		move.b	#6,mapping_frame(a0)
		move.w	#$96,anim_frame_duration(a0)
		addi.w	#$20,y_pos(a0)
		moveq	#7,d6
		move.w	#$9A,d5
		moveq	#-$1C,d4

loc_1968E:
		jsr	(AllocateObject).l
		bne.s	locret_196B8
		move.b	#ObjID_Animal,id(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		add.w	d4,x_pos(a1)
		addq.w	#7,d4
		move.w	d5,$36(a1)
		subq.w	#8,d5
		dbf	d6,loc_1968E

locret_196B8:
		rts
; ===========================================================================
; loc_196BA:
Obj3E_Animals:
		moveq	#7,d0
		and.b	(Vint_runcount+3).w,d0
		bne.s	loc_196F8
		jsr	(AllocateObject).l
		bne.s	loc_196F8
		move.b	#ObjID_Animal,id(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		jsr	(RandomNumber).l
		andi.w	#$1F,d0
		subq.w	#6,d0
		tst.w	d1
		bpl.s	loc_196EE
		neg.w	d0

loc_196EE:
		add.w	d0,x_pos(a1)
		move.w	#$C,$36(a1)

loc_196F8:
		subq.w	#1,anim_frame_duration(a0)
		bne.s	locret_19708
		addq.b	#2,routine(a0)
		move.w	#$B4,anim_frame_duration(a0)

locret_19708:
		rts
; ===========================================================================
; loc_1970A:
Obj3E_EndAct:
		moveq	#$3E,d0
		moveq	#$28,d1
		moveq	#$40,d2
		lea	(Sidekick).w,a1

loc_19714:
		cmp.b	(a1),d1
		beq.s	locret_1972A
		adda.w	d2,a1
		dbf	d0,loc_19714
		jsr	(Load_EndOfAct).l
		jmp	(DeleteObject).l
; ===========================================================================

locret_1972A:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; animation scripts
; ---------------------------------------------------------------------------
; Ani_Obj3E:
Ani_Capsule:	dc.w byte_19730-Ani_Capsule
		dc.w byte_19730-Ani_Capsule
byte_19730:	dc.b   2,  1,  3,$FF
		even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj3E:
MapUnc_Capsule:	include	"mappings/sprite/Capsule.asm"