; ===========================================================================
; ---------------------------------------------------------------------------
; Object 54 - Snail badnik from	EHZ
;
; Internal name: "snail"
; ---------------------------------------------------------------------------
; OST:
snail_parent:			equ $2A		; long-word ; pointer to body
snail_timer:			equ $30		; word ; time to wait until turning around
snail_deleteflame:		equ $34		; byte
snail_attackflag:		equ $35		; byte ; 0 = normal, 1 = charge
; ---------------------------------------------------------------------------
; Sprite_175D0: Obj54:
Obj_Snail:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Snail_Index(pc,d0.w),d1
		jmp	Snail_Index(pc,d1.w)
; ===========================================================================
; off_175DE: Obj54_Index:
Snail_Index:	dc.w Snail_Init-Snail_Index
		dc.w Snail_Move-Snail_Index
		dc.w Snail_CalmDown-Snail_Index
		dc.w Snail_Head-Snail_Index
		dc.w Snail_Flame-Snail_Index
; ===========================================================================
; loc_175E8: Obj54_Init:
Snail_Init:
		move.l	#MapUnc_Snail,mappings(a0)
		move.w	#$402,art_tile(a0)
		bsr.w	JmpTo4_Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#$A,collision_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		move.b	#$E,x_radius(a0)
		; create Snail head
		bsr.w	JmpTo2_AllocateObjectAfterCurrent
		bne.s	loc_17670
		move.b	#ObjID_Snail,id(a1)
		move.b	#6,routine(a1)
		move.l	#MapUnc_Snail,mappings(a1)
		move.w	#$2402,art_tile(a1)
		bsr.w	JmpTo2_Adjust2PArtPointer2
		move.b	#3,priority(a1)
		move.b	#$10,width_pixels(a1)
		move.b	status(a0),status(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.l	a0,snail_parent(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	#2,mapping_frame(a1)

loc_17670:
		addq.b	#2,routine(a0)
		move.w	#-$80,d0
		btst	#0,status(a0)
		beq.s	loc_17682
		neg.w	d0

loc_17682:
		move.w	d0,x_vel(a0)
		rts
; ===========================================================================
; loc_17688: Obj54_Move:
Snail_Move:
		bsr.w	Snail_Charge
		bsr.w	JmpTo10_ObjectMove
		jsr	(ObjHitFloor).l
		cmpi.w	#-8,d1
		blt.s	Obj54_Display
		cmpi.w	#$C,d1
		bge.s	Obj54_Display
		add.w	d1,y_pos(a0)
		lea	(Ani_Snail).l,a1
		bsr.w	JmpTo10_AnimateSprite
		bra.w	JmpTo2_MarkObjGone_P1
; ===========================================================================
; loc_176B4:
Obj54_Display:
		addq.b	#2,routine(a0)
		move.w	#$14,snail_timer(a0)
		st	snail_deleteflame(a0)
		lea	(Ani_Snail).l,a1
		bsr.w	JmpTo10_AnimateSprite
		bra.w	JmpTo2_MarkObjGone_P1

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine for Snail to notice and charge Sonic
; ---------------------------------------------------------------------------
; sub_176D0:
Snail_Charge:
		tst.b	snail_attackflag(a0)
		bne.s	locret_17712
		move.w	(MainCharacter+x_pos).w,d0
		sub.w	x_pos(a0),d0
		cmpi.w	#100,d0		; is Snail within 100 pixels of Sonic?
		bgt.s	locret_17712	; if not, branch
		cmpi.w	#-100,d0
		blt.s	locret_17712	; same as above, but opposite direction
		tst.w	d0
		bmi.s	loc_176F8
		btst	#0,status(a0)
		beq.s	locret_17712
		bra.s	Snail_ChargeSonic
; ===========================================================================

loc_176F8:
		btst	#0,status(a0)
		bne.s	locret_17712
; loc_17700:
Snail_ChargeSonic:
		move.w	x_vel(a0),d0	; $80 = 0000 0000 1000 0000
		asl.w	#2,d0		; shift left by 2-bits
		move.w	d0,x_vel(a0)	; 0000 0010 0000 0000 = $200
		st	snail_attackflag(a0)
		bsr.w	Snail_CreateFlame

locret_17712:
		rts
; End of function Snail_Charge

; ===========================================================================
; sub_17714:
Snail_CreateFlame:
		bsr.w	JmpTo2_AllocateObjectAfterCurrent
		bne.s	locret_17770
		move.b	#ObjID_Snail,id(a1)
		move.b	#8,routine(a1)
		move.l	#MapUnc_Buzzer,mappings(a1)
		move.w	#$3E6,art_tile(a1)
		bsr.w	JmpTo2_Adjust2PArtPointer2
		move.b	#4,priority(a1)
		move.b	#$10,width_pixels(a1)
		move.b	status(a0),status(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.l	a0,snail_parent(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		addq.w	#7,y_pos(a1)
		addi.w	#$D,x_pos(a1)
		move.b	#1,anim(a1)

locret_17770:
		rts
; End of function Snail_CreateFlame

; ===========================================================================
; loc_17772:
Snail_Flame:
		movea.l	snail_parent(a0),a1
		cmpi.b	#ObjID_Snail,(a1)
		bne.w	JmpTo8_DeleteObject
		tst.b	snail_deleteflame(a1)
		bne.w	JmpTo8_DeleteObject
		move.w	x_pos(a1),x_pos(a0)
		move.w	y_pos(a1),y_pos(a0)
		addq.w	#7,y_pos(a0)
		moveq	#$D,d0
		btst	#0,status(a0)
		beq.s	loc_177A2
		neg.w	d0

loc_177A2:
		add.w	d0,x_pos(a0)
		lea	(Ani_Buzzer).l,a1
		bsr.w	JmpTo10_AnimateSprite
		bra.w	JmpTo2_MarkObjGone_P1
; ===========================================================================
; loc_177B4:
Snail_CalmDown:
		subi.w	#1,snail_timer(a0)
		bpl.w	JmpTo2_MarkObjGone_P1
		neg.w	x_vel(a0)
		bsr.w	JmpTo7_ObjectMoveAndFall
		; same as Snail_ChargeSonic, but this time bit-shifting right
		move.w	x_vel(a0),d0
		asr.w	#2,d0
		move.w	d0,x_vel(a0)
		bchg	#0,status(a0)
		bchg	#0,render_flags(a0)
		subq.b	#2,routine(a0)
		sf	snail_deleteflame(a0)
		sf	snail_attackflag(a0)
		bra.w	JmpTo2_MarkObjGone_P1
; ===========================================================================
; loc_177EC:
Snail_Head:
		movea.l	snail_parent(a0),a1
		cmpi.b	#ObjID_Snail,(a1)
		bne.w	JmpTo8_DeleteObject
		move.w	x_pos(a1),x_pos(a0)
		move.w	y_pos(a1),y_pos(a0)
		move.b	status(a1),status(a0)
		move.b	render_flags(a1),render_flags(a0)
		bra.w	JmpTo2_MarkObjGone_P1
; ===========================================================================
; ---------------------------------------------------------------------------
; animation scripts
; ---------------------------------------------------------------------------
; Ani_Obj54:
Ani_Snail:	dc.w .normal-Ani_Snail
		dc.w .charge-Ani_Snail
; byte_17818:
.normal:	dc.b   5,  0,  1,$FF
; byte_1781C:
.charge:	dc.b   1,  0,  1,$FF		; unused
		even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_obj54:
MapUnc_Snail:	include	"mappings/sprite/Badniks - Snail.asm"