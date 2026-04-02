; ===========================================================================
; Sonic 1's sprite engine has the unique ability to use other camera coordinates
; to figure out where sprites should be; sadly, Sonic 2 Final removed this
; dword_CFFC:
BldSpr_ScrPos:	dc.l 0
		dc.l Camera_X_pos
		dc.l Camera_BG_X_pos
		dc.l Camera_BG3_X_pos

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to display sprites on the Genesis
; ("sprites" as in individual mapping pieces, NOT actors/objects)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_D00C:
BuildSprites:
		tst.w	(Two_player_mode).w
		bne.w	BuildSprites_2p
		lea	(Sprite_Table).w,a2
		moveq	#0,d5
		moveq	#0,d4
		tst.b	(Level_started_flag).w
		beq.s	loc_D026
		bsr.w	BuildRings

loc_D026:
		lea	(Sprite_Input_Table).w,a4
		moveq	#7,d7

loc_D02C:
		tst.w	(a4)
		beq.w	loc_D102
		moveq	#2,d6

loc_D034:
		movea.w	(a4,d6.w),a0

		; These are sanity checks that stop objects with invalid IDs or
		; mappings from loading; September 14th to REV00 used the branch
		; for debugging purposes.
		tst.b	(a0)
		beq.w	loc_D124
		tst.l	mappings(a0)
		beq.w	loc_D124

		andi.b	#$7F,render_flags(a0)
		move.b	render_flags(a0),d0
		move.b	d0,d4
		btst	#6,d0
		bne.w	loc_D126
		andi.w	#$C,d0
		beq.s	loc_D0B2
		movea.l	BldSpr_ScrPos(pc,d0.w),a1
		moveq	#0,d0
		move.b	width_pixels(a0),d0
		move.w	x_pos(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_D0FA
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#$140,d1
		bge.w	loc_D0FA
		addi.w	#$80,d3	; '€'
		btst	#4,d4
		beq.s	loc_D0BC
		moveq	#0,d0
		move.b	y_radius(a0),d0
		move.w	y_pos(a0),d2
		sub.w	4(a1),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.s	loc_D0FA
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#$E0,d1	; 'à'
		bge.s	loc_D0FA
		addi.w	#$80,d2	; '€'
		bra.s	loc_D0D4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D0B2:				; CODE XREF: BuildSprites+52j
		move.w	y_pixel(a0),d2
		move.w	x_pixel(a0),d3
		bra.s	loc_D0D4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D0BC:				; CODE XREF: BuildSprites+80j
		move.w	y_pos(a0),d2
		sub.w	4(a1),d2
		addi.w	#$80,d2	; '€'
		cmpi.w	#$60,d2	; '`'
		bcs.s	loc_D0FA
		cmpi.w	#$180,d2
		bcc.s	loc_D0FA

loc_D0D4:				; CODE XREF: BuildSprites+A4j
					; BuildSprites+AEj
		movea.l	mappings(a0),a1
		moveq	#0,d1
		btst	#5,d4
		bne.s	loc_D0F0
		move.b	mapping_frame(a0),d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	loc_D0F4

loc_D0F0:				; CODE XREF: BuildSprites+D2j
		bsr.w	sub_D1B6

loc_D0F4:				; CODE XREF: BuildSprites+E2j
		ori.b	#$80,render_flags(a0)

loc_D0FA:				; CODE XREF: BuildSprites+68j
					; BuildSprites+74j ...
		addq.w	#2,d6
		subq.w	#2,(a4)
		bne.w	loc_D034

loc_D102:				; CODE XREF: BuildSprites+22j
		lea	$80(a4),a4
		dbf	d7,loc_D02C
		move.b	d5,(Sprite_count).w
		cmpi.b	#$50,d5	; 'P'
		beq.s	loc_D11C
		move.l	#0,(a2)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D11C:				; CODE XREF: BuildSprites+106j
		move.b	#0,-5(a2)
		rts
; ===========================================================================
; From September 14th to REV00, a debug command was added here that would
; deliberately crash the game if an object was loaded with an invalid ID
; or mappings pointer, likely to detect a bug where a sprite could delete
; itself on the same frame it queued itself for display.
;
; This bug was present for many objects in Sonic 1, but miraculously didn't
; cause any issues there as mappings are loaded using bytes. However, as
; Sonic 2 uses word-sized pointers for mappings instead, it causes the game
; to read from an odd address, causing a crash.
;
; REV01 removed this and this branch as a whole, only keeping the ID check
; in place. Despite their efforts, however, the ascending/descending metal
; platforms from Wing Fortress still have this bug, as does the Chemical Plant
; boss... well, they tried.
loc_D124:
		bra.s	loc_D0FA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D126:				; CODE XREF: BuildSprites+4Aj
		move.l	a4,-(sp)
		lea	(Camera_X_pos).w,a4
		movea.w	art_tile(a0),a3
		movea.l	mappings(a0),a5
		moveq	#0,d0
		move.b	$E(a0),d0
		move.w	x_pos(a0),d3
		sub.w	(a4),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_D1B0
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#$140,d1
		bge.s	loc_D1B0
		move.w	y_pos(a0),d2
		sub.w	4(a4),d2
		addi.w	#$80,d2	; '€'
		cmpi.w	#$60,d2	; '`'
		bcs.s	loc_D1B0
		cmpi.w	#$180,d2
		bcc.s	loc_D1B0
		ori.b	#$80,render_flags(a0)
		lea	$10(a0),a6
		moveq	#0,d0
		move.b	$F(a0),d0
		subq.w	#1,d0
		bcs.s	loc_D1B0

loc_D17E:				; CODE XREF: BuildSprites+1A0j
		swap	d0
		move.w	(a6)+,d3
		sub.w	(a4),d3
		addi.w	#$80,d3	; '€'
		move.w	(a6)+,d2
		sub.w	4(a4),d2
		addi.w	#$80,d2	; '€'
		addq.w	#1,a6
		moveq	#0,d1
		move.b	(a6)+,d1
		add.w	d1,d1
		movea.l	a5,a1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	loc_D1AA
		bsr.w	sub_D1BA

loc_D1AA:				; CODE XREF: BuildSprites+198j
		swap	d0
		dbf	d0,loc_D17E

loc_D1B0:				; CODE XREF: BuildSprites+138j
					; BuildSprites+144j ...
		movea.l	(sp)+,a4
		bra.w	loc_D0FA
; End of function BuildSprites


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_D1B6:				; CODE XREF: BuildSprites:loc_D0F0p
		movea.w	art_tile(a0),a3
; End of function sub_D1B6


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_D1BA:				; CODE XREF: BuildSprites+19Ap
		cmpi.b	#$50,d5	; 'P'
		bcc.s	locret_D1F6
		btst	#0,d4
		bne.s	loc_D1F8
		btst	#1,d4
		bne.w	loc_D258

loc_D1CE:				; CODE XREF: sub_D1BA+38j
					; S1SS_ShowLayout+114p
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.w	(a1)+,d0
		add.w	a3,d0
		move.w	d0,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D1F0
		addq.w	#1,d0

loc_D1F0:				; CODE XREF: sub_D1BA+32j
		move.w	d0,(a2)+
		dbf	d1,loc_D1CE

locret_D1F6:				; CODE XREF: sub_D1BA+4j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D1F8:				; CODE XREF: sub_D1BA+Aj
		btst	#1,d4
		bne.w	loc_D2A0

loc_D200:				; CODE XREF: sub_D1BA+78j
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	d4,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.w	(a1)+,d0
		add.w	a3,d0
		eori.w	#$800,d0
		move.w	d0,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		neg.w	d0
		move.b	byte_D238(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D230
		addq.w	#1,d0

loc_D230:				; CODE XREF: sub_D1BA+72j
		move.w	d0,(a2)+
		dbf	d1,loc_D200
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_D238:	dc.b   8,  8,  8,  8	; 0
		dc.b $10,$10,$10,$10	; 4
		dc.b $18,$18,$18,$18	; 8
		dc.b $20,$20,$20,$20	; 12
byte_D248:	dc.b   8,$10,$18,$20	; 0
		dc.b   8,$10,$18,$20	; 4
		dc.b   8,$10,$18,$20	; 8
		dc.b   8,$10,$18,$20	; 12
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D258:				; CODE XREF: sub_D1BA+10j sub_D1BA+D0j
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		move.b	byte_D248(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.w	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1000,d0
		move.w	d0,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D288
		addq.w	#1,d0

loc_D288:				; CODE XREF: sub_D1BA+CAj
		move.w	d0,(a2)+
		dbf	d1,loc_D258
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_D290:	dc.b   8,$10,$18,$20	; 0
		dc.b   8,$10,$18,$20	; 4
		dc.b   8,$10,$18,$20	; 8
		dc.b   8,$10,$18,$20	; 12
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D2A0:				; CODE XREF: sub_D1BA+42j
					; sub_D1BA+122j
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		move.b	byte_D290(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	d4,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.w	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1800,d0
		move.w	d0,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		neg.w	d0
		move.b	byte_D2E2(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D2DA
		addq.w	#1,d0

loc_D2DA:				; CODE XREF: sub_D1BA+11Cj
		move.w	d0,(a2)+
		dbf	d1,loc_D2A0
		rts
; End of function sub_D1BA

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_D2E2:	dc.b   8,  8,  8,  8	; 0
		dc.b $10,$10,$10,$10	; 4
		dc.b $18,$18,$18,$18	; 8
		dc.b $20,$20,$20,$20	; 12
BldSpr_ScrPos_2p:dc.l 0
		dc.l Camera_X_pos
		dc.l Camera_BG_X_pos
		dc.l Camera_BG3_X_pos
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; START	OF FUNCTION CHUNK FOR BuildSprites

BuildSprites_2p:			; CODE XREF: BuildSprites+4j
					; BuildSprites+2FAj
		tst.w	(Hint_flag).w
		bne.s	BuildSprites_2p
		lea	(Sprite_Table).w,a2
		moveq	#2,d5
		moveq	#0,d4
		move.l	#$1D80F01,(a2)+
		move.l	#1,(a2)+
		move.l	#$1D80F02,(a2)+
		move.l	#0,(a2)+
		tst.b	(Level_started_flag).w
		beq.s	loc_D332
		bsr.w	BuildSprites2_2p

loc_D332:				; CODE XREF: BuildSprites+320j
		lea	(Sprite_Input_Table).w,a4
		moveq	#7,d7

loc_D338:				; CODE XREF: BuildSprites+408j
		move.w	(a4),d0
		beq.w	loc_D410
		move.w	d0,-(sp)
		moveq	#2,d6

loc_D342:				; CODE XREF: BuildSprites+3FEj
		movea.w	(a4,d6.w),a0
		tst.b	(a0)
		beq.w	loc_D406
		andi.b	#$7F,render_flags(a0) ; ''
		move.b	render_flags(a0),d0
		move.b	d0,d4
		btst	#6,d0
		bne.w	loc_D54A
		andi.w	#$C,d0
		beq.s	loc_D3B6
		movea.l	BldSpr_ScrPos_2p(pc,d0.w),a1
		moveq	#0,d0
		move.b	width_pixels(a0),d0
		move.w	x_pos(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_D406
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#$140,d1
		bge.s	loc_D406
		addi.w	#$80,d3	; '€'
		btst	#4,d4
		beq.s	loc_D3C4
		moveq	#0,d0
		move.b	y_radius(a0),d0
		move.w	y_pos(a0),d2
		sub.w	4(a1),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.s	loc_D406
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#$E0,d1	; 'à'
		bge.s	loc_D406
		addi.w	#$100,d2
		bra.s	loc_D3E0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D3B6:				; CODE XREF: BuildSprites+358j
		move.w	y_pixel(a0),d2
		move.w	x_pixel(a0),d3
		addi.w	#$80,d2	; '€'
		bra.s	loc_D3E0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D3C4:				; CODE XREF: BuildSprites+384j
		move.w	y_pos(a0),d2
		sub.w	4(a1),d2
		addi.w	#$80,d2	; '€'
		cmpi.w	#$60,d2	; '`'
		bcs.s	loc_D406
		cmpi.w	#$180,d2
		bcc.s	loc_D406
		addi.w	#$80,d2	; '€'

loc_D3E0:				; CODE XREF: BuildSprites+3A8j
					; BuildSprites+3B6j
		movea.l	mappings(a0),a1
		moveq	#0,d1
		btst	#5,d4
		bne.s	loc_D3FC
		move.b	mapping_frame(a0),d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	loc_D400

loc_D3FC:				; CODE XREF: BuildSprites+3DEj
		bsr.w	sub_D6A2

loc_D400:				; CODE XREF: BuildSprites+3EEj
		ori.b	#$80,render_flags(a0)

loc_D406:				; CODE XREF: BuildSprites+33Cj
					; BuildSprites+36Ej ...
		addq.w	#2,d6
		subq.w	#2,(sp)
		bne.w	loc_D342
		addq.w	#2,sp

loc_D410:				; CODE XREF: BuildSprites+32Ej
		lea	$80(a4),a4
		dbf	d7,loc_D338
		move.b	d5,(Sprite_count).w
		cmpi.b	#$50,d5	; 'P'
		bcc.s	loc_D42A
		move.l	#0,(a2)
		bra.s	loc_D442
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D42A:				; CODE XREF: BuildSprites+414j
		move.b	#0,-5(a2)
		bra.s	loc_D442
; END OF FUNCTION CHUNK	FOR BuildSprites
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dword_D432:	dc.l 0
		dc.l Camera_X_pos_P2
		dc.l Camera_BG_X_pos_P2
		dc.l Camera_BG3_X_pos_P2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; START	OF FUNCTION CHUNK FOR BuildSprites

loc_D442:				; CODE XREF: BuildSprites+41Cj
					; BuildSprites+424j
		lea	(Sprite_Table_P2).w,a2
		moveq	#0,d5
		moveq	#0,d4
		tst.b	(Level_started_flag).w
		beq.s	loc_D454
		bsr.w	sub_DACA

loc_D454:				; CODE XREF: BuildSprites+442j
		lea	(Sprite_Input_Table).w,a4
		moveq	#7,d7

loc_D45A:				; CODE XREF: BuildSprites+520j
		tst.w	(a4)
		beq.w	loc_D528
		moveq	#2,d6

loc_D462:				; CODE XREF: BuildSprites+518j
		movea.w	(a4,d6.w),a0
		tst.b	(a0)
		beq.w	loc_D520
		move.b	render_flags(a0),d0
		move.b	d0,d4
		btst	#6,d0
		bne.w	loc_D5DA
		andi.w	#$C,d0
		beq.s	loc_D4D0
		movea.l	dword_D432(pc,d0.w),a1
		moveq	#0,d0
		move.b	width_pixels(a0),d0
		move.w	x_pos(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_D520
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#$140,d1
		bge.s	loc_D520
		addi.w	#$80,d3	; '€'
		btst	#4,d4
		beq.s	loc_D4DE
		moveq	#0,d0
		move.b	y_radius(a0),d0
		move.w	y_pos(a0),d2
		sub.w	4(a1),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.s	loc_D520
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#$E0,d1	; 'à'
		bge.s	loc_D520
		addi.w	#$1E0,d2
		bra.s	loc_D4FA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D4D0:				; CODE XREF: BuildSprites+472j
		move.w	y_pixel(a0),d2
		move.w	x_pixel(a0),d3
		addi.w	#$160,d2
		bra.s	loc_D4FA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D4DE:				; CODE XREF: BuildSprites+49Ej
		move.w	y_pos(a0),d2
		sub.w	4(a1),d2
		addi.w	#$80,d2	; '€'
		cmpi.w	#$60,d2	; '`'
		bcs.s	loc_D520
		cmpi.w	#$180,d2
		bcc.s	loc_D520
		addi.w	#$160,d2

loc_D4FA:				; CODE XREF: BuildSprites+4C2j
					; BuildSprites+4D0j
		movea.l	mappings(a0),a1
		moveq	#0,d1
		btst	#5,d4
		bne.s	loc_D516
		move.b	mapping_frame(a0),d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	loc_D51A

loc_D516:				; CODE XREF: BuildSprites+4F8j
		bsr.w	sub_D6A2

loc_D51A:				; CODE XREF: BuildSprites+508j
		ori.b	#$80,render_flags(a0)

loc_D520:				; CODE XREF: BuildSprites+45Cj
					; BuildSprites+488j ...
		addq.w	#2,d6
		subq.w	#2,(a4)
		bne.w	loc_D462

loc_D528:				; CODE XREF: BuildSprites+450j
		lea	$80(a4),a4
		dbf	d7,loc_D45A
		move.b	d5,(Sprite_count).w
		cmpi.b	#$50,d5	; 'P'
		beq.s	loc_D542
		move.l	#0,(a2)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D542:				; CODE XREF: BuildSprites+52Cj
		move.b	#0,-5(a2)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D54A:				; CODE XREF: BuildSprites+350j
		move.l	a4,-(sp)
		lea	(Camera_X_pos).w,a4
		movea.w	art_tile(a0),a3
		movea.l	mappings(a0),a5
		moveq	#0,d0
		move.b	$E(a0),d0
		move.w	x_pos(a0),d3
		sub.w	(a4),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_D5D4
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#$140,d1
		bge.s	loc_D5D4
		move.w	y_pos(a0),d2
		sub.w	4(a4),d2
		addi.w	#$80,d2	; '€'
		cmpi.w	#$60,d2	; '`'
		bcs.s	loc_D5D4
		cmpi.w	#$180,d2
		bcc.s	loc_D5D4
		ori.b	#$80,render_flags(a0)
		lea	$10(a0),a6
		moveq	#0,d0
		move.b	$F(a0),d0
		subq.w	#1,d0
		bcs.s	loc_D5D4

loc_D5A2:				; CODE XREF: BuildSprites+5C4j
		swap	d0
		move.w	(a6)+,d3
		sub.w	(a4),d3
		addi.w	#$80,d3	; '€'
		move.w	(a6)+,d2
		sub.w	4(a4),d2
		addi.w	#$100,d2
		addq.w	#1,a6
		moveq	#0,d1
		move.b	(a6)+,d1
		add.w	d1,d1
		movea.l	a5,a1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	loc_D5CE
		bsr.w	sub_D6A6

loc_D5CE:				; CODE XREF: BuildSprites+5BCj
		swap	d0
		dbf	d0,loc_D5A2

loc_D5D4:				; CODE XREF: BuildSprites+55Cj
					; BuildSprites+568j ...
		movea.l	(sp)+,a4
		bra.w	loc_D406
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D5DA:				; CODE XREF: BuildSprites+46Aj
		move.l	a4,-(sp)
		lea	(Camera_X_pos_P2).w,a4
		movea.w	art_tile(a0),a3
		movea.l	mappings(a0),a5
		moveq	#0,d0
		move.b	$E(a0),d0
		move.w	x_pos(a0),d3
		sub.w	(a4),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_D664
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#$140,d1
		bge.s	loc_D664
		move.w	y_pos(a0),d2
		sub.w	4(a4),d2
		addi.w	#$80,d2	; '€'
		cmpi.w	#$60,d2	; '`'
		bcs.s	loc_D664
		cmpi.w	#$180,d2
		bcc.s	loc_D664
		ori.b	#$80,render_flags(a0)
		lea	$10(a0),a6
		moveq	#0,d0
		move.b	$F(a0),d0
		subq.w	#1,d0
		bcs.s	loc_D664

loc_D632:				; CODE XREF: BuildSprites+654j
		swap	d0
		move.w	(a6)+,d3
		sub.w	(a4),d3
		addi.w	#$80,d3	; '€'
		move.w	(a6)+,d2
		sub.w	4(a4),d2
		addi.w	#$1E0,d2
		addq.w	#1,a6
		moveq	#0,d1
		move.b	(a6)+,d1
		add.w	d1,d1
		movea.l	a5,a1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	loc_D65E
		bsr.w	sub_D6A6

loc_D65E:				; CODE XREF: BuildSprites+64Cj
		swap	d0
		dbf	d0,loc_D632

loc_D664:				; CODE XREF: BuildSprites+5ECj
					; BuildSprites+5F8j ...
		movea.l	(sp)+,a4
		bra.w	loc_D520
; END OF FUNCTION CHUNK	FOR BuildSprites


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; adjust art pointer of object at a0 for 2-player mode
; ModifySpriteAttr_2P:
Adjust2PArtPointer:
		tst.w	(Two_player_mode).w
		beq.s	locret_D684
		move.w	art_tile(a0),d0
		andi.w	#$7FF,d0
		lsr.w	#1,d0
		andi.w	#$F800,art_tile(a0)
		add.w	d0,art_tile(a0)

locret_D684:
		rts
; End of function Adjust2PArtPointer


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; adjust art pointer of object at a1 for 2-player mode
; ModifyA1SpriteAttr_2P:
Adjust2PArtPointer2:
		tst.w	(Two_player_mode).w
		beq.s	locret_D6BE
		move.w	art_tile(a1),d0
		andi.w	#$7FF,d0
		lsr.w	#1,d0
		andi.w	#$F800,art_tile(a1)
		add.w	d0,art_tile(a1)

locret_D6BE
		rts
; End of function Adjust2PArtPointer2


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_D6A2:
		movea.w	art_tile(a0),a3
; End of function sub_D6A2


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_D6A6:				; CODE XREF: BuildSprites+5BEp
					; BuildSprites+64Ep
		cmpi.b	#$50,d5	; 'P'
		bcc.s	locret_D6E6
		btst	#0,d4
		bne.s	loc_D6F8
		btst	#1,d4
		bne.w	loc_D75A

loc_D6BA:				; CODE XREF: sub_D6A6+3Cj
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	byte_D6E8(pc,d4.w),(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		add.w	a3,d0
		move.w	d0,(a2)+
		move.w	(a1)+,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D6E0
		addq.w	#1,d0

loc_D6E0:				; CODE XREF: sub_D6A6+36j
		move.w	d0,(a2)+
		dbf	d1,loc_D6BA

locret_D6E6:				; CODE XREF: sub_D6A6+4j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_D6E8:	dc.b   0,  0		; 0
		dc.b   1,  1		; 2
		dc.b   4,  4		; 4
		dc.b   5,  5		; 6
		dc.b   8,  8		; 8
		dc.b   9,  9		; 10
		dc.b  $C, $C		; 12
		dc.b  $D, $D		; 14
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D6F8:				; CODE XREF: sub_D6A6+Aj
		btst	#1,d4
		bne.w	loc_D7B6

loc_D700:				; CODE XREF: sub_D6A6+8Ej
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	byte_D6E8(pc,d4.w),(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		add.w	a3,d0
		eori.w	#$800,d0
		move.w	d0,(a2)+
		move.w	(a1)+,d0
		neg.w	d0
		move.b	byte_D73A(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D732
		addq.w	#1,d0

loc_D732:				; CODE XREF: sub_D6A6+88j
		move.w	d0,(a2)+
		dbf	d1,loc_D700
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_D73A:	dc.b   8,  8		; 0
		dc.b   8,  8		; 2
		dc.b $10,$10		; 4
		dc.b $10,$10		; 6
		dc.b $18,$18		; 8
		dc.b $18,$18		; 10
		dc.b $20,$20		; 12
		dc.b $20,$20		; 14
byte_D74A:	dc.b   8,$10,$18,$20	; 0
		dc.b   8,$10,$18,$20	; 4
		dc.b   8,$10,$18,$20	; 8
		dc.b   8,$10,$18,$20	; 12
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D75A:				; CODE XREF: sub_D6A6+10j sub_D6A6+EAj
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		move.b	byte_D74A(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	byte_D796(pc,d4.w),(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1000,d0
		move.w	d0,(a2)+
		move.w	(a1)+,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D78E
		addq.w	#1,d0

loc_D78E:				; CODE XREF: sub_D6A6+E4j
		move.w	d0,(a2)+
		dbf	d1,loc_D75A
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_D796:	dc.b   0,  0,  1,  1	; 0
		dc.b   4,  4,  5,  5	; 4
		dc.b   8,  8,  9,  9	; 8
		dc.b  $C, $C, $D, $D	; 12
byte_D7A6:	dc.b   8,$10,$18,$20	; 0
		dc.b   8,$10,$18,$20	; 4
		dc.b   8,$10,$18,$20	; 8
		dc.b   8,$10,$18,$20	; 12
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D7B6:				; CODE XREF: sub_D6A6+56j
					; sub_D6A6+14Ej
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		move.b	byte_D7A6(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	byte_D796(pc,d4.w),(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1800,d0
		move.w	d0,(a2)+
		move.w	(a1)+,d0
		neg.w	d0
		move.b	byte_D7FA(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D7F2
		addq.w	#1,d0

loc_D7F2:				; CODE XREF: sub_D6A6+148j
		move.w	d0,(a2)+
		dbf	d1,loc_D7B6
		rts
; End of function sub_D6A6

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_D7FA:	dc.b   8,  8,  8,  8	; 0
		dc.b $10,$10,$10,$10	; 4
		dc.b $18,$18,$18,$18	; 8
		dc.b $20,$20,$20,$20	; 12
		dc.b $30,$28,  0,  8	; 16