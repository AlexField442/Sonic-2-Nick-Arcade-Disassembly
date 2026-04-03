; tells the Z80 to stop, and waits for it to finish stopping (acquire bus)
stopZ80 macro
	move.w	#$100,(Z80_Bus_Request).l
.loop:	btst	#0,(Z80_Bus_Request).l
	bne.s	.loop
	endm

; tells the Z80 to start again
startZ80 macro
	move.w	#0,(Z80_Bus_Request).l
	endm