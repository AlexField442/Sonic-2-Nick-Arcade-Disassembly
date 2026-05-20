; ===========================================================================
; ---------------------------------------------------------------------------
; Object 79 - Checkpoint (mostly unused)
;
; Internal name: "save"
; ---------------------------------------------------------------------------
; Sprite_134C8: Obj79:
Obj_Checkpoint:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Checkpoint_Index(pc,d0.w),d1
		jsr	Checkpoint_Index(pc,d1.w)
		jmp	(MarkObjGone).l
; ===========================================================================
; off_134DC: Obj79_Index:
Checkpoint_Index:
		dc.w Checkpoint_Init-Checkpoint_Index
		dc.w Checkpoint_Main-Checkpoint_Index
		dc.w Checkpoint_Animate-Checkpoint_Index
; ===========================================================================
; loc_134E2: Obj79_Init:
Checkpoint_Init:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_Checkpoint,mappings(a0)
		move.w	#$47C,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#8,width_pixels(a0)
		move.b	#5,priority(a0)
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		bne.s	loc_13536
		move.b	(Last_star_pole_hit).w,d1
		andi.b	#$7F,d1
		move.b	subtype(a0),d2
		andi.b	#$7F,d2
		cmp.b	d2,d1
		bcs.s	Checkpoint_Main

loc_13536:
		bset	#0,2(a2,d0.w)
		move.b	#4,routine(a0)
		rts
; ===========================================================================
; loc_13544: Obj79_Main:
Checkpoint_Main:
		tst.w	(Debug_placement_mode).w	; are we in Debug Mode?
		bne.w	locret_135CA			; if yes, branch
		tst.b	(Player_override_flag).w	; is the player being controlled by another object?
		bmi.w	locret_135CA			; if yes, branch
		move.b	(Last_star_pole_hit).w,d1
		andi.b	#$7F,d1
		move.b	subtype(a0),d2
		andi.b	#$7F,d2
		cmp.b	d2,d1
		bcs.s	Checkpoint_CheckActivation
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		bset	#0,2(a2,d0.w)
		move.b	#4,routine(a0)
		bra.w	locret_135CA
; ===========================================================================
; loc_13582: Obj79_HitLamp: Checkpoint_HitLamp:
Checkpoint_CheckActivation:
		move.w	(MainCharacter+x_pos).w,d0
		sub.w	x_pos(a0),d0
		addi.w	#8,d0
		cmpi.w	#$10,d0
		bcc.w	locret_135CA
		move.w	(MainCharacter+y_pos).w,d0
		sub.w	y_pos(a0),d0
		addi.w	#$40,d0
		cmpi.w	#$68,d0
		bcc.s	locret_135CA
		move.w	#SndID_Checkpoint,d0
		jsr	(PlaySound).l
		addq.b	#2,routine(a0)
		bsr.w	Checkpoint_SaveData
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		bset	#0,2(a2,d0.w)

locret_135CA:
		rts
