align macros
	dcb.b (\1-(*%\1))%\1,0

stopZ80 macro
	move.w	#$100,(Z80_Bus).l
.loop:	btst	#0,(Z80_Bus).l
	bne.s	.loop
	endm

startZ80 macros
	move.w	#0,(Z80_Bus).l
