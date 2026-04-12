; ---------------------------------------------------------------------------
; PATTERN LOAD CUE LISTS
;
; PATTERN LOAD CUES are simple structures used to load Nemesis-compressed art for sprites.
;
; The decompressor predictably moves down the list, so request 0 is processed first, etc.
; This only matters if your addresses are bad and you overwrite art loaded in a previous request.
;
; NOTICE: The load queue buffer can only hold $10 (16) load requests. None of the routines
; that load PLRs into the queue do any bounds checking, so it's possible to create a buffer
; overflow and completely screw up the variables stored directly after the queue buffer.
; (in my experience this is a guaranteed crash or hang)
;
; Many levels queue more than 16 items overall, but they don't exceed the limit because
; their PLRs are split into multiple parts (like PLC_GHZ and PLC_GHZ2) and they fully
; process the first part before requesting the rest.
; ---------------------------------------------------------------------------

; define a PLC ID constant
plcptr	macro	*,pointer
	\*:	equ	(*-ArtLoadCues)/2
	dc.w	pointer-ArtLoadCues
	endm

ArtLoadCues:
PLCID_Main:		plcptr PLC_Main
PLCID_Main2:		plcptr PLC_Main2
PLCID_Explode:		plcptr PLC_Explode
PLCID_GameOver:		plcptr PLC_GameOver
PLCID_GHZ:		plcptr PLC_GHZ
PLCID_GHZ2:		plcptr PLC_GHZ2
PLCID_LZ:		plcptr PLC_CPZ
PLCID_LZ2:		plcptr PLC_CPZ2
PLCID_CPZ:		plcptr PLC_CPZ
PLCID_CPZ2:		plcptr PLC_CPZ2
PLCID_EHZ:		plcptr PLC_EHZ
PLCID_EHZ2:		plcptr PLC_EHZ2
PLCID_HPZ:		plcptr PLC_HPZ
PLCID_HPZ2:		plcptr PLC_HPZ2
PLCID_HTZ:		plcptr PLC_HTZ
PLCID_HTZ2:		plcptr PLC_HTZ2
PLCID_TitleCard:	plcptr PLC_S1TitleCard
PLCID_Boss:		plcptr PLC_Boss
PLCID_Signpost:		plcptr PLC_Signpost
PLCID_Warp:		plcptr PLC_Warp
PLCID_SpecialStage:	plcptr PLC_S1SpecialStage
PLCID_GHZAnimals:	plcptr PLC_GHZAnimals
PLCID_LZAnimals:	plcptr PLC_LZAnimals
PLCID_CPZAnimals:	plcptr PLC_CPZAnimals
PLCID_EHZAnimals:	plcptr PLC_EHZAnimals
PLCID_HPZAnimals:	plcptr PLC_HPZAnimals
PLCID_HTZAnimals:	plcptr PLC_HTZAnimals
PLCID_SSResults:	plcptr PLC_SSResults
PLCID_Ending:		plcptr PLC_Ending
PLCID_TryAgain:		plcptr PLC_TryAgain
PLCID_EggmanSBZ2	plcptr PLC_EggmanSBZ2
PLCID_FZBoss:		plcptr PLC_FZBoss

; macro for the header of a PLC list
plcheader macro *
\*:	dc.w ((\*_End-\*-2)/6)-1
	endm

; macro for a pattern load cue entry
plc macro toVRAMaddr,fromROMaddr
	dc.l	fromROMaddr		; art to load
	dc.w	(toVRAMaddr<<5)		; VRAM address to load it at (multiplied by $20)
	endm

; ---------------------------------------------------------------------------
; Pattern Load Cues - Standard 1 (loaded at all times)
; ---------------------------------------------------------------------------
PLC_Main:	plcheader
		plc $47C, Nem_Lamppost
		plc $6CA, Nem_HUD
		plc $7D4, Nem_Lives
		plc $6BC, Nem_Ring
		plc $4AC, Nem_Points
PLC_Main_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Standard 2 (loaded at start of level)
; ---------------------------------------------------------------------------
PLC_Main2:	plcheader
		plc $680, Nem_Monitors
		plc $4BE, Nem_Shield
		plc $4DE, Nem_Stars
