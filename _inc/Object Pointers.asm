; ===========================================================================
; ---------------------------------------------------------------------------
; OBJECT POINTER ARRAY ; object pointers ; sprite pointers ; object list ; sprite list
;
; This array contains the pointers to all the objects used in the game.
; ---------------------------------------------------------------------------

; define an object ID constant
objptr macro *,pointer
	\*:	equ	((*-Obj_Index)/4)+1
	dc.l	pointer
	endm

Obj_Index:
ObjID_Sonic:		objptr Obj_Sonic	; Sonic
ObjID_Tails:		objptr Obj02		; Tails
ObjID_Pathswapper:	objptr Obj03		; Collision plane/layer switcher
ObjID_WaterSurface:	objptr Obj04		; Surface of the water
ObjID_TailsTails:	objptr Obj05		; Tails' tails
ObjID_Spiral:		objptr Obj06		; Twisting spiral pathway in EHZ
			dc.l ObjNull
ObjID_WaterSplash:	objptr Obj_WaterSplash	; Water splash in HPZ
ObjID_SSPlayer:		objptr Obj09		; (S1) Sonic in the Special Stage
ObjID_SmallBubbles:	objptr Obj0A		; Small bubbles from Sonic's face while underwater
ObjID_LZPole:		objptr Obj0B		; (S1) Pole that breaks in LZ
ObjID_CPZPlatform:	objptr Obj0C		; Strange floating/falling platform object from CPZ
ObjID_Signpost:		objptr Obj0D		; End of level signpost
ObjID_TitleCharacters:	objptr Obj0E		; Sonic and Tails from the title screen
ObjID_Unknown0F:	objptr Obj0F		; Mappings test?
ObjID_SonAniTest:	objptr Obj_SonAniTest	; (S1) Sonic animation test object (removed)
ObjID_Bridge:		objptr Obj_Bridge	; Bridges in GHZ, EHZ and HPZ
ObjID_HPZEmerald:	objptr Obj12		; Emerald from Hidden Palace Zone
ObjID_HPZWaterfall:	objptr Obj13		; Waterfall from Hidden Palace Zone
ObjID_Seesaw:		objptr Obj_Seesaw	; Seesaw from Hill Top Zone
ObjID_SwingingPlatform:	objptr Obj15		; Swinging platforms in GHZ, CPZ and EHZ
ObjID_HTZLift:		objptr Obj_HTZLift	; Diagonally moving lift from HTZ
ObjID_SpikeHelix:	objptr Obj_SpikeHelix	; (S1) GHZ rotating log helix spikes
ObjID_Platform:		objptr Obj18		; Stationary/moving platforms from GHZ and EHZ
ObjID_Platform2:	objptr Obj19		; Platform from CPZ
ObjID_CollapsingPltfm:	objptr Obj1A		; Collapsing platform from GHZ and HPZ
			dc.l ObjNull
ObjID_Scenery:		objptr Obj1C		; Stage decorations in GHZ, EHZ, HTZ and HPZ
			dc.l ObjNull
ObjID_Ballhog:		objptr ObjNull		; (S1) Ballhog from SBZ (pointer removed)
ObjID_Crabmeat:		objptr Obj_Crabmeat	; (S1) Crabmeat from GHZ
ObjID_Cannonball:	objptr ObjNull		; (S1) Cannonball from Ballhog (pointer removed)
ObjID_HUD:		objptr Obj_HUD		; Score/Rings/Time display (HUD)
ObjID_BuzzBomber:	objptr Obj_BuzzBomber	; (S1) Buzz Bomber from GHZ
ObjID_Missile:		objptr Obj_Missile	; (S1) Buzz Bomber/Newtron missile
ObjID_Fizzle:		objptr Obj24		; (S1) Unused Buzz Bomber missile explosion
ObjID_Ring:		objptr Obj25		; A ring
ObjID_Monitor:		objptr Obj26		; Monitor
ObjID_Explosion:	objptr Obj27		; An explosion, giving off an animal and 100 points
ObjID_Animal:		objptr Obj_Animal	; Animals from badnik
ObjID_Points:		objptr Obj29		; "100 points" text
ObjID_Door:		objptr Obj2A		; (S1) Small door from SBZ
ObjID_Chopper:		objptr Obj2B		; (S1) Chopper from GHZ
ObjID_Jaws:		objptr Obj2C		; (S1) Jaws from LZ
			dc.l ObjNull
