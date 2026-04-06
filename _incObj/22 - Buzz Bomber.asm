; ===========================================================================
; ---------------------------------------------------------------------------
; Object 22 - Buzz Bomber from GHZ
;
; Internal name: "hachi"
; ---------------------------------------------------------------------------
; OST:
buzzbomber_time:	equ $32		; time to wait for performing an action
buzzbomber_status:	equ $34		; 0 = still, 1 = flying, 2 = shooting
buzzbomber_parent:	equ $3C
; ---------------------------------------------------------------------------
; Sprite_A408: Obj22:
Obj_BuzzBomber:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	BuzzBomber_Index(pc,d0.w),d1
		jmp	BuzzBomber_Index(pc,d1.w)
; ===========================================================================
; Obj22_Index:
BuzzBomber_Index:
		dc.w BuzzBomber_Init-BuzzBomber_Index
		dc.w BuzzBomber_Main-BuzzBomber_Index
		dc.w BuzzBomber_Delete-BuzzBomber_Index
; ===========================================================================
; loc_A41C: Obj22_Init:
BuzzBomber_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_BuzzBomber,mappings(a0)
		move.w	#$444,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#3,priority(a0)
		move.b	#8,collision_flags(a0)
		move.b	#$18,width_pixels(a0)
; loc_A44A: Obj22_Main:
BuzzBomber_Main:
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	BuzzBomber_Main_Index(pc,d0.w),d1
		jsr	BuzzBomber_Main_Index(pc,d1.w)
		lea	(Ani_BuzzBomber).l,a1
		bsr.w	AnimateSprite
		bra.w	MarkObjGone
; ===========================================================================
; Obj22_Main_Index:
BuzzBomber_Main_Index:
		dc.w BuzzBomber_Move-BuzzBomber_Main_Index
		dc.w BuzzBomber_NearSonic-BuzzBomber_Main_Index
; ===========================================================================
; loc_A46A: Obj22_Move:
BuzzBomber_Move:
		subq.w	#1,buzzbomber_time(a0)
		bpl.s	locret_A49A
		btst	#1,buzzbomber_status(a0)
		bne.s	BuzzBomber_LoadMissile
		addq.b	#2,routine_secondary(a0)
		move.w	#$7F,buzzbomber_time(a0)
		move.w	#$400,x_vel(a0)
		move.b	#1,anim(a0)
		btst	#0,status(a0)
		bne.s	locret_A49A
		neg.w	x_vel(a0)

locret_A49A:
		rts
; ===========================================================================
; loc_A49C: Obj22_LoadMissile:
BuzzBomber_LoadMissile:
		bsr.w	AllocateObject
		bne.s	locret_A4FE
		move.b	#ObjID_Missile,id(a1)	; load Obj23 (Buzz Bomber/Newtron missile)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		addi.w	#$1C,y_pos(a1)
		move.w	#$200,y_vel(a1)
		move.w	#$200,x_vel(a1)
		move.w	#$18,d0
		btst	#0,status(a0)
		bne.s	loc_A4D8
		neg.w	d0
		neg.w	x_vel(a1)

loc_A4D8:
		add.w	d0,x_pos(a1)
		move.b	status(a0),status(a1)
		move.w	#$E,buzzbomber_time(a1)
		move.l	a0,buzzbomber_parent(a1)
		move.b	#1,buzzbomber_status(a0)
		move.w	#$3B,buzzbomber_time(a0)
		move.b	#2,anim(a0)

locret_A4FE:
		rts
; ===========================================================================
; loc_A500: Obj22_NearSonic:
BuzzBomber_NearSonic:
		subq.w	#1,buzzbomber_time(a0)
		bmi.s	loc_A536
		bsr.w	ObjectMove
		tst.b	buzzbomber_status(a0)
		bne.s	locret_A558
		move.w	(MainCharacter+x_pos).w,d0
		sub.w	x_pos(a0),d0
		bpl.s	loc_A51C
		neg.w	d0

loc_A51C:
		cmpi.w	#$60,d0		; is Buzz Bomber within $60 pixels of Sonic?
		bcc.s	locret_A558	; if not, branch
		tst.b	render_flags(a0)
		bpl.s	locret_A558
		move.b	#2,buzzbomber_status(a0)
		move.w	#$1D,buzzbomber_time(a0)
		bra.s	loc_A548
; ===========================================================================

loc_A536:
		move.b	#0,buzzbomber_status(a0)
		bchg	#0,status(a0)
		move.w	#$3B,buzzbomber_time(a0)

loc_A548:
		subq.b	#2,routine_secondary(a0)
		move.w	#0,x_vel(a0)
		move.b	#0,anim(a0)

locret_A558:
		rts
; ===========================================================================
; loc_A55A: Obj22_Delete:
BuzzBomber_Delete:
		bra.w	DeleteObject

; ===========================================================================
; ---------------------------------------------------------------------------
; animation script - Buzz Bomber
; ---------------------------------------------------------------------------
include_Ani_BuzzBomber: macro
; Ani_obj22:
Ani_BuzzBomber:	dc.w byte_A652-Ani_BuzzBomber
		dc.w byte_A656-Ani_BuzzBomber
		dc.w byte_A65A-Ani_BuzzBomber
byte_A652:	dc.b   1,  0,  1,$FF
byte_A656:	dc.b   1,  2,  3,$FF
byte_A65A:	dc.b   1,  4,  5,$FF
		even
		endm

; ---------------------------------------------------------------------------
; sprite mappings - Buzz Bomber
; ---------------------------------------------------------------------------
include_MapUnc_BuzzBomber: macro
; Map_obj22:
MapUnc_BuzzBomber:	incbin	"mappings/sprite/obj22.bin"
		endm