; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load the Kosinski-compressed DAC driver into Z80 RAM
; ---------------------------------------------------------------------------
; sub_13B2:
SoundDriverLoad:
		nop
		move.w	#$100,(Z80_Bus_Request).l
		move.w	#$100,(Z80_Reset).l
		lea	(Kos_Z80).l,a0
		lea	(Z80_RAM).l,a1
		bsr.w	KosDec
		move.w	#0,(Z80_Reset).l
		nop
		nop
		nop
		nop
		move.w	#$100,(Z80_Reset).l
		startZ80
		rts
; End of function SoundDriverLoad