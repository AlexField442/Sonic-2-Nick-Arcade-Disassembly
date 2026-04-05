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
collision_flags:	equ $20
collision_property:	equ $21
status:			equ $22			; note: exact meaning depends on the object... for Sonic/Tails: bit 0: left-facing. bit 1: in-air. bit 2: spinning. bit 3: on-object. bit 4: roll-jumping. bit 5: pushing. bit 6: underwater.
respawn_index:		equ $23
routine:		equ $24
routine_secondary:	equ $25
angle:			equ $26			; angle about the z axis (360 degrees = 256)
subtype:		equ $28

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
MusID_FZ:			equ ((MusPtr_FZ-MusicIndex)/4)+MusID__First		; $8D
MusID_ActClear:			equ ((MusPtr_ActClear-MusicIndex)/4)+MusID__First	; $8E
MusID_GameOver:			equ ((MusPtr_GameOver-MusicIndex)/4)+MusID__First	; $8F
MusID_Continue:			equ ((MusPtr_Continue-MusicIndex)/4)+MusID__First	; $90
MusID_Credits:			equ ((MusPtr_Credits-MusicIndex)/4)+MusID__First	; $91
MusID_Drowning:			equ ((MusPtr_Drowning-MusicIndex)/4)+MusID__First	; $92
MusID_Emerald:			equ ((MusPtr_Emerald-MusicIndex)/4)+MusID__First	; $93

; ---------------------------------------------------------------------------
; Miscellaneous constants without dedicated pointers

; LEVEL LAYOUTS
levelrowsize:		equ 128		; maximum width of a level layout in chunks
levelrowcount:		equ 32		; maximum height of a level layout in chunks

; PALETTES
palette_line_size:	equ $10*2	; 16 word entries

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
RAM_Start:			equ	__rs
Chunk_Table:			rs.b	$8000
Chunk_Table_End:

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
Palette_fade_range:		rs.w	1		; range affected by the palette fading routines
Palette_fade_start:		equ	__rs-2		; offset from the start of the palette to tell what range of the palette will be affected in the palette fading routines
Palette_fade_length:		equ	__rs-1		; number of entries to change in the palette fading routines

MiscLevelVariables:		equ	__rs
VIntSubE_RunCount:		rs.b	1		; only used by unused vertical interrupts
				rs.b	1		; $FFFFF629 ; unused
Vint_routine:			rs.b	1		; routine counter for V-int
				rs.b	1		; $FFFFF62B ; unused
Sprite_count:			rs.b	1		; the number of sprites drawn in the current frame
				rs.b	5		; $FFFFF62D-$FFFFF631 ; unused
PalCycle_Frame:			rs.w	1		; ColorID loaded in PalCycle
PalCycle_Timer:			rs.w	1		; number of frames until next PalCycle call
RNG_seed:			rs.l	1		; used for random number generation
Game_paused:			rs.w	1
				rs.b	4		; $FFFFF63C-$FFFFF63F ; unused
DMA_data_thunk:			rs.w	1		; used as a RAM holder for the final DMA command word. Data will NOT be preserved across V-INTs, so consider this space reserved.
				rs.w	1		; $FFFFF642-$FFFFF643 ; seems unused
Hint_flag:			rs.w	1		; unless this is 1, H-int won't run

Water_Level_1:			rs.w	1
Water_Level_2:			rs.w	1
Water_Level_3:			rs.w	1
Water_on:			rs.b	1		; is set based on Water_flag
Water_routine:			rs.b	1
Water_fullscreen_flag:		rs.b	1		; was "Water_move"
Do_Updates_in_H_int:		rs.b	1

				rs.b	2		; $FFFFF650-$FFFFF651 ; unused
PalCycle_Frame2:		rs.w	1
PalCycle_Frame3:		rs.w	1
				rs.b	$A		; $FFFFF656-$FFFFF65F ; unused

unk_F660:			rs.w	1		; cleared once on the Sega screen, never used
unk_F662:			rs.w	1		; cleared once on the Sega screen, never used
				rs.b	$1C		; $FFFFF664-$FFFFF67F ; unused
MiscLevelVariables_End:		equ	__rs

Plc_Buffer:			rs.b	6*16		; Pattern load queue (each entry is 6 bytes)
Plc_Buffer_Only_End:		equ	__rs

