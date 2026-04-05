; ---------------------------------------------------------------------------
; "MAIN LEVEL LOAD BLOCK" (after Nemesis)
;
; This struct array tells the engine where to find all the art associated with
; a particular zone. Each zone gets four longwords, in which it stores four
; pointers (in the lower 24 bits) and three jump table indeces (in the upper eight
; bits). The assembled data looks something like this:
;
; aaBBBBBB
; ccDDDDDD
; EEEEEE
; ffgghhii
;
; aa = index for primary pattern load request list
; BBBBBB = unused, pointer to level art
; cc = index for secondary pattern load request list
; DDDDDD = pointer to 16x16 block mappings
; EEEEEE = pointer to 128x128 block mappings
; ff = unused, always 0
; gg = unused, music track
; hh = unused, palette
; ii = palette
;
; Nemesis refers to this as the "main level load block". However, that name implies
; that this is code (obviously, it isn't), or at least that it points to the level's
; collision, object and ring placement arrays (it only points to palettes and 16x16
; mappings although the 128x128 mappings do affect the actual level layout and collision)
; ---------------------------------------------------------------------------

; macro for declaring a "main level load block" (MLLB)
levartptrs macro plc1,plc2,palette,art,map16x16,map128x128,music
	dc.l art+(plc1<<24)
	dc.l map16x16+(plc2<<24)
	dc.l map128x128
	dc.b 0,music,palette,palette
	endm

; MainLoadBlocks:
LevelArtPointers:
		levartptrs  4,  5,  4, Nem_GHZ, Map16_GHZ, Map128_GHZ, MusID_GHZ		;   0 ; GHZ  ; GREEN HILL ZONE
		levartptrs  6,  7,  5, Nem_CPZ, Map16_CPZ, Map128_CPZ, MusID_LZ			;   1 ; LZ   ; LABYRINTH ZONE
		levartptrs  8,  9,  6, Nem_CPZ, Map16_CPZ, Map128_CPZ, MusID_CPZ		;   2 ; CPZ  ; CHEMICAL PLANT ZONE
		levartptrs $A, $B,  7, Nem_EHZ, Map16_EHZ, Map128_EHZ, MusID_EHZ		;   3 ; EHZ  ; EMERALD HILL ZONE
		levartptrs $C, $D,  8, Nem_HPZ, Map16_HPZ, Map128_HPZ, MusID_HPZ		;   4 ; HPZ  ; HIDDEN PALACE ZONE
		levartptrs $E, $F,  9, Nem_EHZ, Map16_EHZ, Map128_EHZ, MusID_HTZ		;   5 ; HTZ  ; HILL TOP ZONE
		levartptrs  0,  0,$13, Nem_GHZ, Map16_GHZ, Map128_GHZ, MusID_HTZ		;   6 ; LEV6 ; LEVEL 6 (UNUSED, SONIC 1 ENDING)