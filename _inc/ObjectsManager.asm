; ===========================================================================
; ---------------------------------------------------------------------------
; Objects Manager
; Subroutine that keeps track of any objects that need to remember
; their state, such as monitors or enemies.
;
; input variables:
;  -none-
;
; writes:
;  d0, d1
;  d2 = respawn index of object to load
;  d6 = camera position
;
;  a0 = address in object placement list
;  a2 = respawn table
; ---------------------------------------------------------------------------

; ObjPosLoad:
ObjectsManager:
		moveq	#0,d0
		move.b	(Obj_placement_routine).w,d0
		move.w	ObjectsManager_States(pc,d0.w),d0
		jmp	ObjectsManager_States(pc,d0.w)
; End of function ObjectsManager

; ===========================================================================
; OPL_Index:
ObjectsManager_States:	
		dc.w ObjectsManager_Init-ObjectsManager_States
		dc.w ObjectsManager_Main-ObjectsManager_States
		dc.w loc_DE5C-ObjectsManager_States
; ===========================================================================
; loc_DC68:
ObjectsManager_Init:
		addq.b	#2,(Obj_placement_routine).w
		move.w	(Current_ZoneAndAct).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	(ObjPos_Index).l,a0
		movea.l	a0,a1
		adda.w	(a0,d0.w),a0
		move.l	a0,(Obj_load_addr_right).w
		move.l	a0,(Obj_load_addr_left).w
		move.l	a0,(Obj_load_addr_right_P2).w
		move.l	a0,(Obj_load_addr_left_P2).w
		lea	(Object_Respawn_Table).w,a2
		move.w	#$101,(a2)+
		; This is bugged; this should divide by 4, not 2; as a result, this causes
		; $17C bytes to be cleared instead of $BE.
		move.w	#(Obj_respawn_data_End-Obj_respawn_data)/2-1,d0

loc_DC9C:
		clr.l	(a2)+
		dbf	d0,loc_DC9C
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d2
		move.w	(Camera_X_pos).w,d6
		subi.w	#$80,d6
		bcc.s	loc_DCB4
		moveq	#0,d6

loc_DCB4:
		andi.w	#$FF80,d6
		movea.l	(Obj_load_addr_right).w,a0

loc_DCBC:
		cmp.w	(a0),d6
		bls.s	loc_DCCE
		tst.b	4(a0)
		bpl.s	loc_DCCA
		move.b	(a2),d2
		addq.b	#1,(a2)

loc_DCCA:
		addq.w	#6,a0
		bra.s	loc_DCBC
; ===========================================================================

loc_DCCE:
		move.l	a0,(Obj_load_addr_right).w
		move.l	a0,(Obj_load_addr_right_P2).w
		movea.l	(Obj_load_addr_left).w,a0
		subi.w	#$80,d6
		bcs.s	loc_DCF2

loc_DCE0:
		cmp.w	(a0),d6
		bls.s	loc_DCF2
		tst.b	4(a0)
		bpl.s	loc_DCEE
		addq.b	#1,1(a2)

loc_DCEE:
		addq.w	#6,a0
		bra.s	loc_DCE0
; ===========================================================================

loc_DCF2:
		move.l	a0,(Obj_load_addr_left).w
		move.l	a0,(Obj_load_addr_left_P2).w
		move.w	#-1,(Camera_X_pos_last).w
		move.w	#-1,(Camera_X_pos_last_P2).w
		tst.w	(Two_player_mode).w
		beq.s	ObjectsManager_Main
		addq.b	#2,(Obj_placement_routine).w
		bra.w	loc_DDE0
; ===========================================================================
; loc_DD14:
ObjectsManager_Main:
		move.w	(Camera_X_pos).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		move.w	d1,(Camera_X_pos_coarse).w
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d2
		move.w	(Camera_X_pos).w,d6
		andi.w	#$FF80,d6
		cmp.w	(Camera_X_pos_last).w,d6
		beq.w	locret_DDDE
		bge.s	loc_DD9A
		move.w	d6,(Camera_X_pos_last).w
		movea.l	(Obj_load_addr_left).w,a0
		subi.w	#$80,d6
		bcs.s	loc_DD76

