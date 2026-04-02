; ===========================================================================
; ---------------------------------------------------------------------------
; Object 49 - Waterfall from EHZ
;
; Internal name: "taki"
; ---------------------------------------------------------------------------
; OST:
waterfall_unk:		equ $30
; ---------------------------------------------------------------------------
; Sprite_15690: Obj49:
Obj_EHZWaterfall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	EHZWaterfall_Index(pc,d0.w),d1
		jmp	EHZWaterfall_Index(pc,d1.w)
; ===========================================================================
; off_1569E: Obj49_Index:
EHZWaterfall_Index:
		dc.w EHZWaterfall_Init-EHZWaterfall_Index
		dc.w EHZWaterfall_Main-EHZWaterfall_Index
; ===========================================================================
; loc_156A2: Obj49_Init:
EHZWaterfall_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_EHZWaterfall,mappings(a0)
		move.w	#$23AE,art_tile(a0)
		bsr.w	j_Adjust2PArtPointer_0
		move.b	#4,render_flags(a0)
		move.b	#$20,width_pixels(a0)
		move.w	x_pos(a0),waterfall_unk(a0)
		move.b	#0,priority(a0)
		move.b	#$80,y_radius(a0)
		bset	#4,render_flags(a0)
; loc_156DC: Obj49_Main:
EHZWaterfall_Main:
		tst.w	(Two_player_mode).w
		bne.s	loc_156F6
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_1586E

loc_156F6:
		move.w	x_pos(a0),d1
		move.w	d1,d2
		subi.w	#$40,d1
		addi.w	#$40,d2
		move.b	subtype(a0),d3
		move.b	#0,mapping_frame(a0)
		move.w	(MainCharacter+x_pos).w,d0
		cmp.w	d1,d0
		bcs.s	loc_15728
		cmp.w	d2,d0
		bcc.s	loc_15728
		move.b	#1,mapping_frame(a0)
		add.b	d3,mapping_frame(a0)
		bra.w	loc_15868
; ===========================================================================

loc_15728:
		move.w	(Sidekick+x_pos).w,d0
		cmp.w	d1,d0
		bcs.s	loc_1573A
		cmp.w	d2,d0
		bcc.s	loc_1573A
		move.b	#1,mapping_frame(a0)

loc_1573A:
		add.b	d3,mapping_frame(a0)
		bra.w	loc_15868
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj49:
MapUnc_EHZWaterfall:	include	"mappings/sprite/Waterfalls from EHZ.asm"