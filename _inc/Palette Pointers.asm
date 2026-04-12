; ===========================================================================
; ---------------------------------------------------------------------------
; Palette pointers
; (PALETTE DESCRIPTOR ARRAY)
; This struct array defines the palette to use for each level.
; ---------------------------------------------------------------------------

; define a palette entry and ID constant
palptr	macro	*,ptr,ram,size
	\*:	equ	(*-PalPointers)/8
	dc.l ptr	; Pointer to palette
	dc.w ram	; Location in ram to load palette into
	dc.w size	; Size of palette in (bytes / 4)
	endm

PalPointers:
PalID_Sega:		palptr	Pal_SegaBG,Normal_palette,$1F
PalID_Title:		palptr	Pal_Title,Normal_palette,$1F
PalID_LevelSelect:	palptr	Pal_LevelSelect,Normal_palette,$1F
PalID_SonicTails:	palptr	Pal_SonicTails,Normal_palette,7
PalID_GHZ:		palptr	Pal_GHZ,Normal_palette_line2,$17
PalID_LZ:		palptr	Pal_CPZ,Normal_palette_line2,$17
PalID_CPZ:		palptr	Pal_CPZ,Normal_palette_line2,$17
PalID_EHZ:		palptr	Pal_EHZ,Normal_palette_line2,$17
PalID_HPZ:		palptr	Pal_HPZ,Normal_palette_line2,$17
PalID_HTZ:		palptr	Pal_HTZ,Normal_palette_line2,$17
PalID_SpecialStage:	palptr	Pal_S1SpecialStage,Normal_palette,$1F
PalID_HPZWater:		palptr	Pal_HPZWater,Normal_palette,$1F
			; the following are leftover Sonic 1 entries
PalID_LZ4:		palptr	Pal_LZ4,Normal_palette_line2,$17
PalID_LZ4Water:		palptr	Pal_LZ4Water,Normal_palette,$1F
PalID_SBZ2:		palptr	Pal_HTZ,Normal_palette_line2,$17
PalID_LZSonicWater:	palptr	Pal_LZSonicWater,Normal_palette,7
PalID_LZ4SonicWater:	palptr	Pal_LZ4SonicWater,Normal_palette,7
PalID_SSResults:	palptr	Pal_S1SpeResults,Normal_palette,$1F
PalID_Continue:		palptr	Pal_S1Continue,Normal_palette,$F
PalID_Ending:		palptr	Pal_S1Ending,Normal_palette,$1F
; ---------------------------------------------------------------------------
Pal_SegaBG:		incbin	"art/palettes/Sega screen background.bin"
Pal_Title:		incbin	"art/palettes/Title screen.bin"
Pal_LevelSelect:	incbin	"art/palettes/Level select.bin"
Pal_SonicTails:		incbin	"art/palettes/Sonic and Tails.bin"
Pal_GHZ:		incbin	"art/palettes/GHZ.bin"
Pal_HPZWater:		incbin	"art/palettes/HPZ underwater.bin"
Pal_CPZ:		incbin	"art/palettes/CPZ.bin"
Pal_EHZ:		incbin	"art/palettes/EHZ.bin"
Pal_HPZ:		incbin	"art/palettes/HPZ.bin"
Pal_HTZ:		incbin	"art/palettes/HTZ.bin"
			; Sonic 1 leftovers
Pal_S1SpecialStage:	incbin	"art/palettes/S1 Special Stage.bin"
Pal_LZ4:		incbin	"art/palettes/LZ4.bin"
Pal_LZ4Water:		incbin	"art/palettes/LZ4 underwater.bin"
Pal_LZSonicWater:	incbin	"art/palettes/LZ Sonic underwater.bin"
Pal_LZ4SonicWater:	incbin	"art/palettes/LZ4 Sonic underwater.bin"
Pal_S1SpeResults:	incbin	"art/palettes/S1 Special Stage results.bin"
Pal_S1Continue:		incbin	"art/palettes/S1 Continue screen.bin"
Pal_S1Ending:		incbin	"art/palettes/S1 Ending.bin"
; ===========================================================================
		nop