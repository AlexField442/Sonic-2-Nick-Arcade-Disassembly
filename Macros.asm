align macro
	dcb.b (\1-(*%\1))%\1,0
	endm

stopZ80 macro
	move.w	#$100,(Z80_Bus).l
@loop:	btst	#0,(Z80_Bus).l
	bne.s	@loop
	endm

startZ80 macro
	move.w	#0,(Z80_Bus).l
	endm