ObjID_MonitorContents:	objptr Obj2E		; Monitor contents (code for power-up behavior and rising image)
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
ObjID_TitleCard:	objptr Obj_TitleCard	; (S1) Level title card
			dc.l ObjNull
ObjID_Spikes:		objptr Obj36		; Vertical spikes
ObjID_LostRings:	objptr Obj37		; Scattering rings (generated when Sonic or Tails are hurt and has rings)
ObjID_Barrier:		objptr Obj_Barrier	; Shield and invincibility stars
ObjID_GameOver:		objptr Obj_GameOver	; Game Over/Time Over text
ObjID_Results:		objptr Obj_Results	; (S1) End of level results screen
ObjID_PurpleRock:	objptr Obj3B		; (S1) Purple rock from GHZ
ObjID_BreakableWall:	objptr Obj3C		; (S1) Breakable wall
ObjID_GHZBoss:		objptr Obj3D		; (S1) GHZ boss
ObjID_EggPrison:	objptr Obj3E		; Egg prison
ObjID_BossExplosion:	objptr Obj3F		; Boss explosion
ObjID_Motobug:		objptr Obj40		; (S1) Motobug from GHZ
ObjID_Spring:		objptr Obj41		; Spring
ObjID_Newtron:		objptr Obj42		; (S1) Newtron from GHZ
			dc.l ObjNull
ObjID_GHZWall:		objptr Obj44		; (S1) Unbreakable wall
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
ObjID_WreckingBall:	objptr Obj48		; (S1) Eggman's wrecking ball
ObjID_EHZWaterfall:	objptr Obj_EHZWaterfall	; Waterfall from EHZ
ObjID_Octus:		objptr Obj4A		; Octus from HPZ
ObjID_Buzzer:		objptr Obj4B		; Buzzer from EHZ
ObjID_BBat:		objptr Obj4C		; BBat from HPZ
ObjID_Stego:		objptr Obj4D		; Stego/Stegway from HPZ
ObjID_Gator:		objptr Obj4E		; Gator from HPZ
ObjID_Redz:		objptr Obj_Redz		; Redz (dinosaur badnik) from HPZ
ObjID_Seahorse:		objptr Obj50		; Seahorse/Aquis from HPZ
ObjID_Skyhorse:		objptr Obj51		; Skyhorse from HPZ
ObjID_BFish:		objptr Obj52		; BFish from HPZ
ObjID_Masher:		objptr Obj53		; Masher from EHZ
ObjID_Snail:		objptr Obj54		; Snail badnik from EHZ
ObjID_EHZBoss:		objptr Obj55		; EHZ boss
ObjID_EHZBoss2:		objptr Obj56		; EHZ boss part 2
ObjID_EHZBoss3:		objptr Obj57		; EHZ boss part 3
ObjID_EHZBoss4:		objptr Obj58		; EHZ boss part 4
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
ObjID_Bubbles:		objptr ObjNull		; (S1) Bubble generator (pointer removed)
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
ObjID_LZBoss:		objptr ObjNull		; (S1) LZ boss (pointer AND code removed)
			dc.l ObjNull
ObjID_Checkpoint:	objptr Obj79		; Checkpoint
			dc.l ObjNull
			dc.l ObjNull
ObjID_RingFlash:	objptr ObjNull		; (S1) Giant ring flash (pointer removed)
ObjID_HiddenPoints:	objptr Obj7D		; (S1) Hidden points at end of stage
ObjID_SSResults:	objptr ObjNull		; (S1) Special Stage results (pointer removed)
ObjID_SSEmeralds:	objptr ObjNull		; (S1) Special Stage results emeralds (pointer removed)
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
			dc.l ObjNull
ObjID_StaffRoll:	objptr Obj_StaffRoll	; (S1) "SONIC TEAM PRESENTS" screen and credits
			dc.l ObjNull
			dc.l ObjNull
; ===========================================================================
; Blank object, allocates its array; this pointer existed in Sonic 1 as well,
; but there it lacked any branch and instead fell into ObjectMoveAndFall
; jmp_DeleteObject:
ObjNull:
		bra.w	DeleteObject