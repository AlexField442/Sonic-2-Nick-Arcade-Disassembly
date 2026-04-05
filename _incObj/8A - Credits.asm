; ===========================================================================
; ---------------------------------------------------------------------------
; Object 8A - "SONIC TEAM PRESENTS" screen and credits
;
; Internal name: "staff"
; ---------------------------------------------------------------------------
; Sprite_185E0: Obj8A:
Obj_StaffRoll:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	StaffRoll_Index(pc,d0.w),d1
		jmp	StaffRoll_Index(pc,d1.w)
; ===========================================================================
; off_185EE: Obj8A_Index:
StaffRoll_Index:
		dc.w StaffRoll_Init-StaffRoll_Index
		dc.w StaffRoll_Display-StaffRoll_Index
; ===========================================================================
; loc_185F2: Obj8A_Init:
StaffRoll_Init:
		addq.b	#2,routine(a0)
		move.w	#$120,x_pixel(a0)
		move.w	#$F0,y_pixel(a0)
		move.l	#MapUnc_StaffRoll,mappings(a0)
		move.w	#$5A0,art_tile(a0)
		bsr.w	j_Adjust2PArtPointer_4
; Obj8A_Credits: StaffRoll_Credits:
		move.w	(Ending_demo_number).w,d0	; load credits index number
		move.b	d0,mapping_frame(a0)	; display appropriate credits
		move.b	#0,render_flags(a0)
		move.b	#0,priority(a0)

		cmpi.b	#GameModeID_TitleScreen,(Game_Mode).w	; is this the title screen?
		bne.s	StaffRoll_Display	; if not, branch
; Obj8A_SonicTeam: StaffRoll_SonicTeam:
		move.w	#$300,art_tile(a0)
		bsr.w	j_Adjust2PArtPointer_4
		move.b	#$A,mapping_frame(a0)
		tst.b	(Hidden_credits_flag).w	; is the Sonic 1 hidden credits cheat activated?
		beq.s	StaffRoll_Display	; if not, branch
		cmpi.b	#$72,(Ctrl_1_Held).w	; has the player pressed A+B+C+Down?
		bne.s	StaffRoll_Display	; if not, branch
		move.w	#$EEE,(Target_palette_line3).w		; 3rd palette, 1st entry = white
		move.w	#$880,(Target_palette_line3+2).w	; 3rd palette, 2nd entry = cyan
		jmp	(DeleteObject).l
; ===========================================================================
; loc_18660: Obj8A_Display:
StaffRoll_Display:
		jmp	(DisplaySprite).l

; ===========================================================================
; ---------------------------------------------------------------------------
; Sprite mappings
; ---------------------------------------------------------------------------
; Map_obj8A:
MapUnc_StaffRoll:	incbin	"mappings/sprite/obj8A.bin"
		nop