loc_DD4A:
		cmp.w	-6(a0),d6
		bge.s	loc_DD76
		subq.w	#6,a0
		tst.b	4(a0)
		bpl.s	loc_DD60
		subq.b	#1,1(a2)
		move.b	1(a2),d2

loc_DD60:
		bsr.w	sub_E0D2
		bne.s	loc_DD6A
		subq.w	#6,a0
		bra.s	loc_DD4A
; ===========================================================================

loc_DD6A:
		tst.b	4(a0)
		bpl.s	loc_DD74
		addq.b	#1,1(a2)

loc_DD74:
		addq.w	#6,a0

loc_DD76:
		move.l	a0,(Obj_load_addr_left).w
		movea.l	(Obj_load_addr_right).w,a0
		addi.w	#$300,d6

loc_DD82:
		cmp.w	-6(a0),d6
		bgt.s	loc_DD94
		tst.b	-2(a0)
		bpl.s	loc_DD90
		subq.b	#1,(a2)

loc_DD90:
		subq.w	#6,a0
		bra.s	loc_DD82
; ===========================================================================

loc_DD94:
		move.l	a0,(Obj_load_addr_right).w
		rts
; ===========================================================================

loc_DD9A:
		move.w	d6,(Camera_X_pos_last).w
		movea.l	(Obj_load_addr_right).w,a0
		addi.w	#$280,d6

loc_DDA6:
		cmp.w	(a0),d6
		bls.s	loc_DDBA
		tst.b	4(a0)
		bpl.s	loc_DDB4
		move.b	(a2),d2
		addq.b	#1,(a2)

loc_DDB4:
		bsr.w	sub_E0D2
		beq.s	loc_DDA6

loc_DDBA:
		move.l	a0,(Obj_load_addr_right).w
		movea.l	(Obj_load_addr_left).w,a0
		subi.w	#$300,d6
		bcs.s	loc_DDDA

loc_DDC8:
		cmp.w	(a0),d6
		bls.s	loc_DDDA
		tst.b	4(a0)
		bpl.s	loc_DDD6
		addq.b	#1,1(a2)

loc_DDD6:
		addq.w	#6,a0
		bra.s	loc_DDC8
; ===========================================================================

loc_DDDA:
		move.l	a0,(Obj_load_addr_left).w

locret_DDDE:
		rts
; ===========================================================================

loc_DDE0:
		moveq	#-1,d0
		move.l	d0,(Object_RAM_block_indices).w
		move.l	d0,(Object_RAM_block_indices+4).w
		move.l	d0,(Player_1_loaded_object_blocks+2).w
		move.l	d0,(Camera_X_pos_last_P2).w
		move.w	#0,(Camera_X_pos_last).w
		move.w	#0,(Camera_X_pos_last_P2).w
		lea	(Object_Respawn_Table).w,a2
		move.w	(a2),(Obj_respawn_index_P2).w
		moveq	#0,d2
		lea	(Object_Respawn_Table).w,a5
		lea	(Obj_load_addr_right).w,a4
		lea	(Player_1_loaded_object_blocks).w,a1
		lea	(Player_2_loaded_object_blocks).w,a6
		moveq	#-2,d6
		bsr.w	sub_DF80
		lea	(Player_1_loaded_object_blocks).w,a1
		moveq	#-1,d6
		bsr.w	sub_DF80
		lea	(Player_1_loaded_object_blocks).w,a1
		moveq	#0,d6
		bsr.w	sub_DF80
		lea	(Obj_respawn_index_P2).w,a5
		lea	(Obj_load_addr_right_P2).w,a4
		lea	(Player_2_loaded_object_blocks).w,a1
		lea	(Player_1_loaded_object_blocks).w,a6
		moveq	#-2,d6
		bsr.w	sub_DF80
		lea	(Player_2_loaded_object_blocks).w,a1
		moveq	#-1,d6
		bsr.w	sub_DF80
		lea	(Player_2_loaded_object_blocks).w,a1
		moveq	#0,d6
		bsr.w	sub_DF80