Plc_PtrNemCode:			rs.l	1		; pointer for nemesis decompression code
Plc_RepeatCount:		rs.l	1	
Plc_PaletteIndex:		rs.l	1	
Plc_PreviousRow:		rs.l	1	
Plc_DataWord:			rs.l	1	
Plc_ShiftValue:			rs.l	1	
Plc_PatternsLeft:		rs.w	1		; amount of current entry remaining to decompress
Plc_FramePatternsLeft:		rs.w	1	
				rs.b	4		; unused, but makes up part of Plc_Buffer
Plc_Buffer_End:

Misc_Variables:			equ	__rs
unk_F700:			rs.w	1

; extra variables for the second player (CPU)
Tails_control_counter:		rs.w	1		; how long until the CPU takes control
Tails_respawn_counter:		rs.w	1
unk_F706:			rs.w	1
Tails_CPU_routine:		rs.w	1
				rs.b	6		; $FFFFF70A-$FFFFF70F ; unused

Rings_manager_routine:		rs.b	1
Level_started_flag:		rs.b	1
Ring_start_addr:		rs.w	1
Ring_end_addr:			rs.w	1
Ring_start_addr_P2:		rs.w	1
Ring_end_addr_P2:		rs.w	1
				rs.b	6		; $FFFFF71A-$FFFFF71F ; unused

Screen_redraw_flag:		rs.b	1		; if whole screen needs to redraw, used by unused CPZ scrolling routine
CPZ_UnkScroll_Timer:		rs.b	1
				rs.b	$E		; $FFFFF722-$FFFFF72F ; unused
Water_flag:			rs.b	1
				rs.b	$F		; $FFFFF731-$FFFFF73F ; unused
Demo_button_index_2P:		rs.w	1		; index into button press demo data, for player 2
Demo_press_counter_2P:		rs.b	1		; index into button press demo data, for player 2
				rs.b	$1D		; $FFFFF743-$FFFFF75F ; unused

Sonic_top_speed:		rs.w	1
Sonic_acceleration:		rs.w	1
Sonic_deceleration:		rs.w	1
Sonic_LastLoadedDPLC:		rs.b	1		; mapping frame number when Sonic last had his tiles requested to be transferred from ROM to VRAM. can be set to a dummy value like -1 to force a refresh DMA.
				rs.b	1		; $FFFFF767 ; unused
Primary_Angle:			rs.b	1
				rs.b	1		; $FFFFF769 ; unused
Secondary_Angle:		rs.b	1
				rs.b	1		; $FFFFF76B ; unused
Obj_placement_routine:		rs.b	1
				rs.b	1		; $FFFFF76D ; unused
Camera_X_pos_last:		rs.w	1		; Camera_X_pos_coarse from the previous frame

Obj_load_addr_right:		rs.l	1		; contains the address of the next object to load when moving right
Obj_load_addr_left:		rs.l	1		; contains the address of the next object to load when moving left
Obj_load_addr_right_P2:		rs.l	1
Obj_load_addr_left_P2:		rs.l	1

Object_RAM_block_indices:	rs.b	6		; seems to be an array of horizontal chunk positions, used for object position range checks
SS_rotation_angle:		equ	__rs-6		; 2 bytes
SS_rotation_speed:		equ	__rs-4		; 2 bytes
Player_1_loaded_object_blocks:	rs.b	3
Player_2_loaded_object_blocks:	rs.b	3

Camera_X_pos_last_P2:		rs.w	1
Obj_respawn_index_P2:		rs.w	1		; respawn table indices of the next objects when moving left or right for the second player

Demo_button_index:		rs.w	1		; index into button press demo data, for player 1
Demo_press_counter:		rs.b	1		; frames remaining until next button press, for player 1
				rs.b	1		; $FFFFF793 ; unused
PalChangeSpeed:			rs.w	1
Collision_addr:			rs.l	1
SS_palette_number:		rs.w	1		; current palette cycle in the Special Stage
SS_palette_time:		rs.w	1		; stores time until next palette cycle
SS_palette_index:		rs.w	1		; index into palette cycle 2, not sure if this is actually used
SS_BGAnim:			rs.w	1		; current background animation in the Special Stage
				rs.b	5		; $FFFFF7A2-$FFFFF7A6 ; unused
