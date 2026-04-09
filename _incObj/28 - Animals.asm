; ===========================================================================
; ---------------------------------------------------------------------------
; Object 28 - Animals from badnik
;
; Internal name: "usagi"
; ---------------------------------------------------------------------------
; OST:
animal_direction:	equ $29
animal_type:		equ $30
animal_x_vel:		equ $32
animal_y_vel:		equ $34
; ---------------------------------------------------------------------------
; Sprite_9AA8: Obj28:
Obj_Animal:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Animal_Index(pc,d0.w),d1
		jmp	Animal_Index(pc,d1.w)
; ===========================================================================
; off_9AB6:
Animal_Index:	dc.w	Animal_Init-Animal_Index
		dc.w	Animal_Main-Animal_Index
		dc.w	Animal_WalkType-Animal_Index
		dc.w	Animal_FlyType-Animal_Index
		dc.w	Animal_WalkType-Animal_Index
		dc.w	Animal_WalkType-Animal_Index
		dc.w	Animal_WalkType-Animal_Index
		dc.w	Animal_FlyType-Animal_Index
		dc.w	Animal_WalkType-Animal_Index
		dc.w	Animal_FromPrison-Animal_Index
		dc.w	loc_9DEE-Animal_Index
		dc.w	loc_9DEE-Animal_Index
		dc.w	loc_9E0E-Animal_Index
		dc.w	loc_9E48-Animal_Index
		dc.w	loc_9EA2-Animal_Index
		dc.w	loc_9EC0-Animal_Index
		dc.w	loc_9EA2-Animal_Index
		dc.w	loc_9EC0-Animal_Index
		dc.w	loc_9EA2-Animal_Index
		dc.w	loc_9EFE-Animal_Index
		dc.w	loc_9E64-Animal_Index
; ===========================================================================
; These are settings for the animals freed from badniks.
; byte_9AE0:
Animal_ZoneData:
		dc.b	0,  5	; Green Hill
		dc.b	2,  3	; Labyrinth
		dc.b	6,  3	; Chemical Plant
		dc.b	4,  5	; Emerald Hill
		dc.b	4,  1	; Hidden Palace
		dc.b	0,  1	; Hill Top
; word_9AEC:
Animal_Properties:
		; horizontal speed, vertical speed, mappings
		dc.w	$FE00,$FC00
		dc.l	MapUnc_Animal
		dc.w	$FE00,$FD00
		dc.l	MapUnc_Animal2
		dc.w	$FE80,$FD00
		dc.l	MapUnc_Animal
		dc.w	$FEC0,$FE80
		dc.l	MapUnc_Animal2
		dc.w	$FE40,$FD00
		dc.l	MapUnc_Animal3
		dc.w	$FD00,$FC00
		dc.l	MapUnc_Animal2
		dc.w	$FD80,$FC80
		dc.l	MapUnc_Animal3
; ---------------------------------------------------------------------------
; These are settings for the animals from the Sonic 1 ending sequence.
; Unused, but fully functional; subtype acts as its index, starting at $A.
; word_9B24:
Animal_EndingSpeeds:
		; horizontal speed, vertical speed
		dc.w	$FBC0,$FC00
		dc.w	$FBC0,$FC00
		dc.w	$FBC0,$FC00
		dc.w	$FD00,$FC00
		dc.w	$FD00,$FC00
		dc.w	$FE80,$FD00
		dc.w	$FE80,$FD00
		dc.w	$FEC0,$FE80
		dc.w	$FE40,$FD00
		dc.w	$FE00,$FD00
		dc.w	$FD80,$FC80
; off_9B50:
Animal_EndingMappings:
		dc.l	MapUnc_Animal2
		dc.l	MapUnc_Animal2
		dc.l	MapUnc_Animal2
		dc.l	MapUnc_Animal
		dc.l	MapUnc_Animal
		dc.l	MapUnc_Animal
		dc.l	MapUnc_Animal
		dc.l	MapUnc_Animal2
		dc.l	MapUnc_Animal3
		dc.l	MapUnc_Animal2
		dc.l	MapUnc_Animal3
