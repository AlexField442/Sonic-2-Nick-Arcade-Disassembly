; ===========================================================================
; ---------------------------------------------------------------------------
; Pseudo-object that manages where rings are placed onscreen
; as you move through the level, and otherwise updates them.
; ---------------------------------------------------------------------------

; RingPosLoad:
RingsManager:
		moveq	#0,d0
		move.b	(Rings_manager_routine).w,d0
		move.w	RingsManager_States(pc,d0.w),d0
		jmp	RingsManager_States(pc,d0.w)
; End of function RingsManager

; ===========================================================================
; RPL_Index:
RingsManager_States:
		dc.w RingsManager_Init-RingsManager_States
		dc.w RingsManager_Main-RingsManager_States
; ===========================================================================
; RPL_Main:
RingsManager_Init:
		addq.b	#2,(Rings_manager_routine).w	; => RingsManager_Main
		bsr.w	RingsManager_Setup	; perform initial setup
		lea	(Ring_Positions).w,a1
		move.w	(Camera_X_pos).w,d4
		subq.w	#8,d4
		bhi.s	loc_D896
		moveq	#1,d4			; no negative values allowed
		bra.s	loc_D896
; ---------------------------------------------------------------------------

loc_D892:
		lea	6(a1),a1		; load next ring

loc_D896:
		cmp.w	2(a1),d4		; is the X pos of the ring < camera X pos?
		bhi.s	loc_D892		; if it is, check next ring
		move.w	a1,(Ring_start_addr).w	; set start addresses
		move.w	a1,(Ring_start_addr_P2).w
		addi.w	#$150,d4		; advance by a screen
		bra.s	loc_D8AE
; ---------------------------------------------------------------------------

loc_D8AA:
		lea	6(a1),a1		; load next ring

loc_D8AE:
		cmp.w	2(a1),d4		; is the X pos of the ring < camera X + 336?
		bhi.s	loc_D8AA		; if it is, check next ring
		move.w	a1,(Ring_end_addr).w	; set end addresses
		move.w	a1,(Ring_end_addr_P2).w
		move.b	#1,(Level_started_flag).w
		rts
; ===========================================================================
; RPL_Next:
RingsManager_Main:
		lea	(Ring_Positions).w,a1
		move.w	#$FF,d1

loc_D8CC:
		move.b	(a1),d0		; is there a ring in this slot?
		beq.s	loc_D8EA	; if not, branch
		bmi.s	loc_D8EA
		subq.b	#1,(a1)		; decrement timer
		bne.s	loc_D8EA	; if it's not 0 yet, branch
		move.b	#6,(a1)		; reset timer
		addq.b	#1,1(a1)	; increment frame
		cmpi.b	#8,1(a1)	; is it destruction time yet?
		bne.s	loc_D8EA	; if not, branch
		move.w	#-1,(a1)	; destroy ring

loc_D8EA:
		lea	6(a1),a1
		dbf	d1,loc_D8CC

		; update ring start and end addresses
		movea.w	(Ring_start_addr).w,a1
		move.w	(Camera_X_pos).w,d4
		subq.w	#8,d4
		bhi.s	loc_D906
		moveq	#1,d4
		bra.s	loc_D906
; ---------------------------------------------------------------------------

loc_D902:
		lea	6(a1),a1

loc_D906:
		cmp.w	2(a1),d4
		bhi.s	loc_D902
		bra.s	loc_D910
; ---------------------------------------------------------------------------

loc_D90E:
		subq.w	#6,a1

loc_D910:
		cmp.w	-4(a1),d4
		bls.s	loc_D90E
		move.w	a1,(Ring_start_addr).w	; update start address

		movea.w	(Ring_end_addr).w,a2
		addi.w	#$150,d4
		bra.s	loc_D928
; ---------------------------------------------------------------------------

loc_D924:
		lea	6(a2),a2

loc_D928:
		cmp.w	2(a2),d4
		bhi.s	loc_D924
		bra.s	loc_D932
; ---------------------------------------------------------------------------

loc_D930:
		subq.w	#6,a2

loc_D932:
		cmp.w	-4(a2),d4
		bls.s	loc_D930
		move.w	a2,(Ring_end_addr).w	; update end address
		tst.w	(Two_player_mode).w	; are we in 2P mode?
		bne.s	loc_D94C		; if we are, update P2 addresses
		move.w	a1,(Ring_start_addr_P2).w	; otherwise, copy over P1 addresses
		move.w	a2,(Ring_end_addr_P2).w
		rts
; ---------------------------------------------------------------------------

loc_D94C:
		; update ring start and end addresses for P2
		movea.w	(Ring_start_addr_P2).w,a1
		move.w	(Camera_X_pos_P2).w,d4
		subq.w	#8,d4
		bhi.s	loc_D960
		moveq	#1,d4
		bra.s	loc_D960
; ---------------------------------------------------------------------------

loc_D95C:
		lea	6(a1),a1