loc_DE5C:
		move.w	(Camera_X_pos).w,d1
		andi.w	#$FF00,d1
		move.w	d1,(Camera_X_pos_coarse).w
		move.w	(Camera_X_pos_P2).w,d1
		andi.w	#$FF00,d1
		move.w	d1,(Camera_X_pos_coarse_P2).w
		move.b	(Camera_X_pos).w,d6
		andi.w	#$FF,d6
		move.w	(Camera_X_pos_last).w,d0
		cmp.w	(Camera_X_pos_last).w,d6
		beq.s	loc_DE9C
		move.w	d6,(Camera_X_pos_last).w
		lea	(Object_Respawn_Table).w,a5
		lea	(Obj_load_addr_right).w,a4
		lea	(Player_1_loaded_object_blocks).w,a1
		lea	(Player_2_loaded_object_blocks).w,a6
		bsr.s	sub_DED2

loc_DE9C:
		move.b	(Camera_X_pos_P2).w,d6
		andi.w	#$FF,d6
		move.w	(Camera_X_pos_last_P2).w,d0
		cmp.w	(Camera_X_pos_last_P2).w,d6
		beq.s	loc_DEC4
		move.w	d6,(Camera_X_pos_last_P2).w
		lea	(Obj_respawn_index_P2).w,a5
		lea	(Obj_load_addr_right_P2).w,a4
		lea	(Player_2_loaded_object_blocks).w,a1
		lea	(Player_1_loaded_object_blocks).w,a6
		bsr.s	sub_DED2

loc_DEC4:
		move.w	(Object_Respawn_Table).w,($FFFFFFEC).w
		move.w	(Obj_respawn_index_P2).w,($FFFFFFEE).w
		rts
; ===========================================================================

sub_DED2:
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d2
		cmp.w	d0,d6
		beq.w	locret_DDDE
		bge.w	sub_DF80
		move.b	2(a1),d2
		move.b	1(a1),2(a1)
		move.b	(a1),1(a1)
		move.b	d6,(a1)
		cmp.b	(a6),d2
		beq.s	loc_DF08
		cmp.b	1(a6),d2
		beq.s	loc_DF08
		cmp.b	2(a6),d2
		beq.s	loc_DF08
		bsr.w	sub_E062
		bra.s	loc_DF0C
; ===========================================================================

loc_DF08:
		bsr.w	sub_E026

loc_DF0C:
		bsr.w	sub_E002
		bne.s	loc_DF30
		movea.l	4(a4),a0

loc_DF16:
		cmp.b	-6(a0),d6
		bne.s	loc_DF2A
		tst.b	-2(a0)
		bpl.s	loc_DF26
		subq.b	#1,1(a5)

loc_DF26:
		subq.w	#6,a0
		bra.s	loc_DF16
; ===========================================================================

loc_DF2A:
		move.l	a0,4(a4)
		bra.s	loc_DF66
; ===========================================================================

loc_DF30:
		movea.l	4(a4),a0
		move.b	d6,(a1)

loc_DF36:
		cmp.b	-6(a0),d6
		bne.s	loc_DF62
		subq.w	#6,a0
		tst.b	4(a0)
		bpl.s	loc_DF4C
		subq.b	#1,1(a5)
		move.b	1(a5),d2

loc_DF4C:
		bsr.w	sub_E122
		bne.s	loc_DF56
		subq.w	#6,a0
		bra.s	loc_DF36
; ===========================================================================

loc_DF56:
		tst.b	4(a0)
		bpl.s	loc_DF60
		addq.b	#1,1(a5)

loc_DF60:
		addq.w	#6,a0

loc_DF62:
		move.l	a0,4(a4)

loc_DF66:
		movea.l	(a4),a0
		addq.w	#3,d6

loc_DF6A:
		cmp.b	-6(a0),d6
		bne.s	loc_DF7C
		tst.b	-2(a0)
		bpl.s	loc_DF78
		subq.b	#1,(a5)

loc_DF78:
		subq.w	#6,a0
		bra.s	loc_DF6A
; ===========================================================================

loc_DF7C:
		move.l	a0,(a4)
		rts
; ===========================================================================

