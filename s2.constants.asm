; ===========================================================================
; ---------------------------------------------------------------------------
; Object Status Table offsets
; ---------------------------------------------------------------------------
; universally followed object conventions:
			; DO NOT CHANGE "ID"! Some objects infer its usage by simply writing to (aX)
			; rather than 0(aX), which does indeed effect compilation, so until I find a
			; way to automate this (similar to the AS GitHub disassembly), best to keep
			; this as-is.
id:			equ 0			; object ID
render_flags:		equ 1			; bitfield ; bit 7 = onscreen flag, bit 0 = x mirror, bit 1 = y mirror, bit 2 = coordinate system, bit 6 = render subobjects
art_tile:		equ 2			; and 3 ; start of sprite's art
mappings:		equ 4			; and 5 and 6 and 7
x_pos:			equ 8			; and 9 ... some objects use $A and $B as well when extra precision is required (see ObjectMove) ... for screen-space objects this is called x_pixel instead
x_sub:			equ $A			; and $B
y_pos:			equ $C			; and $D ... some objects use $E and $F as well when extra precision is required ... screen-space objects use y_pixel instead
y_sub:			equ $E			; and $F
x_vel:			equ $10			; and $11 ; horizontal velocity
y_vel:			equ $12			; and $13 ; vertical velocity
y_radius:		equ $16			; collision height / 2
x_radius:		equ $17			; collision width / 2
priority:		equ $18			; 0 = front
width_pixels:		equ $19
mapping_frame:		equ $1A
anim_frame:		equ $1B
anim:			equ $1C
prev_anim:		equ $1D
anim_frame_duration:	equ $1E
status:			equ $22			; note: exact meaning depends on the object... for Sonic/Tails: bit 0: left-facing. bit 1: in-air. bit 2: spinning. bit 3: on-object. bit 4: roll-jumping. bit 5: pushing. bit 6: underwater.
routine:		equ $24
routine_secondary:	equ $25
angle:			equ $26			; angle about the z axis (360 degrees = 256)

x_pixel:		equ x_pos		; and 1+x_pos ; x coordinate for objects using screen-space coordinate system
y_pixel:		equ 2+x_pos		; and 3+x_pos ; y coordinate for objects using screen-space coordinate system

; conventions mostly shared by Sonic and Tails (Obj01, Obj02, and Obj09).
; Special Stage Sonic uses some different conventions
inertia:		equ $14			; and $15 ; directionless representation of speed... not updated in the air
flip_angle:		equ $27			; angle about the x axis (360 degrees = 256) (twist/tumble)
flips_remaining:	equ $2C			; number of flip revolutions remaining
flip_speed:		equ $2D			; number of flip revolutions per frame / 256
move_lock:		equ $2E			; and $2F ; horizontal control lock, counts down to 0
invulnerable_time:	equ $30			; and $31 ; time remaining until you stop blinking
invincibility_time:	equ $32			; and $33 ; remaining
speedshoes_time:	equ $34			; and $35 ; remaining
next_tilt:		equ $36			; angle on ground in front of sprite
tilt:			equ $37			; angle on ground
stick_to_convex:	equ $38			; 0 for normal, 1 to make Sonic stick to convex surfaces like the rotating discs in Sonic 1 and 3
spindash_flag:		equ $39			; 0 for normal, 1 for charging a spindash
jumping:		equ $3C
interact:		equ $3D			; RAM address of the last object Sonic stood on, minus $FFFFB000 and divided by $40
top_solid_bit:		equ $3E			; the bit to check for top solidity (either $C or $E)
lrb_solid_bit:		equ $3F			; the bit to check for left/right/bottom solidity (either $D or $F)

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
; Miscellaneous constants without dedicated pointers

; LEVEL LAYOUTS
levelrowsize:		equ 128		; maximum width of a level layout in chunks
levelrowcount:		equ 32		; maximum height of a level layout in chunks

; REDRAWING ROUTINES:
; This ia used by stages that employ a more advanced redraw routine, basing it
; off the various background positions other than just BG1; this is to stop tiles
; from being accidentally overwritten

