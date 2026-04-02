; ===========================================================================
; ---------------------------------------------------------------------------
; Object 16 - Diagonally moving lift from HTZ
;
; Internal name: "cablecar"
; ---------------------------------------------------------------------------
; OST:
lift_routine2:		equ $28
lift_unk1:		equ $30
lift_unk2:		equ $32
lift_movetimer:		equ $34		; time for lift to move before stopping
; ---------------------------------------------------------------------------
; Sprite_150FC: Obj16:
Obj_HTZLift:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	HTZLift_Index(pc,d0.w),d1
		jmp	HTZLift_Index(pc,d1.w)
; ===========================================================================
; off_15112: Obj16_Index:
HTZLift_Index:	dc.w HTZLift_Init-HTZLift_Index
		dc.w HTZLift_Main-HTZLift_Index
; ===========================================================================
; loc_1510E: Obj16_Init:
HTZLift_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_HTZLift,mappings(a0)
		move.w	#$43E6,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$20,width_pixels(a0)
		move.b	#0,mapping_frame(a0)
		move.b	#1,priority(a0)
		move.w	x_pos(a0),lift_unk1(a0)
		move.w	y_pos(a0),lift_unk2(a0)
; loc_15150: Obj16_Main:
HTZLift_Main:
		move.w	x_pos(a0),-(sp)
		bsr.w	HTZLift_MoveRoutines
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		move.w	#$FFD8,d3
		move.w	(sp)+,d4
		bsr.w	PlatformObject
		move.w	lift_unk1(a0),d0
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_152AA
		bra.w	loc_152A4
; ===========================================================================
; sub_15184:
HTZLift_MoveRoutines:
		moveq	#0,d0
		move.b	lift_routine2(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	HTZLift_Main_States(pc,d0.w),d1
		jmp	HTZLift_Main_States(pc,d1.w)
; End of function sub_15184

; ===========================================================================
; off_15198: Obj16_SubIndex:
HTZLift_Main_States:
		dc.w HTZLift_Wait-HTZLift_Main_States
		dc.w HTZLift_Slide-HTZLift_Main_States
		dc.w HTZLift_Stall-HTZLift_Main_States
; ===========================================================================
; loc_1519E: Obj16_InitMove:
HTZLift_Wait:
		move.b	status(a0),d0
		andi.b	#$18,d0		; is one of the players standing on the lift?
		beq.s	locret_151BE	; if not, branch
		addq.b	#1,lift_routine2(a0)
		move.w	#$200,x_vel(a0)
		move.w	#$100,y_vel(a0)
		move.w	#$A0,lift_movetimer(a0)

locret_151BE:
		rts
; ===========================================================================
; loc_151C0: Obj16_Move:
HTZLift_Slide:
		bsr.w	j_ObjectMove_0
		subq.w	#1,lift_movetimer(a0)
		bne.s	locret_151CE
		addq.b	#1,lift_routine2(a0)
		; Nothing to handle it breaking yet.

locret_151CE:
		rts
; ===========================================================================
; locret_151D0: Obj16_NoMove:
HTZLift_Stall:
		; After we have stopped moving, do nothing. The final game
		; uses this routine to clear the player's standing flags.
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj16:
MapUnc_HTZLift:		include	"mappings/sprite/HTZ Lifts.asm"
		nop