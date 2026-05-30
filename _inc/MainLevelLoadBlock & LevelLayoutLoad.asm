; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load blocks, chunks, PLCs, and tiles for the current zone
; ---------------------------------------------------------------------------

MainLevelLoadBlock:
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		lsl.w	#4,d0
		lea	(LevelArtPointers).l,a2
		lea	(a2,d0.w),a2
		move.l	a2,-(sp)
		addq.l	#4,a2
		movea.l	(a2)+,a0
		tst.b	(Current_Zone).w		; is this Green Hill Zone?
		beq.s	.uncompressedBlocks		; if yes... jump to where we were going anyways
		bra.s	.uncompressedBlocks
; ---------------------------------------------------------------------------
; Sonic 1 compresses its 16x16 blocks in Enigma; Sonic 2 Nick Arcade leaves
; them uncompressed, likely so that the developers wouldn't have to recompress
; them every time a change was made. Based on the above code, Green Hill had
; its blocks compressed in Enigma up to a certain point
; MainLevelLoadBlock_Skip16Convert:
.enigmaBlocks:
		lea	(Block_Table).w,a1
		move.w	#0,d0
		bsr.w	EniDec
		bra.s	loc_72C2
; ---------------------------------------------------------------------------
; MainLevelLoadBlock_Convert16:
.uncompressedBlocks:
		lea	(Block_Table).w,a1
		move.w	#(Block_Table_End-Block_Table)/2-1,d2
; MainLevelLoadBlock_ConvertLoop:
.uncompressedLoop:
		move.w	(a0)+,d0
		tst.w	(Two_player_mode).w
		beq.s	.notTwoPlayer
		move.w	d0,d1
		andi.w	#$F800,d0
		andi.w	#$7FF,d1
		lsr.w	#1,d1
		or.w	d1,d0
; MainLevelLoadBlock_Not2p:
.notTwoPlayer:
		move.w	d0,(a1)+
		dbf	d2,.uncompressedLoop

loc_72C2:
		cmpi.b	#5,(Current_Zone).w
		bne.s	.loadChunks
		lea	(Block_Table+$980).w,a1
		lea	(Map16_HTZ).l,a0
		move.w	#$3FF,d2
; loc_72D8:
.uncompressedLoop2:
		move.w	(a0)+,d0
		tst.w	(Two_player_mode).w
		beq.s	.notTwoPlayer2
		move.w	d0,d1
		andi.w	#$F800,d0
		andi.w	#$7FF,d1
		lsr.w	#1,d1
		or.w	d1,d0
; loc_72EE:
.notTwoPlayer2:
		move.w	d0,(a1)+
		dbf	d2,.uncompressedLoop2
; loc_72F4:
.loadChunks:
		movea.l	(a2)+,a0
		cmpi.b	#2,(Current_Zone).w
		beq.s	.uncompressedChunks
		cmpi.b	#3,(Current_Zone).w
		beq.s	.uncompressedChunks
		cmpi.b	#4,(Current_Zone).w
		beq.s	.uncompressedChunks
		cmpi.b	#5,(Current_Zone).w
		beq.s	.uncompressedChunks
		move.l	a2,-(sp)
		moveq	#0,d1
		moveq	#0,d2
		move.w	(a0)+,d0
		lea	(a0,d0.w),a1
		lea	(Chunk_Table).l,a2
		lea	(Level_Layout).w,a3
; loc_732C:
.chameleonChunks:
		bsr.w	ChaDec
		tst.w	d0
		bmi.s	.chameleonChunks
		movea.l	(sp)+,a2
		bra.s	.loadLevelAndPalette
; ---------------------------------------------------------------------------
; loc_7338:
.uncompressedChunks:
		lea	(Chunk_Table).l,a1
		move.w	#(Chunk_Table_End-Chunk_Table)/4-1,d0
; loc_7342:
.uncompressedLoop3:
		move.w	(a0)+,(a1)+
		dbf	d0,.uncompressedLoop3