sub_DF80:
		addq.w	#2,d6
		move.b	(a1),d2
		move.b	1(a1),(a1)
		move.b	2(a1),1(a1)
		move.b	d6,2(a1)
		cmp.b	(a6),d2
		beq.s	loc_DFA8
		cmp.b	1(a6),d2
		beq.s	loc_DFA8
		cmp.b	2(a6),d2
		beq.s	loc_DFA8
		bsr.w	sub_E062
		bra.s	loc_DFAC
; ===========================================================================

loc_DFA8:
		bsr.w	sub_E026

loc_DFAC:
		bsr.w	sub_E002
		bne.s	loc_DFC8
		movea.l	(a4),a0

loc_DFB4:
		cmp.b	(a0),d6
		bne.s	loc_DFC4
		tst.b	4(a0)
		bpl.s	loc_DFC0
		addq.b	#1,(a5)

loc_DFC0:
		addq.w	#6,a0
		bra.s	loc_DFB4
; ===========================================================================

loc_DFC4:
		move.l	a0,(a4)
		bra.s	loc_DFE2
; ===========================================================================

loc_DFC8:
		movea.l	(a4),a0
		move.b	d6,(a1)

loc_DFCC:
		cmp.b	(a0),d6
		bne.s	loc_DFE0
		tst.b	4(a0)
		bpl.s	loc_DFDA
		move.b	(a5),d2
		addq.b	#1,(a5)

loc_DFDA:
		bsr.w	sub_E122
		beq.s	loc_DFCC

loc_DFE0:
		move.l	a0,(a4)

loc_DFE2:
		movea.l	4(a4),a0
		subq.w	#3,d6
		bcs.s	loc_DFFC

loc_DFEA:
		cmp.b	(a0),d6
		bne.s	loc_DFFC
		tst.b	4(a0)
		bpl.s	loc_DFF8
		addq.b	#1,1(a5)

loc_DFF8:
		addq.w	#6,a0
		bra.s	loc_DFEA
; ===========================================================================

loc_DFFC:
		move.l	a0,4(a4)
		rts
; End of function sub_DF80


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_E002:
		move.l	a1,-(sp)
		lea	(Object_RAM_block_indices).w,a1
		cmp.b	(a1)+,d6
		beq.s	loc_E022
		cmp.b	(a1)+,d6
		beq.s	loc_E022
		cmp.b	(a1)+,d6
		beq.s	loc_E022
		cmp.b	(a1)+,d6
		beq.s	loc_E022
		cmp.b	(a1)+,d6
		beq.s	loc_E022
		cmp.b	(a1)+,d6
		beq.s	loc_E022
		moveq	#1,d0

loc_E022:
		movea.l	(sp)+,a1
		rts
; End of function sub_E002


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_E026:
		lea	(Object_RAM_block_indices).w,a1
		lea	(Object_RAM+$E00).w,a3
		tst.b	(a1)+
		bmi.s	loc_E05E
		lea	($FFFFC100).w,a3
		tst.b	(a1)+
		bmi.s	loc_E05E
		lea	($FFFFC400).w,a3
		tst.b	(a1)+
		bmi.s	loc_E05E
		lea	($FFFFC700).w,a3
		tst.b	(a1)+
		bmi.s	loc_E05E
		lea	($FFFFCA00).w,a3
		tst.b	(a1)+
		bmi.s	loc_E05E
		lea	($FFFFCD00).w,a3
		tst.b	(a1)+
		bmi.s	loc_E05E
		nop
		nop

loc_E05E:
		subq.w	#1,a1
		rts
; End of function sub_E026


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_E062:				; CODE XREF: sub_DED2+30p sub_DF80+22p
		lea	(Object_RAM_block_indices).w,a1
		lea	(Object_RAM+$E00).w,a3
		cmp.b	(a1)+,d2
		beq.s	loc_E09A
		lea	($FFFFC100).w,a3
		cmp.b	(a1)+,d2
		beq.s	loc_E09A
		lea	($FFFFC400).w,a3
		cmp.b	(a1)+,d2
		beq.s	loc_E09A
		lea	($FFFFC700).w,a3
		cmp.b	(a1)+,d2
		beq.s	loc_E09A
		lea	($FFFFCA00).w,a3
		cmp.b	(a1)+,d2
		beq.s	loc_E09A
		lea	($FFFFCD00).w,a3
		cmp.b	(a1)+,d2
		beq.s	loc_E09A
		nop
		nop