; ===========================================================================
; loc_135CC: Obj79_AfterHit:
Checkpoint_Animate:
		; cycles between two sprites after a random number of frames
		move.b	(Vint_runcount+3).w,d0
		andi.b	#2,d0
		lsr.b	#1,d0
		addq.b	#1,d0
		move.b	d0,mapping_frame(a0)
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to backup the player's data when hitting a checkpoint
; ---------------------------------------------------------------------------
; sub_135DE: Lamppost_StoreInfo:
Checkpoint_SaveData:
		move.b	subtype(a0),(Last_star_pole_hit).w
		move.b	(Last_star_pole_hit).w,(Saved_Last_star_pole_hit).w
		move.w	x_pos(a0),(Saved_x_pos).w
		move.w	y_pos(a0),(Saved_y_pos).w
		move.w	(Ring_count).w,(Saved_Ring_count).w
		move.b	(Extra_life_flags).w,(Saved_Extra_life_flags).w
		move.l	(Timer).w,(Saved_Timer).w
		move.b	(Dynamic_Resize_Routine).w,(Saved_Dynamic_Resize_Routine).w
		move.w	(Camera_Max_Y_pos).w,(Saved_Camera_Max_Y_pos).w
		move.w	(Camera_X_pos).w,(Saved_Camera_X_pos).w
		move.w	(Camera_Y_pos).w,(Saved_Camera_Y_pos).w
		move.w	(Camera_BG_X_pos).w,(Saved_Camera_BG_X_pos).w
		move.w	(Camera_BG_Y_pos).w,(Saved_Camera_BG_Y_pos).w
		move.w	(Camera_BG2_X_pos).w,(Saved_Camera_BG2_X_pos).w
		move.w	(Camera_BG2_Y_pos).w,(Saved_Camera_BG2_Y_pos).w
		move.w	(Camera_BG3_X_pos).w,(Saved_Camera_BG3_X_pos).w
		move.w	(Camera_BG3_Y_pos).w,(Saved_Camera_BG3_Y_pos).w
		move.w	(Water_Level_2).w,(Saved_Water_Level).w
		move.b	(Water_routine).w,(Saved_Water_routine).w
		move.b	(Water_fullscreen_flag).w,(Saved_Water_move).w
		rts
; End of function Checkpoint_SaveData

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load the player's data when restarting from a checkpoint
; ---------------------------------------------------------------------------
; loc_13658: Lamppost_LoadInfo:
Checkpoint_LoadData:
		move.b	(Saved_Last_star_pole_hit).w,(Last_star_pole_hit).w
		move.w	(Saved_x_pos).w,(MainCharacter+x_pos).w
		move.w	(Saved_y_pos).w,(MainCharacter+y_pos).w
		move.w	(Saved_Ring_count).w,(Ring_count).w
		move.b	(Saved_Extra_life_flags).w,(Extra_life_flags).w
		clr.w	(Ring_count).w
		clr.b	(Extra_life_flags).w
		move.l	(Saved_Timer).w,(Timer).w
		move.b	#59,(Timer_frame).w
		subq.b	#1,(Timer_second).w
		move.b	(Saved_Dynamic_Resize_Routine).w,(Dynamic_Resize_Routine).w
		move.b	(Saved_Water_routine).w,(Water_routine).w
		move.w	(Saved_Camera_Max_Y_pos).w,(Camera_Max_Y_pos).w
		move.w	(Saved_Camera_Max_Y_pos).w,(Camera_Max_Y_pos_target).w
		move.w	(Saved_Camera_X_pos).w,(Camera_X_pos).w
		move.w	(Saved_Camera_Y_pos).w,(Camera_Y_pos).w
		move.w	(Saved_Camera_BG_X_pos).w,(Camera_BG_X_pos).w
		move.w	(Saved_Camera_BG_Y_pos).w,(Camera_BG_Y_pos).w
		move.w	(Saved_Camera_BG2_X_pos).w,(Camera_BG2_X_pos).w
		move.w	(Saved_Camera_BG2_Y_pos).w,(Camera_BG2_Y_pos).w
		move.w	(Saved_Camera_BG3_X_pos).w,(Camera_BG3_X_pos).w
		move.w	(Saved_Camera_BG3_Y_pos).w,(Camera_BG3_Y_pos).w
		cmpi.b	#1,(Current_Zone).w	; is this Labyrinth Zone?
		bne.s	loc_136F0		; if yes, branch
		move.w	(Saved_Water_Level).w,(Water_Level_2).w
		move.b	(Saved_Water_routine).w,(Water_routine).w
		move.b	(Saved_Water_move).w,(Water_fullscreen_flag).w

loc_136F0:
		tst.b	(Last_star_pole_hit).w
		bpl.s	locret_13702
		move.w	(Saved_x_pos).w,d0
		subi.w	#$A0,d0
		move.w	d0,(Camera_Min_X_pos).w

locret_13702:
		rts
; End of function Checkpoint_LoadData

; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
; Map_Obj79:
MapUnc_Checkpoint:	include	"mappings/sprite/Checkpoint.asm"