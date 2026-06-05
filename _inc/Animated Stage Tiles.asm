; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to animate stage art
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; DynamicArtCues:
AniArt_Load:
		;bsr.w	ShiftCPZBackground	; Was used in earlier builds before the developers
						; commented out this branch.
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		add.w	d0,d0
		add.w	d0,d0
		move.w	DynArtCue_Index+2(pc,d0.w),d1
		lea	DynArtCue_Index(pc,d1.w),a2
		move.w	DynArtCue_Index(pc,d0.w),d0
		jmp	DynArtCue_Index(pc,d0.w)
; ---------------------------------------------------------------------------
		rts
; End of function AniArt_Load

; ---------------------------------------------------------------------------
; ZONE ANIMATION PROCEDURES AND SCRIPTS
;
; Each zone gets two entries in this jump table. The first entry points to the
; zone's animation procedure (usually Dynamic_Null, AKA none). The second points
; to the zone's animation script.
;
; Seems like stage IDs were already being shifted, since listings for $07-$0F
; can be found, alongside HPZ's art listed from $08 (its ID in the final).
; ---------------------------------------------------------------------------
DynArtCue_Index:
		dc.w Dynamic_NullGHZ-DynArtCue_Index,AnimCue_EHZ-DynArtCue_Index
		dc.w Dynamic_Null-DynArtCue_Index,AnimCue_CPZ-DynArtCue_Index
		dc.w Dynamic_Null-DynArtCue_Index,AnimCue_CPZ-DynArtCue_Index
		dc.w Dynamic_Normal-DynArtCue_Index,AnimCue_EHZ-DynArtCue_Index
		dc.w Dynamic_Normal-DynArtCue_Index,AnimCue_HPZ-DynArtCue_Index
		dc.w Dynamic_Normal-DynArtCue_Index,AnimCue_EHZ-DynArtCue_Index
		dc.w Dynamic_Null-DynArtCue_Index,AnimCue_CPZ-DynArtCue_Index
		dc.w Dynamic_Null-DynArtCue_Index,AnimCue_CPZ-DynArtCue_Index
		dc.w Dynamic_Normal-DynArtCue_Index,AnimCue_HPZ-DynArtCue_Index
		dc.w Dynamic_Null-DynArtCue_Index,AnimCue_CPZ-DynArtCue_Index
		dc.w Dynamic_Null-DynArtCue_Index,AnimCue_CPZ-DynArtCue_Index
		dc.w Dynamic_Null-DynArtCue_Index,AnimCue_CPZ-DynArtCue_Index
		dc.w Dynamic_Null-DynArtCue_Index,AnimCue_CPZ-DynArtCue_Index
		dc.w Dynamic_Null-DynArtCue_Index,AnimCue_CPZ-DynArtCue_Index
		dc.w Dynamic_Null-DynArtCue_Index,AnimCue_CPZ-DynArtCue_Index
		dc.w Dynamic_Null-DynArtCue_Index,AnimCue_CPZ-DynArtCue_Index
; ===========================================================================

Dynamic_Null:
		rts
; ===========================================================================

Dynamic_NullGHZ:
		rts
; ===========================================================================

Dynamic_Normal:
		lea	(Anim_Counters).w,a3
		move.w	(a2)+,d6	; Get number of scripts in list

loc_1AACA:
		subq.b	#1,(a3)		; Tick down frame duration
		bpl.s	loc_1AB10	; If frame isn't over, move on to next script

		moveq	#0,d0
		move.b	1(a3),d0	; Get current frame
		cmp.b	6(a2),d0	; Have we processed the last frame in the script?
		bcs.s	loc_1AAE0
		moveq	#0,d0		; If so, reset to first frame
		move.b	d0,1(a3)

loc_1AAE0:
		addq.b	#1,1(a3)	; Consider this frame processed; set counter to next frame
		move.b	(a2),(a3)	; Set frame duration to global duration value
		bpl.s	loc_1AAEE
		; If script uses per-frame durations, use those instead
		add.w	d0,d0
		move.b	9(a2,d0.w),(a3)	; Set frame duration to current frame's duration value

loc_1AAEE:
		; Prepare for DMA transfer
		; Get relative address of frame's art
		move.b	8(a2,d0.w),d0	; Get tile ID
		lsl.w	#5,d0		; Turn it into an offset
		; Get VRAM destination address
		move.w	4(a2),d2
		; Get ROM source address
		move.l	(a2),d1		; Get start address of animated tile art
		andi.l	#$FFFFFF,d1
		add.l	d0,d1		; Offset into art, to get the address of new frame
		; Get size of art to be transferred
		moveq	#0,d3
		move.b	7(a2),d3
		lsl.w	#4,d3		; Turn it into actual size (in words)
		; Use d1, d2 and d3 to queue art for transfer
		jsr	(QueueDMATransfer).l