PLC_Main2_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Explosion (loaded at start of level *after* title card)
; ---------------------------------------------------------------------------
PLC_Explode:	plcheader
		plc $5A0, Nem_Explosion
PLC_Explode_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Game/Time Over
; ---------------------------------------------------------------------------
PLC_GameOver:	plcheader
		plc $55E, Nem_GameOver
PLC_GameOver_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Green Hill Zone
; ---------------------------------------------------------------------------
PLC_GHZ:	plcheader
		plc 0, Nem_GHZ
		plc $470, Nem_GHZ_Piranha
		plc $4A0, Nem_VSpikes
		plc $4A8, Nem_VSpring
		plc $4B8, Nem_HSpring
		plc $4C6, Nem_GHZ_Bridge
		plc $4D0, Nem_SwingPlatform
		plc $4E0, Nem_Motobug
		plc $6C0, Nem_GHZ_Rock
PLC_GHZ_End:

PLC_GHZ2:	plcheader
		plc $470, Nem_GHZ_Piranha
PLC_GHZ2_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Chemical Plant Zone
; ---------------------------------------------------------------------------
PLC_CPZ:	plcheader
		plc 0, Nem_CPZ
		plc $3D0, Nem_CPZ_Unknown
		plc $400, Nem_CPZ_FloatingPlatform
PLC_CPZ_End:

PLC_CPZ2:	plcheader
		plc $434, Nem_VSpikes
		plc $43C, Nem_DSpring
		plc $45C, Nem_VSpring2
		plc $470, Nem_HSpring2
PLC_CPZ2_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Emerald Hill Zone
; ---------------------------------------------------------------------------
PLC_EHZ:	plcheader
		plc 0, Nem_EHZ
		plc $39E, Nem_EHZ_Fireball
		plc $3AE, Nem_EHZ_Waterfall
		plc $3C6, Nem_EHZ_Bridge
		plc $3CE, Nem_HTZ_Seesaw
		plc $434, Nem_VSpikes
		plc $43C, Nem_DSpring
		plc $45C, Nem_VSpring2
		plc $470, Nem_HSpring2
PLC_EHZ_End:

PLC_EHZ2:	plcheader
		plc $560, Nem_Shield
		plc $4AC, Nem_Points
		plc $3E6, Nem_Buzzer
		plc $402, Nem_Snail
		plc $41C, Nem_Masher
PLC_EHZ2_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Hidden Palace Zone
; ---------------------------------------------------------------------------

PLC_HPZ:	plcheader
		plc 0, Nem_HPZ
		plc $300, Nem_HPZ_Bridge
		plc $315, Nem_HPZ_Waterfall
		plc $34A, Nem_HPZ_Platform
		plc $35A, Nem_HPZ_PulsingBall
		plc $37C, Nem_HPZ_Various
		plc $392, Nem_HPZ_Emerald
		plc $400, Nem_HPZ_WaterSurface
PLC_HPZ_End:

PLC_HPZ2:	plcheader
		plc $500, Nem_Redz
		plc $530, Nem_Bat
PLC_HPZ2_End:
		; unused PLR entries
		plc $300, Nem_Crocobot
		plc $32C, Nem_Buzzer
		plc $350, Nem_Bat
		plc $3C4, Nem_Triceratops
		plc $500, Nem_Redz
		plc $530, Nem_HPZ_Piranha

; ---------------------------------------------------------------------------
; Pattern Load Cues - Hill Top Zone
; ---------------------------------------------------------------------------
PLC_HTZ:	plcheader
		plc 0, Nem_EHZ
		plc $1FC, Nem_HTZ
		plc $500, Nem_HTZ_AniPlaceholders
		plc $39E, Nem_EHZ_Fireball
		plc $3AE, Nem_HTZ_Fireball
		plc $3BE, Nem_HTZ_AutomaticDoor
		plc $3C6, Nem_EHZ_Bridge
		plc $3CE, Nem_HTZ_Seesaw
		plc $434, Nem_VSpikes
		plc $43C, Nem_DSpring
PLC_HTZ_End:
		; unused PLR entries
		plc $45C, Nem_VSpring2
		plc $470, Nem_HSpring2

PLC_HTZ2:	plcheader
		plc $3E6, Nem_HTZ_Lift