loc_D960:
		cmp.w	2(a1),d4
		bhi.s	loc_D95C
		bra.s	loc_D96A
; ---------------------------------------------------------------------------

loc_D968:
		subq.w	#6,a1

loc_D96A:
		cmp.w	-4(a1),d4
		bls.s	loc_D968
		move.w	a1,(Ring_start_addr_P2).w	; update start address

		movea.w	(Ring_end_addr_P2).w,a2
		addi.w	#$150,d4
		bra.s	loc_D982
; ---------------------------------------------------------------------------

loc_D97E:
		lea	6(a2),a2

loc_D982:
		cmp.w	2(a2),d4
		bhi.s	loc_D97E
		bra.s	loc_D98C
; ---------------------------------------------------------------------------

loc_D98A:
		subq.w	#6,a2

loc_D98C:
		cmp.w	-4(a2),d4
		bls.s	loc_D98A
		move.w	a2,(Ring_end_addr_P2).w		; update end address
		rts

; ---------------------------------------------------------------------------
; Subroutine to handle ring collision
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_D998:
Touch_Rings:
		movea.w	(Ring_start_addr).w,a1
		movea.w	(Ring_end_addr).w,a2
		cmpa.w	#MainCharacter,a0
		beq.s	loc_D9AE
		movea.w	(Ring_start_addr_P2).w,a1
		movea.w	(Ring_end_addr_P2).w,a2

loc_D9AE:
		cmpa.l	a1,a2
		beq.w	locret_DA36
		cmpi.w	#$5A,invulnerable_time(a0)
		bcc.s	locret_DA36
		move.w	x_pos(a0),d2
		move.w	y_pos(a0),d3
		subi.w	#8,d2
		moveq	#0,d5
		move.b	y_radius(a0),d5
		subq.b	#3,d5
		sub.w	d5,d3
		cmpi.b	#$39,mapping_frame(a0)
		bne.s	loc_D9E0
		addi.w	#$C,d3
		moveq	#$A,d5

loc_D9E0:				; CODE XREF: Touch_Rings+40j
		move.w	#6,d1
		move.w	#$C,d6
		move.w	#$10,d4
		add.w	d5,d5