loc_1AB10:
		move.b	6(a2),d0	; Get total size of frame data
		tst.b	(a2)		; Is per-frame duration data present?
		bpl.s	loc_1AB1A	; If not, keep the current size; it's correct
		add.b	d0,d0		; Double size to account for the additional frame duration data

loc_1AB1A:
		addq.b	#1,d0
		andi.w	#$FE,d0		; Round to next even address, if it isn't already
		lea	8(a2,d0.w),a2	; Advance to next script in list
		addq.w	#2,a3		; Advance to next script's slot in a3 (usually Anim_Counters)
		dbf	d6,loc_1AACA
		rts
; ===========================================================================
AnimCue_EHZ:	dc.w 4
		dc.l Art_EHZFlower1+$FF000000
		dc.w $7280
		dc.b 6
		dc.b 2
		dc.b   0,$7F		; 0
		dc.b   2,$13		; 2
		dc.b   0,  7		; 4
		dc.b   2,  7		; 6
		dc.b   0,  7		; 8
		dc.b   2,  7		; 10
		dc.l Art_EHZFlower2+$FF000000
		dc.w $72C0
		dc.b 8
		dc.b 2
		dc.b   2,$7F		; 0
		dc.b   0, $B		; 2
		dc.b   2, $B		; 4
		dc.b   0, $B		; 6
		dc.b   2,  5		; 8
		dc.b   0,  5		; 10
		dc.b   2,  5		; 12
		dc.b   0,  5		; 14
		dc.l Art_EHZFlower3+$7000000
		dc.w $7300
		dc.b 2
		dc.b 2
		dc.b   0,  2		; 0
		dc.l Art_EHZFlower4+$FF000000
		dc.w $7340
		dc.b 8
		dc.b 2
		dc.b   0,$7F		; 0
		dc.b   2,  7		; 2
		dc.b   0,  7		; 4
		dc.b   2,  7		; 6
		dc.b   0,  7		; 8
		dc.b   2, $B		; 10
		dc.b   0, $B		; 12
		dc.b   2, $B		; 14
		dc.l Art_EHZFlower5+$1000000
		dc.w $7380
		dc.b 6
		dc.b 2
		dc.b   0,  2		; 0
		dc.b   4,  6		; 2
		dc.b   4,  2		; 4

AnimCue_HPZ:	dc.w 2
		dc.l Art_HPZGlowingBall+$8000000
		dc.w $5D00
		dc.b 6
		dc.b 8
		dc.b   0,  0		; 0
		dc.b   8,$10		; 2
		dc.b $10,  8		; 4
		dc.l Art_HPZGlowingBall+$8000000
		dc.w $5E00
		dc.b 6
		dc.b 8
		dc.b   8,$10		; 0
		dc.b $10,  8		; 2
		dc.b   0,  0		; 4
		dc.l Art_HPZGlowingBall+$8000000
		dc.w $5F00
		dc.b 6
		dc.b 8
		dc.b $10,  8		; 0
		dc.b   0,  0		; 2
		dc.b   8,$10		; 4

; According to leftover resizing code, this was meant for the
; Chemical Plant Zone boss, which symbol tables refer to as "vaccume".
AnimCue_CPZ:	dc.w 7
		dc.l Art_UnkZone_1+$7000000
		dc.w $9000
		dc.b 2
		dc.b 4
		dc.b   0,  4		; 0
		dc.l Art_UnkZone_2+$7000000
		dc.w $9080
		dc.b 3
		dc.b 8
		dc.b   0,  8		; 0
		dc.b $10,  0		; 2
		dc.l Art_UnkZone_3+$7000000
		dc.w $9180
		dc.b 4
		dc.b 2
		dc.b   0,  2		; 0
		dc.b   0,  4		; 2
		dc.l Art_UnkZone_4+$B000000
		dc.w $91C0
		dc.b 4
		dc.b 2
		dc.b   0,  2		; 0
		dc.b   4,  2		; 2
		dc.l Art_UnkZone_5+$F000000
		dc.w $9200
		dc.b $A
		dc.b 1
		dc.b   0		; 0
		dc.b   0		; 1
		dc.b   1		; 2
		dc.b   2		; 3
		dc.b   3		; 4
		dc.b   4		; 5
		dc.b   5		; 6
		dc.b   4		; 7
		dc.b   5		; 8
		dc.b   4		; 9
		dc.l Art_UnkZone_6+$3000000
		dc.w $9220
		dc.b 4
		dc.b 4
		dc.b   0,  4		; 0
		dc.b   8,  4		; 2
		dc.l Art_UnkZone_7+$7000000
		dc.w $92A0
		dc.b 6
		dc.b 3
		dc.b   0,  3		; 0
		dc.b   6,  9		; 2
		dc.b  $C, $F		; 4
		dc.l Art_UnkZone_8+$7000000
		dc.w $9300
		dc.b 4
		dc.b 1
		dc.b   0		; 0
		dc.b   1		; 1
		dc.b   2		; 2
		dc.b   3		; 3

