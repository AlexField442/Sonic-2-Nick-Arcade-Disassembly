; ===========================================================================
; ---------------------------------------------------------------------------
; Object Status Table offsets
; ---------------------------------------------------------------------------
; universally followed object conventions:
routine:		equ $24

; ===========================================================================
; ---------------------------------------------------------------------------
; some variables and functions to help define those constants (redefined before a new set of IDs)
; V-Int routines

VintID_Lag:			equ (Vint_Lag_ptr-Vint_SwitchTbl)		; 0
VintID_SEGA:			equ (Vint_SEGA_ptr-Vint_SwitchTbl)		; 2
VintID_Title:			equ (Vint_Title_ptr-Vint_SwitchTbl)		; 4
VintID_Unused6:			equ (Vint_Unused6_ptr-Vint_SwitchTbl)		; 6
VintID_Level:			equ (Vint_Level_ptr-Vint_SwitchTbl)		; 8
VintID_S1SS:			equ (Vint_S1SS_ptr-Vint_SwitchTbl)		; $A
VintID_TitleCard:		equ (Vint_TitleCard_ptr-Vint_SwitchTbl)		; $C
VintID_UnusedE:			equ (Vint_UnusedE_ptr-Vint_SwitchTbl)		; $E
VintID_Pause:			equ (Vint_Pause_ptr-Vint_SwitchTbl)		; $10
VintID_Fade:			equ (Vint_Fade_ptr-Vint_SwitchTbl)		; $12
VintID_PCM:			equ (Vint_PCM_ptr-Vint_SwitchTbl)		; $14
VintID_SSResults:		equ (Vint_SSResults_ptr-Vint_SwitchTbl)		; $16
VintID_TitleCard2:		equ (Vint_TitleCard2_ptr-Vint_SwitchTbl)	; $18

; Game modes
GameModeID_SegaScreen:		equ (GameMode_SegaScreen-GameModeArray)		; 0
GameModeID_TitleScreen:		equ (GameMode_TitleScreen-GameModeArray)	; 4
GameModeID_Demo:		equ (GameMode_Demo-GameModeArray)		; 8
GameModeID_Level:		equ (GameMode_Level-GameModeArray)		; $C
GameModeID_SpecialStage:	equ (GameMode_SpecialStage-GameModeArray)	; $10
GameModeID_ContinueScreen:	equ $14						; $14 ; referenced despite it not existing
GameModeID_S1Ending:		equ $18						; $18 ; referenced despite it not existing
GameModeID_S1Credits:		equ $1C						; $1C ; referenced despite it not existing
GameModeFlag_TitleCard:		equ 7 ; flag bit
GameModeID_TitleCard:		equ 1<<GameModeFlag_TitleCard			; $80 ; flag mask

; Music IDs
MusID__First			equ $81
MusID_GHZ:			equ ((MusPtr_GHZ-MusicIndex)/4)+MusID__First		; $81
MusID_LZ:			equ ((MusPtr_LZ-MusicIndex)/4)+MusID__First		; $82
MusID_CPZ:			equ ((MusPtr_CPZ-MusicIndex)/4)+MusID__First		; $83
MusID_EHZ:			equ ((MusPtr_EHZ-MusicIndex)/4)+MusID__First		; $84
MusID_HPZ:			equ ((MusPtr_HPZ-MusicIndex)/4)+MusID__First		; $85
MusID_HTZ:			equ ((MusPtr_HTZ-MusicIndex)/4)+MusID__First		; $86
MusID_Invincible:		equ ((MusPtr_Invincible-MusicIndex)/4)+MusID__First	; $87
MusID_ExtraLife:		equ ((MusPtr_ExtraLife-MusicIndex)/4)+MusID__First	; $88
MusID_SpecialStage:		equ ((MusPtr_SpecialStage-MusicIndex)/4)+MusID__First	; $89
MusID_Title:			equ ((MusPtr_Title-MusicIndex)/4)+MusID__First		; $8A
MusID_Ending:			equ ((MusPtr_Ending-MusicIndex)/4)+MusID__First		; $8B
MusID_Boss:			equ ((MusPtr_Boss-MusicIndex)/4)+MusID__First		; $8C

; ---------------------------------------------------------------------------
; Main RAM
Decomp_Buffer:			equ $FFFFAA00

VDP_Command_Buffer:		equ $FFFFDC00
VDP_Command_Buffer_Slot:	equ $FFFFDCFC