Boss_defeated_flag:		rs.b	1
				rs.b	2		; $FFFFF7A8-$FFFFF7A9 ; unused
Lock_screen:			rs.b	1
				rs.b	$12		; $FFFFF7AB-$FFFFF7BD ; unused
BigRingGraphics:		rs.w	1
				rs.b	7		; $FFFFF7C0-$FFFFF7C6 ; unused
WindTunnel_flag:		rs.b	1
Player_override_flag:		rs.b	1
WindTunnel_holding_flag:	rs.b	1
Sliding_flag:			rs.b	1
				rs.b	1		; $FFFFF7CB ; unused
Control_Locked:			rs.b	1
EnterSS_flag:			rs.b	1
				rs.b	2		; $FFFFF7CE-$FFFFF7CF ; unused
Chain_Bonus_counter:		rs.w	1		; counts up when you destroy things that give points, resets when you touch the ground
Bonus_Countdown_1:		rs.w	1		; level results time bonus
Bonus_Countdown_2:		rs.w	1		; level results ring bonus
Update_Bonus_score:		rs.b	1
				rs.b	1		; $FFFFF7D7 ; unused

Camera_X_pos_disposition:	rs.w	1		; this is used for the underwater ripple effect, removed from final
Camera_X_pos_coarse:		rs.w	1		; (Camera_X_pos - 128) / 256
Camera_X_pos_coarse_P2:		rs.w	1


Tails_LastLoadedDPLC:		rs.b	1		; mapping frame number when Tails last had his tiles requested to be transferred from ROM to VRAM. can be set to a dummy value like -1 to force a refresh DMA.
TailsTails_LastLoadedDPLC:	rs.b	1		; mapping frame number when Tails' tails last had their tiles requested to be transferred from ROM to VRAM. can be set to a dummy value like -1 to force a refresh DMA.

Button_TriggerArray:		rs.b	$10		; 16 bytes flag array, #subtype byte set when button/vine of respective subtype activated
Anim_Counters:			rs.b	$10
Misc_Variables_End:		equ	__rs

Sprite_Table:			rs.b	$200		; Sprite Attribute Table buffer
							; actually $280 bytes, but the last $80 are overwritten by Underwater_target_palette

Underwater_target_palette:		rs.b	palette_line_size	; this is used by the screen-fading subroutines.
Underwater_target_palette_line2:	rs.b	palette_line_size	; while Underwater_palette contains the blacked-out palette caused by the fading,
Underwater_target_palette_line3:	rs.b	palette_line_size	; Underwater_target_palette will contain the palette the screen will ultimately fade in to.
Underwater_target_palette_line4:	rs.b	palette_line_size

Underwater_palette:		rs.b	palette_line_size	; main palette for underwater parts of the screen
Underwater_palette_line2:	rs.b	palette_line_size
Underwater_palette_line3:	rs.b	palette_line_size
Underwater_palette_line4:	rs.b	palette_line_size

Normal_palette:			rs.b	palette_line_size	; main palette for non-underwater parts of the screen
Normal_palette_line2:		rs.b	palette_line_size
Normal_palette_line3:		rs.b	palette_line_size
Normal_palette_line4:		rs.b	palette_line_size

Target_palette:			rs.b	palette_line_size	; this is used by the screen-fading subroutines.
Target_palette_line2:		rs.b	palette_line_size	; while Normal_palette contains the blacked-out palette caused by the fading,
Target_palette_line3:		rs.b	palette_line_size	; Target_palette will contain the palette the screen will ultimately fade in to.
Target_palette_line4:		rs.b	palette_line_size

Object_Respawn_Table:		rs.w	1
Obj_respawn_data:		rs.b	$BE
Obj_respawn_data_End:		equ	__rs
				rs.b	$140		; Stack; the first $BE bytes are cleared by ObjectsManager_Init, with possibly disastrous consequences. At least $A0 bytes are needed.
System_Stack:			equ	__rs

CrossResetRAM:			equ	__rs		; RAM in this region will not be cleared after a soft reset.
				rs.w	1		; used by the 68000 to determine the stack location

Level_Inactive_flag:		rs.w	1
Level_frame_counter:		rs.w	1
Debug_object:			rs.b	1
				rs.b	1		; $FFFFFE07 ; unused
Debug_placement_mode:		rs.w	1
Debug_Accel_Timer:		rs.b	1
Debug_Speed:			rs.b	1
Vint_runcount:			rs.l	1