; ===========================================================================
; ---------------------------------------------------------------------------
; An unused routine for Chemical Plant that shifts the select chunk blocks to
; the left between camera X position $1940 and $1F80; this was meant to be
; loaded from AniArt_Load, but is already dummied out in this build. It was
; presumably some abandoned background effect
;
; Referred to internally as "efectmove", efect was seemingly the internal
; name for animated stage artwork
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_1AC1E:
ShiftCPZBackground:
		cmpi.b	#2,(Current_Zone).w	; is this Chemical Plant Zone?
		beq.s	.isCPZ			; if yes, branch
; locret_1AC26:
.endEffect:
		rts
; ===========================================================================
; This shifts all blocks of the chunks $EA-$ED and $FA-$FD one block to the
; left and the last block in each row (chunk $ED/$FD) to the beginning
; i.e. rotates the blocks to the left by one
;
; Thing is, said chunks are completely blank, meaning this effectively goes
; unseen even if it WAS used. Apparently Chemical Plant's chunks had a very
; different arrangement earlier in development
; loc_1AC28:
.isCPZ:
		move.w	(Camera_X_pos).w,d0
		cmpi.w	#$1940,d0
		bcs.s	.endEffect
		cmpi.w	#$1F80,d0
		bcc.s	.endEffect
		subq.b	#1,(CPZ_UnkScroll_Timer).w
		bpl.s	.endEffect
		move.b	#7,(CPZ_UnkScroll_Timer).w
		move.b	#1,(Screen_redraw_flag).w
		lea	(Chunk_Table+($EA*$80)).l,a1
		bsr.s	sub_1AC58
		lea	(Chunk_Table+($FA*$80)).l,a1

sub_1AC58:
		move.w	#8-1,d1

loc_1AC5C:
		move.w	(a1),d0
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	$72(a1),(a1)+
		adda.w	#$70,a1
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	$72(a1),(a1)+
		adda.w	#$70,a1
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	$72(a1),(a1)+
		adda.w	#$70,a1
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	2(a1),(a1)+
		move.w	d0,(a1)+
		suba.w	#$180,a1
		dbf	d1,loc_1AC5C
		rts
; End of function ShiftCPZBackground

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load animated blocks
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; LoadMap16Delta:
LoadAnimatedBlocks:
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		add.w	d0,d0
		move.w	AnimPatMaps(pc,d0.w),d0
		lea	AnimPatMaps(pc,d0.w),a0
		tst.w	(a0)
		beq.s	locret_1AD1A
		lea	(Block_Table).w,a1
		adda.w	(a0)+,a1
		move.w	(a0)+,d1
		tst.w	(Two_player_mode).w
		bne.s	LoadLevelBlocks_2P
; loc_1AD14:
LoadLevelBlocks:
		move.w	(a0)+,(a1)+
		dbf	d1,LoadLevelBlocks

locret_1AD1A:
		rts
; ---------------------------------------------------------------------------
; loc_1AD1C:
LoadLevelBlocks_2P:
		move.w	(a0)+,d0
		move.w	d0,d1
		andi.w	#$F800,d0
		andi.w	#$7FF,d1
		lsr.w	#1,d1
		or.w	d1,d0
		move.w	d0,(a1)+
		dbf	d1,LoadLevelBlocks_2P
		rts
; End of function LoadAnimatedBlocks

; ===========================================================================
; like with the animated stage art, this already lists stages up to $0F and
; includes an entry for the final HPZ level slot, and this time even lists
; CPZ's final level slot
; Map16Delta_Index:
AnimPatMaps:
		dc.w APM_GHZ-AnimPatMaps
		dc.w APM_LZ-AnimPatMaps
		dc.w APM_CPZ-AnimPatMaps
		dc.w APM_GHZ-AnimPatMaps
		dc.w APM_HPZ-AnimPatMaps
		dc.w APM_GHZ-AnimPatMaps
		dc.w APM_LZ-AnimPatMaps
		dc.w APM_LZ-AnimPatMaps
		dc.w APM_HPZ-AnimPatMaps
		dc.w APM_LZ-AnimPatMaps
		dc.w APM_LZ-AnimPatMaps
		dc.w APM_LZ-AnimPatMaps
		dc.w APM_LZ-AnimPatMaps
		dc.w APM_CPZ-AnimPatMaps
		dc.w APM_LZ-AnimPatMaps
		dc.w APM_LZ-AnimPatMaps

