; ===========================================================================
; ---------------------------------------------------------------------------
; Object 47 - SYZ Bumper (unused)
;
; Internal name: "bobin"
; ---------------------------------------------------------------------------
; Sprite_13874: S1Obj47:
Obj_Bumper:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Bumper_Index(pc,d0.w),d1
		jmp	Bumper_Index(pc,d1.w)
; ===========================================================================
; off_13882: S1Obj47_Index:
Bumper_Index:	dc.w Bumper_Init-Bumper_Index
		dc.w Bumper_Main-Bumper_Index
; ===========================================================================
; loc_13886: S1Obj47_Init:
Bumper_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_Bumper,mappings(a0)
		move.w	#$380,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#1,priority(a0)
		move.b	#$D7,collision_flags(a0)
; loc_138B4: S1Obj47_Main:
Bumper_Main:
		move.b	collision_property(a0),d0
		beq.w	Bumper_Animate
		lea	(MainCharacter).w,a1
		bclr	#0,collision_property(a0)
		beq.s	.testSidekick
		bsr.s	Bumper_BumpCharacter
; loc_138CA:
.testSidekick:
		lea	(Sidekick).w,a1
		bclr	#1,collision_property(a0)
		beq.s	loc_138D8
		bsr.s	Bumper_BumpCharacter

loc_138D8:
		clr.b	collision_property(a0)
		bra.w	Bumper_Animate

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to bounce the character away from the bumper
; ---------------------------------------------------------------------------
; sub_138E0: S1Obj47_Bump:
Bumper_BumpCharacter:
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	x_pos(a1),d1
		sub.w	y_pos(a1),d2
		jsr	(CalcAngle).l
		jsr	(CalcSine).l
		; apply x-velocity
		muls.w	#-$700,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a1)
		; apply y-velocity
		muls.w	#-$700,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a1)

		bset	#1,status(a1)	; clear 'in-air' bit
		bclr	#4,status(a1)	; clear 'roll-jumping' bit
		bclr	#5,status(a1)	; clear 'pushing' bit
		clr.b	jumping(a1)
		move.b	#1,anim(a0)
		move.w	#SndID_Bumper,d0
		jsr	(PlaySound).l

		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		beq.s	loc_1394E
		cmpi.b	#$8A,2(a2,d0.w)
		bcc.s	locret_13974
		addq.b	#1,2(a2,d0.w)

loc_1394E:
		moveq	#1,d0
		jsr	(AddPoints).l
		bsr.w	AllocateObject
		bne.s	locret_13974
		move.b	#ObjID_Points,id(a1)	; load Obj_Points
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	#4,mapping_frame(a1)

locret_13974:
		rts
; End of function Bumper_BumpCharacter

; ===========================================================================
; loc_13976:
Bumper_Animate:
		lea	(Ani_Bumper).l,a1
		bsr.w	AnimateSprite
		bra.w	MarkObjGone
; ===========================================================================
; ---------------------------------------------------------------------------
; animation scripts
; ---------------------------------------------------------------------------
; Ani_S1Obj47:
Ani_Bumper:	dc.w byte_13988-Ani_Bumper
		dc.w byte_1398B-Ani_Bumper
byte_13988:	dc.b  $F,  0,$FF
byte_1398B:	dc.b   3,  1,  2,  1,  2,$FD,  0
		even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_S1Obj47:
MapUnc_Bumper:	include	"mappings/sprite/SYZ Bumper.asm"
		nop