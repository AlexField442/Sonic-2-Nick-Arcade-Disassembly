; fill 68k RAM with 0
clearRAM:	macro startAddress,endAddress
	if narg=2
		.length\@: equ (\endAddress)-(\startAddress)
	else
		.length\@: equ \startAddress\_End-\startAddress
	endif
		lea	(\startAddress).w,a1
		moveq	#0,d0
		move.w	#.length\@/4-1,d1

.loop\@:
		move.l	d0,(a1)+
		dbf	d1,.loop\@

	if (\endAddress-\startAddress)&2
		move.w	d0,(a1)+
	endif

	if (\endAddress-\startAddress)&1
		move.b	d0,(a1)+
	endif
	endm

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