APM_GHZ:	dc.w $1788,  $3B,$4502,$4504,$4503,$4505,$4506,$4508,$4507,$4509,$450A,$450C,$450B,$450D,$450E,$4510
		dc.w $450F,$4511,$4512,$4514,$4513,$4515,$4516,$4518,$4517,$4519,$651A,$651C,$651B,$651D,$651E,$6520
		dc.w $651F,$6521,$439C,$4B9C,$439D,$4B9D,$4158,$439C,$4159,$439D,$4B9C,$4958,$4B9D,$4959,$6394,$6B94
		dc.w $6395,$6B95,$E396,$EB96,$E397,$EB97,$6398,$6B98,$6399,$6B99,$E39A,$EB9A,$E39B,$EB9B

APM_LZ:		dc.w	 0, $C80,  $9B,$43A1,$43A2,$43A3,$43A4,$43A5,$43A6,$43A7,$43A8,$43A9,$43AA,$43AB,$43AC,$43AD
		dc.w $43AE,$43AF,$43B0,$43B1,$43B2,$43B3,$43B4,$43B5,$43B6,$43B7,$43B8,$43B9,$43BA,$43BB,$43BC,$43BD
		dc.w $43BE,$43BF,$43C0,$43C1,$43C2,$43C3,$43C4,$63A0,$63A0,$63A0,$63A0,$63A0,$63A0,$63A0,$63A0,	   0
		dc.w	 0,$6340,$6344,	   0,	 0,$6348,$634C,$6341,$6345,$6342,$6346,$6349,$634D,$634A,$634E,$6343
		dc.w $6347,$4358,$4359,$634B,$634F,$435A,$435B,$6380,$6384,$6381,$6385,$6388,$638C,$6389,$638D,$6382
		dc.w $6386,$6383,$6387,$638A,$638E,$638B,$638F,$6390,$6394,$6391,$6395,$6398,$639C,$6399,$639D,$6392
		dc.w $6396,$6393,$6397,$639A,$639E,$639B,$639F,$4378,$4379,$437A,$437B,$437C,$437D,$437E,$437F,$235C
		dc.w $235D,$235E,$235F,$2360,$2361,$2362,$2363,$2364,$2365,$2366,$2367,$2368,$2369,$236A,$236B,	   0
		dc.w	 0,$636C,$636D,	   0,	 0,$636E,    0,$636F,$6370,$6371,$6372,$6373,	 0,$6374,    0,$6375
		dc.w $6376,$4358,$4359,$6377,	 0,$435A,$435B,$C378,$C379,$C37A,$C37B,$C37C,$C37D,$C37E,$C37F

APM_CPZ:	dc.w $17E0,   $F,$43D1,$43D1,$43D1,$43D1,$43D2,$43D2,$43D3,$43D3,$43D4,$43D4,$43D5,$43D5,$43D6,$43D6
		dc.w $43D7,$43D7

APM_HPZ:	dc.w $1710,  $77,$62E8,$62E9,$62EA,$62EB,$62EC,$62ED,$62EE,$62EF,$62F0,$62F1,$62F2,$62F3,$62F4,$62F5
		dc.w $62F6,$62F7,$62F8,$62F9,$62FA,$62FB,$62FC,$62FD,$62FE,$62FF,$42E8,$42E9,$42EA,$42EB,$42EC,$42ED
		dc.w $42EE,$42EF,$42F0,$42F1,$42F2,$42F3,$42F4,$42F5,$42F6,$42F7,$42F8,$42F9,$42FA,$42FB,$42FC,$42FD
		dc.w $42FE,$42FF,    0,$62E8,	 0,$62EA,$62E9,$62EC,$62EB,$62EE,$62ED,	   0,$62EF,    0,    0,$62F0
		dc.w	 0,$62F2,$62F1,$62F4,$62F3,$62F6,$62F5,	   0,$62F7,    0,    0,$62F8,	 0,$62FA,$62F9,$62FC
		dc.w $62FB,$62FE,$62FD,	   0,$62FF,    0,    0,$42E8,	 0,$42EA,$42E9,$42EC,$42EB,$42EE,$42ED,	   0
		dc.w $42EF,    0,    0,$42F0,	 0,$42F2,$42F1,$42F4,$42F3,$42F6,$42F5,	   0,$42F7,    0,    0,$42F8
		dc.w	 0,$42FA,$42F9,$42FC,$42FB,$42FE,$42FD,	   0,$42FF,    0
		nop