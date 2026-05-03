; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to pause the game
; ---------------------------------------------------------------------------
; sub_1408:
PauseGame:
		nop
		tst.b	(Life_count).w
		beq.s	Unpause
		tst.w	(Game_paused).w
		bne.s	Pause_AlreadyPaused
		btst	#7,(Ctrl_1_Press).w
		beq.s	Pause_DoNothing

Pause_AlreadyPaused:
		move.w	#1,(Game_paused).w
		move.b	#1,(Sound_Driver_RAM+StopMusic).w

Pause_Loop:
		move.b	#VintID_Pause,(Vint_routine).w
		bsr.w	WaitForVint
		tst.b	(Slow_motion_flag).w
		beq.s	Pause_ChkStart
		btst	#6,(Ctrl_1_Press).w
		beq.s	Pause_ChkBC
		move.b	#GameModeID_TitleScreen,(Game_Mode).w
		nop
		bra.s	Pause_Resume
; ===========================================================================

Pause_ChkBC:
		btst	#4,(Ctrl_1_Held).w
		bne.s	Pause_SlowMo
		btst	#5,(Ctrl_1_Press).w
		bne.s	Pause_SlowMo

Pause_ChkStart:
		btst	#7,(Ctrl_1_Press).w
		beq.s	Pause_Loop
; loc_1464:
Pause_Resume:
		move.b	#$80,(Sound_Driver_RAM+StopMusic).w

Unpause:
		move.w	#0,(Game_paused).w

Pause_DoNothing:
		rts
; ===========================================================================
; loc_1472:
Pause_SlowMo:
		move.w	#1,(Game_paused).w
		move.b	#$80,(Sound_Driver_RAM+StopMusic).w
		rts
; End of function PauseGame