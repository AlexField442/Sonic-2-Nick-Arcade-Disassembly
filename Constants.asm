; ===========================================================================
; ---------------------------------------------------------------------------
; some variables and functions to help define those constants (redefined before a new set of IDs)
; V-Int routines

VintID_Lag:			equ (Vint_Lag_ptr-Vint_SwitchTbl)			; 0
VintID_SEGA:		equ (Vint_SEGA_ptr-Vint_SwitchTbl)			; 2
VintID_Title:		equ (Vint_Title_ptr-Vint_SwitchTbl)			; 4
VintID_Unused6:		equ (Vint_Unused6_ptr-Vint_SwitchTbl)		; 6
VintID_Level:		equ (Vint_Level_ptr-Vint_SwitchTbl)			; 8
VintID_S1SS:		equ (Vint_S1SS_ptr-Vint_SwitchTbl)			; $A
VintID_TitleCard:	equ (Vint_TitleCard_ptr-Vint_SwitchTbl)		; $C
VintID_UnusedE:		equ (Vint_UnusedE_ptr-Vint_SwitchTbl)		; $E
VintID_Pause:		equ (Vint_Pause_ptr-Vint_SwitchTbl)			; $10
VintID_Fade:		equ (Vint_Fade_ptr-Vint_SwitchTbl)			; $12
VintID_PCM:			equ (Vint_PCM_ptr-Vint_SwitchTbl)			; $14
VintID_SSResults:	equ (Vint_SSResults_ptr-Vint_SwitchTbl)		; $16
VintID_TitleCard2:	equ (Vint_TitleCard2_ptr-Vint_SwitchTbl)	; $18

; Game modes
GameModeID_SegaScreen:		equ (GameMode_SegaScreen-GameModeArray)		; 0
GameModeID_TitleScreen:		equ (GameMode_TitleScreen-GameModeArray)	; 4
GameModeID_Demo:		equ (GameMode_Demo-GameModeArray)				; 8
GameModeID_Level:		equ (GameMode_Level-GameModeArray)				; $C
GameModeID_SpecialStage:	equ (GameMode_SpecialStage-GameModeArray)	; $10
GameModeID_ContinueScreen:	equ $14										; $14, referenced despite it not existing
GameModeID_S1Ending:		equ $18										; $18, referenced despite it not existing
GameModeID_S1Credits:		equ $1C										; $1C, referenced despite it not existing
GameModeFlag_TitleCard:		equ 7 ; flag bit
GameModeID_TitleCard:		equ 1<<GameModeFlag_TitleCard			; $80, flag mask

; ---------------------------------------------------------------------------
; 68k RAM
Decomp_Buffer:			equ $FFFFAA00

VDP_Command_Buffer:		equ $FFFFDC00
VDP_Command_Buffer_Slot:	equ $FFFFDCFC

Sonic_Stat_Record_Buf:		equ $FFFFE400
Sonic_Pos_Record_Buf:		equ $FFFFE500
Tails_Pos_Record_Buf:		equ $FFFFE600

Ring_Positions:			equ $FFFFE800

Sonic_Pos_Record_Index:		equ $FFFFEED2

Game_Mode:			equ $FFFFF600

Demo_Time_left:			equ $FFFFF614

Hint_counter_reserve:		equ $FFFFF624
Vint_routine:			equ $FFFFF62A
DMA_data_thunk:			equ $FFFFF640
Hint_flag:			equ $FFFFF644
Water_fullscreen_flag:		equ $FFFFF64E
Do_Updates_in_H_int:		equ $FFFFF64F

Rings_manager_routine:		equ $FFFFF710
Level_started_flag:		equ $FFFFF711
Ring_start_addr:		equ $FFFFF712
Ring_end_addr:			equ $FFFFF714
Ring_start_addr_P2:		equ $FFFFF716
Ring_end_addr_P2:		equ $FFFFF718

Water_flag:			equ $FFFFF730

Sonic_top_speed:		equ $FFFFF760
Sonic_acceleration:		equ $FFFFF762
Sonic_deceleration:		equ $FFFFF764
Sonic_LastLoadedDPLC:		equ $FFFFF766

Obj_placement_routine:		equ $FFFFF76C
Camera_X_pos_last:		equ $FFFFF76E
Obj_load_addr_right:		equ $FFFFF770
Obj_load_addr_left:		equ $FFFFF774
Obj_load_addr_2:		equ $FFFFF778
Obj_load_addr_3:		equ $FFFFF77C

Camera_X_pos_last_P2:		equ $FFFFF78C

Tails_LastLoadedDPLC:		equ $FFFFF7DE
TailsTails_LastLoadedDPLC:	equ $FFFFF7DF

Debug_placement_mode:		equ $FFFFFE08

Vint_runcount:			equ $FFFFFE0C

Current_ZoneAndAct:		equ $FFFFFE10
Current_Zone:			equ $FFFFFE10
Current_Act:			equ $FFFFFE11

Two_player_mode:		equ $FFFFFFE8

Debug_mode_flag:		equ $FFFFFFFA

; ---------------------------------------------------------------------------
; Z80 RAM
Z80_RAM:				equ	$A00000
Z80_Bus:				equ $A11100
Z80_Reset:				equ $A11200

; ---------------------------------------------------------------------------
; I/O area
HW_Version:				equ $A10001
HW_Port_1_Data:			equ $A10003
HW_Port_2_Data:			equ $A10005
HW_Expansion_Data:		equ $A10007
HW_Port_1_Control:		equ $A10009
HW_Port_2_Control:		equ $A1000B
HW_Expansion_Control:	equ $A1000D
HW_Port_1_TxData:		equ $A1000F
HW_Port_1_RxData:		equ $A10011
HW_Port_1_SCtrl:		equ $A10013
HW_Port_2_TxData:		equ $A10015
HW_Port_2_RxData:		equ $A10017
HW_Port_2_SCtrl:		equ $A10019
HW_Expansion_TxData:	equ $A1001B
HW_Expansion_RxData:	equ $A1001D
HW_Expansion_SCtrl:		equ $A1001F