loc_E09A:				; CODE XREF: sub_E062+Aj sub_E062+12j	...
		move.b	#$FF,-(a1)
		movem.l	a1/a3,-(sp)
		moveq	#0,d1
		moveq	#$B,d2

loc_E0A6:				; CODE XREF: sub_E062+64j
		tst.b	(a3)
		beq.s	loc_E0C2
		movea.l	a3,a1
		moveq	#0,d0
		move.b	$23(a1),d0
		beq.s	loc_E0BA
		bclr	#7,2(a2,d0.w)

loc_E0BA:				; CODE XREF: sub_E062+50j
		moveq	#$F,d0

loc_E0BC:				; CODE XREF: sub_E062+5Cj
		move.l	d1,(a1)+
		dbf	d0,loc_E0BC

loc_E0C2:				; CODE XREF: sub_E062+46j
		lea	$40(a3),a3
		dbf	d2,loc_E0A6
		moveq	#0,d2
		movem.l	(sp)+,a1/a3
		rts
; End of function sub_E062


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_E0D2:				; CODE XREF: ROM:loc_DD60p
					; ROM:loc_DDB4p
		tst.b	4(a0)
		bpl.s	loc_E0E6
		bset	#7,2(a2,d2.w)
		beq.s	loc_E0E6
		addq.w	#6,a0
		moveq	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_E0E6:				; CODE XREF: sub_E0D2+4j sub_E0D2+Cj
		bsr.w	AllocateObject
		bne.s	locret_E120
		move.w	(a0)+,x_pos(a1)
		move.w	(a0)+,d0
		move.w	d0,d1
		andi.w	#$FFF,d0
		move.w	d0,y_pos(a1)
		rol.w	#2,d1
		andi.b	#3,d1
		move.b	d1,render_flags(a1)
		move.b	d1,status(a1)
		move.b	(a0)+,d0
		bpl.s	loc_E116
		andi.b	#$7F,d0	; ''
		move.b	d2,$23(a1)

loc_E116:				; CODE XREF: sub_E0D2+3Aj
		move.b	d0,id(a1)
		move.b	(a0)+,$28(a1)
		moveq	#0,d0

locret_E120:				; CODE XREF: sub_E0D2+18j
		rts
; End of function sub_E0D2


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_E122:				; CODE XREF: sub_DED2:loc_DF4Cp
					; sub_DF80:loc_DFDAp
		tst.b	4(a0)
		bpl.s	loc_E136
		bset	#7,2(a2,d2.w)
		beq.s	loc_E136
		addq.w	#6,a0
		moveq	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_E136:				; CODE XREF: sub_E122+4j sub_E122+Cj
		btst	#5,2(a0)
		beq.s	loc_E146
		bsr.w	AllocateObject
		bne.s	locret_E180
		bra.s	loc_E14C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_E146:				; CODE XREF: sub_E122+1Aj
		bsr.w	AllocateObject_2P
		bne.s	locret_E180

loc_E14C:				; CODE XREF: sub_E122+22j
		move.w	(a0)+,x_pos(a1)
		move.w	(a0)+,d0
		move.w	d0,d1
		andi.w	#$FFF,d0
		move.w	d0,y_pos(a1)
		rol.w	#2,d1
		andi.b	#3,d1
		move.b	d1,render_flags(a1)
		move.b	d1,status(a1)
		move.b	(a0)+,d0
		bpl.s	loc_E176
		andi.b	#$7F,d0	; ''
		move.b	d2,$23(a1)

loc_E176:				; CODE XREF: sub_E122+4Aj
		move.b	d0,id(a1)
		move.b	(a0)+,$28(a1)
		moveq	#0,d0

locret_E180:				; CODE XREF: sub_E122+20j sub_E122+28j
		rts
; End of function sub_E122