Current_ZoneAndAct:		rs.w	1
Current_Zone:			equ	__rs-2		; 1 byte
Current_Act:			equ	__rs-1		; 1 byte
Life_count:			rs.b	1
				rs.b	1		; $FFFFFE13 ; unused
Air_left:			rs.w	1
Current_SpecialStage:		rs.b	1
				rs.b	1		; $FFFFFE17 ; unused
Continue_count:			rs.b	1
				rs.b	1		; $FFFFFE19 ; unused
Time_Over_flag:			rs.b	1
Extra_life_flags:		rs.b	1

; If set, the respective HUD element will be updated.
Update_HUD_lives:		rs.b	1
Update_HUD_rings:		rs.b	1
Update_HUD_timer:		rs.b	1
Update_HUD_score:		rs.b	1

Ring_count:			rs.w	1
Timer:				rs.l	1
Timer_minute:			equ	__rs-3
Timer_second:			equ	__rs-2
Timer_frame:			equ	__rs-1
Score:				rs.l	1
				rs.b	2		; $FFFFFE2A-$FFFFFE2B ; unused
Shield_flag:			rs.b	1
Invincibility_flag:		rs.b	1
Speedshoes_flag:		rs.b	1
unk_FE2F:			rs.b	1		; cleared, never used

Last_star_pole_hit:		rs.b	1
Saved_Last_star_pole_hit:	rs.b	1
Saved_x_pos:			rs.w	1
Saved_y_pos:			rs.w	1
Saved_Ring_count:		rs.w	1
Saved_Timer:			rs.l	1
Saved_Dynamic_Resize_Routine:	rs.b	1
				rs.b	1	; $FFFFFE3D ; unused
Saved_Camera_Max_Y_pos:		rs.w	1
Saved_Camera_X_pos:		rs.w	1
Saved_Camera_Y_pos:		rs.w	1
Saved_Camera_BG_X_pos:		rs.w	1
Saved_Camera_BG_Y_pos:		rs.w	1
Saved_Camera_BG2_X_pos:		rs.w	1
Saved_Camera_BG2_Y_pos:		rs.w	1
Saved_Camera_BG3_X_pos:		rs.w	1
Saved_Camera_BG3_Y_pos:		rs.w	1
Saved_Water_Level:		rs.w	1
Saved_Water_routine:		rs.b	1
Saved_Water_move:		rs.b	1
Saved_Extra_life_flags:		rs.b	1
				rs.b	2	; $FFFFFE55-$FFFFFE56 ; unused

Emerald_count:			rs.b	1
Emeralds_array:			rs.b	6

LAST_VALUE:			equ	__rs	; $FE5E
		popo						; restore options

Logspike_anim_counter:		equ $FFFFFEC0
Logspike_anim_frame:		equ $FFFFFEC1
Rings_anim_counter:		equ $FFFFFEC2
Rings_anim_frame:		equ $FFFFFEC3
Unknown_anim_counter:		equ $FFFFFEC4
Unknown_anim_frame:		equ $FFFFFEC5
Ring_spill_anim_counter:	equ $FFFFFEC6
Ring_spill_anim_frame:		equ $FFFFFEC7
Ring_spill_anim_accum:		equ $FFFFFEC8

LevSel_HoldTimer:		equ $FFFFFF80
Level_select_zone:		equ $FFFFFF82
Sound_test_sound:		equ $FFFFFF84

Next_Extra_life_score:		equ $FFFFFFC0
Level_select_flag:		equ $FFFFFFE0
Slow_motion_flag:		equ $FFFFFFE1
Debug_options_flag:		equ $FFFFFFE2
Hidden_credits_flag:		equ $FFFFFFE3
Correct_cheat_entries:		equ $FFFFFFE4
Correct_cheat_entries_2:	equ $FFFFFFE6
Two_player_mode:		equ $FFFFFFE8
unk_FFEA:			equ $FFFFFFEA
Demo_mode_flag:			equ $FFFFFFF0
Demo_number:			equ $FFFFFFF2
Ending_demo_number:		equ $FFFFFFF4
Graphics_flags:			equ $FFFFFFF8
Debug_mode_flag:		equ $FFFFFFFA
Checksum_fourcc:		equ $FFFFFFFC

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