PLC_HTZ2_End:
		; unused PLR entries
		plc $3E6, Nem_Buzzer
		plc $402, Nem_Snail
		plc $41C, Nem_Masher

; ---------------------------------------------------------------------------
; Pattern Load Cues - Title Card
; ---------------------------------------------------------------------------
PLC_S1TitleCard:plcheader
		plc $580, Nem_S1TitleCard
PLC_S1TitleCard_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Bosses
; ---------------------------------------------------------------------------
PLC_Boss:	plcheader
		plc $460, Nem_BossShip
		plc $4C0, Nem_EHZ_Boss
		plc $540, Nem_EHZ_Boss_Blades
PLC_Boss_End:
		; unused PLR entries
		plc $400, Nem_BossShip
		plc $460, Nem_CPZ_ProtoBoss
		plc $4D0, Nem_BossShipBoost
		plc $4D8, Nem_Smoke
		plc $4E8, Nem_EHZ_Boss
		plc $568, Nem_EHZ_Boss_Blades

; ---------------------------------------------------------------------------
; Pattern Load Cues - Signpost
; ---------------------------------------------------------------------------
PLC_Signpost:	plcheader
		plc $680, Nem_Signpost
		plc $4B6, Nem_S1BonusPoints
		plc $462, Nem_BigFlash
PLC_Signpost_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Warp Effect (removed)
; ---------------------------------------------------------------------------
PLC_Warp:
PLC_Warp_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Special Stage (blank)
; ---------------------------------------------------------------------------
; PLC_Invalid:
PLC_S1SpecialStage:	dc.w ((PLC_S1SpecialStage_End-PLC_S1SpecialStage)/6)-1+$11
PLC_S1SpecialStage_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - GHZ Animals
; ---------------------------------------------------------------------------
PLC_GHZAnimals:	plcheader
		plc $580, Nem_Bunny
		plc $592, Nem_Flicky
PLC_GHZAnimals_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - LZ Animals
; ---------------------------------------------------------------------------
PLC_LZAnimals:	plcheader
		plc $580, Nem_Penguin
		plc $592, Nem_Seal
PLC_LZAnimals_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - CPZ Animals
; ---------------------------------------------------------------------------
PLC_CPZAnimals:	plcheader
		plc $580, Nem_Squirrel
		plc $592, Nem_Seal
PLC_CPZAnimals_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - EHZ Animals
; ---------------------------------------------------------------------------
PLC_EHZAnimals:	plcheader
		plc $580, Nem_Pig
		plc $592, Nem_Flicky
PLC_EHZAnimals_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - HPZ Animals
; ---------------------------------------------------------------------------
PLC_HPZAnimals:	plcheader
		plc $580, Nem_Pig
		plc $592, Nem_Chicken
PLC_HPZAnimals_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - HTZ Animals
; ---------------------------------------------------------------------------
PLC_HTZAnimals:	plcheader
		plc $580, Nem_Bunny
		plc $592, Nem_Chicken
PLC_HTZAnimals_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Special Stage results screen (blank)
; ---------------------------------------------------------------------------
PLC_SSResults:	dc.w ((PLC_SSResults_End-PLC_SSResults)/6)-1+2
PLC_SSResults_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Ending Sequence (blank)
; ---------------------------------------------------------------------------
PLC_Ending:	dc.w ((PLC_Ending_End-PLC_Ending)/6)-1+$E
PLC_Ending_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Try Again/End screens (blank)
; ---------------------------------------------------------------------------
PLC_TryAgain:	dc.w ((PLC_TryAgain_End-PLC_TryAgain)/6)-1+3
PLC_TryAgain_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Eggman in SBZ2 (blank)
; ---------------------------------------------------------------------------
PLC_EggmanSBZ2:	dc.w ((PLC_EggmanSBZ2_End-PLC_EggmanSBZ2)/6)-1+3
PLC_EggmanSBZ2_End:

; ---------------------------------------------------------------------------
; Pattern Load Cues - Final Boss (blank)
; ---------------------------------------------------------------------------
PLC_FZBoss:	dc.w ((PLC_FZBoss_End-PLC_FZBoss)/6)-1+5
PLC_FZBoss_End: