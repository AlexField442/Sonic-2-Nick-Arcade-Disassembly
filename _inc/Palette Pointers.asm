; ===========================================================================
; ---------------------------------------------------------------------------
; Palette pointers
; (PALETTE DESCRIPTOR ARRAY)
; This struct array defines the palette to use for each level.
; ---------------------------------------------------------------------------

palptr	macro	ptr,ram,size
	dc.l ptr	; Pointer to palette
	dc.w ram	; Location in ram to load palette into
	dc.w size	; Size of palette in (bytes / 4)
	endm

PalPointers:	palptr	Pal_SegaBG,Normal_palette,$1F
		palptr	Pal_Title,Normal_palette,$1F
		palptr	Pal_LevelSelect,Normal_palette,$1F
		palptr	Pal_SonicTails,Normal_palette,7
		palptr	Pal_GHZ,Normal_palette_line2,$17
		palptr	Pal_CPZ,Normal_palette_line2,$17
		palptr	Pal_CPZ,Normal_palette_line2,$17
		palptr	Pal_EHZ,Normal_palette_line2,$17
		palptr	Pal_HPZ,Normal_palette_line2,$17
		palptr	Pal_HTZ,Normal_palette_line2,$17
		palptr	Pal_S1SpecialStage,Normal_palette,$1F
		palptr	Pal_HPZWater,Normal_palette,$1F
		; the following are leftover Sonic 1 entries
		palptr	Pal_LZ4,Normal_palette_line2,$17
		palptr	Pal_LZ4Water,Normal_palette,$1F
		palptr	Pal_HTZ,Normal_palette_line2,$17
		palptr	Pal_LZSonicWater,Normal_palette,7
		palptr	Pal_LZ4SonicWater,Normal_palette,7
		palptr	Pal_S1SpeResults,Normal_palette,$1F
		palptr	Pal_S1Continue,Normal_palette,$F
		palptr	Pal_S1Ending,Normal_palette,$1F
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