; word_9B7C:
Animal_EndingVRAM:
		dc.w	$5A5
		dc.w	$5A5
		dc.w	$5A5
		dc.w	$553
		dc.w	$553
		dc.w	$573
		dc.w	$573
		dc.w	$585
		dc.w	$593
		dc.w	$565
		dc.w	$5B3
; ===========================================================================
; loc_9B92:
Animal_Init:
		tst.b	subtype(a0)
		beq.w	loc_9C00
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.b	d0,routine(a0)
		subi.w	#$14,d0
		move.w	Animal_EndingVRAM(pc,d0.w),art_tile(a0)
		add.w	d0,d0
		move.l	Animal_EndingMappings(pc,d0.w),mappings(a0)
		lea	Animal_EndingSpeeds(pc),a1
		move.w	(a1,d0.w),animal_x_vel(a0)
		move.w	(a1,d0.w),x_vel(a0)
		move.w	2(a1,d0.w),animal_y_vel(a0)
		move.w	2(a1,d0.w),y_vel(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#$C,y_radius(a0)
		move.b	#4,render_flags(a0)
		bset	#0,render_flags(a0)
		move.b	#6,priority(a0)
		move.b	#8,width_pixels(a0)
		move.b	#7,anim_frame_duration(a0)
		bra.w	DisplaySprite
; ===========================================================================

loc_9C00:
		addq.b	#2,routine(a0)
		bsr.w	RandomNumber
		andi.w	#1,d0
		moveq	#0,d1
		move.b	(Current_Zone).w,d1
		add.w	d1,d1
		add.w	d0,d1
		lea	Animal_ZoneData(pc),a1
		move.b	(a1,d1.w),d0
		move.b	d0,animal_type(a0)
		lsl.w	#3,d0
		lea	Animal_Properties(pc),a1
		adda.w	d0,a1
		move.w	(a1)+,animal_x_vel(a0)
		move.w	(a1)+,animal_y_vel(a0)
		move.l	(a1)+,mappings(a0)
		move.w	#$580,art_tile(a0)
		btst	#0,animal_type(a0)
		beq.s	loc_9C4A
		move.w	#$592,art_tile(a0)

loc_9C4A:
		bsr.w	Adjust2PArtPointer
		move.b	#$C,y_radius(a0)
		move.b	#4,render_flags(a0)
		bset	#0,render_flags(a0)
		move.b	#6,priority(a0)
		move.b	#8,width_pixels(a0)
		move.b	#7,anim_frame_duration(a0)
		move.b	#2,mapping_frame(a0)
		move.w	#$FC00,y_vel(a0)
		tst.b	(Boss_defeated_flag).w
		bne.s	loc_9CAA
		bsr.w	AllocateObject
		bne.s	loc_9CA6
		move.b	#ObjID_Points,id(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	combo(a0),d0
		lsr.w	#1,d0
		move.b	d0,mapping_frame(a1)

loc_9CA6:
		bra.w	DisplaySprite
; ===========================================================================

loc_9CAA:
		move.b	#$12,routine(a0)
		clr.w	x_vel(a0)
		bra.w	DisplaySprite
; ===========================================================================
; loc_9CB8:
Animal_Main:
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		bsr.w	ObjectMoveAndFall
		tst.w	y_vel(a0)
		bmi.s	loc_9D0E
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_9D0E
		add.w	d1,y_pos(a0)
		move.w	animal_x_vel(a0),x_vel(a0)
		move.w	animal_y_vel(a0),y_vel(a0)
		move.b	#1,mapping_frame(a0)
		move.b	animal_type(a0),d0
		add.b	d0,d0
		addq.b	#4,d0
		move.b	d0,routine(a0)
		tst.b	(Boss_defeated_flag).w
		beq.s	loc_9D0E
		btst	#4,(Vint_runcount+3).w
		beq.s	loc_9D0E
		neg.w	x_vel(a0)
		bchg	#0,render_flags(a0)

loc_9D0E:
		bra.w	DisplaySprite
; ===========================================================================
; Used by Pocky, Pecky, Rocky, and Ricky
; loc_9D12:
Animal_WalkType:
		bsr.w	ObjectMoveAndFall
		move.b	#1,mapping_frame(a0)
		tst.w	y_vel(a0)
		bmi.s	Animal_DeleteWalk
		move.b	#0,mapping_frame(a0)
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	Animal_DeleteWalk
		add.w	d1,y_pos(a0)
		move.w	animal_y_vel(a0),y_vel(a0)
; loc_9D3C:
Animal_DeleteWalk:
		tst.b	subtype(a0)
		bne.s	Animal_ChkDel
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
; Used by Cucky and Flicky
; loc_9D4E:
Animal_FlyType:
		bsr.w	ObjectMove
		addi.w	#$18,y_vel(a0)
		tst.w	y_vel(a0)
		bmi.s	loc_9D8A
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_9D8A
		add.w	d1,y_pos(a0)
		move.w	animal_y_vel(a0),y_vel(a0)
		tst.b	subtype(a0)
		beq.s	loc_9D8A
		cmpi.b	#$A,subtype(a0)
		beq.s	loc_9D8A
		neg.w	x_vel(a0)
		bchg	#0,render_flags(a0)

loc_9D8A:
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	Animal_DeleteFly
		move.b	#1,anim_frame_duration(a0)
		addq.b	#1,mapping_frame(a0)
		andi.b	#1,mapping_frame(a0)
; loc_9DA0:
Animal_DeleteFly:
		tst.b	subtype(a0)
		bne.s	Animal_ChkDel
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
; loc_9DB2:
Animal_ChkDel:
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		bcs.s	loc_9DCA
		subi.w	#384,d0
		bpl.s	loc_9DCA
		tst.b	render_flags(a0)
		bpl.w	DeleteObject

loc_9DCA:
		bra.w	DisplaySprite
; ===========================================================================
; loc_9DCE:
Animal_FromPrison:
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		subq.w	#1,$36(a0)
		bne.w	loc_9DEA
		move.b	#2,routine(a0)
		move.b	#3,priority(a0)

loc_9DEA:
		bra.w	DisplaySprite
; ===========================================================================

loc_9DEE:
		bsr.w	Animal_CheckDistance
		bcc.s	loc_9E0A
		move.w	animal_x_vel(a0),x_vel(a0)
		move.w	animal_y_vel(a0),y_vel(a0)
		move.b	#$E,routine(a0)
		bra.w	Animal_FlyType
; ===========================================================================

loc_9E0A:
		bra.w	Animal_ChkDel
; ===========================================================================

loc_9E0E:
		bsr.w	Animal_CheckDistance
		bpl.s	loc_9E44
		clr.w	x_vel(a0)
		clr.w	animal_x_vel(a0)
		bsr.w	ObjectMove
		addi.w	#$18,y_vel(a0)
		bsr.w	Animal_BounceOnFloor
		bsr.w	Animal_CheckDirection
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	loc_9E44
		move.b	#1,anim_frame_duration(a0)
		addq.b	#1,mapping_frame(a0)
		andi.b	#1,mapping_frame(a0)

loc_9E44:
		bra.w	Animal_ChkDel
; ===========================================================================

loc_9E48:
		bsr.w	Animal_CheckDistance
		bpl.s	loc_9E9E
		move.w	animal_x_vel(a0),x_vel(a0)
		move.w	animal_y_vel(a0),y_vel(a0)
		move.b	#4,routine(a0)
		bra.w	Animal_WalkType
; ===========================================================================

loc_9E64:
		bsr.w	ObjectMoveAndFall
		move.b	#1,mapping_frame(a0)
		tst.w	y_vel(a0)
		bmi.s	loc_9E9E
		move.b	#0,mapping_frame(a0)
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_9E9E
		not.b	animal_direction(a0)
		bne.s	loc_9E94
		neg.w	x_vel(a0)
		bchg	#0,render_flags(a0)

loc_9E94:
		add.w	d1,y_pos(a0)
		move.w	animal_y_vel(a0),y_vel(a0)

loc_9E9E:
		bra.w	Animal_ChkDel
; ===========================================================================

loc_9EA2:
		bsr.w	Animal_CheckDistance
		bpl.s	loc_9EBC
		clr.w	x_vel(a0)
		clr.w	animal_x_vel(a0)
		bsr.w	ObjectMoveAndFall
		bsr.w	Animal_BounceOnFloor
		bsr.w	Animal_CheckDirection

loc_9EBC:
		bra.w	Animal_ChkDel
; ===========================================================================

loc_9EC0:
		bsr.w	Animal_CheckDistance
		bpl.s	loc_9EFA
		bsr.w	ObjectMoveAndFall
		move.b	#1,mapping_frame(a0)
		tst.w	y_vel(a0)
		bmi.s	loc_9EFA
		move.b	#0,mapping_frame(a0)
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_9EFA
		neg.w	x_vel(a0)
		bchg	#0,render_flags(a0)
		add.w	d1,y_pos(a0)
		move.w	animal_y_vel(a0),y_vel(a0)

loc_9EFA:
		bra.w	Animal_ChkDel
; ===========================================================================

loc_9EFE:
		bsr.w	Animal_CheckDistance
		bpl.s	loc_9F4E
		bsr.w	ObjectMove
		addi.w	#$18,y_vel(a0)
		tst.w	y_vel(a0)
		bmi.s	loc_9F38
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_9F38
		not.b	animal_direction(a0)
		bne.s	loc_9F2E
		neg.w	x_vel(a0)
		bchg	#0,render_flags(a0)

loc_9F2E:
		add.w	d1,y_pos(a0)
		move.w	animal_y_vel(a0),y_vel(a0)

loc_9F38:
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	loc_9F4E
		move.b	#1,anim_frame_duration(a0)
		addq.b	#1,mapping_frame(a0)
		andi.b	#1,mapping_frame(a0)

loc_9F4E:
		bra.w	Animal_ChkDel

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to animate and bounce animal on floor
; ---------------------------------------------------------------------------
; sub_9F52:
Animal_BounceOnFloor:
		move.b	#1,mapping_frame(a0)
		tst.w	y_vel(a0)		; is animal moving upwards?
		bmi.s	locret_9F78		; if yes, branch
		move.b	#0,mapping_frame(a0)
		jsr	(ObjHitFloor).l
		tst.w	d1			; has animal hit the floor?
		bpl.s	locret_9F78		; if not, branch
		add.w	d1,y_pos(a0)
		move.w	animal_y_vel(a0),y_vel(a0)

locret_9F78:
		rts
; End of function Animal_BounceOnFloor

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to set orientation based on Sonic's position
; ---------------------------------------------------------------------------
; sub_9F7A:
Animal_CheckDirection:
		bset	#0,render_flags(a0)
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		bcc.s	locret_9F90		; branch if Sonic is left of the animal
		bclr	#0,render_flags(a0)

locret_9F90:
		rts
; End of function Animal_CheckDirection

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check if Sonic is more than 184px to the right
;
; output:
; d0 = positive if true; negative if false
; ---------------------------------------------------------------------------
; sub_9F92:
Animal_CheckDistance:
		move.w	(MainCharacter+x_pos).w,d0
		sub.w	x_pos(a0),d0
		subi.w	#184,d0
		rts
; End of function Animal_CheckDistance

; ===========================================================================
; ---------------------------------------------------------------------------
; Sprite mappings
; ---------------------------------------------------------------------------
include_MapUnc_Animal: macro
; Map_Obj28a:
MapUnc_Animal:		include	"mappings/sprite/Animals - Pocky and Pecky.asm"
; Map_Obj28:
MapUnc_Animal2:		include	"mappings/sprite/Animals - Rocky, Cucky, and Flicky.asm"
; Map_Obj28b:
MapUnc_Animal3:		include	"mappings/sprite/Animals - Picky and Ricky.asm"
	endm