; ===========================================================================
; ---------------------------------------------------------------------------
; Object 4B - Buzzer from EHZ
;
; Internal name: "wasp"
; ---------------------------------------------------------------------------
; OST:
buzzer_parent:			equ $2A		; long-word
buzzer_move_timer:		equ $2E		; word
buzzer_turn_delay:		equ $30		; word
buzzer_shooting_flag:		equ $32		; byte
buzzer_shot_timer:		equ $34		; word
; ---------------------------------------------------------------------------
; Sprite_16794: Obj4B:
Obj_Buzzer:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Buzzer_Index(pc,d0.w),d1
		jmp	Buzzer_Index(pc,d1.w)
; ===========================================================================
; off_167A2: Obj4B_Index:
Buzzer_Index:	dc.w Buzzer_Init-Buzzer_Index
		dc.w Buzzer_Main-Buzzer_Index
		dc.w Buzzer_Flame-Buzzer_Index
		dc.w Buzzer_Projectile-Buzzer_Index
; ===========================================================================
; loc_167AA: Obj4B_Projectile:
Buzzer_Projectile:
		bsr.w	JmpTo6_ObjectMove
		lea	(Ani_Buzzer).l,a1
		bsr.w	JmpTo5_AnimateSprite
		bra.w	JmpTo_MarkObjGone_P1
; ===========================================================================
; loc_167BC: Obj4B_Flame:
Buzzer_Flame:
		movea.l	buzzer_parent(a0),a1
		tst.b	(a1)
		beq.w	JmpTo6_DeleteObject
		tst.w	buzzer_turn_delay(a1)
		bmi.s	loc_167CE
		rts
; ---------------------------------------------------------------------------

loc_167CE:
		move.w	x_pos(a1),x_pos(a0)
		move.w	y_pos(a1),y_pos(a0)
		move.b	status(a1),status(a0)
		move.b	render_flags(a1),render_flags(a0)
		lea	(Ani_Buzzer).l,a1
		bsr.w	JmpTo5_AnimateSprite
		bra.w	JmpTo_MarkObjGone_P1