Sonic_Stat_Record_Buf:		equ $FFFFE400
Sonic_Pos_Record_Buf:		equ $FFFFE500
Tails_Pos_Record_Buf:		equ $FFFFE600

Ring_Positions:			equ $FFFFE800

Sonic_Pos_Record_Index:		equ $FFFFEED2

Game_Mode:			equ $FFFFF600

VDP_Reg1_val:			equ $FFFFF60C

Demo_Time_left:			equ $FFFFF614

Vscroll_Factor:			equ $FFFFF616

Hint_counter_reserve:		equ $FFFFF624
Vint_routine:			equ $FFFFF62A
DMA_data_thunk:			equ $FFFFF640
Hint_flag:			equ $FFFFF644
Water_fullscreen_flag:		equ $FFFFF64E
Do_Updates_in_H_int:		equ $FFFFF64F

Plc_Buffer:			equ $FFFFF680

Plc_Buffer_Reg0:		equ $FFFFF6E0
Plc_Buffer_Reg4:		equ $FFFFF6E4
Plc_Buffer_Reg8:		equ $FFFFF6E8
Plc_Buffer_RegC:		equ $FFFFF6EC
Plc_Buffer_Reg10:		equ $FFFFF6F0
Plc_Buffer_Reg14:		equ $FFFFF6F4
Plc_Buffer_Reg18:		equ $FFFFF6F8
Plc_Buffer_Reg1A:		equ $FFFFF6FA

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

Anim_Counters:			equ $FFFFF7F0

Sprite_Table:			equ $FFFFF800

Debug_object:			equ $FFFFFE06
Debug_placement_mode:		equ $FFFFFE08
Debug_Accel_Timer:		equ $FFFFFE0A
Debug_Speed:			equ $FFFFFE0B

Vint_runcount:			equ $FFFFFE0C

Current_ZoneAndAct:		equ $FFFFFE10
Current_Zone:			equ $FFFFFE10
Current_Act:			equ $FFFFFE11

Two_player_mode:		equ $FFFFFFE8

Debug_mode_flag:		equ $FFFFFFFA

; ---------------------------------------------------------------------------
; VDP addresses
VDP_data_port:			equ $C00000 ; (8=r/w, 16=r/w)
VDP_control_port:		equ $C00004 ; (8=r/w, 16=r/w)
PSG_input:			equ $C00011

; ---------------------------------------------------------------------------
; Z80 addresses
Z80_RAM:			equ $A00000 ; start of Z80 RAM
Z80_RAM_End:			equ $A02000 ; end of non-reserved Z80 RAM
YM2612_A0:			equ $A04000
YM2612_D0:			equ $A04001
YM2612_A1:			equ $A04002
YM2612_D1:			equ $A04003
Z80_Bus_Request:		equ $A11100
Z80_Reset:			equ $A11200

Security_Addr:			equ $A14000

; ---------------------------------------------------------------------------
; I/O Area 
HW_Version:			equ $A10001
HW_Port_1_Data:			equ $A10003
HW_Port_2_Data:			equ $A10005
HW_Expansion_Data:		equ $A10007
HW_Port_1_Control:		equ $A10009
HW_Port_2_Control:		equ $A1000B
HW_Expansion_Control:		equ $A1000D
HW_Port_1_TxData:		equ $A1000F
HW_Port_1_RxData:		equ $A10011
HW_Port_1_SCtrl:		equ $A10013
HW_Port_2_TxData:		equ $A10015
HW_Port_2_RxData:		equ $A10017
HW_Port_2_SCtrl:		equ $A10019
HW_Expansion_TxData:		equ $A1001B
HW_Expansion_RxData:		equ $A1001D
HW_Expansion_SCtrl:		equ $A1001F

; ---------------------------------------------------------------------------
; Sound driver constants

SFXPriorityVal:			equ 0
TempoTimeout:			equ 1
CurrentTempo:			equ 2	; stores current tempo value
StopMusic:			equ 3	; set to 1 to pause music, and $80 to unpause music
FadeOutCounter:			equ 4

; unused byte

FadeOutDelay:			equ 6
Communication:			equ 7	; unused byte used to synchronise gameplay events with music, used in Ristar to sync boss attacks
DACUpdating:			equ 8	; set to $80 while DAC is updating, then back to 0
QueueToPlay:			equ 9	; if NOT set to $80, means new index was requested
SFXToPlay:			equ $A	; first sound queue
SFXToPlay2:			equ $B	; second sound queue
SFXToPlay3:			equ $C	; third (broken) sound queue

; unused byte

