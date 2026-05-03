; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutines to queue audio for the sound driver
;
; The first two can be used interchangably, but the symbol tables label
; them as 'bgmset' and 'soundset'. The third one is broken and does not
; have a label, presumably due to it being commented out.
; ---------------------------------------------------------------------------
; loc_13F6:
PlayMusic:
		move.b	d0,(Sound_Driver_RAM+SFXToPlay).w
		rts
; End of function PlayMusic

; ---------------------------------------------------------------------------
; loc_13FC:
PlaySound:
		move.b	d0,(Sound_Driver_RAM+SFXToPlay2).w
		rts
; End of function PlaySound

; ---------------------------------------------------------------------------
; loc_1402:
PlaySound_Unk:
		move.b	d0,(Sound_Driver_RAM+SFXToPlay3).w
		rts
; End of functions PlaySound_Unk