; loc_7348:
.loadLevelAndPalette:
		bsr.w	LevelLayoutLoad
		move.w	(a2)+,d0
		move.w	(a2),d0
		andi.w	#$FF,d0
		cmpi.w	#$103,(Current_ZoneAndAct).w
		bne.s	.notLZ4
		moveq	#PalID_LZ4,d0
; loc_735E:
.notLZ4:
		cmpi.w	#$501,(Current_ZoneAndAct).w
		beq.s	.notSBZ2
		cmpi.w	#$502,(Current_ZoneAndAct).w
		bne.s	.loadPaletteAndPLC
; loc_736E:
.notSBZ2:
		moveq	#PalID_SBZ2,d0
; loc_7370:
.loadPaletteAndPLC:
		bsr.w	PalLoad1
		movea.l	(sp)+,a2
		addq.w	#4,a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	locret_7382
		bsr.w	LoadPLC

locret_7382:
		rts
; End of function MainLevelLoadBlock

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load a level layout from RAM
;
; Unlike Sonic 1, this is programmed to repeat level rows until it fills up
; all of $FF8000 to $FF9000, mainly used to repeat backgrounds without having
; it bloating the ROM (the final game doesn't do this)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


LevelLayoutLoad:
		lea	(Level_Layout).w,a3
		move.w	#(Level_Layout_End-Level_Layout)/4-1,d1
		moveq	#0,d0

loc_738E:
		move.l	d0,(a3)+
		dbf	d1,loc_738E		; fill $8000-$8FFF with 0

		; interlace the foreground and background data for every row
		lea	(Level_Layout).w,a3
		moveq	#0,d1
		bsr.w	LevelLayoutLoad2
		lea	(Level_Layout+levelrowsize).w,a3
		moveq	#2,d1

LevelLayoutLoad2:
		tst.b	(Current_Zone).w
		beq.s	LevelLayoutLoad_GHZ
		move.w	(Current_ZoneAndAct).w,d0
		lsl.b	#6,d0
		lsr.w	#5,d0
		move.w	d0,d2
		add.w	d0,d0
		add.w	d2,d0
		add.w	d1,d0
		lea	(Level_Index).l,a1
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1

		moveq	#0,d1
		move.w	d1,d2
		move.b	(a1)+,d1	; load level width (in tiles)
		move.b	(a1)+,d2	; load level height (in tiles)
		move.l	d1,d5
		addq.l	#1,d5
		moveq	#0,d3
		move.w	#levelrowsize,d3	; size of each row in memory (128 chunks)
		divu.w	d5,d3		; repeat each 'source row' until the 'destination row' is filled
		subq.w	#1,d3

loc_73DE:
		movea.l	a3,a0
		move.w	d3,d4

loc_73E2:
		move.l	a1,-(sp)
		move.w	d1,d0

loc_73E6:
		move.b	(a1)+,(a0)+
		dbf	d0,loc_73E6
		movea.l	(sp)+,a1
		dbf	d4,loc_73E2
		lea	(a1,d5.w),a1
		lea	levelrowsize*2(a3),a3
		dbf	d2,loc_73DE
		rts
; End of function LevelLayoutLoad

; ===========================================================================
; Dynamically converts the Sonic 1 level layout into Sonic 2 Nick Arcade's,
; read more about it here: https://forums.sonicretro.org/index.php?posts/993641/
LevelLayoutLoad_GHZ:
		move.w	(Current_ZoneAndAct).w,d0
		lsl.b	#6,d0
		lsr.w	#5,d0
		move.w	d0,d2
		add.w	d0,d0
		add.w	d2,d0
		add.w	d1,d0
		lea	(Level_Index).l,a1
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		moveq	#0,d1
		move.w	d1,d2
		move.b	(a1)+,d1	; load level width (in tiles)
		move.b	(a1)+,d2	; load level height (in tiles)

loc_7426:
		move.w	d1,d0
		movea.l	a3,a0

loc_742A:
		move.b	(a1)+,d3
		subq.b	#1,d3		; subtract 1 from chunk ID
		bcc.s	loc_7440	; if chunk is not $00, branch
		moveq	#0,d3		; set 'air' chunk to $00
		move.b	d3,(a0)+	; load first chunk
		move.b	d3,(a0)+	; load second chunk
		move.b	d3,$FE(a0)	; load third chunk
		move.b	d3,$FF(a0)	; load fourth chunk
		bra.s	loc_7456
; ===========================================================================

loc_7440:
		lsl.b	#2,d3
		addq.b	#1,d3		; add 1 to chunk ID
		move.b	d3,(a0)+	; load first chunk
		addq.b	#1,d3		; add 1 to chunk ID
		move.b	d3,(a0)+	; load second chunk
		addq.b	#1,d3		; add 1 to chunk ID
		move.b	d3,$FE(a0)	; load third chunk
		addq.b	#1,d3		; add 1 to chunk ID
		move.b	d3,$FF(a0)	; load fourth chunk

loc_7456:
		dbf	d0,loc_742A	; load 1 row
		lea	levelrowsize*4(a3),a3	; do next row
		dbf	d2,loc_7426	; repeat for number of rows
		rts
; End of function LevelLayoutLoad_GHZ

; ===========================================================================
; leftover level layout	converting function (from raw to the way it's stored in the game)
LevelLayout_Convert:
		lea	($FE0000).l,a1
		lea	($FE0080).l,a2
		lea	(Chunk_Table).l,a3
		move.w	#$3F,d1

loc_747A:
		bsr.w	sub_750C
		bsr.w	sub_750C
		dbf	d1,loc_747A
		lea	($FE0000).l,a1
		lea	(Chunk_Table&$FFFFFF).l,a2
		move.w	#$3F,d1

loc_7496:
		move.w	#0,(a2)+
		dbf	d1,loc_7496
		move.w	#$3FBF,d1

loc_74A2:
		move.w	(a1)+,(a2)+
		dbf	d1,loc_74A2
		rts
; ===========================================================================
		lea	($FE0000).l,a1
		lea	(Chunk_Table).l,a3
		moveq	#$1F,d0

loc_74B8:
		move.l	(a1)+,(a3)+
		dbf	d0,loc_74B8
		moveq	#0,d7
		lea	($FE0000).l,a1
		move.w	#$FF,d5

loc_74CA:
		lea	(Chunk_Table).l,a3
		move.w	d7,d6

loc_74D2:
		movem.l	a1-a3,-(sp)
		move.w	#$3F,d0

loc_74DA:
		cmpm.w	(a1)+,(a3)+
		bne.s	loc_74F0
		dbf	d0,loc_74DA
		movem.l	(sp)+,a1-a3
		adda.w	#$80,a1
		dbf	d5,loc_74CA
		bra.s	loc_750A
; ===========================================================================

loc_74F0:
		movem.l	(sp)+,a1-a3
		adda.w	#$80,a3
		dbf	d6,loc_74D2
		moveq	#$1F,d0

loc_74FE:
		move.l	(a1)+,(a3)+
		dbf	d0,loc_74FE
		addq.l	#1,d7
		dbf	d5,loc_74CA

loc_750A:
		bra.s	loc_750A

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_750C:
		moveq	#7,d0

loc_750E:
		move.l	(a3)+,(a1)+
		move.l	(a3)+,(a1)+
		move.l	(a3)+,(a1)+
		move.l	(a3)+,(a1)+
		move.l	(a3)+,(a2)+
		move.l	(a3)+,(a2)+
		move.l	(a3)+,(a2)+
		move.l	(a3)+,(a2)+
		dbf	d0,loc_750E
		adda.w	#$80,a1
		adda.w	#$80,a2
		rts
; End of function sub_750C