; ===========================================================================
; loc_167F4: Obj4B_Init:
Buzzer_Init:
		move.l	#MapUnc_Buzzer,mappings(a0)
		move.w	#$3E6,art_tile(a0)
		bsr.w	JmpTo2_Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#$A,collision_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		move.b	#$18,x_radius(a0)
		move.b	#3,priority(a0)
		addq.b	#2,routine(a0)	; => Buzzer_Main

		; load exhaust flame object
		bsr.w	JmpTo_AllocateObjectAfterCurrent
		bne.s	locret_1689E

		move.b	#ObjID_Buzzer,id(a1)	; load Obj_Buzzer
		move.b	#4,routine(a1)	; => Buzzer_Flame
		move.l	#MapUnc_Buzzer,mappings(a1)
		move.w	#$3E6,art_tile(a1)
		bsr.w	JmpTo_Adjust2PArtPointer2
		move.b	#4,priority(a1)
		move.b	#$10,width_pixels(a1)
		move.b	status(a0),status(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	#1,anim(a1)
		move.l	a0,buzzer_parent(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	#$100,buzzer_move_timer(a0)
		move.w	#-$100,x_vel(a0)
		btst	#0,render_flags(a0)
		beq.s	locret_1689E
		neg.w	x_vel(a0)

locret_1689E:
		rts
; ===========================================================================
; loc_168A0: Obj4B_Main:
Buzzer_Main:
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Buzzer_Main_Index(pc,d0.w),d1
		jsr	Buzzer_Main_Index(pc,d1.w)
		lea	(Ani_Buzzer).l,a1
		bsr.w	JmpTo5_AnimateSprite
		bra.w	JmpTo_MarkObjGone_P1
; ===========================================================================
; loc_168BC: Obj4B_Main_Index:
Buzzer_Main_Index:
		dc.w Buzzer_Roaming-Buzzer_Main_Index
		dc.w Buzzer_Shooting-Buzzer_Main_Index
; ===========================================================================
; loc_168C0: Obj4B_Roaming:
Buzzer_Roaming:
		bsr.w	Buzzer_ChkPlayers
		subq.w	#1,buzzer_turn_delay(a0)
		move.w	buzzer_turn_delay(a0),d0
		cmpi.w	#$F,d0
		beq.s	Buzzer_TurnAround
		tst.w	d0
		bpl.s	locret_168E4
		subq.w	#1,buzzer_move_timer(a0)
		bgt.w	JmpTo6_ObjectMove
		move.w	#$1E,buzzer_turn_delay(a0)

locret_168E4:
		rts
; ---------------------------------------------------------------------------
; loc_168E6: Obj4B_TurnAround:
Buzzer_TurnAround:
		sf	buzzer_shooting_flag(a0)	; re-enable shooting
		neg.w	x_vel(a0)		; reverse movement direction
		bchg	#0,render_flags(a0)
		bchg	#0,status(a0)
		move.w	#$100,buzzer_move_timer(a0)
		rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16902: Obj4B_ChkPlayers:
Buzzer_ChkPlayers:
		tst.b	buzzer_shooting_flag(a0)
		bne.w	locret_1694E	; branch, if shooting is disabled
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0	; a1=character
		move.w	d0,d1
		bpl.s	loc_16918
		neg.w	d0

loc_16918:
		; test if player is inside an 8 pixel wide strip
		cmpi.w	#$28,d0
		blt.s	locret_1694E
		cmpi.w	#$30,d0
		bgt.s	locret_1694E

		tst.w	d1			; test sign of distance
		bpl.s	Buzzer_PlayerIsLeft	; branch, if player is left from object
		btst	#0,render_flags(a0)
		beq.s	locret_1694E		; branch, if object is facing right
		bra.s	Buzzer_ReadyToShoot
; ---------------------------------------------------------------------------
; loc_16932: Obj4B_PlayerIsLeft:
Buzzer_PlayerIsLeft:
		btst	#0,render_flags(a0)
		bne.s	locret_1694E	; branch, if object is facing left
; loc_1693A: Obj4B_ReadyToShoot:
Buzzer_ReadyToShoot:
		st	buzzer_shooting_flag(a0)	; disable shooting
		addq.b	#2,routine_secondary(a0)	; => Buzzer_Shooting
		move.b	#3,anim(a0)	; play shooting animation
		move.w	#$32,buzzer_shot_timer(a0)

locret_1694E:
		rts
; End of function Buzzer_ChkPlayers

; ===========================================================================
; loc_16950: Obj4B_Shooting:
Buzzer_Shooting:
		move.w	buzzer_shot_timer(a0),d0	; get timer value
		subq.w	#1,d0				; decrement
		blt.s	Buzzer_DoneShooting		; branch, if timer has expired
		move.w	d0,buzzer_shot_timer(a0)	; update timer value
		cmpi.w	#$14,d0				; has timer reached a certain value?
		beq.s	Buzzer_ShootProjectile		; if yes, branch
		rts
; ===========================================================================
; loc_16964: Obj4B_DoneShooting:
Buzzer_DoneShooting:
		subq.b	#2,routine_secondary(a0)	; => Buzzer_Roaming
		rts
; ===========================================================================
; loc_1696A: Obj4B_ShootProjectile:
Buzzer_ShootProjectile:
		jsr	(AllocateObjectAfterCurrent).l
		bne.s	locret_169D8

		move.b	#ObjID_Buzzer,id(a1) ; load Obj_Buzzer
		move.b	#6,routine(a1)	; => Buzzer_Projectile
		move.l	#MapUnc_Buzzer,mappings(a1)
		move.w	#$3E6,art_tile(a1)
		bsr.w	JmpTo_Adjust2PArtPointer2
		move.b	#4,priority(a1)
		move.b	#$98,collision_flags(a1)
		move.b	#$10,width_pixels(a1)
		move.b	status(a0),status(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	#2,anim(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	#$180,y_vel(a1)
		move.w	#-$180,x_vel(a1)
		btst	#0,render_flags(a1)	; is object facing left?
		beq.s	locret_169D8		; if not, branch
		neg.w	x_vel(a1)		; move in other direction

locret_169D8:
		rts
; ===========================================================================
; animation script
; off_169DA: Ani_obj4B:
Ani_Buzzer:	dc.w .moving-Ani_Buzzer
		dc.w .flame-Ani_Buzzer
		dc.w .bullet-Ani_Buzzer
		dc.w .shoot-Ani_Buzzer
; byte_169E2:
.moving:	dc.b  $F,  0,$FF
; byte_169E5:
.flame:		dc.b   2,  3,  4,$FF
; byte_169E9:
.bullet:	dc.b   3,  5,  6,$FF
; byte_169ED:
.shoot:		dc.b   9,  1,  1,  1,  1,  1,$FD,  0
		even

; ---------------------------------------------------------------------------
; Sprite mappings
; ---------------------------------------------------------------------------
; Map_obj4B:
MapUnc_Buzzer:	include "mappings/sprite/Badniks - Buzzer.asm"
		align 4