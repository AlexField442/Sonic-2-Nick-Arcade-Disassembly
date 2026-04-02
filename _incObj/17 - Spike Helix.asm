; ===========================================================================
; ---------------------------------------------------------------------------
; Object 17 - GHZ rotating log helix spikes
;
; Internal name: "thashi"
; ---------------------------------------------------------------------------
; OST:
spikehelix_frame:	equ $3E		; start frame (different for each sprite)
; ---------------------------------------------------------------------------
; Sprite_866C: Obj17:
Obj_SpikeHelix:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	SpikeHelix_Index(pc,d0.w),d1
		jmp	SpikeHelix_Index(pc,d1.w)
; ===========================================================================
; off_867A: Obj17_Index:
SpikeHelix_Index:	dc.w SpikeHelix_Init-SpikeHelix_Index
		dc.w SpikeHelix_Main-SpikeHelix_Index
		dc.w SpikeHelix_Display-SpikeHelix_Index
; ===========================================================================
; loc_8680:
SpikeHelix_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_SpikeHelix,mappings(a0)
		move.w	#$4398,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#7,status(a0)
		move.b	#4,render_flags(a0)
		move.b	#3,priority(a0)
		move.b	#8,width_pixels(a0)
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		move.b	id(a0),d4
		lea	subtype(a0),a2
		moveq	#0,d1
		move.b	(a2),d1			; move helix length to d1
		move.b	#0,(a2)+
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3			; d3 = x-position of leftmost sprite
		subq.b	#2,d1			; d1 = number of spikes, excluding parent and first loop
		bcs.s	SpikeHelix_Main		; if we only have one spike, branch
		moveq	#0,d6
; loc_86D4:
SpikeHelix_MakeHelix:
		bsr.w	AllocateObjectAfterCurrent
		bne.s	SpikeHelix_Main
		addq.b	#1,subtype(a0)
		move.w	a1,d5
		subi.w	#Object_RAM,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#4,routine(a1)
		move.b	d4,id(a1)
		move.w	d2,y_pos(a1)
		move.w	d3,x_pos(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	#$4398,art_tile(a1)
		bsr.w	Adjust2PArtPointer2
		move.b	#4,render_flags(a1)
		move.b	#3,priority(a1)
		move.b	#8,width_pixels(a1)
		move.b	d6,spikehelix_frame(a1)	; set frame for current spike
		addq.b	#1,d6			; use next frame on next spike
		andi.b	#7,d6
		addi.w	#$10,d3			; x-position of next spike
		cmp.w	x_pos(a0),d3		; is this spike in the center?
		bne.s	loc_8746		; if not, branch

		move.b	d6,spikehelix_frame(a0)	; set parent spike frame
		addq.b	#1,d6
		andi.b	#7,d6
		addi.w	#$10,d3
		addq.b	#1,subtype(a0)

loc_8746:
		dbf	d1,SpikeHelix_MakeHelix	; repeat d1 times (helix length)
; loc_874A:
SpikeHelix_Main:
		bsr.w	SpikeHelix_RotateSpike
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	SpikeHelix_DeleteAll
		bra.w	DisplaySprite
; ===========================================================================
; loc_8766:
SpikeHelix_DeleteAll:
		moveq	#0,d2
		lea	subtype(a0),a2
		move.b	(a2)+,d2		; d2 = helix length
		subq.b	#2,d2
		bcs.s	SpikeHelix_Delete
; loc_8772:
SpikeHelix_DeleteLoop:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#Object_RAM,d0
		movea.l	d0,a1			; get child address
		bsr.w	DeleteObject2
		dbf	d2,SpikeHelix_DeleteLoop	; repeat d2 times (helix length)
; loc_8788:
SpikeHelix_Delete:
		bra.w	DeleteObject

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_878C:
SpikeHelix_RotateSpike:
		move.b	($FFFFFEC1).w,d0	; get synchronised frame value
		move.b	#0,$20(a0)		; make object harmless
		add.b	spikehelix_frame(a0),d0	; add initial frame
		andi.b	#7,d0
		move.b	d0,mapping_frame(a0)	; change current frame
		bne.s	locret_87AA		; if it isn't frame 0, branch
		move.b	#$84,$20(a0)		; make object harmful

locret_87AA:
		rts
; End of function Obj17_RotateSpike

; ===========================================================================
; loc_87AC:
SpikeHelix_Display:
		bsr.w	SpikeHelix_RotateSpike
		bra.w	DisplaySprite
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj34:
MapUnc_SpikeHelix:	include	"mappings/sprite/Spike Helix.asm"