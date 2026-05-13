; ===========================================================================
; ---------------------------------------------------------------------------
; Sonic	1 Object 7C - giant ring flash (unused, pointer removed)
;
; Internal name: "ebigring"
;----------------------------------------------------------------------------
; OST:
ringflash_parent:		equ $3C		; 4 bytes
; ---------------------------------------------------------------------------
; Sprite_AB3C: Obj_S1Obj7C:
Obj_GiantRingFlash:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	GiantRingFlash_Index(pc,d0.w),d1
		jmp	GiantRingFlash_Index(pc,d1.w)
; ===========================================================================
; off_AB4A: Obj_S1Obj7C_Index:
GiantRingFlash_Index:
		dc.w GiantRingFlash_Init-GiantRingFlash_Index
		dc.w GiantRingFlash_Main-GiantRingFlash_Index
		dc.w GiantRingFlash_Delete-GiantRingFlash_Index
; ===========================================================================
; loc_AB50:
GiantRingFlash_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_GiantRingFlash,mappings(a0)
		move.w	#$2462,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#0,priority(a0)
		move.b	#$20,width_pixels(a0)
		move.b	#$FF,mapping_frame(a0)
; loc_AB7E:
GiantRingFlash_Main:
		bsr.s	GiantRingFlash_Enter
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
; sub_AB98:
GiantRingFlash_Enter:
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	locret_ABD6
		move.b	#1,anim_frame_duration(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#8,mapping_frame(a0)
		bcc.s	GiantRingFlash_RemoveCharacter
		cmpi.b	#3,mapping_frame(a0)
		bne.s	locret_ABD6
		movea.l	ringflash_parent(a0),a1
		move.b	#6,routine(a1)
		move.b	#$1C,(MainCharacter+anim).w
		move.b	#1,(EnterSS_flag).w
		clr.b	(Invincibility_flag).w
		clr.b	(Shield_flag).w

locret_ABD6:
		rts
; ===========================================================================
; loc_ABD8:
GiantRingFlash_RemoveCharacter:
		addq.b	#2,routine(a0)
		move.w	#0,(MainCharacter).w
		addq.l	#4,sp
		rts
; ===========================================================================
; loc_ABE6:
GiantRingFlash_Delete:
		bra.w	DeleteObject
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
include_MapUnc_GiantRingFlash macro
; Map_S1Obj7C:
MapUnc_GiantRingFlash:	include	"mappings/sprite/Giant Ring Flash.asm"
		nop
		endm