; Note that internally, they were called Plane B, C, and D (A is the foreground
; layer, Z was the unused effect seen in the TTS'90 demo)
static1:		equ 0
dynamic1:		equ 2
dynamic2:		equ 4
dynamic3:		equ 6

; ---------------------------------------------------------------------------
; Main RAM
		pusho						; save options
		opt	ae+					; enable auto evens

		rsset $FF0000|$FF000000
				rs.b	$8000

Level_Layout:			rs.b	levelrowsize*levelrowcount	; level layout; each row is $80 bytes
Level_Layout_End:		equ	__rs

Block_Table:			rs.w	$C00
Block_Table_End:		equ	__rs

TempArray_LayerDef:		rs.b	$200		; used by some layer deformation routines
Decomp_Buffer:			rs.b	$200		; used by Nemesis as a temporary buffer before it is uploaded to VRAM

Sprite_Input_Table:		rs.b	$400
Sprite_Input_Table_End:		equ	__rs

Object_RAM:			rs.b	$2000
Object_RAM_End:			equ	__rs

MainCharacter:			equ	Object_RAM
Sidekick:			equ	Object_RAM+$40

Primary_Collision:		rs.b	$600
Secondary_Collision:		rs.b	$600

VDP_Command_Buffer:		rs.w	7*$12		; stores 18 ($12) VDP commands to issue the next time ProcessDMAQueue is called
VDP_Command_Buffer_Slot:	rs.l	1		; stores the address of the next open slot for a queued VDP command

Sprite_Table_P2:		rs.b	$280		; Sprite Attribute Table buffer for the bottom split screen in 2-player mode
				rs.b	$80		; unused, but SAT buffer can spill over into this area when there are too many sprites on-screen

Horiz_Scroll_Buf:		rs.l	224		; total lines on the screen
				rs.l	16		; unused, bug a bug/optimization in 'Deform_CPZ' in later builds causes these values to be overflowed into
				rs.b	$40		; these are just unused
Horiz_Scroll_Buf_End:		equ	__rs

Sonic_Stat_Record_Buf:		rs.b	$100
Sonic_Pos_Record_Buf:		rs.b	$100
unk_E600:			rs.b	$100
Tails_Pos_Record_Buf:		rs.b	$100

Ring_Positions:			rs.b	$600
Ring_Positions_End:		equ	__rs

Camera_RAM:			equ	__rs
Camera_X_pos:			rs.l	1
Camera_Y_pos:			rs.l	1
Camera_BG_X_pos:		rs.l	1
Camera_BG_Y_pos:		rs.l	1
Camera_BG2_X_pos:		rs.l	1
Camera_BG2_Y_pos:		rs.l	1
Camera_BG3_X_pos:		rs.l	1
Camera_BG3_Y_pos:		rs.l	1

Camera_X_pos_P2:		rs.l	1
Camera_Y_pos_P2:		rs.l	1
Camera_BG_X_pos_P2:		rs.l	1
Camera_BG_Y_pos_P2:		rs.l	1
Camera_BG2_X_pos_P2:		rs.l	1
Camera_BG2_Y_pos_P2:		rs.l	1
Camera_BG3_X_pos_P2:		rs.l	1
Camera_BG3_Y_pos_P2:		rs.l	1

Horiz_block_crossed_flag:	rs.b	1		; toggles between 0 and $10 when you cross a block boundary horizontally
Verti_block_crossed_flag:	rs.b	1		; toggles between 0 and $10 when you cross a block boundary vertically
Horiz_block_crossed_flag_BG:	rs.b	1		; toggles between 0 and $10 when background camera crosses a block boundary horizontally
Verti_block_crossed_flag_BG:	rs.b	1		; toggles between 0 and $10 when background camera crosses a block boundary vertically
Horiz_block_crossed_flag_BG2:	rs.b	1
				rs.b	1		; $FFFFEE45 ; unused
Horiz_block_crossed_flag_BG3:	rs.b	1
				rs.b	1		; $FFFFEE47 ; unused

Horiz_block_crossed_flag_P2:	rs.b	1
Verti_block_crossed_flag_P2:	rs.b	1
				rs.b	6		; $FFFFEE4A-$FFFFEE4F ; unused

Scroll_flags:			rs.w	1		; bitfield ; bit 0 = redraw top row, bit 1 = redraw bottom row, bit 2 = redraw left-most column, bit 3 = redraw right-most column
Scroll_flags_BG:		rs.w	1		; bitfield ; bits 0-3 as above, bit 4 = redraw top row (except leftmost block), bit 5 = redraw bottom row (except leftmost block), bits 6-7 = as bits 0-1
Scroll_flags_BG2:		rs.w	1		; bitfield ; bit 0 = redraw left-most column, bit 1 = redraw right-most column
Scroll_flags_BG3:		rs.w	1		; bitfield ; bits 0-3 as Scroll_flags_BG but using Y-dependent BG camera; bits 4-5 = bits 2-3; bits 6-7 = bits 2-3

Scroll_flags_P2:		rs.w	1
Scroll_flags_BG_P2:		rs.w	1
Scroll_flags_BG2_P2:		rs.w	1
Scroll_flags_BG3_P2:		rs.w	1

Camera_RAM_copy:		rs.l	2		; copied over every V-int
Camera_BG_copy:			rs.l	2		; copied over every V-int
Camera_BG2_copy:		rs.l	2		; copied over every V-int
Camera_BG3_copy:		rs.l	2		; copied over every V-int

Camera_P2_copy:			rs.l	8		; copied over every V-int

Scroll_flags_copy:		rs.w	1		; copied over every V-int
Scroll_flags_BG_copy:		rs.w	1		; copied over every V-int
Scroll_flags_BG2_copy:		rs.w	1		; copied over every V-int
Scroll_flags_BG3_copy:		rs.w	1		; copied over every V-int

Scroll_flags_copy_P2:		rs.w	1		; copied over every V-int
Scroll_flags_BG_copy_P2:	rs.w	1		; copied over every V-int
Scroll_flags_BG2_copy_P2:	rs.w	1		; copied over every V-int
Scroll_flags_BG3_copy_P2:	rs.w	1		; copied over every V-int

Camera_X_pos_diff:		rs.w	1		; (new X pos - old X pos) * 256
Camera_Y_pos_diff:		rs.w	1		; (new Y pos - old Y pos) * 256

				rs.b	2		; $FFFFEEB4-$FFFFEEB5 ; unused

Camera_X_pos_diff_P2:		rs.w	1		; (new X pos - old X pos) * 256
Camera_Y_pos_diff_P2:		rs.w	1		; (new Y pos - old Y pos) * 256

				rs.b	6		; $FFFFEEBA-$FFFFEEBF ; unused

Camera_Min_X_pos_target:	rs.w	1		; unused, except for one write in LevelSizeLoad
Camera_Max_X_pos_target:	rs.w	1		; unused, written to alongside the above
Camera_Min_Y_pos_target:	rs.w	1		; unused, except for one write in LevelSizeLoad
Camera_Max_Y_pos_target:	rs.w	1

Camera_Min_X_pos:		rs.w	1
Camera_Max_X_pos:		rs.w	1
Camera_Min_Y_pos:		rs.w	1
Camera_Max_Y_pos:		rs.w	1

Horiz_scroll_delay_val:		rs.w	1
Sonic_Pos_Record_Index:		rs.w	1

Horiz_scroll_delay_val_P2:	rs.w	1		; effectively unused as Tails writes to Sonic's value instead, oops
Tails_Pos_Record_Index:		rs.w	1

Camera_Y_pos_bias:		rs.w	1		; added to y position for lookup/lookdown, $60 is center
				rs.b	2		; $FFFFEEDA-$FFFFEEDB ; unused

Deform_lock:			rs.b	1		; set to 1 to stop all deformation
				rs.b	1		; $FFFFEEDD ; unused
Camera_Max_Y_Pos_Changing:	rs.b	1
Dynamic_Resize_Routine:		rs.b	1
unk_EEE0:			rs.w	1
				rs.b	$E		; $FFFFEEE2-$FFFFEEEF ; unused
Camera_X_pos_copy:		rs.l	1
Camera_Y_pos_copy:		rs.l	1
				rs.b	8		; $FFFFEEF8-$FFFFEEFF ; unused
Block_cache:			rs.w	512/16*2	; width of plane in blocks, with each block getting two words.

				rs.b	$80		; $FFFFEF80-$FFFFEFFF ; unused
Sound_Driver_RAM:		rs.b	$600		; only $5C0 bytes are used, but it's allocated for $600

Game_Mode:			rs.b	1
				rs.b	1		; $FFFFF601 ; unused
Ctrl_1_Logical:			rs.w	1
Ctrl_1_Held_Logical:		equ	__rs-2
Ctrl_1_Press_Logical:		equ	__rs-1
Ctrl_1:				rs.w	1
Ctrl_1_Held:			equ	__rs-2
Ctrl_1_Press:			equ	__rs-1
Ctrl_2:				rs.w	1
Ctrl_2_Held:			equ	__rs-2
Ctrl_2_Press:			equ	__rs-1
				rs.b	4		; $FFFFF608-$FFFFF60B ; unused
VDP_Reg1_val:			rs.w	1		; normal value of VDP register #1 when display is disabled
				rs.b	6		; $FFFFF60E-$FFFFF613 ; unused
Demo_Time_left:			rs.w	1

Vscroll_Factor:			rs.l	1
Vscroll_Factor_FG:		equ	__rs-4
Vscroll_Factor_BG:		equ	__rs-2
unk_F61A:			rs.l	1		; cleared twice, never used
Vscroll_Factor_P2:		rs.l	1
Vscroll_Factor_P2_FG:		equ	__rs-4
Vscroll_Factor_P2_BG:		equ	__rs-2
				rs.b	2		; $FFFFF622-$FFFFF623 ; unused
Hint_counter_reserve:		rs.w	1		; must contain a VDP command word, preferably a write to register $0A. Executed every V-INT.
		popo						; restore options

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

unk_F700:			equ $FFFFF700
Tails_control_counter:		equ $FFFFF702
unk_F706:			equ $FFFFF706
Tails_CPU_routine:		equ $FFFFF708

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

; ---------------------------------------------------------------------------
; Extended RAM constants (for routines that would convert data for STI's use)

ConvertedChunksLoc:		equ $00FE0000