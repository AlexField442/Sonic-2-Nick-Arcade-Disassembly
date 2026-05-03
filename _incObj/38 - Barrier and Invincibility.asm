; ===========================================================================
; ---------------------------------------------------------------------------
; Object 38 - barrier and invincibility stars
;
; Internal name: "baria"
; ---------------------------------------------------------------------------
; Obj38:
Obj_Barrier:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Barrier_Index(pc,d0.w),d1
		jmp	Barrier_Index(pc,d1.w)
; ===========================================================================
; Obj38_Index:
Barrier_Index:	dc.w Barrier_Init-Barrier_Index
		dc.w Barrier_Shield-Barrier_Index
		dc.w Barrier_Stars-Barrier_Index
; ===========================================================================
; Obj38_Init:
Barrier_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_Barrier,mappings(a0)
		move.b	#4,render_flags(a0)
		move.b	#1,priority(a0)
		move.b	#$18,width_pixels(a0)
		tst.b	anim(a0)		; is this the shield?
		bne.s	loc_1240C		; if not, branch
		move.w	#$4BE,art_tile(a0)
		cmpi.b	#3,(Current_Zone).w	; is this Emerald Hill Zone?
		bne.s	loc_12406		; if not, branch
		move.w	#$560,art_tile(a0)

loc_12406:
		bsr.w	Adjust2PArtPointer
		rts
; ===========================================================================

loc_1240C:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_Sonic,mappings(a0)
		move.w	#$4DE,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#2,priority(a0)
		rts
; ===========================================================================
; Obj38_Shield:
Barrier_Shield:
		tst.b	(Invincibility_flag).w	; is Sonic invincible?
		bne.s	locret_1245A	; if yes, branch
		tst.b	(Shield_flag).w	; does Sonic have a shield?
		beq.s	Barrier_Delete	; if not, branch
		move.w	(MainCharacter+x_pos).w,x_pos(a0)
		move.w	(MainCharacter+y_pos).w,y_pos(a0)
		move.b	(MainCharacter+status).w,status(a0)
		lea	(Ani_Barrier).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------

locret_1245A:
		rts
; ===========================================================================
; loc_1245C: Obj38_Delete:
Barrier_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
; This code has some connection to Unused_RecordPos, as both use Tails'
; old position buffer for something
; Obj38_Stars:
Barrier_Stars:
		tst.b	(Invincibility_flag).w	; is Sonic invincible?
		beq.s	Barrier_Delete2	; if not, branch
		move.w	(unk_EEE0).w,d0
		move.b	anim(a0),d1
		subq.b	#1,d1
		move.b	#$3F,d1
		lsl.b	#2,d1
		addi.b	#4,d1
		sub.b	d1,d0
		lea	(unk_E600).w,a1
		lea	(a1,d0.w),a1
		move.w	(a1)+,d0
		andi.w	#$3FFF,d0
		move.w	d0,x_pos(a0)
		move.w	(a1)+,d0
		andi.w	#$7FF,d0
		move.w	d0,y_pos(a0)
		move.b	(MainCharacter+status).w,status(a0)
		move.b	(MainCharacter+mapping_frame).w,mapping_frame(a0)
		move.b	(MainCharacter+render_flags).w,render_flags(a0)
		jmp	(DisplaySprite).l
; ===========================================================================
; loc_124B2: Obj38_Delete2:
Barrier_Delete2:
		jmp	(DeleteObject).l

; ===========================================================================

include_Ani_Barrier:	macro
; animation script
; Ani_obj38:
Ani_Barrier:	dc.w byte_125C2-Ani_Barrier
		dc.w byte_125CE-Ani_Barrier
		dc.w byte_125D4-Ani_Barrier
		dc.w byte_125EE-Ani_Barrier
		dc.w byte_12608-Ani_Barrier
byte_125C2:	dc.b   0,  5,  0,  5,  1,  5,  2,  5,  3,  5,  4,$FF
byte_125CE:	dc.b   5,  4,  5,  6,  7,$FF
byte_125D4:	dc.b   0,  4,  4,  0,  4,  4,  0,  5,  5,  0,  5,  5,  0,  6,  6,  0
		dc.b   6,  6,  0,  7,  7,  0,  7,  7,  0,$FF
byte_125EE:	dc.b   0,  4,  4,  0,  4,  0,  0,  5,  5,  0,  5,  0,  0,  6,  6,  0
		dc.b   6,  0,  0,  7,  7,  0,  7,  0,  0,$FF
byte_12608:	dc.b   0,  4,  0,  0,  4,  0,  0,  5,  0,  0,  5,  0,  0,  6,  0,  0
		dc.b   6,  0,  0,  7,  0,  0,  7,  0,  0,$FF
		even
		endm

; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------

include_MapUnc_Barrier:	macro
; Map_obj38:
MapUnc_Barrier:	include	"mappings/sprite/Barrier and Invincibility.asm"
		endm