loc_D9EE:				; CODE XREF: Touch_Rings+9Aj
		tst.w	(a1)
		bne.w	loc_DA2C
		move.w	2(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	loc_DA06
		add.w	d6,d0
		bcs.s	loc_DA0C
		bra.w	loc_DA2C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_DA06:				; CODE XREF: Touch_Rings+64j
		cmp.w	d4,d0
		bhi.w	loc_DA2C

loc_DA0C:				; CODE XREF: Touch_Rings+68j
		move.w	4(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	loc_DA1E
		add.w	d6,d0
		bcs.s	loc_DA24
		bra.w	loc_DA2C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_DA1E:				; CODE XREF: Touch_Rings+7Cj
		cmp.w	d5,d0
		bhi.w	loc_DA2C

loc_DA24:				; CODE XREF: Touch_Rings+80j
		move.w	#$604,(a1)
		bsr.w	sub_A8DE

loc_DA2C:				; CODE XREF: Touch_Rings+58j Touch_Rings+6Aj ...
		lea	6(a1),a1
		cmpa.l	a1,a2
		bne.w	loc_D9EE

locret_DA36:				; CODE XREF: Touch_Rings+18j Touch_Rings+22j
		rts
; End of function Touch_Rings


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ

; BuildSprites2:
BuildRings:
		movea.w	(Ring_start_addr).w,a0
		movea.w	(Ring_end_addr).w,a4
		cmpa.l	a0,a4
		bne.s	loc_DA46
		rts

loc_DA46:
		lea	(Camera_X_pos).w,a3

loc_DA4A:
		tst.w	(a0)			; has the ring been consumed?
		bmi.w	BuildRings_NextRing	; if yes, branch
		move.w	2(a0),d3		; get ring X position
		sub.w	(a3),d3			; subtract the camera's X position
		addi.w	#$80,d3
		move.w	4(a0),d2		; get ring Y position
		sub.w	4(a3),d2		; subtract the camera's Y position
		addi.w	#8,d2
		bmi.s	BuildRings_NextRing
		cmpi.w	#$F0,d2
		bge.s	BuildRings_NextRing	; if the ring is not visible, branch
		addi.w	#$78,d2
		lea	(off_DC04).l,a1
		moveq	#0,d1
		move.b	1(a0),d1
		bne.s	loc_DA84
		move.b	($FFFFFEC3).w,d1

loc_DA84:
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.w	(a1)+,d0
		addi.w	#$26BC,d0
		move.w	d0,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		add.w	d3,d0
		move.w	d0,(a2)+
; loc_DAA8:
BuildRings_NextRing:
		lea	6(a0),a0
		cmpa.l	a0,a4
		bne.w	loc_DA4A
		rts
; End of function BuildRings

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


BuildSprites2_2p:			; CODE XREF: BuildSprites+322p
		lea	(Camera_X_pos).w,a3
		move.w	#$78,d6	; 'x'
		movea.w	(Ring_start_addr).w,a0
		movea.w	(Ring_end_addr).w,a4
		cmpa.l	a0,a4
		bne.s	loc_DAE0
		rts
; End of function BuildSprites2_2p


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_DACA:				; CODE XREF: BuildSprites+444p
		lea	(Camera_X_pos_P2).w,a3
		move.w	#$158,d6
		movea.w	(Ring_start_addr_P2).w,a0
		movea.w	(Ring_end_addr_P2).w,a4
		cmpa.l	a0,a4
		bne.s	loc_DAE0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_DAE0:				; CODE XREF: BuildSprites2_2p+12j
					; sub_DACA+12j	...
		tst.w	(a0)
		bmi.w	loc_DB40
		move.w	2(a0),d3
		sub.w	(a3),d3
		addi.w	#$80,d3	; '€'
		move.w	4(a0),d2
		sub.w	4(a3),d2
		addi.w	#$88,d2	; 'ˆ'
		bmi.s	loc_DB40
		cmpi.w	#$170,d2
		bge.s	loc_DB40
		add.w	d6,d2
		lea	(off_DC04).l,a1
		moveq	#0,d1
		move.b	1(a0),d1
		bne.s	loc_DB18
		move.b	($FFFFFEC3).w,d1

loc_DB18:				; CODE XREF: sub_DACA+48j
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	byte_DB4C(pc,d4.w),(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		addi.w	#$235E,d0
		move.w	d0,(a2)+
		move.w	(a1)+,d0
		add.w	d3,d0
		move.w	d0,(a2)+

loc_DB40:				; CODE XREF: sub_DACA+18j sub_DACA+32j ...
		lea	6(a0),a0
		cmpa.l	a0,a4
		bne.w	loc_DAE0
		rts
; End of function sub_DACA

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_DB4C:	dc.b   0,  0,  1,  1	; 0
		dc.b   4,  4,  5,  5	; 4
		dc.b   8,  8,  9,  9	; 8
		dc.b  $C, $C, $D, $D	; 12

; ---------------------------------------------------------------------------
; Subroutine to perform initial rings manager setup
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; RingsManager2:
RingsManager_Setup:
		lea	(Ring_Positions).w,a1
		moveq	#0,d0
		move.w	#(Ring_Positions_End-Ring_Positions)/4-1,d1

loc_DB66:
		move.l	d0,(a1)+
		dbf	d1,loc_DB66
		moveq	#0,d0
		move.w	(Current_ZoneAndAct).w,d0
		lsl.b	#6,d0
		lsr.w	#5,d0
		lea	(RingPos_Index).l,a1
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		lea	(Ring_Positions+6).w,a2
; loc_DB88:
RingsMgr_NextRowOrCol:
		move.w	(a1)+,d2
		bmi.s	RingsMgr_SortRings
		move.w	(a1)+,d3
		bmi.s	RingsMgr_RingCol
		move.w	d3,d0
		rol.w	#4,d0
		andi.w	#7,d0
		andi.w	#$FFF,d3
; loc_DB9C:
RingsMgr_NextRingInRow:
		move.w	#0,(a2)+
		move.w	d2,(a2)+
		move.w	d3,(a2)+
		addi.w	#$18,d2
		dbf	d0,RingsMgr_NextRingInRow
		bra.s	RingsMgr_NextRowOrCol
; ===========================================================================
; loc_DBAE:
RingsMgr_RingCol:
		move.w	d3,d0
		rol.w	#4,d0
		andi.w	#7,d0
		andi.w	#$FFF,d3
; loc_DBBA:
RingsMgr_NextRingInCol:
		move.w	#0,(a2)+
		move.w	d2,(a2)+
		move.w	d3,(a2)+
		addi.w	#$18,d3
		dbf	d0,RingsMgr_NextRingInCol
		bra.s	RingsMgr_NextRowOrCol
; ===========================================================================
; loc_DBCC:
RingsMgr_SortRings:
		moveq	#-1,d0
		move.l	d0,(a2)+
		lea	(Ring_Positions+2).w,a1
		move.w	#$FE,d3

loc_DBD8:
		move.w	d3,d4
		lea	6(a1),a2
		move.w	(a1),d0

loc_DBE0:
		tst.w	(a2)
		beq.s	loc_DBF2
		cmp.w	(a2),d0
		bls.s	loc_DBF2
		move.l	(a1),d1
		move.l	(a2),d0
		move.l	d0,(a1)
		move.l	d1,(a2)
		swap	d0

loc_DBF2:
		lea	6(a2),a2
		dbf	d4,loc_DBE0
		lea	6(a1),a1
		dbf	d3,loc_DBD8
		rts
; End of function RingsManager_Setup

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
off_DC04:	incbin	"mappings/sprite/Rings.bin"