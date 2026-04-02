; ===========================================================================
; ---------------------------------------------------------------------------
; OBJECT POINTER ARRAY ; object pointers ; sprite pointers ; object list ; sprite list
;
; This array contains the pointers to all the objects used in the game.
; ---------------------------------------------------------------------------
Obj_Index:
		dc.l Obj_Sonic		; Sonic
		dc.l Obj02		; Tails
		dc.l Obj03		; Collision plane/layer switcher
		dc.l Obj04		; Surface of the water
		dc.l Obj05		; Tails' tails
		dc.l Obj06		; Twisting spiral pathway in EHZ
		dc.l ObjNull
		dc.l Obj_WaterSplash	; Water splash in HPZ
		dc.l Obj09		; (S1) Sonic in the Speical Stage
		dc.l Obj0A		; Small bubbles from Sonic's face while underwater
		dc.l Obj0B		; (S1) Pole that breaks in LZ
		dc.l Obj0C		; Strange floating/falling platform object from CPZ
		dc.l Obj0D		; End of level signpost
		dc.l Obj0E		; Sonic and Tails from the title screen
		dc.l Obj0F		; Mappings test?
		dc.l Obj_SonAniTest	; (S1) Sonic animation test object (removed)
		dc.l Obj_Bridge		; Bridges in GHZ, EHZ and HPZ
		dc.l Obj12		; Emerald from Hidden Palace Zone
		dc.l Obj13		; Waterfall from Hidden Palace Zone
		dc.l Obj14		; Seesaw from Hill Top Zone
		dc.l Obj15		; Swinging platforms in GHZ, CPZ and EHZ
		dc.l Obj_HTZLift	; Diagonally moving lift from HTZ
		dc.l Obj_SpikeHelix	; (S1) GHZ rotating log helix spikes
		dc.l Obj18		; Stationary/moving platforms from GHZ and EHZ
		dc.l Obj19		; Platform from CPZ
		dc.l Obj1A		; Collapsing platform from GHZ and HPZ
		dc.l ObjNull
		dc.l Obj1C		; Stage decorations in GHZ, EHZ, HTZ and HPZ
		dc.l ObjNull
		dc.l ObjNull
		dc.l Obj1F		; (S1) Crabmeat from GHZ
		dc.l ObjNull
		dc.l Obj21		; Score/Rings/Time display (HUD)
		dc.l Obj22		; (S1) Buzz Bomber from GHZ
		dc.l Obj23		; (S1) Buzz Bomber/Newtron missile
		dc.l Obj24		; (S1) Unused Buzz Bomber missile explosion
		dc.l Obj25		; A ring
		dc.l Obj26		; Monitor
		dc.l Obj27		; An explosion, giving off an animal and 100 points
		dc.l Obj28		; Animal and the 100 points from a badnik
		dc.l Obj29		; "100 points" text
		dc.l Obj2A		; (S1) Small door from SBZ
		dc.l Obj2B		; (S1) Chopper from GHZ
		dc.l Obj2C		; (S1) Jaws from LZ
		dc.l ObjNull
		dc.l Obj2E		; Monitor contents (code for power-up behavior and rising image)
		dc.l ObjNull
		dc.l ObjNull
		dc.l ObjNull
		dc.l ObjNull
		dc.l ObjNull
		dc.l Obj_TitleCard	; (S1) Level title card
		dc.l ObjNull
		dc.l Obj36		; Vertical spikes
		dc.l Obj37		; Scattering rings (generated when Sonic or Tails are hurt and has rings)
		dc.l Obj_Barrier	; Shield and invincibility stars
		dc.l Obj39		; Game Over/Time Over text
		dc.l Obj3A		; (S1) End of level results screen
		dc.l Obj3B		; (S1) Purple rock from GHZ
		dc.l Obj3C		; (S1) Breakable wall
		dc.l Obj3D		; (S1) GHZ boss
		dc.l Obj3E		; Egg prison
		dc.l Obj3F		; Boss explosion
		dc.l Obj40		; (S1) Motobug from GHZ
		dc.l Obj41		; Spring
		dc.l Obj42		; (S1) Newtron from GHZ
		dc.l ObjNull
		dc.l Obj44		; (S1) Unbreakable wall
		dc.l ObjNull
		dc.l ObjNull
		dc.l ObjNull
		dc.l Obj48		; (S1) Eggman's wrecking ball
		dc.l Obj_EHZWaterfall	; Waterfall from EHZ
		dc.l Obj4A		; Octus from HPZ
		dc.l Obj4B		; Buzzer from EHZ
		dc.l Obj4C		; BBat from HPZ
		dc.l Obj4D		; Stego/Stegway from HPZ
		dc.l Obj4E		; Gator from HPZ
		dc.l Obj4F		; Redz (dinosaur badnik) from HPZ
		dc.l Obj50		; Seahorse/Aquis from HPZ
		dc.l Obj51		; Skyhorse from HPZ
		dc.l Obj52		; BFish from HPZ
		dc.l Obj53		; Masher from EHZ
		dc.l Obj54		; Snail badnik from EHZ
		dc.l Obj55		; EHZ boss
		dc.l Obj56		; EHZ boss part 2
		dc.l Obj57		; EHZ boss part 3
		dc.l Obj58		; EHZ boss part 4
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
		dc.l Obj79		; Checkpoint
		dc.l ObjNull
		dc.l ObjNull
		dc.l ObjNull
		dc.l Obj7D		; (S1) Hidden points at end of stage
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
		dc.l Obj8A		; (S1) "SONIC TEAM PRESENTS" screen and credits
		dc.l ObjNull
		dc.l ObjNull
; ===========================================================================
; Blank object, allocates its array; this pointer existed in Sonic 1 as well,
; but there it lacked any branch and instead fell into ObjectMoveAndFall
; jmp_DeleteObject:
ObjNull:
		bra.w	DeleteObject