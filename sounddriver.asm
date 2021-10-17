; ===========================================================================
; ---------------------------------------------------------------------------
; Modified Type 1b 68000 Sound Driver
; Same as Sonic 1's, down to its location in the ROM
; ---------------------------------------------------------------------------

Go_SoundTypes:	dc.l SoundTypes
Go_SoundD0:	dc.l SoundD0Index
Go_MusicIndex:	dc.l MusicIndex
Go_SoundIndex:	dc.l SoundIndex
off_719A0:	dc.l byte_71A94
Go_PSGIndex:	dc.l PSG_Index
; ---------------------------------------------------------------------------
; PSG instruments used in music
; ---------------------------------------------------------------------------
PSG_Index:	dc.l PSG1, PSG2, PSG3, PSG4, PSG5, PSG6, PSG7, PSG8, PSG9
PSG1:		dc.b   0,  0,  0,  1,  1,  1,  2,  2,  2,  3,  3,  3,  4,  4,  4,  5,  5,  5,  6,  6,  6,  7,$80
PSG2:		dc.b   0,  2,  4,  6,  8,$10,$80
PSG3:		dc.b   0,  0,  1,  1,  2,  2,  3,  3,  4,  4,  5,  5,  6,  6,  7,  7,$80
PSG4:		dc.b   0,  0,  2,  3,  4,  4,  5,  5,  5,  6,$80
PSG6:		dc.b   3,  3,  3,  2,  2,  2,  2,  1,  1,  1,  0,  0,  0,  0,$80
PSG5:		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  2,  2,  3,  3,  3,  3,  3,  3,  3,  3,  4,$80
PSG7:		dc.b   0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  2,  2,  2,  2,  2,  3,  3,  3,  4,  4,  4,  5,  5,  5,  6,  7,$80
PSG8:		dc.b   0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  3,  3,  3,  3,  3,  4,  4,  4,  4,  4,  5,  5,  5,  5,  5,  6,  6,  6,  6,  6,  7,  7,  7,$80
PSG9:		dc.b   0,  1,  2,  3,  4,  5,  6,  7,  8,  9, $A, $B, $C, $D, $E, $F,$80
byte_71A94:	dc.b   7,$72,$73,$26,$15,  8,$FF,  5
; ---------------------------------------------------------------------------
; Music	Pointers
; ---------------------------------------------------------------------------
MusicIndex:	dc.l Music81, Music82, Music83,	Music84, Music85, Music86
		dc.l Music87, Music88, Music89,	Music8A, Music8B, Music8C
		dc.l Music8D, Music8E, Music8F,	Music90, Music91, Music92
		dc.l Music93
; ---------------------------------------------------------------------------
; Type of sound	being played ($90 = music; $70 = normal	sound effect)
; ---------------------------------------------------------------------------
SoundTypes:	dc.b $90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90
		dc.b $90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$80
		dc.b $70,$70,$70,$70,$70,$70,$70,$70,$70,$68,$70,$70,$70,$60,$70,$70
		dc.b $60,$70,$60,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$7F,$60
		dc.b $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$80
		dc.b $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$90
		dc.b $90,$90,$90,$90

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_71B4C:
		move.w	#$100,($A11100).l ; stop the Z80
		nop
		nop
		nop

loc_71B5A:				; CODE XREF: sub_71B4C+16j
		btst	#0,($A11100).l
		bne.s	loc_71B5A
		btst	#7,($A01FFD).l
		beq.s	loc_71B82
		startZ80
		nop
		nop
		nop
		nop
		nop
		bra.s	sub_71B4C
; ===========================================================================

loc_71B82:				; CODE XREF: sub_71B4C+20j
		lea	($FFF000).l,a6
		clr.b	$E(a6)
		tst.b	3(a6)		; is music paused?
		bne.w	loc_71E50	; if yes, branch
		subq.b	#1,1(a6)
		bne.s	loc_71B9E
		jsr	sub_7260C(pc)

loc_71B9E:				; CODE XREF: sub_71B4C+4Cj
		move.b	4(a6),d0
		beq.s	loc_71BA8
		jsr	sub_72504(pc)

loc_71BA8:				; CODE XREF: sub_71B4C+56j
		tst.b	$24(a6)
		beq.s	loc_71BB2
		jsr	sub_7267C(pc)

loc_71BB2:				; CODE XREF: sub_71B4C+60j
		tst.w	$A(a6)		; is music or sound being played?
		beq.s	loc_71BBC	; if not, branch
		jsr	Sound_Play(pc)

loc_71BBC:				; CODE XREF: sub_71B4C+6Aj
		cmpi.b	#-$80,9(a6)
		beq.s	loc_71BC8
		jsr	Sound_ChkValue(pc)

loc_71BC8:				; CODE XREF: sub_71B4C+76j
		lea	$40(a6),a5
		tst.b	(a5)
		bpl.s	loc_71BD4
		jsr	sub_71C4E(pc)

loc_71BD4:				; CODE XREF: sub_71B4C+82j
		clr.b	8(a6)
		moveq	#5,d7

loc_71BDA:				; CODE XREF: sub_71B4C:loc_71BE6j
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_71BE6
		jsr	sub_71CCA(pc)

loc_71BE6:				; CODE XREF: sub_71B4C+94j
		dbf	d7,loc_71BDA
		moveq	#2,d7

loc_71BEC:				; CODE XREF: sub_71B4C:loc_71BF8j
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_71BF8
		jsr	sub_72850(pc)

loc_71BF8:				; CODE XREF: sub_71B4C+A6j
		dbf	d7,loc_71BEC
		move.b	#-$80,$E(a6)
		moveq	#2,d7

loc_71C04:				; CODE XREF: sub_71B4C:loc_71C10j
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_71C10
		jsr	sub_71CCA(pc)

loc_71C10:				; CODE XREF: sub_71B4C+BEj
		dbf	d7,loc_71C04
		moveq	#2,d7

loc_71C16:				; CODE XREF: sub_71B4C:loc_71C22j
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_71C22
		jsr	sub_72850(pc)

loc_71C22:				; CODE XREF: sub_71B4C+D0j
		dbf	d7,loc_71C16
		move.b	#$40,$E(a6)
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_71C38
		jsr	sub_71CCA(pc)

loc_71C38:				; CODE XREF: sub_71B4C+E6j
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_71C44
		jsr	sub_72850(pc)

loc_71C44:
		startZ80
		rts
; End of function sub_71B4C


; =============== S U B	R O U T	I N E =======================================


sub_71C4E:				; DATA XREF: sub_71B4C+84t
		subq.b	#1,$E(a5)
		bne.s	locret_71CAA
		move.b	#-$80,8(a6)
		movea.l	4(a5),a4

loc_71C5E:				; CODE XREF: sub_71C4E+1Ej
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#$E0,d5
		bcs.s	loc_71C6E
		jsr	sub_72A5A(pc)
		bra.s	loc_71C5E
; ===========================================================================

loc_71C6E:				; CODE XREF: sub_71C4E+18j
		tst.b	d5
		bpl.s	loc_71C84
		move.b	d5,$10(a5)
		move.b	(a4)+,d5
		bpl.s	loc_71C84
		subq.w	#1,a4
		move.b	$F(a5),$E(a5)
		bra.s	loc_71C88
; ===========================================================================

loc_71C84:				; CODE XREF: sub_71C4E+22j
					; sub_71C4E+2Aj
		jsr	sub_71D40(pc)

loc_71C88:				; CODE XREF: sub_71C4E+34j
		move.l	a4,4(a5)
		btst	#2,(a5)
		bne.s	locret_71CAA
		moveq	#0,d0
		move.b	$10(a5),d0
		cmpi.b	#-$80,d0
		beq.s	locret_71CAA
		btst	#3,d0
		bne.s	loc_71CAC
		move.b	d0,($A01FFF).l

locret_71CAA:				; CODE XREF: sub_71C4E+4j
					; sub_71C4E+42j ...
		rts
; ===========================================================================

loc_71CAC:				; CODE XREF: sub_71C4E+54j
		subi.b	#-$78,d0
		move.b	byte_71CC4(pc,d0.w),d0
		move.b	d0,($A000EA).l
		move.b	#-$7D,($A01FFF).l
		rts
; End of function sub_71C4E

; ===========================================================================
byte_71CC4:	dc.b $12,$15,$1C,$1D,$FF,$FF; 0

; =============== S U B	R O U T	I N E =======================================


sub_71CCA:				; DATA XREF: sub_71B4C+96t
					; sub_71B4C+C0t ...

; FUNCTION CHUNK AT 000726E2 SIZE 0000001C BYTES

		subq.b	#1,$E(a5)
		bne.s	loc_71CE0
		bclr	#4,(a5)
		jsr	sub_71CEC(pc)
		jsr	sub_71E18(pc)
		bra.w	loc_726E2
; ===========================================================================

loc_71CE0:				; CODE XREF: sub_71CCA+4j
		jsr	sub_71D9E(pc)
		jsr	sub_71DC6(pc)
		bra.w	loc_71E24
; End of function sub_71CCA


; =============== S U B	R O U T	I N E =======================================


sub_71CEC:				; DATA XREF: sub_71CCA+At
		movea.l	4(a5),a4
		bclr	#1,(a5)

loc_71CF4:				; CODE XREF: sub_71CEC+16j
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#$E0,d5
		bcs.s	loc_71D04
		jsr	sub_72A5A(pc)
		bra.s	loc_71CF4
; ===========================================================================

loc_71D04:				; CODE XREF: sub_71CEC+10j
		jsr	sub_726FE(pc)
		tst.b	d5
		bpl.s	loc_71D1A
		jsr	sub_71D22(pc)
		move.b	(a4)+,d5
		bpl.s	loc_71D1A
		subq.w	#1,a4
		bra.w	sub_71D60
; ===========================================================================

loc_71D1A:				; CODE XREF: sub_71CEC+1Ej
					; sub_71CEC+26j
		jsr	sub_71D40(pc)
		bra.w	sub_71D60
; End of function sub_71CEC


; =============== S U B	R O U T	I N E =======================================


sub_71D22:				; DATA XREF: sub_71CEC+20t

; FUNCTION CHUNK AT 00071D58 SIZE 00000008 BYTES

		subi.b	#-$80,d5
		beq.s	loc_71D58
		add.b	8(a5),d5
		andi.w	#$7F,d5
		lsl.w	#1,d5
		lea	word_72790(pc),a0
		move.w	(a0,d5.w),d6
		move.w	d6,$10(a5)
		rts
; End of function sub_71D22


; =============== S U B	R O U T	I N E =======================================


sub_71D40:				; DATA XREF: sub_71C4E:loc_71C84t
					; sub_71CEC:loc_71D1At	...
		move.b	d5,d0
		move.b	2(a5),d1

loc_71D46:				; CODE XREF: sub_71D40+Cj
		subq.b	#1,d1
		beq.s	loc_71D4E
		add.b	d5,d0
		bra.s	loc_71D46
; ===========================================================================

loc_71D4E:				; CODE XREF: sub_71D40+8j
		move.b	d0,$F(a5)
		move.b	d0,$E(a5)
		rts
; End of function sub_71D40

; ===========================================================================
; START	OF FUNCTION CHUNK FOR sub_71D22

loc_71D58:				; CODE XREF: sub_71D22+4j
		bset	#1,(a5)
		clr.w	$10(a5)
; END OF FUNCTION CHUNK	FOR sub_71D22

; =============== S U B	R O U T	I N E =======================================


sub_71D60:				; CODE XREF: sub_71CEC+2Aj
					; sub_71CEC+32j ...
		move.l	a4,4(a5)
		move.b	$F(a5),$E(a5)
		btst	#4,(a5)
		bne.s	locret_71D9C
		move.b	$13(a5),$12(a5)
		clr.b	$C(a5)
		btst	#3,(a5)
		beq.s	locret_71D9C
		movea.l	$14(a5),a0
		move.b	(a0)+,$18(a5)
		move.b	(a0)+,$19(a5)
		move.b	(a0)+,$1A(a5)
		move.b	(a0)+,d0
		lsr.b	#1,d0
		move.b	d0,$1B(a5)
		clr.w	$1C(a5)

locret_71D9C:				; CODE XREF: sub_71D60+Ej
					; sub_71D60+1Ej
		rts
; End of function sub_71D60


; =============== S U B	R O U T	I N E =======================================


sub_71D9E:				; DATA XREF: sub_71CCA:loc_71CE0t
					; sub_72850:loc_72866t
		tst.b	$12(a5)
		beq.s	locret_71DC4
		subq.b	#1,$12(a5)
		bne.s	locret_71DC4
		bset	#1,(a5)
		tst.b	1(a5)
		bmi.w	loc_71DBE
		jsr	sub_726FE(pc)
		addq.w	#4,sp
		rts
; ===========================================================================

loc_71DBE:				; CODE XREF: sub_71D9E+14j
		jsr	sub_729A0(pc)
		addq.w	#4,sp

locret_71DC4:				; CODE XREF: sub_71D9E+4j sub_71D9E+Aj
		rts
; End of function sub_71D9E


; =============== S U B	R O U T	I N E =======================================


sub_71DC6:				; DATA XREF: sub_71CCA+1At
					; sub_72850+1Et
		addq.w	#4,sp
		btst	#3,(a5)
		beq.s	locret_71E16
		tst.b	$18(a5)
		beq.s	loc_71DDA
		subq.b	#1,$18(a5)
		rts
; ===========================================================================

loc_71DDA:				; CODE XREF: sub_71DC6+Cj
		subq.b	#1,$19(a5)
		beq.s	loc_71DE2
		rts
; ===========================================================================

loc_71DE2:				; CODE XREF: sub_71DC6+18j
		movea.l	$14(a5),a0
		move.b	1(a0),$19(a5)
		tst.b	$1B(a5)
		bne.s	loc_71DFE
		move.b	3(a0),$1B(a5)
		neg.b	$1A(a5)
		rts
; ===========================================================================

loc_71DFE:				; CODE XREF: sub_71DC6+2Aj
		subq.b	#1,$1B(a5)
		move.b	$1A(a5),d6
		ext.w	d6
		add.w	$1C(a5),d6
		move.w	d6,$1C(a5)
		add.w	$10(a5),d6
		subq.w	#4,sp

locret_71E16:				; CODE XREF: sub_71DC6+6j
		rts
; End of function sub_71DC6


; =============== S U B	R O U T	I N E =======================================


sub_71E18:				; DATA XREF: sub_71CCA+Et
		btst	#1,(a5)
		bne.s	locret_71E48
		move.w	$10(a5),d6
		beq.s	loc_71E4A

loc_71E24:				; CODE XREF: sub_71CCA+1Ej
		move.b	$1E(a5),d0
		ext.w	d0
		add.w	d0,d6
		btst	#2,(a5)
		bne.s	locret_71E48
		move.w	d6,d1
		lsr.w	#8,d1
		move.b	#$A4,d0
		jsr	sub_72722(pc)
		move.b	d6,d1
		move.b	#$A0,d0
		jsr	sub_72722(pc)

locret_71E48:				; CODE XREF: sub_71E18+4j
					; sub_71E18+18j
		rts
; ===========================================================================

loc_71E4A:				; CODE XREF: sub_71E18+Aj
		bset	#1,(a5)
		rts
; End of function sub_71E18

; ===========================================================================
; START	OF FUNCTION CHUNK FOR sub_71B4C

loc_71E50:				; CODE XREF: sub_71B4C+44j
		bmi.s	loc_71E94
		cmpi.b	#2,3(a6)
		beq.w	loc_71EFE
		move.b	#2,3(a6)
		moveq	#2,d3
		move.b	#$B4,d0
		moveq	#0,d1

loc_71E6A:				; CODE XREF: sub_71B4C+328j
		jsr	sub_7272E(pc)
		jsr	sub_72764(pc)
		addq.b	#1,d0
		dbf	d3,loc_71E6A
		moveq	#2,d3
		moveq	#$28,d0

loc_71E7C:				; CODE XREF: sub_71B4C+33Cj
		move.b	d3,d1
		jsr	sub_7272E(pc)
		addq.b	#4,d1
		jsr	sub_7272E(pc)
		dbf	d3,loc_71E7C
		jsr	sub_729B6(pc)
		bra.w	loc_71C44
; ===========================================================================

loc_71E94:				; CODE XREF: sub_71B4C:loc_71E50j
		clr.b	3(a6)
		moveq	#$30,d3
		lea	$40(a6),a5
		moveq	#6,d4

loc_71EA0:				; CODE XREF: sub_71B4C+36Ej
		btst	#7,(a5)
		beq.s	loc_71EB8
		btst	#2,(a5)
		bne.s	loc_71EB8
		move.b	#$B4,d0
		move.b	$A(a5),d1
		jsr	sub_72722(pc)

loc_71EB8:				; CODE XREF: sub_71B4C+358j
					; sub_71B4C+35Ej
		adda.w	d3,a5
		dbf	d4,loc_71EA0
		lea	$220(a6),a5
		moveq	#2,d4

loc_71EC4:				; CODE XREF: sub_71B4C+392j
		btst	#7,(a5)
		beq.s	loc_71EDC
		btst	#2,(a5)
		bne.s	loc_71EDC
		move.b	#$B4,d0
		move.b	$A(a5),d1
		jsr	sub_72722(pc)

loc_71EDC:				; CODE XREF: sub_71B4C+37Cj
					; sub_71B4C+382j
		adda.w	d3,a5
		dbf	d4,loc_71EC4
		lea	$340(a6),a5
		btst	#7,(a5)
		beq.s	loc_71EFE
		btst	#2,(a5)
		bne.s	loc_71EFE
		move.b	#$B4,d0
		move.b	$A(a5),d1
		jsr	sub_72722(pc)

loc_71EFE:				; CODE XREF: sub_71B4C+30Cj
					; sub_71B4C+39Ej ...
		bra.w	loc_71C44
; END OF FUNCTION CHUNK	FOR sub_71B4C
; ---------------------------------------------------------------------------
; Subroutine to	play a sound or	music track
; ---------------------------------------------------------------------------

; =============== S U B	R O U T	I N E =======================================


Sound_Play:				; DATA XREF: sub_71B4C+6Ct
		movea.l	(Go_SoundTypes).l,a0
		lea	$A(a6),a1	; load music track number
		move.b	0(a6),d3
		moveq	#2,d4

loc_71F12:				; CODE XREF: Sound_Play:loc_71F3Ej
		move.b	(a1),d0		; move track number to d0
		move.b	d0,d1
		clr.b	(a1)+
		subi.b	#-$7F,d0
		bcs.s	loc_71F3E
		cmpi.b	#-$80,9(a6)
		beq.s	loc_71F2C
		move.b	d1,$A(a6)
		bra.s	loc_71F3E
; ===========================================================================

loc_71F2C:				; CODE XREF: Sound_Play+22j
		andi.w	#$7F,d0
		move.b	(a0,d0.w),d2
		cmp.b	d3,d2
		bcs.s	loc_71F3E
		move.b	d2,d3
		move.b	d1,9(a6)	; set music flag

loc_71F3E:				; CODE XREF: Sound_Play+1Aj
					; Sound_Play+28j ...
		dbf	d4,loc_71F12
		tst.b	d3
		bmi.s	locret_71F4A
		move.b	d3,0(a6)

locret_71F4A:				; CODE XREF: Sound_Play+42j
		rts
; End of function Sound_Play


; =============== S U B	R O U T	I N E =======================================


Sound_ChkValue:				; DATA XREF: sub_71B4C+78t

; FUNCTION CHUNK AT 000724E6 SIZE 0000001E BYTES
; FUNCTION CHUNK AT 0007259E SIZE 0000002C BYTES
; FUNCTION CHUNK AT 00072624 SIZE 00000058 BYTES

		moveq	#0,d7
		move.b	9(a6),d7
		beq.w	Sound_E4
		bpl.s	locret_71F8C
		move.b	#$80,9(a6)	; reset	music flag
		cmpi.b	#$9F,d7
		bls.w	loc_71FD2	; music	$81-$9F
		cmpi.b	#$A0,d7
		bcs.w	locret_71F8C
		cmpi.b	#$CF,d7
		bls.w	loc_721C6	; sound	$A0-$CF
		cmpi.b	#$D0,d7
		bcs.w	locret_71F8C
		cmpi.b	#$E0,d7
		bcs.w	loc_7230C	; sound	$D0-$DF
		cmpi.b	#$E4,d7
		bls.s	loc_71F8E	; sound	$E0-$E4

locret_71F8C:				; CODE XREF: Sound_ChkValue+Aj
					; Sound_ChkValue+1Ej ...
		rts
; ===========================================================================

loc_71F8E:				; CODE XREF: Sound_ChkValue+3Ej
		subi.b	#$E0,d7
		lsl.w	#2,d7
		jmp	loc_71F98(pc,d7.w)
; ===========================================================================

loc_71F98:
		bra.w	Sound_E0
; ===========================================================================
		bra.w	loc_71FAC
; ===========================================================================
		bra.w	Sound_E2
; ===========================================================================
		bra.w	Sound_E3
; ===========================================================================
		bra.w	Sound_E4
; ===========================================================================
; ---------------------------------------------------------------------------
; Play "Say-gaa" PCM sound
; ---------------------------------------------------------------------------

loc_71FAC:				; CODE XREF: Sound_ChkValue+50j
		move.b	#$88,($A01FFF).l
		startZ80
		move.w	#$11,d1

loc_71FC0:				; CODE XREF: Sound_ChkValue+7Ej
		move.w	#$FFFF,d0

loc_71FC4:				; CODE XREF: Sound_ChkValue+7Aj
		nop
		dbf	d0,loc_71FC4
		dbf	d1,loc_71FC0
		addq.w	#4,sp
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Play music track $81-$9F
; ---------------------------------------------------------------------------

loc_71FD2:				; CODE XREF: Sound_ChkValue+16j
		cmpi.b	#$88,d7		; is "extra life" music	played?
		bne.s	loc_72024	; if not, branch
		tst.b	$27(a6)
		bne.w	loc_721B6
		lea	$40(a6),a5
		moveq	#9,d0

loc_71FE6:				; CODE XREF: Sound_ChkValue+A2j
		bclr	#2,(a5)
		adda.w	#$30,a5
		dbf	d0,loc_71FE6
		lea	$220(a6),a5
		moveq	#5,d0

loc_71FF8:				; CODE XREF: Sound_ChkValue+B4j
		bclr	#7,(a5)
		adda.w	#$30,a5
		dbf	d0,loc_71FF8
		clr.b	0(a6)
		movea.l	a6,a0
		lea	$3A0(a6),a1
		move.w	#$87,d0

loc_72012:				; CODE XREF: Sound_ChkValue+C8j
		move.l	(a0)+,(a1)+
		dbf	d0,loc_72012
		move.b	#-$80,$27(a6)
		clr.b	0(a6)
		bra.s	loc_7202C
; ===========================================================================

loc_72024:				; CODE XREF: Sound_ChkValue+8Aj
		clr.b	$27(a6)
		clr.b	$26(a6)

loc_7202C:				; CODE XREF: Sound_ChkValue+D6j
		jsr	sub_725CA(pc)
		movea.l	(off_719A0).l,a4
		subi.b	#-$7F,d7
		move.b	(a4,d7.w),$29(a6)
		movea.l	(Go_MusicIndex).l,a4
		lsl.w	#2,d7
		movea.l	(a4,d7.w),a4
		moveq	#0,d0
		move.w	(a4),d0
		add.l	a4,d0
		move.l	d0,$18(a6)
		move.b	5(a4),d0
		move.b	d0,$28(a6)
		tst.b	$2A(a6)
		beq.s	loc_72068
		move.b	$29(a6),d0

loc_72068:				; CODE XREF: Sound_ChkValue+116j
		move.b	d0,2(a6)
		move.b	d0,1(a6)
		moveq	#0,d1
		movea.l	a4,a3
		addq.w	#6,a4
		moveq	#0,d7
		move.b	2(a3),d7
		beq.w	loc_72114
		subq.b	#1,d7
		move.b	#$C0,d1
		move.b	4(a3),d4
		moveq	#$30,d6
		move.b	#1,d5
		lea	$40(a6),a1
		lea	byte_721BA(pc),a2

loc_72098:				; CODE XREF: Sound_ChkValue+174j
		bset	#7,(a1)
		move.b	(a2)+,1(a1)
		move.b	d4,2(a1)
		move.b	d6,$D(a1)
		move.b	d1,$A(a1)
		move.b	d5,$E(a1)
		moveq	#0,d0
		move.w	(a4)+,d0
		add.l	a3,d0
		move.l	d0,4(a1)
		move.w	(a4)+,8(a1)
		adda.w	d6,a1
		dbf	d7,loc_72098
		cmpi.b	#7,2(a3)
		bne.s	loc_720D8
		moveq	#$2B,d0
		moveq	#0,d1
		jsr	sub_7272E(pc)
		bra.w	loc_72114
; ===========================================================================

loc_720D8:				; CODE XREF: Sound_ChkValue+17Ej
		moveq	#$28,d0
		moveq	#6,d1
		jsr	sub_7272E(pc)
		move.b	#$42,d0
		moveq	#$7F,d1
		jsr	sub_72764(pc)
		move.b	#$4A,d0
		moveq	#$7F,d1
		jsr	sub_72764(pc)
		move.b	#$46,d0
		moveq	#$7F,d1
		jsr	sub_72764(pc)
		move.b	#$4E,d0
		moveq	#$7F,d1
		jsr	sub_72764(pc)
		move.b	#$B6,d0
		move.b	#$C0,d1
		jsr	sub_72764(pc)

loc_72114:				; CODE XREF: Sound_ChkValue+130j
					; Sound_ChkValue+188j
		moveq	#0,d7
		move.b	3(a3),d7
		beq.s	loc_72154
		subq.b	#1,d7
		lea	$190(a6),a1
		lea	byte_721C2(pc),a2

loc_72126:				; CODE XREF: Sound_ChkValue+204j
		bset	#7,(a1)
		move.b	(a2)+,1(a1)
		move.b	d4,2(a1)
		move.b	d6,$D(a1)
		move.b	d5,$E(a1)
		moveq	#0,d0
		move.w	(a4)+,d0
		add.l	a3,d0
		move.l	d0,4(a1)
		move.w	(a4)+,8(a1)
		move.b	(a4)+,d0
		move.b	(a4)+,$B(a1)
		adda.w	d6,a1
		dbf	d7,loc_72126

loc_72154:				; CODE XREF: Sound_ChkValue+1CEj
		lea	$220(a6),a1
		moveq	#5,d7

loc_7215A:				; CODE XREF: Sound_ChkValue+232j
		tst.b	(a1)
		bpl.w	loc_7217C
		moveq	#0,d0
		move.b	1(a1),d0
		bmi.s	loc_7216E
		subq.b	#2,d0
		lsl.b	#2,d0
		bra.s	loc_72170
; ===========================================================================

loc_7216E:				; CODE XREF: Sound_ChkValue+21Aj
		lsr.b	#3,d0

loc_72170:				; CODE XREF: Sound_ChkValue+220j
		lea	dword_722CC(pc),a0
		movea.l	(a0,d0.w),a0
		bset	#2,(a0)

loc_7217C:				; CODE XREF: Sound_ChkValue+210j
		adda.w	d6,a1
		dbf	d7,loc_7215A
		tst.w	$340(a6)
		bpl.s	loc_7218E
		bset	#2,$100(a6)

loc_7218E:				; CODE XREF: Sound_ChkValue+23Aj
		tst.w	$370(a6)
		bpl.s	loc_7219A
		bset	#2,$1F0(a6)

loc_7219A:				; CODE XREF: Sound_ChkValue+246j
		lea	$70(a6),a5
		moveq	#5,d4

loc_721A0:				; CODE XREF: Sound_ChkValue+25Aj
		jsr	sub_726FE(pc)
		adda.w	d6,a5
		dbf	d4,loc_721A0
		moveq	#2,d4

loc_721AC:				; CODE XREF: Sound_ChkValue+266j
		jsr	sub_729A0(pc)
		adda.w	d6,a5
		dbf	d4,loc_721AC

loc_721B6:				; CODE XREF: Sound_ChkValue+90j
		addq.w	#4,sp
		rts
; ===========================================================================
byte_721BA:	dc.b 6,	0, 1, 2, 4, 5, 6, 0 ; DATA XREF: Sound_ChkValue+148t
byte_721C2:	dc.b $80, $A0, $C0, 0	; DATA XREF: Sound_ChkValue+1D6t
; ===========================================================================
; ---------------------------------------------------------------------------
; Play normal sound effect
; ---------------------------------------------------------------------------

loc_721C6:				; CODE XREF: Sound_ChkValue+26j
		tst.b	$27(a6)
		bne.w	loc_722C6
		tst.b	4(a6)
		bne.w	loc_722C6
		tst.b	$24(a6)
		bne.w	loc_722C6
		cmpi.b	#-$4B,d7	; is ring sound	effect played?
		bne.s	loc_721F4	; if not, branch
		tst.b	$2B(a6)
		bne.s	loc_721EE
		move.b	#-$32,d7	; play ring sound in left speaker

loc_721EE:				; CODE XREF: Sound_ChkValue+29Cj
		bchg	#0,$2B(a6)	; change speaker

loc_721F4:				; CODE XREF: Sound_ChkValue+296j
		cmpi.b	#-$59,d7	; is "pushing" sound played?
		bne.s	loc_72208	; if not, branch
		tst.b	$2C(a6)
		bne.w	locret_722C4
		move.b	#-$80,$2C(a6)

loc_72208:				; CODE XREF: Sound_ChkValue+2ACj
		movea.l	(Go_SoundIndex).l,a0
		subi.b	#-$60,d7
		lsl.w	#2,d7
		movea.l	(a0,d7.w),a3
		movea.l	a3,a1
		moveq	#0,d1
		move.w	(a1)+,d1
		add.l	a3,d1
		move.b	(a1)+,d5
		move.b	(a1)+,d7
		subq.b	#1,d7
		moveq	#$30,d6

loc_72228:				; CODE XREF: Sound_ChkValue:loc_722A8j
		moveq	#0,d3
		move.b	1(a1),d3
		move.b	d3,d4
		bmi.s	loc_72244
		subq.w	#2,d3
		lsl.w	#2,d3
		lea	dword_722CC(pc),a5
		movea.l	(a5,d3.w),a5
		bset	#2,(a5)
		bra.s	loc_7226E
; ===========================================================================

loc_72244:				; CODE XREF: Sound_ChkValue+2E4j
		lsr.w	#3,d3
		lea	dword_722CC(pc),a5
		movea.l	(a5,d3.w),a5
		bset	#2,(a5)
		cmpi.b	#-$40,d4
		bne.s	loc_7226E
		move.b	d4,d0
		ori.b	#$1F,d0
		move.b	d0,($C00011).l
		bchg	#5,d0
		move.b	d0,($C00011).l

loc_7226E:				; CODE XREF: Sound_ChkValue+2F6j
					; Sound_ChkValue+30Aj
		movea.l	dword_722EC(pc,d3.w),a5
		movea.l	a5,a2
		moveq	#$B,d0

loc_72276:				; CODE XREF: Sound_ChkValue+32Cj
		clr.l	(a2)+
		dbf	d0,loc_72276
		move.w	(a1)+,(a5)
		move.b	d5,2(a5)
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,4(a5)
		move.w	(a1)+,8(a5)
		move.b	#1,$E(a5)
		move.b	d6,$D(a5)
		tst.b	d4
		bmi.s	loc_722A8
		move.b	#-$40,$A(a5)
		move.l	d1,$20(a5)

loc_722A8:				; CODE XREF: Sound_ChkValue+350j
		dbf	d7,loc_72228
		tst.b	$250(a6)
		bpl.s	loc_722B8
		bset	#2,$340(a6)

loc_722B8:				; CODE XREF: Sound_ChkValue+364j
		tst.b	$310(a6)
		bpl.s	locret_722C4
		bset	#2,$370(a6)

locret_722C4:				; CODE XREF: Sound_ChkValue+2B2j
					; Sound_ChkValue+370j
		rts
; ===========================================================================

loc_722C6:				; CODE XREF: Sound_ChkValue+27Ej
					; Sound_ChkValue+286j ...
		clr.b	0(a6)
		rts
; ===========================================================================
dword_722CC:	dc.l   $FFF0D0,	       0,  $FFF100,  $FFF130; 0
					; DATA XREF: Sound_ChkValue:loc_72170t
					; Sound_ChkValue+2EAt ...
		dc.l   $FFF190,	 $FFF1C0,  $FFF1F0,  $FFF1F0; 4
dword_722EC:	dc.l   $FFF220,	       0,  $FFF250,  $FFF280; 0
		dc.l   $FFF2B0,	 $FFF2E0,  $FFF310,  $FFF310; 4
; ===========================================================================
; ---------------------------------------------------------------------------
; Play GHZ waterfall sound
; ---------------------------------------------------------------------------

loc_7230C:				; CODE XREF: Sound_ChkValue+36j
		tst.b	$27(a6)
		bne.w	locret_723C6
		tst.b	4(a6)
		bne.w	locret_723C6
		tst.b	$24(a6)
		bne.w	locret_723C6
		movea.l	(Go_SoundD0).l,a0
		subi.b	#-$30,d7
		lsl.w	#2,d7
		movea.l	(a0,d7.w),a3
		movea.l	a3,a1
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,$20(a6)
		move.b	(a1)+,d5
		move.b	(a1)+,d7
		subq.b	#1,d7
		moveq	#$30,d6

loc_72348:				; CODE XREF: Sound_ChkValue:loc_72396j
		move.b	1(a1),d4
		bmi.s	loc_7235A
		bset	#2,$100(a6)
		lea	$340(a6),a5
		bra.s	loc_72364
; ===========================================================================

loc_7235A:				; CODE XREF: Sound_ChkValue+400j
		bset	#2,$1F0(a6)
		lea	$370(a6),a5

loc_72364:				; CODE XREF: Sound_ChkValue+40Cj
		movea.l	a5,a2
		moveq	#$B,d0

loc_72368:				; CODE XREF: Sound_ChkValue+41Ej
		clr.l	(a2)+
		dbf	d0,loc_72368
		move.w	(a1)+,(a5)
		move.b	d5,2(a5)
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,4(a5)
		move.w	(a1)+,8(a5)
		move.b	#1,$E(a5)
		move.b	d6,$D(a5)
		tst.b	d4
		bmi.s	loc_72396
		move.b	#-$40,$A(a5)

loc_72396:				; CODE XREF: Sound_ChkValue+442j
		dbf	d7,loc_72348
		tst.b	$250(a6)
		bpl.s	loc_723A6
		bset	#2,$340(a6)

loc_723A6:				; CODE XREF: Sound_ChkValue+452j
		tst.b	$310(a6)
		bpl.s	locret_723C6
		bset	#2,$370(a6)
		ori.b	#$1F,d4
		move.b	d4,($C00011).l
		bchg	#5,d4
		move.b	d4,($C00011).l

locret_723C6:				; CODE XREF: Sound_ChkValue+3C4j
					; Sound_ChkValue+3CCj ...
		rts
; End of function Sound_ChkValue

; ===========================================================================
		dc.l $FFF100, $FFF1F0, $FFF250,	$FFF310, $FFF340, $FFF370

; =============== S U B	R O U T	I N E =======================================


Snd_FadeOut1:				; DATA XREF: Sound_ChkValue:Sound_E0t
		clr.b	0(a6)
		lea	$220(a6),a5
		moveq	#5,d7

loc_723EA:				; CODE XREF: Snd_FadeOut1+96j
		tst.b	(a5)
		bpl.w	loc_72472
		bclr	#7,(a5)
		moveq	#0,d3
		move.b	1(a5),d3
		bmi.s	loc_7243C
		jsr	sub_726FE(pc)
		cmpi.b	#4,d3
		bne.s	loc_72416
		tst.b	$340(a6)
		bpl.s	loc_72416
		lea	$340(a6),a5
		movea.l	$20(a6),a1
		bra.s	loc_72428
; ===========================================================================

loc_72416:				; CODE XREF: Snd_FadeOut1+24j
					; Snd_FadeOut1+2Aj
		subq.b	#2,d3
		lsl.b	#2,d3
		lea	dword_722CC(pc),a0
		movea.l	a5,a3
		movea.l	(a0,d3.w),a5
		movea.l	$18(a6),a1

loc_72428:				; CODE XREF: Snd_FadeOut1+34j
		bclr	#2,(a5)
		bset	#1,(a5)
		move.b	$B(a5),d0
		jsr	sub_72C4E(pc)
		movea.l	a3,a5
		bra.s	loc_72472
; ===========================================================================

loc_7243C:				; CODE XREF: Snd_FadeOut1+1Aj
		jsr	sub_729A0(pc)
		lea	$370(a6),a0
		cmpi.b	#-$20,d3
		beq.s	loc_7245A
		cmpi.b	#-$40,d3
		beq.s	loc_7245A
		lsr.b	#3,d3
		lea	dword_722CC(pc),a0
		movea.l	(a0,d3.w),a0

loc_7245A:				; CODE XREF: Snd_FadeOut1+68j
					; Snd_FadeOut1+6Ej
		bclr	#2,(a0)
		bset	#1,(a0)
		cmpi.b	#-$20,1(a0)
		bne.s	loc_72472
		move.b	$1F(a0),($C00011).l

loc_72472:				; CODE XREF: Snd_FadeOut1+Cj
					; Snd_FadeOut1+5Aj ...
		adda.w	#$30,a5
		dbf	d7,loc_723EA
		rts
; End of function Snd_FadeOut1


; =============== S U B	R O U T	I N E =======================================


Snd_FadeOut2:				; DATA XREF: Sound_ChkValue+59Et
		lea	$340(a6),a5
		tst.b	(a5)
		bpl.s	loc_724AE
		bclr	#7,(a5)
		btst	#2,(a5)
		bne.s	loc_724AE
		jsr	loc_7270A(pc)
		lea	$100(a6),a5
		bclr	#2,(a5)
		bset	#1,(a5)
		tst.b	(a5)
		bpl.s	loc_724AE
		movea.l	$18(a6),a1
		move.b	$B(a5),d0
		jsr	sub_72C4E(pc)

loc_724AE:				; CODE XREF: Snd_FadeOut2+6j
					; Snd_FadeOut2+10j ...
		lea	$370(a6),a5
		tst.b	(a5)
		bpl.s	locret_724E4
		bclr	#7,(a5)
		btst	#2,(a5)
		bne.s	locret_724E4
		jsr	loc_729A6(pc)
		lea	$1F0(a6),a5
		bclr	#2,(a5)
		bset	#1,(a5)
		tst.b	(a5)
		bpl.s	locret_724E4
		cmpi.b	#$E0,1(a5)
		bne.s	locret_724E4
		move.b	$1F(a5),($C00011).l

locret_724E4:				; CODE XREF: Snd_FadeOut2+38j
					; Snd_FadeOut2+42j ...
		rts
; End of function Snd_FadeOut2

; ===========================================================================
; ---------------------------------------------------------------------------
; Fade out music
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR Sound_ChkValue

Sound_E0:				; CODE XREF: Sound_ChkValue:loc_71F98j
		jsr	Snd_FadeOut1(pc)
		jsr	Snd_FadeOut2(pc)
		move.b	#3,6(a6)
		move.b	#$28,4(a6)
		clr.b	$40(a6)
		clr.b	$2A(a6)
		rts
; END OF FUNCTION CHUNK	FOR Sound_ChkValue

; =============== S U B	R O U T	I N E =======================================


sub_72504:				; DATA XREF: sub_71B4C+58t
		move.b	6(a6),d0
		beq.s	loc_72510
		subq.b	#1,6(a6)
		rts
; ===========================================================================

loc_72510:				; CODE XREF: sub_72504+4j
		subq.b	#1,4(a6)
		beq.w	Sound_E4
		move.b	#3,6(a6)
		lea	$70(a6),a5
		moveq	#5,d7

loc_72524:				; CODE XREF: sub_72504+38j
		tst.b	(a5)
		bpl.s	loc_72538
		addq.b	#1,9(a5)
		bpl.s	loc_72534
		bclr	#7,(a5)
		bra.s	loc_72538
; ===========================================================================

loc_72534:				; CODE XREF: sub_72504+28j
		jsr	sub_72CB4(pc)

loc_72538:				; CODE XREF: sub_72504+22j
					; sub_72504+2Ej
		adda.w	#$30,a5
		dbf	d7,loc_72524
		moveq	#2,d7

loc_72542:				; CODE XREF: sub_72504+60j
		tst.b	(a5)
		bpl.s	loc_72560
		addq.b	#1,9(a5)
		cmpi.b	#$10,9(a5)
		bcs.s	loc_72558
		bclr	#7,(a5)
		bra.s	loc_72560
; ===========================================================================

loc_72558:				; CODE XREF: sub_72504+4Cj
		move.b	9(a5),d6
		jsr	sub_7296A(pc)

loc_72560:				; CODE XREF: sub_72504+40j
					; sub_72504+52j
		adda.w	#$30,a5
		dbf	d7,loc_72542
		rts
; End of function sub_72504


; =============== S U B	R O U T	I N E =======================================


sub_7256A:				; DATA XREF: Sound_ChkValue+676t
					; sub_725CA+3At
		moveq	#2,d3
		moveq	#$28,d0

loc_7256E:				; CODE XREF: sub_7256A+10j
		move.b	d3,d1
		jsr	sub_7272E(pc)
		addq.b	#4,d1
		jsr	sub_7272E(pc)
		dbf	d3,loc_7256E
		moveq	#$40,d0
		moveq	#$7F,d1
		moveq	#2,d4

loc_72584:				; CODE XREF: sub_7256A+2Ej
		moveq	#3,d3

loc_72586:				; CODE XREF: sub_7256A+26j
		jsr	sub_7272E(pc)
		jsr	sub_72764(pc)
		addq.w	#4,d0
		dbf	d3,loc_72586
		subi.b	#$F,d0
		dbf	d4,loc_72584
		rts
; End of function sub_7256A

; ===========================================================================
; ---------------------------------------------------------------------------
; Stop music
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR Sound_ChkValue

Sound_E4:				; CODE XREF: Sound_ChkValue+6j
					; Sound_ChkValue+5Cj ...
		moveq	#$2B,d0
		move.b	#-$80,d1
		jsr	sub_7272E(pc)
		moveq	#$27,d0
		moveq	#0,d1
		jsr	sub_7272E(pc)
		movea.l	a6,a0
		move.w	#$E3,d0

loc_725B6:				; CODE XREF: Sound_ChkValue+66Cj
		clr.l	(a0)+
		dbf	d0,loc_725B6
		move.b	#-$80,9(a6)	; set music to $80 (silence)
		jsr	sub_7256A(pc)
		bra.w	sub_729B6
; END OF FUNCTION CHUNK	FOR Sound_ChkValue

; =============== S U B	R O U T	I N E =======================================


sub_725CA:				; DATA XREF: Sound_ChkValue:loc_7202Ct
		movea.l	a6,a0
		move.b	0(a6),d1
		move.b	$27(a6),d2
		move.b	$2A(a6),d3
		move.b	$26(a6),d4
		move.w	$A(a6),d5
		move.w	#$87,d0

loc_725E4:				; CODE XREF: sub_725CA+1Cj
		clr.l	(a0)+
		dbf	d0,loc_725E4
		move.b	d1,0(a6)
		move.b	d2,$27(a6)
		move.b	d3,$2A(a6)
		move.b	d4,$26(a6)
		move.w	d5,$A(a6)
		move.b	#-$80,9(a6)
		jsr	sub_7256A(pc)
		bra.w	sub_729B6
; End of function sub_725CA


; =============== S U B	R O U T	I N E =======================================


sub_7260C:				; DATA XREF: sub_71B4C+4Et
		move.b	2(a6),1(a6)
		lea	$4E(a6),a0
		moveq	#$30,d0
		moveq	#9,d1

loc_7261A:				; CODE XREF: sub_7260C+12j
		addq.b	#1,(a0)
		adda.w	d0,a0
		dbf	d1,loc_7261A
		rts
; End of function sub_7260C

; ===========================================================================
; ---------------------------------------------------------------------------
; Speed	up music
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR Sound_ChkValue

Sound_E2:				; CODE XREF: Sound_ChkValue+54j
		tst.b	$27(a6)
		bne.s	loc_7263E
		move.b	$29(a6),2(a6)
		move.b	$29(a6),1(a6)
		move.b	#-$80,$2A(a6)
		rts
; ===========================================================================

loc_7263E:				; CODE XREF: Sound_ChkValue+6DCj
		move.b	$3C9(a6),$3A2(a6)
		move.b	$3C9(a6),$3A1(a6)
		move.b	#-$80,$3CA(a6)
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Change music back to normal speed
; ---------------------------------------------------------------------------

Sound_E3:				; CODE XREF: Sound_ChkValue+58j
		tst.b	$27(a6)
		bne.s	loc_7266A
		move.b	$28(a6),2(a6)
		move.b	$28(a6),1(a6)
		clr.b	$2A(a6)
		rts
; ===========================================================================

loc_7266A:				; CODE XREF: Sound_ChkValue+70Aj
		move.b	$3C8(a6),$3A2(a6)
		move.b	$3C8(a6),$3A1(a6)
		clr.b	$3CA(a6)
		rts
; END OF FUNCTION CHUNK	FOR Sound_ChkValue

; =============== S U B	R O U T	I N E =======================================


sub_7267C:				; DATA XREF: sub_71B4C+62t
		tst.b	$25(a6)
		beq.s	loc_72688
		subq.b	#1,$25(a6)
		rts
; ===========================================================================

loc_72688:				; CODE XREF: sub_7267C+4j
		tst.b	$26(a6)
		beq.s	loc_726D6
		subq.b	#1,$26(a6)
		move.b	#2,$25(a6)
		lea	$70(a6),a5
		moveq	#5,d7

loc_7269E:				; CODE XREF: sub_7267C+32j
		tst.b	(a5)
		bpl.s	loc_726AA
		subq.b	#1,9(a5)
		jsr	sub_72CB4(pc)

loc_726AA:				; CODE XREF: sub_7267C+24j
		adda.w	#$30,a5
		dbf	d7,loc_7269E
		moveq	#2,d7

loc_726B4:				; CODE XREF: sub_7267C+54j
		tst.b	(a5)
		bpl.s	loc_726CC
		subq.b	#1,9(a5)
		move.b	9(a5),d6
		cmpi.b	#$10,d6
		bcs.s	loc_726C8
		moveq	#$F,d6

loc_726C8:				; CODE XREF: sub_7267C+48j
		jsr	sub_7296A(pc)

loc_726CC:				; CODE XREF: sub_7267C+3Aj
		adda.w	#$30,a5
		dbf	d7,loc_726B4
		rts
; ===========================================================================

loc_726D6:				; CODE XREF: sub_7267C+10j
		bclr	#2,$40(a6)
		clr.b	$24(a6)
		rts
; End of function sub_7267C

; ===========================================================================
; START	OF FUNCTION CHUNK FOR sub_71CCA

loc_726E2:				; CODE XREF: sub_71CCA+12j
		btst	#1,(a5)
		bne.s	locret_726FC
		btst	#2,(a5)
		bne.s	locret_726FC
		moveq	#$28,d0
		move.b	1(a5),d1
		ori.b	#$F0,d1
		bra.w	sub_7272E
; ===========================================================================

locret_726FC:				; CODE XREF: sub_71CCA+A1Cj
					; sub_71CCA+A22j
		rts
; END OF FUNCTION CHUNK	FOR sub_71CCA

; =============== S U B	R O U T	I N E =======================================


sub_726FE:				; DATA XREF: sub_71CEC:loc_71D04t
					; sub_71D9E+18t ...
		btst	#4,(a5)
		bne.s	locret_72714
		btst	#2,(a5)
		bne.s	locret_72714

loc_7270A:				; DATA XREF: Snd_FadeOut2+12t
		moveq	#$28,d0
		move.b	1(a5),d1
		bra.w	sub_7272E
; ===========================================================================

locret_72714:				; CODE XREF: sub_726FE+4j sub_726FE+Aj
		rts
; End of function sub_726FE

; ===========================================================================

loc_72716:				; CODE XREF: ROM:00072AE6j
		btst	#2,(a5)
		bne.s	locret_72720
		bra.w	sub_72722
; ===========================================================================

locret_72720:				; CODE XREF: ROM:0007271Aj
		rts

; =============== S U B	R O U T	I N E =======================================


sub_72722:				; CODE XREF: ROM:0007271Cj
					; DATA XREF: sub_71E18+22t ...

; FUNCTION CHUNK AT 0007275A SIZE 0000000A BYTES

		btst	#2,1(a5)
		bne.s	loc_7275A
		add.b	1(a5),d0
; End of function sub_72722


; =============== S U B	R O U T	I N E =======================================


sub_7272E:				; CODE XREF: sub_71CCA+A2Ej
					; sub_726FE+12j ...
		move.b	($A04000).l,d2
		btst	#7,d2
		bne.s	sub_7272E
		move.b	d0,($A04000).l
		nop
		nop
		nop

loc_72746:				; CODE XREF: sub_7272E+22j
		move.b	($A04000).l,d2
		btst	#7,d2
		bne.s	loc_72746
		move.b	d1,($A04001).l
		rts
; End of function sub_7272E

; ===========================================================================
; START	OF FUNCTION CHUNK FOR sub_72722

loc_7275A:				; CODE XREF: sub_72722+6j
		move.b	1(a5),d2
		bclr	#2,d2
		add.b	d2,d0
; END OF FUNCTION CHUNK	FOR sub_72722

; =============== S U B	R O U T	I N E =======================================


sub_72764:				; CODE XREF: sub_72764+Aj
					; DATA XREF: sub_71B4C+322t ...
		move.b	($A04000).l,d2
		btst	#7,d2
		bne.s	sub_72764
		move.b	d0,($A04002).l
		nop
		nop
		nop

loc_7277C:				; CODE XREF: sub_72764+22j
		move.b	($A04000).l,d2
		btst	#7,d2
		bne.s	loc_7277C
		move.b	d1,($A04003).l
		rts
; End of function sub_72764

; ===========================================================================
word_72790:	dc.w $25E, $284, $2AB, $2D3, $2FE, $32D, $35C, $38F, $3C5
					; DATA XREF: sub_71D22+10t
		dc.w $3FF, $43C, $47C, $A5E, $A84, $AAB, $AD3, $AFE, $B2D
		dc.w $B5C, $B8F, $BC5, $BFF, $C3C, $C7C, $125E,	$1284
		dc.w $12AB, $12D3, $12FE, $132D, $135C,	$138F, $13C5, $13FF
		dc.w $143C, $147C, $1A5E, $1A84, $1AAB,	$1AD3, $1AFE, $1B2D
		dc.w $1B5C, $1B8F, $1BC5, $1BFF, $1C3C,	$1C7C, $225E, $2284
		dc.w $22AB, $22D3, $22FE, $232D, $235C,	$238F, $23C5, $23FF
		dc.w $243C, $247C, $2A5E, $2A84, $2AAB,	$2AD3, $2AFE, $2B2D
		dc.w $2B5C, $2B8F, $2BC5, $2BFF, $2C3C,	$2C7C, $325E, $3284
		dc.w $32AB, $32D3, $32FE, $332D, $335C,	$338F, $33C5, $33FF
		dc.w $343C, $347C, $3A5E, $3A84, $3AAB,	$3AD3, $3AFE, $3B2D
		dc.w $3B5C, $3B8F, $3BC5, $3BFF, $3C3C,	$3C7C

; =============== S U B	R O U T	I N E =======================================


sub_72850:				; DATA XREF: sub_71B4C+A8t
					; sub_71B4C+D2t ...
		subq.b	#1,$E(a5)
		bne.s	loc_72866
		bclr	#4,(a5)
		jsr	sub_72878(pc)
		jsr	sub_728DC(pc)
		bra.w	loc_7292E
; ===========================================================================

loc_72866:				; CODE XREF: sub_72850+4j
		jsr	sub_71D9E(pc)
		jsr	sub_72926(pc)
		jsr	sub_71DC6(pc)
		jsr	sub_728E2(pc)
		rts
; End of function sub_72850


; =============== S U B	R O U T	I N E =======================================


sub_72878:				; DATA XREF: sub_72850+At
		bclr	#1,(a5)
		movea.l	4(a5),a4

loc_72880:				; CODE XREF: sub_72878+16j
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#-$20,d5
		bcs.s	loc_72890
		jsr	sub_72A5A(pc)
		bra.s	loc_72880
; ===========================================================================

loc_72890:				; CODE XREF: sub_72878+10j
		tst.b	d5
		bpl.s	loc_728A4
		jsr	sub_728AC(pc)
		move.b	(a4)+,d5
		tst.b	d5
		bpl.s	loc_728A4
		subq.w	#1,a4
		bra.w	sub_71D60
; ===========================================================================

loc_728A4:				; CODE XREF: sub_72878+1Aj
					; sub_72878+24j
		jsr	sub_71D40(pc)
		bra.w	sub_71D60
; End of function sub_72878


; =============== S U B	R O U T	I N E =======================================


sub_728AC:				; DATA XREF: sub_72878+1Ct
		subi.b	#-$7F,d5
		bcs.s	loc_728CA
		add.b	8(a5),d5
		andi.w	#$7F,d5
		lsl.w	#1,d5
		lea	word_729CE(pc),a0
		move.w	(a0,d5.w),$10(a5)
		bra.w	sub_71D60
; ===========================================================================

loc_728CA:				; CODE XREF: sub_728AC+4j
		bset	#1,(a5)
		move.w	#$FFFF,$10(a5)
		jsr	sub_71D60(pc)
		bra.w	sub_729A0
; End of function sub_728AC


; =============== S U B	R O U T	I N E =======================================


sub_728DC:				; DATA XREF: sub_72850+Et

; FUNCTION CHUNK AT 00072920 SIZE 00000006 BYTES

		move.w	$10(a5),d6
		bmi.s	loc_72920
; End of function sub_728DC


; =============== S U B	R O U T	I N E =======================================


sub_728E2:				; DATA XREF: sub_72850+22t
		move.b	$1E(a5),d0
		ext.w	d0
		add.w	d0,d6
		btst	#2,(a5)
		bne.s	locret_7291E
		btst	#1,(a5)
		bne.s	locret_7291E
		move.b	1(a5),d0
		cmpi.b	#-$20,d0
		bne.s	loc_72904
		move.b	#-$40,d0

loc_72904:				; CODE XREF: sub_728E2+1Cj
		move.w	d6,d1
		andi.b	#$F,d1
		or.b	d1,d0
		lsr.w	#4,d6
		andi.b	#$3F,d6
		move.b	d0,($C00011).l
		move.b	d6,($C00011).l

locret_7291E:				; CODE XREF: sub_728E2+Cj
					; sub_728E2+12j
		rts
; End of function sub_728E2

; ===========================================================================
; START	OF FUNCTION CHUNK FOR sub_728DC

loc_72920:				; CODE XREF: sub_728DC+4j
		bset	#1,(a5)
		rts
; END OF FUNCTION CHUNK	FOR sub_728DC

; =============== S U B	R O U T	I N E =======================================


sub_72926:				; DATA XREF: sub_72850+1At

; FUNCTION CHUNK AT 0007299A SIZE 00000006 BYTES

		tst.b	$B(a5)
		beq.w	locret_7298A

loc_7292E:				; CODE XREF: sub_72850+12j
		move.b	9(a5),d6
		moveq	#0,d0
		move.b	$B(a5),d0
		beq.s	sub_7296A
		movea.l	(Go_PSGIndex).l,a0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	(a0,d0.w),a0
		move.b	$C(a5),d0
		move.b	(a0,d0.w),d0
		addq.b	#1,$C(a5)
		btst	#7,d0
		beq.s	loc_72960
		cmpi.b	#-$80,d0
		beq.s	loc_7299A

loc_72960:				; CODE XREF: sub_72926+32j
		add.w	d0,d6
		cmpi.b	#$10,d6
		bcs.s	sub_7296A
		moveq	#$F,d6
; End of function sub_72926


; =============== S U B	R O U T	I N E =======================================


sub_7296A:				; CODE XREF: sub_72926+12j
					; sub_72926+40j
					; DATA XREF: ...
		btst	#1,(a5)
		bne.s	locret_7298A
		btst	#2,(a5)
		bne.s	locret_7298A
		btst	#4,(a5)
		bne.s	loc_7298C

loc_7297C:				; CODE XREF: sub_7296A+26j
					; sub_7296A+2Cj
		or.b	1(a5),d6
		addi.b	#$10,d6
		move.b	d6,($C00011).l

locret_7298A:				; CODE XREF: sub_72926+4j sub_7296A+4j ...
		rts
; ===========================================================================

loc_7298C:				; CODE XREF: sub_7296A+10j
		tst.b	$13(a5)
		beq.s	loc_7297C
		tst.b	$12(a5)
		bne.s	loc_7297C
		rts
; End of function sub_7296A

; ===========================================================================
; START	OF FUNCTION CHUNK FOR sub_72926

loc_7299A:				; CODE XREF: sub_72926+38j
		subq.b	#1,$C(a5)
		rts
; END OF FUNCTION CHUNK	FOR sub_72926

; =============== S U B	R O U T	I N E =======================================


sub_729A0:				; CODE XREF: sub_728AC+2Cj
					; DATA XREF: sub_71D9E:loc_71DBEt ...
		btst	#2,(a5)
		bne.s	locret_729B4

loc_729A6:				; DATA XREF: Snd_FadeOut2+44t
		move.b	1(a5),d0
		ori.b	#$1F,d0
		move.b	d0,($C00011).l

locret_729B4:				; CODE XREF: sub_729A0+4j
		rts
; End of function sub_729A0


; =============== S U B	R O U T	I N E =======================================


sub_729B6:				; CODE XREF: Sound_ChkValue+67Aj
					; sub_725CA+3Ej
					; DATA XREF: ...
		lea	($C00011).l,a0
		move.b	#-$61,(a0)
		move.b	#-$41,(a0)
		move.b	#-$21,(a0)
		move.b	#-1,(a0)
		rts
; End of function sub_729B6

; ===========================================================================
word_729CE:	dc.w $356, $326, $2F9, $2CE, $2A5, $280, $25C, $23A, $21A
					; DATA XREF: sub_728AC+10t
		dc.w $1FB, $1DF, $1C4, $1AB, $193, $17D, $167, $153, $140
		dc.w $12E, $11D, $10D, $FE, $EF, $E2, $D6, $C9,	$BE, $B4
		dc.w $A9, $A0, $97, $8F, $87, $7F, $78,	$71, $6B, $65
		dc.w $5F, $5A, $55, $50, $4B, $47, $43,	$40, $3C, $39
		dc.w $36, $33, $30, $2D, $2B, $28, $26,	$24, $22, $20
		dc.w $1F, $1D, $1B, $1A, $18, $17, $16,	$15, $13, $12
		dc.w $11, 0

; =============== S U B	R O U T	I N E =======================================


sub_72A5A:				; DATA XREF: sub_71C4E+1At
					; sub_71CEC+12t ...
		subi.w	#$E0,d5
		lsl.w	#2,d5
		jmp	loc_72A64(pc,d5.w)
; End of function sub_72A5A

; ===========================================================================

loc_72A64:
		bra.w	loc_72ACC
; ===========================================================================
		bra.w	loc_72AEC
; ===========================================================================
		bra.w	loc_72AF2
; ===========================================================================
		bra.w	loc_72AF8
; ===========================================================================
		bra.w	loc_72B14
; ===========================================================================
		bra.w	loc_72B9E
; ===========================================================================
		bra.w	loc_72BA4
; ===========================================================================
		bra.w	loc_72BAE
; ===========================================================================
		bra.w	loc_72BB4
; ===========================================================================
		bra.w	loc_72BBE
; ===========================================================================
		bra.w	loc_72BC6
; ===========================================================================
		bra.w	loc_72BD0
; ===========================================================================
		bra.w	loc_72BE6
; ===========================================================================
		bra.w	loc_72BEE
; ===========================================================================
		bra.w	loc_72BF4
; ===========================================================================
		bra.w	loc_72C26
; ===========================================================================
		bra.w	loc_72D30
; ===========================================================================
		bra.w	loc_72D52
; ===========================================================================
		bra.w	loc_72D58
; ===========================================================================
		bra.w	loc_72E06
; ===========================================================================
		bra.w	loc_72E20
; ===========================================================================
		bra.w	loc_72E26
; ===========================================================================
		bra.w	loc_72E2C
; ===========================================================================
		bra.w	loc_72E38
; ===========================================================================
		bra.w	loc_72E52
; ===========================================================================
		bra.w	loc_72E64
; ===========================================================================

loc_72ACC:				; CODE XREF: ROM:loc_72A64j
		move.b	(a4)+,d1
		tst.b	1(a5)
		bmi.s	locret_72AEA
		move.b	$A(a5),d0
		andi.b	#$37,d0
		or.b	d0,d1
		move.b	d1,$A(a5)
		move.b	#-$4C,d0
		bra.w	loc_72716
; ===========================================================================

locret_72AEA:				; CODE XREF: ROM:00072AD2j
		rts
; ===========================================================================

loc_72AEC:				; CODE XREF: ROM:00072A68j
		move.b	(a4)+,$1E(a5)
		rts
; ===========================================================================

loc_72AF2:				; CODE XREF: ROM:00072A6Cj
		move.b	(a4)+,7(a6)
		rts
; ===========================================================================

loc_72AF8:				; CODE XREF: ROM:00072A70j
		moveq	#0,d0
		move.b	$D(a5),d0
		movea.l	(a5,d0.w),a4
		move.l	#0,(a5,d0.w)
		addq.w	#2,a4
		addq.b	#4,d0
		move.b	d0,$D(a5)
		rts
; ===========================================================================

loc_72B14:				; CODE XREF: ROM:00072A74j
		movea.l	a6,a0
		lea	$3A0(a6),a1
		move.w	#$87,d0

loc_72B1E:				; CODE XREF: ROM:00072B20j
		move.l	(a1)+,(a0)+
		dbf	d0,loc_72B1E
		bset	#2,$40(a6)
		movea.l	a5,a3
		move.b	#$28,d6
		sub.b	$26(a6),d6
		moveq	#5,d7
		lea	$70(a6),a5

loc_72B3A:				; CODE XREF: ROM:00072B60j
		btst	#7,(a5)
		beq.s	loc_72B5C
		bset	#1,(a5)
		add.b	d6,9(a5)
		btst	#2,(a5)
		bne.s	loc_72B5C
		moveq	#0,d0
		move.b	$B(a5),d0
		movea.l	$18(a6),a1
		jsr	sub_72C4E(pc)

loc_72B5C:				; CODE XREF: ROM:00072B3Ej
					; ROM:00072B4Cj
		adda.w	#$30,a5
		dbf	d7,loc_72B3A
		moveq	#2,d7

loc_72B66:				; CODE XREF: ROM:00072B7Cj
		btst	#7,(a5)
		beq.s	loc_72B78
		bset	#1,(a5)
		jsr	sub_729A0(pc)
		add.b	d6,9(a5)

loc_72B78:				; CODE XREF: ROM:00072B6Aj
		adda.w	#$30,a5
		dbf	d7,loc_72B66
		movea.l	a3,a5
		move.b	#-$80,$24(a6)
		move.b	#$28,$26(a6)
		clr.b	$27(a6)
		startZ80
		addq.w	#8,sp
		rts
; ===========================================================================

loc_72B9E:				; CODE XREF: ROM:00072A78j
		move.b	(a4)+,2(a5)
		rts
; ===========================================================================

loc_72BA4:				; CODE XREF: ROM:00072A7Cj
		move.b	(a4)+,d0
		add.b	d0,9(a5)
		bra.w	sub_72CB4
; ===========================================================================

loc_72BAE:				; CODE XREF: ROM:00072A80j
		bset	#4,(a5)
		rts
; ===========================================================================

loc_72BB4:				; CODE XREF: ROM:00072A84j
		move.b	(a4),$12(a5)
		move.b	(a4)+,$13(a5)
		rts
; ===========================================================================

loc_72BBE:				; CODE XREF: ROM:00072A88j
		move.b	(a4)+,d0
		add.b	d0,8(a5)
		rts
; ===========================================================================

loc_72BC6:				; CODE XREF: ROM:00072A8Cj
		move.b	(a4),2(a6)
		move.b	(a4)+,1(a6)
		rts
; ===========================================================================

loc_72BD0:				; CODE XREF: ROM:00072A90j
		lea	$40(a6),a0
		move.b	(a4)+,d0
		moveq	#$30,d1
		moveq	#9,d2

loc_72BDA:				; CODE XREF: ROM:00072BE0j
		move.b	d0,2(a0)
		adda.w	d1,a0
		dbf	d2,loc_72BDA
		rts
; ===========================================================================

loc_72BE6:				; CODE XREF: ROM:00072A94j
		move.b	(a4)+,d0
		add.b	d0,9(a5)
		rts
; ===========================================================================

loc_72BEE:				; CODE XREF: ROM:00072A98j
		clr.b	$2C(a6)
		rts
; ===========================================================================

loc_72BF4:				; CODE XREF: ROM:00072A9Cj
		bclr	#7,(a5)
		bclr	#4,(a5)
		jsr	sub_726FE(pc)
		tst.b	$250(a6)
		bmi.s	loc_72C22
		movea.l	a5,a3
		lea	$100(a6),a5
		movea.l	$18(a6),a1
		bclr	#2,(a5)
		bset	#1,(a5)
		move.b	$B(a5),d0
		jsr	sub_72C4E(pc)
		movea.l	a3,a5

loc_72C22:				; CODE XREF: ROM:00072C04j
		addq.w	#8,sp
		rts
; ===========================================================================

loc_72C26:				; CODE XREF: ROM:00072AA0j
		moveq	#0,d0
		move.b	(a4)+,d0
		move.b	d0,$B(a5)
		btst	#2,(a5)
		bne.w	locret_72CAA
		movea.l	$18(a6),a1
		tst.b	$E(a6)
		beq.s	sub_72C4E
		movea.l	$20(a5),a1
		tst.b	$E(a6)
		bmi.s	sub_72C4E
		movea.l	$20(a6),a1

; =============== S U B	R O U T	I N E =======================================


sub_72C4E:				; CODE XREF: ROM:00072C3Ej
					; ROM:00072C48j
					; DATA XREF: ...
		subq.w	#1,d0
		bmi.s	loc_72C5C
		move.w	#$19,d1

loc_72C56:				; CODE XREF: sub_72C4E+Aj
		adda.w	d1,a1
		dbf	d0,loc_72C56

loc_72C5C:				; CODE XREF: sub_72C4E+2j
		move.b	(a1)+,d1
		move.b	d1,$1F(a5)
		move.b	d1,d4
		move.b	#-$50,d0
		jsr	sub_72722(pc)
		lea	byte_72D18(pc),a2
		moveq	#$13,d3

loc_72C72:				; CODE XREF: sub_72C4E+2Cj
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		jsr	sub_72722(pc)
		dbf	d3,loc_72C72
		moveq	#3,d5
		andi.w	#7,d4
		move.b	byte_72CAC(pc,d4.w),d4
		move.b	9(a5),d3

loc_72C8C:				; CODE XREF: sub_72C4E+4Cj
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		lsr.b	#1,d4
		bcc.s	loc_72C96
		add.b	d3,d1

loc_72C96:				; CODE XREF: sub_72C4E+44j
		jsr	sub_72722(pc)
		dbf	d5,loc_72C8C
		move.b	#-$4C,d0
		move.b	$A(a5),d1
		jsr	sub_72722(pc)

locret_72CAA:				; CODE XREF: ROM:00072C32j
		rts
; End of function sub_72C4E

; ===========================================================================
byte_72CAC:	dc.b   8,  8,  8,  8	; 0
		dc.b  $A, $E, $E, $F	; 4

; =============== S U B	R O U T	I N E =======================================


sub_72CB4:				; CODE XREF: ROM:00072BAAj
					; DATA XREF: sub_72504:loc_72534t ...
		btst	#2,(a5)
		bne.s	locret_72D16
		moveq	#0,d0
		move.b	$B(a5),d0
		movea.l	$18(a6),a1
		tst.b	$E(a6)
		beq.s	loc_72CD8
		movea.l	$20(a6),a1
		tst.b	$E(a6)
		bmi.s	loc_72CD8
		movea.l	$20(a6),a1

loc_72CD8:				; CODE XREF: sub_72CB4+14j
					; sub_72CB4+1Ej
		subq.w	#1,d0
		bmi.s	loc_72CE6
		move.w	#$19,d1

loc_72CE0:				; CODE XREF: sub_72CB4+2Ej
		adda.w	d1,a1
		dbf	d0,loc_72CE0

loc_72CE6:				; CODE XREF: sub_72CB4+26j
		adda.w	#$15,a1
		lea	byte_72D2C(pc),a2
		move.b	$1F(a5),d0
		andi.w	#7,d0
		move.b	byte_72CAC(pc,d0.w),d4
		move.b	9(a5),d3
		bmi.s	locret_72D16
		moveq	#3,d5

loc_72D02:				; CODE XREF: sub_72CB4:loc_72D12j
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		lsr.b	#1,d4
		bcc.s	loc_72D12
		add.b	d3,d1
		bcs.s	loc_72D12
		jsr	sub_72722(pc)

loc_72D12:				; CODE XREF: sub_72CB4+54j
					; sub_72CB4+58j
		dbf	d5,loc_72D02

locret_72D16:				; CODE XREF: sub_72CB4+4j
					; sub_72CB4+4Aj
		rts
; End of function sub_72CB4

; ===========================================================================
byte_72D18:	dc.b $30, $38, $34, $3C, $50, $58, $54,	$5C, $60, $68
					; DATA XREF: sub_72C4E+1Et
		dc.b $64, $6C, $70, $78, $74, $7C, $80,	$88, $84, $8C
byte_72D2C:	dc.b $40, $48, $44, $4C	; DATA XREF: sub_72CB4+36t
; ===========================================================================

loc_72D30:				; CODE XREF: ROM:00072AA4j
		bset	#3,(a5)
		move.l	a4,$14(a5)
		move.b	(a4)+,$18(a5)
		move.b	(a4)+,$19(a5)
		move.b	(a4)+,$1A(a5)
		move.b	(a4)+,d0
		lsr.b	#1,d0
		move.b	d0,$1B(a5)
		clr.w	$1C(a5)
		rts
; ===========================================================================

loc_72D52:				; CODE XREF: ROM:00072AA8j
		bset	#3,(a5)
		rts
; ===========================================================================

loc_72D58:				; CODE XREF: ROM:00072AACj
		bclr	#7,(a5)
		bclr	#4,(a5)
		tst.b	1(a5)
		bmi.s	loc_72D74
		tst.b	8(a6)
		bmi.w	loc_72E02
		jsr	sub_726FE(pc)
		bra.s	loc_72D78
; ===========================================================================

loc_72D74:				; CODE XREF: ROM:00072D64j
		jsr	sub_729A0(pc)

loc_72D78:				; CODE XREF: ROM:00072D72j
		tst.b	$E(a6)
		bpl.w	loc_72E02
		clr.b	0(a6)
		moveq	#0,d0
		move.b	1(a5),d0
		bmi.s	loc_72DCC
		lea	dword_722CC(pc),a0
		movea.l	a5,a3
		cmpi.b	#4,d0
		bne.s	loc_72DA8
		tst.b	$340(a6)
		bpl.s	loc_72DA8
		lea	$340(a6),a5
		movea.l	$20(a6),a1
		bra.s	loc_72DB8
; ===========================================================================

loc_72DA8:				; CODE XREF: ROM:00072D96j
					; ROM:00072D9Cj
		subq.b	#2,d0
		lsl.b	#2,d0
		movea.l	(a0,d0.w),a5
		tst.b	(a5)
		bpl.s	loc_72DC8
		movea.l	$18(a6),a1

loc_72DB8:				; CODE XREF: ROM:00072DA6j
		bclr	#2,(a5)
		bset	#1,(a5)
		move.b	$B(a5),d0
		jsr	sub_72C4E(pc)

loc_72DC8:				; CODE XREF: ROM:00072DB2j
		movea.l	a3,a5
		bra.s	loc_72E02
; ===========================================================================

loc_72DCC:				; CODE XREF: ROM:00072D8Aj
		lea	$370(a6),a0
		tst.b	(a0)
		bpl.s	loc_72DE0
		cmpi.b	#-$20,d0
		beq.s	loc_72DEA
		cmpi.b	#-$40,d0
		beq.s	loc_72DEA

loc_72DE0:				; CODE XREF: ROM:00072DD2j
		lea	dword_722CC(pc),a0
		lsr.b	#3,d0
		movea.l	(a0,d0.w),a0

loc_72DEA:				; CODE XREF: ROM:00072DD8j
					; ROM:00072DDEj
		bclr	#2,(a0)
		bset	#1,(a0)
		cmpi.b	#-$20,1(a0)
		bne.s	loc_72E02
		move.b	$1F(a0),($C00011).l

loc_72E02:				; CODE XREF: ROM:00072D6Aj
					; ROM:00072D7Cj ...
		addq.w	#8,sp
		rts
; ===========================================================================

loc_72E06:				; CODE XREF: ROM:00072AB0j
		move.b	#-$20,1(a5)
		move.b	(a4)+,$1F(a5)
		btst	#2,(a5)
		bne.s	locret_72E1E
		move.b	-1(a4),($C00011).l

locret_72E1E:				; CODE XREF: ROM:00072E14j
		rts
; ===========================================================================

loc_72E20:				; CODE XREF: ROM:00072AB4j
		bclr	#3,(a5)
		rts
; ===========================================================================

loc_72E26:				; CODE XREF: ROM:00072AB8j
		move.b	(a4)+,$B(a5)
		rts
; ===========================================================================

loc_72E2C:				; CODE XREF: ROM:00072ABCj
					; ROM:00072E4Cj ...
		move.b	(a4)+,d0
		lsl.w	#8,d0
		move.b	(a4)+,d0
		adda.w	d0,a4
		subq.w	#1,a4
		rts
; ===========================================================================

loc_72E38:				; CODE XREF: ROM:00072AC0j
		moveq	#0,d0
		move.b	(a4)+,d0
		move.b	(a4)+,d1
		tst.b	$24(a5,d0.w)
		bne.s	loc_72E48
		move.b	d1,$24(a5,d0.w)

loc_72E48:				; CODE XREF: ROM:00072E42j
		subq.b	#1,$24(a5,d0.w)
		bne.s	loc_72E2C
		addq.w	#2,a4
		rts
; ===========================================================================

loc_72E52:				; CODE XREF: ROM:00072AC4j
		moveq	#0,d0
		move.b	$D(a5),d0
		subq.b	#4,d0
		move.l	a4,(a5,d0.w)
		move.b	d0,$D(a5)
		bra.s	loc_72E2C
; ===========================================================================

loc_72E64:				; CODE XREF: ROM:00072AC8j
		move.b	#-$78,d0
		move.b	#$F,d1
		jsr	sub_7272E(pc)
		move.b	#-$74,d0
		move.b	#$F,d1
		bra.w	sub_7272E
; ===========================================================================
Kos_Z80:	dc.b $E1,$FF,$F3,$FF,$31,$FC,$1F,$DD,$21,  0,$40,$AF,$32,$FD,$FF,$8F,$1F,$32,$FF,$1F,$3E,  1,$32,  0,$60,  6,  8,$3E,  7,$FF,$FF,$F9; 0
					; DATA XREF: SoundDriverLoad+12o
		dc.b  $F,$10,$FA,$18,$10,  0,  1,  2,  4,  8,$10,$20,$40,$80,$FF,$3F,$FC,$FE,$FC,$F8,$F0,$E0,$C0,$21,$DC,$7E,$B7,$F2,$35,  0,$FF,$7F; 32
		dc.b $D6,$81,$77,$FE,  6,$30,$78,$11,  0,  0,$FD,$21,$D6,  0,$CB,$27,$FA,$C3,$FE,  6,  0,$4F,$FD,  9,$FD,$5E,$EE,$56,$FF,$C3,  1,$FD; 64
		dc.b $4E,  2,$FD,$46,  3,$D9,$16,$80,$21,$A9,$72,$1F,$1E,$DD,$36,  0,$2B,$1E,$2A,$ED,  4,$DD,$72,  1,$FE,$F8,$F5,$D9,$26,  0,$1A,$E6; 96
		dc.b $F0, $F,$FF,$C6,$22,$6F,$7F,$FC,$7E,$D9,$82,$57,$75,$DD,$73,  0,$E6,$74,$41,$10,$FE,$60,$38,$D9,$E6,$EA,$F8,$13,$3A,$8B,$CB,$7F; 128
		dc.b $C2,$FC,$C3,$6D,$13, $B,$79,$B0,$C2,$77,  0,$C3,$F6,$11,$FF,$E1,$88,$96,$21,$78,$69, $E,$2A,$1A,$DD,$71,$DA,$77,  1,$E1,$A7,  6; 160
		dc.b  $B,$DA,$13,$2B,$7D,$B4,$C2,$C1,$E3, $F,$F0,$EE,  0,$52,  3,$17,$67,$2B,  4,$70,  7,$F8,$31,  1,$F8,$B0, $B,$16,$10,$1B,$F8,$90; 192
		dc.b  $A,$FF,$FC,$FF,$FD,$E9,$91,$3B,$C7,$FD,$52,$DD,$53,$FF,$FF,$BF,$7D, $F,$76,$ED,$7E,$FE,$8D,$64,$EE,$77,$E9,$6E,$65,$3D,$54,$F1; 224
		dc.b $7F,$2D,$50,$E2, $D,$4B,$2E,$ED,$C4,$FD,$5D,$DD,$EC,$CB,$FC,$FF,$CD,$4A,$B2,$59,$B3,$4C,$32,$44,$BA,$43,$44,$49,$51, $F,$FF,$44; 256
		dc.b $34,$53,$42,$44,$F7,$42,$43,$24,$34,$2B,$43,$19,$FF,$1F,$3B,$3A,$4C,  3,$BB,$2C,$1B,$BB,$AB,$BB,$CB,$AB,$CB,$BC,$E0,$21,$FE,$FF; 288
		dc.b $BB,$BC,$CA,$CA,$FC,$B9,$7C,$F8,$EF, $A,$B9, $A,$19, $A,$76,$33,  2,$32,$23,  3,$FE,$33,$33,$13,$FD,$FF,$23,$32,$34,$3B,$24,$FF; 320
		dc.b $FF,$23,$22,$21,$32,$11,$12,$21,$11,  9,  3,$9A,$A2,$2A,$9A,$10, $A,$FF,$FF,$A0,  9,$A9,$AB,  9, $B,$AA,$9B,$2A,$BA,$10,$BA,  1; 352
		dc.b $CA,$3A,  9,$FF,$FF,$AA,  2,$A9,$90,$92,$A0,$20,$A0,$1A,$21,$A2,$B2,$13,$BA,$3A,$12,$FF,$87,$B9,$93,$AA,  0,$9A,  0,$B2,$AA,$29; 384
		dc.b $B1,$AB,  1,$D6,$FF,$7F,$31,$BC,$22,  9,$20,$BA,$42,$B1,$21,$10,$23,$B0,$43,$AB,$32,$4A,$F8,$FF,$7C,$3C,$34,$2A,$40,$90,$4A,$22; 416
		dc.b   3,$A2,$11,$A3,$A0,$FF,$FF,$A3,$2B,$C3,$10,  0,$AB,$21,$B9,$20,$AA,$2A,$B3,$9B,$B2,$3B,$B0,$FF,$87,$9B,$90,$2B,$C9,$4B,$B9,$1A; 448
		dc.b $90,$1A,$A0,$39,$B2,$BD,$FF,$21,$22,$CA,$49,$B9,$B0,$29,$AA,$22,$A9,$12,$81, $B,$FC,$FF,$CE,$A0,$31,  1,  9,$22,$13,$9A,  3,$29; 480
		dc.b $92,$3B,$A2,$3A,$FF,$87,$A2,$A9,$10,$91,$9A,$30,$A9,$21,$B1,$3A,$AA,$30,$D0,$FF,$87,$39,$19,$3A,$92,$20,$21,  0,  1,$A2,$3B, $A; 512
		dc.b $20,$E9,$F1,$FF,$99,$1B,$6D,  1,$AA,$12,$A9,$99,$2B,$21,$BA,$11,$9B,$FF, $F,$A2, $B,$12,$AA,$A3, $A,$2A,  2,$91,$A1,$2A,$A2, $A; 544
		dc.b $FF,$FF,$B3,$22,$A3,  0,  0,$22,$99,  0,$29,$1B,$23,$B1,$A3,$B2,$2A,$22,$FF,$87,$1A,$13,$A1,$20,$11,$A1,$92,$90,$93,$AB,$24,$BA; 576
		dc.b $DA,$87,$FF,$31,$A1,$1A,$2A,$33,  9,$9A,$A4,$BB,$B3,$23,$B2,$A2,$87,$FF,$19,$B2,$3A,$A1,$10,$3B,$AA,$19, $A,$B2, $A,$A9,  4,$3F; 608
		dc.b $84,$CB,$33,$BA,  0,$93,$9A,$A2,$81, $A,$88,$C3,$E1,$33,$C3,$39,$44,  2,$11,  0,$F4,$21,$AA, $F,$FF,$32,$B9,$3B,$20,$A1,$6E,$C2; 640
		dc.b $4C,$A3,$1A,$A3,$10,$B2,$FF,$FF,$29,$22,$9B,$12,$4B,$B0,$32,  2, $A,$33,$99,$93,$31,$B0,  2,$13,$E1, $F,$B0,  0,$74, $B,  9,  9; 672
		dc.b $1C,$A3,$2A,$AA,$1F,$3E,$A7,$2A,$A0,$22,$AB,$12,$10,$AA,$2B,$10,$1A,$99,$7C,  8,$AB,$19,$91,$A2,$1A,$9A,$83,$A0,$61,  8,$4A,$12; 704
		dc.b $68,$A1,$11,$A6,$10,$C3,$FF,$FA,$39,  1,$73,$39,$2A,$33,$1B,$33, $A,$32,$92,$A1,$1F,  0,  9,$A2,$99,$90,$BA,  3,$3F,$DF,$C2, $F; 736
		dc.b  $D,$A3, $B,$9B,  2,$AB,$10,$B0,  9,$FF,$C3,$55,$A2,$20,$C3,$30,  0,$B9,$91,$2A,$B1,$1A,$92,$A3,$C3,$3F,$AA,$31,$A0,  8,$92,$A9; 768
		dc.b $13,$AA,  2,  9,$11,$AA, $C,$87,$28,$19,  1,$74,$12,$A0,$99, $E,$F0,$7F,$12,$73,  0,$20,  2,$12,$29,$93,$12,  1,  1,  2,$2A,$F8; 800
		dc.b $1F,$AA,$9A,$1A,$20,$2A,$90,  9,  0,$90,$A1,$9A, $E,$87,$8A,$A9,$A0,$19,$28,$91,$9A,  0,$6D,$FF, $F,$2A,$99, $A,  2,$A0,$91,  9; 832
		dc.b   1,$90,$92,  9,$19,  0,$87,$F8,$C4,$10,$A1,  0,$47,$10,$F7,  9,$10,$21,$61,$80,$A1,$21,$21,$11,$20,$C4,$FB,$A1,$DF,$91,$19,$F6; 864
		dc.b $10,$6A,$E9,$10,$90,  0,$91,$91,$A1,$E9,$87,$80,$99,$10,  9,$99,$FB,$1A,$B2,$20,$C0,$B0,$C4,$5B,$EB,$C2,$CD,$91,  0,$34,  1,$76; 896
		dc.b $F4,$EC,$90,$10,$80,  8,$E9,$BA,$4D,$E9,$E6,$80,$A2,$F8,$29,$C3,$FD,$FD,$FC, $C,  8,$21,$EA,$FF,$8A,$C4,$40,$80,$FA,$92,$C1,$FC; 928
		dc.b $40,$92,$A6,$FE,$F7, $B,$EB,$AC,  8,$8A,$F2,$FC,$F7,$B1,  0,$EB,$FD,$FD,$94,$58,$AD,$FC,  1,$EB,$E6,$FF,$F8, $A,$22,$99,$AE,$FB; 960
		dc.b $6A,$FC,$FC,$C5,$FF,$ED,$BD,$E5,$D2,$9A,$19,$A9,$BD,$EE,$D6,$56,$55,$FF,$FF,$56,$7F,$47,$1F,$2E,$7D,$2D,$DD,$ED,$CD,$DA,$D5,$5F; 992
		dc.b $D7,$F2,$77,$FF,$FF,$FD,$84,$FF,$66,$6E,$D7,$FF,$56,$6D,$D6,$F5,$66,$E5,$46,$AE,$6C,$FF,$FF,$D6,$F6,$5E,$64,$E3,$47,$58,$25,$7D; 1024
		dc.b $C6,$34,$3D,$EF,$71, $C,$DC,$1F,$FE, $D,$4D,$BC,$B1,$AA,  2,$26,$AC,$EE,$C3,$55,$54,$55,$FF,$FF,$55,$51,$43,$34,  4,$56,$54,$ED; 1056
		dc.b $DE,$DD,$EE,$47,$ED,$72,$E5,$6C,$FF,$FF,$E6,$6E,$49,$2E,$75,$AD,$DE,$1D,$CC,$BC,$CC,$E4,$5D,$DE,$67,$5E,$FF,$FF,$CB,$E5,$64,$C4; 1088
		dc.b $53,$EB,$66,$EA,$47,$DF,$56,$DE,$42,$53,$45,$65,$FF,$FF,$E3,$66,$CD,$E4,$DD,$DD,$DE,$4C,$D5,$4D,$E5,$DE,$D4,$67,$53,$6C,$FF,$FF; 1120
		dc.b $6C,$6A,$FC,$4E,$D4,$4E,$DB,$73,$E4,$6D,$46,$45,$A3,$4E,$3D,$49,$FF,$FF,$14,$B5,$E5,$BD,$DE,$BE,$46,$53,$65,$5C,$EC,$6C,$DD,$5C; 1152
		dc.b $ED,$6C,$FF,$E1,$DE,$66,$4D,$ED,$4D,$C5,$55,$43,$ED,$5D,$C7,$30,$54,$FF,$FF,$44,$45,$C5,$54,$4E,  6,$ED,$D5,$5E,$ED,$6D,$EC,$61; 1184
		dc.b $55,$6B,$4A,$FF,$FF,$AE,$D4,$54,$EC,$3B,$BD,$C6,$DD,$DB,$E3,$4C,$52,$56,$5D,$55,$57,$FF,$F0,$3E,$D4, $C,$CE,$CD,$DB,$52,$DD,$BB; 1216
		dc.b $52,$DC,$5C,$55,$FF,$FF,$D6,$6E,$C5,$16,$DE,$D5,$D1,$E5,$5E,$C4,$E4,$BC,$75,$6D,$E2,$6E, $F,$FF,$BA,$E4,$14,$B4,$DC,$6A,$C6,$3D; 1248
		dc.b $56,$69,$14,$6B,$DE,$FF,$FF,$64,$EC,$CE,$DD,$F7,$54,$CE,$7C,$E7,$CB,$CE,$B5,$A7,$DD,$66,$ED,$FF,$C3,$C6,$EE,$DD,$34,$BC,$DD,$56; 1280
		dc.b $EA,$6C,$55,$C5, $F,$DD,  1,$FE,$CD,$46,$B1,$81,$36,$E4,$4E,$BD,$52,$BD,$FF,$FF,$4C,$C3,$7E,$EA,$43,$6D,$2D,$46,$DD,$65,$BB,$4A; 1312
		dc.b $D4,$AE,$BD,$4B,$FF,$FF,$ED,$4C,$35,$6B,$C6,$6E,$5C,$CE,$53,$BD,$46,$24,$C9,$4D,$D5,$C5,$FF,$FF,$4E,$44,$13,$E5,$6A,$DE,$4D,$46; 1344
		dc.b $CC,$4E,$C4,$35,$35,$5C,$53,$A4,$C3,$FF, $E,$3B,$E1,$C4,$DB,$D5,$DD,$B5,$C5,$EA,$5D,$6D,$62,$FF,$FF,$DC,$56,$5E,$D4,$44,$CC,$CA; 1376
		dc.b $6B,$1D,$D6,$4E,$4D,$5C,$4D,$25,$6B,$FF, $F,$DC,$3E,$3C,$CA,$4C,$EE,$A5,$66,$5B,$C2,$63,$6C,$5E,$FF,$3F,$5D,$DC,$5E,$E6,$4B,$DD; 1408
		dc.b $C0,$F6,$66,$EE,$55,$D5,$65,$C3,$64,  4,$F8,$F1,$CD,$AA,$AD,$5D,$4C,$EC,$5D,$FF,$FF,$E6,$C5,$4B,$4C,$36,$C5,$D3,$BC,$64,$44,$AE; 1440
		dc.b $5C,$D3, $B,$B4,$E5,$FF,$FF,$BD,$51,$DC,$36,$CD,$55,$5D,$DC,$4D,$E3,$5C,$45,  0,$16,$65,$CE,$FF,$FF,$C5,$43,$D4,$D3,$4C,$EB,$2A; 1472
		dc.b $4D,$3D,$CC,$EA,$56,$5C,$44,$4B,$66,$FF,$FF,$23,$CD,$E2,$55,$EE,$D9,$4A,$2E,$B4,$C4,$1D,$61,$30,$56,$53,$D5,$FF,$FF,$34,$55,$DC; 1504
		dc.b $C1,$4D,$4D,$EC,$DD,$CC,$CE,$56,$91,$35,$6D,$95,$6C,$FF,$FF,$C6,$D4,$42,$AC,$BC,$CD,$CD,$A4,$DD,$24,$56,$E9,$51,$54,$BD,$44,$87; 1536
		dc.b   1,$AC,$34,$CD,$AD,$31,$A6,$5D,$9D,$E0,$FF,$61,$C1,$BD,$35,$E4,$E6,$DB,$DD,$55,$DD,$AD,$66,$FF,$FF,$CC,$56,$E2,$42,$45,$4B,$24; 1568
		dc.b $D0,$C2,$5B,$3D,$CD,$4E,$CC,$2B,$90,$FF,$87,$DB,$56,$44,$D3,$55,$33,$15,$BC,$C3,$4D,$DE,$65,$57,$FF,$3F,$CB,$24,$6C,$DE,$B7,$B3; 1600
		dc.b $1C,$4D,$C5,$5C,$ED,$2C,$29,$D4,$5C,$FC,$FF,$10,$C5,$A6,$54,$CD,$C9,$E6,$BD,$CD,$E5,$4D,$33,$32,$CA,$3F,$FC,$45,$D4,$45,$49,$4B; 1632
		dc.b $34,$25,$8C,$CC,$5D,$EB,$64,$AD,$FF,$FF,$4C,$B4,$54,$BB,$CC,$45,$CD,$36,$4C,$4D,$DA,$4C,$35,$4E,$90,$4B,$FF,$FF,$DE,$26,$64,$4D; 1664
		dc.b $3A,$3B,$53,$AA,$42,$CD,$BD,$3C,$4A,$CD,$5C,$40,$FF,$FF,$4B,$94,$45,$4D,$CC,$DD,$5D,$D4,$55,$6D,$CB,$52,$B5,$1B,$3C,$53,$C3,$FF; 1696
		dc.b $CB,$CC,  4,$9C,$56,$BE,$BA,$CD,$53,$B4,$55,$D0,$46,$FF,$FF, $D,$A3,$55,$45,$BD,$CA,$32,$5C,$DE,$C1,$D4,$B1,$CC,$51,$C3,$43,$E1; 1728
		dc.b $FF,$42,$55,$43,$5B,  4,$CD,$C4,$43,$B4,$6D,$A5,$DB,$59,$FF,$E1,$CC,$B0,$BC,$C5,$A3,$4B,$B1,$B6,$54,$EC,$BD,$56,$DC,$FF,$FF,$44; 1760
		dc.b $9B,$DD,$50,$DC,$A4,$BB,$34,$4C,$C4,$CD,$6A,$CD,$24,$CC,$46,$FF,$FF,$A4,$C3,$A5,$B1,$D4,$C3,$34,$BB,$CA,$C4,$4D,$AC,$B4,$3B,$3B; 1792
		dc.b $4B, $F,$FF,$D5,$59,$C5,$A2,$C4,$23,$4D,$3C,$CC,$54,$DD,$5A,$C3,$F0,$3F,$B2,  6,$49,$CA,$D5,$3B,$63,$C4,$CB,$41,$AB,$A4,$FC,$FF; 1824
		dc.b $AB,$A6,$4B,$1B,  3,$45,$23,$CB,$63,$DD,$C3,$3D,$C4,$DC,$FF,$F0,$53,$DC,$45,$40, $A,$5B,$CC,$55,$94,$97,$CD,$DA,$34,$FF,$FF,$AA; 1856
		dc.b $3B,$50,$B2,$44,$CE,$95,$5D,$C4,$45,$13,$4D,$B5,$AD,$1C,$59,$FF,$87,$D4,  3,$54,$C3, $C,$42,$D4,$5D,$C9,$DC,  2,$CB,$13,$FF,$F0; 1888
		dc.b $B1,  4,$13,$C0,$5C,$45,$5D,$E4,$53,$BA,$AC, $C,$B4,$F0,$FF,$2C,$D3,$43,$9B,$B3,$54,$4B,$BE,$3C,$15,$4A,$BC,$41,$FF,$F0,$D4,$4C; 1920
		dc.b $B0,$2D,$43,$12,$AC,$10,$34,$8F,$44,$BC,$BD,$7F,$F8,$9B,$23,$C4,$54,$3C,$23,$5C,$D5,$14,$93,$59,$C4,$C4,$F0,$FF,$32,$77,$54,$30; 1952
		dc.b $AD,$B2,$2D,  4,$33,$AA,$CD,$B4,  3,$FF,$FF,$12,$3C,$45,$AA,$42,$32,$35,$CB,$B4,$DB,$BB,$B4,$4B,$D4,$D2,$40,$FF,$FF,$D3,$44,$4C; 1984
		dc.b $52,$12,$CB,  4,$CC,$49,$BC,$14,$A2,$33,$3C,$B3,$4B,$FF,$FF,$CB,$34,$9B,$DC,$C2,$CA,$CC,$44,$C5,$64,$2C,$34,$CB,$C5,$5B,$D4,$FF; 2016
		dc.b $FF,$CC,$43,$A2,$2A,$2D,$D2,$53,  4,$3A,$C2,$C3,$45,$2C,$CC,  9,$AD,$FF,$FF,$C5,$CB,$BD,$15,$25,$44,$DA,$5C,$DC,$14,$C0,$CB,$45; 2048
		dc.b $54,$3B,$DB,$FF,$FF,$5B,$C3,$BC,$A4,$A1,$54,$CC,$94, $C,$22,$24,$9C,$BA,$25,$5C,$C4,$FF,$1F,$BC,$9C,$CB,$2B,$DD,$32,$C4,$34,$BC; 2080
		dc.b $45,$53,$41,$CD,$34,$FE,$FF,$F1,$14,$CB,$CB,$A4,$A4,$3C,$33,$23,$44,$2B,$A3,$4B,$DB,$BC,$FF,$FF,$DC,$34,$45,$3B,$4C,$33,$1B,$2B; 2112
		dc.b $BB,$33,$5C,$C9,$14,$CC,$3C,$B5,$FF,$FF,$3C,$CC,$A3,$BC,$B3,$BC,$53,$C2,$43,$CC,$B5,$53,$DD,$25,$54,$C9,$FF,$C3,$43,$B2, $C,$BD; 2144
		dc.b $34,$41,$3A,$49,$DD,$40,$CC,$5E,$53,$FF,$FF,$54,$BB,$AA,$2B,$1B,$C2,$3C,$1C,$C5,  4,$3C,$44,$CB,$39,$CD,$4B,$FF,$FF,$45,$BC,$DB; 2176
		dc.b $45,$CB,$44,$10,$23,$3C, $B,$34,$4B,$29,$2B,$CC,$D2,$FF,$FF,$92,$CA,$34,$1B,$33,$25,$2B,$BC,$B1, $C,$45,$BB,$CC,$53,$AB,$CC,$10; 2208
		dc.b $FE,$9B,$89,$5C,$D7,$45,$C4,$B4,$2A,$CC,$BB, $F,$FF,$DC,$CB,$3B,$24,$44,$3D,$2B,$C5,$5A,$DC,$44,$33,$AC,$E1,$FF,$CC,$AC,$33,$B2; 2240
		dc.b $B5,$3A,$B0,$4C,$BB,$A2,$44,  5,$CD,$FF,$3F, $B,$25,$4B,$BD,$30,$3B,$D4,$5B,$A4,$B4,$3A,$C3,$94,$4C,$CA,$FC,$7F,$BF,$AC,$33,$94; 2272
		dc.b $A3,$4A,$3C,$BB,$4B,$CA,$B4,$34,$2C,$30,$F8,$FF,$7F,$43,$AB,$C1,$44,$39,$9C,$D9,$44,$9A, $B,$30,  3,  7,$F8,$2B,$10,$CB,$12,$34; 2304
		dc.b $60, $C,$53,$CC,  2,$1F,$FE,$BC,  2,$43,$CB,$AA,$49,$A2,$AC,$42,$B1,$43,$1A,$3B,$FF,$3F,$CB,$4A,$1B,$92, $B, $C,$93,$A2,$23,$33; 2336
		dc.b $50,$3C,$2A,$A4,$1B,$FC,$FF,$7E,$D5,$4A,$C3,$45,$B3,$2D,$CA,$B2,$30,  2,$22,$A9,$A9,$FF,$FF,$9B,$B4,$BB,$BB,$43,$23,$CC,$3A,$34; 2368
		dc.b $A4, $C,$1C,$15,$39,$B3,$B3,$87,  1,$3A,$31,$9B,$44,$CD,$BB,$32,  6,$FE,$FF,$9A,$20,$CC,  4,$1B,$23,$3B,$CC,$44,$4B,$BC,$B4,$22; 2400
		dc.b $33,$BC,$10,$86,$32,$E9,$BA,$FC,$B4,$B4,  4,$C3,$C3,$AA,$C2,$4C,$8E,$93,$B9,$B0,$53,$DB,$BB,$FF,$FF,$C4,$2C,$29,$34,$BB,$99,$2A; 2432
		dc.b $1B,$24,$B1,$2B,$B4,$9B,$AB,$3C,$3B,$3F,$FC,$B3,$B0, $C,$14,$34,$3B,$BA,$70,$C3,$23,$B4,$13,$3A,$FF,$FF,$BC,$A2,$1A,$9C,$B0,$A2; 2464
		dc.b $41,$C1,$33, $B,$22,  4,$93,$42,$A1,$CB,$FF,$FF,$3C,$24,$9C,$B2,$BB,$90,$93,$20,$99,  3,$CA,$3A,$A4,$CA,$4A,$24,$FF,$FF,$40,$B4; 2496
		dc.b $1A,$4A,$CA,$AB,$3B,$CA,$43,$3B,$C0,$4A,$10,$CC,$C2,$1A,$FF,$FF,$94,$44,$3A,$21,$BC,$B5, $C,$AB,$B2,$90,$23,$43,  3, $B,$CC,$41; 2528
		dc.b $F0,$1F,$3C,$C6,$29,$33,$32,$32,$BA,$BC,$3A,$CB,$A3,$FE,$FF,$44,$BB,$AB,$43, $B,$B3,$34,$11,$24,$13,$9A,$B0,$A0,$2B,$CB,$F0,$FF; 2560
		dc.b $20,$ED,$1B,$94,$BB,$93,$53,$1C,$CB,$32,  2,$2B,$A3,$FF,$FF,$22,$44,$13,$CB,$93,$2B,$C0,$12,$1C,$CA,$9B,$92,$20,$B2,$2A,$23,$FF; 2592
		dc.b $FF,$A1,$43,$2B,$A1,$3B,  0,$13,$2A,$1A,$B9,$40,$AB,$33,$2A,$22,$BA,$1F,$FE,$C9, $A,$A0,$3A,$BB,$2B,$C2,$3C,$B3,$23,$51,$BB,$3B; 2624
		dc.b $FF,$F0,  9,$BC,$CB,$A0,$C2,$44,$CB,$11,$23,$55,$B4,$23,$CB,$FF,$87,$3B,$2A,$A1,$91,$1A,$93,$3C,$A2,$99,$34,$20,$B3,$CF,$C3,$FF; 2656
		dc.b $B2,$3A,$B0,$97,$92,$4C,$CB,$34,$A9,$19,$23,$A4,$59,$F8,$FF,$CB,  7,$9B,$19,$A4,$9B,$C9,$BB,$B4,$49,$C2,$42,$34,$FF,$FF,$2A,  2; 2688
		dc.b $AC,$94,$1C,$B2,$32,$AC,$B2,$43,$B0,$1B,$BA,$43,$20,$9A,$FF,$FF,$92,$3A,  9, $A,$CA,$20,$9B,$10,$1B,$13,$C3,$45,$AB,  4,$30,$AB; 2720
		dc.b $10,$20,  2,$41,$BA,$42,$4F,$39, $C,$FF,$DF,$30,$A3,$53,$9B,$BA,$B9,$22,$39,$30,$A9, $F,$FF,$9B,$A3,$49,$A0,$A9,$CE,$12, $C,$AC; 2752
		dc.b   3,$20,$20,$B1,$FF,$FF,$34,$9A,$2A,$AA,$24,$3B,$B0, $A,$39,$A3, $C,$A2,$BB,$32,$22,$AC,$E1,$1F,$BA,$93,$97,$20,$B0,$19,$A2,$A1; 2784
		dc.b $A3,$3B,$B2,$E0,$FF,$E2,$24,$9A,$22,$21,$B3,$3A,$A1,$93,$A9,  0,$A1,$E1,$FF,$32,$A1,$AF,$22,$1C,$93,$33,$3B,$23,$3A,  1,$BC,$A1; 2816
		dc.b $FF,$FF,$BB,$2A,$B9,$B9,  3,$42,$49,$9A,$1B,$B4,$3A,$A9,$33,$22, $B,$34,$E1,$8F,$AB,$CB,  8,  1,$4B,$A2,$2A,$A2,  1,$BB,$1F,$FE; 2848
		dc.b $FB,$39,$39,$AA,$10,$19,$1B,  2,  1,$23,$42,$B2,$3B, $F,$FF,$A1,$3A,$CB,$93,$AB,$DD,$93,$21,  1,$CA,  2,  2,$3A,$FF,$C3,  3,$29; 2880
		dc.b $AA,$21,$AA,$22,$BA,$A1,$2A,  1,$9A,$FF,$B3,$FD,$30,$23,$2B,$79,$B1,$B3,$32,$B0,$3A,$A0,$59,$B9,$33,$3C,$FC,$2F,$20,$C0,$32,$B2; 2912
		dc.b $DF,$30,$92,$23,$1B,$39,$C3,$E1,$1C,$B3,$31,$DC,$AB,$BA,$31,$4F,$A0,  1,$1F,$E0,$11,$29,$91,$23,$29,$9B,$D7,$FE,$AB,$A1,$7F,$F8; 2944
		dc.b $91, $A,$3A,$A3,$31,$CB,$34, $B,$E8,$B1,$22,$11,$B0,$FF,$FF,$29,$31,$22,$A2,$3A,$B0,$11,$20,  0,$21,$2A,$92,$22,  2,$9C,$23,$FF; 2976
		dc.b $FF,$31,$BB,$13,  9,$21,$99,$91,$10,$21,$B0,$49,$AA,$AB, $A,$23,$39,$3F,$FC,$B1,$2A,$22,$AB,$92,$A0,$90,$39,$12,  0,  2,$29,$A9; 3008
		dc.b $FF,$FF,$B2,$2B,$92,$92,$91,$B9,$19,$1B,$B0,$10,  2,$A2,$32,$A0,$A3, $A,$FF,$87,$B2,$B2,$3A,$B9,$90,$21,$1A,$2B,$B2,$39,  0,$13; 3040
		dc.b $E5,$FF,$FF,$12,$AB,$B2,$45,$4D,$E0,$54,$34,$4C,$DE,$6E,$EC,$B3,$4B,$56,$66,$FF,$FF,$55,$63,  3,$32,$DE,$FE,$57,$DE,$DE,$DC,$15; 3072
		dc.b $3D,$EB,$B5,$76,$66,$FF,$FF,$43,$5E,$FC,$AD,$CC,$EB,$44,$BB,$73,$C0,$2D,$DC,$13,$21,$BC,$CC,$FF,$FF,$A3,$64,$25,$65,$66,$50, $A; 3104
		dc.b $DD,$CC,$25,$3D,$DD,$C6,$AE,$FE,$DD,$FF,$E1,$42,$30,$63,$DD,$56,$CE,$B5,$DC,$45,$45,$BC,$54,$BB,$E1,$FF,$43,$3A,$DE,$CC,$DC,$3B; 3136
		dc.b $DC,$DC,$55,$51,$56,$65,$45,$FF,$FF,$5A,$2C,$EA,$33,$9B,$3D,$D0,$3C,$DB,$9B,$EE,$DA, $C,$EC,$43,$44,$FF,$FF,$45,$5C,$D9,$64,$DC; 3168
		dc.b $1C,$44,$66,$46,$6C,$D4,$53,$DE,$EE,$BB,$D3,$FF,$87,$55,$55,$33,$23,$CC,$A5,$59,$24,$3D,$CA,$BB,$BE,$F8,$87,$FF,$4B,$44,$4D,$D9; 3200
		dc.b $C4,$DD,$CE,$46,$5B,$BA,$44,$44,$43,$FF,$87,$13,$65,$55,$3B,$B9,$35,$1B,$B3,$42,$BC,$DB,$3C,$74,$FF,$FF,$46,$54,$5B,$ED,$40,$DC; 3232
		dc.b $DA,$3C,$44,$33,$52,$DB,$55,$CD,$DD,$B2,$FF,$FF,$49,$ED,$A5,$6C,$25,$DC,$66,$45,$3D,$24,$34,$52,$25,$4B,$BA,$DB,$FF,$FF,$49,$D2; 3264
		dc.b $3C,$42,$BB,$CC,$EE,$24,$3C,$BC,$34,$93,$4A,$CD,$DC,$2C,$FF,$FF,$45,$49,$C4,$55,$44,$5C,$DC,$BB,  3,$BD,$A5,$5A,$45,$35,$2B,$CB; 3296
		dc.b $FF,  3,$65,$CA,$2B,$9C,$DD,$54,$C3,$52,$DC,$D4,$50,$46,$FC, $F,$E1,$CD,$BB,$B4,$54,$AD,$A5,$BC,$55,$B4,$43,$FF,$10,$D8,$44,$54; 3328
		dc.b $DA,$63,$C4,$DD,$C9,$AB,$63,$B4,$FE,$C3,$CF,$54,$ED,$CC,$C3,$B9,$54,$B3,$BA,$64,$9C,$E3,$FF,$FF,$A0,$BA,$30,$3A,$4A,$24,$CA,$55; 3360
		dc.b $43,$1B,$19, $C,$44,$95,$49,$43,$FF,$1F,$B4,$49,$5C,$E4,$5D,  4,$DC, $B,$D5, $E,$45,$3B,$CB,$33,$FE,$FF,$1D,$54,$CC,$35,$AD,$56; 3392
		dc.b $3E,$CA,$DA,$CA,$44,  3,$53,$15,$42,$FF,$FF,$B3,$32,$4B,$24,$CD,$24,$4C,$A1,  3,$50,$45,$CD,$D9,$CD,$14,$2D,$FF,$FF,$D2,$3D,$45; 3424
		dc.b $3C,$C3,$B2,$B1,$BB,$B3,$44,$4C,$D9,$33,$53,$D3,$5C,$FF,$FF,$A4,$40,$32,$BC,$AA,$23,$25,$5C,$CA,$15,$5D,$CB,$DC,$40,$C5,$4D,$FF; 3456
		dc.b $C3,$95,$BC,$A3,$33,$CC,$CD,$43,$EC,$53,$D2,$45,$F8,  4,$FF,$FF,$3C,$9A,$B3,$40,$B5,$4B,$35,$42,$2B,$D1,$A1,$53,$C9,$9C,$C3,$3B; 3488
		dc.b $FF,$3F,$33,$CB,$3C,$A5,$CC,$2B,$C3,$31,$9B,$C2,$B2,$43,$4A,$CC,$D2,$FC,$FF,$95,$3B,$DB,$54,$32,$14,$43,$CC,$C5,$4C,$C2,$BA,$45; 3520
		dc.b $4B,$FF,$FF,$CC,$94,$50,$AA,$B4,$3D,$C0,$3C,$CB,$44,$BA,$A1,$4B,$CB,$AB,$BB,$FF,$FF,$42,$DA,$43,$C3,$50,$B9,$C3,$1C,$34,$33,$29; 3552
		dc.b $3C,$B4,$42,$94,$BC,$FF,$FF,$24,$44,$1D,$CA,$BC,$45,$B9,$CC,$44,$32,$CB,$4B,$B0,$BC,$AB,$9A,$FF,$FF,$DB,$43,$45,$AC,$B0,$2C,$44; 3584
		dc.b $1C,$AB,$B2,$44,$C0,$40,$9C,$35,$4C,$FF,$F7,$C4,$2C,$C3,$33,$32,  4,$AC,$3A,$29,$CB,$34,$B2,$78,$C9,$C2,$BC,$FF,$E1,$94,$4A,$CB; 3616
		dc.b $2C,$C2,$32,$AC,  2,$24,$23,$C9,$B0,$2B,$1F,$FE,$B1,$13,$3A,$A4,$3B,$C3,$99,$A4,$CD,$A3,$22,$BC,$DA,$FF,$FF,$39,$B4,$54,$DD,$B1; 3648
		dc.b $43,$9B,$BB,$BA,  4,$2C,$34,$39,$29,$C0,$4B,$C3,$FF,$C4,$39,$BB,$1E,$34,  2,$4C,$C3,$43,  3,$A0,$3A,$CA,$FF,$F0,$5A,$CA,$43,$32; 3680
		dc.b $AB,$BC,$2B,$C9,$41,  4,$3B,$CA,  4,$7F,$F8,$2B,$14,$4C,$DB,$A0,$19,$A2,$31,$7F,$30,$3C,$B3,$39,$FF,$FF,$33,$BB,$34,$30,$DC,$55; 3712
		dc.b $CD,$C4,$4C,$B4,$BD,$C4,$53,$BB,$CC,$33,$FF,$C3,$A0,$2A,$CB,$33,$B1,$1C,$13,$42,$C1,$3A,$90,$DE,$2B,$87,$FF,$CC,$92,$33,$34,$52; 3744
		dc.b $43, $A,$C9,$30,$33,$3C,$DC,$93,$E1,$FF,$33,$33,$64,$BA,$CD,$DB,$44,$2A,$B3,$AC,$C4,$49,$AB,$FF,$FF,$B1,$A0,$43,$43,$BD,$C3,$54; 3776
		dc.b $10,$13,$90,$22,  1,$23,$2A,$A1,$21,$7F,$F8,$B9,$32,$BC,$93,$BA,$1B,$C9,$43,$97,$B2,$4B,$BA,$20,$FF,$E1,$A3,$2B,$CA,$A3,$39,$21; 3808
		dc.b $13,$3B,$34,$2A,$9F,$21,$BC,$FF,$70,$11,$BB,$43,$A2,$34, $C,$B9,$2A,$33,$AB,$AB,$B0,$3A,$F8,$FF, $C,$2C,$B0,$BB,$13,$AC,$CB,$14; 3840
		dc.b $42,  0,$CC,$22,$22,$FF,$1F,$99,$B4,$5A,$13,$BB,$33,$A3,$21,$20,$32,$4A,$CA,$10,$A4,$1E,$FE,$DB,$A2,$2A,$B2,$BB,$DD,$13,$32,$BB; 3872
		dc.b $9A,$99,$23,$FF, $F,$3A,$C3,$40,$CB,$32,$24,$2A,$24,$2C,$BA,$10,$A2,$4A, $F,$FF,$DB,$49,$B9,$12,$39,$E8,$A1,$A9,$9A,$23,$10,$1B; 3904
		dc.b $A3,$FF,$FF,$10,$BC,$BA,$BA,$93,$3A,$2B,$BA,$9A,$BA,$44,$91,$12,$20,$A0,$29,$FF,$FF,  0,  3,$23,$43,$9B, $B,$24,$3C,$A3,$43,$AC; 3936
		dc.b $A9,$A0,$AB,$12,$BC,$FF,$FF,$29,$A2,$AC,$B2,$A2,$33,$A1,$1B,$B2,$22,$3A,$BA,$BC,$34,$32,$30,$FF,$87,$22,$AA,$33,$9A,$33,$9B,$BA; 3968
		dc.b $33, $A,$1C,  4,$42,$A1,$FF,$FF,$39,$23,$AB,$AA,$B3,$4B,$CC,  3,$43,$AB,$BA,$BB,$21,$CB,$93,$3B,$FF,$BF,$14,$1C,$B9,$33,$AB,  4; 4000
		dc.b $53,$AB,$A9,$91,$33,  9,$34,$30,$AA,  3,$FC,$3D,$E1,$1A,$C0,$2F,$3A,$CB,$34,$BC,$B1,$A2,$BD,  1,$20, $A,$5B,$99,$22,$2B,$A3,$32; 4032
		dc.b $E1,$23,$59,$1E,$E0,$DC,$33,  0,$AB,$B2,$C7,$E5,$19,$22,$7F,$18,$BC,$A4,$31,$1A,$BA,  9,$AA,$AB,$C3,$1B,$A0,$FE,$87,$FA,$BB,$94; 4064
		dc.b $43,$3B,$23, $B,$C2,$44,$3A,$12,$58,$E1,$F0,$A0,$2A,$EC,$23,$2B,$BB,$EA,$B9,$30,$BC,$FF,$FF,$12,$10,$2B,$CC,$93,$21,$21,$90,  0; 4096
		dc.b $13,$29,$9B,$14,$30,$90,$10,$F7,$FF,  0,$22,$1B,$B0,$DB,$D1,$BB,$93,$99,$21,$2A,$B0,$21,  9,  0,  1,$E1,$3F,$1A,$12,$12,$13,$2B; 4128
		dc.b $CA,$AB,$93,$1A,$A2,$32,$AA,$FC,$FD,$43,  3,$32,  2,$33,$12,$21,  0,$65,$F1,$12,$2B,$91,$A0,$FF,  1,$30,$AB,$92,$AA,$2A,$BB,$AB; 4160
		dc.b $B0,$B2,$30,$CF,  0,$FE,  2,$CD,$76,$29,$A3,$32, $A,$A1,$32,$FF,$F1,$32,$A9,  9, $A,$B3,$39,$10,$A0,$99,$43,$3E,$11,  2,$FF,$1F; 4192
		dc.b $29,  9,$12, $A,$21,$BB,$BB,$12,$92,$31,$BC,$AA,$20,$A9,$FE,  0,$DA,$11,$22,  9,$21,$A9,$34,$23,$10,$F0,$F1,$A6,$AD,$33, $B,$AA; 4224
		dc.b $BA,$1A,$75,  2,$9B,$E1,$FF,$BC,$A1,$81,$10,$90,$22,$33,$9B,$91,$A1,$33,$30, $B,$FF,$87,  2,$31,$91,$2A,$A0,$32,  1,$2A,$BA,$A9; 4256
		dc.b   1,$22,$C3,$F0,$5E,$91,$A1,$12,$19,$12,$90,  0,$D9,$BB,$22,$99,$5A,$D1,  8,$FF,$25,  2,$C0,$32,$9A,$23,$19,  0,$91,$33,$3F,$84; 4288
		dc.b $3A,$A9,$23,$9A,$AA,$A9,$AA,  2,$BB,$FA,$10,$FE,$11,$87,$A0,$88,$1A,$A0,$12,$31,$99,$12,$3F,$C0,$33,$22,$19,$A9,$92,$33,$19,$A4; 4320
		dc.b $CE,$11, $F, $F,$12,  0,  9,$BA,$A2,$19,$99,$13,$19, $A,$FF,$1F,$B4, $B,$92,$2A,  0,$AB,$91,$10,$10,$AB,$12,$32,$1A,$90,$E0,  7; 4352
		dc.b $A6,$B7,$21,  1,$90,$21,$AB,$A2,$D5,$28,$C0,$35,  0,$EF,$89,$B3,$18,$99,$10,$FE,$A9,$EB,$9A,$99,$22,$A0,  9,$13,$49,$91,$7F,$80; 4384
		dc.b $9A,$22,$90,$A9,$22,$22,$AA,  0,$A6,$BA,$1F,$FE,$92,$20,$AB,$B9,  1,$23,$1C,$22,$9A,$BA,$9A,$B0,  0,$87,  1,$90,$12,$29,$AB,$F5; 4416
		dc.b $22,$20,$5D, $E,  3,$2C,$19,$A0,$43,  4,$9A,$A9,$E0,$84,$FF,$D3,$AA,$5D,$BA,  3,$10,$2A,$B9,$9A,$12,$22,  1,$8E,$AB,$B3,$79,$D2; 4448
		dc.b $23,$11,$19,$30,$FC,$DD,$A5,$29,$99,$C8,$A2,$20,$9A,$B9,  0,$FF,  3,$22,  1,$19,$90,$AA,$AA,$12, $A,$90,  1,$11,$49,  0,$40,$AC; 4480
		dc.b $53,$E1,$49,$32,$38, $C,$D1,$23,$29,$A9,$FB,  0,$9A,$1F,$60,$E2,$AA,$BA,$BA,$99,$99,$63,$F5,$B0,$19,$80,$E1,$E1,$D7,  2,$31,$F4; 4512
		dc.b $33,$20,$F0,$43,$11,$F7,$39,$9A,$90,$10,  1,$21,$A0,$91,$78,$61,$AA,$AA,$22,  9,$99,$C4,$91,$9D,$B9,$AA,$80,  1,$56,  5,$22, $B; 4544
		dc.b   2,  2, $C,$75,$22,$1B,$FD,  1,$12,  3,$1C,$FD,  9,$AA,$A5,$90,$BB,$AA,$AB,  6,$F8,$99,$A0,$23,$B9,$56,$10, $A,  3,$21,$87,$C1; 4576
		dc.b   0,  0,  2,$32,$C7,$91,$20,$38,$87,$F1,$10,$60,$1A,$C9,$10,$3A,$EF,$9A,$99,$80,$10,$F9,$94,$11,$86,  9,$3E,  4,  1,  0,$11,$12; 4608
		dc.b   9,$A0,$63,$12,$7B,  0,$80,$51,$98,$9F,$F3,$1F,$42,$19,$9A,$AB,$99,$91,$1A,$BA,$B9,$BE,$99,$80, $F,$E8,$64,$90,$92,$32,  0,$99; 4640
		dc.b $80,$10,$40,$B5, $E,$5B,$23,$1C,  4,$FC,$FC,$F1,$AA,  0,$BE,$81,$91,$E9,$80,  1,$99,$FC,$11,  9,$B7,$7E,$78,$A6,$20,$91,$23,$33; 4672
		dc.b   9,$91,$D0,$21,$12,$19,$A9,  4,$10,$30,$56,$79,$E3,$F1,$C2,$61,$40,  0,$87,  2,$22,$1A,$FD,$22,$29,$38,  4,$AA,$32,$19,$91,$9C; 4704
		dc.b $90,$FE,  8,$7D,$96,$9A,$53, $A,$33,$91,$21,$29,$9A,  9,  4,  4,$F9,$BA,$70,$C4,$70,$18,$4E,$97,$79,$12,$23,$D5,$10,$19,  6,$80; 4736
		dc.b $E6,$11,$11,$C1,$BD,$E9,  0,  0,  9,$EC,$74,$9D,$88,  1,$E8,$58,$A2,$11,$1B,$10,  0,$F3,$BF,$8E,$B5,  1,$C0,$6A,$53,$F9,$9A,$BB; 4768
		dc.b $89,  0,$1E,$11,$C6,$8E,$85,$8A,$99,$90,$21,$E0,  0,$39,$4A,  9,$12,$32,$58,  0,$F0,$E1,$79,$A1,$7B,$AA,$A9,$99,$61,$10,$A9,$91; 4800
		dc.b $88, $A,$AA,$EA,$CE,$F1,$2C, $C,$BD,$4A,$8A,$20,$B8,$8A,$8F,$90,$10,$10,  1,$76,$B0,$91,$AF,$DC,$10,  7,$F4,$A6,$B9,$A0,$11,  7; 4832
		dc.b   5,$18,$F5,$E1,$1D,$F1,$90,$E1,$92,$22,  4,$28,$D0,$C1,$F1,$7B,$74,$99,$C6,$F1, $C,$2A,$C5,$11,$20,$50,$FE,$E9,$CE,$F1,$CF,$82; 4864
		dc.b $22,  8,$BD,$FB,$82,$8C,$81,  1,$40,$93,$12,$AA,$6B,$B6,$B6,$81,  4,$40,$4E,$E7,$67,$75,  3,  0,$A4,$F1,$21,$89,$33,$A1,$C2,$85; 4896
		dc.b $59,$A3,$BA,$A9,$A9,$C6,$F1,$49,  0,  6,$12,$AA,$E8,$11,$89,  2,$9C,  3,$20,$3A,$81,$90,$5F,$6E,$44,  0,  8,$E6,$BF,$7D,$B8,$83; 4928
		dc.b   2,  4,$ED,$6B,$81,$EF,$11,$19,$BA,  0,  3,$8A,$74,$41,$81,$21,$BD,  4,$88,$E1,$9A,$77,$A0, $A,$17,$A3,$2E,  9,  9,$91,  6,$F1; 4960
		dc.b $35,$23,$34,  8,$80,$CD,$F1,$A1,$9A,$F7,  0,$80,$F4,$DA,$9C,$D2,$23,  0,$31,$99,$A0,$F1,$D8,$FD,  0,  8,$2F,$BF,$EE,$C4,$F1,  0; 4992
		dc.b $83,$CF,$15,$D9,$99,  2,$2F,$A2,  0,$EA,$F1,$AA,$71,$25,$6D,$E9,$77,  0,$A2,$E6,$BE,$F8,$CA,$E1,$62,  0,$88,$6D,$F2,$84,$E5,$E6; 5024
		dc.b $2C,  0,$31,$71,$18,$F1,$A1,$B7,$22,$50,$D9,$B7,$32,$9A,$11,  2,  8,$60,$74,$DE,$A9,$10,$42,$25,$E4,$12,$E5,$10,$B4,  2,$49,$51; 5056
		dc.b $63,$79,$AD,$EA,$F1,$D2,$F1,$F8,$63,$61,$82,  0,$30,$C7,  1,$BF,  8,$8B,$1B,$6F,$45,  1,$21,$C9,$79,$80,$AA,$91,$93,$E3,$3E,$7A; 5088
		dc.b $D5,$E9,  1,$F1,  8,$AA,$FC,$F1,$89,$E3,$61,$F2,$31,$F1,$C0,$F2,$80,  0,$69,$7A,$C5,$E5,$61,  1,$10,$EF,$19,$4B,$99,$E6,$C5,$88; 5120
		dc.b $32,$8C,$E9,$F7,$90,$BF,$20,$46,$FF,$B4,$4C,$F2,$BB,$A9,$8E,$94,$56,$9C,$2A,$F2,$5A,$21,$20,$E5,$F1,$D0,$E1,$54,  9,$38,$C9,$7A; 5152
		dc.b $B7,$EA,$90,$E9,$C7,$A3,$A8,$AF,$91,$B9,$63,$79,$DE,$EB,$F1,  0,$A8,$E5,$F2,$BB,$F5,$60,$4B,$E9,  8, $A,$89,$F1,$F4,$E1,$EB,$F2; 5184
		dc.b $CF,$F1,$40,$2A,$27,$B4,$CD,$F8,$71,$11,$79,$86,$FC,$8A,$22,$29,  8,$F4,$B6,$36,$64,$32,$A2,  4,$76,$49,$CC,$F1,$4E,$24,$54,$93; 5216
		dc.b $2E,$64,$F2,$61,$10,$4C,$E9,$21,$7A,  4,$14,$AB,$C1,$2E,$B7,$73,  0,$25,$C3,$7D,$BE,$9F,$F1,$B1,$11,  8,$19,$F1,$EC,$BE,$46,  9; 5248
		dc.b $44,$E1,$DE,$EA,  5,$D9,$4C,$14,$D1,$8E,$F3,$F1,$FF,$CC,$8F,$72,$82,$8C,$19,  0,$FA,$FC,$43,$EC,$73,$A4,$22,$3A,$DB,$CB,$EB,$72; 5280
		dc.b $E2,$EA,$F2,$91,  1,$91,$F2,$8F,$5C,$71,$58,$12,$69,$F1,$A3,  2,$E7,$F1,$D8,$DF,$E9,$95,$55,$D5,$AF,$73,$A3,$D9,$B9,$64,$F1,$A8; 5312
		dc.b $FE,$2F,$73,$51,$51,$61,$F2,$44,$C2,$EB,$63,$E9,$9F,$3F,$F2,$15,$59,$FF,$EA,$47,$E9,$40,$F1,$DD,$BF,$A3,$EA,$40,$15,$E5,$ED,$4F; 5344
		dc.b $77,$34,$E9,$EA,$F5,  9,$41,$D9,$8A,$E4,$B8,$31,$EA,  0,$95,$CF,$B7,$2F,$E9,$FF,$F3,$75,$EB,$24,  2,$D9,$D0,$F2,$6D,$C5,$74,  5; 5376
		dc.b $25,$86,$F2,$B7,$FC,$EB,$5E,$F1,$DF,$6A,$D5,  5,$15,$78,$F1,$C5,$6B,$EE,$7B,$E2,$2A,$F3,$D4,$F2,$95,$44,$7A,$84,$F1,$EA,$EA,$8B; 5408
		dc.b $90,$69,$C4,$44,$11,$8D,$CA,$91,$6B,$EA,$99,  0,$B1,$2D,$BC,$D8,$45,$11,$D0,$63,$E9,$C2,$72,$FC,  3,$91,$19,$ED,$5F,$6D,$C9,$25; 5440
		dc.b $52,$B8,$25,$F2,$CE,$2D,$BF,$F2,$A8,$FD,$56,  9,$DE,$18,$F3,$E2,$F2,$D5,$F2,$2C,$91,$50,$D1,$DF,$EA,$5D,$B5,$F2,$15,$25,$32,$F2; 5472
		dc.b $A8,$F3,$19,$6A,$31,  8,$F2,$7B,$89,$50,$66,$EC,$C5,$46,$70,$2C,$E1,$94,$58,$A9,$EF,$E9,$78,$E3,$B9,$EC,$99,$55,$D4,$EA,$BF,$76; 5504
		dc.b $74,$F4,$6C,$F5,$F3,$E3,$14,$91,$D5,$84,$63,$BE,$8E,$54,  6,$E6,  1,$F1,$8D,$EB,$EB,$EC,$19,$FA,$46,$95,$C6,$5A,$FF,$F4,$BB,$F1; 5536
		dc.b $64,$FC,$19,  9,$1C,$44,$29,  6,$51,$64,$78,$17,$D1,$F5,$BB,$58,$95,$94,$C1,$E9,$49,$F2,$82,$FC,$89,$B7,$F2,$2E,$F4,$64,$54,$EC; 5568
		dc.b $1C,$F2,$5E,$BA,$5E,$F6,$BD,$F3,$52,$65,$A9,$E7,$F4,$C8,$F2,$F5,$DA,$FE,$EB,$86,$49,$94,$17,$EB,$EA,$E9,$E3,$FE,$A7,$F3,$94,$65; 5600
		dc.b $D8,$BF,$F2,$38,$F3,$8B,$3A,$EB,$BE,$46,$96,$8C,$E5,$14,$EA,$F5,$94,$59,$33,$B7,$F4,$F1,$E4,$A7,$76,$49,$F2,$94,$55,$FE,$A4,$F2; 5632
		dc.b $9F,$1E,$EB,$62,$F3,$47,$E2,$62,$45,$2D,$9C,$BA,$FC,$29,$5B,$D3,$92,$48,$41,$92,$E4,$FE,$19,  5,$F3,$99,$95,$EC,$F2,$A2,$EA,$5F; 5664
		dc.b $EB,$16,$D3,$44,$25,$E9,$17,$EC,$E2,$45,$DB, $A,$5A,$CF,$59,$51,$EF,$D2,$51,$A7,$F3,$77,$F5,$30,$A3,$E5,$59,$52,$BB,$E3,$E5,$BA; 5696
		dc.b $F5,$6F,$DD,$53,$E4,$F6,$65,$55,$37,$F3,$2F,$FC,$61,$E3,$F2,$1E,$E3,$93,$E2,$30,$FC,$95,$55,$5F,$E4,$FE,$F2,$3D,$E3,$D2,$A4,$F4; 5728
		dc.b $A8,$38, $C,  4,$E4,$59,$65,$ED,$E7,  8,$55,$53,$45,$FC,$D1,$F3,  1,$55,$55,$8C,$FC,$3C,$53,$BE,$FC,$9E,$54,$6E,$56,$60,$DA,$D0; 5760
		dc.b $FC,$C5,$D3,$65,$55,  7,$CA,$B7,$F6,$73,$4E,$D5,$BB,$FD,$B6,$F5,$C2,$4D,$95,$54,$2C,$56,$FF,$FE,$D7,$F3,$72,$EB,$DC,$30,$FC,$D0; 5792
		dc.b $F4,$56,$65,$FD,$1F,$EB,$B4,$48, $B,$E1,$FD,$1C,$DD,$D2,$56,$55,$A8,$18,$FF,$18,$EA,$1C,$EF,$D6,$EC,$20,$EC,$E9,$F3,$55,$56,$C3; 5824
		dc.b $48, $A,$EA,$F7,$EC,$FE,$BE,$EF,$47,$D1,$FF,$BC,$EC,$55,$96,$64,$37,$B2,$EC,$33,$FD,$BA,$F8,$10,$8F,$E7,$FC,$94,$55,$5E,  0,$FD; 5856
		dc.b $1E,$EC,$18,$D7,$F6,$B4,$FD,$B9,$FC,$55,$55,$E9,$F4,$EA,$F7,$EE,$FC,$BA,$FE,$CF,$FC,$BD,$F4,$47,$E4,$EE,$D3,$55,$55,$EA,$F0,  9; 5888
		dc.b $C1,$BA,$CE,$FD,$5D,$F7,$EE,$47,$BE,$ED,$BC,$F0, $C,$A5,$E3,$55,$55,$14,$FD,$A0,$FC,$EB,$F0,  9,$36,$42,$2D,$F8, $A,$EC,$F0,  9; 5920
		dc.b $31,$E9,$E8,$F3,$55,$51,$A0,$F8,  9,$8B,$F3,$17,$F5,$BA,$FF,$EA,$F0, $C,$FF,  0,$F0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 5952
Music81:	dc.w  $687, $603, $103,	$646,	 0,  $30,$F412,	 $FC,	$B, $1E1,$F414,	$302,$F408, $413,$F420,	$532,$D001,    3, $5CD,$D003,	 6, $63A,    3,	   4,$EF02,$E040,$F800,$7BE0,$C0E0,$80D9, $4E0,$40D5,$E601,$F700, $DFF,$F3D9, $480,$14E6,$EBE0,$C080,$4080,$8080,$8080,$EF06,$F00D, $107, $4E9,$F480,$20F8,  $60,$C938,$F800,$5BC9, $808,$CDE9,	$CEF, $6E9,$F4CB,$34E7,$34C9, $8CB,$CD38,$E738,$C908; 0
					; DATA XREF: ROM:MusicIndexo
		dc.w $C9CD,$CC34,$E734,$C908,$CCCB,$1CE7,$1CEF,	$5E9,$F4E6, $A80, $8D9,	$C80, $4E8, $BD9, $8DA,$D9DC,$E814,$D910,$E80B,$D508,$E800,$E6F6,$E918,$F6FF,$A6D2, $4CE,$D2CE,$D4D0,$D4D0,$D5D2,$D5D2,$D7D4,$D7D4,$E3D5, $8D2,$10D5, $8D4,$10D5, $8D4,$10D0,$30D2, $8D9,$D710,$D508,$D410,$D508,$D410,$D038,$D508,$D210,$D508,$D410,$D508,$D410,$D030,$D208, $8CE,$10D2, $8D0,$10D2, $8D0,$10E3,$EF00,$E201; 64
		dc.w $8008,$A2AE,$A2A3,$AFA4,$B0E8, $4EF, $1A5,	$8F7,  $18,$FFFA,$E800,$A504,$80A5, $8A2, $480,$A208,$A304,$80A3, $8A4,	$480,$A408,$E804,$A508,$F700,$1DFF,$FAE8,  $A5,$A7A9,$EF01,$F800,$47F8,	 $76,$E800,$A5A7,$A9F8,	 $3C,$F800,$6BA5,$A5A5,$E800,$EF00,$A318,$A2A0,$9E9D, $880,$9B80,$A218,$A4A5,$A7A9, $880,$AE80,$AD18,$ACAA,$A8A7, $880,$A580,$A018,$A7A0,$AC08,$9DA9,$9EAA,$A0AC,$E804,$E201; 128
		dc.w $F6FF,$B6E8, $4AA,	$8AA,$AAAA,$AAAA,$AAE8,	 $AA,$E804,$A9A9,$A9A9,$A9E8,  $A5,$A7A9,$E804,$AAAA,$AAAA,$AAAA,$AAE8,	 $AA,$E804,$A9A9,$A9A9,$A9E8,  $A5,$A7A9,$E3E8,	$4AA,$AAAA,$AAAA,$AAAA,$E800,$AAE8, $4A9,$A9A9,$A9A9,$A9A9,$E800,$A9E8,	$4A7,$A7A7,$A7A7,$A7A7,$E800,$A7E8, $4A5,$A5A5,$A5A5,$E3EF, $2E0,$80F8,$FECA,$EF08,$E0C0,$E9E8,$E6FE,$8001,$C901,$E7C8,	$F80, $8C7, $1E7,$C60F,$8008; 192
		dc.w $F700, $2FF,$EEC9,	$1E7,$C807,$8008,$C701,$E7C6, $780, $8CA, $1E7,$C90F,$8008,$C901,$E7C8,	$F80, $8C7, $1E7,$C610,$E73B,$8004,$C701,$E7C6,	$F80, $8C9, $1E7,$C80F,$8008,$CA01,$E7C9, $780,	$8F7,	 2,$FFE7,$CA01,$E7C9, $F80, $8C9, $1E7,$C828,$E73E,$E602,$E918,$EF05,$E9E8,$F800,$85D2,$F800,$81D9,$F800,$7DD2,$8024,$80D5, $480, $CD2,$10D0, $480,$D280,$D580,$F4EF, $5F8,  $6F,$D004,$D2D5; 256
		dc.w  $8D2,$F800,$66D0,	$4D2,$D508,$D9F8,  $5D,$D004,$D2D5, $8D2,$E606,$BDBA, $480,$1680,$E6FA,$D908,$80D5,$80D2,$D2D2,	$480,$D580,$D980,$E918,$EF07,$E0C0,$E81E,$E606,$C218,$1818,$1808,$80C2,$80C1,$1818,$1818, $880,$C180,$C018,$1818,$1808,$80C0,$80C6,$1818,$1818,	$880,$C680,$E6FA,$E800,$F6FF,$7680,$3480,$D004,$D2D5, $8E3,$E606,$C108,$BD04,$8012,$80C1, $8BD,	$480,$BF08,$BC04,$800E,$80E6; 320
		dc.w $FAE3,$EF08,$8020,$80E0,$80E9,$E8E6, $AC5,	$1E7,$C40F,$8008,$C301,$E7C2, $F80, $8F7,    2,$FFEE,$C501,$E7C4, $780,	$8C3, $1E7,$C207,$8008,$C701,$E7C6, $F80, $8C5,	$1E7,$C40F,$8008,$C301,$E7C2,$10E7,$3C80, $4C3,	$1E7,$C20F,$8008,$C501,$E7C4, $F80, $8C7, $1E7,$C607,$8008,$F700, $2FF,$E7C7, $1E7,$C60F,$8008,$C501,$E7C4,$28E7,$3FE6,$F6E9,$18F4,$EF05,$E9E8,$E618,$E080,$E6FD,$F800,$85BF; 384
		dc.w $BFC1,$C1BD,$BDBA,$BAB6,$B6BF,$BFBC,$BCB8,$B8BF,$BFF8,  $70,$B5B5,$BDBD,$BABA,$B6B6,$B3B3,$BCBC,$E603,$E918,$E9F4,$EF04,$D010,$D2D4,$E6F9,$D528,$E728,$D710,$D4D0,$D528,$E728,$D410,$D0D4,$D528,$E728,$D710,$D4D0,$D540,$E740,$E90C,$E607,$E6E8,$EF07,$E81E,$E0C0,$E612,$BF18,$1818,$1808,$80BF,$80BD,$1818,$1818,	$880,$BD80,$BD18,$1818,$1808,$80BD,$80C2,$1818,$1818, $880,$C280,$E6EE,$E800; 448
		dc.w $F6FF,$70C1, $8C1,$BDBD,$BABA,$B6B6,$BFBF,$BCBC,$B8B8,$E3EF, $380,$2080,$EF08,$E040,$E9E8,$E6F2,$C201,$E7C1, $F80,	$8C0, $1E7,$BF0F,$8008,$F700, $2FF,$EEC2, $1E7,$C107,$8008,$C001,$E7BF,	$780, $8C3, $1E7,$C20F,$8008,$C201,$E7C1, $F80,	$8C0, $1E7,$BF10,$E73C,$8004,$C001,$E7BF, $F80,	$8C2, $1E7,$C10F,$8008,$C301,$E7C2, $780, $8F7,	   2,$FFE7,$C301,$E7C2,	$F80, $8C2, $1E7,$C128,$E73F; 512
		dc.w $E918,$E60E,$EF05,$E9E8,$E040,$E6FD,$F800,$94BF,$BFC1,$C1BD,$BDBA,$BAB6,$B6BF,$BFBC,$BCB8,$B8BF,$BFF8,  $7F,$B5B5,$BDBD,$BABA,$B6B6,$B3B3,$BCBC,$E918,$E603,$E9F4,$EF04,$E102,$D010,$D2D4,$E6F9,$D528,$E728,$D710,$D4D0,$D528,$E728,$D410,$D0D4,$D528,$E728,$D710,$D4D0,$D540,$E740,$E90C,$E100,$EF04,$E9F4,$E6FA,$D308,$CED7,$CED3,$CED7,$CEF7,	 2,$FFF3,$D2CD,$D5CD,$D2CD,$D5CD,$F700,	$2FF; 576
		dc.w $F4D1,$CCD5,$CCD1,$CCD5,$CCF7,    2,$FFF4,$D5D2,$D9D2,$D5D2,$D9D2,$F700, $2FF,$F4E6, $DE9,	$CF6,$FF63,$C108,$C1BD,$BDBA,$BAB6,$B6BF,$BFBC,$BCB8,$B8E3,$F505,$F00E,	$101, $380,$40E8,$10C1,$18BF,$C1BF,$C108,$80BF,$80C2,$18C1,$E800,$BF28,$E728,$E810,$BF18,$C1C2,$10BF,$18C1,$C210,$18E8,	 $C1,$34E7,$34F4,$F501,$8010,$C904,$8014,$C908,$8020,$C804,$8014,$C808,$8010,$F701, $3FF,$EA80,$10C6; 640
		dc.w  $480,$14C6, $880,$20C4, $480,$14C4, $880,$10F7,	 2,$FFD1,$F505,$D318,$D2D0,$CECD, $880,$CB80,$C618,$C8C9,$CBCD,	$880,$D280,$D118,$D0CE,$CCCB,$10C9, $880,$8008,$D0D2,$D010, $8D2,$8010,$EC01,$C618, $880,$C680,$ECFF,$F503,$F6FF,$9880,$40EC,$FEE8, $6D5, $8D4,$D2D0,$D5D4,$D2D0,$F700,	$8FF,$F1E8,  $F5, $180,$10CD, $480,$14CD, $880,$20CB, $480,$14CB, $880,$10F7, $103,$FFEA,$8010,$C904; 704
		dc.w $8014,$C908,$8020,$C804,$8014,$C808,$8010,$F700, $2FF,$D1CB,$34E7,$34C9, $8CB,$CD38,$E738,$C908,$C9CD,$CC34,$E734,$C908,$CCCB,$F505,$BD18,$1818,$1808,$80BD,$80F5,	$3F6,$FFAA,$F3E7,$E806,$C610,$1010, $8F6,$FFFD,$8008,$8182,$8181,$8282,$8281,$1082, $881,$1008,$8210,$F700, $7FF,$F381,$1082, $881,$1082, $808,	$881,$1082, $881,$1008,$8210,$F700, $7FF,$F381,$1082, $881,$1082, $808,	$8F7; 768
		dc.w  $102,$FFE4,$F6FF,$E108, $A70,$3000,$1F1F,$5F5F,$120E, $A0A,    4,	$403,$2F2F,$2F2F,$242D,$1380,$2036,$3530,$31DF,$DF9F,$9F07, $609, $607,	$606, $820,$1010,$F819,$3713,$8036, $F01, $101,$1F1F,$1F1F,$1211, $E00,	  $A, $709,$FF0F,$1F0F,$1880,$8080,$3D01, $202,	$214, $E8C, $E08, $502,	$500, $D0D, $D1F,$1F1F,$1F1A,$8080,$802C,$7278,$3434,$1F12,$1F12,   $A,	  $A,	 0,    0, $F1F,	$F1F; 832
		dc.w $1680,$1780,$2C74,$7434,$341F,$121F,$1F00,	   0,	 0, $100, $10F,$3F0F,$3F16,$8017,$8004,$7242,$3232,$1212,$1212,	   8,	 8,    8,    8,	$F1F, $F1F,$2380,$2380,$3D01, $202, $210,$5050,$5007, $808, $801,    0,	 $20,$1717,$171C,$8080,$802C,$7474,$3434,$1F12,$1F1F,	 7,    7,    7,	   7,  $38,  $38,$1680,$1780; 896
Music82:	dc.b   3,$D3,  6,  3,  2,  6,  3,$81,  0,  0,  0,$30,$F4, $C,  0,$AA,$E8, $D,  1,$47,$F4,$18,  1,$81,$F4,$18,  1,$90,  0,$12,  2,$13,$D0,  2,  0,  9,  2,$8B,$D0,  2,  0,  9,  2,$EB,  0,  2,  0,  4,$EF,  0,$80,$30,$80,  6,$C1,$C4,$C1,$C4,  9,$C6,$C8, $C,$C9,  6; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b $C8,$C6,$C4,  9,$C6,  6,$C4,  3,$C1,  6,$F7,  0,  2,$FF,$E6,$F8,  0,$38,$C9,  9,$CB,  6,$C9,  3,$C6,  6,$F8,  0,$2D,$C9, $C,$C6,$CB,  4,$C9,$CB,$C9,$24,$80,$30,$F8,  0,$2D,$C9, $C,$C9,  6,$C9,$CB,  9,$C9,$CD,$36,$F8,  0,$20,$CE,  6,$CD,$CB,$C9,$C7,$C6,$C4; 64
		dc.b $C2,$C1,$C9,$12,$80,$18,$F6,$FF,$AC,$80,$C6,$C9,$C6,$C9,  9,$CB,$CD, $C,$CE,  6,$CD,$CB,$E3,$C9, $C,$C9,  6,$C9,$CB,  9,$C9,$CE, $C,$CD,  6,$CB,$C9,$CB,  9,$CD, $F,$E3,$EF,  1,$E2,  1,$80,$12,$B3, $C,$B8,  3,$80,$B8,$80,  9,$B1, $F,$80,  3,$B5,$80,$B8,  9; 128
		dc.b $80,  3,$BA,  9,$80,  3,$BC, $F,$80,  3,$BA,$80,$B8,  9,$80,  3,$B5,  9,$80,  3,$F7,  0,  2,$FF,$E0,$B6, $F,$80,  3,$BA,$80,$BD,  9,$80,  3,$BF,  9,$80,  3,$C1, $F,$80,  3,$BF,$80,$BD,  9,$80,  3,$BA,  9,$80,  3,$F7,  0,  2,$FF,$E0,$B1, $F,$80,  3,$B5,$80; 192
		dc.b $B8,  9,$80,  3,$B5,  9,$80,  3,$BD,$80,$BD,  6,$B8,$BD,$B7,$18,$F8,  0,$1E,$B5,$80,$80,$B5,$BA,$80,$80,$BA,$BA,$18,$F8,  0,$11,$BB,$80,$80,$BB,$BD,$80,$80,$BD,$B8, $C,$B8,$E2,  1,$F6,$FF,$89,$B6,  6,$80,$80,$B6,$B5,$80,$80,$B5,$B3,$80,$80,$B3,$B1,$B3,$B5; 256
		dc.b  $C,$B6,  6,$80,$80,$B6,$E3,$E0,$80,$F8,  0,$21,$F0,  1,  1,  1,  4,$80,$60,$80,$80,$80,$80,$CD,$48,$CE, $C,$D0,$C9,$30,$80,$CD,$48,$CE, $C,$D0,$C9,$18,$CB,$CD,$D0,$F6,$FF,$E6,$EF,  3,$E8,  8,$D2,  6,$CE,$CB,$E8,  0,$D0, $A,$80,  2,$D0,  3,$80,$D0,$80,  9; 320
		dc.b $E3,$E0,$40,$E1,  2,$F8,$FF,$E5,$F0,  2,  1,  2,  4,$F6,$FF,$C2,$EF,  2,$E8,  8,$BD,  6,$BA,$B6,$E8,  0,$BD,  9,$80,  3,$BD,$80,$BD,$80,  9,$E6,  3,$EF,  4,$80,$4E,$B8,  3,$BA,$BD,$80,$BA,$80,$51,$C1,  3,$BD,$BA,$80,$BD,$80,$51,$BD,  3,$BF,$C2,$80,$BF,$80; 384
		dc.b $51,$C6,  3,$C2,$BD,$80,$C2,$80,$39,$B8,  6,$80,$BA,$80,$BB,  3,$80,$BB,$80,$BE,$80,$E8, $A,$F8,  0,$22,$80,  6,$BA,$80,$BC,$80,$BE,$BE,$C1,$F8,  0,$16,$E8,  5,$80,  6,$B8,  3,$BA,$BD,$BD,$BA,$B8,$F7,  0,  3,$FF,$F8,$E8,  0,$F6,$FF,$AB,$C1,$12,  6,$BF,$12; 448
		dc.b   6,$BD,$12,  6,$BC,$BD,$E8,$14,$BF, $C,$E8, $A,$C1,$12,  6,$BF,$12,  6,$E3,$D2,  3,$D2,$CE,$CE,$CB,$CB,$21,$F8,  0,$3C,$E9,  5,$F7,  0,  2,$FF,$F7,$E9,$F6,$80,  6,$CD, $C, $C, $C,  6,$80,  6,$CD,  3,  9, $C,$D3,$D3,  6,$F8,  0,$3C,$D0,  3,  9,  6,$80,  6; 512
		dc.b $D4, $C, $C,  3,  9,  6,$F8,  0,$2D,$D3,  3,  9,  6,$80,  6,$CD, $C,  6,$CB,$CE,$D2, $C,$F6,$FF,$C3,$80,  6,$CD, $C, $C, $C,  6,$80,$CD, $C, $C,  3,  9,  6,$80,$CD, $C, $C, $C,  6,$80,$CD, $C, $C,  3,  9,  6,$E3,$80,  6,$D2, $C,$D2,$D0,  3,  9,  6,$80,$CE; 576
		dc.b  $C, $C,$CD,  3,  9,  6,$80,$D2, $C, $C,$E3,$D5,  3,$D5,$D2,$D2,$CE,$CE,$21,$E9,  3,$F8,$FF,$C2,$E9,  5,$F7,  0,  2,$FF,$F7,$E9,$F3,$80,  6,$D0, $C, $C, $C,  6,$80,  6,$D0,  3,  9, $C,$D6, $C,  6,$F8,  0,$22,$D4,  3,  9,  6,$80,  6,$D7, $C, $C,$D6,  3,  9; 640
		dc.b   6,$F8,  0,$12,$D7,  3,  9,  6,$80,  6,$D0, $C,  6,$CE,  6,$D2,$D5, $C,$F6,$FF,$BF,$80,  6,$D5, $C, $C,$D4,  3,  9,  6,$80,$D2, $C, $C,$D0,  3,  9,  6,$80,$D5, $C, $C,$E3,$F3,$E7,$80,$12,$E8, $E,$C6, $C,$E8,  3,  6, $C,$F8,  0,$43,$F8,  0,$4C,$F8,  0,$3D; 704
		dc.b $E8, $E, $C,$E8,  3,  6,  6,  3,  3,  6,  3,  3,  6,$F8,  0,$2D,$F8,  0,$36,$F8,  0,$27,$F8,  0,$24,$F8,  0,$21,$F8,  0,$1E,$F8,  0,$34,  3,  3,$E8, $E,  6,$E8,  3,  3,  3,$E8, $E,  6,$F8,  0,$25,$EC,$FF,$E8, $E, $C, $C,$EC,  1,$F6,$FF,$BC,$E8, $E, $C,$E8; 768
		dc.b   3,  6,  6,  6,  6,  6,  6,$E3,$E8, $E, $C,$E8,  3,  6,  6,  6,  6,  6,  3,  3,$E3,$80,  3,$E8,  3,$C6,  6,  6,  3,$E8, $E,  6,$E8,  3,  6,  6,  6,  6,  6,  6,  6,  6,$E8,  3,  6,  6,  6,$E8, $E,  6,$E8,  3,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6; 832
		dc.b $E3,$82,  6,$82,$82,$81, $C,$82,  6, $C,$81,$12,$81,  6,$81, $C,$82,$F7,  0,  9,$FF,$F5,$81,$12,$81,  6,$81,$82,$82,$82,$F8,  0,$1A,$81, $C,$82,  6,$81,$81,  6,$82,$82, $C,$F8,  0, $D,$81, $C,$82,  6,$81,$81,$82,$82,$82,$F6,$FF,$D1,$81, $C,$82,  6,$81,$81; 896
		dc.b  $C,$82,$81, $C,$82,  6,$81,$81, $C,$82,$81, $C,$82,  6,$81,$81, $C,$82,$E3,$31,$34,$35,$30,$31,$DF,$DF,$9F,$9F, $C,  7, $C,  9,  7,  7,  7,  8,$2F,$1F,$1F,$2F,$17,$32,$14,$80,$18,$37,$30,$30,$31,$9E,$DC,$1C,$9C, $D,  6,  4,  1,  8, $A,  3,  5,$BF,$BF,$3F; 960
		dc.b $2F,$2C,$22,$14,$80,$3A,  1,  7,  1,  1,$8E,$8E,$8D,$53, $E, $E, $E,  3,  0,  0,  0,  0,$1F,$FF,$1F, $F,$18,$28,$27,$80,$3D,  1,  2,  2,  2,$14, $E,$8C, $E,  8,  5,  2,  5,  0,  0,  0,  0,$1F,$1F,$1F,$1F,$1A,$92,$A7,$80,$3C,$31,$52,$50,$30,$52,$53,$52,$53; 1024
		dc.b   8,  0,  8,  0,  4,  0,  4,  0,$1F, $F,$1F, $F,$1A,$80,$16,$80; 1088
Music83:	dc.b   3,$E1,  6,  3,  2,  9,  3,$B5,  0,  0,  0,$32,$E8,$15,  1,$D9,$E8, $E,  0,$30,$E8,$15,  0,$97,$E8,$17,  1,$34,$E8,$17,  2,$CB,$D0,  3,  0,  8,  3,$1B,$D0,  5,  0,  8,  3,$22, $B,  3,  0,  9,$E1,  2,$EF,  0,$80,$24,$F8,  0,$37,$D2,  9,$80,  3,$D2,  6,$D0; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b $D2,  9,$80,  3,$D2,  6,$D0,$D2,  9,$80,  3,$D2,  6,$D0,$D2, $C,$D4,$CE,$12,$CD,$35,$80,  1,$F8,  0,$16,$D2,$24,$D4, $C,$D1,$24,$D4,  9,$80,  3,$D4,$12,$D2,$4D,$80,$61,$80,$48,$F6,$FF,$C8,$C6,  6,$C8,$C9,$CD,$D4,  9,$80,  3,$D4,  6,$D2,$D4,  9,$80,  3,$D4; 64
		dc.b   6,$D2,$D4,  9,$80,  3,$D4,  6,$D2,$D4,$D2,$CD,$C9,$D0, $C,$D2,  6,$E7,$CE,$4D,$80,  1,$E3,$EF,  3,$E6,$F7,$80,  6,$C1,  3,  3,  6,$80,$B5,$1E,$EF,  2,$E6,  9,$D4,  6,$F8,  0,$5E,$D2,  9,$80,  3,$D2,$80,$D4,  6,$80,$D2, $C,$80,  6,$D2,  9,$80,  3,$D2,$80; 128
		dc.b $D4,  6,$80,$D2, $C,$80,$18,$D0,  3,$80, $F,$D0,  3,$80,$39,$D4,  6,$F8,  0,$37,$CE,  9,$80,  3,$CE,$80,$D2,  6,$80,$CE, $C,$80,  6,$D1,  9,$80,  3,$D1,$80,$D4,  6,$80,$D1, $C,$80,$18,$D5,  3,$80, $F,$D5,  3,$80,  9,$D9,  9,$80,  3,$D9,$80,$D7,  6,$80,$D5; 192
		dc.b   3,$80,$D4,$12,$F8,  2,$BE,$F6,$FF,$A1,$E7,  3,$80,$D4,$80,$D5,  6,$80,$D4, $C,$80,  6,$D4,  9,$80,  3,$D4,$80,$D5,  6,$80,$D4, $C,$80,$18,$D5,  3,$80, $F,$D5,  3,$80,$1B,$D5,  3,$80, $F,$D5,  3,$80,  9,$E3,$EF,  4,$E6,$FC,$E9,$24,$80,  6,$B5,  3,  3,  6; 256
		dc.b $80,$A9,$1E,$EF,  2,$E9,$DC,$E6,  4,$D0,  6,$F8,  0,$62,$CE,  9,$80,  3,$CE,$80,$D0,  6,$80,$CE, $C,$80,  6,$CE,  9,$80,  3,$CE,$80,$D0,  6,$80,$CE, $C,$80,$18,$CD,  3,$80, $F,$CD,  3,$80,$39,$D0,  6,$F8,  0,$3B,$CB,  9,$80,  3,$CB,$80,$CE,  6,$80,$CB, $C; 320
		dc.b $80,  6,$CD,  9,$80,  3,$CD,$80,$D1,  6,$80,$CD, $C,$80,$18,$D2,  3,$80, $F,$D2,  3,$80,  9,$D5,  9,$80,  3,$D5,$80,$D4,  6,$80,$D2,  3,$80,$D1,$12,$E1,  3,$F8,  2,$1B,$E1,  0,$F6,$FF,$9D,$E7,  3,$80,$D0,$80,$D2,  6,$80,$D0, $C,$80,  6,$D0,  9,$80,  3,$D0; 384
		dc.b $80,$D2,  6,$80,$D0, $C,$80,$18,$D2,  3,$80, $F,$D2,  3,$80,$1B,$D2,  3,$80, $F,$D2,  3,$80,  9,$E3,$EF,  1,$80,  6,$B5,  3,$B5,$E2,  1,$B5,  6,$80,$A9,$24,$F8,  0,$AF,$AC,  3,$80,$AC,  6,$B3,  3,$80,$B3,  6,$B0,  3,$80,$B0,  6,$B3,  3,$80,$B3,  6,$F7,  1; 448
		dc.b   2,$FF,$E8,$B1,  3,$80,$B1,  6,$B8,  3,$80,$B8,  6,$B5,  3,$80,$B5,  6,$B8,  3,$80,$B8,  6,$B0,  3,$80,$B0,  6,$B6,  3,$80,$B6,  6,$B5,  3,$80,$B5,  6,$B0,  3,$80,$B0,  6,$F8,  0,$6B,$B0,  3,$80,$B0,  6,$B6,  3,$80,$B6,  6,$B3,  3,$80,$B3,  6,$B6,  3,$80; 512
		dc.b $B6,  6,$B5,  3,$80,$B5,  6,$BC,  3,$80,$BC,  6,$B9,  3,$80,$B9,  6,$BC,  3,$80,$BC,  6,$AE,  3,$80,$AE,  6,$B5,  3,$80,$B5,  6,$B1,  3,$80,$B1,  6,$B5,  3,$80,$B5,  6,$AE,  3,$80,$AE,  6,$B5,  3,$80,$B5,  6,$B3,  3,$80,$B3,  6,$B5,  3,$80,$B5,  6,$AE,$12; 576
		dc.b $AE,  6,$AC,$12,$AC,  6,$AA,$12,$AA,  6,$AC,$12,$AC,  6,$F7,  1,  2,$FF,$EC,$E2,  1,$F6,$FF,$50,$AE,  3,$80,$AE,  6,$B5,  3,$80,$B5,  6,$B3,  3,$80,$B3,  6,$B5,  3,$80,$B5,  6,$F7,  0,  2,$FF,$E8,$B3,  3,$80,$B3,  6,$BA,  3,$80,$BA,  6,$B6,  3,$80,$B6,  6; 640
		dc.b $BA,  3,$80,$BA,  6,$F7,  0,  2,$FF,$E8,$E3,$80,$3C,$80,$60,$F8,  0,$33,$80,$2A,$DA, $C,$DA,  6,$D7, $C,$D4,  6,$D1,$2A,$80,$48,$F8,  0,$22,$80,$60,$D2,  6,$D5,  3,$D2,$D5,  6,$D2,$D4,$D0,$CB,$D4,$CE,$D2,  3,$CE,$D2,  6,$CE,$D0,$D2,$D4,$D0,$F7,  0,  2,$FF; 704
		dc.b $E5,$F6,$FF,$CA,$80,$30,$DA,  3,$D7,$D2,$CE,$D7,$D2,$CE,$CB,$D2,$CE,$CB,$C6,$CE,$CB,$C6,$C2,$27,$80,$3C,$E3,$80,  2,$E1,  1,$F6,$FF,$AA,$F3,$E7,$EC,$FF,$80,  6,$C1,  3,  3,  6,$80,$B5,$24,$EC,  1,$F8,  0,$60,$AC,$AC,$B3,$B3,$B0,$B0,$B3,$B3,$AC,$AC,$B3,$B3; 768
		dc.b $B0,$B0,$B3,$B3,$B1,$B1,$B8,$B8,$B5,$B5,$B8,$B8,$B0,$B0,$B6,$B6,$B5,$B5,$B0,$B0,$F8,  0,$3D,$B0,$B0,$B6,$B6,$B3,$B3,$B6,$B6,$B5,$B5,$BC,$BC,$B9,$B9,$BC,$BC,$AE,$AE,$B5,$B5,$B1,$B1,$B5,$B5,$AE,$AE,$B5,$B5,$B3,$B3,$B5,$B5,$EC,$FF,$BA,$12,$BA,  6,$B8,$12,$B8; 832
		dc.b   6,$B6,$12,$B6,  6,$B8,$12,$B8,  6,$F7,  0,  2,$FF,$EC,$EC,  1,$F6,$FF,$9F,$AE,  6,$AE,$B5,$B5,$B3,$B3,$B5,$B5,$AE,$AE,$B5,$B5,$B3,$B3,$B5,$B5,$B3,$B3,$BA,$BA,$B6,$B6,$BA,$BA,$B3,$B3,$BA,$BA,$B6,$B6,$BA,$BA,$E3,$80,  6,$82,  3,  3, $C,$81, $C, $C, $C,$81; 896
		dc.b  $C,$F6,$FF,$FC,$E8,  6,$80,  6,$D9,$D5,$D2, $C,$D7,  6,$D4,$D0,$80,$D5,$D2,$CE, $C,$D7,  6,$D4,$D0,$F7,  0,  2,$FF,$E9,$E8,  0,$E3,$22, $A,$13,  5,$11,  3,$12,$12,$11,  0,$13,$13,  0,  3,  2,  2,  1,$1F,$1F, $F, $F,$1E,$18,$26,$81,$3A,$61,$3C,$14,$31,$9C; 960
		dc.b $DB,$9C,$DA,  4,  9,  4,  3,  3,  1,  3,  0,$1F, $F, $F,$AF,$21,$47,$31,$80,$3A,  1,  7,  1,  1,$8E,$8E,$8D,$53, $E, $E, $E,  3,  0,  0,  0,  0,$1F,$FF,$1F, $F,$18,$28,$27,$80,$23,$7C,$32,  0,  0,$5F,$58,$DC,$DF,  4, $B,  4,  4,  6, $C,  8,  8,$1F,$1F,$BF; 1024
		dc.b $BF,$24,$26,$16,$80,  2,$3C,$32,$55,$51,$1F,$98,$1F,$9F, $F,$11, $E,$11, $E,  5,  8,  5,$5F, $F,$6F, $F,$2D,$2D,$2F,$80; 1088
Music84:	dc.b   3,$D7,  6,  3,  2,  6,  3,$D0,  0,  0,  0,$30,$E8,  0,  0,$89,$E8,  6,  1,$8A,$DC,$1A,  2,$3D,$DC,$1A,  2,$F2,$F4,$20,  1,$8E,$C4,  6,  0,  5,  2,$41,$C4,  6,  0,  5,  3,$B7,  0,  4,  0,  4,$EF,  0,$80, $C,$C4,$C6,$D0,$F8,  0,$19,$CD,$1E,$D9,  6,$D5,$3C; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b $80,$1E,$F7,  0,  3,$FF,$F6,$D9,  6,$D5,$18,$C4, $C,$C6,$D0,$F6,$FF,$E6,$F8,  0,$10,$CD,$1E,$CE,  6,$CD,$CB,$12,$C4, $C,$C6,$D0,$F8,  0,  2,$E3,$CD,$2A,$CD,  3,$CE,$D0,  9,$D2,$D3,  6,$D2, $C,$D0,$CE,$1E,$CE,  6,$CD,$CE,$1E,$CB, $C,$CD,$CE,$2A,$CB,  3,$CD; 64
		dc.b $CE,  9,$D0,$D1,  6,$D0, $C,$CE,$E3,$EF,  1,$E2,  1,$80,$30,$F8,  0,$6A,$80,  6,$B0,  2,$80,  1,$B0,  2,$80,  1,$B1,  6,$80,  3,$B1,$80,  6,$B1,$12,$80,  6,$B1,  2,$80,  1,$B1,  2,$80,  1,$B3,  6,$80,  3,$B3,$80,  6,$AC,$12,$B3,  6,$AC,$F8,  0,$3E,$80,  6; 128
		dc.b $B3,  2,$80,  1,$B0,  2,$80,  1,$F8,  0,$8E,$B0,  2,$80,  1,$B5,  2,$80,  1,$B6,  6,$80,  3,$B6,$80,  6,$B6,$12,$80,  6,$B8,  2,$80,  1,$B6,  2,$80,  1,$F8,  0,$70,$B5,  2,$80,  1,$B6,  2,$80,  1,$B8,  6,$80,$AC,$24,$E2,  1,$F6,$FF,$95,$B1,  6,$80,  3,$B1; 192
		dc.b $80,  6,$B1,$12,$80,  6,$B1,  2,$80,  1,$B1,  2,$80,  1,$AF,  6,$80,  3,$AF,  3,$80,  6,$AE,$12,$80,  6,$AE,  2,$80,  1,$AE,  2,$80,  1,$B3,  6,$80,  3,$B3,  6,$80,  3,$B3,  2,$80,  1,$B3,  2,$80,  1,$E9,$FF,$F7,  0,  4,$FF,$EA,$E9,  4,$AC,  6,$80,  3,$AC; 256
		dc.b $80,  6,$AC,$12,$80,  6,$AC,  2,$80,  1,$AC,  2,$80,  1,$B0,  6,$80,  3,$B0,$80,  6,$B0,$12,$E3,$B1,  6,$80,  3,$B1,$80,  6,$B1,$12,$80,  6,$AC,  2,$80,  1,$B1,  2,$80,  1,$B3,  6,$80,  3,$B3,$80,  6,$B3,$12,$80,  6,$AE,  2,$80,  1,$B3,  2,$80,  1,$B5,  6; 320
		dc.b $80,  3,$B5,$80,  6,$B5,$12,$80,  6,$E3,$EF,  2,$E0,$80,$80,$30,$F8,  0,$3A,$D0,  6,$80,  3,$D0,$80,  6,$D0,$12,$80,  6,$D4,  9,$80,  3,$D4,$80,$D2,  9,$80,  3,$D0,$80,$CE, $C,$80,  6,$F8,  0,$1C,$F8,  0,$62,$E8,  8,$80,  6,$D9,  9,  9,  9,$D7,  9,$D5,  6; 384
		dc.b $F8,  0,$53,$E8,  0,$80, $C,$D2,$24,$F6,$FF,$C5,$D0,  6,$80,  3,$D0,$80,  6,$D0,$18,$80,  6,$CE,$80,  3,$CE,$80,  6,$CD,$18,$80,  6,$D2,$80,  3,$D0,  6,$80,  3,$CE,$80,$D2,  6,$80,  3,$D0,  6,$80,  3,$CE,$80,$D2,  6,$80,  3,$D0,  6,$80,  3,$CE,$18,$80,  6; 448
		dc.b $CE,$80,  3,$CE,$80,  6,$CE,$18,$80,  6,$D1,$80,  3,$D1,$80,  6,$D1,$18,$80,  6,$E3,$E8,  8,$80,  6,$D4,  9,  9,  9,  9,$E8,  5,  3,  3,$E8,  8,$80,  6,$D5,  9,  9,  9,  9,$E8,  5,  3,  3,$E8,  8,$80,  6,$D7,  9,  9,  9,  9,$E8,  5,  3,  3,$E3,$EF,  2,$E0; 512
		dc.b $40,$80,$30,$F8,  0,$3C,$CD,  6,$80,  3,$CD,$80,  6,$CD,$12,$80,  6,$D0,  9,$80,  3,$D0,$80,$CE,  9,$80,  3,$CD,$80,$CB, $C,$80,  6,$F8,  0,$1E,$F8,  0,$64,$E8,  8,$80,  6,$D5,  9,  9,  9,$D4,  9,$D2,  6,$E8,  8,$F8,  0,$53,$E8,  0,$80, $C,$CE,$24,$F6,$FF; 576
		dc.b $C3,$CD,  6,$80,  3,$CD,$80,  6,$CD,$18,$80,  6,$CB,$80,  3,$CB,$80,  6,$CA,$18,$80,  6,$CE,$80,  3,$CD,  6,$80,  3,$CB,$80,$CE,  6,$80,  3,$CD,  6,$80,  3,$CB,$80,$CE,  6,$80,  3,$CD,  6,$80,  3,$CB,$18,$80,  6,$CB,$80,  3,$CB,$80,  6,$CB,$18,$80,  6,$CE; 640
		dc.b $80,  3,$CE,$80,  6,$CE,$18,$80,  6,$E3,$E8,  8,$80,  6,$D0,  9,  9,  9,  9,$E8,  5,  3,  3,$E8,  8,$80,  6,$D2,  9,  9,  9,  9,$E8,  5,  3,  3,$E8,  8,$80,  6,$D4,  9,  9,  9,  9,$E8,  5,  3,  3,$E3,$EF,  4,$80, $C,$C4,$C6,$D0,$EF,  4,$F8,$FD,$55,$CD,  6; 704
		dc.b $EF,  3,$E6,$EC,$F8,  0,$59,$E1,$14,$C6,  1,$E7,$E1,  0,$C6,  5,$F8,  0,$71,$B4,$E6,  7,$B4,$EF,  3,$E6,$E8,$E9,$CD,$80,  6,$E1,$14,$CD,  1,$E7,$E1,  0,$CD,  5,$CE,  6,$CD,$CE,$D0,$80,$C9,$80,  6,$F8,  0,$2C,$E8,  5,$C6,  3,  3,$E8,  0,$F8,  0,$46,$EF,  3; 768
		dc.b $E6,$EF,$E9,$CD,$CD,  3,$CE,$D0,  3,$80,  9,$E1,$EC,$D5,  1,$E7,$E1,  0,$F0,$2C,  1,  4,  4,$D5,$23,$F4,$E6,$14,$F6,$FF,$9B,$F8,  0,$27,$B4,$E6,  7,$B4,$EF,  3,$E6,$E8,$E9,$CD,$80,  6,$E1,$14,$CD,  1,$E7,$E1,  0,  5,$80,  6,$E1,$14,$C9,  1,$E7,$E1,  0,  5; 832
		dc.b $80,  6,$E3,$C9,  6,$C6,$80,  6,$E1,$14,$C4,  1,$E7,$E1,  0,  2,$C6,  3,$E8,  5,$C9,  3,$C9,  6,$C6,  3,$C9,  3,$E8,  0,$C9,$80,$E6,$FC,$E9,$33,$EF,  5,$B4,  3,$E6,  7,$B4,$E6,  7,$B4,$E6,  7,$E3,$F6,$FF,$FE,$F6,$FF,$FE,$F3,$E7,$E8,  2,$80,$24,$C6,  3,  3; 896
		dc.b $EC,  2,$F5,  8,$E8,  8,  6,$F5,  4,$E8,  3,$EC,$FE,$F6,$FF,$EE,$80,$30,$81, $C,$F6,$FF,$FC,$34,$33,$41,$7E,$74,$5B,$9F,$5F,$1F,  4,  7,  7,  8,  0,  0,  0,  0,$FF,$FF,$EF,$FF,$23,$90,$29,$97,$3A,$61,$3C,$14,$31,$9C,$DB,$9C,$DA,  4,  9,  4,  3,  3,  1,  3; 960
		dc.b   0,$1F, $F, $F,$AF,$21,$47,$31,$80,  4,$72,$42,$32,$32,$1F,$1F,$1F,$1F,  0,  0,  0,  0,  0,  0,  0,  0,  0,  7,  0,  7,$23,$80,$23,$80,$3A,  1,  7,  1,  1,$8E,$8E,$8D,$53, $E, $E, $E,  3,  0,  0,  0,  0,$1F,$FF,$1F, $F,$18,$28,$27,$80,$3C,$38,$74,$76,$33; 1024
		dc.b $10,$10,$10,$10,  2,  7,  4,  7,  3,  9,  3,  9,$2F,$2F,$2F,$2F,$1E,$80,$1E,$80,$F4,  6,  4, $F, $E,$1F,$1F,$1F,$1F,  0,  0, $B, $B,  0,  0,  5,  8, $F, $F,$FF,$FF,$15,$85,  2,$8A,  0; 1088
Music85:	dc.b   3,$B5,  6,  3,  2,  3,  3,$38,  0,  0,  0,$30,$F4,$11,  0,$DD,$E8, $B,  1,$A3,$F4,$14,  2,$36,$F4,$18,  3,  3,$F4,$18,  3,$12,$D0,  6,  0,  6,  3,$20,$E8,  7,  0,  0,  3,$21,  0,  5,  0,  4,$80,$2A,$EF,  0,$F0,  8,  1,  6,  4,$F8,  0,$51,$CB, $A,$CE,$2C; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b $F8,  0,$4A,$CB,$CE,  2,$80,  4,$CE,  2,$80,  4,$D0,  4,$CE,  2,$D0,  4,$80,  2,$D2,  6,$F9,$80,$12,$EF,  4,$F4,$E6,  8,$F8,  0,$55,$F8,  0,$6A,$C6,  8,$C9, $C,$D0, $A,$D2,  2,$80,  4,$D2,  2,$D0,  3,$80,$CE, $C,$F8,  0,$3E,$80,  6,$CD,  2,$80,  4,$CD, $C; 64
		dc.b $CE,$CD, $A,$CB,  2,$80,$2A,$E6,$F8,$F6,$FF,$A7,$80,  4,$CD,  2,$80,  4,$CD,  8,$C9,  2,$80,  4,$C6,  2,$80,  4,$CD, $A,$C9,  2,$80, $C,$80,$2E,$CF,  2,$80,  4,$CF,  8,$CB,  2,$80,  4,$C8,  2,$80,  4,$CF, $C,$E3,$F8,  0,$16,$C6,$80,  2,$C7,$80,  4,$C7,  8; 128
		dc.b $C9,  3,$80,$C7,$80,$C6,  4,$C7,$80,  2,$C9, $E,$E3,$80,  4,$CE,  8,$CD,  3,$80,$CB,$80,$C9,$80,$CB,$80,$C9,  4,$E3,$EF,  1,$E6,$FE,$E2,  1,$BA,  3,$80,$BA,$80,$B8,$80,$B8,$80,$B6,$80,$B6,$80,$B5,$80,$B5,  2,$80,$B3,$E6,  2,$F8,  0,$50,$BB,$80,  2,$BA,$80; 192
		dc.b   4,$BA,  8,$B8,  3,$80,$B8,$80,$B6,$80,$B6,$80,$B5, $A,$B3,  2,$F8,  0,$38,$BB,  8,$BA,  3,$80,$BA,$80,$BA,$80,$BA,$80,$BA,$80,$13,$BB,  2,$F8,  0,$59,$BB,$F7,  0,  2,$FF,$F8,$F8,  0,$50,$B5,$80,  4,$B5,  8,$B5,  3,$80,$B5,$80,$BA,  9,$80,  3,$BA, $A,$B3; 256
		dc.b   2,$80,$2E,$B3,  2,$E2,  1,$F6,$FF,$AF,$80,  4,$B3,  8,$B5,  3,$80,$B3,$80,$B5,$80,$B3,$80,$B6,  4,$BA,$80,  2,$BA,$80,  4,$C1,  8,$BD,  3,$80,$BD,$80,$BA,$80,$BA,$80,$B6, $A,$B5,  2,$80,  4,$B5,  8,$B7,  3,$80,$B5,$80,$B7,$80,$B5,$80,$B8,  4,$E3,$80,  4; 320
		dc.b $BB,  8,$BD,  3,$80,$BB,$80,$BA,  6,$80,$BB,  4,$BA,$80,  2,$B8,$80,  4,$B8,  8,$BA,  3,$80,$B8,$80,$B6,$80,$B6,$80,$B8,  4,$BA,$80,  2,$E3,$80,$30,$EF,  5,$F8,  0,$5D,$80,  6,$D2,  2,$80, $A,$D0,  2,$80, $A,$CE,  2,$80,  4,$CD,  2,$80,$CE,$CD,$80,  4,$F8; 384
		dc.b   0,$45,$C6,  2,$80,$C6,$CA,$80,$CA,$CD,$80,$CD,$D0,$80,$D0,$D2,$80,$10,$80,  4,$C2,  2,$F8,  0,$45,$80,$13,$C2,  2,$F8,  0,$3E,$80,$BD,$80,$BF,  4,$C1,$80,  2,$C2,$F8,  0,$32,$80,$15,$80,  4,$D2,  8,$D0,  3,$80,$D0,$80,$CE,$80,$CE,$80,$CD,  4,$CE,  2,$CD; 448
		dc.b   4,$CB,  2,$F6,$FF,$9E,$80,$36,$C6,  4,$C9,  2,$CB,  4,$CE,  2,$80,  6,$C6,  4,$C9,  2,$CB,  4,$CE,  2,$80,$3C,$E3,$80,  4,$C2,  8,$C2,  3,$80,$C2,$80,$C1,$80,$13,$BF,  2,$80,  4,$BF,  8,$BF,  3,$80,$BF,$80,$BD,$E3,$E0,$80,$E1,  3,$F8,  0,$80,$E1,  0,$F0; 512
		dc.b   1,  1,  1,  4,$EF,  2,$F8,  0, $D,$E6,$FC,$CB,  2,$F8,  0,$2C,$E6,  4,$F6,$FF,$EB,$F8,  0,$14,$D2,$30,$F8,  0, $F,$D6,  3,$80,$D6,$80,$D6,$80,$D6,$80,$D6,  3,$80,$13,$E3,$CD,$24,$CE,  6,$D0,$CD,$24,$C9,  6,$CB,$CD,$24,$CE,  6,$D0,$E3,$F8,  0,$22,$80,$13; 576
		dc.b $CB,  2,$F8,  0,$1B,$80,$C6,$80,$C7,  4,$C9,$80,  2,$CB,$F8,  0, $F,$80,$13,$C6, $E,$CA, $C,$CD,$D6, $A,$D7,  2,$80,$30,$E3,$80,  4,$CB,  8,$CB,  3,$80,$CB,$80,$C9,$80,$D2,$80,$CE,$80,  7,$C7,  2,$80,  4,$C7,  8,$C7,  3,$80,$C7,$80,$C6,$E3,$EF,  3,$E6,$FE; 640
		dc.b $F8,  0,  4,$E6,  6,$E3,$E5,  1,$AF,  1,$E7,$AE,  4,$80,  7,$AF,  1,$E7,$AE,  4,$80,  7,$B1,  1,$E7,$B0,  4,$80,  7,$B1,  1,$E7,$B0,  4,$80,  7,$B2,  1,$E7,$B1,  4,$80,  7,$B2,  1,$E7,$B1,  4,$80,  7,$B3,  1,$E7,$B2,  4,$80,  7,$B3,  1,$E7,$B2,  4,$80,  7; 704
		dc.b $E5,  2,$E3,$E0,$40,$F8,$FF,$B5,$F0,  2,  1,  2,  4,$E1,  2,$F6,$FF,$2E,$F8,$FF,$B2,$F8,$FF,$3E,$CB,  2,$F8,$FF,$5F,$F6,$FF,$F6,$F2,$F3,$E7,$E8,  1,$EC,  1,$80,  4,$C6,  2,$F7,  0,  8,$FF,$F8,$EC,$FF,  2,$80,$C6,$F6,$FF,$FB,$82,  6,  6,  6,  6,  6,  6,  4; 768
		dc.b   2,  4,$81,  2,$F8,  0,$61,$F7,  0,  3,$FF,$F9,$80,  4,$81,  8,$82,  6,$81,$81,  6,$82,$82,$82,  4,$81,  2,$F8,  0,$4A,$F7,  0,  2,$FF,$F9,$80,  4,$81,  8,$82,  6,$81,$81, $C,$82,$82,  6,  6,  6,  6,$10,  2,  4,$81,  2,$F8,  0,$2E,$F7,  0,  3,$FF,$F9,$80; 832
		dc.b   4,$81,  8,$82,  6,$81,$81,  6,$82,$82,$82,  4,$81,  2,$F8,  0,$17,$F7,  0,  3,$FF,$F9,$80, $C,$82, $A,$81,  2,$82,  6,$82,$82,  6,  4,$81,  2,$F6,$FF,$9E,$80,  4,$81,  8,$82,  6,$81,$81, $C,$82, $A,$81,  2,$E3,$3C,$31,$52,$50,$30,$52,$53,$52,$53,  8,  0; 896
		dc.b   8,  0,  4,  0,  4,  0,$10,  7,$10,  7,$1A,$80,$16,$80,$18,$37,$30,$30,$31,$9E,$DC,$1C,$9C, $D,  6,  4,  1,  8, $A,  3,  5,$BF,$BF,$3F,$2F,$32,$22,$14,$80,$3D,  1,  2,  2,  2,$1F,$10,$10,$10,  7,$1F,$1F,$1F,  0,  0,  0,  0,$1F, $F, $F, $F,$17,$8D,$8C,$8C; 960
		dc.b $2C,$74,$74,$34,$34,$1F,$1F,$1F,$1F,  0,  0,  0,  0,  0,  1,  0,  1, $F,$3F, $F,$3F,$16,$80,$17,$80,  4,$37,$72,$77,$49,$1F,$1F,$1F,$1F,  7, $A,  7, $D,  0,  0,  0,  0,$10,  7,$10,  7,$23,$80,$23,$80,$3A,  1,  1,  1,  2,$8D,  7,  7,$52,  9,  0,  0,  3,  1; 1024
		dc.b   2,  2,  0,$5F, $F, $F,$2F,$18,$22,$18,$80,  0; 1088
Music86:	dc.b   4,$A1,  6,  3,  2,  5,  3,$70,  0,  0,  0,$30,$F4, $D,  0,$7D,$F4, $D,  1,$1A,$F4,$13,  1,$51,$F4,$17,  2, $B,$F4,$17,  2,$75,$D0,  3,  0,  0,  2,$C9,$D0,  3,  0,  0,  3,$49,  0,  3,  0,  4,$EF,  2,$E6,  8,$80,$24,$CD,  3,$CB,$C9,$C8,$CE,$CD,$CB,$C9,$D0; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b $CE,$CD,$CB,$D2,$D0,$CE,$CD,$D4,$D2,$D0,$CE,$E6,$F8,$EF,  3,$F0, $D,  1,  8,  5,$F8,  3,$D8,$EF,  5,$E1,$FE,$E0,$40,$E6,  3,$E9,$F4,$F8,  4,$24,$E9, $C,$E6,$FD,$E0,$C0,$E6,$FE,$E1,  0,$EF,  3,$F8,  3,$E0,$F7,  0,  2,$FF,$F9,$E6,  2,$F6,$FF,$B4,$EF,  0,$E6; 64
		dc.b $FD,$E2,  1,$E8,  6,$AE,  3,$B0,$80,$B1,$80,$B3,$B5,$E8,  0,$B8,  9,$AC,  6,$B8,$F7,  0,  5,$FF,$F9,$AC,$E6,  3,$E8,  6,$F8,  0,$6B,$B8,$B8,$B3,$B3,$B6,$B6,$B3,$B3,$F7,  0,  4,$FF,$F4,$B6,$B6,$B1,$B1,$B4,$B4,$B1,$B1,$F7,  0,  4,$FF,$F4,$F8,  0,$4E,$F7,  1; 128
		dc.b   2,$FF,$DC,$E0,$80,$F8,  3,$C0,$E0,$C0,$B1,  3,$B1,$AC,$AC,$AE,$AE,$AC,$AC,$F7,  0,  2,$FF,$F3,$B7,$B7,$B2,$B2,$B4,$B4,$B2,$B2,$F7,  0,  2,$FF,$F4,$B6,$B6,$B1,$B1,$B3,$B3,$B1,$B1,$F7,  0,  2,$FF,$F4,$B8,$B8,$B3,$B3,$B5,$B5,$B3,$B3,$F7,  0,  2,$FF,$F4,$F7; 192
		dc.b   1,  4,$FF,$C7,$E8,  0,$E2,  1,$F6,$FF,$73,$BA,  3,$BA,$B5,$B5,$B8,$B8,$B5,$B5,$F7,  0,  4,$FF,$F3,$E3,$EF,  1,$E8,  6,$BA,  3,$BC,$80,$BD,$80,$BF,$C1,$E8,  0,$C4,$4B,$EF,  3,$E1,  3,$E6,$FA,$F8,  2,$FC,$EF,  0,$E0,$40,$E8,  6,$F8,  3,$4C,$E0,$C0,$EF,  3; 256
		dc.b $E8,  0,$E6,$FE,$F8,  3, $C,$F7,  0,  2,$FF,$F9,$E6,  8,$F6,$FF,$CA,$EF,  4,$E0,$80,$F0,$5C,  1,  5,  4,$E8,  6,$F8,  0,$55,$E1,  4,$F8,  0,$5D,$E6,  6,$EF,  5,$E1,  2,$E6,$ED,$E9,$F4,$F8,  3,$17,$E6,$13,$E9, $C,$E6,$F3,$EF,  4,$F4,$E6,$FA,$F4,$F8,  0,$59; 320
		dc.b $80, $C,$C6,  2,$E1,  0,$E7, $A,$80,  3,$C6,$80,$80,$C6,$80,  9,$F8,  0,$46,$C6,  2,$E1,  0, $A,$80,  6,$F0,$18,  1,  7,  4,$E1,$E2,$C6,  2,$E7,$E1,  0,$1C,$F7,  0,  2,$FF,$D1,$E6,  6,$E6,  1,$F6,$FF,$9F,$C1,  3,$C1,$80,$C1,$80,$C1,$C1,$E8,  0,$BF,$4B,$E3; 384
		dc.b $EF,  2,$E6,  6,$F0,  8,  1,  8,  4,$80,$60,$80,$80,$CD,$18,$CF,$D0,$D1,$F7,  0,  2,$FF,$F3,$E3,$80, $C,$E1,$EC,$C4,  2,$E1,  0,$E7,  6,$80,  1,$C4,  3,$80,$18,$80, $C,$E1,$EC,$CA,  2,$E1,  0,$E7,  6,$80,  1,$CA,  3,$80,$18,$80, $C,$E1,$EC,$C9,  2,$E1,  0; 448
		dc.b $E7,  6,$80,  1,$C9,  3,$80,$18,$E1,$EC,$E3,$EF,  4,$E0,$40,$F0,$5C,  1,  5,  4,$E8,  6,$BD,  3,$BD,$80,$BD,$80,$BD,$BD,$E8,  0,$BC,$4B,$F8,$FF,$9C,$E6,  6,$80,$60,$F7,  0,  1,$FF,$FA,$EF,  6,$E6,$EB,$E9, $C,$F4,$F8,  0,$16,$CD,$CE,$D0,$F8,  0,$10,$D0,$CE; 512
		dc.b $CD,$F7,  0,  2,$FF,$F0,$E6,  9,$E9,$F4,$F6,$FF,$BF,$80,  3,$CD,$C9,  6,  6,$C4,$C9,  9,$CD,  9,$80,  6,$80,  3,$CE,$CA,  6,  6,$C7,$CA,  9,$CE,  9,$80,  6,$80,  3,$CD,$C9,  6,  6,$C6,$C9,  9,$CD, $F,$CB, $C,$E3,$EC,  1,$F5,  0,$F8,$FF,$38,$F5,  6,$EC,$FF; 576
		dc.b $F8,$FF,$47,$80,$60,$F5,  0,$EC,$FF,$F8,  0,$1F,$80, $C,$C2,$80,  3,$C2,$80,$80,$C2,$80,  9,$F8,  0,$11,$C2, $C,$80,  6,$C2,$1E,$F7,  0,  2,$FF,$E5,$EC,  1,$F6,$FF,$CC,$80, $C,$C1,  7,$80,  2,$C1,  3,$80,$18,$80, $C,$C7,  7,$80,  2,$C7,  3,$80,$18,$80, $C; 640
		dc.b $C6,  7,$80,  2,$C6,  3,$80,$18,$E3,$F5,  0,$EC,  1,$BD,  3,$BD,$80,$BD,$80,$BD,$BD,$E8,  0,$BC,$4B,$EC,$FF,$F5,  5,$E8,  3,$F8,  0,$59,$D0,$D0,$D7,$D0,$D5,$D0,$D4,$D0,$F7,  0,  4,$FF,$F4,$D2,$D2,$D8,$D2,$D7,$D2,$D5,$D2,$F7,  0,  4,$FF,$F4,$F8,  0,$3C,$F7; 704
		dc.b   1,  2,$FF,$D8,$80,$60,$EC,  1,$D5,  3,$D5,$DC,$D5,$DA,$D5,$D9,$D5,$F7,  0,  2,$FF,$F3,$D3,$D3,$DA,$D3,$D8,$D3,$D6,$D3,$F7,  0,  2,$FF,$F4,$D2,$D2,$D9,$D2,$D7,$D2,$D5,$D2,$F7,  0,  4,$FF,$F4,$F7,  1,  4,$FF,$D4,$EC,$FF,$F6,$FF,$90,$D2,  3,$D2,$D9,$D2,$D7; 768
		dc.b $D2,$D5,$D2,$F7,  0,  4,$FF,$F3,$E3,$F3,$E7,$E8,  3,$C6,  3,  6,$80,$C6,  6, $F, $C, $C, $C,$18,$C6,  3,  3,$EC,  2,$F5,  8,$E8,  8,  6,$F5,  4,$E8,  3,$EC,$FE,$F7,  0,$88,$FF,$EC,$F6,$FF,$DA,$82,  3,  6,  6,  3,  3, $F,$81, $C,$80, $C,$81,$81,  6,$82,$82; 832
		dc.b $82,  3,  3,$81, $C,$82,$81,$82,$81,$82,  1,$89,  5,$88,  6,$81,  1,$89,  5,$88,  6,$82,  1,$89,  5,$88,  6,$F7,  0,  2,$FF,$E4,$81, $C,$82,$81,$82,$81,$82,$81,$82,  6,$88,  3,$88,$81, $C,$82,$81,$82,$81,  6,$88,$82,  1,$89,  5,$88,  6,$81,  1,$89,  5,$82; 896
		dc.b   1,$88,  5,$82,  1,$89,  5,$82,  3,  3,$F7,  1,  2,$FF,$B5,$82,  3,$82,$81,$81,$81,$81,$82,$82,$81,$81,$81,$81,$82,$82,$82,$82,$F7,  0,  2,$FF,$EB,$F8,  0,$28,$88,  2,$81,  1,$89,  5,$82,  1,$88,  5,$89,  6,$F8,  0,$19,$89,  2,$82,  1,$88,  5,$82,  1,$89; 960
		dc.b   5,$82,  1,$88,  2,$82,  3,$F7,  1,  2,$FF,$DA,$F6,$FF,$62,$81, $C,$82,  9,$81,  6,  3,$81,  1,$88,  2,$89,  3,$82,  1,$88, $B,$F7,  0,  3,$FF,$EB,$81, $C,$82,  9,$81,  6,$82,  1,$E3,$D2,$1E,$D0,  6,$CE,$D0,$CD,$30,$D0,$1E,$CE,  6,$CD,$CE,$CB,$30,$CE,$1E; 1024
		dc.b $CC,  6,$CB,$CC,$C9,$18,$CB,$CD,  3,$CE,$CD,$5A,$F7,  0,  2,$FF,$DE,$E3,$D0,$1E,$CD,  6,$C9,$D5,$D3, $C,$D5,  6,$D3, $C,$D0,  6,$D3,$D2,$24,$CD,  6,$CE,$D0,$12,$D2,  6,$D0,$12,$CD, $C,$D0,$1E,$CD,  6,$C9,$D5,$D3, $C,$D5,  6,$D3, $C,$D0,  6,$D3,$D2,$24,$CD; 1088
		dc.b   6,$CE,$D0,$30,$80,  6,$E3,$F8,  0, $A,$B8,$B8,  9,$F8,  0,  4,$80, $C,$E3,$BA,  3,$BA,$B9,$B9,$B8,$B8,$BA,$BA,$B9,$B9,$B8,$B8,$E3,  8, $A,$70,$30,  0,$1F,$1F,$5F,$5F,$12, $E, $A, $A,  0,  4,  4,  3,$2F,$2F,$2F,$2F,$24,$2D,$13,$80,$2C,$74,$74,$34,$34,$1F; 1152
		dc.b $12,$1F,$1F,  0,  4,  0,  4,  0,  9,  0,  9,  0,  8,  0,  8,$16,$80,$17,$80,$3D,  1,  2,  2,  2,$14, $E,$8C, $E,  8,  5,  2,  5,  0,  8,  8,  8,$1F,$1F,$1F,$1F,$1A,$92,$A7,$80,$29,$36,$74,$71,$31,  4,  4,  5,$1D,$12, $E,$1F,$1F,  4,  6,  3,  1,$5F,$6F, $F; 1216
		dc.b  $F,$27,$27,$2E,$80,$3D,  1,  1,  1,  1,$8E,$52,$14,$4C,  8,  8, $E,  3,  0,  0,  0,  0,$1F,$1F,$1F,$1F,$1B,$80,$80,$9B,$30,$30,$30,$30,$30,$9E,$D8,$DC,$DC, $E, $A,  4,  5,  8,  8,  8,  8,$BF,$BF,$BF,$BF,$14,$3C,$14,$80,$3D,  1,  2,  0,  1,$1F, $E, $E, $E; 1280
		dc.b   7,$1F,$1F,$1F,  0,  0,  0,  0,$1F, $F, $F, $F,$17,$8D,$8C,$8C; 1344
Music87:	dc.b   1,$B4,  6,  3,  1,  8,  1,$66,  0,  0,  0,$32,$F4,$11,  0,$9D,$F4,  7,  0,$EB,$E8, $F,  1,$1E,$E8, $F,  0,$30,$F4,$11,  1,$51,$D0,  5,  0,  5,  1,$51,$DC,  5,  0,  5,  1,$52,  0,  3,  0,  4,$E1,  3,$EF,  0,$80,$30,$80, $C,$CA,$15,$80,  3,$CA,  6,$80,$CB; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b  $F,$80,  3,$C8,$18,$80,  6,$CA,  6,$80,$CA,$80,$CA,$80,$C6,$80,$C4, $F,$80,  3,$C8,$18,$80,  6,$80, $C,$CA,$15,$80,  3,$CA,  6,$80,$CB, $F,$80,  3,$C8,$18,$80,  6,$CA,  6,$80,$CA,$80,$CA,$80,$C6,$80,$C4, $F,$80,  3,$C8,$18,$80,  6,$E6,$FD,$80,$30,$80,$C6; 64
		dc.b   4,$C8,$CA,$CB,$CD,$CF,$C8,$CA,$CC,$CD,$CF,$D1,$CA,$CC,$CE,$CF,$D1,$D3,$CE,$CF,$D1,$D3,$D5,$D6,$E6,  3,$F6,$FF,$9A,$E2,  1,$EF,  1,$80,$30,$AE,  6,$80,$AE,$80,$A9,$80,$A9,$80,$AC,$12,$AB, $C,$AC,  6,$AB, $C,$AE,  6,$80,$AE,$80,$A9,$80,$A9,$80,$B3,$12,$B2; 128
		dc.b  $C,$B3,  6,$B2, $C,$F7,  0,  2,$FF,$DA,$A4,  6,$A0,$12,$A2,  6,$80,$A4,$80,$F7,  0,  2,$FF,$F3,$A2, $C,$A4,$A6,$A8,$A4,  6,$A6,$A8,$AA,$A6,$A8,$AA,$AB,$E2,  1,$F6,$FF,$B9,$EF,  0,$80,$30,$CD,  6,$80,$CD,$80,$CA,$80,$CA,$80,$CB,$12,$CB,$1E,$CD,  6,$80,$CD; 192
		dc.b $80,$CA,$80,$CA,$80,$D0,$12,$D0,$1E,$F7,  0,  2,$FF,$E2,$80,  6,$C4,$12,$C6,  6,$80,$12,$F7,  0,  4,$FF,$F4,$F6,$FF,$D2,$EF,  0,$80,$30,$CA,  6,$80,$CA,$80,$C6,$80,$C6,$80,$C8,$12,$C8,$1E,$CA,  6,$80,$CA,$80,$C6,$80,$C6,$80,$CB,$12,$CB,$1E,$F7,  0,  2,$FF; 256
		dc.b $E2,$80,  6,$C8,$12,$CA,  6,$80,$12,$F7,  0,  4,$FF,$F4,$F6,$FF,$D2,$F2,$F3,$E7,$80,$30,$E8,  3,$C6, $C,$E8, $C, $C,$E8,  3, $C,$E8, $C, $C,$F6,$FF,$F1,$82,  6,$82,$82,$82,$82,  2,$82,  4,$81,$12,$81, $C,$82,$81,$82,$81, $C,$82,$81,$82,$81, $C,$82,$81,$82; 320
		dc.b $81, $C,$82,$81,  4,$80,$82,$82, $C,$F7,  0,  2,$FF,$E4,$81,  6,$82,$12,$81, $C,$82,$82,  6,$81,$12,$81, $C,$82,$82,  6,$81,$12,$81, $C,$82,$82,  4,$82,$82,$82,$82,$82,$82,$82,$82,$82,$82,$82,$F6,$FF,$BF,$F2,$3A,  1,  7,  1,  1,$8E,$8E,$8D,$53, $E, $E, $E; 384
		dc.b   3,  0,  0,  0,  0,$1F,$FF,$1F, $F,$18,$28,$27,$80,$3A,$61,$3C,$14,$31,$9C,$DB,$9C,$DA,  4,  9,  4,  3,  3,  1,  3,  0,$1F, $F, $F,$AF,$21,$47,$31,$80; 448
Music88:	dc.b   0,$A2,  6,  3,  2,  5,  0,$93,  0,  0,  0,$37,$E8,$10,  0,$4D,$E8,$10,  0,$6C,$E8,$10,  0,$30,$E8,$10,  0,$65,$E8,$10,  0,$81,$D0,  6,  0,  5,  0,$92,$DC,  6,  0,  5,  0,$92,$DC,  0,  0,  4,$E1,  3,$E0,$40,$F6,  0,  3,$E0,$80,$EF,  0,$E8,  6,$D9,  6,  3; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b   3,  6,  6,$E8,  0,$DB,  9,$D7,$D6,  6,$D9,$18,$F2,$EF,  1,$E8,  6,$E2,  1,$D6,  6,  3,  3,  6,  6,$E8,  0,$D7,  9,$D4,$D2,  6,$D6,$18,$E2,  1,$F2,$E1,  3,$E0,$40,$F6,  0,  3,$E0,$80,$EF,  2,$BA, $C,$80,  6,$BA,$B8,$80,  3,$B8,  6,$80,  3,$B8,  6,$BA,$18; 64
		dc.b $F2,$E8,  6,$D6,  6,  3,  3,  6,  6,$E8,  0,$D7,  9,$D4,$D2,  6,$D6,$18,$F2,$88,$12,  6,$8B,  9,  9,  6,$88,  6,$8A,$88,$8A,$88, $C,$E4,$3A,  1,  7,  1,  1,$8E,$8E,$8D,$53, $E, $E, $E,  3,  0,  0,  0,  0,$1F,$FF,$1F, $F,$18,$4E,$16,$80,$3A,  1,  7,  1,  1; 128
		dc.b $8E,$8E,$8D,$53, $E, $E, $E,  3,  0,  0,  0,  0,$1F,$FF,$1F, $F,$18,$28,$27,$80,$3A,  1,  7,  1,  1,$8E,$8E,$8D,$53, $E, $E, $E,  3,  0,  0,  0,  7,$1F,$FF,$1F, $F,$18,$28,$27,$80,  0; 192
Music89:	dc.b   2,$C8,  7,  3,  2,  8,  2,$84,  0,  0,  0,$34,$DC,$18,  0,$7A,$DC, $C,  0,$C6,$E8,$18,  1,$2B,$E8,$18,  1,$90,$E8,$18,  2,$85,$E8,$14,  1,$F5,$DC,  3,  0,  4,  2,$67,$FD,  1,  0,  8,  2,$84,$DC,  4,  0,  4,$EF,  0,$C1,$18,$C2, $C,$C4,$18,$C1, $C,$18,$BD; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b  $C,$C1,$18,$BD, $C,$C1,$18,$C2, $C,$C4,$18,$C1, $C,$BD,$18,$BF, $C,$BD,$24,$F7,  0,  2,$FF,$DF,$E7,  3,$80,  9,$BF, $C,$C1,$C2,$C1,$C2,$C4,$18,$C1, $C,$BD,$24,$80, $C,$BF,$C1,$C2,$C1,$C2,$C4,$18,$C6, $C,$C4,$21,$80,  3,$F6,$FF,$BD,$EF,  2,$E2,  1,$C2, $C; 64
		dc.b $80,$18,$C1, $C,$80,$18,$BF, $C,$80,$18,$BD, $C,$BF,$C1,$C2, $C,$80,$18,$C1, $C,$80,$18,$BF,$12,$C1,  6,$BF, $C,$BD,$24,$F7,  0,  2,$FF,$DC,$BB, $C,$80,$18,$BB, $C,$80,$18,$BD, $C,$80,$18,$BD, $C,$80,$18,$BB, $C,$80,$18,$BB, $C,$80,$18,$BF, $C,$80,$18,$C4; 128
		dc.b $24,$E2,  1,$F6,$FF,$B9,$EF,  3,$F0,$1A,  1,  4,  6,$E0,$C0,$F8,  0,$3A,$80,$D5,  3,$80,  9,$D5, $C,$D4,$D5,$D7,$F8,  0,$2D,$D5,$12,$D7,  6,$D5, $C,$D4,$24,$F7,  0,  2,$FF,$E4,$F8,  0,$2D,$80,$D4,  3,$80,  9,$D4, $C,$80,$D4,  3,$80,  9,$D4, $C,$F8,  0,$1C; 192
		dc.b $80,$D5,  3,$80,  9,$D5, $C,$24,$F6,$FF,$C5,$80, $C,$D9,  3,$80,  9,$D9, $C,$80,$D7,  3,$80,  9,$D7, $C,$E3,$80, $C,$D2,  3,$80,  9,$D2, $C,$80,$D2,  3,$80,  9,$D2, $C,$E3,$EF,  3,$F0,$1A,  1,  4,  6,$E0,$40,$F8,  0,$3A,$80,$D2,  3,$80,  9,$D2, $C,$D0,$D2; 256
		dc.b $D4,$F8,  0,$2D,$D2,$12,$D4,  6,$D2, $C,$D0,$24,$F7,  0,  2,$FF,$E4,$F8,  0,$2D,$80,$D0,  3,$80,  9,$D0, $C,$80,$D0,  3,$80,  9,$D0, $C,$F8,  0,$1C,$80,$D2,  3,$80,  9,$D2, $C,$24,$F6,$FF,$C5,$80, $C,$D5,  3,$80,  9,$D5, $C,$80,$D4,  3,$80,  9,$D4, $C,$E3; 320
		dc.b $80, $C,$CE,  3,$80,  9,$CE, $C,$80,$CE,  3,$80,  9,$CE, $C,$E3,$EF,  3,$F0,$1A,  1,  4,  6,$E0,$80,$F8,  0,$3A,$80,$CE,  3,$80,  9,$CE, $C,$CD,$CE,$D0,$F8,  0,$2D,$CE,$12,$D0,  6,$CE, $C,$CD,$24,$F7,  0,  2,$FF,$E4,$F8,  0,$2D,$80,$CD,  3,$80,  9,$CD, $C; 384
		dc.b $80,$CD,  3,$80,  9,$CD, $C,$F8,  0,$1C,$80,$CE,  3,$80,  9,$CE, $C,$24,$F6,$FF,$C5,$80, $C,$D2,  3,$80,  9,$D2, $C,$80,$D0,  3,$80,  9,$D0, $C,$E3,$80, $C,$CB,  3,$80,  9,$CB, $C,$80,$CB,  3,$80,  9,$CB, $C,$E3,$E8,  6,$F8,  0,$47,$C9,  6,  6,$C6,  3,$80; 448
		dc.b   9,$C2,  3,$80,  9,$C8,  3,$80,$21,$F8,  0,$35,$C9,  3,$80,$15,$CB,  3,$80,  9,$C9,  3,$80,$21,$F7,  0,  2,$FF,$DB,$F8,  0,$38,$D4,  6,  6,$D0,$D0,$CD,$CD,$D4,$D4,$D0,$D0,$CD,  3,$80,  9,$F8,  0,$26,$D5,  6,  6,$D2,$D2,$CE,$CE,$D0,  9,$80,$1B,$F6,$FF,$B8; 512
		dc.b $CD,  6,  6,$C9,  3,$80,  9,$C6,  3,$80,  9,$CB,  6,  6,$C8,  3,$80,  9,$C4,  3,$80,  9,$E3,$D2,  6,  6,$CE,$CE,$CB,$CB,$D2,$D2,$CE,$CE,$CB,  3,$80,  9,$E3,$80, $C,$BD,$BD,$80,$BD,$BD,$80,$BD,$BD,$80,$BD,  6,  6, $C,$80,$BD,$BD,$80,$BD,$BD,$80,$BD,$BD,$BD; 576
		dc.b $24,$F6,$FF,$E4,$F2,$EF,  1,$D9,$18,$DA, $C,$DC,$18,$D9, $C,$18,$D5, $C,$D9,$18,$D5, $C,$D9,$18,$DA, $C,$DC,$18,$D9, $C,$D5,$18,$D7, $C,$D5,$24,$F7,  0,  2,$FF,$DF,$80, $C,$D7,$D9,$DA,$D9,$DA,$DC,$18,$D9, $C,$D5,$24,$80, $C,$D7,$D9,$DA,$D9,$DA,$DC,$18,$DE; 640
		dc.b  $C,$DC,$21,$80,  3,$F6,$FF,$C0,$2C,$74,$74,$34,$34,$1F,$12,$1F,$1F,  0,  0,  0,  0,  0,  1,  0,  1,  0,$36,  0,$36,$16,$80,$17,$80,$2C,$72,$78,$34,$34,$1F,$12,$1F,$12,  0, $A,  0, $A,  0,  0,  0,  0,  0,$16,  0,$16,$16,$80,$17,$80,$30,$30,$30,$30,$30,$9E; 704
		dc.b $D8,$DC,$DC, $E, $A,  4,  5,  8,  8,  8,  8,$B0,$B0,$B0,$B5,$14,$3C,$14,$80,$3D,  1,  2,  0,  1,$1F,$10,$10,$10,  7,$1F,$1F,$1F,  0,  0,  0,  0,$10,  7,  7,  7,$17,$80,$80,$80; 768
Music8A:	dc.b   1,$61,  6,  3,  1,  5,  1,$37,  0,  0,  0,$32,$F4, $C,  0,$67,$F4,  9,  0,$9F,$F4, $D,  0,$D8,$F4, $C,  0,$30,$F4, $E,  1,$60,$D0,  3,  0,  5,  1,$60,$DC,  6,  0,  5,  1,$14,  0,  4,  0,  4,$E1,  3,$EF,  0,$80,$3C,$CA,$15,$80,  3,$CA,  6,$80,$CB, $F,$80; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b   3,$C8,$18,$80,  6,$CA,$80,$CA,$80,$CA,$80,$C6,$80,$C4, $F,$80,  3,$C8, $C,$80,$12,$C6,  6,$80,$CA,$80,$D2,$80,$CD, $C,$80,  6,$D1,$12,$D2,  6,$80,$72,$F2,$EF,  1,$E2,  1,$80,$30,$AE,  6,$80,$AE,$80,$A9,$80,$A9,$80,$AC,$12,$AB, $C,$AC,  6,$AB, $C,$AE,  6; 64
		dc.b $80,$AE,$80,$A9,$80,$A9,$80,$B3,$12,$B2, $C,$B3,  6,$B2, $C,$80,$A2,$80,$A2,$80,  6,$AD,$12,$AE,  6,$80,$A2,$6C,$E2,  1,$F2,$EF,  2,$80,$30,$CD,  6,$80,$CD,$80,$CA,$80,$CA,$80,$CB, $F,$80,  3,$CB,$18,$80,  6,$CD,$80,$CD,$80,$CA,$80,$CA,$80,$D0, $F,$80,  3; 128
		dc.b $D0,$18,$80,  6,$CD, $C,$80,$CD,$80,$80,  6,$CC,$12,$CD, $C,$E6,$FC,$EF,  1,$E1,  3,$A2,$6C,$F2,$EF,  2,$80,$30,$CA,  6,$80,$CA,$80,$C6,$80,$C6,$80,$C8, $F,$80,  3,$C8,$18,$80,  6,$CA,$80,$CA,$80,$C6,$80,$C6,$80,$CB, $F,$80,  3,$CB,$18,$80,  6,$CA, $C,$80; 192
		dc.b $CA,$80,$80,  6,$C9,$12,$CA, $C,$E6,$FD,$EF,  1,$F0,  0,  1,  6,  4,$A2,$6C,$F2,$F3,$E7,$80,$30,$E8,  3,$C6, $C,$E8, $C, $C,$E8,  3, $C,$E8, $C, $C,$F7,  0,  5,$FF,$EF,$E8,  3,  6,$E8, $E,$12,$E8,  3, $C,$E8, $F, $C,$F2,$80, $C,$82,$82,$82,$81,$82,$81,$82; 256
		dc.b $81,$82,$81,$82,$81,$82,$81,$82,$81,$82,$81,  6,$80,  2,$82,$82,$82,  9,$82,  3,$81, $C,$82,$81,$82,$81,  6,$82,$12,$82, $C,$81,$F2,$3A,$51,  8,$51,  2,$1E,$1E,$1E,$10,$1F,$1F,$1F, $F,  0,  0,  0,  2, $F, $F, $F,$1F,$18,$24,$22,$81,$20,$36,$35,$30,$31,$DF; 320
		dc.b $DF,$9F,$9F,  7,  6,  9,  6,  7,  6,  6,  8,$2F,$1F,$1F,$FF,$19,$37,$13,$80,$3A,  1,  7,  1,  1,$8E,$8E,$8D,$53, $E, $E, $E,  3,  0,  0,  0,  0,$1F,$FF,$1F, $F,$18,$28,$27,$80; 384
Music8B:	dc.b   2,$36,  6,  3,  1,  5,  1,$F6,  0,  0,  0,$30,$F4, $E,  0,$84,$F4,  9,  0,$E5,$F4, $D,  1,$2D,$F4, $D,  1,$82,$F4,$17,  1,$98,$D0,  5,  0,  5,  1,$BA,$DC,  5,  0,  5,  1,$D4,  0,  3,  0,  4,$EF,  3,$80,$60,$F8,  0,$27,$80,$60,$E6,$FB,$80, $C,$CD,  6,$80; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b $D4,$CD,  6,$80, $C,$CD,  6,$80,$D4,$CD,  6,$80,$18,$E6,  5,$80, $C,$AE,$80,$AE,$80,$24,$E1,  2,$E6,  8,$A2,$6C,$F2,$80, $C,$CA,$15,$80,  3,$CA,  6,$80,$CB, $F,$80,  3,$C8,$18,$80,  6,$CA,$80,$CA,$80,$CA,$80,$C6,$80,$C4, $F,$80,  3,$C8,$18,$80,  6,$F7,  0; 64
		dc.b   2,$FF,$DB,$E3,$EF,  1,$E2,  1,$80,$60,$AE,  6,$80,$AE,$80,$A9,$80,$A9,$80,$AC,$12,$AB, $C,$AC,  6,$AB, $C,$AE,  6,$80,$AE,$80,$A9,$80,$A9,$80,$B3,$12,$B2, $C,$B3,  6,$B2, $C,$F7,  0,  2,$FF,$DA,$AC,  6,$80,$A9,$80,$AA,$80,$AB,$80,$AC,$AC,$A9,$80,$AA,$80; 128
		dc.b $AC,$80,$A9,$80,$A9,$80,$AD,$80,$AD,$80,$B0,$80,$B0,$80,$B3,$80,$B3,$80,$80, $C,$A2,$12,$80,  6,$A2,$12,$AD,$AE,  6,$80,$E6,$FD,$A2,$6C,$E2,  1,$F2,$EF,  2,$80,$60,$CD,  6,$80,$CD,$80,$CA,$80,$CA,$80,$CB,$12,$CB,$1E,$CD,  6,$80,$CD,$80,$CA,$80,$CA,$80,$D0; 192
		dc.b $12,$D0,$1E,$F7,  0,  2,$FF,$E2,$80, $C,$CB,$12,$80,  6,$CB,$80,$CA,$12,$CB,$CA, $C,$C5,$18,$C8,$CB,$D1,$80, $C,$CD,$80,$CD,$12,$CC,$CD,  6,$80,$E6,$F8,$EF,  1,$E1,  3,$A2,$6C,$F2,$EF,  2,$80,$60,$CA,  6,$80,$CA,$80,$C6,$80,$C6,$80,$C8,$12,$C8,$1E,$CA,  6; 256
		dc.b $80,$CA,$80,$C6,$80,$C6,$80,$CB,$12,$CB,$1E,$F7,  0,  2,$FF,$E2,$E1,  3,$E6,  8,$F8,  0, $D,$E6,$F0,$EF,  1,$F0,  0,  1,  6,  4,$A2,$6C,$F2,$EF,  0,$80, $C,$D0,$D4,$D7,$DB, $C,$80,  6,$DB, $C,$DC,  6,$DB, $C,$DD,$60,$DE, $C,$80,$DE,$80,$80,  6,$DD,$12,$DE; 320
		dc.b  $C,$E3,$EF,  3,$E1,  3,$E6,$F7,$80,$60,$F8,$FE,$D1,$E6,  9,$F0,  0,  1,  6,  4,$F8,$FF,$CD,$F2,$80,$60,$80,$80,$80,$80,$80, $C,$C8,$12,$80,  6,$C8,$80,$C6,$12,$C8,$C6, $C,$C1,$18,$C5,$C8,$CB,$80, $C,$CA,$80,$CA,$12,$C9,$CA,  6,$F2,$E1,  1,$80,$60,$80,$80; 384
		dc.b $80,$80,$80,$80, $C,$CD,  6,$80,$D4,$CD,$80, $C,$CD,  6,$80,$D4,$CD,$80,$18,$F2,$F3,$E7,$E8,  3,$C6, $C,$E8, $C, $C,$E8,  3, $C,$E8, $C, $C,$F7,  0, $F,$FF,$EF,$E8,  3,$C6,  6,$E8, $E,$12,$E8,  3, $C,$E8, $F, $C,$F2,$81, $C,$82,$81,$82,$81, $C,$82,$81,  6; 448
		dc.b $80,  2,$82,$82,$82,  9,$82,  3,$81, $C,$82,$81,$82,$81, $C,$82,$81,$82,$81, $C,$82,$81,$82,$81, $C,$82,$81,  6,$80,  2,$82,$82,$82,  9,$82,  3,$F7,  0,  3,$FF,$E0,$81, $C,$82,$81,$82,$81,  6,$82,$12,$82, $C,$81,$F2,$3D,  1,  2,  2,  2,$14, $E,$8C, $E,  8; 512
		dc.b   5,  2,  5,  0,  0,  0,  0,$1F,$1F,$1F,$1F,$1A,$80,$80,$80,$20,$36,$35,$30,$31,$DF,$DF,$9F,$9F,  7,  6,  9,  6,  7,  6,  6,  8,$2F,$1F,$1F,$FF,$19,$37,$13,$80,$3A,  1,  7,  1,  1,$8E,$8E,$8D,$53, $E, $E, $E,  3,  0,  0,  0,  0,$1F,$FF,$1F, $F,$18,$28,$27; 576
		dc.b $80,$3A,$51,  8,$51,  2,$1E,$1E,$1E,$10,$1F,$1F,$1F, $F,  0,  0,  0,  2, $F, $F, $F,$1F,$18,$24,$22,$81; 640
Music8C:	dc.b   1,$85,  6,  3,  2,  4,  1,$3C,  0,  0,  1, $E,$F4,$12,  0,$81,$E8,  8,  0,$CD,$F4, $F,  1,$13,$F4,$12,  0,$30,$E8, $F,  1,$1C,$D0,  3,  0,  5,  0,$C8,$D0,  3,  0,  5,  1,$3B,$DC,  1,  0,  8,$EF,  5,$DB, $C,$DB,$DB,$DB,$E6,  2,$F8,  0,$32,$D2,$CF,$D0,$CF; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b $CD,$CF,$D2,$CF,$D0,$CF,$D6,$CF,$CD,$CF,$F8,  0,$21,$D4,$CF,$D2,$CF,$D0,$CF,$D2,$CF,$D4,$CF,$D6,$D4,$DA,$D6,$E6,$FE,$DB,  3,$D7,  3,$DB,  3,$D7,  3,$F7,  0,  4,$FF,$F4,$F6,$FF,$C6,$D4,  6,$CF,$D7,$CF,$D4,$CF,$CD,$CF,$D4,$CF,$D7,$CF,$D4,$CF,$D2,$CF,$D0,$CF; 64
		dc.b $E3,$EF,  0,$E2,  1,$B7,  6,$C3,$B7,$C3,$B7,$C3,$B7,$C3,$F8,  0,$19,$B0,  6,$B5,$B5, $C,$B0,  6,$F8,  0, $F,$B5,  6,$B3,$B3, $C,$B3,  6,$B2,$30,$E2,  1,$F6,$FF,$DB,$B0,  6,$B0,$B3,$B3,$B2,$B2,$B1,$B1,$B0,$12,$B7,  6,$BC, $C,$BA,$B8,  6,$B8, $C,$B3,  6,$B8; 128
		dc.b $B8, $C,$B7,  6,$B5,$B5, $C,$E3,$E1,  2,$F6,  0,  5,$EF,  1,$E0,$80,$80,$30,$F8,  0,$26,$C1,$12,$80,$CB,  3,$80,$CA,$80,$C6,$12,$F8,  0,$19,$C1, $C,$C8,  3,$80,$CD,$80,$CD, $C,$CD,  3,$80,$CE,$80,$CE, $C,$CE,  3,$80,$CF,$30,$F6,$FF,$D7,$80,$1E,$C3,  3,$80; 192
		dc.b $C8,$80,$CA,$80,$CB,$30,$80,$12,$C8,  3,$80,$C4,$80,$E3,$E1,  3,$F6,  0,  3,$E0,$40,$EF,  2,$F0, $C,  1,  4,  6,$80,$30,$F8,  0, $D,$D9,$F8,  0,  9,$D9,$18,$DA,$DB,$30,$F6,$FF,$F0,$D4,  4,$D2,$D5,$D4,$24,$80, $C,$CF,$D4,$D6,$D7,$30,$E3,$F2,$88,  6,$8A,$88; 256
		dc.b $8A,$88,$8A,$88,$8A,$82, $C,$82,  4,$82,$82,$82,  6,$82, $C,$82,  6,$82,$12,$82,  6,$82, $C,$82, $C,$F7,  0,  3,$FF,$E8,$82, $C,$82,  4,$82,$82,$82,  6,$82, $C,$82,  6,$82,  6,$82, $C,$82,  6,$82,  6,$82, $C,$82,  6,$82,  1,$88,  5,$8A,  6,$88,$8A,$88,$8A; 320
		dc.b $88,$8A,$F6,$FF,$B8,  8, $A,$70,$30,  0,$1F,$1F,$5F,$5F,$12, $E, $A, $A,  0,  4,  4,  3,$2F,$2F,$2F,$2F,$24,$2D,$13,$80,$3A,  1,  7,  1,  1,$8E,$8E,$8D,$53, $E, $E, $E,  3,  0,  0,  0,  0,$1F,$FF,$1F, $F,$18,$28,$27,$80,$3D,  1,  2,  2,  2,$14, $E,$8C, $E; 384
		dc.b   8,  5,  2,  5,  0,  0,  0,  0,$1F,$1F,$1F,$1F,$1A,$92,$A7,$80,$30,$30,$30,$30,$30,$9E,$D8,$DC,$DC, $E, $A,  4,  5,  8,  8,  8,  8,$BF,$BF,$BF,$BF,$14,$3C,$14,$80,$39,  1,$51,  0,  0,$1F,$5F,$5F,$5F,$10,$11,  9,  9,  7,  0,  0,  0,$2F,$2F,$2F,$1F,$20,$22; 448
		dc.b $20,$80,$3A,$42,$43,$14,$71,$1F,$12,$1F,$1F,  4,  2,  4, $A,  1,  1,  2, $B,$1F,$1F,$1F,$1F,$1A,$16,$19,$80,  0; 512
Music8D:	dc.b   1,$B8,  6,  3,  2,  6,  1,$70,  0,  0,  0,$35,  0,$12,  0,$6C,$F4, $D,  0,$CF,$F4, $A,  1,$1D,$F4, $F,  0,$30,  0,$12,  1,$6F,$D0,  3,  0,  5,  1,$6F,$DC,  6,  0,  5,  1,$6F,$DC,  0,  0,  4,$E1,  3,$F6,  0,  6,$F0,$1A,  1,  6,  4,$EF,  0,$D4,  3,$80,$D1; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b $80,$D1,$80,$D4,$D4,$80,$18,$80, $C,$C6,$C8,$C9,$CB,$C9,$C8,$C9,$CD,$60,$80, $C,$C6,$C8,$C9,$CB,$C9,$C8,$C9,$CE,$30,$D0,$18,$D1,$C6, $C,$C6,$C6,$C6,$C8,$C8,$C8,$C8,$F6,$FF,$DC,$EF,  1,$E2,  1,$B5,  3,$80,$A9,$80,$A9,$80,$B5,$B5,$80,$12,$B1,  3,$B0,$F8,  0; 64
		dc.b $25,$B1,  3,$B0,$F8,  0,$1F,$AD,  6,$AA, $C,$AA,  9,$AA,  3,$AA,  6,$AA, $C,$A5,  6,$AC,$AC, $C,$AC,  6,$A9,$A9, $C,$B1,  3,$B0,$E2,  1,$F6,$FF,$DA,$AE, $C,$AE,  9,$AE,  3,$AE,  6,$AE, $C,$A9,  6,$AE,  3,$A9,$AE, $C,$A9,  6,$AE, $C,$AC,$AA,$AA,  9,$AA,  3; 128
		dc.b $AA,  6,$AA, $C,$A5,  6,$AC,$AC, $C,$AC,  6,$AD,$AD, $C,$E3,$EF,  2,$D9,  3,$80,$CD,$80,$CD,$80,$D9,$D9,  3,$80,$18,$F8,  0,$25,$D7,  6,$80,$D5,  3,$80,$D4,$80,$D1,$12,$F8,  0,$18,$D7,  6,$80,$D5,  3,$80,$D4,$80,$D1,$12,$C6,$18,$C8, $C,$C9,$C8,$18,$C9, $C; 192
		dc.b $CB,$F6,$FF,$DA,$80,$1E,$BA,  3,$80,$BD,$80,$C1,$80,$C6,  3,$C4,$C6,$30,$D5,  6,$80,$D2,  3,$80,$CE,$80,$CB,$18,$E3,$EF,  2,$E6,$FC,$E1,  3,$D9,  3,$80,$CD,$80,$CD,$80,$D9,$D9,  3,$80,$18,$E6,  4,$EF,  3,$BA,  6,$B5,$BC,$B5,$BD,$B5,$BC,$B5,$BA,$B5,$BC,$B5; 256
		dc.b $BD,$B5,$BC,$B5,$BA,$B5,$BC,$B5,$BD,$B5,$BA,$B5,$BC,$B5,$BF,$B5,$BD,$B5,$BC,$B5,$F7,  0,  2,$FF,$DB,$D5,  3,$D4,$D3,$D2,$F7,  0,  4,$FF,$F7,$D7,$D6,$D5,$D4,$F7,  0,  4,$FF,$F8,$F6,$FF,$C5,$F2,$88,  6,$8A,$8A,$88,  3,$88,  9,$82,  3,$82,  3,$82,  3,$82,  3; 320
		dc.b $8A,$8A,$82, $C,  9,  3,  6,  6,$88,$8A,$82,$82, $C,  6, $C, $C, $C,  9,  3,  6,  6,$88,  3,$88,$8A,  6,$82,  6, $C,  6,  6, $C,  6,$F7,  0,  2,$FF,$DD, $C,  9,  3,  6, $C,  6,$88,  6,$8A,$88,$8A,$88,$8A,$88,$8A,$F6,$FF,$CB,$3D,  1,  2,  2,  2,$14, $E,$8C; 384
		dc.b  $E,  8,  5,  2,  5,  0,  0,  0,  0,$1F,$1F,$1F,$1F,$1A,$92,$A7,$80,$20,$36,$35,$30,$31,$DF,$DF,$9F,$9F,  7,  6,  9,  6,  7,  6,  6,  8,$2F,$1F,$1F,$FF,$19,$37,$13,$80,$3A,  1,  7,  1,  1,$8E,$8E,$8D,$53, $E, $E, $E,  3,  0,  0,  0,  0,$1F,$FF,$1F, $F,$18; 448
		dc.b $28,$27,$80,$3A,$42,$43,$14,$71,$1F,$12,$1F,$1F,  4,  2,  4, $A,  1,  1,  2,  2,$1F,$1F,$1F,$1F,$1A,$16,$19,$80; 512
Music8E:	dc.b   0,$D8,  6,  3,  2,  3,  0,$BE,  0,  0,  0,$30,$F4, $A,  0,$4D,$DC, $A,  0,$6F,$F4,$15,  0,$8B,$F4,$15,  0,$A7,$F4,$14,  0,$32,$D0,  5,  0,  5,  0,$AE,$DC,  7,  0,  5,  0,$BD,$DC,  0,  0,  4,$EF,  0,$80,  6,$B8,$BA,$BC,$BD,$BF,$C1,$C2,$C4, $C,$D4,  2,$E7; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b $D5,  1,$D4,  3,$D0,$F0, $C,  1,  8,  4,$D2,$33,$F2,$EF,  1,$E8, $B,$E2,  1,$C4,  3,$C4,$B8,  6,$B8,$C4,  3,$C4,$B8,  6,$B8,$C4,  3,$C4,$80,  6,$80, $C,$B8,  9,$E8,  0,$BA,$33,$E2,  1,$F2,$E0,$80,$EF,  2,$E8,  6,$C9,  3,$C9,$80, $C,$C9,  3,$C9,$80, $C,$C9; 64
		dc.b   3,$C9,$80,$12,$E8,  0,$C9,  9,$CB,$33,$F2,$E0,$40,$EF,  2,$E8,  6,$C6,  3,$C6,$80, $C,$C6,  3,$C6,$80, $C,$C6,  3,$C6,$80,$12,$E8,  0,$C6,  9,$C8,$33,$F2,$EF,  3,$F0, $D,  1,  2,  5,$C4,  6,$C9,$C8,$C4,$C9,$C8,$C4,$C9,$C8, $C,$C9,  9,$C8,$33,$F2,$82,  3; 128
		dc.b $82,$81,  6,$81,$82,  3,$82,$81,  6,$81,$82,  3,$82,$88,$88,$8B,$8B,  3,$8B,$8B,$82,  9,$33,$F2,$3D,  1,  2,  0,  1,$1F, $E, $E, $E,  7,$1F,$1F,$1F,  0,  0,  0,  0,$1F, $F, $F, $F,$17,$8D,$8C,$8C,$3A,$61,$3C,$14,$31,$9C,$DB,$9C,$DA,  4,  9,  4,  3,  3,  1; 192
		dc.b   3,  0,$1F, $F, $F, $F,$21,$47,$31,$80,$3D,  1,  1,  1,  1,$8E,$52,$14,$4C,  8,  8, $E,  3,  0,  0,  0,  0,$1F,$1F,$1F,$1F,$1B,$80,$80,$9B,$3D,  1,  1,  1,  1,$8E,$52,$14,$4C,  8,  8, $E,  3,  0,  0,  0,  0,$1F,$1F,$1F,$1F,$1B,$80,$80,$9B,$3D,  1,  2,  2; 256
		dc.b   2,$10,$50,$50,$50,  7,  8,  8,  8,  1,  0,  0,  0,$2F,$1F,$1F,$1F,$1C,$82,$82,$82,  0; 320
Music8F:	dc.b   0,$EB,  6,  3,  2,$13,  0,$E2,  0,  0,  0,$30,$E8, $A,  0,$65,$F4, $F,  0,$84,$F4, $F,  0,$99,$F4, $D,  0,$CF,$DC,$16,  0,$E1,$D0,  3,  0,  5,  0,$E1,$DC,  6,  0,  5,  0,$E1,$DC,  0,  0,  4,$EF,  0,$F0,$20,  1,  4,  5,$80, $C,$CA,$12,$80,  6,$CA,$80,$CB; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b $12,$C8,$1E,$CA,  6,$80,$CA,$80,$CA,$80,$C6,$80,$C4,$12,$C8, $C,$80,$12,$C9,  4,$80,$C9,$C8,  6,$80,$C7,$80,$C6,$80,$F0,$28,  1,$18,  5,$C5,$60,$F2,$EF,  1,$80,  1,$D9,  6,$80,$D9,$80,$D6,$80,$D6,$80,$D7,$15,$D7,$1B,$D9,  6,$80,$D9,$80,$D6,$80,$D6,$80,$DC; 64
		dc.b $15,$DC,$1B,$F2,$EF,  1,$D6, $C,$D6,$D2,$D2,$D4,$15,$D4,$1B,$D6, $C,$D6,$D2,$D2,$D7,$15,$D7,$1B,$F2,$EF,  2,$E2,  1,$AE,  6,$80,$AE,$80,$A9,$80,$A9,$80,$AC,$15,$AB, $C,$AC,  3,$AB, $C,$AE,  6,$80,$AE,$80,$A9,$80,$A9,$80,$B3,$15,$B2, $C,$B3,  3,$B2, $C,$AE; 128
		dc.b   4,$80,$AE,$AD,  6,$80,$AC,$80,$AB,$80,$AB,$60,$E2,  1,$F2,$EF,  3,$80,$30,$D7,$12,$80,  3,$D7,$1B,$80,$30,$DC,$12,$80,  3,$DC,$1B,$F2,$80,$18,$81,$F7,  0,  4,$FF,$F9,$F2,$3A,$51,  8,$51,  2,$1E,$1E,$1E,$10,$1F,$1F,$1F, $F,  0,  0,  0,  2, $F, $F, $F,$1F; 192
		dc.b $18,$24,$22,$81,$3C,$33,$30,$73,$70,$94,$9F,$96,$9F,$12,  0,$14, $F,  4, $A,  4, $D,$2F, $F,$4F,$2F,$33,$80,$1A,$80,$3A,  1,  7,  1,  1,$8E,$8E,$8D,$53, $E, $E, $E,  3,  0,  0,  0,  7,$1F,$FF,$1F, $F,$1C,$28,$27,$80,$1F,$66,$31,$53,$22,$1C,$98,$1F,$1F,$12; 256
		dc.b  $F, $F, $F,  0,  0,  0,  0,$FF, $F, $F, $F,$8C,$8D,$8A,$8B,  0; 320
Music90:	dc.b   0,$F9,  6,  3,  1,  7,  0,$E8,  0,  0,  0,$30,$E5,  8,  0,$5B,$E8,  8,  0,$9A,$F4, $F,  0,$C2,$F4, $F,  0,$E7,$F4, $A,  0,$E7,$D0,  3,  0,  5,  0,$E7,$DC,  6,  0,  5,  0,$E7,$DC,  0,  0,  4,$EF,  0,$80,$30,$E9,  1,$80, $C,$CC,$12,$80,  6,$CC,$80,$CD, $C; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b $80,  6,$CA,$18,$80,  6,$F7,  0,  3,$FF,$EA,$CE,  6,$80,$CE,$80,$CE,$80,$C9,$80,$C7, $C,$80,  6,$CB,$4E,$F2,$EF,  1,$E6,  2,$E9,$F4,$E2,  1,$C6, $C,$C5,$C4,$C3,$E6,$FE,$E9, $C,$EF,  2,$BA,  6,$80,$BA,$80,$B5,$80,$B5,$80,$B8,$12,$B7, $C,$B8,  6,$B7, $C,$E9; 64
		dc.b   1,$F7,  0,  3,$FF,$E9,$E9,$FD,$BC,  6,$80,$BC,$80,$B7,$80,$B7,$80,$C1, $C,$80,  6,$C0,$4E,$E2,  1,$F2,$EF,  3,$80,$30,$CD,  6,$80,$CD,$80,$CA,$80,$CA,$80,$CB,$12,$CB,$1E,$F7,  0,  3,$FF,$EF,$CD,  6,$80,$CD,$80,$CA,$80,$CA,$80,$D0, $C,$80,  6,$D0,$1E,$E7; 128
		dc.b $30,$F2,$EF,  3,$80,$30,$CA,  6,$80,$CA,$80,$C6,$80,$C6,$80,$C8,$12,$C8,$1E,$F7,  0,  3,$FF,$EF,$CA,  6,$80,$CA,$80,$C6,$80,$C6,$80,$CB, $C,$80,  6,$CB,$4E,$F2,$80,$30,$81, $C,$82,$F7,  0, $E,$FF,$F9,$81, $C,$82,  6,$81, $C,$F2,$3A,$51,  8,$51,  2,$1E,$1E; 192
		dc.b $1E,$10,$1F,$1F,$1F, $F,  0,  0,  0,  2, $F, $F, $F,$1F,$18,$24,$22,$81,$3B,$52,$31,$31,$51,$12,$14,$12,$14, $D,  0, $D,  2,  0,  0,  0,  1,$4F, $F,$5F,$3F,$1E,$18,$2D,$80,$3A,$61,$3C,$14,$31,$9C,$DB,$9C,$DA,  4,  9,  4,  3,  3,  1,  3,  0,$1F, $F, $F,$AF; 256
		dc.b $21,$47,$31,$80,$1C,$6F,  1,$21,$71,$9F,$DB,$9E,$5E, $F,  7,  6,  7,  8, $A, $B,  0,$8F,$8F,$FF,$FF,$18,$8D,$26,$80,  0; 320
Music91:	dc.b  $F,$94,  6,  3,  1,$33, $C,$3F,  0,  0,  0,$30,$F4,$12,  1,$78,  0, $B,  4,$2D,$F4,$14,  5,$D7,$F4,  8,  8,$1D,$F4,$20,  9,$39,$D0,  1,  0,  0, $A,$67,$D0,  3,  0,  0, $B,$58,  0,  3,  0,  4,$E2,  1,$80,$60,$EF,$1C,$E6,$F8,$E8,  6,$F8, $D,$7E,$E0,$C0,$E8; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b   0,$EF,  3,$F0, $D,  1,  7,  4,$80,$30,$F8,  0,$F3,$CD,$CB,$18,$C9, $C,$C8,$18,$C9, $C,$C8,$18,$C4,$54,$F8,  0,$E3, $C,$C2,$18,$C6, $C,$C4,$18,$C6, $C,$C4,$18,$BD,$24,$80,$60,$80,$80,$80,$F4,$E2,  1,$EA, $F,$EF,  5,$E6,  2,$80,  6,$C1,$C4,$C1,$C4,  9,$C6; 64
		dc.b $C8, $C,$C9,  6,$C8,$C6,$C4,  9,$C6,  6,$C4,  3,$C1,  6,$80,  6,$C6,$C9,$C6,$C9,  9,$CB,$CD, $C,$CE,  6,$CD,$CB,$C9, $C,$C6, $C,$CB,  4,$C9,$CB,$C9,$24,$E9,$F4,$E6,  9,$EF,  8,$80,$18,$C6,  6,$C8,$C9,$CD,$F8, $D,$74,$EF, $B,$E6,$EB,$80, $C,$C4,$C6,$D0,$F8; 128
		dc.b  $D,$A9,$CD,$1E,$D9,  6,$D5,$18,$80,$24,$E2,  1,$EA, $A,$EF, $F,$E9, $C,$E6, $B,$F8, $E,$6E,$E2,  1,$EA,  7,$80,$60,$E2,  1,$EA,  3,$80,$30,$EF,$17,$E6, $E,$80,  4,$CE,  8,$CD,  3,$80,$CB,$80,$C9,$80,$CB,$80,$C9,  4,$C6,$80,  2,$C7,$80,  4,$C7,  8,$C9,  3; 192
		dc.b $80,$C7,$80,$C6,  4,$C7,$80,  2,$C9, $E,$80,  6,$CD,  2,$80,  4,$CD, $C,$CE,$CD, $A,$CB,  2,$E2,  1,$EA,  4,$E6,$F5,$EF,$1A,$80,$60,$F8,  0,$2D,$E6,  9,$E1,  3,$EF,$18,$F0,  0,  1,  6,  4,$F8,  6,$D1,$E6,$EF,$EF,$1B,$E1,  2,$96,$6C,$E7,$60,$E2,  1,$F2,$C9; 256
		dc.b  $C,$C6,$18,$C9, $C,$C8,$18,$C9, $C,$C8,$18,$C4,$48,$C6, $C,$E3,$80, $C,$CA,$15,$80,  3,$CA,  6,$80,$CB, $F,$80,  3,$C8,$18,$80,  6,$CA,  6,$80,$CA,$80,$CA,$80,$C6,$80,$C4, $F,$80,  3,$C8,$18,$80,  6,$F7,  0,  2,$FF,$DA,$E3,$80,$60,$EF,$1D,$A7, $C,$A7,$B0; 320
		dc.b $B0,$AC,$AC,$AE,$AE,$A7,$A7,$AE,$AE,$AB,$AB,$AC,$AC,$A5,$A5,$AC,$AC,$AB,$AB,$AC,$AC,$A2,$A2,$A2,$A2,$A7,$A7,$A7,$A9,$F7,  0,  2,$FF,$DB,$EF,  0,$E8,  5,$AA, $C,$F8,  2,$6A,$E8,  5,$A9, $C, $C, $C, $C, $C,$E8,  0,$A5,$A7,$A9,$F7,  0,  2,$FF,$E8,$E8,  5,$AA; 384
		dc.b $F8,  2,$52,$E8,  5,$A9,$F8,  2,$4C,$E8,  5,$A7,$F8,  2,$46,$E8,  5,$A5, $C, $C, $C, $C, $C,$E8,  0,$A0,$A2,$A4,$E8,  5,$A5,$F7,  0,$18,$FF,$FB,$E8,  0,$A5,  6,$80,$A5, $C,$A2,  6,$80,$A2, $C,$A3,  6,$80,$A3, $C,$A4,  6,$80,$A4, $C,$EF,  6,$E9,$E8,$E6,  2; 448
		dc.b $B1, $F,$80,  3,$B5,$80,$B8,  9,$80,  3,$BA,  9,$80,  3,$BC, $F,$80,  3,$BA,$80,$B8,  9,$80,  3,$B5,  9,$80,  3,$E9,  5,$F7,  0,  2,$FF,$DE,$E9,$F6,$B1, $F,$80,  3,$B5,$80,$B8,  9,$80,  3,$B5,  9,$80,  3,$B1,  6,$80,$12,$B5,$18,$E6,  1,$EF,  9,$AE,  3,$80; 512
		dc.b $AE,  6,$B5,  3,$80,$B5,  6,$B3,  3,$80,$B3,  6,$B5,  3,$80,$B5,  6,$F7,  0,  2,$FF,$E8,$B3,  3,$80,$B3,  6,$BA,  3,$80,$BA,  6,$B6,  3,$80,$B6,  6,$BA,  3,$80,$BA,  6,$F7,  0,  2,$FF,$E8,$B0,  3,$80,$B0,  6,$B6,  3,$80,$B6,  6,$B3,  3,$80,$B3,  6,$B6,  3; 576
		dc.b $80,$B6,  6,$B5,  3,$80,$B5,  6,$BC,  3,$80,$BC,  6,$B9,  3,$80,$B9,  6,$BC,  3,$80,$BC,  6,$AE,  3,$80,$AE,  6,$B5,  3,$80,$B5,  6,$B1,  3,$80,$B1,  6,$B5,  3,$80,$B5,  6,$AE,  3,$80,  9,$80,$24,$E6,$F8,$B1,  6,$80,  3,$B1,$80,  6,$B1,$12,$80,  6,$B1,  2; 640
		dc.b $80,  1,$B1,  2,$80,  1,$AF,  6,$80,  3,$AF,  3,$80,  6,$AE,$12,$80,  6,$AE,  2,$80,  1,$AE,  2,$80,  1,$B3,  6,$80,  3,$B3,  6,$80,  3,$B3,  2,$80,  1,$B3,  2,$80,  1,$E9,$FF,$F7,  0,  4,$FF,$EA,$E9,  4,$AC,  6,$80,  3,$AC,$80,  6,$AC,$12,$80,  6,$AC,  2; 704
		dc.b $80,  1,$AC,  2,$80,  1,$B0,  6,$80,  3,$B0,$80,  6,$B0,$12,$80,  6,$B3,  2,$80,  1,$B0,  2,$80,  1,$B1,  6,$80,  3,$B1,$80,  6,$B1,$12,$80,  6,$B5,  2,$80,  1,$B6,  2,$80,  1,$B8,  6,$80,$AC,$24,$EF,$10,$E9, $C,$E6,  7,$E8,  6,$F8,  0,$E3,$E9,  6,$F8,  0; 768
		dc.b $DE,$E9,$FF,$F8,  0,$D9,$E9,  2,$F8,  0,$D4,$E9,$F9,$F7,  2,  2,$FF,$E8,$E8,  0,$E9,$F4,$E6,$FC,$EF,$14,$80,$30,$80,$30,$BA,  3,$80,$BA,$80,$B8,$80,$B8,$80,$B6,$80,$B6,$80,$B5,$80,$B5,  2,$80,$BB,$E6,  2,$80,  4,$BB,  8,$BD,  3,$80,$BB,$80,$BA,  6,$80,$BB; 832
		dc.b   4,$BA,$80,  2,$B8,$80,  4,$B8,  8,$BA,  3,$80,$B8,$80,$B6,$80,$B6,$80,$B8,  4,$B6,$80,  2,$B5,$80,  4,$B5,  8,$B5,  3,$80,$B5,$80,$BA,  9,$80,  3,$BA, $A,$B3,  2,$E9, $C,$E6,$FE,$EF,$19,$80,$60,$AE,  6,$80,$AE,$80,$A9,$80,$A9,$80,$AC,$12,$AB, $C,$AC,  6; 896
		dc.b $AB, $C,$AE,  6,$80,$AE,$80,$A9,$80,$A9,$80,$B3,$12,$B2, $C,$B3,  6,$B2, $C,$F7,  0,  2,$FF,$DA,$AC,  6,$80,$A9,$80,$AA,$80,$AB,$80,$AC,  6,$AC,  6,$A9,  6,$80,$AA,$80,$AC,$80,$A9,  6,$80,$A9,$80,$AD,$80,$AD,$80,$B0,  6,$80,$B0,$80,$B3,$80,$B3,$80,$80, $C; 960
		dc.b $AE,$12,$80,  6,$AE,$12,$AD,$12,$AE,  6,$80,$E6,$FD,$A2,$6C,$E7,$60,$F2,  0,  1, $C, $C, $C, $C, $C, $C,$E8,  0, $C,$E3,$B1,  3,$B1,$AC,$AC,$AE,$AE,$AC,$AC,$F7,  0,  2,$FF,$F3,$E3,$80,$60,$F7,  0,  8,$FF,$FA,$EF,$1F,$E6,  1,$E0,$40,$CB,  6,$CD,$CF,$D0,$CD; 1024
		dc.b $CF,$D0,$D2,$CF,$D0,$D2,$D4,$D2,$D4,$D5,$D7,$E0,$80,$D9,$E0,$40,$D5,$E6,  2,$F7,  0, $D,$FF,$F4,$E0,$C0,$EF,  2,$E6,$E5,$E9,$E8,$D0,  6,$D2,$D5, $C,$D2,$80,$4E,$80,$D0,  6,$D2,$D5, $C,$D9,$80,$4E,$80,$D0,  6,$D2,$D5, $C,$D2,$80,$36,$80,$D5,  6,$80,$12,$D2; 1088
		dc.b $18,$D0,  6,$80,$D2,$80,$D5,$80,$F4,$EF,  4,$E6,$FE,$C9,  1,$E7,$C8,$1B,$80,  8,$C7,  1,$E7,$C6,$1B,$80,  8,$F7,  0,  2,$FF,$EE,$C9,  1,$E7,$C8, $B,$80, $C,$C7,  1,$E7,$C6, $B,$80, $C,$CA,  1,$E7,$C9,$1B,$80,  8,$C9,  1,$E7,$C8,$24,$E7,$18,$E7,$5A,$80,  6; 1152
		dc.b $E9,$18,$80,$60,$80,$80,$30,$E9,$E8,$EF,  8,$E9, $C,$E6,  3,$E1,  2,$80,$18,$C6,  6,$C8,$C9,$CD,$F8,  9,$4F,$EF, $D,$E9, $C,$E6, $B,$80, $C,$C4,$C6,$D0,$F8,  9,$82,$EF, $A,$E6,$EC,$80,  6,$E1,$14,$C4,  1,$E7,$E1,  0,  2,$C6,  3,$E8,  5,$C9,  3,$C9,  6,$C6; 1216
		dc.b   3,$C9,$E8,  0,$C9,$E6,$FC,$E9,$33,$EF, $E,$B4,  3,$E6,  7,$B4,$E6,  7,$B4,$E6,  7,$B4,$EF, $A,$E6,$EF,$E9,$CD,$CD,  3,$CE,$D0,$80,  9,$E1,$EC,$D5,  1,$E7,$E1,  0,$F0,$2C,  1,  4,  4,$D5,$23,$F4,$EF, $F,$E6,$FF,$E1,  3,$F8, $A, $B,$E1,  0,$EF,$15,$E6,  9; 1280
		dc.b $80,$30,$80,$30,$80,$2E,$C2,  2,$80,  4,$C2,  8,$C2,  3,$80,$C2,$80,$C1,  3,$80,$13,$BF,  2,$80,  4,$BF,  8,$BF,  3,$80,$BF,$80,$BD,  3,$80,$15,$80,  4,$D2,  8,$D0,  3,$80,$D0,$80,$CE,$80,$CE,$80,$CD,  4,$CE,  2,$CD,  4,$CB,  2,$EF, $A,$E6,$F9,$80,$60,$CD; 1344
		dc.b   6,$80,$CD,$80,$CA,$80,$CA,$80,$CB,$12,$CB,$1E,$CD,  6,$80,$CD,$80,$CA,$80,$CA,$80,$D0,$12,$D0,$1E,$F7,  0,  2,$FF,$E2,$80, $C,$CB,$12,$80,  6,$CB,$80,$CA,$12,$CB,$CA, $C,$C5,$18,$C8,$CB,$D1,$80, $C,$CD,$80,$CD,$12,$CC,$CD,  6,$80,$EF,$19,$E6,$F8,$E1,  3; 1408
		dc.b $A2,$6C,$E7,$60,$F2,$CB,  6,$CD,$CF,$D0,$CD,$CF,$D0,$D2,$CF,$D0,$D2,$D4,$D2,$D4,$D5,$D7,$E3,$EF,$20,$80,$60,$E6,  8,$F8,  1,$2D,$C3, $C,$C3,$80,$80,$C6,$C6,$80,$80,$F8,  1,$21,$C6,$24,$24,$18,$E0,$80,$F8,  1,$25,$E6,$F2,$C5,  1,$E7,$C4,$1B,$80,  8,$C3,  1; 1472
		dc.b $E7,$C2,$1B,$80,  8,$F7,  0,  2,$FF,$EE,$C5,  1,$E7,$C4, $B,$80, $C,$C3,  1,$E7,$C2, $B,$80, $C,$C7,  1,$E7,$C6,$1B,$80,  8,$C5,  1,$E7,$C4,$24,$E7,$18,$E7,$5A,$80,  6,$E9,$18,$80,$60,$80,$80,$5A,$E0,$C0,$EF, $A,$E9,$F4,$E6,  5,$D4,  9,$80,  3,$D4,$80,$D5; 1536
		dc.b   6,$80,$D4, $C,$80,  6,$F7,  0,  2,$FF,$EF,$80,$12,$D5,  3,$80, $F,$D5,  3,$80,$1B,$D5,  3,$80, $F,$D5,  3,$80,  9,$CE,  9,$80,  3,$CE,$80,$D2,  6,$80,$CE, $C,$80,  6,$D1,  9,$80,  3,$D1,$80,$D4,  6,$80,$D1, $C,$80,  6,$80,$80, $C,$D5,  3,$80, $F,$D5,  3; 1600
		dc.b $80, $F,$D5,  3,$80,$2D,$E9,$F4,$E6,  3,$EF, $C,$E0,$80,$F8,  8,$54,$EF,$11,$E6,$F6,$E9,$18,$F8,  0,$BE,$80, $C,$E1,$EC,$C6,  2,$E1,  0,$E7, $A,$80,  3,$C6,$80,$80,$C6,$80,  9,$F8,  0,$A9,$E1,$EC,$C6,  2,$E1,  0, $A,$80,  6,$F0,$18,  1,  7,  4,$E1,$E2,$C6; 1664
		dc.b   2,$E7,$E1,  0,$1C,$E1,  0,$E1,  3,$F8,  0,$BD,$E1,  0,$E0,$C0,$EF, $A,$E6,$F5,$80,$60,$CA,  6,$80,$CA,$80,$C6,$80,$C6,$80,$C8,$12,$C8,$1E,$CA,  6,$80,$CA,$80,$C6,$80,$C6,$80,$CB,$12,$CB,$1E,$F7,  0,  2,$FF,$E2,$EF,$18,$E1,  3,$E6,  8,$F8,  1,  5,$EF,$19; 1728
		dc.b $E6,$F0,$F0,  0,  1,  6,  4,$A2,$6C,$E7,$60,$F2,$C8,$24,$24,$18,$C6,$24,$24,$18,$C4,$24,$24,$18,$E3,$EF,  2,$E9,$E8,$E6, $D,$F8,  0,$26,$BF,$BF,$F7,  0,  2,$FF,$F7,$F8,  0,$1C,$B5,$B5,$BD,$BD,$BA,$BA,$B6,$B6,$B3,$B3,$BC,$BC,$E6,  3,$E9, $C,$EF,  1,$D0,$18; 1792
		dc.b $D2,$D4,$E9,$F4,$EF,  4,$E3,$C1, $C,$C1,$BD,$BD,$BA,$BA,$B6,$B6,$BF,$BF,$BC,$BC,$B8,$B8,$E3,$80, $C,$E1,$EC,$C4,  2,$E1,  0,$E7,  6,$80,  1,$C4,  3,$80,$18,$80, $C,$E1,$EC,$CA,  2,$E1,  0,$E7,  6,$80,  1,$CA,  3,$80,$18,$80, $C,$E1,$EC,$C9,  2,$E1,  0,$E7; 1856
		dc.b   6,$80,  1,$C9,  3,$80,$18,$E3,$E6,  8,$EF,$16,$80,$30,$80,$30,$E5,  1,$F8,  0,$35,$E5,  2,$EF,$12,$F0,  1,  1,  1,  4,$CB,  2,$80,  4,$CB,  8,$CB,  3,$80,$CB,$80,$C9,$80,$D2,$80,$CE,$80,  7,$C7,  2,$80,  4,$C7,  8,$C7,  3,$80,$C7,$80,$C6,  3,$80,$13,$C6; 1920
		dc.b  $E,$CA, $C,$CD,$D6, $A,$D7,  2,$E3,$AF,  1,$E7,$AE,  4,$80,  7,$AF,  1,$E7,$AE,  4,$80,  7,$B1,  1,$E7,$B0,  4,$80,  7,$B1,  1,$E7,$B0,  4,$80,  7,$B2,  1,$E7,$B1,  4,$80,  7,$B2,  1,$E7,$B1,  4,$80,  7,$B3,  1,$E7,$B2,  4,$80,  7,$B3,  1,$E7,$B2,  4,$80; 1984
		dc.b   3,$E3,$80, $C,$D0,$D4,$D7,$DB,$80,  6,$DB, $C,$DC,  6,$DB, $C,$DD,$54,$80, $C,$DE,$80,$DE,$80,$12,$DD,$DE, $C,$E3,$EF,$20,$80,$60,$E6,$F0,$F8,  1,  7,$BF, $C, $C,$80,$18,$C3, $C, $C,$80,$18,$F8,  0,$FA,$C3,$24,$24,$18,$E0,$40,$F8,$FE,$DE,$E6,$F2,$C2,  1; 2048
		dc.b $E7,$C1,$1B,$80,  8,$C0,  1,$E7,$BF,$1B,$80,  8,$F7,  0,  2,$FF,$EE,$C2,  1,$E7,$C1, $B,$80, $C,$C0,  1,$E7,$BF, $B,$80, $C,$C3,  1,$E7,$C2,$1B,$80,  8,$C2,  1,$E7,$C1,$24,$E7,$18,$E7,$5A,$80,  6,$E9,$18,$E0,$C0,$E6,  3,$E9, $C,$EF,  7,$80,$4E,$B8,  3,$BA; 2112
		dc.b $BD,$80,$BA,$80,$51,$C6,  3,$C2,$BD,$80,$C2,$80,$5D,$EF, $A,$E9,$E8,$E6,  2,$D0,  9,$80,  3,$D0,$80,$D2,  6,$80,$D0, $C,$80,  6,$F7,  0,  2,$FF,$EF,$80,$12,$D2,  3,$80, $F,$D2,  3,$80,$1B,$D2,  3,$80, $F,$D2,  3,$80,  9,$CB,  9,$80,  3,$CB,$80,$CE,  6,$80; 2176
		dc.b $CB, $C,$80,  6,$CD,  9,$80,  3,$CD,$80,$D1,  6,$80,$CD, $C,$80,$18,$D2,  3,$80, $F,$D2,  3,$80, $F,$D2,  3,$80,$2D,$EF, $C,$E0,$40,$E9,$F4,$E6,  3,$F8,  5,$A8,$EF,$12,$E9,$24,$E6,$F4,$F8,  6,$7C,$CD,$CE,$D0,$F8,  6,$76,$D0,$CE,$CD,$E9,$F4,$F8,$FE,$8A,$E0; 2240
		dc.b $C0,$EF,$1A,$E1,  3,$E6,$F8,$80,$60,$F8,$F8,$45,$E6,  0,$EF,$1A,$80,$60,$80, $C,$CD,  6,$80,$D4,$CD,  6,$80, $C,$CD,  6,$80,$D4,$CD,  6,$80,$18,$E6,  5,$80, $C,$AE,$80,$AE,$F2,$C4,$24,$24,$18,$C3,$24,$24,$18,$C1,$24,$24,$18,$E3,$80,$60,$F5,  8,$EC,  3,$E8; 2304
		dc.b   6,$F8,  4,$77,$F5,  1,$E8,  0,$EC,$FD,$80,$18,$C9,  6,$80,$1E,$C9, $C,$80,$18,$80,$18,$C8,  6,$80,$1E,$C8, $C,$80,$18,$F7,  0,  3,$FF,$E8,$80,$18,$C6,  6,$80,$1E,$C6, $C,$80,$18,$80,$18,$C4,  6,$80,$1E,$C4, $C,$80,$18,$F5,  5,$F0, $E,  1,  1,  3,$E8,$10; 2368
		dc.b $C1,$24,$BF,$C1,$BF,$C1, $C,$80,$BF,$80,$C2,$24,$E8,  0,$C1,$60,$E7,$3C,$F4,$F5,  9,$EC,  1,$80,  6,$CD, $C,$CD,$CD,$CD,  6,$80,$CD, $C,$CD,$CD,  3,  9,  6,$E9,  5,$F7,  0,  2,$FF,$EA,$E9,$F6,$80,  6,$CD, $C,$CD,$CD,$CD,  6,$80,$30,$F5,  8,$EC,  1,$F8,  4; 2432
		dc.b $91,$80,  2,$80,$30,$EC,  3,$E9,$F4,$F5,  5,$F8,  5,$17,$E9, $C,$EC,$FC,$F5,  0,$F8,  0,$72,$80, $C,$C2,$80,  3,$C2,$80,$80,$C2,$80,  9,$F8,  0,$64,$C2, $C,$80,  6,$C2,$1E,$F5,  6,$EC,  4,$80,$30,$80,$30,$E5,  1,$F8,$FD,$D2,$E5,  2,$CB,  2,$80,  4,$CB,  8; 2496
		dc.b $CB,  3,$80,$CB,$80,$C9,$80,$D2,$80,$CE,$80,  7,$C7,  2,$80,  4,$C7,  8,$C7,  3,$80,$C7,$80,$C6,  3,$80,$13,$C6, $E,$CA, $C,$CD,$D6, $A,$D7,  2,$80,$60,$80,$80,$80,$80,$EC,$FF,$80, $C,$C8,$12,$80,  6,$C8,$80,$C6,$12,$C8,$C6, $C,$C1,$18,$C5,$C8,$CB,$80, $C; 2560
		dc.b $CA,$80,$CA,$12,$C9,$CA,  6,$F2,$80, $C,$C1,  7,$80,  2,$C1,  3,$80,$18,$80, $C,$C7,  7,$80,  2,$C7,  3,$80,$18,$80, $C,$C6,  7,$80,  2,$C6,  3,$80,$18,$E3,$80,$60,$F7,  0,  8,$FF,$FA,$80,  2,$F8,$FB,$53,$EC,$FE,$F5,  1,$80,$16,$CD,  6,$80,$1E,$CD, $C,$80; 2624
		dc.b $18,$80,$18,$CB,  6,$80,$1E,$CB, $C,$80,$18,$80,$18,$CD,  6,$80,$1E,$CD, $C,$80,$18,$80,$18,$CB,  6,$80,$1E,$CB, $C,$80,$18,$F7,  0,  2,$FF,$E8,$80,$18,$C9,  6,$80,$1E,$C9, $C,$80,$18,$80,$18,$C8,  6,$80,$1E,$C8, $C,$80,$18,$E8,  6,$F5,  6,$D5, $C,$D4,$D2; 2688
		dc.b $D0,$F7,  0,  8,$FF,$F7,$E8,  0,$F5,  9,$EC,  1,$80,  6,$D0, $C,$D0,$D0,$D0,  6,$80,$D0, $C,$D0,$D0,  3,  9,  6,$E9,  5,$F7,  0,  2,$FF,$EA,$E9,$F6,$80,  6,$D0, $C,$D0,$D0,$D0,  6,$80,$30,$80,  2,$E1,  1,$EC,  3,$F8,  3,$5A,$E1,  0,$80,$30,$EC,  1,$E9,$F4; 2752
		dc.b $F5,  5,$F8,  3,$8B,$E9, $C,$EC,$FD,$E8,  3,$D5,  3,$D5,$DC,$D5,$DA,$D5,$D9,$D5,$F7,  0,  2,$FF,$F3,$D3,$D3,$DA,$D3,$D8,$D3,$D6,$D3,$F7,  0,  2,$FF,$F4,$D2,$D2,$D9,$D2,$D7,$D2,$D5,$D2,$F7,  0,  4,$FF,$F4,$F7,  1,  2,$FF,$D4,$80,$60,$80,$80,$80,$80,$80,$80; 2816
		dc.b $80,$80,$E6, $C,$E1,  2,$EC,  2,$80, $C,$CD,  6,$80,$D4,$CD,  6,$80, $C,$CD,  6,$80,$D4,$CD,$F2,$F3,$E7,$E8,  4,$C6, $C,$F7,  0,$48,$FF,$FA,$E8,  6, $C,$F7,  0,$60,$FF,$FB,$EC,$FF,$F8,  2,$AE,$E8, $E, $C,$E8,  3,  6,  6,  3,  3,  6,  3,  3,  6,$F8,  2,$9E; 2880
		dc.b $F7,  0,  4,$FF,$F9,$F5,  9,$EC,  1,$E9, $B,$AE,  6,$AE,$B5,$B5,$B3,$B3,$B5,$B5,$F7,  0,  2,$FF,$F3,$B3,$B3,$BA,$BA,$B6,$B6,$BA,$BA,$F7,  0,  2,$FF,$F4,$B0,$B0,$B6,$B6,$B3,$B3,$B6,$B6,$B5,$B5,$BC,$BC,$B9,$B9,$BC,$BC,$AE,$AE,$B5,$B5,$B1,$B1,$B5,$B5,$AE,  6; 2944
		dc.b $80,$1E,$E8,  2,$E9,$F5,$F5,  4,$C6,  3,  3,$EC,  2,$F5,  8,$E8,  8,  6,$E8,  3,$EC,$FE,$F7,  0,$1E,$FF,$EC,$80,$24,$F5,  4,  3,  3,$EC,  2,$F5,  8,$E8,  8,  6,$E8,  3,$EC,$FE,$F7,  0,$20,$FF,$ED,$80,$30,$E8,  1,$F5,  4,$EC,  3,$C6,  2,$80,$C6,$F7,  0,  8; 3008
		dc.b $FF,$F8,$80,  4,$C6,  2,$F7,  0,  8,$FF,$F8,$EC,$FF,$C6,  2,$80,$C6,$F7,  0,$18,$FF,$F8,$EC,$FE,$C6,  4,$80,$C6,$F7,  0,  8,$FF,$F8,$E8,  3, $C,$E8, $C, $C,$E8,  3, $C,$E8, $C, $C,$F7,  0, $D,$FF,$F0,$E8,  3,  6,$E8, $E,$12,$E8,  3, $C,$E8, $F, $C,$F2,$82; 3072
		dc.b   6,$82,$82,$82,$82, $C,  6, $C,  6, $C, $C, $C,$F8,  1,$20,$81,$18,$82, $C,$82,$81,$18,$82, $C,$82,$F8,  1,$13,$81, $C,$82,$82,$82,$82,$82,$82,$82,$81,$18,$82, $C,$81,$18, $C,$82,$18,$F7,  0,  7,$FF,$F3,$81,$18,$82, $C,$81,$18,$82, $C, $C, $C,$81,$18,$82; 3136
		dc.b  $C,$81,$18, $C,$82,$18,$F7,  0,  3,$FF,$F3,$81,$18,$82, $C,$81,$18,$82, $C,$82,$82,$EB,  2,$81,$12,$81,  6,$81, $C,$82,$F7,  0,  5,$FF,$F5,$81,$12,$81,  6,$81,  6,$82,$82,$82,$81, $C,$F7,  0,$18,$FF,$FA,$81, $C,$81,$81,$81,  6,$81,  2,$81,$82,$82, $C,$80; 3200
		dc.b $24,$81, $C,$81,$81,$81,$F7,  0,  7,$FF,$F7,$81, $C,$81,$82,  3,$82,$82,$82,$82,$82,$82,$82,$F8,  0,$A5,$88,  2,$81,  1,$89,  5,$82,  1,$88,  5,$89,  6,$F8,  0,$96,$89,  2,$82,  1,$88,  5,$82,  1,$89,  5,$82,  1,$88,  2,$82,  3,$82,  3,$82,$81,$81,$82,$82; 3264
		dc.b $81,$81,$81,$82,  9,$82,  6,  3,  3,$81,  9,  3,$82,  9,$81,  6,  6,  3,$82,  6,  3,  3,$82,  6,$82,$82,$82,$82,$82,$82,  4,  2,  4,$81,  2,$80,  4,$81,  8,$82,  6,$81,$81, $C,$82, $A,$81,  2,$F7,  0,  3,$FF,$EF,$EB,  1,$80,$18,$82,$14,$81,  4,$82, $C,$82; 3328
		dc.b $82, $C,  8,$81,  4,$81, $C,$82,$81,$82,$F7,  1,  3,$FF,$F7,$81, $C,$82,$81,  6,$80,  2,$82,$82,$82,  9,$82,  3,$F7,  0,  3,$FF,$E5,$81, $C,$82,$81,$82,$81,  6,$82,$12,$82, $C,$81,$F2,$81,$18,$82, $C,$81,$18,$81, $C,$82,$81,$F7,  0,  3,$FF,$F2,$E3,$81, $C; 3392
		dc.b $82,  9,$81,  6,  3,$81,  1,$88,  2,$89,  3,$82,  1,$88, $B,$81, $C,$82,  9,$81,  6,  3,$81,  1,$88,  2,$89,  3,$82,  1,$88, $B,$81, $C,$82,  9,$81,  6,  3,$81,  1,$88,  2,$89,  3,$82,  1,$88, $B,$81, $C,$82,  9,$81,  6,$82,  1,$E3,$F8,  0, $F,$C3,$BF,$C1; 3456
		dc.b $C3,$BF,$F8,  0,  7,$C8,$C6,$C8,$C9,$CB,$E3,$C8, $C,$C4,$C8,$CB,$C9,$C8,$C6,$C8,$C6,$C3,$C6,$C9,$C8,$C6,$C4,$C6,$C4,$C1,$C4,$C8,$C6,$C4,$C3,$C4,$C3,$C4,$C6,$E3,$80, $C,$D0,$D4,$D7,$DB, $C,$80,  6,$DB, $C,$DC,  6,$DB, $C,$D9,$60,$80, $C,$D0,$D4,$D7,$DB, $C; 3520
		dc.b $80,  6,$DB, $C,$DC,  6,$DB, $C,$DD,$5D,$80,  3,$DE,$12,$80,  6,$DE,$12,$80,  6,$80,  6,$DD,$12,$DE,  6,$80,$12,$E3,$E8, $E, $C,$E8,  3,  6,  6,  6,  6,  6,  6,$E3,$D4,  9,$80,  3,$D4,  6,$D2,$F7,  0,  3,$FF,$F5,$D4,$D2,$CD,$C9,$D0, $C,$D2,  6,$E7,$CE,$4D; 3584
		dc.b $80,  1,$D2,$24,$D4, $C,$D1,$24,$D4,  9,$80,  3,$D4,$12,$D2,$1E,$E3,$80,$30,$80,$80,$DA,  3,$D7,$D2,$CE,$D7,$D2,$CE,$CB,$D2,$CE,$CB,$C6,$CE,$CB,$C6,$C2,$33,$80,$5E,$E3,$CD,$2A,$CD,  3,$CE,$D0,  9,$D2,$D3,  6,$D2, $C,$D0,$CE,$1E,$CE,  6,$CD,$CE,$1E,$CB, $C; 3648
		dc.b $CD,$CE,$2A,$CB,  3,$CD,$CE,  9,$D0,$D1,  6,$D0, $C,$CE,$E3,$F8,  0,$47,$CB,  6,$80,  3,$CB,$80,  6,$CA,$18,$80,  6,$CE,  6,$80,  3,$CD,  6,$80,  3,$CB,$80,$F7,  0,  2,$FF,$F2,$CE,  6,$80,  3,$CD,  6,$80,  3,$CB,$18,$80,  6,$E9,$FE,$F8,  0,$1C,$E9,  3,$F8; 3712
		dc.b   0,$17,$E9,$FF,$80,  6,$E8,  8,$D0,  9,  9,  9,  9,$E8,  5,  3,  3,$E8,  0,$80, $C,$CE,$24,$E3,$CD,  6,$80,  3,$CD,$80,  6,$CD,$18,$80,  6,$E3,$D0,  6,$80,  3,$D0,$80,  6,$D0,$18,$80,  6,$CE,  6,$80,  3,$CE,$80,  6,$CD,$18,$80,  6,$D2,  6,$80,  3,$D0,  6; 3776
		dc.b $80,  3,$CE,$80,$D2,  6,$80,  3,$D0,  6,$80,  3,$CE,$80,$D2,  6,$80,  3,$D0,  6,$80,  3,$CE,$18,$80,  6,$CE,  6,$80,  3,$CE,$80,  6,$CE,$18,$80,  6,$D1,  6,$80,  3,$D1,$80,  6,$D1,$18,$80,  6,$80,  6,$E8,  8,$D4,  9,  9,  9,  9,$E8,  5,  3,  3,$E8,  0,$80; 3840
		dc.b  $C,$D2,$24,$E3,$F8,  0,$11,$D0,$12,$D2,  6,$D0,$12,$CD, $C,$F8,  0,  6,$D0,$30,$80,  6,$E3,$D0,$1E,$CD,  6,$C9,$D5,$D3, $C,$D5,  6,$D3, $C,$D0,  6,$D3,$D2,$24,$CD,  6,$CE,$E3,$80,  3,$CD,$C9,  6,  6,$C4,$C9,  9,$CD,  9,$80,  6,$80,  3,$CE,$CA,  6,  6,$C7; 3904
		dc.b $CA,  9,$CE,  9,$80,  6,$80,  3,$CD,$C9,  6,  6,$C6,$C9,  9,$CD, $F,$CB, $C,$E3,$20,$36,$35,$30,$31,$DF,$DF,$9F,$9F,  7,  6,  9,  6,  7,  6,  6,  8,$20,$10,$10,$F8,$19,$37,$13,$80,$2C,$72,$78,$34,$34,$1F,$12,$1F,$12,  0, $A,  0, $A,  0,  0,  0,  0, $F,$1F; 3968
		dc.b  $F,$1F,$16,$80,$17,$80,$2C,$74,$74,$34,$34,$1F,$12,$1F,$1F,  0,  0,  0,  0,  0,  1,  0,  1, $F,$3F, $F,$3F,$16,$80,$17,$80,  4,$72,$42,$32,$32,$12,$12,$12,$12,  0,  8,  0,  8,  0,  8,  0,  8, $F,$1F, $F,$1F,$23,$80,$23,$80,$2C,$74,$74,$34,$34,$1F,$12,$1F; 4032
		dc.b $1F,  0,  7,  0,  7,  0,  7,  0,  7,  0,$38,  0,$38,$16,$80,$17,$80,$31,$34,$35,$30,$31,$DF,$DF,$9F,$9F, $C,  7, $C,  9,  7,  7,  7,  8,$2F,$1F,$1F,$2F,$17,$32,$14,$80,$18,$37,$30,$30,$31,$9E,$DC,$1C,$9C, $D,  6,  4,  1,  8, $A,  3,  5,$BF,$BF,$3F,$2F,$2C; 4096
		dc.b $22,$14,$80,$3C,$31,$52,$50,$30,$52,$53,$52,$53,  8,  0,  8,  0,  4,  0,  4,  0,$1F, $F,$1F, $F,$1A,$80,$16,$80,$22, $A,$13,  5,$11,  3,$12,$12,$11,  0,$13,$13,  0,  3,  2,  2,  1,$1F,$1F, $F, $F,$1E,$18,$26,$81,$3A,$61,$3C,$14,$31,$9C,$DB,$9C,$DA,  4,  9; 4160
		dc.b   4,  3,  3,  1,  3,  0,$1F, $F, $F,$AF,$21,$47,$31,$80,$3A,  1,  7,  1,  1,$8E,$8E,$8D,$53, $E, $E, $E,  3,  0,  0,  0,  0,$1F,$FF,$1F, $F,$18,$28,$27,$80,$34,$33,$41,$7E,$74,$5B,$9F,$5F,$1F,  4,  7,  7,  8,  0,  0,  0,  0,$FF,$FF,$EF,$FF,$23,$90,$29,$97; 4224
		dc.b   4,$72,$42,$32,$32,$1F,$1F,$1F,$1F,  0,  0,  0,  0,  0,  0,  0,  0,  0,  7,  0,  7,$23,$80,$23,$80,$3C,$38,$74,$76,$33,$10,$10,$10,$10,  2,  7,  4,  7,  3,  9,  3,  9,$2F,$2F,$2F,$2F,$1E,$80,$1E,$80,$F4,  6,  4, $F, $E,$1F,$1F,$1F,$1F,  0,  0, $B, $B,  0; 4288
		dc.b   0,  5,  8, $F, $F,$FF,$FF,$15,$85,  2,$8A,$29,$36,$74,$71,$31,  4,  4,  5,$1D,$12, $E,$1F,$1F,  4,  6,  3,  1,$5F,$6F, $F, $F,$27,$27,$2E,$80,  8, $A,$70,$30,  0,$1F,$1F,$5F,$5F,$12, $E, $A, $A,  0,  4,  4,  3,$2F,$2F,$2F,$2F,$24,$2D,$13,$80,$3D,  1,  1; 4352
		dc.b   1,  1,$8E,$52,$14,$4C,  8,  8, $E,  3,  0,  0,  0,  0,$1F,$1F,$1F,$1F,$1B,$80,$80,$9B,$3D,  1,  2,  0,  1,$1F, $E, $E, $E,  7,$1F,$1F,$1F,  0,  0,  0,  0,$1F, $F, $F, $F,$17,$8D,$8C,$8C,$3C,$31,$52,$50,$30,$52,$53,$52,$53,  8,  0,  8,  0,  4,  0,  4,  0; 4416
		dc.b $10,  7,$10,  7,$1A,$80,$16,$80,$18,$37,$30,$30,$31,$9E,$DC,$1C,$9C, $D,  6,  4,  1,  8, $A,  3,  5,$BF,$BF,$3F,$2F,$32,$22,$14,$80,$3A,  1,  1,  1,  2,$8D,  7,  7,$52,  9,  0,  0,  3,  1,  2,  2,  0,$5F, $F, $F,$2F,$18,$22,$18,$80,$2C,$74,$74,$34,$34,$1F; 4480
		dc.b $1F,$1F,$1F,  0,  0,  0,  0,  0,  1,  0,  1, $F,$3F, $F,$3F,$16,$80,$17,$80,  4,$37,$72,$77,$49,$1F,$1F,$1F,$1F,  7, $A,  7, $D,  0,  0,  0,  0,$10,  7,$10,  7,$23,$80,$23,$80,$3D,  1,  2,  2,  2,$14, $E,$8C, $E,  8,  5,  2,  5,  0,  0,  0,  0,$1F,$1F,$1F; 4544
		dc.b $1F,$1A,$80,$80,$80,$20,$36,$35,$30,$31,$DF,$DF,$9F,$9F,  7,  6,  9,  6,  7,  6,  6,  8,$2F,$1F,$1F,$FF,$19,$37,$13,$80,$3A,$51,  8,$51,  2,$1E,$1E,$1E,$10,$1F,$1F,$1F, $F,  0,  0,  0,  2, $F, $F, $F,$1F,$18,$24,$22,$81,$3A,$32,$56,$32,$42,$8D,$4F,$15,$52; 4608
		dc.b   6,  8,  7,  4,  2,  0,  0,  0,$1F,$1F,$2F,$2F,$19,$20,$2A,$80,$3A,  1,  7,  1,  1,$8E,$8E,$8D,$53, $E, $E, $E,  3,  0,  0,  0,  0,$1F,$FF,$1F, $F,$18,$28,$27,$80,  8, $A,$70,$30,  0,$1F,$1F,$5F,$5F,$12, $E, $A, $A,  0,  4,  4,  3,$2F,$2F,$2F,$2F,$24,$2D; 4672
		dc.b $13,$80,$3A,  1,  7,  1,  1,$8E,$8E,$8D,$53, $E, $E, $E,  3,  0,  0,  0,  7,$1F,$FF,$1F, $F,$18,$28,$27,$80,$36, $F,  1,  1,  1,$1F,$1F,$1F,$1F,$12,$11, $E,  0,  0, $A,  7,  9,$FF, $F,$1F, $F,$18,$80,$80,$80,$3A,  3,$19,  1,$53,$1F,$DF,$1F,$9F, $C,  2, $C; 4736
		dc.b   5,  4,  4,  4,  7,$1F,$FF, $F,$2F,$1D,$36,$1B,$80,  0; 4800
Music92:	dc.b   0,$C6,  6,  0,  1,  2,  0,$A6,  0,  0,  0,$1E, $C,  8,  0,$40,$E8, $E,  0,$4F,$F4,$40,  0,$6C,  6,$11,  0,$89, $C,$19,$EF,  0,$E2,  1,$E8,  5,$F8,  0,$8D,$EA,  3,$F8,  0,$88,$EA,  4,$F8,  0,$83,$EA,  6,$F8,  0,$7E,$EA, $A,$F8,  0,$79,$BD,  6,$E2,  1,$F2; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b $EF,  1,$E6,$FF,$F8,  0,$76,$F7,  0, $A,$FF,$F7,$BD,  6,$F2,$EF,  2,$E6,$FE,$E7,$C9,  2,$E7,$CA,$E7,$C9,$E7,$CA,$E7,$C9,$E7,$CA,$E7,$C9,$E7,$CA,$F7,  0,$1E,$FF,$E9,$C9,  6,$F2,$EF,  3,$E8,  5,$80,  3,$E0,$40,$B1,  6,$BD,$E0,$C0,$B1,$BD,$E0,$80,$B2,$BE,$E0; 64
		dc.b $C0,$B2,$BE,$F7,  0, $A,$FF,$EB,$F2,$EF,  0,$E8,  5,$80,  4,$E0,$80,$B1,  6,$BD,$E0,$80,$B1,$BD,$E0,$40,$B2,$BE,$E0,$40,$B2,$BE,$F7,  0, $A,$FF,$EB,$F2,$82, $C,$82,$82,$82,$F7,  0, $A,$FF,$F7,$82,  6,$F2,$B1,  6,$BD,$B1,$BD,$B2,$BE,$B2,$BE,$B1,  6,$BD,$B1; 128
		dc.b $BD,$B2,$BE,$B2,$BE,$E3,$3C,$31,$52,$50,$30,$52,$53,$52,$53,  8,  0,  8,  0,  4,  0,  4,  0,$1F, $F,$1F, $F,$1A,$80,$16,$80,$18,$37,$30,$30,$31,$9E,$DC,$1C,$9C, $D,  6,  4,  1,  8, $A,  3,  5,$BF,$BF,$3F,$2F,$2C,$22,$14,$80,$2C,$52,$58,$34,$34,$1F,$12,$1F; 192
		dc.b $12,  0, $A,  0, $A,  0,  0,  0,  0, $F,$1F, $F,$1F,$15,$82,$14,$82,  7,$34,$31,$54,$51,$14,$14,$14,$14,  0,  0,  0,  0,  0,  0,  0,  0, $F, $F, $F, $F,$91,$91,$91,$91; 256
Music93:	dc.b   0,$9C,  7,  3,  1,  6,  0,$99,  0,  0,  0,$36,$F4,  8,  0,$42,$F4,  8,  0,$34,$F4,  7,  0,$4E,$F4,$16,  0,$5C,$F4,$16,  0,$6A,$F4,$16,  0,$87,$F4,  2,  0,  4,  0,$78,$F4,  2,  0,  5,  0,$99,$F4,  0,  0,  4,$E1,  2,$EF,  0,$C1,  6,$C4,$C9,$CD, $C,$C9,$D0; 0
					; DATA XREF: ROM:MusicIndexo
		dc.b $2A,$F2,$EF,  0,$BD,  6,$C1,$C4,$C9, $C,$C6,$CB,$2A,$F2,$EF,  1,$C1, $C,$C1,  6,$C4,  6,$80,$C4,$80,$C9,$2A,$F2,$EF,  1,$C9, $C,$C9,  6,$CD,  6,$80,$CD,$80,$D0,$2A,$F2,$EF,  1,$C4, $C,$C4,  6,$C9,  6,$80,$C9,$80,$CD,$2A,$F2,$80,$2D,$C4,  6,$C2,$C1,$BF,$EC; 64
		dc.b   3,$F7,  0,  4,$FF,$F5,$F2,$E2,  1,$80,  2,$80,$2D,$C4,  6,$C2,$C1,$BF,$EC,  3,$F7,  0,  4,$FF,$F5,$E2,  1,$F2,  4,$35,$72,$54,$46,$1F,$1F,$1F,$1F,  7, $A,  7, $D,  0, $B,  0, $B,$1F, $F,$1F, $F,$23,$14,$1D,$80,$3C,$31,$52,$50,$30,$52,$53,$52,$53,  8,  0; 128
		dc.b   8,  0,  4,  0,  4,  0,$10,  7,$10,  7,$1A,$80,$16,$80; 192
; ---------------------------------------------------------------------------
; Sound	effect pointers
; ---------------------------------------------------------------------------
SoundIndex:	dc.l SoundA0, SoundA1, SoundA2,	SoundA3, SoundA4, SoundA5
					; DATA XREF: ROM:Go_SoundIndexo
		dc.l SoundA6, SoundA7, SoundA8,	SoundA9, SoundAA, SoundAB
		dc.l SoundAC, SoundAD, SoundAE,	SoundAF, SoundB0, SoundB1
		dc.l SoundB2, SoundB3, SoundB4,	SoundB5, SoundB6, SoundB7
		dc.l SoundB8, SoundB9, SoundBA,	SoundBB, SoundBC, SoundBD
		dc.l SoundBE, SoundBF, SoundC0,	SoundC1, SoundC2, SoundC3
		dc.l SoundC4, SoundC5, SoundC6,	SoundC7, SoundC8, SoundC9
		dc.l SoundCA, SoundCB, SoundCC,	SoundCD, SoundCE, SoundCF
SoundD0Index:	dc.l SoundD0		; DATA XREF: ROM:Go_SoundD0o
SoundA0:	dc.b   0,$16,  1,  1,$80,$80,  0, $A,$F4,  0,$F5,  0,$9E,  5,$F0,  2,  1,$F8,$65,$A3,$15,$F2; 0
					; DATA XREF: ROM:SoundIndexo
SoundA1:	dc.b   0,$11,  1,  1,$80,  5,  0, $A,  0,  1,$EF,  0,$BD,  6,$BA,$16,$F2,$3C,  5,  1, $A,  1,$56,$5C,$5C,$5C, $E,$11,$11,$11,  9, $A,  6, $A,$4F,$3F,$3F,$3F,$17,$80,$20,$80; 0
					; DATA XREF: ROM:SoundIndexo
SoundA2:	dc.b   0,$1F,  1,  1,$80,$C0,  0, $A,  0,  0,$F0,  1,  1,$F0,  8,$F3,$E7,$C0,  4,$CA,  4,$C0,  1,$EC,  1,$F7,  0,  6,$FF,$F8,$F2,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundA3:	dc.b   0,$19,  1,  1,$80,  5,  0, $A,$F4,  0,$EF,  0,$B0,  7,$E7,$AD,  1,$E6,  1,$F7,  0,$2F,$FF,$F9,$F2,$30,$30,$30,$30,$30,$9E,$D8,$DC,$DC, $E, $A,  4,  5,  8,  8,  8,  8,$BF,$BF,$BF,$BF,$14,$3C,$14,$80; 0
					; DATA XREF: ROM:SoundIndexo
SoundA4:	dc.b   0,$35,  1,  2,$80,$A0,  0,$10,$F4,  0,$80,$C0,  0,$22,$F4,  0,$F5,  0,$AF,  1,$80,$AF,$80,  3,$AF,  1,$80,  1,$F7,  0, $B,$FF,$F8,$F2,$F5,  0,$80,  1,$AD,$80,$AD,$80,  3,$AD,  1,$80,  1,$F7,  0, $B,$FF,$F8,$F2,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundA5:	dc.b   0,$13,  1,  1,$80,  5,  0, $A,  0,  0,$EF,  0,$80,  1,$8B, $A,$80,  2,$F2,$FA,$21,$30,$10,$32,$2F,$1F,$2F,$2F,  5,  8,  9,  2,  6, $F,  6,  2,$1F,$2F,$4F,$2F, $F,$1A, $E,$80; 0
					; DATA XREF: ROM:SoundIndexo
SoundA6:	dc.b   0,$16,  1,  1,$80,  5,  0, $A,$F2,  0,$EF,  0,$F0,  1,  1,$10,$FF,$CF,  5,$D7,$25,$F2,$3B,$3C,$39,$30,$31,$DF,$1F,$1F,$DF,  4,  5,  4,  1,  4,  4,  4,  2,$FF, $F,$1F,$AF,$29,$20, $F,$80,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundA7:	dc.b   0,$16,  1,  1,$80,  4,  0, $A,  0,  6,$EF,  0,$8F,  7,$80,  2,$8F,  6,$80,$10,$ED,$F2,$FA,$21,$30,$10,$32,$1F,$1F,$1F,$1F,  5,$18,  9,  2,  6, $F,  6,  2,$1F,$2F,$4F,$2F, $F, $E, $E,$80,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundA8:	dc.b   0,$1A,  1,  1,$80,  5,  0, $A,$F2,  4,$EF,  0,$A6,  2,$E7,$A4,  1,$E7,$E9,  2,$F7,  0,$26,$FF,$F5,$F2,$3B,$3C,$39,$30,$31,$DF,$1F,$1F,$DF,  4,  5,  4,  1,  4,  4,  4,  2,$FF, $F,$1F,$AF,$29,$20, $F,$80,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundA9:	dc.b   0,$12,  1,  1,$80,$A0,  0, $A,  0,  0,$F0,  1,  1,$E6,$35,$8E,  6,$F2; 0
					; DATA XREF: ROM:SoundIndexo
SoundAA:	dc.b   0,$28,  1,  2,$80,$C0,  0,$10,  0,  0,$80,  5,  0,$23,  0,  3,$F5,  0,$F3,$E7,$C2,  5,$C6,  5,$E7,  7,$EC,  1,$E7,$F7,  0, $F,$FF,$F8,$F2,$EF,  0,$A6,$14,$F2,  0,  0,  3,  2,  0,$D9,$DF,$1F,$1F,$12,$11,$14, $F, $A,  0, $A, $D,$FF,$FF,$FF,$FF,$22,  7,$27; 0
					; DATA XREF: ROM:SoundIndexo
		dc.b $80,  0		; 64
SoundAB:	dc.b   0,$1F,  1,  1,$80,$C0,  0, $A,  0,  0,$F5,  0,$F3,$E7,$C6,  3,$80,  3,$C6,  1,$E7,  1,$EC,  1,$E7,$F7,  0,$15,$FF,$F8,$F2,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundAC:	dc.b   0,$1B,  1,  1,$80,  5,  0, $A,  0,  0,$EF,  0,$F0,  1,  1, $C,  1,$81, $A,$E6,$10,$F7,  0,  4,$FF,$F8,$F2,$F9,$21,$30,$10,$32,$1F,$1F,$1F,$1F,  5,$18,  9,  2, $B,$1F,$10,  5,$1F,$2F,$4F,$2F, $E,  7,  4,$80; 0
					; DATA XREF: ROM:SoundIndexo
SoundAD:	dc.b   0,$1D,  1,  1,$80,  5,  0, $A, $E,  0,$EF,  0,$F0,  1,  1,$21,$6E,$A6,  7,$80,  6,$F0,  1,  1,$44,$1E,$AD,  8,$F2,$35,  5,  9,  8,  7,$1E, $D, $D, $E, $C,$15,  3,  6,$16, $E,  9,$10,$2F,$2F,$1F,$1F,$15,$12,$12,$80; 0
					; DATA XREF: ROM:SoundIndexo
SoundAE:	dc.b   0,$31,  1,  2,$80,  5,  0,$10,  0,  0,$80,$C0,  0,$1E,  0,  0,$EF,  0,$80,  1,$F0,  1,  1,$40,$48,$83,  6,$85,  2,$F2,$F5,  0,$80, $B,$F3,$E7,$C6,  1,$E7,  2,$EC,  1,$E7,$F7,  0,$10,$FF,$F8,$F2,$FA,  2,  3,  0,  5,$12,$11, $F,$13,  5,$18,  9,  2,  6, $F; 0
					; DATA XREF: ROM:SoundIndexo
		dc.b   6,  2,$1F,$2F,$4F,$2F,$2F,$1A, $E,$80; 64
SoundAF:	dc.b   0,$14,  1,  1,$80,  5,  0, $A, $C,  0,$EF,  0,$80,  1,$A3,  5,$E7,$A4,$26,$F2,$30,$30,$30,$30,$30,$9E,$A8,$AC,$DC, $E, $A,  4,  5,  8,  8,  8,  8,$BF,$BF,$BF,$BF,  4,$2C,$14,$80,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundB0:	dc.b   0,$18,  1,  1,$80,  5,  0, $A,$FB,  5,$EF,  0,$DF,$7F,$DF,  2,$E6,  1,$F7,  0,$1B,$FF,$F8,$F2,$83,$1F,$15,$1F,$1F,$1F,$1F,$1F,$1F,  0,  0,  0,  0,  2,  2,  2,  2,$2F,$2F,$FF,$3F, $B,$16,  1,$82,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundB1:	dc.b   0,$13,  1,  1,$80,  5,  0, $A,$FB,  2,$EF,  0,$B3,  5,$80,  1,$B3,  9,$F2,$83,$12,$10,$13,$1E,$1F,$1F,$1F,$1F,  0,  0,  0,  0,  2,  2,  2,  2,$2F,$2F,$FF,$3F,  5,$10,$34,$87; 0
					; DATA XREF: ROM:SoundIndexo
SoundB2:	dc.b   0,$36,  1,  2,$80,  4,  0,$22, $C,  4,$80,  5,  0,$10, $E,  2,$EF,  0,$F0,  1,  1,$83, $C,$8A,  5,  5,$E6,  3,$F7,  0, $A,$FF,$F7,$F2,$80,  6,$EF,  0,$F0,  1,  1,$6F, $E,$8D,  4,  5,$E6,  3,$F7,  0, $A,$FF,$F7,$F2,$35,$14,$1A,  4,  9, $E,$10,$11, $E, $C; 0
					; DATA XREF: ROM:SoundIndexo
		dc.b $15,  3,  6,$16, $E,  9,$10,$2F,$2F,$4F,$4F,$2F,$12,$12,$80,  0; 64
SoundB3:	dc.b   0,$31,  1,  2,$80,  5,  0,$10,  0,  0,$80,$C0,  0,$1E,  0,  0,$EF,  0,$80,  1,$F0,  1,  1,$40,$48,$83,  6,$85,  2,$F2,$F5,  0,$80, $B,$F3,$E7,$A7,$25,$E7,  2,$EC,  1,$E7,$F7,  0,$10,$FF,$F8,$F2,$FA,  2,  3,  0,  5,$12,$11, $F,$13,  5,$18,  9,  2,  6, $F; 0
					; DATA XREF: ROM:SoundIndexo
		dc.b   6,  2,$1F,$2F,$4F,$2F,$2F,$1A, $E,$80; 64
SoundB4:	dc.b   0,$29,  1,  3,$80,  5,  0,$16,  0,  0,$80,  4,  0,$1B,  0,  0,$80,  2,  0,$24,  0,  2,$EF,  0,$F6,  0,  7,$EF,  0,$E1,  7,$80,  1,$BA,$20,$F2,$EF,  1,$9A,  3,$F2,$3C,  5,  1, $A,  1,$56,$5C,$5C,$5C, $E,$11,$11,$11,  9, $A,  6, $A,$4F,$3F,$3F,$3F,$1F,$80; 0
					; DATA XREF: ROM:SoundIndexo
		dc.b $2B,$80,  5,  0,  0,  0,  0,$1F,$1F,$1F,$1F,$12, $C, $C, $C,$12,  8,  8,  8,$1F,$5F,$5F,$5F,  7,$80,$80,$80,  0; 64
SoundB5:	dc.b   0,$15,  1,  1,$80,  5,  0, $A,  0,  5,$EF,  0,$E0,$40,$C1,  5,$C4,  5,$C9,$1B,$F2,  4,$37,$72,$77,$49,$1F,$1F,$1F,$1F,  7, $A,  7, $D,  0, $B,  0, $B,$1F, $F,$1F, $F,$23,$80,$23,$80; 0
					; DATA XREF: ROM:SoundIndexo
SoundB6:	dc.b   0,$1D,  1,  1,$80,$C0,  0, $A,  0,  0,$F0,  1,  1,$F0,  8,$F3,$E7,$C1,  7,$D0,  1,$EC,  1,$F7,  0, $C,$FF,$F8,$F2,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundB7:	dc.b   0,$22,  1,  1,$80,  5,  0, $A,  0,  0,$EF,  0,$F0,  1,  1,$20,  8,$8B, $A,$F7,  0,  8,$FF,$FA,$8B,$10,$E6,  3,$F7,  0,  9,$FF,$F8,$F2,$FA,$21,$30,$10,$32,$1F,$1F,$1F,$1F,  5,$18,  9,  2,  6, $F,  6,  2,$1F,$2F,$4F,$2F, $F,$1A, $E,$80,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundB8:	dc.b   0,$1D,  1,  1,$80,$C0,  0, $A,  0,  0,$F0,  1,  1,$F0,  8,$F3,$E7,$B4,  8,$B0,  2,$EC,  1,$F7,  0,  3,$FF,$F8,$F2,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundB9:	dc.b   0,$4A,  1,  4,$80,  2,  0,$1C,$10,  0,$80,  4,  0,$27,  0,  0,$80,  5,  0,$23,$10,  0,$80,$C0,  0,$38,  0,  0,$E0,$40,$80,  2,$F6,  0,  5,$E0,$80,$80,  1,$EF,  0,$F0,  3,  1,$20,  4,$81,$18,$E6, $A,$F7,  0,  6,$FF,$F8,$F2,$F0,  1,  1, $F,  5,$F3,$E7,$B0; 0
					; DATA XREF: ROM:SoundIndexo
		dc.b $18,$E7,$EC,  3,$F7,  0,  5,$FF,$F7,$F2,$F9,$21,$30,$10,$32,$1F,$1F,$1F,$1F,  5,$18,  9,  2, $B,$1F,$10,  5,$1F,$2F,$4F,$2F, $E,  7,  4,$80,  0; 64
SoundBA:	dc.b   0, $F,  1,  1,$80,  5,  0, $A,  0,  7,$EF,  0,$AE,  8,$F2,$1C,$2E,  2, $F,  2,$1F,$1F,$1F,$1F,$18, $F,$14, $E,  0,  0,  0,  0,$FF,$FF,$FF,$FF,$20,$80,$1B,$80; 0
					; DATA XREF: ROM:SoundIndexo
SoundBB:	dc.b   0,$12,  1,  1,$80,  5,  0, $A,$F4,  0,$EF,  0,$9B,  4,$80,$A0,  6,$F2,$3C,  0,  0,  0,  0,$1F,$1F,$1F,$1F,  0,$16, $F, $F,  0,  0,  0,  0, $F,$AF,$FF,$FF,  0,$80, $A,$80,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundBC:	dc.b   0,$28,  1,  2,$80,  5,  0,$10,$90,  0,$80,$C0,  0,$1A,  0,  0,$EF,  0,$F0,  1,  1,$C5,$1A,$CD,  7,$F2,$F5,  7,$80,  7,$F0,  1,  2,  5,$FF,$F3,$E7,$BB,$4F,$F2,$FD,  9,  3,  0,  0,$1F,$1F,$1F,$1F,$10, $C, $C, $C, $B,$1F,$10,  5,$1F,$2F,$4F,$2F,  9,$84,$92; 0
					; DATA XREF: ROM:SoundIndexo
		dc.b $8E,  0		; 64
SoundBD:	dc.b   0,$21,  1,  2,$80,  5,  0,$10,$10, $A,$80,  4,  0,$1A,  0,  0,$EF,  0,$F0,  1,  1,$60,  1,$A7,  8,$F2,$80,  8,$EF,  1,$84,$22,$F2,$FA,$21,$3A,$19,$30,$1F,$1F,$1F,$1F,  5,$18,  9,  2, $B,$1F,$10,  5,$1F,$2F,$4F,$2F, $E,  7,  4,$80,$FA,$31,$30,$10,$32,$1F; 0
					; DATA XREF: ROM:SoundIndexo
		dc.b $1F,$1F,$1F,  5,$18,  5,$10, $B,$1F,$10,$10,$1F,$2F,$1F,$2F, $D,  0,  1,$80,  0; 64
SoundBE:	dc.b   0,$21,  1,  1,$80,  4,  0, $A, $C,  5,$EF,  0,$80,  1,$F0,  3,  1,  9,$FF,$CA,$25,$F4,$E7,$E6,  1,$D0,  2,$F7,  0,$2A,$FF,$F7,$F2,$3C,  0,$44,  2,  2,$1F,$1F,$1F,$15,  0,$1F,  0,  0,  0,  0,  0,  0, $F, $F, $F, $F, $D,  0,$28,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundBF:	dc.b   0,$59,  1,  3,$80,  2,  0,$16,$F4,  6,$80,  4,  0,$31,$F4,  6,$80,  5,  0,$46,$F4,  6,$EF,  0,$C9,  7,$CD,$D0,$CB,$CE,$D2,$CD,$D0,$D4,$CE,$D2,$D5,$D0,  7,$D4,$D7,$E6,  5,$F7,  0,  8,$FF,$F6,$F2,$EF,  0,$E1,  1,$80,  7,$CD,$15,$CE,$D0,$D2,$D4,$15,$E6,  5; 0
					; DATA XREF: ROM:SoundIndexo
		dc.b $F7,  0,  8,$FF,$F8,$F2,$EF,  0,$E1,  1,$C9,$15,$CB,$CD,$CE,$D0,$15,$E6,  5,$F7,  0,  8,$FF,$F8,$F2,$14,$25,$33,$36,$11,$1F,$1F,$1F,$1F,$15,$18,$1C,$13, $B,  8, $D,  9, $F,$9F,$8F, $F,$24,  5, $A,$80; 64
SoundC0:	dc.b   0,$15,  1,  1,$80,  5,  0, $A,  0,  3,$EF,  0,$94,  5,$80,  5,$94,  4,$80,  4,$F2,$38,  8,  8,  8,  8,$1F,$1F,$1F, $E,  0,  0,  0,  0,  0,  0,  0,  0, $F, $F, $F,$1F,  0,  0,  0,$80; 0
					; DATA XREF: ROM:SoundIndexo
SoundC1:	dc.b   0,$21,  1,  2,$80,  5,  0,$10,  0,  0,$80,$C0,  0,$1A,  0,  2,$F0,  3,  1,$72, $B,$EF,  0,$BA,$16,$F2,$F5,  1,$F3,$E7,$B0,$1B,$F2,$3C, $F,  1,  3,  1,$1F,$1F,$1F,$1F,$19,$12,$19, $E,  5,$12,  0, $F, $F,$7F,$FF,$FF,  0,$80,  0,$80; 0
					; DATA XREF: ROM:SoundIndexo
SoundC2:	dc.b   0,$11,  1,  1,$80,  5,  0, $A, $C,  8,$EF,  0,$BA,  8,$BA,$25,$F2,$14,$25,$33,$36,$11,$1F,$1F,$1F,$1F,$15,$18,$1C,$13, $B,  8, $D,  9, $F,$9F,$8F, $F,$24,  5, $A,$80; 0
					; DATA XREF: ROM:SoundIndexo
SoundC3:	dc.b   0,$2F,  1,  2,$80,  4,  0,$10, $C,  0,$80,  5,  0,$1C,  0,$13,$EF,  1,$80,  1,$A2,  8,$EF,  0,$E7,$AD,$26,$F2,$EF,  2,$F0,  6,  1,  3,$FF,$80, $A,$C3,  6,$F7,  0,  5,$FF,$FA,$C3,$17,$F2,$30,$30,$5C,$34,$30,$9E,$A8,$AC,$DC, $E, $A,  4,  5,  8,  8,  8,  8; 0
					; DATA XREF: ROM:SoundIndexo
		dc.b $BF,$BF,$BF,$BF,$24,$1C,  4,$80,$30,$30,$5C,$34,$30,$9E,$A8,$AC,$DC, $E, $A,  4,  5,  8,  8,  8,  8,$BF,$BF,$BF,$BF,$24,$2C,  4,$80,  4,$37,$72,$77,$49,$1F,$1F,$1F,$1F,  7, $A,  7, $D,  0, $B,  0, $B,$1F, $F,$1F, $F,$13,$81,$13,$88; 64
SoundC4:	dc.b   0, $F,  1,  1,$80,  5,  0, $A,  0,  0,$EF,  0,$8A,$22,$F2,$FA,$21,$30,$10,$32,$1F,$1F,$1F,$1F,  5,$18,  5,$10, $B,$1F,$10,$10,$1F,$2F,$4F,$2F, $D,  7,  4,$80; 0
					; DATA XREF: ROM:SoundIndexo
SoundC5:	dc.b   0,$35,  1,  3,$80,  5,  0,$16,  0,  0,$80,  4,  0,$1F,  0,  0,$80,$C0,  0,$26,  0,  0,$EF,  0,$8A,  8,$80,  2,$8A,  8,$F2,$EF,  1,$80,$12,$C6,$55,$F2,$F5,  2,$F3,$E7,$80,  2,$C2,  5,$C4,  4,$C2,  5,$C4,  4,$F2,$3B,  3,  2,  2,  6,$18,$1A,$1A,$96,$17, $E; 0
					; DATA XREF: ROM:SoundIndexo
		dc.b  $A,$10,  0,  0,  0,  0,$FF,$FF,$FF,$FF,  0,$28,$39,$80,  4,$37,$72,$77,$49,$1F,$1F,$1F,$1F,  7, $A,  7, $D,  0, $B,  0, $B,$1F, $F,$1F, $F,$23,$80,$23,$80,  0; 64
SoundC6:	dc.b   0,$28,  1,  2,$80,  4,  0,$10,  0,  5,$80,  5,  0,$1C,  0,  8,$EF,  0,$C6,  2,  5,  5,  5,  5,  5,  5,$3A,$F2,$EF,  0,$80,  2,$C4,  2,  5,$15,  2,  5,$32,$F2,  4,$37,$72,$77,$49,$1F,$1F,$1F,$1F,  7, $A,  7, $D,  0, $B,  0, $B,$1F, $F,$1F, $F,$23,$80,$23; 0
					; DATA XREF: ROM:SoundIndexo
		dc.b $80,  0		; 64
SoundC7:	dc.b   0,$15,  1,  1,$80,  5,  0, $A,  0,  0,$EF,  0,$BE,  5,$80,  4,$BE,  4,$80,  4,$F2,$28,$2F,$5F,$37,$2B,$1F,$1F,$1F,$1F,$15,$15,$15,$13,$13, $C, $D,$10,$2F,$2F,$3F,$2F,  0,$10,$1F,$80; 0
					; DATA XREF: ROM:SoundIndexo
SoundC8:	dc.b   0,$11,  1,  1,$80,$C0,  0, $A,  0,  0,$F5,  0,$F3,$E7,$A7,$25,$F2,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundC9:	dc.b   0,$14,  1,  1,$80,  5,  0, $A, $E,  0,$EF,  0,$F0,  1,  1,$33,$18,$B9,$1A,$F2,$3B, $A,$31,  5,  2,$5F,$5F,$5F,$5F,  4,$14,$16, $C,  0,  4,  0,  0,$1F,$6F,$D8,$FF,  3,$25,  0,$80,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundCA:	dc.b   0,$14,  1,  1,$80,  5,  0, $A,  0,  2,$EF,  0,$F0,  1,  1,$5B,  2,$CC,$65,$F2,$20,$36,$35,$30,$31,$41,$49,$3B,$4B,  9,  6,  9,  8,  1,  3,  2,$A9, $F, $F, $F, $F,$29,$27,$23,$80,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundCB:	dc.b   0,$33,  1,  2,$80,  5,  0,$10,  0,  0,$80,$C0,  0,$21,  0,  0,$EF,  0,$F0,  3,  1,$20,  4,$81,$18,$E6, $A,$F7,  0,  6,$FF,$F8,$F2,$F0,  1,  1, $F,  5,$F3,$E7,$B0,$18,$E7,$EC,  3,$F7,  0,  5,$FF,$F7,$F2,$F9,$21,$30,$10,$32,$1F,$1F,$1F,$1F,  5,$18,  9,  2; 0
					; DATA XREF: ROM:SoundIndexo
		dc.b  $B,$1F,$10,  5,$1F,$2F,$4F,$2F, $E,  7,  4,$80; 64
SoundCC:	dc.b   0,$21,  1,  1,$80,  4,  0, $A,  0,  2,$EF,  0,$80,  1,$F0,  3,  1,$5D, $F,$B0, $C,$F4,$E7,$E6,  2,$BD,  2,$F7,  0,$19,$FF,$F7,$F2,$20,$36,$35,$30,$31,$DF,$DF,$9F,$9F,  7,  6,  9,  6,  7,  6,  6,  8,$2F,$1F,$1F,$FF,$16,$30,$13,$80; 0
					; DATA XREF: ROM:SoundIndexo
SoundCD:	dc.b   0, $D,  1,  1,$80,$C0,  0, $A,  0,  0,$BB,  2,$F2,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundCE:	dc.b   0,$15,  1,  1,$80,  4,  0, $A,  0,  5,$EF,  0,$E0,$80,$C1,  4,$C4,  5,$C9,$1B,$F2,  4,$37,$72,$77,$49,$1F,$1F,$1F,$1F,  7, $A,  7, $D,  0, $B,  0, $B,$1F, $F,$1F, $F,$23,$80,$23,$80; 0
					; DATA XREF: ROM:SoundIndexo
SoundCF:	dc.b   0,$1E,  1,  2,$80,  4,  0,$10,$27,  3,$80,  5,  0,$12,$27,  0,$80,  4,$EF,  0,$B4,  5,$E6,  2,$F7,  0,$15,$FF,$F8,$F2,$F4,  6,  4, $F, $E,$1F,$1F,$1F,$1F,  0,  0, $B, $B,  0,  0,  5,  8, $F, $F,$FF,$FF, $C,$8B,  3,$80,  0; 0
					; DATA XREF: ROM:SoundIndexo
SoundD0:	dc.b   0,$21,  1,  1,$80,  4,  0, $A,  0,$10,$EF,  0,$D0,  2,$E7,  1,$F7,  0,$40,$FF,$FA,$E7,  1,$E6,  1,$F7,  0,$22,$FF,$F8,$80,  1,$EE,$38, $F, $F, $F, $F,$1F,$1F,$1F, $E,  0,  0,  0,  0,  0,  0,  0,  0, $F, $F, $F,$1F,  0,  0,  0,$80; 0
					; DATA XREF: ROM:SoundD0Indexo
SegaPCM:	dc.b $94,$96,$93,$97,$A2,$9A,$9B,$A3,$9C,$9B,$9F,$96,$96,$95,$96,$94,$8F,$93,$8B,$95,$8F,$90,$91,$8F,$90,$8F,$97,$88,$89,$8E,$83,$81,$7E,$7F,$7B,$7C,$7F,$7B,$7C,$7D,$77,$7E,$7F,$7A,$7A,$86,$80,$7E,$87,$7F,$7F,$86,$81,$87,$88,$86,$8C,$89,$91,$93,$94,$9A,$99,$94; 0
		dc.b $97,$98,$91,$99,$99,$96,$9C,$9F,$9C,$97,$9E,$9A,$9A,$9B,$9A,$99,$95,$9C,$95,$94,$9C,$94,$95,$94,$98,$96,$98,$93,$95,$95,$98,$96,$96,$9C,$93,$98,$95,$96,$99,$94,$99,$95,$92,$9A,$93,$98,$9C,$92,$99,$90,$93,$93,$94,$93,$8C,$8E,$8C,$93,$8E,$94,$99,$94,$95,$96; 64
		dc.b $8E,$99,$90,$91,$92,$92,$8C,$8C,$8C,$87,$86,$87,$7C,$84,$82,$7C,$77,$7D,$82,$7C,$81,$7C,$7F,$7F,$81,$84,$78,$83,$81,$81,$87,$7D,$83,$8B,$83,$8B,$87,$8C,$90,$8B,$91,$8A,$8A,$8D,$89,$8C,$90,$90,$8A,$90,$91,$90,$8E,$90,$91,$92,$8E,$8D,$8C,$8F,$8C,$84,$84,$85; 128
		dc.b $84,$82,$86,$88,$86,$85,$84,$85,$87,$81,$86,$88,$85,$85,$84,$80,$7C,$81,$7D,$7D,$79,$79,$79,$74,$77,$70,$73,$73,$78,$6A,$6B,$6A,$67,$6A,$65,$67,$61,$62,$5D,$5D,$5B,$57,$59,$55,$51,$56,$54,$52,$51,$4E,$50,$51,$4C,$56,$55,$53,$52,$55,$59,$55,$59,$5F,$58,$58; 192
		dc.b $64,$5D,$63,$64,$60,$66,$63,$6A,$67,$68,$65,$64,$66,$60,$5E,$5B,$5E,$62,$60,$62,$5A,$60,$60,$5F,$64,$64,$69,$67,$69,$66,$65,$6A,$68,$65,$6B,$61,$62,$63,$60,$60,$63,$5D,$61,$5D,$67,$65,$69,$6C,$6B,$6D,$70,$73,$78,$73,$7B,$7D,$80,$82,$87,$87,$91,$8E,$8F,$94; 256
		dc.b $9A,$9F,$A5,$A0,$A0,$A4,$9F,$A3,$9D,$9F,$97,$94,$9A,$8C,$91,$93,$96,$96,$97,$95,$93,$9A,$92,$8F,$92,$8F,$8B,$89,$86,$7F,$85,$82,$7A,$81,$81,$7E,$7C,$7A,$80,$80,$7E,$7D,$7C,$85,$88,$85,$83,$88,$89,$87,$89,$89,$8B,$8F,$8A,$8A,$8C,$8F,$93,$92,$97,$95,$8F,$99; 320
		dc.b $9D,$9D,$99,$A1,$9D,$A4,$A6,$98,$A3,$9E,$9F,$9B,$99,$95,$97,$9A,$99,$8C,$9E,$96,$90,$9E,$95,$99,$93,$92,$98,$8F,$93,$93,$8E,$9B,$96,$93,$97,$94,$97,$9C,$97,$91,$9A,$95,$91,$93,$96,$97,$98,$90,$8F,$92,$96,$8B,$8A,$96,$8C,$89,$8E,$93,$93,$98,$98,$89,$99,$9F; 384
		dc.b $95,$92,$93,$92,$8B,$95,$87,$7E,$8F,$83,$75,$81,$7F,$78,$7C,$7F,$7F,$7D,$79,$7D,$83,$81,$78,$7A,$87,$72,$74,$80,$75,$7E,$7F,$7E,$87,$80,$85,$80,$86,$89,$84,$87,$7E,$88,$8C,$8A,$82,$8E,$92,$84,$91,$8B,$8B,$8C,$8C,$85,$8C,$8B,$7F,$84,$8B,$7E,$7A,$82,$86,$86; 448
		dc.b $81,$84,$8B,$84,$85,$88,$82,$85,$87,$84,$80,$7D,$84,$85,$7A,$85,$80,$78,$80,$7B,$78,$82,$6E,$6D,$7C,$76,$65,$6D,$6C,$6B,$6F,$69,$65,$67,$62,$64,$5A,$66,$63,$53,$5D,$5D,$57,$60,$5D,$50,$55,$59,$5B,$52,$54,$53,$5B,$52,$4F,$55,$57,$59,$59,$4E,$5A,$6B,$5E,$60; 512
		dc.b $69,$68,$73,$6D,$64,$6B,$6F,$61,$6A,$65,$5A,$5F,$65,$62,$5C,$61,$69,$61,$6B,$65,$65,$6A,$67,$66,$6A,$60,$6C,$6B,$6A,$68,$6A,$6A,$6C,$6B,$60,$65,$60,$66,$58,$61,$68,$62,$6B,$6A,$6D,$6E,$70,$76,$6F,$7A,$76,$79,$79,$7D,$80,$7B,$87,$89,$82,$8E,$94,$91,$9B,$9D; 576
		dc.b $9A,$A1,$A6,$A4,$99,$9E,$9E,$97,$9A,$94,$9B,$95,$9C,$99,$9B,$9E,$9F,$9B,$9B,$A3,$98,$94,$95,$8E,$85,$84,$82,$84,$8A,$7C,$7F,$81,$7F,$80,$7D,$86,$78,$86,$82,$85,$87,$84,$84,$8B,$90,$83,$8A,$8B,$89,$8E,$8A,$85,$88,$8C,$8C,$89,$8A,$90,$93,$95,$93,$96,$9C,$A2; 640
		dc.b $9E,$A3,$9B,$9F,$9D,$A8,$97,$98,$9C,$9C,$94,$94,$93,$97,$97,$97,$94,$97,$9D,$93,$96,$95,$8B,$8F,$92,$91,$8B,$93,$91,$8C,$98,$8F,$93,$91,$9A,$94,$8E,$97,$97,$9B,$90,$8D,$95,$96,$95,$91,$8D,$97,$94,$8A,$8F,$93,$8D,$89,$8E,$89,$8A,$8D,$95,$90,$95,$94,$8E,$90; 704
		dc.b $85,$8B,$82,$84,$7D,$76,$7C,$78,$77,$80,$75,$76,$7A,$7B,$7F,$77,$7C,$7B,$7A,$76,$74,$77,$71,$77,$78,$78,$75,$76,$7B,$7D,$79,$7E,$81,$84,$83,$83,$83,$8A,$88,$86,$8B,$8C,$8E,$89,$8C,$8F,$94,$8D,$8E,$8F,$8A,$8E,$87,$7E,$87,$74,$81,$7C,$82,$80,$81,$88,$82,$88; 768
		dc.b $85,$8D,$81,$7E,$81,$81,$7A,$7D,$81,$77,$7C,$7E,$7D,$79,$79,$7B,$79,$7B,$74,$77,$6E,$73,$70,$6E,$67,$72,$68,$73,$68,$6F,$6C,$6E,$6D,$6A,$6A,$70,$6E,$6F,$63,$6A,$69,$63,$5D,$5F,$5D,$62,$5B,$5B,$53,$55,$58,$51,$56,$55,$56,$54,$5F,$5B,$60,$65,$6A,$66,$61,$68; 832
		dc.b $66,$6B,$64,$61,$68,$61,$67,$68,$62,$67,$62,$62,$67,$64,$69,$70,$6B,$66,$6B,$66,$66,$6D,$65,$65,$6A,$6D,$67,$66,$66,$68,$67,$65,$69,$6C,$68,$6D,$6B,$6E,$6C,$74,$75,$77,$7A,$7A,$7D,$79,$7F,$7E,$79,$83,$7F,$85,$84,$81,$89,$88,$93,$97,$97,$9D,$96,$A4,$9A,$A0; 896
		dc.b $9B,$9A,$9C,$96,$9A,$97,$9B,$9E,$99,$9E,$A0,$9A,$A4,$9E,$A1,$9D,$9D,$94,$93,$9A,$83,$89,$85,$86,$7F,$7F,$7E,$7F,$86,$7F,$84,$81,$86,$8B,$7D,$86,$87,$85,$86,$88,$87,$8F,$8E,$8D,$91,$8D,$88,$92,$8B,$8B,$8B,$89,$89,$85,$8F,$8F,$92,$9B,$98,$9C,$97,$9A,$99,$A2; 960
		dc.b $93,$99,$9A,$9A,$9B,$94,$98,$91,$96,$97,$8C,$96,$90,$9B,$93,$97,$8E,$94,$92,$8E,$89,$8E,$88,$8A,$86,$84,$89,$8E,$8D,$8C,$95,$97,$8D,$95,$93,$8C,$95,$8C,$97,$87,$8E,$94,$8C,$91,$8E,$8F,$8C,$8E,$8E,$90,$8E,$8B,$8E,$8F,$95,$97,$91,$96,$92,$8C,$8A,$8D,$83,$80; 1024
		dc.b $7E,$7B,$7F,$7C,$79,$7A,$7C,$79,$78,$77,$77,$74,$77,$78,$73,$7D,$72,$74,$70,$70,$7A,$6D,$74,$71,$70,$7B,$74,$7E,$79,$7B,$83,$7B,$84,$84,$81,$89,$80,$89,$8B,$83,$82,$88,$90,$8B,$84,$89,$85,$85,$80,$87,$7A,$83,$85,$80,$8B,$87,$89,$87,$8A,$88,$8B,$84,$86,$7D; 1088
		dc.b $7C,$81,$7A,$7F,$78,$80,$81,$7B,$80,$7C,$7D,$80,$7A,$7E,$7C,$76,$75,$73,$71,$6C,$70,$66,$6F,$6C,$6E,$70,$73,$72,$6F,$6D,$6E,$73,$68,$6A,$6F,$5E,$67,$5F,$5F,$5F,$5D,$60,$60,$58,$5C,$5C,$5B,$5A,$5D,$65,$5A,$5F,$64,$5F,$6E,$59,$6F,$64,$68,$70,$65,$70,$65,$6C; 1152
		dc.b $5F,$6D,$66,$62,$6F,$5D,$6C,$60,$66,$69,$61,$70,$67,$6B,$6C,$62,$6A,$6D,$62,$69,$6D,$69,$6A,$6F,$6F,$74,$6C,$72,$74,$6F,$73,$6D,$74,$6D,$74,$70,$6D,$75,$6D,$72,$7E,$72,$76,$76,$75,$76,$79,$84,$7B,$85,$8B,$90,$92,$9A,$8F,$9B,$9B,$9A,$AA,$96,$9D,$A2,$98,$97; 1216
		dc.b $A6,$9A,$9A,$9E,$A1,$95,$9F,$9F,$99,$9F,$9E,$98,$99,$96,$8F,$98,$87,$88,$88,$83,$88,$7E,$88,$85,$8C,$82,$88,$94,$7D,$8E,$8A,$7A,$91,$79,$8A,$7F,$81,$84,$86,$8A,$87,$83,$87,$88,$81,$83,$8C,$84,$84,$8D,$8C,$8F,$98,$8D,$99,$A2,$95,$A7,$95,$A0,$A4,$93,$9D,$9E; 1280
		dc.b $9C,$A0,$9C,$97,$A1,$92,$9D,$92,$9C,$9D,$94,$9A,$98,$93,$97,$89,$92,$84,$8E,$87,$8C,$87,$93,$86,$98,$8E,$91,$93,$93,$92,$90,$91,$93,$8A,$8E,$87,$8D,$81,$8C,$89,$83,$8A,$88,$87,$84,$8C,$88,$87,$88,$8B,$95,$91,$93,$8B,$8F,$8C,$88,$8C,$8A,$7C,$83,$7A,$7C,$7A; 1344
		dc.b $71,$7D,$76,$79,$74,$75,$6C,$7E,$70,$65,$78,$73,$78,$6F,$6F,$72,$72,$7A,$73,$7A,$7A,$78,$81,$79,$87,$83,$81,$86,$7D,$7F,$81,$7B,$80,$88,$80,$80,$82,$81,$8B,$88,$85,$83,$8A,$88,$8E,$84,$88,$8A,$85,$91,$8B,$8C,$89,$8C,$8B,$86,$8E,$86,$87,$7B,$7D,$7B,$7B,$72; 1408
		dc.b $79,$78,$75,$77,$73,$77,$7C,$6C,$81,$71,$78,$6F,$6B,$75,$6B,$67,$69,$67,$6E,$6A,$69,$64,$79,$6F,$6C,$6B,$70,$68,$6A,$65,$72,$66,$69,$5E,$67,$5B,$5E,$6A,$5B,$60,$67,$60,$62,$5B,$5F,$66,$63,$66,$64,$6A,$6F,$5E,$6B,$68,$6D,$69,$6B,$6D,$6A,$5F,$6A,$6A,$60,$6E; 1472
		dc.b $67,$66,$61,$6B,$60,$68,$60,$67,$6B,$67,$65,$66,$64,$69,$67,$6D,$6C,$71,$6B,$74,$70,$78,$7B,$7A,$74,$78,$7D,$72,$78,$71,$83,$6F,$72,$82,$6B,$7F,$74,$76,$79,$83,$7E,$86,$7E,$88,$8C,$82,$93,$8C,$9F,$98,$94,$A1,$99,$A3,$94,$9A,$A2,$98,$8D,$9D,$99,$91,$98,$97; 1536
		dc.b $98,$8F,$8C,$95,$97,$8A,$8D,$94,$8F,$84,$8A,$83,$8C,$85,$7A,$8A,$89,$79,$8B,$83,$88,$86,$88,$8A,$83,$80,$7C,$84,$87,$81,$7C,$7B,$7E,$84,$84,$7A,$87,$88,$8A,$8F,$84,$89,$99,$85,$9C,$91,$9A,$9E,$A0,$A0,$A6,$A3,$A0,$A6,$A9,$AC,$A4,$A4,$9D,$A0,$9F,$A3,$A2,$A1; 1600
		dc.b $A2,$A2,$9A,$A3,$9A,$9B,$97,$8E,$96,$95,$95,$93,$86,$8E,$88,$83,$8A,$91,$84,$92,$83,$95,$84,$8A,$83,$85,$8B,$85,$7E,$86,$7E,$7B,$81,$7F,$7C,$76,$80,$87,$84,$82,$83,$85,$7C,$88,$81,$8B,$87,$8E,$95,$84,$94,$82,$85,$8C,$84,$89,$87,$83,$81,$7B,$84,$7D,$7B,$77; 1664
		dc.b $88,$79,$7B,$7A,$7B,$79,$7A,$75,$78,$79,$7A,$75,$7E,$83,$7B,$83,$7F,$87,$87,$79,$8A,$84,$87,$85,$80,$82,$88,$85,$7D,$81,$72,$7E,$84,$7B,$7C,$80,$80,$87,$7D,$81,$80,$85,$80,$81,$8D,$81,$89,$8A,$89,$87,$8A,$88,$84,$7F,$78,$7C,$76,$74,$6F,$71,$71,$6E,$6C,$6C; 1728
		dc.b $6B,$68,$6B,$6D,$6A,$67,$66,$6E,$61,$68,$5B,$6C,$6F,$62,$71,$6C,$73,$6C,$6A,$72,$72,$75,$6D,$70,$70,$6B,$73,$60,$60,$6C,$58,$6A,$67,$69,$71,$61,$6E,$5F,$5D,$67,$6A,$6B,$6B,$6C,$6A,$67,$71,$63,$73,$6E,$6C,$67,$6A,$69,$67,$6B,$66,$67,$6B,$66,$5F,$68,$61,$67; 1792
		dc.b $6F,$62,$71,$64,$6D,$66,$6F,$70,$68,$6F,$76,$74,$72,$6E,$85,$78,$83,$82,$85,$8F,$84,$87,$7D,$8C,$7B,$86,$89,$7A,$81,$7C,$7E,$84,$81,$88,$7F,$87,$80,$86,$84,$83,$89,$94,$8A,$94,$8C,$95,$94,$97,$9F,$90,$9C,$8E,$9A,$92,$8F,$93,$88,$89,$8A,$90,$85,$84,$8B,$8D; 1856
		dc.b $89,$81,$83,$7E,$7C,$84,$7F,$82,$88,$7B,$86,$81,$85,$89,$84,$80,$86,$85,$8B,$89,$84,$83,$83,$83,$7D,$83,$7D,$7B,$82,$82,$82,$82,$86,$87,$87,$8E,$8A,$95,$88,$96,$97,$9B,$97,$9F,$A1,$9E,$A4,$AB,$A3,$B3,$B1,$AC,$A3,$A1,$97,$9F,$9B,$94,$96,$98,$8D,$8A,$86,$78; 1920
		dc.b $85,$8E,$93,$97,$9F,$A1,$A0,$9E,$95,$96,$92,$88,$86,$8A,$79,$77,$7B,$7F,$75,$6A,$6E,$6D,$78,$78,$77,$6B,$72,$7F,$7A,$81,$89,$87,$8F,$8F,$8A,$8C,$84,$7A,$84,$77,$7E,$7E,$82,$89,$83,$87,$90,$91,$98,$96,$90,$9D,$99,$95,$92,$92,$86,$8E,$A0,$8F,$90,$9E,$91,$8F; 1984
		dc.b $80,$7E,$97,$97,$86,$74,$83,$83,$73,$89,$83,$92,$9C,$7D,$94,$A2,$A5,$99,$7F,$7A,$67,$54,$5C,$6B,$68,$6C,$76,$6B,$56,$55,$43,$47,$77,$89,$88,$8A,$8D,$6B,$4E,$51,$6A,$78,$7C,$95,$90,$9D,$95,$84,$7F,$6E,$82,$8B,$65,$4C,$67,$91,$88,$7C,$7A,$8E,$C4,$A5,$77,$68; 2048
		dc.b $56,$70,$8D,$8E,$87,$97,$94,$86,$80,$71,$6A,$65,$6B,$8D,$9A,$86,$79,$63,$46,$51,$7A,$9C,$88,$75,$76,$86,$82,$69,$5E,$5E,$65,$6D,$65,$4F,$2E,$20,$30,$44,$46,$4B,$4D,$4E,$53,$4F,$49,$45,$51,$62,$58,$44,$51,$4F,$46,$44,$42,$4D,$50,$4D,$5D,$7B,$64,$5F,$78,$82; 2112
		dc.b $8A,$8C,$89,$9D,$98,$7E,$A2,$B3,$C2,$D0,$C3,$A9,$B2,$B8,$AE,$9A,$7B,$8F,$AD,$B7,$C4,$C6,$BC,$A9,$9B,$98,$96,$9A,$A2,$95,$91,$9E,$A4,$8A,$5E,$44,$49,$73,$7E,$74,$87,$9C,$B2,$C5,$B8,$A6,$A7,$A6,$A8,$9B,$7F,$75,$79,$91,$9A,$7E,$62,$45,$2F,$33,$32,$3B,$58,$74; 2176
		dc.b $92,$87,$64,$53,$37,$34,$3B,$3D,$4B,$56,$50,$41,$34,$44,$32,$20,$2B,$49,$5A,$7B,$76,$6E,$93,$75,$7E,$6E,$53,$75,$5F,$78,$8F,$8E,$9F,$B4,$B6,$8D,$70,$7A,$7B,$8E,$9B,$AF,$EA,$D7,$CF,$E4,$CC,$CA,$B3,$B1,$DB,$E6,$D6,$CB,$C1,$9D,$9B,$81,$88,$B1,$C0,$B7,$91,$92; 2240
		dc.b $BE,$C7,$A5,$A2,$9D,$A1,$9D,$A1,$B3,$9A,$8A,$B5,$CD,$C4,$93,$84,$A7,$AE,$A1,$A3,$C4,$D1,$CB,$E6,$DF,$D4,$C5,$B4,$A5,$7B,$6A,$86,$7C,$6A,$6C,$5A,$6B,$5A,$1F,$11,$29,$2E,$53,$87,$6D,$55,$62,$77,$74,$64,$73,$83,$86,$7F,$8C,$96,$7B,$74,$88,$8F,$81,$79,$7D,$86; 2304
		dc.b $80,$87,$AB,$B8,$AF,$90,$91,$95,$7A,$6A,$67,$4E,$53,$63,$58,$29,  0,$22,$69,$7D,$82,$78,$64,$69,$83,$9C,$98,$72,$7E,$B1,$D7,$CF,$99,$7B,$75,$72,$81,$8B,$6F,$63,$7D,$97,$7D,$58,$58,$6B,$79,$89,$86,$67,$5F,$69,$90,$A5,$86,$68,$68,$6D,$7A,$8A,$6B,$44,$38,$44; 2368
		dc.b $64,$51,$24,$22,$2F,$24,$21,$16,$18,$1F,$28,$5A,$81,$75,$62,$5D,$57,$5A,$5D,$61,$69,$58,$53,$50,$61,$6C,$5F,$70,$82,$83,$98,$A5,$A9,$96,$A2,$D7,$E4,$BD,$7D,$4D,$3F,$2F,$28,$37,$54,$7E,$99,$93,$7C,$4C,$2B,$49,$7A,$A7,$D8,$E4,$ED,$FF,$F9,$D1,$B8,$A3,$C8,$F5; 2432
		dc.b $FF,$FC,$C5,$A3,$B5,$9C,$82,$90,$70,$51,$64,$78,$80,$71,$66,$7F,$86,$6C,$64,$4B,$4A,$68,$76,$7D,$63,$4B,$46,$3D,$37,$40,$6B,$B0,$DC,$ED,$F3,$D2,$A4,$96,$B6,$C2,$B5,$BE,$CB,$D1,$9C,$5C,$56,$51,$51,$5F,$66,$6A,$5E,$68,$76,$64,$5A,$6B,$7A,$6C,$53,$68,$9B,$96; 2496
		dc.b $73,$68,$6D,$69,$5F,$62,$66,$6F,$94,$AA,$BB,$BB,$A9,$B2,$B7,$9E,$94,$99,$A0,$99,$9B,$AC,$B2,$AE,$B3,$B2,$B2,$AD,$86,$61,$5D,$66,$78,$9D,$B8,$AC,$96,$A2,$B3,$90,$77,$85,$6D,$68,$8F,$A9,$8A,$54,$2C,$3A,$4C,$31,$41,$5B,$66,$86,$9F,$AA,$8B,$6F,$74,$66,$5A,$4D; 2560
		dc.b $4E,$73,$71,$78,$A1,$88,$63,$5B,$42,$3A,$5E,$80,$87,$8D,$85,$6F,$48,$19,$19,$2C,$3C,$5A,$67,$4F,$29,  0,  0,  2,$15,$4C,$7E,$92,$AA,$AD,$96,$7E,$56,$5A,$88,$B0,$D1,$CE,$9A,$81,$90,$94,$89,$7F,$84,$90,$B0,$E1,$D1,$87,$85,$B0,$D3,$CE,$9F,$98,$A9,$BF,$DE,$E4; 2624
		dc.b $B8,$88,$8C,$87,$73,$70,$5B,$65,$9C,$D3,$FC,$FC,$D5,$C9,$AA,$98,$D7,$FA,$E2,$DC,$D9,$D6,$B2,$57,$29,$2B,$44,$84,$96,$77,$57,$44,$5F,$68,$44,$49,$6B,$98,$B0,$A0,$9F,$8F,$5D,$4F,$74,$83,$73,$5C,$50,$5E,$6F,$83,$80,$5A,$68,$84,$88,$A5,$B2,$95,$8A,$9F,$BF,$B9; 2688
		dc.b $69,$34,$3F,$52,$6A,$6C,$63,$67,$67,$7C,$80,$48,  9,$17,$6A,$91,$8E,$AD,$C3,$D6,$BC,$97,$B1,$B2,$A9,$B9,$C0,$BC,$A7,$90,$79,$83,$92,$9B,$AC,$8E,$7D,$8F,$8D,$8D,$70,$5B,$6E,$89,$A9,$A8,$89,$86,$8A,$90,$9F,$98,$81,$63,$5A,$6A,$4A,$38,$66,$8E,$AD,$A1,$66,$63; 2752
		dc.b $87,$91,$77,$58,$66,$9F,$7F,$40,$50,$40,$35,$4A,$3E,$55,$41, $E,$33,$34,$13,  7, $F,$40,$63,$69,$6E,$65,$4D,$4C,$5E,$41,$43,$67,$5F,$51,$35,$18,$1F,$19, $E,$28,$49,$66,$81,$6D,$4C,$42,$4D,$77,$8D,$8C,$9A,$A5,$97,$88,$91,$87,$5D,$5E,$85,$7A,$52,$51,$66,$7D; 2816
		dc.b $91,$A2,$C8,$D7,$A4,$8E,$AA,$CA,$BA,$C3,$D9,$D7,$DB,$B0,$80,$66,$50,$7E,$D7,$FE,$F4,$E7,$E5,$C6,$A2,$93,$97,$C5,$EF,$EC,$DE,$D2,$CE,$BD,$8D,$7E,$91,$78,$56,$6E,$69,$4D,$48,$48,$72,$8B,$6E,$68,$6B,$58,$51,$57,$72,$9C,$B2,$A9,$96,$7C,$74,$7C,$83,$94,$AC,$BB; 2880
		dc.b $AF,$80,$4A,$3A,$53,$81,$AD,$C3,$CA,$C9,$A9,$66,$38,$54,$74,$68,$76,$88,$98,$83,$3F,$30,$38,$47,$6A,$7C,$6F,$39,$21,$5E,$89,$7A,$7D,$A5,$AD,$A6,$A9,$9C,$BE,$DD,$D4,$E3,$F0,$F0,$D7,$87,$6C,$86,$79,$7B,$85,$81,$87,$89,$76,$5D,$40,$4E,$7C,$A9,$B8,$A9,$B8,$BC; 2944
		dc.b $95,$70,$5B,$70,$92,$78,$67,$6F,$6D,$73,$70,$68,$8C,$BE,$D0,$DA,$B3,$80,$86,$AC,$D7,$BC,$8A,$94,$9F,$8F,$39,  3,$3D,$78,$94,$88,$6B,$5A,$3E,$47,$4F,$48,$48,$5D,$88,$85,$6D,$77,$76,$5C,$57,$7D,$96,$80,$4D,$3E,$5A,$65,$85,$7C,$4F,$62,$98,$A2,$84,$65,$73,$88; 3008
		dc.b $95,$8F,$62,$39,$47,$74,$9A,$98,$6F,$86,$B5,$9B,$81,$69,$6F,$9C,$97,$87,$AD,$AC,$92,$A2,$7A,$5F,$76,$88,$B8,$A3,$68,$77,$B7,$EC,$D6,$BE,$EF,$FF,$ED,$BD,$88,$98,$C7,$E2,$D9,$99,$61,$52,$56,$70,$6B,$5D,$85,$A0,$9C,$93,$96,$89,$63,$68,$84,$80,$59,$22, $B,$1C; 3072
		dc.b $5C,$89,$64,$31,$3A,$5A,$6C,$49,$2F,$56,$8D,$B9,$D1,$BB,$99,$8C,$89,$8A,$95,$80,$6F,$8B,$64,$2B,$3E,$38,$2B,$4D,$56,$5E,$55,$54,$9A,$A7,$77,$69,$5C,$5E,$47,  0,  7,$3E,$4D,$5E,$49,$34,$49,$4C,$5A,$60,$5C,$8B,$BA,$B8,$B1,$B4,$B0,$AF,$BB,$99,$56,$4B,$66,$73; 3136
		dc.b $5B,$18,  0,  5,$33,$5C,$6E,$72,$8F,$A2,$AC,$AB,$97,$77,$6C,$74,$75,$72,$6C,$6E,$71,$67,$5C,$52,$3E,$34,$5B,$94,$8D,$6F,$7E,$A5,$BA,$C9,$D9,$C9,$89,$6E,$A0,$8C,$6B,$85,$7D,$76,$5B,$14,  1,$10,$1B,$5D,$79,$75,$94,$A1,$A6,$9F,$7F,$84,$9A,$9B,$A2,$8A,$8D,$9B; 3200
		dc.b $6A,$5B,$6B,$82,$AE,$B3,$7A,$52,$4D,$6C,$9D,$B2,$A8,$B0,$CE,$D2,$A8,$79,$66,$76,$92,$AF,$BE,$9C,$79,$77,$82,$8A,$8B,$9B,$C5,$E9,$E3,$BD,$8E,$76,$92,$BD,$DF,$FF,$FF,$EB,$C5,$BE,$FF,$FF,$FF,$F9,$EE,$F8,$EF,$BB,$9E,$9B,$A9,$F1,$FF,$D3,$BE,$BE,$C1,$B1,$82,$82; 3264
		dc.b $97,$9C,$AB,$A3,$87,$6A,$5A,$81,$AC,$B7,$A9,$90,$8C,$A0,$95,$96,$94,$85,$8D,$A4,$AF,$A4,$64,$3C,$65,$87,$82,$82,$8D,$94,$8B,$78,$6E,$57,$57,$7C,$9A,$9D,$8F,$61,$20,  0,$3B,$77,$60,$51,$57,$3C,$1C, $D,$36,$3E,$38,$64,$6F,$74,$8A,$54,$2E,$4E,$71,$A5,$9D,$52; 3328
		dc.b $59,$7C,$69,$62,$3D,$26,$5C,$70,$3E,  0,  0,  0,$24,$30,$4C,$8C,$8F,$70,$6B,$60,$65,$52,$34,$5A,$66,$4F,$3D,$11,  0,$22,$5C,$7B,$76,$5F,$65,$9D,$AA,$79,$6F,$6A,$7C,$A6,$A6,$8D,$6E,$67,$88,$86,$7C,$73,$4E,$57,$5A,$46,$4E,$4F,$7A,$B3,$A8,$98,$8A,$60,$4A,$38; 3392
		dc.b $43,$79,$82,$7A,$7E,$5B,$50,$79,$70,$60,$61,$7D,$BD,$C7,$A8,$8E,$62,$5C,$80,$7D,$6D,$84,$A1,$A5,$95,$6A,$5C,$4C,$30,$39,$56,$64,$77,$81,$85,$7E,$69,$78,$90,$8B,$96,$AD,$A9,$7E,$44,$3E,$6B,$86,$7E,$7B,$80,$96,$BE,$DA,$DF,$FF,$FF,$FF,$FF,$E2,$97,$82,$B1,$FF; 3456
		dc.b $FF,$F2,$C6,$B2,$B9,$9A,$5A,$4B,$7B,$D2,$FD,$C4,$8C,$82,$89,$A4,$C3,$CB,$D3,$D8,$B1,$7B,$6C,$77,$9C,$AE,$B8,$E7,$FF,$FF,$DF,$C3,$C6,$E2,$ED,$DB,$CE,$B0,$90,$AC,$CE,$B1,$9D,$A1,$9C,$8E,$80,$7A,$74,$73,$87,$93,$83,$73,$66,$67,$78,$84,$94,$96,$80,$77,$5C,$49; 3520
		dc.b $58,$40,$2C,$4E,$8E,$B3,$8C,$6B,$83,$96,$AF,$CF,$95,$66,$87,$A3,$A8,$62,  5,$12,$49,$35,  0,  0,  0,  0,$3C,$3A,$1A,  9,$16,$3B,$48,$4D,$65,$63,$4E,$46,$2A,$14,$21,$17,$18,$3A,$4E,$64,$3E,  0,  0,$3E,$5E,$82,$8C,$73,$81,$91,$7B,$77,$6E,$6D,$88,$83,$6D,$4A; 3584
		dc.b $15,$16,$53,$88,$7F,$5E,$49,$2F,$12, $F,$4B,$88,$94,$94,$83,$68,$78,$8F,$92,$9D,$BD,$E4,$E4,$87,$3B,$65,$9E,$95,$97,$8C,$73,$92,$B6,$A4,$80,$68,$85,$C4,$D0,$B1,$8C,$5F,$62,$92,$89,$63,$58,$54,$60,$7A,$67,$58,$4F,$42,$55,$76,$5E,$33,$3B,$5C,$A1,$D7,$BC,$A6; 3648
		dc.b $A0,$BE,$FF,$FF,$D2,$D2,$C7,$D6,$EC,$CB,$BF,$CE,$BC,$C7,$AF,$81,$8E,$AA,$B0,$C9,$B4,$8B,$8F,$A7,$95,$7B,$79,$72,$8B,$9E,$60,$52,$58,$4F,$65,$57,$5C,$BC,$FF,$D7,$A0,$A9,$F7,$FF,$FF,$F2,$D9,$B6,$CE,$C7,$7C,$7A,$C2,$FA,$FB,$D3,$AC,$89,$74,$86,$A6,$C3,$C2,$A4; 3712
		dc.b $95,$89,$8C,$97,$82,$6D,$85,$A2,$A6,$79,$3B,$4C,$75,$98,$E5,$D6,$7C,$79,$94,$BA,$B7,$A8,$E9,$FF,$DC,$B9,$7A,$67,$C4,$E5,$A9,$71,$52,$5B,$6B,$3A,  0,  0,$35,$6F,$6B,$42,$18,$1E,$3A,$32,$29,$22,$26,$3F,$3F,$1F, $F,$32,$6E,$69,$2D,$14,$1A,$31,$3C,$16,$2D,$76; 3776
		dc.b $94,$96,$53, $F,$2E,$46,$51,$5E,$58,$75,$7C,$43,$33,$4F,$77,$99,$83,$49,$41,$6F,$66,$21,  0, $E,$46,$3B,$19,$14,$43,$71,$A0,$BC,$9B,$A7,$CA,$9E,$5C,$45,$54,$9B,$D5,$B3,$6D,$3D,$57,$8C,$80,$63,$58,$69,$B3,$DA,$B2,$95,$90,$A5,$D5,$E3,$BC,$A7,$8F,$79,$74,$5F; 3840
		dc.b $56,$6B,$64,$3E,$17,$13,$44,$7F,$92,$91,$AC,$B6,$96,$A0,$A8,$9B,$BF,$E7,$D3,$CA,$DB,$E0,$C3,$8B,$A2,$D5,$B7,$88,$86,$91,$A1,$A4,$98,$9E,$BD,$D5,$CA,$96,$7C,$9F,$BB,$9B,$4E,$31,$41,$45,$3C,$26,$1D,$50,$9D,$C7,$B5,$84,$79,$88,$9D,$B7,$AC,$7E,$7E,$9C,$B5,$BB; 3904
		dc.b $92,$72,$81,$A5,$DF,$C1,$63,$56,$83,$99,$A2,$AA,$A6,$A0,$87,$79,$7E,$70,$7C,$8E,$62,$44,$56,$59,$51,$61,$89,$B0,$B7,$BF,$CF,$AF,$9E,$9E,$8F,$9E,$92,$7E,$A0,$B7,$B0,$AF,$94,$82,$89,$8D,$93,$83,$67,$71,$8A,$84,$85,$76,$5E,$59,$65,$82,$83,$65,$43,$3E,$6C,$6B; 3968
		dc.b $3E,$1C,$1A,$47,$7A,$91,$81,$4B,$3C,$7C,$8D,$4B,$20,$21,$44,$63,$5E,$52,$23,$16,$3E,$59,$53,$56,$71,$81,$7F,$87,$99,$90,$8E,$86,$71,$5B,$69,$7A,$6E,$61,$2E,$2E,$5A,$56,$38,$35,$5C,$7B,$8B,$A3,$8A,$76,$AC,$C3,$A5,$71,$4D,$61,$6E,$47,$43,$45,$35,$38,$4D,$5E; 4032
		dc.b $73,$91,$A1,$B4,$C8,$D2,$DA,$CE,$B2,$B2,$D6,$D3,$A9,$84,$7D,$87,$7B,$52,$42,$54,$61,$7C,$8F,$6F,$6D,$84,$A4,$DB,$FC,$FC,$FB,$E2,$C8,$CA,$C0,$BC,$D1,$C2,$92,$7E,$95,$B4,$B8,$B2,$B6,$AD,$B8,$D9,$DF,$E6,$D4,$CE,$FF,$FF,$D2,$C8,$C0,$AF,$8C,$69,$78,$70,$4F,$5F; 4096
		dc.b $57,$35,$57,$8B,$B6,$BC,$B0,$C9,$BC,$85,$7D,$9D,$B0,$9D,$86,$94,$88,$56,$43,$38,$3D,$55,$5B,$83,$91,$88,$92,$A1,$93,$7E,$7E,$9B,$A0,$8C,$72,$4E,$38,$3A,$4F,$66,$73,$59,$21,$24,$50,$7E,$A0,$9B,$8A,$8E,$88,$69,$4C,$5A,$89,$97,$7C,$4A,$27,$26,$38,$45,$43,$41; 4160
		dc.b $45,$47,$44,$46,$4C,$50,$69,$7D,$8B,$9E,$95,$6E,$54,$43,$49,$6D,$7D,$87,$68,$2E,$24,$28,$19,$37,$6B,$76,$67,$50,$5A,$62,$58,$5E,$61,$58,$55,$6B,$75,$58,$52,$6D,$85,$8B,$89,$8D,$98,$8D,$75,$75,$AA,$CA,$CB,$D2,$A5,$60,$59,$74,$88,$8C,$8E,$B8,$B3,$69,$52,$54; 4224
		dc.b $61,$90,$BD,$D3,$B1,$74,$5A,$3D,$22,$2C,$45,$5B,$67,$63,$66,$57,$38,$56,$96,$C2,$CB,$C9,$CA,$C3,$A4,$AA,$B6,$A0,$9C,$A7,$85,$47,$2D,$49,$64,$57,$5D,$74,$63,$58,$61,$6F,$88,$AC,$E3,$FF,$F6,$D8,$BA,$92,$74,$66,$85,$A4,$8B,$8E,$95,$76,$70,$74,$7B,$98,$B1,$E6; 4288
		dc.b $FF,$DF,$AF,$BB,$D8,$FF,$FF,$FF,$E3,$AB,$75,$56,$4D,$36,$5A,$96,$A9,$89,$5E,$5C,$82,$96,$B1,$E4,$FF,$FF,$EE,$D6,$CA,$94,$60,$6A,$6B,$68,$81,$78,$56,$48,$7B,$BB,$B5,$A5,$B3,$BC,$B7,$C8,$DB,$E0,$E5,$EA,$E1,$C0,$82,$4C,$34,$32,$5B,$8E,$A3,$8C,$5C,$4D,$61,$71; 4352
		dc.b $86,$94,$89,$A2,$DF,$E8,$9B,$3F,  0,  0,$27,$6A,$88,$63,$16,  0,  0,  6,$1B,$55,$67,$6A,$85,$74,$52,$60,$7F,$8F,$A1,$8D,$68,$51,$3D,$30,$1F,  0,  0,$17,$26, $F,  0,  0,  0, $A,$56,$A7,$B4,$85,$60,$32,  6,  0,$29,$76,$A1,$A3,$8C,$5B,$3B,$3B,$4A,$58,$74,$97; 4416
		dc.b $AE,$AB,$97,$8B,$8E,$79,$5F,$6D,$A1,$C7,$AA,$5F,$39,$29,$5C,$A3,$C0,$B0,$88,$4F,$1A,$16,$43,$8B,$D2,$D6,$8F,$44,  1,  0,$32,$6F,$B4,$FD,$FF,$F9,$E6,$C0,$BB,$A8,$9C,$CA,$FD,$F0,$C0,$82,$62,$6A,$61,$5D,$79,$77,$69,$5D,$5B,$72,$9B,$C0,$F3,$FF,$DF,$A3,$9B,$8A; 4480
		dc.b $91,$C5,$F1,$FB,$C7,$7E,$52,$33,$36,$67,$97,$B4,$DE,$E8,$F0,$C2,$79,$76,$A9,$F9,$FF,$FF,$FF,$BB,$68,$46,$34,$29,$59,$82,$7A,$51,$19,  0,$1B,$6D,$B5,$D2,$BD,$A8,$94,$8A,$A1,$B6,$BD,$B6,$95,$6B,$21,  0,$1C,$37,$65,$93,$A4,$A5,$8B,$77,$84,$A9,$D3,$FA,$FF,$FF; 4544
		dc.b $FF,$C0,$7F,$57,$4D,$4B,$43,$57,$7C,$55,$23,$31,$5A,$74,$93,$B6,$A4,$86,$9C,$CD,$CD,$A2,$92,$AF,$A9,$78,$4A,$18,  9,  7,$18,$55,$61,$5F,$70,$72,$64,$59,$6C,$9C,$CA,$E9,$F1,$D5,$93,$80,$83,$4F,$40,$4B,$21,  0,  0,  2,$36,$47,$43,$46,$2D,$38,$4D,$6C,$95,$B7; 4608
		dc.b $CF,$C9,$B2,$9F,$8A,$77,$6D,$7C,$85,$90,$7E,$60,$57,$53,$53,$80,$81,$7C,$93,$85,$8A,$8E,$86,$B9,$A6,$66,$4F,$21,$2A,$54,$50,$67,$88,$76,$39,$17, $E,$26,$46,$50,$73,$7F,$60,$69,$64,$69,$7F,$87,$BB,$E1,$D5,$D9,$C3,$A7,$8F,$7A,$96,$AD,$AB,$95,$62,$4C,$68,$6F; 4672
		dc.b $55,$50,$5D,$5F,$55,$56,$67,$7C,$96,$CD,$F5,$EA,$AC,$7E,$85,$84,$AE,$D5,$BB,$B3,$BF,$A9,$90,$78,$81,$A9,$B6,$E4,$FF,$FF,$E0,$B7,$BF,$E5,$FF,$FF,$F4,$C7,$91,$7A,$87,$7D,$60,$71,$78,$54,$37,$2F,$3C,$6D,$A6,$C7,$D4,$D4,$AF,$9E,$A4,$AF,$B9,$AB,$8E,$79,$87,$8C; 4736
		dc.b $7F,$72,$65,$65,$79,$9F,$C2,$CE,$CA,$C5,$C0,$B3,$B9,$D4,$C5,$A9,$94,$68,$55,$57,$2F,$21,$37,$31,$27,$28,$1F,$24,$42,$85,$AB,$90,$7A,$A4,$B8,$9C,$82,$53,$53,$67,$45,$3B,$48,$31,$1C, $F,  0, $E,$3B,$58,$4C,$40,$4F,$5E,$73,$8D,$98,$9A,$86,$60,$60,$5A,$31,$1D; 4800
		dc.b $11,  0,  0,  0,  0,  5,$12,$19,$24,$2E,$46,$5F,$9A,$B6,$9D,$98,$96,$96,$B7,$C7,$D9,$DA,$B2,$72,$56,$53,$5F,$74,$76,$63,$81,$78,$51,$5F,$85,$9A,$86,$76,$A7,$C9,$9A,$6A,$6B,$8F,$8E,$64,$62,$7F,$7E,$45,$2B,$38,$4E,$80,$8D,$6A,$62,$6C,$6A,$85,$B4,$EA,$FF,$FF; 4864
		dc.b $FF,$EF,$E7,$D6,$CD,$C6,$B1,$A3,$AC,$A4,$81,$62,$47,$3A,$44,$41,$3D,$5F,$88,$8F,$89,$84,$73,$7A,$9D,$C7,$D3,$B0,$97,$94,$B2,$B0,$89,$8B,$8F,$8A,$8A,$7A,$94,$D3,$FF,$FF,$D3,$D4,$F5,$D4,$B4,$AF,$C4,$EB,$D9,$AE,$9C,$81,$4F,$3E,$2C,$1C,$24,$31,$46,$60,$57,$42; 4928
		dc.b $3B,$5D,$8C,$A4,$A8,$96,$95,$BD,$B6,$88,$69,$61,$5A,$73,$92,$90,$92,$A5,$A9,$C6,$D1,$B0,$A0,$A7,$BD,$C9,$CA,$B4,$A1,$AB,$9C,$70,$4E,$41,$3B,$26,$1E,$32,$66,$8D,$95,$83,$5F,$56,$8F,$CC,$B5,$84,$99,$C9,$B8,$7C,$5F,$5E,$7E,$90,$75,$71,$70,$66,$5F,$5E,$59,$47; 4992
		dc.b $52,$73,$95,$97,$75,$67,$80,$8D,$79,$62,$6A,$7D,$72,$35,$1B,$3A,$56,$4E,$2B,$25,$33,$26, $D, $D,$30,$51,$68,$71,$83,$9E,$8E,$8F,$B6,$C4,$DE,$E4,$BE,$8F,$86,$8A,$72,$5C,$5F,$72,$7D,$4A,$39,$43,$26,$20,$51,$67,$58,$5D,$6E,$79,$79,$8F,$9E,$92,$8D,$6C,$50,$45; 5056
		dc.b $34,$2D,$2C, $E,  0,$13,$37,$3D,$59,$7D,$91,$AD,$C8,$D9,$E4,$FD,$FF,$FF,$E9,$F7,$EE,$BB,$86,$60,$5D,$55,$2D,$16, $D,$1C,$3E,$2B,$18,$3A,$7B,$AD,$BC,$BB,$C7,$D1,$CB,$D0,$AE,$A1,$A8,$8A,$81,$89,$6F,$90,$B6,$B2,$E1,$E3,$AB,$C7,$FF,$EC,$D3,$E6,$FF,$FF,$FF,$E3; 5120
		dc.b $BD,$A8,$AE,$8F,$70,$63,$60,$5A,$36, $E,$1A,$43,$54,$7D,$B1,$B6,$9A,$85,$92,$9F,$AD,$B7,$9D,$99,$A9,$A1,$92,$95,$AB,$C5,$BF,$AB,$8C,$94,$A7,$8C,$80,$AA,$C7,$DD,$CD,$80,$5B,$58,$5A,$64,$49,$3C,$4A,$36,$41,$56,$4C,$4C,$6D,$9B,$B3,$9B,$79,$64,$57,$76,$6E,$28; 5184
		dc.b $34,$68,$84,$98,$70,$50,$5F,$5D,$40,$48,$69,$81,$68,$22,$15,$42,$66,$7E,$5A,$3D,$48,$27,$12,$13,  5,$34,$6C,$78,$74,$60,$40,$37,$44,$51,$3B,$2D,$45,$4D,$38,$1A,  0,$22,$71,$70,$84,$9C,$A8,$BA,$B2,$A1,$A4,$C6,$DF,$CB,$AB,$9C,$92,$88,$7D,$65,$62,$65,$4D,$54; 5248
		dc.b $4D,$17,$1D,$65,$A1,$AC,$A4,$AF,$CD,$D2,$C3,$9F,$7E,$9D,$A2,$8A,$69,$35,$21,$22,$1D,$26,$51,$7C,$A9,$C4,$C7,$C0,$CE,$F4,$FF,$FF,$FF,$FF,$FF,$E8,$C4,$AB,$9B,$72,$67,$5E,$30,  6,  0,  7,$37,$62,$85,$89,$8F,$B2,$BA,$AB,$B6,$CC,$F3,$FF,$E5,$A8,$82,$72,$86,$7C; 5312
		dc.b $91,$AC,$AC,$CE,$C7,$95,$93,$A0,$B4,$FF,$FF,$EA,$CF,$C4,$DC,$E9,$AC,$A1,$BB,$A7,$72,$2B, $E,$2F,$40,$31,$2A,$2F,$46,$54,$3A,$36,$51,$6A,$7A,$8A,$AC,$C0,$B9,$96,$82,$92,$9B,$BF,$FF,$EA,$A6,$76,$57,$44,$50,$8B,$A0,$95,$78,$37,$1C,$27,$3A,$6A,$7C,$5E,$5C,$70; 5376
		dc.b $6C,$72,$80,$97,$B0,$B5,$BA,$96,$5D,$5C,$57,$4D,$61,$6A,$87,$8B,$3B, $A,$22,$37,$7B,$BB,$CA,$CA,$AD,$83,$59,$53,$77,$90,$A7,$9E,$5A,$27,  1,  0,$17,$38,$59,$67,$4D,$3A,$4A,$6A,$8A,$A0,$8F,$91,$95,$85,$6C,$4B,$50,$6C,$74,$79,$69,$4A,$35,$3C,$4B,$43,$5B,$8F; 5440
		dc.b $D1,$F5,$D2,$84,$70,$A6,$BA,$BA,$AC,$90,$88,$72,$4B,$3D,$3E,$5D,$5D,$34,$54,$6F,$71,$A1,$9D,$72,$55,$4D,$A1,$E1,$B9,$A3,$87,$4B,$2C,$27,$3F,$4B,$46,$4E,$5E,$5D,$63,$81,$AF,$D5,$EC,$FD,$FF,$D5,$A3,$BB,$B7,$A8,$B9,$B4,$98,$75,$41,$1E,$10,$19,$41,$55,$3D,$52; 5504
		dc.b $72,$60,$4D,$43,$53,$AB,$FF,$FF,$EB,$A3,$87,$87,$87,$8C,$B2,$FB,$FF,$D3,$83,$55,$5F,$8F,$D6,$F4,$D4,$A8,$A1,$BD,$B2,$B2,$CB,$D5,$FF,$FF,$DE,$90,$4F,$3A,$4D,$51,$6F,$A3,$97,$44,  0,  0,$23,$62,$A5,$C8,$D4,$C0,$86,$66,$89,$B1,$F4,$FF,$FF,$FD,$DB,$79,$42,$61; 5568
		dc.b $91,$AD,$9A,$67,$3F,$1D, $C,$23,$47,$66,$6D,$76,$90,$B0,$AA,$97,$8F,$98,$C4,$D7,$C7,$CC,$B8,$81,$56,$24,$19,$54,$66,$37,$1D,$19,$31,$47,$48,$5B,$77,$88,$96,$AC,$B4,$A5,$7B,$60,$64,$68,$65,$73,$79,$5D,$10,  0,  0,  0,$39,$87,$82,$3E,  6,  0,  5,$3E,$9F,$EF; 5632
		dc.b $FA,$C9,$7F,$4E,$42,$3F,$55,$75,$8D,$87,$4D,  0,  0,  0,$20,$54,$70,$7B,$9E,$9A,$73,$5E,$72,$9E,$C8,$EE,$ED,$D1,$9B,$4B,$24,$44,$7A,$A5,$A1,$69,$3C,$15,$12,$4A,$9E,$D2,$C5,$90,$78,$85,$7E,$76,$86,$9E,$C2,$D5,$D9,$B5,$6A,$57,$7A,$7F,$79,$91,$CC,$E7,$C8,$95; 5696
		dc.b $70,$5F,$7C,$CA,$FF,$FF,$D5,$94,$69,$67,$80,$9E,$A9,$A8,$AB,$89,$50,$3E,$69,$B5,$DD,$C3,$9D,$88,$9A,$99,$84,$98,$E4,$FF,$FF,$E8,$86,$7C,$73,$71,$BC,$E2,$EC,$F6,$D1,$9E,$8B,$6F,$93,$E8,$FF,$FB,$B4,$4E,$3D,$8F,$B8,$A2,$90,$9C,$A3,$77,$46,$37,$4F,$8C,$98,$65; 5760
		dc.b $53,$55,$43,$60,$72,$73,$B4,$D2,$B8,$9C,$68,$36,$36,$5F,$A4,$BA,$AD,$8A,$5C,$46,$31,$24,$25,$34,$4A,$56,$6A,$82,$65,$4A,$4B,$66,$A8,$CF,$C0,$B5,$9B,$70,$59,$3E,$38,$67,$78,$53,$1A,  0,  3, $D,  3,$2F,$6E,$80,$55,$1D,$1C,$53,$79,$9A,$E2,$F7,$CC,$A1,$55,$16; 5824
		dc.b $17,$2E,$56,$7A,$80,$54,  7,  0,  0,$14,$65,$8B,$91,$99,$A6,$91,$72,$7D,$B1,$DB,$D6,$AB,$83,$76,$67,$42,$2D,$30,$52,$59,$16,  0,$22,$74,$94,$8A,$85,$92,$B7,$D3,$DF,$E7,$E4,$BF,$AC,$B9,$C9,$C1,$AD,$9F,$87,$71,$56,$3B,$3F,$70,$7C,$6E,$84,$8C,$95,$89,$57,$5C; 5888
		dc.b $B9,$FF,$FF,$FF,$AD,$5D,$61,$8A,$83,$95,$CF,$D9,$B9,$54,  0,  0,$59,$C0,$F5,$D1,$8E,$5F,$3B,$57,$8F,$BE,$FF,$FF,$FF,$EB,$90,$3F,$47,$84,$B6,$BD,$8E,$59,$42,$25,  8,$18,$4D,$AA,$F3,$D9,$84,$4D,$74,$A6,$9F,$BB,$FF,$FF,$FF,$DF,$81,$53,$6C,$AB,$B8,$8C,$71,$57; 5952
		dc.b $48,$42,$46,$5B,$6A,$90,$D3,$FF,$FA,$93,$4E,$42,$75,$A4,$AD,$CE,$BD,$72,$2C,  0,  0,$25,$65,$A1,$85,$44,$2F, $C, $A,$38,$7A,$D5,$F7,$DA,$AD,$72,$6A,$7F,$6D,$81,$AC,$AA,$8F,$58,$35,$4C,$63,$7F,$9E,$A1,$9B,$67,$19,$2A,$6A,$7B,$95,$A6,$A1,$82,$3D,$2C,$35,$3A; 6016
		dc.b $57,$7A,$88,$6F,$47,$41,$5C,$92,$9D,$94,$84,$7F,$97,$B2,$C2,$C0,$89,$4E,$34,$34,$70,$AB,$AB,$A5,$8D,$44,$14,$2D,$3E,$5C,$86,$A5,$9A,$71,$40,$29,$3D,$54,$80,$AC,$AD,$7E,$50,$3B,$3F,$62,$6D,$90,$C4,$83,$3F,$2A,$36,$8B,$CC,$BC,$BC,$B4,$75,$4D,$3B,$56,$B7,$FF; 6080
		dc.b $FD,$C6,$94,$7D,$67,$42,$43,$63,$9E,$B8,$87,$55,$3B,$4E,$62,$70,$90,$A9,$B3,$B5,$B0,$BE,$C9,$A3,$7C,$7D,$9F,$A9,$96,$80,$7E,$8B,$72,$2B,$34,$5B,$4E,$54,$52,$6E,$B8,$BD,$A2,$BC,$DF,$FF,$FF,$C6,$93,$8C,$9E,$A7,$8D,$79,$79,$65,$2C, $F,$26,$5B,$A9,$AD,$90,$7C; 6144
		dc.b $87,$97,$88,$B9,$F9,$FF,$FF,$FF,$E3,$C4,$A5,$8F,$A0,$78,$53,$51,$50,$6C,$96,$9B,$9D,$A5,$A6,$AC,$90,$6D,$99,$EF,$FF,$FB,$D3,$8B,$5B,$77,$74,$58,$5D,$68,$6C,$3B,  0,  0,$1A,$3C,$70,$9E,$96,$8E,$8D,$8D,$A1,$C4,$E8,$FF,$F2,$9B,$44,$42,$7D,$A9,$BC,$BA,$88,$43; 6208
		dc.b $1D,  3,  0, $E,$60,$7E,$6E,$4F,$22,$14,$33,$55,$70,$94,$9F,$A1,$9A,$6E,$51,$54,$5D,$7B,$9E,$8D,$6A,$50,$46,$60,$6E,$4D,$44,$5F,$50,$44,$66,$8F,$AE,$AF,$7A,$73,$8A,$86,$81,$7B,$65,$5D,$35,  2,  0,  6,$31,$56,$38,  8, $C,$1A,$2E,$4D,$7D,$C3,$DB,$C0,$76,$48; 6272
		dc.b $71,$96,$AD,$C9,$C8,$C6,$88,$27,$17,$3A,$45,$4A,$40,$5B,$81,$75,$63,$5F,$7C,$D2,$FB,$EC,$D6,$A9,$9C,$8C,$6A,$7E,$B5,$B8,$A3,$78,$3E,$40,$77,$94,$95,$8A,$8E,$90,$7D,$A9,$D7,$C6,$C3,$C3,$CB,$CF,$AD,$88,$96,$8D,$67,$40,$3F,$6F,$B1,$CC,$B6,$98,$97,$9B,$8C,$81; 6336
		dc.b $A0,$E1,$FF,$EF,$C1,$97,$7A,$90,$98,$85,$A3,$CB,$C9,$8C,$40,$49,$7A,$81,$9B,$C8,$D1,$E4,$CC,$88,$8D,$C8,$FC,$FF,$DA,$79,$49,$59,$7E,$9C,$C8,$F6,$E3,$A8,$6A,$4A,$5E,$96,$C4,$B8,$99,$80,$70,$9C,$8B,$4E,$3B,$39,$68,$8C,$67,$3D,$34,$4D,$68,$67,$64,$75,$88,$8C; 6400
		dc.b $7B,$6F,$69,$6E,$89,$87,$49,$35,$77,$A7,$AB,$A7,$7E,$5E,$45,$44,$6B,$70,$60,$60,$26,  0,  0,  0, $A,$3D,$43,$47,$3B,$33,$45,$59,$83,$AE,$BF,$A8,$71,$60,$68,$6D,$92,$9C,$92,$99,$69,$31,$30,$30,$2E,$34,$23,$46,$8B,$A8,$8A,$5A,$65,$89,$A1,$AC,$88,$60,$6B,$7E; 6464
		dc.b $78,$52, $C,  0,$16,$2B,$3E,$45,$46,$5B,$73,$7C,$6C,$60,$95,$FA,$FF,$E3,$A3,$84,$93,$A1,$9C,$A3,$8F,$64,$3D, $C, $B,$2C,$66,$B3,$CB,$CA,$BF,$8A,$5F,$72,$C8,$FF,$FF,$F1,$CA,$8D,$66,$72,$84,$98,$CE,$EA,$CC,$8D,$5C,$5C,$61,$6F,$B0,$C4,$B7,$BB,$B3,$9B,$8F,$99; 6528
		dc.b $CE,$E9,$B5,$76,$67,$9A,$C9,$C4,$9D,$A1,$BE,$C2,$A0,$59,$3A,$75,$B7,$C0,$A7,$8B,$9C,$BF,$B4,$7A,$62,$8E,$C3,$D0,$BC,$9E,$9E,$93,$77,$6F,$81,$A0,$B4,$AF,$A7,$9C,$77,$5B,$63,$68,$66,$83,$A7,$B9,$CD,$D5,$BD,$9A,$A8,$BD,$B1,$B0,$AE,$9A,$7F,$5A,$4D,$40,$31,$2B; 6592
		dc.b   9,  0,$24,$42,$65,$5D,$6A,$9D,$9F,$78,$67,$7B,$A2,$BB,$94,$60,$69,$5F,$4D,$49,$27,$24,$48,$65,$4F,$45,$7B,$9A,$79,$64,$64,$65,$71,$67,$64,$68,$6B,$6B,$55,$3B,$31,$2D, $F,  2,$31,$5F,$7E,$8A,$81,$66,$53,$35,$46,$96,$E4,$E9,$B6,$7B,$5F,$6F,$89,$95,$72,$4F; 6656
		dc.b $5F,$6B,$5D,$5D,$40,$32,$50,$83,$C2,$BB,$74,$49,$5D,$9A,$B3,$8B,$59,$65,$91,$8C,$3B,  0,$32,$98,$D2,$C6,$80,$52,$3F,$46,$79,$8F,$96,$B5,$C4,$A9,$82,$6E,$74,$72,$50,$5F,$91,$C5,$FA,$EB,$A4,$81,$83,$8B,$A3,$B4,$A8,$A5,$8D,$6A,$50,$4C,$79,$CE,$EC,$A5,$62,$6E; 6720
		dc.b $BF,$F3,$DF,$B6,$9C,$94,$94,$8D,$89,$74,$6A,$76,$64,$75,$B7,$99,$72,$58,$3A,$7E,$C8,$D9,$EF,$F0,$EA,$E2,$A1,$5C,$6A,$A1,$D0,$D8,$9C,$64,$4B,$3E,$54,$58,$35,$2A,$63,$9F,$AE,$97,$75,$74,$8B,$AC,$BA,$D6,$F2,$E4,$C2,$86,$4D,$44,$52,$62,$6E,$63,$50,$61,$7E,$9B; 6784
		dc.b $C5,$C3,$AE,$9E,$94,$BF,$E6,$C9,$A1,$7F,$79,$86,$71,$4E,$2D,$18,  8,  0,  0,$3D,$85,$A5,$80,$66,$53,$3D,$51,$84,$A6,$C9,$CA,$A2,$77,$3C,$25,$60,$9C,$9C,$A0,$95,$6A,$53,$21,  0,$1C,$4D,$A2,$E3,$A7,$45,$13,$1A,$49,$7B,$96,$AE,$BA,$93,$40,  0,  0,$64,$B2,$B4; 6848
		dc.b $97,$6F,$33, $F,$3D,$83,$98,$98,$8D,$86,$8C,$6F,$75,$A0,$93,$82,$A8,$BF,$A7,$7B,$5C,$6A,$98,$A9,$98,$81,$79,$89,$7E,$3F,$15,$28,$5D,$A0,$A7,$69,$42,$5D,$A8,$BE,$86,$73,$85,$A7,$9E,$4C,$3A,$5D,$5F,$5F,$51,$4D,$78,$93,$8E,$94,$8E,$70,$9F,$D7,$E7,$FF,$FD,$EF; 6912
		dc.b $E8,$A5,$66,$51,$48,$73,$90,$7D,$80,$7C,$5B,$4B,$46,$4E,$62,$8A,$BA,$D7,$C8,$99,$8E,$8D,$92,$96,$99,$B2,$B4,$9A,$70,$2E,$24,$62,$B6,$E1,$B4,$84,$85,$87,$A9,$CD,$D1,$E2,$EE,$FF,$E3,$81,$40,$50,$7E,$A8,$AE,$78,$28,  0,  4,  3, $A,$45,$A9,$EF,$D2,$89,$64,$72; 6976
		dc.b $7D,$AB,$FF,$FF,$E6,$AD,$71,$62,$49,$62,$B0,$C3,$C2,$CB,$8E,$4E,$4B,$6F,$A6,$BA,$AC,$BA,$C8,$A4,$6A,$64,$72,$72,$6A,$5D,$52,$5C,$65,$35,  0, $F,$5F,$B3,$BA,$75,$43,$18,$13,$65,$8F,$93,$9A,$88,$BB,$E0,$AD,$9C,$9C,$89,$83,$7B,$62,$4F,$56,$59,$6B,$66,$43,$45; 7040
		dc.b $51,$53,$5F,$74,$65,$3A,$30,$5B,$9D,$B0,$8A,$64,$6D,$99,$8E,$55,$46,$60,$85,$8F,$52,$3E,$44,$3E,$4E,$51,$57,$A9,$F1,$D2,$A8,$6A,$36,$6E,$BC,$EB,$FF,$FF,$C8,$79,$2C,$1B,$54,$70,$69,$68,$37,$16,$24,$31,$52,$64,$54,$71,$B3,$CA,$A2,$5F,$55,$5F,$66,$7E,$77,$79; 7104
		dc.b $6B,$5F,$5F,$47,$50,$74,$9C,$D2,$C5,$92,$8A,$A1,$C9,$F9,$EE,$B6,$B5,$BB,$A4,$90,$54,$1F,$43,$80,$9B,$8B,$62,$41,$3A,$34,  7,$16,$84,$E3,$FF,$E0,$78,$5C,$57,$5D,$A3,$D5,$D5,$C2,$8C,$72,$81,$8A,$97,$B0,$C5,$C5,$C1,$CC,$CB,$97,$6F,$8E,$D4,$F7,$EF,$BE,$6C,$3C; 7168
		dc.b $26,$26,$55,$67,$62,$6B,$63,$42,$21,$11,$51,$C4,$FF,$FF,$C5,$85,$5B,$57,$8A,$B9,$CD,$E4,$FB,$E5,$BA,$6F,$3F,$7C,$C0,$C9,$DE,$DA,$89,$59,$5D,$73,$B1,$C1,$B1,$B5,$89,$4B,$18,  2,$25,$53,$99,$BB,$6F,$12,  2,$4A,$90,$90,$73,$59,$6D,$91,$73,$31,$4B,$89,$CB,$F5; 7232
		dc.b $CB,$8B,$78,$6E,$77,$61,$53,$63,$79,$81,$88,$8F,$70,$5B,$65,$46,$42,$61,$59,$63,$65,$3F,$47,$59,$6D,$9A,$8C,$46,$45,$6D,$80,$74,$62,$6D,$6E,$62,$3D,$3D,$74,$91,$8C,$79,$76,$6F,$8D,$B0,$B7,$A0,$8E,$84,$96,$CD,$D3,$8F,$67,$7E,$86,$66,$3D,$16,$23,$3D,$63,$72; 7296
		dc.b $50,$30,$3E,$5B,$47,$2A,$2E,$4D,$98,$CB,$A8,$72,$33,  5,$4F,$C6,$ED,$A5,$65,$6A,$86,$87,$7F,$B2,$EF,$F1,$BC,$6E,$80,$C0,$B1,$AA,$9E,$80,$8C,$83,$69,$7A,$8C,$67,$4D,$4A,$4B,$5E,$51,$59,$7C,$7D,$83,$AD,$D1,$D4,$96,$54,$42,$65,$BE,$ED,$CC,$A5,$8B,$98,$B9,$B6; 7360
		dc.b $BB,$DC,$EC,$BE,$8E,$A2,$D3,$CC,$BC,$B3,$88,$68,$69,$67,$7C,$7E,$4D,$2B,$32,$3F,$57,$6F,$83,$A4,$AE,$B3,$B8,$AF,$D2,$C5,$74,$6B,$A9,$DD,$EC,$CD,$A8,$87,$7B,$7C,$79,$8B,$DC,$F7,$A2,$6C,$6A,$75,$BD,$E8,$DA,$D7,$A6,$67,$45,$3B,$4A,$58,$51,$36,$2B,$44,$5B,$46; 7424
		dc.b $33,$34,$43,$63,$7F,$91,$84,$65,$5F,$93,$C2,$D6,$E6,$BA,$5C,$27,$31,$5B,$82,$A1,$A4,$74,$58,$3C,$16,$4D,$9D,$A5,$A2,$8B,$61,$53,$3B,$3C,$63,$7C,$95,$9A,$78,$48,$21,$24,$33,$37,$46,$47,$54,$88,$84,$5F,$44,$30,$6F,$CA,$E2,$B8,$74,$45,$66,$9A,$C5,$C4,$98,$85; 7488
		dc.b $78,$71,$86,$89,$77,$61,$52,$49,$47,$4C,$58,$77,$90,$69,$40,$3E,$39,$31,$33,$38,$46,$6B,$75,$76,$81,$95,$88,$57,$3D,$6D,$C4,$EA,$BE,$82,$6A,$6C,$83,$BC,$E3,$D8,$B4,$8D,$6E,$77,$93,$B0,$C2,$C2,$A5,$63,$44,$54,$A6,$E1,$9D,$50,$2A,$2B,$70,$97,$87,$85,$8F,$9E; 7552
		dc.b $B2,$8A,$3D,$3A,$78,$BC,$F6,$FF,$EC,$95,$6D,$6F,$8A,$C3,$EB,$FF,$FF,$C1,$7A,$62,$58,$5D,$A7,$EA,$D7,$9F,$64,$4F,$59,$77,$8D,$7F,$70,$78,$72,$74,$80,$96,$9E,$86,$73,$7E,$92,$9C,$93,$95,$9D,$B0,$DD,$FF,$F2,$AC,$6C,$3E,$59,$9D,$D4,$F7,$D6,$87,$5C,$75,$7E,$9C; 7616
		dc.b $DA,$D9,$A4,$6E,$46,$36,$37,$3A,$6F,$9B,$7A,$55,$25,  8,  7,$10,$2C,$54,$80,$7F,$59,$64,$9E,$AE,$86,$71,$A9,$D9,$C5,$6F,$21,$27,$72,$AA,$AB,$77,$48,$49,$46,$24,$3C,$93,$A9,$7D,$51,$33,$33,$59,$87,$B2,$C5,$A4,$4E, $A, $E,$3E,$42,$14,$1A,$59,$92,$5B,$24,$55; 7680
		dc.b $86,$96,$9F,$BC,$E1,$CA,$78,$5F,$6A,$77,$91,$AD,$DB,$BD,$7E,$45,  7,$11,$5C,$87,$78,$6D,$80,$79,$51,$47,$73,$99,$80,$4E,$26,$18,$3E,$54,$40,$47,$77,$AB,$A1,$6E,$5C,$72,$85,$8B,$BE,$FF,$FF,$BC,$62,$3F,$5E,$87,$9D,$BA,$D4,$AF,$72,$52,$46,$70,$A4,$BF,$D5,$D9; 7744
		dc.b $D2,$AA,$76,$79,$B6,$CC,$A5,$78,$64,$67,$6B,$56,$3A,$35,$57,$88,$B1,$A3,$81,$91,$8B,$A0,$FF,$FF,$FF,$C9,$92,$94,$96,$9C,$C5,$B9,$93,$7A,$6A,$66,$5A,$4A,$7C,$C1,$DC,$CE,$8F,$77,$98,$B1,$B7,$AC,$9A,$93,$9A,$83,$56,$21,$18,$52,$7A,$75,$73,$80,$C5,$EC,$D0,$CC; 7808
		dc.b $C1,$BD,$B8,$A8,$C0,$B6,$86,$9D,$A9,$A4,$C4,$A6,$7D,$71,$42,$51,$8D,$74,$67,$7B,$83,$8C,$8F,$67,$2A,$16,$31,$41,$48,$42, $E,  0,$24,$5F,$82,$7E,$6B,$98,$C4,$BD,$B6,$99,$72,$91,$9B,$7C,$71,$5B,$61,$93,$7E,$3C,$29,$26,$4A,$55,$43,$6C,$82,$73,$7E,$73,$7C,$9C; 7872
		dc.b $8F,$71,$65,$52,$37,$10,  8,$15,$26,$51,$67,$72,$83,$75,$81,$A9,$D6,$DD,$C1,$AD,$AA,$96,$6B,$73,$A1,$96,$87,$6C,$28, $D,$1E,$37,$43,$43,$72,$AB,$A6,$8C,$6F,$60,$81,$8E,$83,$94,$78,$35, $D,$21,$49,$5D,$68,$7B,$80,$8A,$99,$A3,$9B,$BA,$E6,$D1,$B0,$AF,$A1,$7D; 7936
		dc.b $7D,$73,$5E,$77,$63,$3F,$4D,$5F,$84,$AB,$81,$86,$BE,$DB,$F7,$F1,$D8,$D5,$C2,$B2,$AF,$9A,$8E,$66,$40,$35, $D,$1D,$66,$9B,$A7,$9D,$81,$84,$BB,$E7,$FF,$FF,$DE,$C4,$C5,$B6,$91,$59,$54,$7B,$80,$88,$71,$4D,$4D,$58,$70,$A5,$DE,$E2,$BF,$9F,$AE,$DA,$D7,$C4,$B2,$90; 8000
		dc.b $72,$4B,$1A,$1A,$3D,$5B,$70,$7E,$99,$96,$69,$82,$C6,$F6,$FF,$E3,$9B,$80,$94,$A6,$A7,$B8,$B8,$A0,$96,$61,$3B,$46,$5F,$89,$8D,$7C,$78,$7F,$91,$83,$72,$68,$57,$5F,$59,$15,  0,  0,  0,$4D,$8C,$79,$65,$75,$85,$85,$98,$AD,$DA,$E6,$A5,$6B,$70,$68,$4F,$5E,$6F,$6B; 8064
		dc.b $4C,$20, $D,$1D,$3F,$5F,$68,$66,$80,$AE,$AE,$86,$7F,$75,$57,$64,$69,$59,$4D,$15,  0,  0,$15,$66,$9F,$B3,$C2,$9B,$76,$92,$C0,$FA,$FF,$D8,$A9,$A4,$80,$4C,$61,$79,$45,$1F,$20, $B,$1C,$31,$3D,$68,$84,$90,$A4,$9C,$90,$9C,$9E,$6E,$68,$92,$86,$5B,$3A,$1C,$16,$3B; 8128
		dc.b $68,$92,$C0,$D5,$BB,$7C,$58,$85,$F9,$FF,$FF,$CB,$89,$44,$45,$68,$80,$77,$2D,  3,$28,$4B,$6E,$8A,$95,$BC,$CA,$9C,$9B,$E8,$FF,$FF,$D0,$AE,$AE,$AB,$93,$5A,$26,$2A,$3F,$6D,$BC,$E9,$BA,$56,$40,$8C,$F2,$FF,$FF,$FF,$D3,$88,$5B,$78,$A1,$A0,$6F,$3F,$1D,  8,$3E,$64; 8192
		dc.b $6D,$8D,$A3,$B4,$96,$6A,$AF,$FF,$FF,$FA,$CB,$9A,$78,$5C,$69,$76,$53,$59,$88,$AA,$B8,$95,$42,$27,$7C,$DE,$FF,$FE,$B4,$82,$4E,$48,$6E,$87,$C0,$D1,$8A,$4D,$27,$2D,$61,$8E,$AB,$BE,$9C,$63,$4A,$4B,$7D,$C0,$B6,$89,$38,  0,  0,$2D,$48,$67,$86,$B3,$B6,$7F,$43,$2D; 8256
		dc.b $7A,$C7,$DF,$F1,$C7,$73,$28,  8,$31,$68,$80,$7B,$36,  0,  0,  0,$13,$39,$7D,$C9,$B6,$79,$76,$96,$AE,$A8,$87,$81,$6F,$3A,$12,$21,$3D,$3B,$36,$6A,$96,$81,$57,$46,$81,$D3,$E9,$E6,$FD,$DA,$91,$7D,$91,$9F,$9A,$79,$46,$1F,$24,$35,$20, $C,$28,$6A,$99,$93,$7E,$77; 8320
		dc.b $75,$9D,$BA,$97,$71,$5E,$44,$5D,$84,$83,$7D,$74,$82,$9D,$7A,$4D,$70,$B4,$D7,$D0,$C0,$B4,$8A,$68,$72,$8D,$A9,$B1,$85,$48,$1E,$2B,$4D,$50,$7D,$A7,$8A,$64,$6B,$9B,$B9,$AD,$9A,$99,$8C,$6E,$7A,$C6,$E2,$BE,$83,$56,$81,$E0,$FF,$EA,$B3,$88,$7B,$96,$E6,$FF,$FF,$B2; 8384
		dc.b $61,$5A,$7E,$A8,$A2,$83,$8B,$95,$69,$33,$28,$65,$A8,$A5,$77,$68,$68,$67,$78,$87,$8A,$7D,$66,$70,$9E,$CD,$B8,$7E,$6A,$83,$C9,$FF,$FF,$E7,$CC,$A9,$7E,$7A,$B0,$D8,$B2,$71,$54,$54,$40,$25,$36,$75,$8C,$7D,$62,$53,$64,$64,$79,$A9,$A2,$85,$70,$65,$7E,$87,$57,$51; 8448
		dc.b $46,$2A,$48,$7E,$8A,$84,$6C,$70,$9E,$C1,$D2,$D6,$C0,$B1,$A2,$90,$91,$8D,$77,$6A,$50,$3F,$23,$10,$31,$3F,$29,$2B,$33,$40,$4B,$40,$4E,$69,$58,$54,$61,$65,$79,$88,$80,$69,$4A,$46,$50,$71,$97,$9E,$90,$7A,$74,$AD,$D5,$A7,$67,$5B,$95,$CA,$B6,$8D,$5C,$36,$45,$6B; 8512
		dc.b $9F,$BA,$8B,$60,$4A,$35,$4C,$57,$68,$AD,$AD,$6E,$43,$12,$17,$59,$8A,$92,$85,$7A,$89,$7F,$4E,$5C,$92,$CB,$FF,$FF,$DB,$9D,$65,$63,$91,$C3,$F0,$D8,$75,$39,$23,$33,$57,$7A,$B0,$A8,$62,$38,$31,$52,$86,$9E,$A9,$9A,$60,$34,$3A,$65,$90,$94,$73,$6D,$83,$93,$AC,$BC; 8576
		dc.b $96,$75,$9A,$E2,$FF,$FF,$D7,$90,$85,$AA,$FF,$FF,$DF,$7D,$49,$50,$97,$DC,$D3,$A7,$65,$28,$35,$6B,$9A,$AD,$9D,$77,$4C,$26,$27,$58,$97,$AB,$90,$82,$79,$6C,$6A,$67,$84,$B6,$C6,$D0,$EC,$D3,$9A,$8C,$AC,$C0,$D6,$FF,$FF,$AA,$51,$3B,$55,$7C,$9D,$AB,$90,$2E,  0,$12; 8640
		dc.b $2A,$4C,$6F,$69,$5B,$32,$12,$45,$7B,$93,$AC,$A9,$8E,$67,$4E,$6F,$98,$8B,$6A,$74,$A3,$AA,$81,$64,$69,$9C,$C5,$A4,$79,$7D,$9A,$BB,$B1,$94,$97,$6F,$3D,$68,$94,$7A,$4A,$1B,$1E,$23,$17, $A,  4,$23,$66,$81,$70,$5F,$5C,$74,$7A,$76,$97,$A9,$AE,$B7,$81,$4B,$69,$86; 8704
		dc.b $9A,$9E,$80,$6F,$51,$3D,$5D,$7E,$86,$7F,$7B,$93,$81,$5A,$64,$6E,$8D,$A9,$98,$76,$52,$36,$38,$57,$8B,$B0,$91,$69,$6E,$68,$63,$68,$76,$8F,$B3,$C8,$B0,$77,$42,$53,$A2,$E3,$F3,$BE,$45,  0,$37,$B8,$FF,$D9,$6D,$25,$1F,$4B,$96,$D7,$BE,$70,$36,$30,$55,$73,$76,$88; 8768
		dc.b $BC,$CE,$95,$57,$5F,$9B,$CE,$D2,$BC,$AA,$99,$95,$96,$71,$44,$57,$A6,$BE,$B2,$A3,$78,$4A,$41,$75,$E5,$FF,$F2,$A1,$4D,$49,$86,$BD,$EC,$CC,$7D,$26,  0,$3B,$8F,$96,$85,$6F,$5E,$74,$9F,$E0,$EA,$AB,$8C,$B7,$F7,$FF,$F6,$9D,$48,$25,$57,$C1,$F4,$BA,$41,  0,  0,$58; 8832
		dc.b $C7,$E4,$B0,$6C,$46,$57,$94,$C4,$C1,$86,$58,$75,$7E,$4D,$2D,$37,$53,$65,$65,$67,$65,$64,$7B,$91,$8D,$9B,$AE,$C3,$B2,$7C,$63,$76,$A0,$C7,$AB,$7F,$6C,$52,$5B,$7D,$8A,$8D,$78,$66,$62,$60,$6B,$7D,$7B,$80,$78,$72,$77,$47,$2D,$41,$5F,$88,$82,$5A,$5B,$63,$75,$83; 8896
		dc.b $65,$71,$96,$98,$9B,$77,$3A,$3E,$6F,$9F,$B9,$8B,$42,$16,$1B,$6D,$C0,$C5,$78,$11, $A,$71,$CD,$E5,$A5,$4C,$36,$51,$7E,$BC,$A8,$65,$44,$2D,$38,$67,$8B,$A7,$A5,$84,$65,$51,$67,$B7,$F0,$DB,$93,$61,$6E,$92,$A5,$99,$77,$50,$3A,$59,$90,$A3,$8E,$71,$5A,$5C,$8A,$D5; 8960
		dc.b $EC,$B5,$6F,$5D,$70,$81,$9A,$C3,$BC,$79,$3E,$2B,$34,$71,$B5,$BB,$9B,$65,$4F,$7D,$A0,$C1,$D9,$B4,$92,$97,$9D,$8F,$70,$7C,$93,$78,$77,$91,$6E,$4E,$62,$92,$A7,$88,$75,$86,$8B,$9E,$B5,$AB,$88,$68,$61,$86,$AA,$A5,$83,$60,$60,$7A,$87,$8E,$90,$94,$9A,$8C,$7D,$8C; 9024
		dc.b $A3,$BE,$BB,$98,$88,$8A,$AF,$CD,$BF,$A4,$82,$61,$6E,$95,$B0,$B1,$90,$5B,$36,$4D,$83,$B3,$BB,$A5,$90,$64,$3C,$47,$80,$A0,$9D,$97,$6F,$39,$34,$59,$87,$9B,$80,$68,$4E,$45,$6D,$86,$7C,$75,$7B,$83,$7D,$7C,$87,$66,$50,$7E,$96,$89,$77,$65,$69,$6B,$67,$80,$8A,$6C; 9088
		dc.b $61,$6F,$7D,$8F,$84,$6B,$78,$8C,$83,$72,$73,$89,$90,$7B,$69,$66,$6B,$7B,$84,$84,$7A,$6B,$6F,$7B,$7E,$76,$6B,$71,$81,$80,$78,$76,$72,$77,$7B,$7A,$86,$8C,$7C,$6D,$72,$81,$82,$67,$60,$8C,$AB,$93,$78,$6F,$6A,$71,$7E,$90,$A1,$90,$6F,$67,$6E,$7D,$88,$7A,$78,$91; 9152
		dc.b $A1,$8F,$6D,$62,$6D,$7C,$9D,$B5,$95,$61,$4C,$64,$90,$A8,$A3,$8B,$61,$4F,$6F,$96,$AC,$AA,$8A,$74,$75,$71,$79,$97,$A9,$9D,$71,$4F,$56,$6F,$8E,$A6,$95,$74,$5C,$5A,$74,$8E,$99,$95,$8D,$91,$8E,$81,$88,$99,$9F,$9E,$95,$96,$90,$7F,$7B,$8D,$A1,$AA,$9A,$80,$82,$8F; 9216
		dc.b $9C,$AA,$BB,$B5,$97,$8C,$98,$A2,$AB,$AB,$A0,$8A,$6D,$66,$75,$85,$94,$89,$65,$50,$5F,$80,$94,$96,$84,$51,$29,$46,$86,$98,$78,$53,$42,$41,$51,$7D,$A0,$8F,$64,$48,$46,$5F,$74,$7C,$84,$7D,$71,$6A,$72,$8E,$A3,$A1,$94,$86,$8C,$A2,$A2,$9D,$96,$8C,$8F,$91,$8A,$79; 9280
		dc.b $69,$73,$89,$89,$83,$7A,$67,$62,$6C,$82,$90,$7C,$5E,$49,$45,$5F,$74,$74,$6E,$64,$5A,$57,$61,$76,$7E,$71,$62,$5E,$65,$72,$7D,$87,$83,$77,$71,$6E,$85,$A9,$B2,$97,$7B,$79,$83,$93,$B0,$BC,$99,$6C,$66,$7F,$9A,$AF,$B5,$9E,$71,$5B,$76,$96,$A4,$9F,$83,$6D,$67,$67; 9344
		dc.b $6E,$7A,$84,$81,$6A,$5A,$5E,$6D,$7D,$76,$60,$61,$70,$79,$79,$6F,$6C,$75,$83,$92,$90,$83,$7C,$76,$7A,$8C,$9A,$96,$81,$70,$77,$90,$A8,$B1,$9C,$86,$84,$8B,$9F,$B8,$C0,$AF,$97,$8C,$95,$A8,$AE,$9F,$8E,$80,$77,$80,$91,$99,$95,$7F,$67,$67,$85,$9C,$9A,$92,$84,$71; 9408
		dc.b $70,$88,$A1,$9D,$7D,$68,$63,$66,$72,$85,$8B,$7C,$71,$6E,$74,$7D,$7F,$7D,$81,$83,$82,$7B,$74,$7D,$89,$90,$92,$8E,$8D,$89,$7F,$7D,$82,$8D,$97,$91,$81,$72,$69,$76,$88,$8D,$89,$7F,$75,$72,$78,$87,$91,$8A,$7B,$6E,$66,$70,$7A,$77,$74,$72,$6C,$66,$69,$73,$71,$6A; 9472
		dc.b $68,$6B,$73,$78,$77,$77,$71,$6F,$76,$79,$83,$8E,$8A,$77,$6E,$73,$78,$7F,$8B,$88,$6D,$5A,$65,$7B,$87,$85,$7D,$6F,$65,$6C,$7F,$8B,$8E,$88,$7B,$76,$76,$7A,$7F,$81,$83,$7F,$72,$6C,$72,$7C,$80,$77,$74,$7E,$87,$84,$7B,$71,$6F,$74,$7C,$85,$84,$7C,$71,$6C,$74,$81; 9536
		dc.b $85,$81,$75,$6E,$76,$83,$8E,$8C,$7F,$7A,$7B,$7C,$83,$8E,$91,$88,$7D,$7D,$87,$8F,$93,$91,$8E,$85,$81,$87,$8C,$8D,$88,$76,$67,$70,$82,$8D,$92,$92,$89,$7F,$87,$9E,$A9,$A1,$91,$87,$85,$89,$95,$9D,$9B,$8E,$81,$7C,$84,$92,$96,$94,$8E,$85,$81,$84,$94,$A5,$A2,$90; 9600
		dc.b $85,$8A,$96,$9C,$97,$8D,$83,$80,$8A,$94,$92,$87,$7B,$7A,$7C,$80,$88,$86,$7C,$79,$7F,$87,$86,$80,$7B,$7D,$87,$8C,$88,$82,$7C,$7B,$7B,$7C,$80,$83,$7F,$78,$75,$79,$81,$86,$88,$83,$7A,$78,$7B,$83,$8D,$88,$7A,$7B,$7F,$80,$7F,$83,$86,$7A,$6C,$71,$79,$77,$74,$71; 9664
		dc.b $6D,$6A,$68,$6E,$71,$6E,$6F,$74,$7A,$78,$76,$7A,$7E,$82,$7F,$7A,$79,$75,$73,$7C,$80,$7C,$7A,$77,$71,$6D,$71,$7D,$82,$7C,$73,$71,$7A,$7C,$75,$77,$7B,$7A,$72,$6E,$73,$73,$75,$79,$76,$70,$71,$75,$70,$62,$5F,$67,$6D,$6E,$6D,$6F,$73,$71,$70,$77,$7F,$84,$85,$86; 9728
		dc.b $87,$83,$7D,$7A,$7B,$81,$89,$8F,$92,$83,$6B,$6C,$80,$90,$95,$8C,$83,$7D,$7E,$88,$8E,$8B,$8F,$8F,$88,$86,$88,$8A,$84,$78,$76,$7A,$7F,$81,$81,$81,$7B,$72,$74,$7B,$80,$87,$86,$7D,$7E,$82,$8A,$91,$8F,$8E,$90,$8D,$90,$94,$93,$98,$9B,$99,$95,$87,$85,$93,$98,$9A; 9792
		dc.b $99,$92,$90,$92,$92,$95,$99,$9A,$93,$89,$8F,$9E,$A3,$96,$80,$76,$76,$78,$81,$84,$7E,$78,$6B,$63,$71,$82,$8B,$90,$86,$75,$73,$7D,$89,$90,$90,$92,$8B,$7B,$72,$79,$8D,$98,$8D,$7C,$75,$7D,$8D,$94,$91,$8B,$85,$86,$8F,$93,$90,$94,$97,$8E,$87,$8E,$97,$95,$81,$69; 9856
		dc.b $5F,$65,$6D,$6C,$6D,$70,$6C,$69,$69,$67,$6C,$73,$75,$70,$6F,$76,$82,$82,$7A,$74,$74,$7B,$7C,$78,$7D,$82,$84,$7A,$6C,$6A,$75,$82,$89,$86,$81,$7D,$7D,$85,$82,$81,$8B,$8A,$8A,$90,$8B,$85,$7E,$66,$5C,$5C,$58,$63,$73,$5E,$48,$53,$65,$74,$7B,$7C,$78,$6A,$5E,$59; 9920
		dc.b $67,$7B,$85,$7C,$7C,$88,$8D,$87,$7A,$7E,$6B,$69,$7B,$81,$8A,$94,$8D,$7F,$80,$8B,$93,$93,$94,$95,$96,$93,$8E,$8A,$81,$7A,$6C,$62,$6F,$65,$54,$54,$63,$70,$75,$70,$65,$6F,$78,$79,$7E,$86,$88,$8F,$A8,$AB,$AE,$9D,$8C,$98,$9F,$9C,$9E,$93,$90,$82,$70,$8A,$94,$89; 9984
		dc.b $8A,$8E,$96,$A9,$AE,$A4,$99,$99,$AB,$AD,$9C,$A9,$B2,$A6,$8F,$6D,$62,$72,$7B,$7A,$71,$75,$7D,$6F,$68,$72,$88,$91,$86,$62,$51,$74,$95,$9A,$97,$92,$7E,$6D,$78,$8B,$85,$6D,$5F,$51,$49,$55,$68,$74,$6C,$58,$5C,$7D,$8E,$91,$87,$7B,$8A,$A5,$B1,$A2,$83,$71,$6C,$67; 10048
		dc.b $68,$6A,$68,$58,$40,$46,$6E,$80,$94,$9A,$85,$80,$83,$8D,$8F,$8C,$A5,$B3,$A3,$9C,$9E,$89,$7B,$7F,$7E,$78,$88,$92,$77,$67,$6B,$72,$79,$7F,$98,$B6,$B2,$A9,$A8,$A4,$B5,$CC,$CC,$BD,$A8,$90,$8F,$8C,$7F,$76,$65,$57,$5F,$73,$87,$8C,$7F,$7F,$8D,$9B,$AB,$AE,$98,$84; 10112
		dc.b $8B,$A0,$B8,$BE,$96,$92,$85,$55,$48,$60,$74,$6E,$45,$35,$5F,$5E,$33,$45,$59,$83,$7E,$54,$59,$81,$8C,$8C,$70,$62,$72,$75,$5E,$42,$46,$26,  8,$2E,$35,$19,$13,$13,$24,$3F,$52,$86,$8D,$6F,$5D,$77,$95,$B8,$DB,$D5,$C1,$D2,$D0,$9D,$95,$98,$79,$6A,$68,$7E,$8D,$78; 10176
		dc.b $5C,$52,$4C,$65,$9F,$C7,$CC,$B2,$81,$72,$92,$AC,$AA,$8A,$71,$5C,$47,$3D,$4A,$57,$48,$44,$58,$65,$71,$7A,$82,$88,$96,$A2,$A1,$A9,$BA,$CD,$DF,$E0,$D4,$CD,$CA,$B2,$8A,$5A,$55,$86,$C0,$C9,$A7,$8C,$7F,$73,$8A,$C8,$E0,$CF,$BE,$B6,$B1,$A6,$85,$56,$4F,$6B,$8A,$A1; 10240
		dc.b $83,$34,  0,  0,$25,$6C,$91,$7A,$4F,$3A,$5D,$9A,$BD,$AC,$7B,$61,$71,$A9,$E0,$F8,$E4,$9B,$5E,$55,$7A,$9B,$8B,$73,$6E,$57,$48,$70,$8D,$89,$94,$BB,$E3,$F6,$FC,$F5,$CF,$9E,$90,$A1,$B5,$BE,$A5,$8C,$6D,$48,$35,$32,$44,$6E,$70,$59,$60,$71,$82,$84,$6D,$68,$98,$C3; 10304
		dc.b $C9,$C8,$B4,$94,$94,$9D,$92,$8E,$6D,$41,$35,$2A,$44,$46,  0,  0,  0,$24,$72,$AF,$91,$56,$42,$58,$8D,$9B,$8A,$84,$74,$6B,$7D,$7A,$60,$2D,  0,  0,  0,$36,$4E,$47,$1A,  8,$26,$47,$62,$7D,$96,$AB,$A8,$A8,$C2,$CB,$AF,$A8,$BB,$C6,$B5,$8F,$74,$5E,$5B,$69,$63,$4F; 10368
		dc.b $53,$78,$A4,$CA,$DA,$CE,$B7,$B2,$D1,$E6,$CE,$9C,$75,$74,$7D,$8B,$B7,$AB,$5A,$30,$33,$4D,$70,$6A,$42,$46,$66,$8A,$A2,$83,$68,$7E,$7F,$6F,$75,$8E,$82,$72,$9E,$C4,$B5,$95,$73,$55,$50,$6B,$9B,$A7,$7D,$6B,$87,$9E,$BF,$BC,$89,$8A,$93,$8B,$9B,$8C,$5A,$50,$62,$65; 10432
		dc.b $68,$76,$75,$58,$4C,$5A,$65,$73,$80,$83,$A4,$CA,$BD,$B8,$BC,$B1,$B1,$BA,$C5,$C8,$B0,$AB,$D0,$E1,$DC,$C2,$9E,$99,$A8,$AE,$A2,$7A,$85,$CE,$F7,$FF,$FF,$FF,$EC,$D5,$D2,$D7,$BE,$A5,$98,$91,$AD,$C8,$98,$60,$5E,$53,$40,$3C,$52,$77,$76,$72,$A7,$B0,$8C,$95,$97,$8B; 10496
		dc.b $9D,$AD,$9C,$81,$5D,$4A,$64,$71,$5F,$47,$41,$4C,$32,  1,  0,  0,  7,$2C,$24,$1F,$43,$5F,$5B,$47,$49,$5A,$4D,$36,$33,$31,$3A,$5E,$6A,$54,$3F,$3C,$30,$10, $B,$25,$49,$62,$5E,$4D,$5B,$6E,$5A,$4E,$5E,$7C,$A0,$B6,$AB,$99,$92,$92,$9F,$A3,$8D,$70,$70,$7A,$6C,$39; 10560
		dc.b $21,$41,$38,$1D,$38,$7F,$B9,$A1,$62,$57,$7A,$9F,$A1,$94,$A8,$B2,$D7,$F4,$BA,$82,$60,$3F,$47,$4E,$63,$96,$95,$5A,$43,$53,$57,$56,$4B,$52,$7B,$A2,$AC,$9C,$9B,$B8,$BD,$B3,$BB,$D6,$FB,$F8,$C7,$8D,$70,$74,$6D,$58,$53,$72,$9F,$A7,$70,$46,$4C,$4D,$58,$83,$A8,$B2; 10624
		dc.b $93,$7D,$B1,$D8,$C9,$C7,$AE,$86,$98,$BE,$C2,$A1,$6F,$58,$5A,$62,$74,$57,$37,$4E,$61,$7A,$94,$A5,$CB,$EE,$FB,$FF,$FF,$EA,$C7,$CD,$D3,$C2,$C2,$C6,$B4,$AD,$C0,$B4,$8E,$69,$62,$A9,$EA,$E0,$CE,$AA,$9B,$C6,$DC,$C9,$9F,$80,$90,$9C,$8D,$8C,$87,$7C,$76,$76,$81,$79; 10688
		dc.b $60,$56,$69,$91,$C3,$CE,$A6,$9D,$D1,$FE,$FB,$E7,$D3,$CB,$BF,$81,$37,$18,$2F,$55,$6A,$75,$7E,$60,$46,$4A,$3E,$2D,$39,$48,$64,$87,$76,$5D,$64,$4A,$25,$2D,$47,$50,$38,$2D,$52,$74,$82,$6A,$3C,$19,  0,$12,$43,$4F,$66,$58,$3B,$4F,$77,$91,$95,$98,$A0,$A2,$9D,$8A; 10752
		dc.b $5B,$2E,$16,$17,$33,$3E,$2C,$33,$3E,$2E,$2F,$40,$59,$6C,$64,$6D,$7F,$85,$89,$81,$63,$56,$72,$8B,$92,$79,$49,$3C,$55,$60,$53,$53,$51,$39,$2D,$54,$87,$98,$98,$9C,$B1,$E2,$FC,$E3,$B8,$89,$7D,$7B,$74,$61,$22,  0,  0,  0,  0,  0,  0,$23,$6B,$A8,$A3,$8F,$90,$90; 10816
		dc.b $B1,$C2,$B6,$B6,$92,$7B,$92,$95,$95,$6D,$1F,$1F,$52,$6A,$6D,$44,$20,$3C,$59,$5F,$5B,$4E,$69,$A6,$D2,$EA,$F7,$F3,$E6,$D3,$D0,$DD,$D4,$B6,$97,$8F,$9C,$8A,$5B,$4E,$64,$9B,$DD,$FE,$FF,$EC,$E7,$EE,$DB,$C4,$9D,$82,$A2,$DC,$FF,$FF,$E0,$DC,$D0,$B0,$AC,$A1,$8F,$99; 10880
		dc.b $B2,$C3,$AC,$84,$6A,$60,$6A,$94,$C3,$E7,$FF,$EF,$EF,$FA,$E1,$C9,$A8,$8A,$7A,$7D,$A7,$B0,$73,$40,$23,$37,$78,$86,$A5,$D8,$C0,$B7,$D1,$BD,$85,$53,$4C,$79,$B7,$C8,$AC,$88,$5E,$3F,$40,$4B,$31,$18,$2C,$45,$53,$38,  0,  0,$2A,$63,$BA,$E4,$D6,$E2,$E5,$E9,$E9,$C0; 10944
		dc.b $9C,$9B,$94,$7C,$6B,$3A, $A,  8,$13,$2F,$54,$70,$7F,$8F,$97,$81,$64,$57,$47,$41,$72,$94,$91,$7F,$6A,$73,$81,$87,$73,$5E,$62,$68,$86,$A0,$79,$39,$11,$29,$61,$7D,$AD,$C7,$CA,$E7,$C5,$90,$84,$4E,$3A,$75,$7F,$59,$5A,$66,$3E,$14,  0,  0,$30,$5C,$70,$8D,$A7,$99; 11008
		dc.b $66,$59,$38, $A,$18,$3D,$58,$50,$3C,$57,$56,$31,$3C,$48,$36,$22,$1E,$50,$7E,$5D, $B,  0,$20,$48,$78,$9F,$C5,$CE,$CD,$C2,$A1,$87,$5B,$3E,$5A,$76,$80,$6C,$2F,  0,  0,  0,$17,$31,$53,$7F,$B6,$E3,$AC,$6E,$75,$8D,$AB,$CA,$DC,$D1,$C0,$C6,$C2,$A8,$A8,$A5,$8E,$8D; 11072
		dc.b $80,$75,$78,$47,$26,$48,$67,$81,$B4,$DC,$FF,$FF,$FF,$FF,$E1,$E0,$DF,$E2,$F0,$D4,$AD,$A0,$80,$5E,$42,$2A,$4B,$73,$91,$C9,$F7,$FF,$FA,$D1,$CC,$CD,$B7,$A6,$B8,$B4,$A9,$BE,$BB,$A1,$A3,$9C,$69,$47,$47,$5E,$7F,$6F,$3A,$31,$57,$7F,$9E,$AD,$C5,$EB,$FC,$F4,$CD,$A1; 11136
		dc.b $99,$93,$8E,$7B,$4F,$3F,$3D,$38,$2A,$11,$2B,$44,$56,$99,$C6,$D5,$CF,$B0,$AE,$A4,$76,$55,$63,$7C,$A7,$D3,$AB,$74,$70,$8F,$87,$64,$5D,$52,$74,$9A,$75,$5C,$4E,$4B,$79,$A4,$CC,$FF,$FF,$E0,$B9,$BC,$DB,$F1,$DB,$AB,$A0,$B0,$C2,$9F,$40,  0,  0,$51,$A9,$C4,$C0,$CF; 11200
		dc.b $BD,$8E,$83,$5C,$35,$2C,$3E,$84,$A4,$97,$80,$5F,$57,$68,$46,$11, $B,$13,$52,$82,$63,$4C,$2C,$23,$58,$7B,$9A,$C5,$E2,$DD,$CC,$A9,$7F,$54,$2F,$33,$4D,$46,$30,  1,  0,  0,  0,  0,  0,$36,$5B,$A3,$D5,$A2,$6A,$5B,$54,$58,$62,$83,$9D,$A2,$8B,$59,$34,$32, $D,  0; 11264
		dc.b   0,  0,$1F,$56,$58,$42,$1F,$47,$8D,$B0,$D9,$D8,$C3,$D8,$DD,$E3,$CF,$88,$77,$9A,$A2,$96,$6C,$14,  0,  0,$38,$5A,$5F,$74,$97,$D4,$FF,$D2,$71,$59,$76,$9A,$C5,$C8,$BF,$C3,$AB,$AF,$BA,$AC,$A3,$7F,$6C,$9D,$C9,$AF,$6D,$41,$44,$87,$C7,$A7,$8D,$AE,$D3,$E9,$C1,$85; 11328
		dc.b $92,$A5,$B7,$E7,$E0,$A4,$7A,$6B,$45,$2C,$37,$40,$4F,$75,$A1,$D6,$FD,$B9,$66,$61,$7B,$90,$94,$9E,$BF,$D2,$EA,$FB,$C7,$93,$66,$23, $E,$19,$56,$90,$5C,$37,$4C,$59,$70,$8E,$9D,$A9,$DF,$FF,$FF,$F6,$C7,$B6,$C9,$C9,$A8,$7D,$45,$1B,$1D,$2C,$25,$2A,$3F,$52,$93,$CA; 11392
		dc.b $D8,$BF,$A4,$AD,$C4,$CA,$B2,$BA,$CB,$B1,$B3,$CD,$A5,$87,$8F,$6E,$40,$34,$2F,$50,$6F,$7E,$94,$A2,$BE,$BC,$C9,$F1,$FF,$FF,$FD,$E3,$E6,$D3,$B3,$98,$69,$47,$50,$76,$7A,$41,$1D,$2A,$57,$A5,$D9,$D3,$CF,$AD,$80,$75,$40,$2B,$61,$7C,$86,$79,$6F,$84,$7B,$5C,$38,$16; 11456
		dc.b   2,$1C,$46,$48,$36,$3F,$46,$24, $D,$1F,$3E,$74,$9A,$B9,$D4,$CB,$CD,$AF,$6C,$57,$66,$7C,$79,$48,$17,  7,  0,  0,  0,  0,$1B,$4F,$4F,$45,$14,  6,$32,$58,$6C,$AA,$DA,$DF,$DC,$C4,$C0,$BB,$8F,$58,$2C,$1F,$42,$5E,$44,$1E,  0,  0,$12,$36,$73,$A4,$A4,$A2,$C5,$E5; 11520
		dc.b $FF,$FF,$E5,$BC,$B3,$9B,$79,$45,$11,$10,$3F,$51,$4C,$57,$82,$B7,$AA,$6A,$53,$63,$80,$9C,$B0,$D5,$EB,$E4,$E4,$C8,$83,$58,$41,$2B,$2E,$45,$87,$C2,$98,$61,$5D,$61,$6F,$7F,$8C,$B0,$CF,$C9,$C0,$B7,$BC,$C0,$AB,$78,$44,$4F,$4B,$49,$49,$1E,$25,$67,$7C,$7B,$9B,$C1; 11584
		dc.b $CD,$93,$4F,$49,$6F,$9C,$AA,$B3,$C9,$CD,$DD,$FA,$E1,$A4,$74,$54,$5C,$51,$41,$87,$B8,$A0,$8F,$80,$5D,$38,$21,$25,$57,$9A,$CE,$F6,$FF,$FF,$FF,$FF,$EB,$92,$74,$8B,$A6,$B0,$7F,$57,$68,$87,$9C,$85,$5C,$35,$23,$54,$81,$8B,$8B,$9B,$D6,$FF,$FF,$FF,$FF,$FF,$DB,$A1; 11648
		dc.b $6D,$4E,$4D,$5D,$8B,$9E,$6C,$5E,$5A,$3E,$2B,$38,$49,$61,$AD,$FD,$FF,$FF,$FF,$E8,$C9,$A2,$72,$6B,$69,$57,$55,$55,$4B,$58,$7A,$94,$97,$79,$46,$30,$3E,$41,$4D,$5E,$7A,$C5,$F0,$D9,$B1,$7B,$3F,  9,  9,$30,$21,$30,$75,$9C,$A3,$76,$48,$21,  0,  0,$19,$3F,$6A,$A2; 11712
		dc.b $E4,$FF,$E6,$A6,$7B,$67,$50,$35,$54,$64,$4A,$56,$56,$51,$6B,$65,$62,$71,$45,  9,  0,  4,  5,  0,$2B,$62,$91,$C4,$EF,$F7,$D1,$A6,$79,$72,$9C,$A6,$94,$A7,$9F,$7D,$88,$7C,$36,  0,  0,  4,$37,$6B,$9D,$EB,$FF,$FF,$F7,$CC,$90,$3F,$13,$30,$49,$67,$93,$B8,$C0,$85; 11776
		dc.b $50,$48,$26,  0, $C,$49,$76,$89,$6C,$6A,$C2,$D8,$BE,$AC,$7F,$7F,$B9,$CE,$A2,$59,$2C,$60,$94,$76,$25,  2,$45,$62,$35,$30,$42,$65,$B0,$F2,$FF,$FF,$DE,$D3,$B8,$6E,$23,$1A,$2B,$16,$1A,$3E,$73,$9E,$7A,$47,$66,$83,$5D,$3C,$3B,$59,$8B,$A1,$A4,$B9,$E1,$FF,$FF,$D0; 11840
		dc.b $AD,$97,$B1,$C0,$96,$77,$96,$CA,$C0,$67,$2F,$1A,  0,  0,$2E,$64,$A6,$FF,$FF,$FF,$FF,$D8,$8D,$8C,$92,$9C,$CF,$FB,$E4,$DF,$D3,$8C,$6F,$60,$47,$5A,$94,$9B,$7F,$6E,$59,$49,$3E,$3D,$6A,$9C,$C9,$F9,$FF,$FF,$E9,$B2,$A5,$9B,$87,$94,$C0,$C4,$84,$4E,$3F,  0,  0,$20; 11904
		dc.b $45,$6A,$BC,$F5,$FF,$FF,$FF,$C5,$92,$3F, $E,$41,$82,$A8,$CB,$B2,$A3,$AE,$7B,$39,$13,$14,$55,$96,$A8,$AC,$B5,$91,$42,$29,$16, $F,$44,$8E,$C1,$DE,$EE,$CA,$71,$27,$12,$17,  7,  0,$48,$90,$86,$57,$3C,$60,$8C,$AD,$B9,$AC,$D7,$FF,$FF,$C9,$6E,$1A,$30,$63,$54,$26; 11968
		dc.b $1E,$54,$89,$8A,$6D,$4A,$1F, $A,$16,$37,$65,$91,$7C,$4F,$61,$7A,$83,$8D,$82,$97,$D2,$FC,$FF,$F0,$C2,$A3,$96,$63,  6,  0,  0,$2E,$51,$67,$85,$AA,$CE,$DA,$D4,$BD,$95,$A4,$DC,$B7,$7D,$9A,$A1,$68,$33,  7,  0,$23,$48,$66,$84,$A4,$B4,$A1,$5C,$31,$18,  0, $E,$4B; 12032
		dc.b $8A,$CE,$FF,$FC,$B4,$9D,$A4,$A0,$87,$5C,$6A,$9D,$96,$65,$30,  2,  0,  4,$2C,$5E,$98,$D4,$EF,$F3,$E3,$AE,$93,$82,$59,$43,$60,$86,$7D,$5D,$3F,$3D,$3C,$29,$1C,$3F,$5F,$87,$C2,$B5,$90,$6D,$4D,$3E,$32,$53,$A4,$F5,$FF,$FF,$FF,$FF,$DC,$97,$56,$35,$4B,$73,$85,$86; 12096
		dc.b $72,$30,  0,$18,$4C,$6A,$8C,$BE,$FF,$FF,$FF,$FF,$E6,$89,$51,$70,$89,$68,$61,$A6,$F3,$EC,$AA,$60,$44,$75,$8F,$59,$46,$61,$7A,$8C,$7B,$4A,$3C,$74,$C0,$D2,$DB,$E7,$E1,$E1,$AA,$6D,$75,$83,$57,$3F,$58,$63,$4F,$4B,$55,$7A,$A9,$A0,$92,$A6,$BB,$E9,$E6,$B5,$86,$54; 12160
		dc.b $4C,$75,$66,$27,$2B,$75,$BA,$AF,$94,$82,$75,$86,$75,$59,$62,$5F,$66,$70,$54,$5D,$87,$9D,$9F,$82,$68,$6C,$78,$6E,$53,$59,$87,$7F,$51,$25, $E,$18,$22,$3A,$72,$AD,$D9,$FF,$FF,$E5,$CC,$C9,$9A,$59,$47,$65,$97,$A2,$68,$38,$41,$4D,$52,$46,$13,$14,$3A,$47,$68,$6D; 12224
		dc.b $48,$55,$60,$68,$97,$C1,$E6,$F5,$E1,$FC,$FF,$D4,$A6,$7F,$89,$8C,$68,$5E,$44,$17,$1E,$25,$24,$56,$9D,$CE,$FB,$FF,$FF,$FC,$DD,$9C,$58,$52,$7D,$97,$9A,$75,$6F,$9F,$90,$51,$33,$1D,$1A,$4A,$6B,$8C,$9B,$85,$8A,$7C,$54,$57,$79,$93,$A5,$AE,$AC,$DB,$FD,$D9,$B2,$85; 12288
		dc.b $4D,$3F,$61,$4B, $C, $C,$41,$9D,$D7,$C4,$AC,$BE,$C9,$BB,$95,$60,$3D,$39,$60,$5C,$43,$47,$51,$52,$64,$62,$5C,$6E,$60,$79,$7F,$64,$7E,$82,$63,$62,$65,$5D,$67,$82,$9C,$B6,$DA,$FC,$FF,$E5,$B1,$9F,$9C,$60,$2E,$27,$14,$21,$40,$48,$63,$9E,$D7,$F6,$EC,$BC,$B8,$C6; 12352
		dc.b $98,$59,$4B,$7F,$C6,$F1,$E1,$AC,$8D,$73,$51,$4A,$26,  4,$2E,$72,$9B,$A7,$92,$6B,$46,$30,$3B,$6B,$92,$BC,$FF,$FF,$FF,$F7,$BB,$7D,$5B,$54,$37,$1F,$2A,$36,$3B,$4C,$57,$7C,$AC,$B7,$D1,$E9,$CC,$BD,$BE,$92,$67,$59,$55,$62,$74,$6F,$55,$48,$49,$49,$6B,$6A,$52,$68; 12416
		dc.b $8A,$BB,$D9,$A5,$69,$4F,$32,$20,$3F,$59,$89,$C5,$C1,$BF,$BB,$80,$4C,$34, $B,  0,  0,$15,$43,$70,$85,$96,$C3,$D8,$C9,$BA,$A7,$93,$8B,$91,$7E,$71,$82,$91,$9E,$8C,$4D,$32,$56,$69,$4F,$60,$57,$54,$86,$7F,$4B,$36,$24,$29,$4E,$39,$43,$7F,$B2,$E5,$F6,$FB,$FF,$FF; 12480
		dc.b $EE,$AD,$97,$7E,$46,$51,$75,$4A,$49,$5A,$52,$73,$87,$7D,$A2,$C7,$C1,$C9,$DF,$CD,$B8,$C8,$C7,$9A,$6B,$63,$6E,$67,$58,$62,$8E,$93,$86,$85,$80,$7E,$5C,$27,$29,$35,$2D,$57,$A8,$E3,$FF,$FF,$FF,$F2,$C0,$6A,$5B,$7E,$4F,$2C,$4A,$5F,$6C,$80,$72,$7C,$AC,$C5,$E2,$FF; 12544
		dc.b $EF,$D0,$CE,$B4,$83,$49,$21,$29,$29,$13, $F,$24,$2B,$2D,$58,$78,$7B,$92,$AF,$AC,$93,$5E,$2B,$4D,$70,$5C,$80,$C5,$D8,$CF,$C6,$A3,$81,$7F,$6B,$69,$88,$68,$5A,$87,$8D,$63,$44,$3F,$52,$82,$9A,$AC,$CF,$EE,$FF,$FF,$B9,$7D,$69,$5D,$61,$53,$51,$7C,$9D,$A5,$B0,$B2; 12608
		dc.b $95,$78,$65,$5C,$5D,$52,$2F,$2E,$4F,$39,$3C,$5E,$85,$C2,$F3,$FF,$FF,$EF,$CF,$CB,$B5,$8B,$61,$4B,$6A,$7C,$5E,$39,$25,$44,$7E,$8F,$9E,$BE,$CF,$F4,$EE,$A7,$7D,$66,$41,$32,$35,$42,$80,$C2,$C3,$A9,$A6,$7E,$45,$36,$3B,$41,$5A,$69,$8F,$B4,$B2,$AB,$97,$68,$51,$55; 12672
		dc.b $59,$65,$5F,$4D,$75,$88,$55,$37,$14,$10,$2C,$28,$2F,$6C,$A8,$C8,$DD,$C3,$B3,$D2,$CF,$81,$57,$66,$69,$5C,$24,  0,  0,$29,$4D,$34,$3D,$88,$B7,$C4,$93,$28,$28,$55,$37,$28,$38,$61,$B2,$C0,$90,$7D,$68,$7D,$B6,$9D,$8D,$CF,$D9,$CA,$AF,$66,$1D,  0, $E,$1F,$50,$9B; 12736
		dc.b $CD,$EE,$F4,$C3,$A2,$8B,$51,$3F,$56,$63,$87,$A7,$B3,$C6,$BB,$98,$99,$8C,$6F,$7B,$76,$62,$60,$54,$5D,$71,$63,$60,$7B,$97,$A4,$B7,$D4,$C5,$BD,$CB,$A6,$92,$8D,$82,$A2,$BA,$8F,$72,$7A,$74,$73,$92,$A9,$C4,$EE,$EF,$FF,$FF,$D9,$9C,$76,$39,$15,$19,$25,$3A,$6B,$81; 12800
		dc.b $88,$8F,$64,$4A,$61,$67,$4E,$5D,$87,$98,$9B,$88,$6B,$67,$68,$62,$82,$A3,$9E,$AA,$BB,$A9,$95,$90,$75,$55,$3A,$2E,$47,$5A,$5E,$77,$98,$CB,$ED,$D6,$C4,$BE,$9C,$78,$6C,$4E,$3C,$62,$69,$65,$8B,$A3,$B7,$C9,$AE,$94,$8E,$6D,$3E,$20,$13,$1C,$49,$75,$7B,$82,$93,$91; 12864
		dc.b $99,$A0,$7F,$6E,$A7,$DB,$E0,$CB,$B6,$BC,$BE,$9E,$6B,$3E,$45,$91,$C8,$BE,$B5,$C9,$EA,$E7,$B3,$6F,$54,$72,$6F,$4C,$4A,$43,$4A,$7E,$96,$97,$9A,$A0,$9C,$98,$8F,$76,$89,$B5,$C6,$C1,$BB,$B6,$AD,$99,$6E,$36,$21,$3B,$5F,$78,$78,$6D,$71,$7A,$61,$2A,$16,$22,$32,$5D; 12928
		dc.b $8D,$AC,$D4,$FF,$FF,$F1,$C6,$8D,$54,$51,$50,$1A,  9,$18,$1C,$47,$59,$47,$52,$5E,$6A,$73,$5E,$43,$3A,$45,$45,$40,$47,$6D,$80,$7A,$6C,$53,$51,$67,$90,$A0,$A5,$BA,$C6,$C3,$AC,$83,$4C,$2E,$1E,$14,$25,$44,$75,$9E,$B7,$B4,$8D,$62,$3F,$45,$6F,$81,$75,$85,$AA,$C1; 12992
		dc.b $AD,$92,$6E,$58,$69,$6C,$6A,$64,$6D,$8F,$9C,$7B,$5A,$58,$71,$71,$55,$60,$88,$98,$95,$AC,$D6,$E6,$CF,$CA,$C8,$A0,$7B,$54,$53,$76,$79,$98,$CD,$EA,$FF,$FF,$FF,$F5,$C3,$A3,$94,$68,$39,$2C,$2F,$3A,$43,$4A,$62,$74,$7F,$7F,$86,$97,$9E,$9D,$B6,$CD,$B3,$A2,$B7,$A0; 13056
		dc.b $7A,$65,$50,$69,$7E,$78,$87,$95,$73,$58,$65,$4E,$3F,$67,$75,$98,$B7,$B5,$C7,$D8,$DC,$C1,$9E,$86,$71,$4D,$41,$41,$3D,$4C,$68,$78,$78,$82,$76,$72,$70,$56,$5F,$7E,$71,$63,$7C,$8E,$81,$63,$33,$23,$42,$40,$3B,$59,$62,$6F,$85,$97,$B3,$A2,$90,$B5,$C8,$AF,$94,$82; 13120
		dc.b $7F,$83,$86,$7B,$7F,$B6,$D3,$CF,$A8,$62,$5E,$97,$9F,$6F,$4B,$5B,$8A,$98,$7B,$50,$40,$6C,$8C,$7F,$82,$6F,$6F,$AE,$C2,$9C,$A1,$BF,$CF,$DD,$CB,$AE,$AA,$A5,$91,$7E,$6B,$43,$34,$2D,$14,$19,$2A,$48,$7F,$9B,$AE,$CD,$E3,$F6,$F5,$CD,$A7,$9E,$99,$A8,$B3,$84,$70,$87; 13184
		dc.b $6D,$4E,$35,$26,$2F,$25,$28,$2D,$3C,$66,$75,$75,$8B,$92,$9B,$AE,$A9,$8D,$73,$66,$5A,$44,$35,$3B,$71,$A9,$A3,$9B,$9E,$9C,$B1,$A5,$89,$84,$6C,$81,$BD,$AD,$80,$81,$74,$59,$41, $E,  2,$35,$42,$38,$59,$80,$97,$9C,$8F,$78,$79,$98,$9F,$98,$91,$8F,$8B,$7D,$4E,$28; 13248
		dc.b $24,$2D,$31,$37,$5A,$93,$A7,$93,$9A,$9D,$8A,$75,$5A,$6D,$8C,$91,$91,$96,$AD,$B7,$CA,$F0,$FF,$FF,$FF,$F0,$CC,$9B,$70,$5A,$52,$5A,$6B,$7C,$87,$80,$75,$57,$31,$1E,$19,$2C,$58,$84,$B8,$D0,$D6,$E4,$DF,$D3,$C7,$AB,$98,$A5,$C5,$CF,$B0,$8A,$73,$6A,$56,$1F,  0,$13; 13312
		dc.b $3F,$57,$6D,$A5,$DB,$FB,$FF,$FF,$EC,$EB,$E0,$C2,$99,$72,$79,$84,$5B,$1F, $B,$36,$62,$62,$5B,$5D,$88,$A5,$82,$70,$76,$8C,$9A,$7C,$68,$60,$54,$65,$59,$24,$4B,$95,$99,$96,$8C,$86,$92,$5F,$1F,$1E,$40,$5C,$7B,$AF,$DE,$FF,$FF,$FF,$DD,$99,$6B,$3D,  8,  0,$15,$49; 13376
		dc.b $6C,$84,$83,$7B,$7B,$6B,$5A,$49,$4F,$70,$7E,$8F,$8C,$68,$76,$75,$49,$57,$78,$8F,$B0,$BC,$C7,$CB,$BA,$93,$69,$61,$5C,$42,$2D,$15,  7,$20,$2B,$2C,$57,$82,$B0,$DE,$E2,$E9,$E6,$CC,$B7,$99,$7A,$84,$A6,$AD,$A1,$78,$45,$3A,$3B,$23,  7,$20,$50,$6B,$6F,$6E,$82,$88; 13440
		dc.b $6F,$5B,$57,$69,$96,$C6,$DB,$CB,$C2,$E5,$D4,$76,$2C,$31,$3B,$37,$4D,$6D,$86,$A2,$CD,$DA,$E4,$F1,$E8,$E9,$E0,$BA,$94,$87,$56,$14, $C,$2E,$3F,$26,$28,$40,$64,$83,$8F,$A1,$B7,$B3,$A5,$AE,$BB,$AA,$85,$7B,$70,$56,$67,$7E,$73,$60,$5D,$61,$6C,$62,$44,$55,$6F,$56; 13504
		dc.b $5E,$88,$8B,$82,$83,$A1,$C7,$C9,$C9,$D1,$DD,$FA,$FF,$EE,$D2,$9B,$7E,$7A,$59,$24,  0,$12,$2C,$45,$6B,$72,$61,$73,$75,$51,$2C,$20,$1F,$29,$60,$9A,$B8,$DF,$FF,$FF,$FF,$EE,$BB,$9B,$80,$7A,$80,$66,$40,$2A,$2F,$33,$16,  6,$2D,$66,$98,$C4,$ED,$FF,$FF,$FF,$FF,$C2; 13568
		dc.b $7F,$6F,$74,$6C,$48,$39,$5C,$6F,$7C,$94,$84,$82,$93,$6B,$52,$67,$5F,$44,$55,$88,$BD,$CA,$BB,$B5,$AA,$8E,$69,$4B,$3F,$4F,$83,$B1,$AD,$9A,$94,$92,$64,$1F,$2E,$75,$A5,$D8,$FF,$FF,$FF,$FF,$E9,$A7,$57,  8,  0,  0,$10,$30,$5D,$91,$BE,$CE,$CB,$A7,$88,$6C,$5C,$6F; 13632
		dc.b $80,$6A,$61,$76,$83,$9B,$9A,$8D,$94,$8F,$8D,$91,$82,$6D,$83,$A7,$9F,$79,$5A,$4B,$32,  0,  0,  0,$2A,$57,$91,$CE,$F8,$FF,$FF,$E5,$A6,$4C,  8,$24,$59,$61,$71,$9B,$B5,$A4,$70,$32,  9,  0,  0, $A,$2B,$3F,$4E,$6C,$7F,$7E,$87,$77,$66,$72,$7B,$90,$C0,$C8,$9B,$AA; 13696
		dc.b $D1,$99,$3F, $E,  5,$10,$29,$49,$6C,$97,$D0,$FF,$FF,$FF,$FB,$D5,$A1,$76,$36,  0, $F,$36,$46,$5B,$65,$77,$94,$77,$5B,$6E,$76,$78,$A3,$C9,$D6,$E1,$D0,$BE,$B3,$8E,$5D,$4C,$45,$57,$87,$B1,$AC,$77,$79,$A3,$87,$56,$41,$41,$4C,$5B,$7F,$AC,$D2,$FF,$FF,$FF,$FF,$FC; 13760
		dc.b $CC,$B8,$AF,$76,$6E,$A7,$A4,$8A,$7A,$4D,$34,$40,$34,$2B,$4C,$7A,$91,$99,$93,$63,$31,$2C,$35,$3C,$75,$B3,$DA,$F5,$FF,$FF,$FF,$D0,$8D,$84,$87,$6A,$48,$1C,  0,  0,$11,$1A,$2D,$5A,$96,$C7,$DB,$E1,$D6,$CD,$B5,$98,$89,$87,$AB,$9F,$64,$5D,$54,$2D,$26,$12,$1D,$62; 13824
		dc.b $88,$84,$88,$85,$6B,$49,$2A,$1A,$20,$55,$90,$AE,$C6,$CA,$BA,$A7,$6B,$1F,$2A,$4F,$59,$65,$69,$7B,$8A,$7D,$6C,$68,$7F,$B0,$DD,$F1,$FF,$FF,$F1,$CE,$A4,$51,$1A,$14,  1,  0,$19,$49,$7E,$AC,$B1,$AF,$BB,$AE,$9E,$98,$91,$7F,$76,$7A,$68,$60,$8D,$AF,$AE,$C2,$DE,$F0; 13888
		dc.b $C2,$71,$5F,$74,$71,$57,$46,$62,$76,$5B,$3B,$28,$36,$73,$99,$A1,$BE,$F0,$FF,$FF,$E6,$B0,$89,$73,$66,$35,$1C,$4E,$7B,$A0,$A3,$75,$5D,$5A,$41,$1E,$13,$16,$1F,$3F,$6F,$82,$83,$AA,$C4,$A9,$85,$89,$90,$8C,$8C,$9D,$B1,$BA,$A9,$66,$1F,  0,  0,$13,$51,$78,$9B,$D5; 13952
		dc.b $FF,$FF,$FF,$DF,$AB,$8C,$78,$4C,$30,$1D,  5, $F,$23,$38,$50,$58,$76,$9E,$9D,$85,$75,$85,$87,$75,$6D,$79,$9C,$B4,$B7,$AF,$7B,$50,$70,$86,$53,$36,$5C,$99,$B5,$86,$4D,$3D,$3C,$38,$44,$64,$8F,$C5,$FF,$FF,$FF,$FF,$FF,$CD,$85,$4D,$3F,$63,$95,$A4,$96,$92,$A0,$84; 14016
		dc.b $4E,$24,$12,$24,$57,$8C,$9B,$9A,$87,$65,$55,$42,$45,$82,$C5,$DB,$ED,$FF,$FF,$F9,$D4,$B2,$98,$87,$87,$74,$3B,  8,  1,$18,$36,$4F,$74,$AE,$EA,$FF,$FF,$FF,$D7,$99,$84,$71,$67,$70,$80,$99,$A8,$B0,$9D,$64,$38,$31,$2E,$3D,$5E,$88,$AF,$B6,$9F,$73,$62,$6C,$79,$71; 14080
		dc.b $69,$8E,$CF,$DF,$A9,$81,$7C,$5A,$36,$1F,$13,$1E,$3E,$68,$8E,$A9,$C4,$D4,$C6,$CE,$CE,$D0,$D7,$BB,$9A,$80,$5F,$3D,$24,  8,  0,$24,$66,$63,$53,$62,$62,$71,$90,$9D,$8F,$78,$86,$AA,$A5,$72,$66,$89,$8C,$61,$50,$81,$A4,$B0,$B4,$A8,$98,$72,$4E,$29,  0,  0,  0,$26; 14144
		dc.b $61,$8E,$A3,$CB,$DE,$C0,$A7,$A4,$92,$72,$75,$99,$BB,$B6,$8B,$62,$52,$45,$26,$16,$37,$59,$4E,$66,$72,$49,$28,$21,$24,$2A,$52,$83,$B2,$D8,$C6,$AE,$BB,$AD,$87,$8C,$97,$8F,$94,$A5,$6D,$1A,  8,$21,$4B,$7A,$A3,$C7,$EF,$FF,$FF,$FF,$E6,$9A,$62,$69,$80,$81,$7F,$77; 14208
		dc.b $75,$72,$47,$13,  0,$17,$4E,$77,$A2,$CF,$E1,$E0,$CF,$8F,$56,$60,$76,$8A,$9F,$A3,$BC,$D8,$BC,$95,$7B,$46,$36,$4A,$3E,$2F,$33,$55,$82,$90,$9A,$B7,$D8,$F5,$FF,$FF,$FF,$E9,$C3,$88,$68,$55,$37,$4B,$8B,$A0,$82,$76,$69,$54,$4E,$25,$17,$51,$82,$89,$7E,$77,$5F,$42; 14272
		dc.b $3E,$35,$49,$89,$BE,$DE,$F7,$E9,$EF,$F2,$A2,$50,$34,$40,$41,$27,$16,$3A,$6E,$8F,$9E,$84,$73,$9E,$BE,$B8,$B1,$A0,$A0,$CB,$C1,$83,$6E,$60,$45,$47,$3D,$38,$46,$5E,$75,$73,$6C,$60,$40,$43,$7F,$92,$7E,$A5,$CD,$D1,$C6,$9F,$89,$90,$91,$9C,$91,$64,$42,$2E,$1E,  9; 14336
		dc.b   0,$22,$60,$8B,$B2,$E3,$FB,$FF,$FF,$F3,$CB,$B6,$A0,$A5,$B5,$8B,$4D,$41,$35,$17,$15,$20,$36,$6C,$A3,$AF,$BF,$B9,$93,$76,$65,$73,$8F,$9F,$B4,$D2,$E5,$E4,$C5,$8D,$65,$6C,$77,$63,$4C,$61,$86,$9A,$73,$29,$25,$4F,$5F,$71,$93,$B2,$E4,$FF,$E3,$BA,$97,$6F,$57,$69; 14400
		dc.b $63,$57,$8C,$A6,$96,$83,$68,$53,$53,$48,$45,$59,$53,$46,$4C,$42,$39,$2F,$34,$60,$86,$96,$B5,$C7,$B5,$8F,$77,$80,$86,$75,$6B,$72,$75,$4D,$1E,$28,$34,$38,$6E,$A7,$CA,$E9,$FF,$FF,$FF,$D5,$89,$5E,$53,$42,$40,$5B,$76,$7F,$6A,$5B,$43,$24,  9, $B,$29,$42,$55,$80; 14464
		dc.b $B3,$D1,$D2,$C6,$B9,$A7,$9D,$9A,$9C,$93,$73,$83,$A0,$71,$2E,$1B,$26,$2C,$19,$29,$66,$98,$B5,$CD,$E2,$FF,$FF,$FF,$F7,$C6,$A6,$A2,$A3,$83,$46,$2F,$5C,$7D,$70,$59,$5D,$87,$8F,$69,$44,$3B,$5A,$8E,$9F,$A2,$AF,$A3,$9D,$8E,$52,$39,$56,$8D,$A6,$A2,$D8,$FB,$DC,$BC; 14528
		dc.b $8F,$62,$37,$18,$26,$51,$74,$93,$CC,$FE,$FF,$F4,$C4,$91,$67,$49,$4B,$83,$9A,$90,$A2,$AD,$99,$84,$5B,$39,$4C,$5D,$5C,$68,$73,$6D,$66,$61,$63,$7A,$8E,$9E,$B5,$C7,$DE,$EB,$C3,$8F,$84,$A5,$9D,$5F,$31,$27,$31, $F,  0,  0,$2C,$5D,$88,$B5,$E4,$FD,$FF,$FF,$D3,$8C; 14592
		dc.b $73,$7F,$9E,$A9,$83,$76,$74,$4E,$30,  0,  0,  0,$31,$4F,$6C,$88,$A1,$D0,$CA,$97,$6A,$59,$70,$95,$A4,$AC,$C5,$C9,$B2,$8D,$71,$4A,$1C,  9, $E,$24,$31,$3B,$5E,$81,$87,$A3,$C5,$CA,$D5,$EC,$EB,$C0,$85,$58,$59,$66,$2F,  0,$1F,$51,$7C,$80,$56,$56,$89,$91,$71,$5D; 14656
		dc.b $63,$7B,$8A,$6F,$55,$51,$58,$66,$61,$64,$89,$B5,$B9,$9B,$8C,$96,$81,$45,$29,$3E,$59,$5E,$70,$9C,$A3,$92,$A8,$B9,$B6,$BE,$D8,$EA,$E2,$DB,$CF,$D3,$DF,$B1,$6E,$4D,$3D,$4B,$50,$27,$27,$51,$69,$76,$62,$45,$3E,$45,$65,$8B,$9A,$B2,$DF,$F5,$F5,$D7,$C2,$A8,$87,$8B; 14720
		dc.b $9F,$90,$69,$48,$3D,$33,$13,$11,$3C,$6F,$9D,$CC,$F2,$FA,$FF,$FF,$FF,$CD,$9F,$90,$B1,$C4,$84,$44,$4D,$6F,$7A,$48,$15,$3F,$80,$88,$70,$65,$7A,$6F,$53,$61,$75,$76,$87,$B2,$C5,$B3,$A2,$8F,$60,$2B,$24,$51,$69,$5B,$67,$71,$7E,$84,$6B,$6D,$6C,$72,$A0,$CA,$D0,$DA; 14784
		dc.b $E8,$DB,$AF,$6F,$3B,$41,$5B,$4F,$4B,$50,$73,$89,$68,$3C,$37,$41,$4E,$5F,$73,$8A,$90,$93,$95,$88,$7A,$75,$84,$84,$91,$C5,$E7,$D5,$A9,$89,$9B,$97,$4F,$19,$1B,$38,$3F,$40,$44,$5A,$85,$A5,$BE,$BF,$DF,$FF,$FF,$C7,$B0,$A9,$AF,$9B,$5B,$3C,$53,$77,$8B,$7A,$49,$3F; 14848
		dc.b $46,$2C,$22,$2F,$56,$7C,$92,$B0,$B6,$B7,$CD,$D4,$C0,$A5,$A1,$BB,$AE,$84,$88,$94,$78,$52,$23,$17,$27,$26,$43,$75,$9D,$BD,$DD,$EB,$DB,$E1,$E2,$B0,$86,$80,$95,$A0,$87,$55,$24, $F,$14,$15,$13,$12,$41,$89,$AC,$A8,$95,$8E,$8B,$72,$5B,$5D,$69,$8A,$A3,$84,$60,$7E; 14912
		dc.b $A3,$81,$55,$53,$78,$7A,$4B,$2C,$34,$39,$33,$4E,$6C,$86,$B3,$DC,$FB,$F9,$EB,$EE,$BD,$82,$7B,$8D,$98,$95,$8E,$74,$61,$68,$66,$3B, $B,$22,$5D,$83,$77,$60,$6B,$6F,$4F,$43,$46,$45,$7C,$A9,$B7,$E0,$FA,$EC,$CA,$95,$6C,$59,$42,$34,$49,$6C,$6D,$5A,$66,$6B,$75,$7D; 14976
		dc.b $7D,$9E,$C9,$F9,$FF,$FF,$E0,$DC,$D7,$A5,$6B,$4C,$36,$4B,$79,$75,$68,$65,$71,$89,$71,$38,$53,$8A,$96,$86,$74,$7D,$8F,$88,$7E,$85,$8C,$B0,$C3,$AA,$8B,$6D,$55,$36,$22,$23,$42,$60,$81,$B1,$B2,$B5,$C7,$CB,$CB,$C9,$D5,$F0,$F2,$DC,$CC,$A1,$6C,$4D,$1A,  0, $C,$24; 15040
		dc.b $4C,$7A,$88,$93,$9D,$88,$6A,$51,$4B,$51,$67,$9D,$CB,$D9,$D5,$C5,$B6,$9B,$78,$4C,$3D,$6E,$AA,$9E,$76,$78,$7C,$7E,$5C,$1C,$2C,$5F,$78,$99,$BA,$C0,$D8,$F4,$EF,$C7,$9E,$B8,$CA,$9A,$54,$45,$4E,$39,$2D,$32,$4A,$72,$8C,$87,$7E,$60,$52,$56,$3B,$3A,$51,$63,$9B,$BE; 15104
		dc.b $B9,$C7,$B7,$8C,$84,$75,$69,$77,$6A,$7C,$A4,$94,$55,$33,$2F,$2A,$32,$41,$68,$A2,$DA,$FE,$FF,$F8,$CC,$AA,$82,$46,$11,  0,$16,$49,$62,$6F,$69,$41,$38,$2E,$13,$19,$2D,$63,$AC,$BB,$AA,$9D,$96,$8C,$68,$55,$64,$78,$82,$80,$82,$8E,$80,$5F,$39,$3A,$58,$4B,$3E,$45; 15168
		dc.b $51,$6F,$84,$88,$A5,$CA,$F9,$FF,$FF,$FE,$F2,$C8,$86,$3C,  0,  7,$39,$5E,$8E,$9D,$9B,$A6,$73,$3C,$42,$48,$51,$73,$A1,$D5,$E2,$B4,$7D,$5D,$53,$55,$54,$69,$91,$D9,$FF,$F7,$AF,$7A,$6F,$75,$3C,$12,$39,$79,$AD,$C1,$D0,$E8,$F8,$E9,$C7,$9F,$85,$9D,$C7,$C0,$94,$6C; 15232
		dc.b $69,$92,$94,$6D,$6B,$6F,$81,$9F,$90,$66,$58,$55,$7C,$AB,$9A,$8E,$9B,$A5,$95,$76,$5F,$48,$42,$59,$8A,$C0,$BB,$97,$94,$91,$77,$27,  0,$1B,$4F,$78,$91,$AF,$E4,$FF,$FF,$E5,$98,$88,$C4,$C0,$8C,$6A,$5E,$97,$9C,$55,$1B,  0,  2,$21,$2B,$30,$46,$7E,$C7,$D1,$94,$75; 15296
		dc.b $7B,$89,$86,$5C,$6A,$AC,$C2,$B3,$A4,$94,$79,$61,$45,$2F,$25,$3D,$57,$52,$63,$71,$82,$A0,$A2,$B1,$D6,$D7,$BE,$A4,$A3,$AE,$8F,$64,$5C,$69,$71,$80,$7A,$57,$34,$28,$2F,$3F,$46,$49,$70,$A8,$BF,$BE,$A2,$7D,$6D,$4B,$30,$42,$5C,$74,$8C,$B5,$E7,$C8,$8C,$74,$4B,$47; 15360
		dc.b $6C,$71,$82,$A5,$BA,$D7,$C4,$88,$90,$A4,$95,$96,$9B,$B5,$CD,$B5,$8C,$68,$41,$23,$23,$2F,$23,$2A,$59,$66,$6F,$78,$61,$59,$69,$6F,$65,$6A,$83,$86,$77,$70,$79,$9B,$AE,$AC,$B6,$B9,$A0,$7B,$53,$3C,$22,$19,$3E,$58,$72,$9F,$BC,$BD,$BD,$C3,$B9,$A0,$93,$BB,$E1,$E8; 15424
		dc.b $C8,$A6,$AD,$A0,$5F,$25,$2E,$3B,$45,$57,$55,$7C,$9A,$84,$7E,$76,$6B,$76,$6A,$84,$AF,$A4,$9F,$AC,$A2,$8F,$8C,$88,$7C,$75,$72,$71,$81,$61,$49,$77,$90,$83,$99,$B0,$AD,$B5,$C7,$C8,$A2,$A1,$C0,$C7,$A6,$74,$58,$6B,$80,$60,$30,$2F,$4C,$66,$7C,$98,$A3,$A8,$B3,$AC; 15488
		dc.b $92,$62,$32,$31,$65,$80,$6C,$6F,$9A,$B8,$A4,$79,$65,$59,$57,$53,$48,$4F,$56,$5C,$76,$89,$7B,$7E,$90,$A5,$C2,$B9,$AE,$AD,$A8,$B6,$B6,$92,$86,$98,$A0,$8A,$5B,$59,$77,$6C,$49,$32,$56,$79,$62,$49,$4E,$75,$90,$7E,$65,$64,$7A,$97,$A9,$A0,$95,$99,$AC,$BA,$99,$5F; 15552
		dc.b $57,$78,$77,$6A,$67,$63,$87,$BE,$B9,$81,$70,$83,$AA,$B7,$97,$9D,$E1,$F9,$C4,$83,$5B,$52,$50,$3D,$33,$4C,$72,$92,$9D,$96,$7A,$68,$6D,$70,$6E,$5B,$5E,$80,$94,$9C,$9C,$7E,$7E,$87,$73,$8B,$90,$6B,$6B,$7B,$57,$43,$48,$60,$9A,$B8,$C3,$C9,$CE,$F0,$E3,$A1,$72,$78; 15616
		dc.b $B5,$CF,$98,$65,$72,$8F,$74,$28,  0,  5,$2E,$45,$44,$51,$68,$79,$77,$56,$3D,$52,$54,$48,$68,$8E,$90,$97,$A2,$8A,$77,$6F,$69,$6B,$69,$61,$6C,$7B,$7C,$77,$59,$4B,$67,$7A,$75,$78,$9B,$B6,$BD,$A1,$87,$A8,$BA,$A1,$8A,$8A,$8F,$94,$77,$5A,$58,$3E,$45,$6C,$7B,$87; 15680
		dc.b $8E,$89,$9C,$94,$64,$3B,$1D,$38,$7A,$AE,$A6,$97,$AE,$BD,$BA,$8D,$52,$40,$63,$8D,$86,$79,$85,$90,$A3,$C3,$AC,$77,$83,$AA,$A9,$91,$8A,$98,$D5,$ED,$AF,$80,$81,$7C,$63,$54,$4A,$60,$8A,$8A,$7B,$7F,$8D,$8D,$70,$55,$67,$8A,$8C,$85,$92,$A0,$BA,$B3,$80,$6D,$80,$94; 15744
		dc.b $92,$6B,$43,$58,$6D,$58,$56,$65,$6F,$97,$B8,$A0,$8D,$93,$9E,$AA,$90,$82,$B8,$E1,$DF,$CD,$AE,$8B,$6C,$58,$3A,$35,$5B,$7E,$8D,$A4,$AC,$A7,$96,$67,$49,$49,$64,$76,$7B,$96,$AD,$B8,$A8,$7C,$5D,$5A,$67,$6F,$5A,$67,$95,$9B,$A3,$B3,$A7,$92,$8E,$86,$8C,$8D,$A7,$B5; 15808
		dc.b $96,$A1,$B3,$BB,$B4,$7E,$52,$66,$68,$4F,$4B,$55,$73,$7C,$6B,$63,$7E,$92,$86,$63,$53,$57,$6D,$6A,$53,$67,$99,$BC,$CC,$B4,$83,$75,$71,$56,$2E,$1C,$3E,$7C,$97,$85,$8E,$93,$76,$75,$8A,$6A,$5F,$9A,$C5,$C8,$B4,$AA,$CC,$C7,$90,$65,$53,$57,$6A,$73,$68,$46,$32,$42; 15872
		dc.b $51,$40,$1C,  7,$14,$24,$2E,$47,$5D,$82,$AA,$B7,$AF,$90,$6D,$52,$54,$67,$66,$67,$7D,$8E,$98,$82,$5F,$5C,$5A,$5D,$6C,$74,$81,$9A,$AF,$BD,$A7,$9A,$AC,$9C,$7E,$62,$56,$7D,$85,$79,$95,$96,$8E,$99,$86,$7E,$87,$79,$5F,$57,$59,$70,$93,$B1,$AB,$A3,$BD,$BC,$97,$65; 15936
		dc.b $2E,$2A,$6A,$94,$80,$71,$92,$C6,$D5,$AC,$7A,$75,$95,$BD,$CA,$95,$85,$C3,$DF,$AE,$89,$89,$8F,$95,$70,$5E,$83,$AC,$BD,$BE,$B3,$8C,$74,$6D,$6D,$68,$45,$3F,$68,$94,$B6,$B7,$A0,$97,$9E,$A0,$8E,$64,$5A,$6E,$90,$AD,$9F,$86,$8A,$8C,$78,$59,$4E,$56,$6C,$84,$87,$96; 16000
		dc.b $98,$95,$B2,$AC,$82,$91,$A8,$95,$7E,$74,$73,$96,$AC,$99,$9D,$A3,$8A,$5D,$3A,$42,$4D,$54,$63,$66,$82,$AD,$BF,$B5,$96,$7F,$8E,$96,$75,$46,$2B,$47,$84,$8E,$7E,$6E,$6C,$90,$8C,$59,$3F,$55,$88,$C6,$E0,$B0,$9B,$BD,$C6,$A9,$70,$47,$62,$8B,$85,$6E,$79,$82,$82,$73; 16064
		dc.b $4C,$2D,$23,$36,$5E,$6E,$5F,$5F,$78,$88,$87,$75,$62,$5C,$6F,$96,$AC,$96,$6F,$77,$9B,$8C,$67,$51,$41,$58,$81,$7C,$6A,$67,$63,$6E,$8F,$AC,$96,$82,$96,$A6,$A2,$76,$58,$76,$7A,$78,$A4,$C4,$B3,$AD,$A8,$8C,$71,$3D, $D,  2, $C,$21,$2A,$3D,$61,$85,$94,$75,$3C,$31; 16128
		dc.b $68,$99,$88,$5B,$6A,$B3,$DC,$AA,$5D,$4C,$61,$89,$93,$6A,$70,$95,$A7,$B9,$A3,$63,$56,$79,$8D,$93,$90,$94,$9E,$A7,$92,$80,$88,$89,$8D,$AB,$B4,$93,$7F,$6B,$5F,$6C,$5B,$5F,$79,$9A,$B8,$D1,$DF,$BF,$87,$78,$80,$70,$66,$6B,$85,$96,$86,$81,$6B,$51,$82,$A5,$9B,$A3; 16192
		dc.b $A9,$C6,$EB,$DA,$AF,$91,$8F,$A1,$86,$55,$56,$7C,$9F,$AB,$BC,$C1,$A9,$A1,$9C,$8C,$66,$40,$3F,$60,$81,$8F,$82,$75,$93,$B4,$A9,$8E,$65,$4E,$81,$96,$63,$4D,$6E,$8D,$8B,$6A,$63,$8F,$A0,$9C,$9D,$88,$6A,$62,$6C,$76,$7B,$6B,$74,$9E,$A2,$8B,$6F,$6B,$84,$77,$67,$99; 16256
		dc.b $CB,$C8,$B0,$8D,$66,$47,$32,$29,$34,$4C,$86,$AD,$8B,$7E,$87,$9C,$AA,$6A,$48,$7A,$A2,$B0,$8F,$63,$65,$7C,$85,$67,$47,$47,$72,$AC,$A2,$74,$5C,$69,$9F,$B5,$82,$64,$7C,$A0,$CC,$B8,$78,$7C,$86,$8D,$B3,$9D,$62,$66,$7D,$6F,$44,$18,$17,$37,$4E,$5E,$6B,$67,$75,$9B; 16320
		dc.b $AE,$9D,$71,$56,$6C,$86,$89,$82,$7D,$82,$8F,$90,$95,$8E,$6F,$70,$92,$9B,$8E,$7F,$74,$82,$80,$5F,$76,$82,$6C,$93,$AA,$A4,$9B,$68,$55,$88,$BD,$C3,$99,$82,$8E,$9D,$96,$4D,  2,$16,$5E,$8A,$60,$24,$3C,$87,$B1,$76,$1F,$17,$4F,$9C,$A8,$5B,$31,$5F,$A9,$D8,$BB,$7C; 16384
		dc.b $78,$BC,$E6,$A9,$46,$2E,$6A,$92,$84,$6F,$6B,$76,$9B,$BE,$8E,$5E,$5E,$7F,$C2,$E1,$C0,$A7,$9A,$93,$9E,$72,$2C,$26,$48,$7A,$9F,$A0,$A0,$C0,$D9,$D0,$9F,$68,$6B,$7A,$69,$6B,$6C,$53,$61,$86,$B1,$DA,$C3,$94,$7F,$6C,$6D,$84,$79,$5B,$75,$D0,$FF,$DE,$8F,$60,$7D,$9E; 16448
		dc.b $9A,$59,$39,$A0,$FF,$FF,$AD,$3B,$2B,$86,$93,$33,  0,$18,$81,$E5,$E5,$8B,$60,$B2,$EC,$AA,$47,  4,$2B,$73,$65,$35,$1C,$4C,$B4,$E2,$B9,$8E,$86,$9B,$98,$63,$38,$29,$3F,$7A,$A9,$A7,$8C,$7D,$7A,$6B,$64,$64,$68,$85,$D2,$FC,$CF,$94,$5E,$41,$48,$26,  4,$1C,$49,$75; 16512
		dc.b $A9,$CA,$D8,$D5,$B4,$89,$4D,$26,$31,$5C,$56,$52,$9C,$CD,$D1,$B6,$98,$BD,$CF,$A2,$67,$2C,$46,$8B,$7C,$4A,$41,$87,$DE,$D8,$75,$2C,$51,$BC,$F3,$9A,$5E,$C3,$FF,$F8,$96,$28,$13,$49,$50,$19,  4,$30,$8B,$D3,$BD,$7D,$5F,$84,$AA,$77,$3A,$3E,$66,$8B,$8B,$75,$7C,$95; 16576
		dc.b $B3,$D1,$C5,$A8,$8F,$84,$90,$86,$57,$42,$62,$77,$77,$6F,$74,$9C,$97,$82,$85,$7A,$84,$A9,$D8,$E2,$BB,$62,$43,$62,$53,$21,$27,$74,$9D,$9D,$91,$80,$7E,$7C,$6F,$48,$15,$20,$62,$72,$3B,$19,$4F,$A2,$AE,$62,$58,$B7,$F6,$E6,$96,$51,$82,$A6,$6F,$45,$2D,$42,$88,$9A; 16640
		dc.b $62,$49,$72,$AB,$C9,$97,$77,$BC,$DC,$B5,$65,$3E,$75,$92,$7C,$6E,$67,$73,$8C,$96,$8E,$85,$86,$A6,$BD,$8F,$5F,$7E,$A3,$8E,$54,$23,$44,$8C,$BB,$D0,$C6,$BE,$BA,$A6,$7C,$5B,$35,$35,$5C,$71,$7A,$8B,$A0,$AB,$C2,$C1,$C1,$B9,$9A,$B5,$D8,$D3,$9B,$50,$5F,$95,$6E,$2B; 16704
		dc.b $1C,$56,$99,$74,$56,$78,$9A,$BA,$AC,$88,$87,$95,$A1,$88,$36, $D,$35,$55,$69,$79,$96,$D1,$EB,$C0,$8A,$6D,$58,$31,$22,$31,$50,$84,$9C,$A3,$A8,$97,$A7,$A9,$79,$70,$8B,$AE,$D4,$A6,$56,$50,$68,$7B,$69,$31,$2D,$4C,$7E,$A4,$96,$90,$A2,$C2,$B9,$7D,$52,$6C,$7C,$64; 16768
		dc.b $3C,$39,$73,$B8,$D7,$DC,$D3,$DC,$ED,$BB,$7B,$42,$17,$3D,$5A,$4F,$76,$8D,$94,$B0,$A9,$95,$87,$88,$A3,$CC,$CB,$A4,$8B,$80,$85,$76,$41,$2E,$4F,$5F,$51,$4F,$57,$6A,$7E,$87,$82,$6F,$6C,$7D,$77,$58,$40,$4D,$78,$A2,$C8,$DB,$DB,$D4,$D0,$B1,$61,$20,$18,$4A,$7D,$6F; 16832
		dc.b $54,$72,$9C,$A6,$8B,$6C,$85,$9C,$A1,$AA,$AB,$AA,$A2,$70,$3F,$3A,$50,$65,$66,$4C,$3A,$70,$A6,$8A,$5B,$52,$7E,$B3,$94,$4E,$49,$65,$5C,$35,$1E,$31,$5E,$9A,$C9,$A9,$74,$88,$A4,$92,$4C,$1A,$52,$95,$A4,$97,$79,$6C,$94,$A1,$84,$69,$64,$92,$CB,$D3,$BE,$89,$5A,$54; 16896
		dc.b $50,$45,$49,$6E,$8F,$B1,$C5,$C1,$98,$58,$5E,$9E,$A3,$5E,$45,$7E,$C3,$B9,$7A,$54,$60,$92,$B2,$AB,$82,$86,$C1,$C0,$88,$41,$39,$7F,$86,$57,$5B,$72,$AC,$C2,$7F,$63,$8F,$CC,$E4,$D6,$BB,$C0,$D0,$A7,$69,$41,$4B,$68,$80,$78,$59,$68,$B0,$B4,$59,$39,$65,$88,$73,$52; 16960
		dc.b $67,$93,$A7,$9C,$7B,$72,$8C,$9A,$9D,$7F,$80,$9E,$88,$68,$4A,$5A,$8A,$6D,$4B,$51,$60,$7E,$82,$81,$A8,$CC,$EE,$EF,$AE,$91,$9D,$77,$3F,$13,$18,$49,$73,$8C,$8F,$80,$8E,$9F,$82,$56,$65,$9C,$A5,$81,$7B,$91,$9F,$88,$5D,$4B,$7D,$CB,$D8,$9A,$5C,$70,$B4,$C0,$83,$4A; 17024
		dc.b $78,$CD,$CE,$89,$42,$34,$71,$A7,$A1,$6F,$77,$DD,$FF,$BB,$7E,$72,$5F,$53,$3B,$32,$59,$8F,$A1,$AB,$A3,$91,$79,$49,$23,$41,$79,$5F,$38,$4D,$7A,$9A,$79,$3E,$55,$A3,$C7,$CB,$AD,$8B,$BD,$E0,$9A,$38,$16,$4D,$92,$89,$66,$53,$5B,$8A,$94,$6B,$54,$94,$E4,$DD,$AF,$96; 17088
		dc.b $7F,$5D,$29, $F,$28,$4C,$8B,$A4,$83,$6F,$8D,$AC,$6B,$10,  0,$41,$78,$6B,$60,$6F,$90,$AC,$A7,$7A,$3E,$43,$87,$A0,$75,$52,$5D,$64,$3D,$3A,$5B,$66,$73,$8A,$9A,$AE,$A3,$87,$91,$B3,$D6,$DC,$A8,$7B,$96,$9F,$68,$23, $F,$32,$69,$85,$7D,$8B,$9C,$BE,$D4,$8F,$4E,$65; 17152
		dc.b $9C,$A7,$80,$6C,$88,$8B,$80,$95,$93,$8B,$94,$A7,$AB,$9B,$90,$83,$7B,$63,$59,$87,$A8,$8C,$6B,$65,$7D,$9E,$A3,$7B,$78,$AC,$E7,$F0,$A3,$64,$7C,$95,$A4,$95,$5A,$6D,$BD,$E1,$C4,$75,$41,$69,$91,$76,$57,$47,$44,$67,$8A,$68,$45,$58,$86,$C0,$CE,$9D,$8B,$9F,$B4,$AF; 17216
		dc.b $86,$56,$43,$61,$8F,$95,$75,$5B,$62,$7F,$83,$70,$67,$81,$C8,$FD,$E8,$AD,$8E,$77,$5F,$4C,$30,$27,$4F,$87,$91,$80,$6B,$6E,$80,$8C,$81,$80,$9F,$AD,$AA,$90,$6E,$69,$84,$9D,$8D,$6F,$7D,$C4,$EA,$B5,$61,$46,$76,$7F,$4F,$3F,$77,$BE,$DC,$BD,$70,$5D,$98,$DB,$D5,$90; 17280
		dc.b $82,$BD,$CD,$93,$2E,  0,$3B,$73,$61,$66,$70,$84,$B6,$AD,$73,$63,$67,$6B,$80,$66,$52,$6A,$5F,$3E,$36,$34,$36,$5E,$8A,$AA,$CF,$DE,$AC,$80,$7F,$73,$69,$67,$70,$99,$98,$6B,$67,$65,$56,$62,$71,$6D,$8A,$BE,$BF,$A6,$7A,$41,$51,$66,$36,$38,$65,$8A,$BB,$A4,$62,$44; 17344
		dc.b $58,$78,$70,$3E,$24,$67,$9A,$57, $A,$28,$61,$9A,$B5,$8D,$81,$B6,$CE,$9A,$45,$16,$3B,$6F,$5F,$25,$28,$81,$AD,$98,$85,$75,$A3,$ED,$D7,$A4,$B5,$CE,$D1,$99,$38,$22,$5A,$70,$74,$6E,$55,$6E,$A4,$94,$61,$6E,$8E,$A7,$A6,$91,$9B,$A4,$84,$8A,$9E,$81,$75,$7E,$98,$BF; 17408
		dc.b $BC,$8D,$7B,$77,$81,$9A,$8C,$74,$80,$B6,$B8,$7D,$57,$4F,$69,$9A,$AD,$B1,$B5,$AF,$B8,$B1,$7E,$48,$57,$95,$95,$90,$BB,$B5,$B8,$CC,$AC,$84,$79,$7C,$80,$66,$52,$73,$6C,$3F,$1A,$29,$7C,$9D,$88,$87,$B2,$E7,$CF,$8F,$69,$71,$B1,$D0,$A6,$79,$7B,$88,$68,$30,$26,$4B; 17472
		dc.b $79,$A4,$BE,$B6,$AF,$AB,$91,$78,$4C,$35,$55,$68,$91,$B0,$99,$89,$69,$49,$4E,$4C,$5E,$79,$93,$B9,$C2,$A3,$80,$6C,$7D,$89,$75,$87,$B0,$C3,$B2,$88,$76,$6F,$6F,$73,$7B,$87,$8A,$90,$88,$47,$29,$63,$A6,$BA,$C5,$DF,$F0,$F0,$CB,$8A,$3C, $B,$1E,$4D,$70,$53,$40,$9D; 17536
		dc.b $CA,$94,$52,$30,$62,$9E,$7D,$63,$77,$77,$82,$75,$47,$34,$35,$47,$68,$88,$97,$85,$7C,$8B,$96,$A1,$91,$78,$8C,$AA,$AF,$7D,$2F,$36,$6B,$74,$62,$5B,$7A,$B0,$BB,$8F,$62,$40,$3B,$55,$6C,$81,$8D,$A1,$BE,$A5,$6A,$4D,$52,$5B,$3C,$1E,$5D,$95,$6B,$45,$4F,$5C,$66,$61; 17600
		dc.b $4B,$48,$81,$C1,$B7,$9B,$80,$8B,$C4,$A9,$5B,$3A,$4C,$6D,$59,$3A,$47,$68,$A8,$CA,$D1,$C8,$B7,$C8,$C9,$95,$54,$49,$7B,$B2,$AF,$79,$66,$74,$76,$68,$3E,$3D,$6A,$79,$8E,$B1,$B1,$9C,$A1,$A1,$93,$94,$83,$8A,$B7,$C3,$9C,$7F,$6C,$72,$9A,$9A,$7E,$83,$96,$AC,$A8,$6D; 17664
		dc.b $3F,$5E,$8D,$99,$A0,$A2,$A4,$B2,$AE,$93,$63,$4C,$72,$A6,$BC,$AE,$A7,$AF,$A7,$95,$5D,$41,$82,$9F,$9E,$9E,$A6,$B4,$8C,$50,$1E,$1F,$54,$61,$52,$6E,$90,$C6,$C8,$88,$83,$B3,$D8,$D6,$9D,$7C,$98,$A2,$74,$40,$3B,$55,$6E,$80,$78,$6E,$7E,$87,$88,$77,$51,$4F,$78,$AA; 17728
		dc.b $B4,$9C,$87,$7B,$72,$5D,$44,$3E,$56,$72,$9E,$B9,$9D,$7D,$87,$86,$78,$77,$71,$94,$BF,$BC,$A7,$8C,$77,$88,$86,$5D,$60,$84,$9A,$97,$81,$55,$54,$81,$7E,$5C,$7B,$A2,$C7,$EE,$BF,$A9,$A1,$77,$72,$7C,$76,$63,$55,$6B,$7C,$44,$1D,$3B,$6E,$81,$79,$81,$93,$9A,$8B,$72; 17792
		dc.b $4C,$4A,$62,$64,$69,$78,$77,$74,$7B,$7F,$91,$8D,$81,$8E,$9E,$A0,$95,$6F,$59,$70,$7E,$6C,$53,$66,$7E,$7F,$74,$67,$62,$5E,$4F,$56,$83,$A2,$A2,$9A,$98,$9E,$8C,$5F,$4D,$44,$43,$57,$6E,$64,$55,$52,$4A,$5C,$5C,$43,$4C,$6F,$8B,$93,$7A,$5D,$75,$AF,$C6,$A9,$9E,$A1; 17856
		dc.b $A3,$95,$5D,$28,$3C,$6D,$75,$7A,$7A,$89,$C7,$CF,$A0,$92,$90,$93,$AF,$AA,$90,$8E,$8E,$93,$87,$5A,$50,$5E,$59,$5D,$68,$77,$82,$8A,$97,$A0,$9E,$9C,$A8,$B6,$B5,$A8,$94,$74,$79,$A3,$AC,$8F,$83,$97,$B5,$9E,$5A,$46,$64,$79,$7B,$6E,$80,$B2,$BD,$B0,$8B,$76,$78,$6D; 17920
		dc.b $72,$8E,$B4,$D2,$C6,$B6,$AF,$98,$7C,$5C,$4D,$58,$5B,$7F,$A5,$A4,$A0,$88,$6C,$79,$78,$6B,$63,$5D,$79,$84,$6F,$6C,$85,$C1,$DD,$C5,$BF,$C7,$BD,$94,$65,$4C,$4E,$5A,$63,$74,$77,$77,$7B,$69,$58,$4D,$4D,$67,$7A,$90,$B8,$C0,$A9,$94,$85,$6C,$50,$3F,$3A,$62,$90,$92; 17984
		dc.b $98,$92,$7C,$87,$8F,$7B,$67,$7C,$A9,$AA,$95,$79,$8B,$B2,$A0,$78,$73,$8D,$A2,$92,$59,$44,$71,$80,$6B,$5E,$65,$9B,$C3,$A2,$7A,$71,$79,$A9,$BC,$A5,$AD,$B8,$BB,$AB,$71,$3F,$26,$1C,$27,$2C,$43,$74,$89,$97,$9B,$80,$77,$7F,$71,$53,$5A,$68,$73,$7B,$74,$98,$B6,$A2; 18048
		dc.b $8C,$83,$8F,$97,$81,$56,$4D,$72,$7A,$69,$6A,$63,$6B,$74,$56,$47,$61,$76,$7B,$81,$8F,$A5,$AB,$90,$83,$87,$71,$61,$51,$46,$5D,$7A,$72,$56,$5B,$5E,$52,$34,$2D,$4C,$54,$69,$82,$77,$83,$87,$8C,$9D,$8C,$7A,$8B,$AA,$BD,$A3,$6B,$6E,$96,$8D,$78,$6D,$59,$62,$87,$80; 18112
		dc.b $60,$65,$9C,$CD,$DC,$C5,$AD,$B6,$AE,$8E,$66,$41,$40,$61,$78,$7F,$86,$7A,$7A,$80,$71,$6A,$78,$8C,$A1,$B4,$D0,$CA,$A3,$92,$96,$9D,$98,$94,$92,$92,$A9,$A8,$78,$48,$53,$85,$81,$56,$54,$78,$9B,$A2,$84,$74,$82,$97,$A6,$AE,$B4,$BA,$D1,$BB,$8E,$86,$78,$6D,$66,$5F; 18176
		dc.b $84,$A0,$89,$74,$6D,$50,$47,$65,$78,$81,$95,$B2,$C2,$AC,$86,$78,$7B,$84,$88,$A2,$C8,$D5,$CD,$AF,$94,$7F,$6D,$57,$32,$2A,$43,$65,$66,$4F,$68,$7C,$83,$8E,$95,$98,$90,$92,$90,$82,$7E,$74,$73,$73,$69,$7D,$7F,$5F,$61,$6B,$72,$7D,$76,$80,$A3,$AC,$9B,$8D,$83,$7B; 18240
		dc.b $8A,$96,$98,$A2,$B0,$B5,$AF,$86,$5B,$57,$4E,$3F,$4A,$4F,$62,$83,$94,$A2,$A0,$96,$93,$9E,$A8,$AB,$99,$84,$9F,$B1,$99,$75,$4E,$56,$6A,$59,$4F,$3F,$40,$5D,$71,$65,$55,$69,$88,$A4,$9E,$69,$5C,$63,$61,$7E,$94,$9F,$B7,$D2,$DA,$C7,$89,$4A,$4B,$40,$2E,$36,$3B,$5B; 18304
		dc.b $88,$8E,$7E,$61,$39,$4A,$7D,$97,$97,$94,$A4,$BD,$AC,$79,$5F,$61,$65,$58,$5E,$6F,$6E,$68,$51,$38,$32,$3C,$3C,$40,$55,$75,$7B,$6C,$68,$85,$AE,$B5,$A3,$A9,$C8,$D2,$AF,$6D,$4A,$3F,$34,$4D,$66,$6E,$95,$BF,$BE,$A8,$92,$6A,$52,$66,$9D,$C9,$CA,$B9,$B9,$C7,$A9,$67; 18368
		dc.b $35,$2B,$3F,$5D,$8B,$91,$70,$87,$9B,$83,$69,$66,$7F,$B1,$C1,$AB,$AD,$A1,$AB,$C4,$B4,$A3,$A5,$AC,$B7,$97,$59,$45,$3A,$40,$55,$62,$65,$76,$8C,$95,$96,$7A,$62,$6F,$95,$CC,$D4,$B2,$C0,$D5,$C0,$99,$58,$3E,$6C,$85,$80,$89,$84,$8B,$8A,$67,$38,$2D,$41,$60,$75,$6F; 18432
		dc.b $8D,$C3,$D3,$D3,$C5,$C0,$D4,$CD,$B8,$A8,$91,$94,$99,$6C,$4A,$48,$4C,$5C,$55,$38,$32,$51,$6D,$54,$4D,$85,$B6,$D3,$D1,$B9,$A4,$92,$7F,$59,$48,$56,$62,$83,$A5,$94,$6D,$59,$4A,$3F,$49,$5A,$6C,$94,$BC,$E0,$C5,$96,$A3,$B6,$B1,$A6,$99,$A6,$B9,$A1,$6F,$4B,$2A,$2B; 18496
		dc.b $4A,$3B,$37,$62,$89,$9B,$9E,$9C,$9F,$A7,$C1,$E1,$CC,$AF,$A8,$97,$7A,$3C,$10,$3C,$7D,$80,$7C,$7F,$8B,$8C,$6F,$31,  0,  8,$51,$91,$A5,$8C,$9B,$C9,$B5,$74,$5D,$67,$9C,$CA,$CB,$C5,$AA,$A0,$9A,$52, $D,  0,$15,$42,$5D,$66,$72,$79,$85,$7D,$67,$6D,$7C,$98,$B7,$AE; 18560
		dc.b $99,$81,$64,$67,$80,$86,$77,$66,$7A,$85,$4E,$22,  5,  0,$14,$32,$56,$79,$8C,$9F,$A6,$90,$7B,$8D,$B3,$CA,$C0,$C4,$DA,$CA,$92,$50,$17, $A,$17,$1A,$32,$68,$AB,$CE,$D0,$B9,$93,$A8,$D1,$A5,$6A,$8D,$E3,$F1,$A6,$5E,$48,$77,$A1,$5E,$17,$2C,$5E,$7F,$78,$34,$29,$65; 18624
		dc.b $A0,$D4,$E1,$DD,$E1,$D6,$D0,$B0,$94,$95,$B2,$CE,$D4,$BD,$87,$59,$30,  9,  0,  0,$10,$65,$A9,$C4,$B6,$A0,$AD,$97,$74,$72,$73,$A1,$E5,$F3,$D6,$A8,$81,$77,$80,$67,$41,$58,$8B,$8A,$69,$65,$5A,$45,$40,$52,$6C,$8B,$AE,$AC,$96,$8A,$A8,$EE,$FE,$F2,$E4,$EA,$F6,$BE; 18688
		dc.b $79,$41,$13,$18,$32,$39,$53,$74,$87,$81,$5A,$3B,$33,$50,$7D,$83,$9C,$D4,$F1,$EF,$BA,$78,$5E,$63,$6C,$4D,$36,$59,$74,$7B,$72,$3B,$15,$26,$53,$86,$9E,$A8,$C8,$E6,$E3,$C6,$C0,$CD,$D5,$BE,$AB,$91,$60,$51,$2E,  2,  0,  7,$41,$89,$97,$89,$92,$A8,$AD,$A6,$A5,$B4; 18752
		dc.b $C6,$DA,$EE,$DB,$A0,$68,$44,$2E,$23,$1F,$18,$4D,$9D,$A1,$77,$61,$4A,$33,$2E,$44,$67,$99,$C0,$CE,$CD,$AA,$A4,$BD,$AA,$81,$7F,$9B,$95,$7B,$62,$3E,$22,$2F,$2F,$3B,$6E,$94,$92,$86,$7A,$72,$71,$74,$79,$7A,$85,$A7,$C4,$A6,$60,$48,$40,$59,$83,$6F,$65,$8D,$86,$5D; 18816
		dc.b $39,  7,  0,  0,$1E,$54,$89,$A9,$C5,$DB,$C3,$9C,$A0,$AD,$B2,$CB,$C2,$9E,$88,$78,$51,$1A,  0,  0,$2E,$66,$7B,$7D,$86,$A9,$DE,$DC,$B8,$AE,$BB,$E9,$EF,$C4,$B4,$9F,$6A,$5C,$67,$49,$3A,$52,$63,$5B,$3F,$37,$4C,$45,$55,$8A,$B2,$DF,$FF,$FF,$FF,$F7,$BC,$D2,$D6,$AA; 18880
		dc.b $92,$7B,$6B,$6E,$52,$16,  0,  0,  8,$38,$6A,$96,$CB,$DB,$C9,$B3,$9E,$99,$85,$73,$8A,$AD,$CD,$C9,$94,$78,$6F,$70,$70,$47,$3E,$75,$92,$79,$54,$3D,$4A,$5B,$60,$6A,$86,$B7,$DE,$DC,$B5,$8A,$A0,$D5,$E4,$DA,$BC,$A5,$A4,$8B,$5C,$2A,$20,$19,$23,$7E,$AC,$83,$6D,$61; 18944
		dc.b $5D,$7A,$60,$37,$5C,$8C,$BA,$E1,$C1,$9C,$98,$91,$8E,$67,$3D,$4E,$77,$75,$4A,$34,$31,$23,$33,$56,$78,$9F,$B4,$D4,$F6,$F1,$DB,$D5,$D0,$C4,$BF,$97,$5C,$44,$39,$2D,$19,  3, $A,$38,$7C,$B3,$BB,$B6,$BB,$BA,$B3,$A3,$92,$9F,$C5,$D0,$D4,$BE,$83,$57,$36,$26,$1D,$1C; 19008
		dc.b $2E,$47,$65,$7F,$81,$60,$3E,$53,$90,$B2,$B6,$A3,$AD,$F1,$F5,$B5,$8E,$71,$79,$9E,$71,$30,$3A,$52,$50,$3E,$17,$26,$69,$A0,$C1,$B6,$A2,$A4,$99,$7B,$59,$40,$58,$6D,$78,$A2,$B5,$85,$53,$5A,$61,$4D,$35,$3F,$74,$95,$87,$66,$30, $A,$1A,$35,$53,$70,$8C,$C6,$FC,$EF; 19072
		dc.b $C5,$B1,$A7,$AA,$94,$6F,$79,$83,$64,$4D,$3D,$1F,$11,$28,$57,$7F,$9A,$B2,$B8,$AE,$B3,$AE,$B2,$AE,$AD,$D7,$F2,$F1,$BF,$71,$66,$79,$4A,$20,$1F,$3C,$60,$61,$53,$41,$51,$74,$A1,$BB,$B2,$CD,$FF,$FF,$FF,$FE,$DD,$CD,$AC,$72,$47,$31,$29,$1F,$19,$27,$24,$1C,$4A,$83; 19136
		dc.b $A3,$B5,$BD,$C3,$CA,$BF,$93,$7C,$8D,$8D,$A0,$B7,$9D,$75,$69,$80,$75,$44,$33,$56,$88,$91,$80,$77,$66,$5A,$62,$6F,$7F,$8E,$AC,$DE,$F0,$E0,$C6,$9D,$87,$8A,$7C,$76,$95,$7E,$61,$7A,$74,$71,$5F,$4A,$7E,$9D,$86,$74,$5D,$5D,$6C,$56,$55,$5C,$6F,$AC,$CD,$B2,$7A,$7E; 19200
		dc.b $AC,$A4,$6A,$42,$64,$85,$68,$42,$30,$17,$24,$4E,$6B,$8A,$97,$BA,$F5,$FC,$ED,$E1,$BF,$B1,$95,$6F,$61,$55,$49,$3F,$34,$2F,$2A,$30,$59,$8B,$A1,$B6,$C5,$C8,$CB,$A0,$77,$9B,$B2,$B6,$C4,$BA,$9D,$7A,$5F,$4C,$2E,$11,$15,$3B,$49,$53,$66,$6C,$75,$57,$66,$AA,$C4,$D8; 19264
		dc.b $DE,$CE,$DE,$E6,$B6,$7C,$4A,$2D,$34,$47,$4C,$2A,$2C,$5D,$62,$4A,$53,$88,$C1,$CA,$AD,$9E,$AF,$A7,$69,$46,$4E,$53,$76,$8E,$7B,$69,$63,$74,$70,$42,$17,$27,$69,$8D,$76,$73,$64,$4E,$53,$53,$56,$68,$86,$C1,$E5,$E3,$E1,$C3,$AF,$98,$56,$2D,$55,$85,$72,$52,$54,$59; 19328
		dc.b $4F,$4D,$63,$6F,$74,$90,$A8,$AF,$A3,$89,$96,$C6,$CC,$B3,$D3,$EA,$CE,$B5,$8A,$63,$59,$4A,$44,$4A,$3D,$4C,$7B,$6A,$39,$47,$84,$AF,$BA,$CD,$E8,$FF,$FF,$FF,$EA,$CD,$98,$68,$42,$2B,$22,$19,$39,$50,$42,$40,$5D,$7F,$7E,$7A,$8C,$AA,$D7,$D5,$A1,$9F,$A7,$90,$9B,$9C; 19392
		dc.b $7B,$68,$72,$87,$7C,$57,$40,$57,$77,$6E,$5F,$65,$71,$79,$79,$7B,$97,$B5,$D2,$EF,$EF,$D2,$BB,$B8,$93,$3A, $E,$3E,$81,$8F,$68,$47,$57,$8E,$AF,$9D,$6F,$6A,$A3,$C8,$A6,$70,$30,$32,$82,$73,$35,$4D,$8E,$B7,$B4,$91,$82,$96,$98,$79,$63,$52,$3D,$42,$40,$31,$29,$3D; 19456
		dc.b $7B,$A2,$A2,$BC,$E3,$E8,$D1,$C5,$C1,$B0,$8F,$60,$52,$57,$47,$45,$4B,$42,$47,$56,$7E,$98,$8E,$97,$9B,$A7,$BE,$93,$77,$8A,$91,$BA,$D4,$BB,$AB,$96,$91,$8E,$5A,$18,  9,$23,$30,$1D,$24,$41,$6B,$9E,$8E,$77,$96,$D4,$FF,$FF,$D0,$A3,$CA,$DC,$8E,$2E,  0,$11,$59,$32; 19520
		dc.b   0,  7,$4F,$8A,$8A,$81,$9A,$C5,$E8,$D2,$9B,$71,$60,$76,$75,$53,$54,$7A,$88,$6B,$61,$60,$3C,$2C,$33,$37,$4F,$50,$51,$7C,$89,$80,$69,$62,$84,$9E,$A2,$BA,$E6,$DF,$C1,$D0,$BD,$76,$53,$3A,$31,$34,$39,$5B,$76,$74,$6E,$7B,$90,$8E,$7D,$7B,$81,$91,$8D,$80,$82,$8D; 19584
		dc.b $CC,$D7,$A0,$90,$B4,$EE,$E2,$92,$57,$63,$8D,$8B,$49,$11,$24,$5D,$78,$60,$47,$76,$BA,$E9,$FF,$FF,$FA,$FF,$FF,$F4,$9A,$57,$3F,$46,$42,$2F,$23,$33,$56,$6F,$80,$73,$61,$84,$B2,$AF,$9D,$95,$9D,$A9,$A5,$99,$85,$79,$85,$A6,$AB,$87,$75,$7B,$77,$54,$36,$34,$3A,$40; 19648
		dc.b $54,$75,$91,$AA,$C1,$D6,$FB,$FF,$FB,$D9,$BB,$9F,$79,$3F,$1D,$19,$2C,$68,$74,$56,$69,$7C,$9E,$B0,$94,$95,$B3,$D4,$D2,$9E,$75,$55,$3C,$3D,$36,$35,$47,$84,$D0,$DC,$B7,$9F,$90,$79,$4E,$21, $C,$10,$26,$50,$73,$70,$77,$9F,$DA,$F9,$DB,$A9,$95,$A9,$AD,$72,$52,$58; 19712
		dc.b $60,$81,$7B,$4D,$4A,$66,$82,$8F,$7A,$78,$A7,$BB,$A4,$8E,$86,$70,$53,$54,$71,$8B,$97,$A1,$D5,$FD,$E0,$A6,$80,$60,$2F,  3,  0,  0,  3,$35,$80,$AC,$89,$89,$C8,$EF,$E6,$B8,$A8,$CA,$CE,$B7,$8D,$4B,$21,$1A,$20,$10, $A,$27,$4E,$83,$99,$87,$99,$B6,$BC,$BA,$AB,$8C; 19776
		dc.b $6E,$58,$53,$62,$67,$55,$6C,$B2,$B4,$76,$4F,$3B,$25, $C,  0, $B,$35,$4B,$83,$B6,$AC,$96,$A1,$C7,$E1,$C5,$B3,$D5,$D7,$A3,$7C,$6C,$4A,$1B,$18,$32,$52,$5D,$5E,$84,$B5,$B7,$98,$7D,$77,$82,$8E,$87,$67,$54,$72,$99,$BD,$90,$5F,$AE,$F5,$EB,$AB,$78,$8D,$B1,$90,$52; 19840
		dc.b $1B,$20,$5E,$8E,$72,$44,$5F,$A3,$EC,$F1,$B2,$C9,$FF,$FF,$D2,$96,$98,$7C,$60,$47,$33,$4E,$5C,$5A,$79,$90,$75,$57,$5F,$77,$8A,$97,$90,$87,$8A,$92,$9A,$87,$53,$76,$D4,$DC,$B7,$9B,$8F,$93,$79,$38,  6, $D,$2D,$42,$5D,$70,$86,$AE,$D3,$FD,$FF,$FF,$F3,$EC,$C2,$82; 19904
		dc.b $65,$3F,  2,  0,$1E,$5B,$8E,$66,$69,$BA,$D3,$95,$46,$4C,$B1,$FF,$E7,$A5,$76,$87,$A7,$6A,  0,  0,$47,$AE,$D3,$A1,$8A,$B7,$CE,$99,$33,  0,  0,$1D,$45,$43,$50,$80,$B9,$ED,$F2,$DF,$BF,$B1,$BC,$9A,$5C,$42,$3C,$46,$67,$6A,$6D,$86,$94,$B2,$B7,$73,$58,$6F,$86,$AF; 19968
		dc.b $AC,$8E,$86,$8A,$81,$50,$24,$28,$68,$B9,$E9,$FE,$FA,$D9,$AD,$7F,$3D,  0,  0,  0,  0,$38,$68,$9A,$BB,$CB,$F0,$FA,$D8,$AA,$88,$87,$97,$96,$6F,$49,$41,$47,$54,$3A,$17,$37,$6F,$92,$8A,$62,$65,$AA,$E1,$D2,$8F,$62,$7B,$88,$66,$21,  4,$56,$A5,$B6,$B3,$92,$67,$6C; 20032
		dc.b $5B, $F,  0,  0,  0,$46,$7B,$8B,$A9,$D8,$F5,$FE,$C9,$8D,$A3,$BD,$BC,$AC,$67,$41,$61,$55,$2D,$13,$23,$6A,$AB,$AE,$92,$82,$7D,$8F,$A0,$9D,$77,$59,$6B,$7C,$88,$64,$4F,$94,$A8,$B9,$EA,$EA,$D7,$BC,$95,$66,$2D,$19,$28,$39,$64,$8D,$A1,$C0,$C4,$AF,$AC,$A0,$B6,$D6; 20096
		dc.b $C7,$C0,$CD,$CD,$AB,$8A,$62,$37,$34,$39,$4F,$71,$69,$81,$A7,$85,$6D,$87,$9A,$7E,$66,$7C,$95,$96,$6F,$5B,$81,$98,$AC,$B9,$B2,$A7,$A5,$9B,$69,$36,$1A,$28,$4A,$57,$5D,$7B,$B3,$DD,$D7,$B3,$B8,$EB,$FB,$D6,$B1,$99,$76,$4E,$2D, $A, $E,$2F,$6A,$A3,$90,$8E,$B0,$BB; 20160
		dc.b $B9,$A6,$A8,$A1,$85,$8D,$A1,$86,$54,$36,$57,$82,$7B,$73,$80,$A9,$C7,$AF,$7A,$48,$35,$41,$3B,$1E,$11,$2E,$72,$A1,$98,$7C,$8A,$D7,$FE,$C3,$9B,$A1,$94,$66,$51,$52,$49,$51,$65,$88,$A8,$A8,$A4,$8F,$7F,$8C,$8C,$7A,$67,$76,$A9,$B9,$86,$3F,$3D,$6B,$90,$A2,$9D,$C2; 20224
		dc.b $EA,$E0,$AD,$6E,$2D,  0,  0,  3,  1,$19,$51,$A0,$F5,$E6,$9F,$B9,$E8,$E6,$BE,$6F,$56,$7A,$75,$44,$15, $C,$44,$7A,$93,$82,$6A,$9B,$C5,$B0,$8A,$6F,$87,$AE,$B0,$98,$73,$4A,$40,$54,$51,$2E,$31,$6B,$A1,$B8,$9B,$65,$48,$2C,$15,$13,$1D,$40,$7E,$B9,$D9,$DA,$C2,$A9; 20288
		dc.b $AA,$9F,$74,$73,$9A,$A1,$8B,$71,$5A,$63,$55,$38,$58,$7E,$9A,$B4,$94,$82,$91,$82,$6E,$5E,$4D,$70,$A9,$A2,$63,$47,$6E,$AB,$BC,$86,$91,$E8,$FF,$F3,$AD,$4C,$24,$4C,$6B,$3A,  0,$2A,$A5,$F4,$DC,$80,$78,$DE,$FE,$AC,$61,$6E,$D2,$FF,$E4,$73,$44,$62,$84,$65,  9,  0; 20352
		dc.b $55,$A2,$AC,$84,$52,$6A,$A4,$AD,$9D,$8E,$8A,$93,$B9,$A8,$5F,$41,$60,$8D,$AE,$A1,$70,$6C,$6C,$59,$58,$49,$30,$4C,$8F,$C9,$DC,$BB,$B4,$BD,$A4,$8C,$86,$93,$A3,$96,$8A,$74,$4B,$29,$23,$35,$41,$66,$9E,$AF,$DC,$FF,$F5,$C7,$A7,$75,$79,$88,$5E,$2E,$29,$5E,$75,$63; 20416
		dc.b $58,$64,$A2,$CC,$BB,$A9,$87,$6B,$7A,$76,$3D, $D,$1E,$51,$80,$7A,$5C,$78,$9E,$98,$88,$81,$91,$B1,$BE,$AA,$8F,$77,$6E,$81,$7E,$61,$6E,$A3,$BA,$A0,$87,$75,$66,$67,$5E,$65,$89,$8E,$83,$9F,$BD,$A5,$84,$91,$A1,$AB,$B1,$97,$76,$47,$2A,$35,$2D,$12, $C,$33,$75,$9C; 20480
		dc.b $96,$A8,$D7,$F7,$E7,$AE,$94,$AC,$A3,$84,$66,$2B,$15,$4D,$84,$69,$2E,$47,$A1,$E6,$D2,$83,$6F,$9D,$B0,$97,$6F,$49,$4B,$8E,$B7,$77,$24,$18,$4D,$76,$45,  4,$25,$5D,$6C,$67,$56,$4B,$63,$8A,$A0,$A9,$B4,$B4,$C9,$CE,$8E,$47,$33,$4F,$69,$70,$69,$76,$8A,$7B,$85,$A1; 20544
		dc.b $8A,$68,$84,$AD,$AE,$86,$59,$51,$5D,$55,$68,$81,$73,$74,$A8,$D2,$B3,$80,$64,$6D,$B1,$CD,$A6,$95,$8B,$AA,$C8,$90,$4C,$25,$40,$8B,$A8,$80,$60,$95,$DE,$C1,$80,$80,$A0,$CC,$CC,$D5,$D7,$A3,$91,$B1,$99,$4D,$2B,$36,$57,$73,$5E,$47,$66,$77,$88,$A5,$95,$77,$94,$CE; 20608
		dc.b $CB,$9D,$6F,$64,$7A,$7D,$6C,$5D,$5A,$68,$81,$8C,$6C,$56,$6C,$85,$AA,$AB,$9E,$A6,$C0,$C0,$80,$60,$6A,$6A,$88,$96,$7F,$6A,$5D,$69,$83,$6D,$54,$78,$9D,$B2,$C5,$BC,$B7,$CD,$BB,$9B,$85,$6C,$6C,$66,$69,$63,$57,$60,$64,$67,$5F,$4F,$6A,$8B,$8D,$92,$8B,$82,$71,$68; 20672
		dc.b $70,$69,$67,$8C,$A3,$95,$6D,$52,$65,$74,$65,$60,$7D,$A6,$A0,$84,$81,$98,$A8,$8F,$84,$A0,$BA,$BA,$93,$6E,$5B,$52,$52,$43,$44,$88,$D3,$E0,$B5,$8A,$8B,$98,$81,$44,$2F,$4C,$79,$8B,$5F,$3B,$2D,$44,$69,$6A,$64,$83,$CA,$EC,$C1,$78,$45,$67,$94,$82,$6B,$6C,$9C,$D5; 20736
		dc.b $BE,$7D,$5D,$58,$7A,$92,$80,$6A,$6F,$90,$93,$4E,$32,$51,$60,$7F,$8F,$A0,$C1,$C0,$A1,$73,$37,  4,  0,  0,  2,$32,$6D,$9F,$A0,$70,$79,$91,$82,$71,$79,$A4,$C4,$BB,$98,$78,$5B,$3D,$45,$63,$6B,$72,$98,$B4,$A8,$90,$72,$6F,$8F,$94,$7A,$6A,$7B,$8E,$8F,$77,$4E,$55; 20800
		dc.b $A0,$E0,$D3,$A6,$98,$9F,$8A,$4D,$1A,$22,$47,$83,$C8,$D3,$D1,$D8,$C9,$C6,$92,$44,$4E,$78,$A4,$BC,$A0,$98,$98,$83,$68,$48,$4E,$78,$B8,$DC,$D4,$CC,$C4,$AD,$9B,$73,$47,$4E,$74,$83,$78,$69,$55,$52,$64,$83,$96,$97,$9A,$9E,$96,$85,$55,$39,$4D,$6E,$9F,$BC,$C2,$B0; 20864
		dc.b $90,$95,$7E,$38,$1F,$5D,$AD,$C9,$B4,$9B,$9F,$8F,$5D,$3E,$3F,$44,$6A,$B0,$BD,$A7,$AA,$B0,$AC,$97,$7C,$68,$75,$8F,$92,$87,$8B,$89,$92,$B0,$AB,$99,$91,$95,$91,$70,$40,$26,$2D,$3D,$4F,$58,$7B,$96,$83,$6A,$65,$79,$79,$77,$A0,$D2,$E0,$D4,$BB,$92,$58,$30,$2C,$23; 20928
		dc.b $20,$4B,$9D,$CD,$C3,$BA,$AA,$9F,$98,$75,$58,$6A,$8D,$A9,$A6,$82,$77,$89,$A2,$A5,$8A,$6A,$69,$71,$61,$3F,$27,$39,$60,$7B,$88,$8A,$78,$79,$83,$7D,$69,$62,$7D,$B9,$C7,$95,$75,$6C,$4B,$2A,$25,$35,$59,$97,$DC,$F6,$E9,$D9,$D2,$C4,$92,$51,$2A,$36,$61,$73,$5E,$47; 20992
		dc.b $4B,$67,$85,$7A,$55,$59,$91,$AB,$8F,$5A,$35,$4F,$77,$74,$5F,$5A,$7B,$92,$75,$52,$33,$42,$80,$9C,$A9,$9C,$85,$9E,$8D,$47,$15,$24,$60,$98,$BC,$CD,$CA,$BB,$A9,$81,$45,$21,$32,$66,$95,$9B,$9C,$A6,$97,$89,$77,$6E,$86,$93,$AF,$B2,$8E,$82,$57,$39,$45,$45,$63,$92; 21056
		dc.b $B1,$B7,$9D,$9A,$BF,$B3,$96,$A3,$CB,$F6,$DD,$AB,$99,$65,$2F,$1B,$1E,$3D,$71,$B0,$EB,$E6,$B6,$98,$86,$7A,$6E,$63,$84,$BE,$E4,$E5,$BA,$74,$44,$3F,$45,$2F,$2F,$6D,$9E,$B1,$A2,$65,$44,$54,$78,$7C,$7B,$A4,$BB,$D4,$D0,$A1,$7F,$62,$6D,$9A,$8F,$69,$7A,$7D,$51,$39; 21120
		dc.b $32,$41,$67,$90,$C4,$E6,$CF,$BB,$C5,$AE,$92,$70,$4F,$73,$A3,$AD,$8C,$5E,$50,$5D,$73,$65,$52,$8F,$D6,$E5,$D8,$91,$58,$52,$47,$32,$13,$2A,$69,$A4,$B2,$8A,$65,$70,$90,$9E,$90,$69,$78,$C5,$BE,$72,$3A,$3E,$86,$B3,$A0,$91,$9D,$AD,$BC,$98,$4E,$3D,$5E,$90,$A8,$93; 21184
		dc.b $85,$98,$A0,$87,$63,$69,$90,$AA,$A3,$8C,$80,$73,$4C,$1C,$14,$22,$45,$78,$90,$91,$A0,$B0,$AF,$90,$66,$65,$81,$A5,$8C,$5A,$63,$67,$54,$4D,$40,$56,$8A,$BE,$D9,$C9,$A1,$99,$CE,$D4,$A0,$7A,$81,$A7,$B2,$85,$41,$19,$28,$51,$5E,$45,$3F,$7C,$A9,$87,$3F, $E,$11,$39; 21248
		dc.b $6C,$72,$83,$C3,$DD,$CC,$A2,$6C,$54,$53,$4F,$5D,$72,$70,$73,$74,$4F,$3C,$47,$55,$6E,$86,$AE,$CD,$B4,$8C,$9E,$B0,$95,$7D,$71,$79,$96,$8C,$64,$47,$40,$5F,$8B,$9D,$91,$9F,$C3,$B3,$81,$49,$26,$36,$5E,$79,$82,$97,$AC,$C0,$BA,$85,$6D,$77,$8F,$AC,$B6,$BF,$C5,$DD; 21312
		dc.b $D5,$72,$29,$32,$69,$90,$76,$7E,$BA,$DC,$D8,$A5,$65,$6E,$94,$98,$7B,$62,$74,$9E,$A1,$61,$3E,$71,$C2,$DE,$BE,$8D,$79,$7E,$51,$14,  0,$1A,$64,$AB,$CA,$B8,$AF,$BC,$B4,$88,$53,$5A,$A0,$D1,$B0,$87,$85,$5F,$28,$1C,$18,$33,$6A,$AC,$E3,$E9,$D7,$DF,$DE,$B5,$78,$45; 21376
		dc.b $4F,$8F,$A4,$6B,$52,$5E,$86,$9F,$80,$70,$7D,$A5,$B5,$82,$36,$11,$37,$73,$68,$65,$93,$C3,$DE,$BE,$7F,$51,$55,$74,$7A,$79,$89,$87,$8D,$8C,$41,$16,$25,$51,$86,$A6,$D5,$FD,$FF,$F1,$C3,$A8,$86,$4B,$3B,$45,$59,$70,$6C,$72,$82,$8E,$9D,$A7,$8D,$7C,$8C,$83,$67,$47; 21440
		dc.b $42,$58,$60,$76,$7C,$7B,$73,$69,$75,$57,$50,$7C,$97,$B3,$B8,$9D,$7F,$87,$6A,$1D,$14,$38,$64,$9C,$B9,$C8,$D8,$D0,$BE,$9A,$7C,$76,$7F,$88,$73,$6D,$93,$92,$73,$60,$4E,$7A,$A3,$86,$61,$43,$38,$4A,$34,$12, $F,$3D,$90,$9A,$7A,$6F,$7A,$92,$91,$8E,$95,$B7,$DA,$D8; 21504
		dc.b $A6,$6A,$42,$15,  0,  0,$18,$49,$84,$B8,$D5,$D0,$AE,$86,$89,$97,$7D,$70,$8F,$B0,$B6,$8B,$50,$2B,$3A,$69,$74,$78,$95,$BE,$CF,$A7,$6E,$51,$47,$53,$64,$60,$7C,$A4,$A5,$98,$7E,$82,$A8,$BC,$C4,$CB,$D3,$B5,$92,$72,$35,$15,$20,$58,$A0,$DB,$FF,$F6,$F1,$E1,$AE,$87; 21568
		dc.b $56,$3A,$6C,$8C,$8E,$7A,$3C,$43,$67,$76,$81,$7F,$A7,$D9,$E9,$C2,$83,$61,$53,$43,$3B,$49,$5C,$78,$8D,$94,$89,$75,$92,$C4,$CF,$AD,$A1,$9F,$7D,$61,$44,$22,$22,$34,$61,$99,$AC,$B0,$BC,$CB,$AA,$90,$B0,$B0,$9C,$A2,$A3,$A6,$88,$4B,$3E,$4C,$63,$85,$92,$92,$97,$A3; 21632
		dc.b $86,$52,$33,$27,$34,$5A,$70,$77,$89,$8E,$88,$8C,$9C,$BD,$CC,$C8,$C2,$BC,$9B,$5D,$30,$18,$1E,$35,$4B,$68,$A5,$DF,$E6,$DA,$AE,$8A,$AC,$CA,$B2,$89,$78,$95,$A8,$5F,$14,$1D,$59,$82,$89,$93,$85,$92,$B4,$92,$5C,$29,$22,$53,$75,$6E,$5A,$66,$77,$79,$76,$76,$7E,$95; 21696
		dc.b $C0,$BC,$8E,$78,$6B,$52,$38,$22,$2A,$5C,$9A,$CA,$B9,$A7,$BA,$B6,$9B,$8E,$9B,$AE,$AA,$A2,$9F,$74,$38,$21,$29,$38,$40,$67,$B3,$BD,$A6,$96,$68,$43,$28,$1D,$2C,$41,$50,$6D,$76,$62,$73,$A1,$C8,$D4,$D1,$C0,$AB,$96,$60,$2D,  6,  0,$26,$4F,$6C,$84,$99,$AD,$BB,$97; 21760
		dc.b $7B,$7D,$96,$BF,$B7,$98,$94,$A0,$84,$40,$1F,$33,$5C,$7C,$8A,$93,$A8,$B7,$A1,$7E,$59,$36,$41,$71,$7C,$72,$77,$87,$98,$A0,$B0,$B7,$B0,$C1,$BD,$A6,$8D,$6B,$58,$4A,$50,$6B,$7C,$99,$BF,$C4,$B0,$8C,$7B,$A9,$C2,$CE,$DA,$CA,$BF,$B5,$81,$34,  0,  0,$46,$85,$95,$9A; 21824
		dc.b $BC,$D1,$B5,$91,$55,$1F,$25,$55,$7A,$69,$51,$68,$A1,$C1,$AE,$9D,$A1,$C2,$D8,$AC,$71,$51,$4F,$5A,$4E,$2F,$30,$6B,$95,$8A,$73,$7E,$A5,$BA,$CA,$CF,$DF,$F5,$D3,$BC,$9C,$50,$28,$1F,$33,$5C,$83,$A4,$A3,$A5,$A5,$8B,$66,$29,$15,$36,$58,$73,$71,$6C,$8C,$AA,$93,$7E; 21888
		dc.b $97,$B1,$C2,$B4,$A9,$A1,$92,$65,$39,$48,$66,$6D,$61,$53,$7C,$BD,$CC,$C6,$BC,$CB,$F7,$F2,$B6,$6B,$55,$58,$3F,$15,  0,$3E,$97,$C0,$C2,$AB,$97,$98,$97,$67,$27, $B,$29,$6E,$84,$61,$47,$64,$94,$9C,$92,$93,$8B,$96,$B2,$A2,$79,$55,$44,$52,$5B,$4C,$47,$5C,$87,$AD; 21952
		dc.b $B4,$B7,$CC,$DC,$D2,$B4,$A2,$98,$7F,$70,$46,$21,$3A,$6A,$7F,$79,$82,$8D,$86,$5D,$30,$33,$57,$54,$32,$54,$7A,$80,$74,$66,$70,$82,$A5,$CA,$D6,$C0,$B5,$AA,$85,$61,$31,$13,$16,$26,$3D,$55,$58,$66,$9D,$C3,$C5,$C2,$CC,$C9,$B0,$93,$78,$60,$58,$55,$60,$6E,$70,$78; 22016
		dc.b $7F,$6F,$5D,$59,$65,$82,$99,$97,$68,$5A,$8A,$A0,$6D,$3C,$54,$8E,$B6,$C5,$C2,$C2,$C5,$C6,$AA,$61,$3A,$46,$68,$75,$5F,$68,$8C,$A0,$B2,$AF,$A0,$AB,$CF,$ED,$C5,$88,$8F,$C4,$C3,$85,$4D,$4B,$75,$77,$4F,$4F,$5C,$6D,$A3,$A7,$8A,$A5,$A5,$6C,$49,$50,$3F,$25,$29,$4E; 22080
		dc.b $92,$C9,$DD,$EC,$E8,$D0,$BB,$90,$55,$34,$3A,$53,$4F,$4A,$62,$73,$72,$7D,$8C,$9D,$A7,$BB,$D1,$D4,$C1,$BE,$CD,$AB,$75,$68,$62,$55,$44,$44,$63,$6E,$77,$8F,$90,$94,$9D,$76,$38,$22,$37,$3E,$36,$49,$81,$B4,$DD,$E6,$CE,$B7,$A3,$8F,$6E,$3C,$3C,$62,$86,$84,$6C,$71; 22144
		dc.b $7D,$83,$89,$99,$B2,$D3,$F2,$FC,$D6,$9A,$9F,$AE,$6A,$22,$26,$3C,$41,$38,$32,$5F,$97,$B1,$C7,$BD,$AA,$9E,$76,$34,$1A,$28,$2E,$41,$65,$93,$BA,$C7,$B6,$9E,$8C,$7B,$72,$69,$53,$5B,$86,$8E,$62,$42,$46,$50,$64,$7F,$AD,$DB,$E9,$ED,$ED,$BA,$7C,$6F,$76,$63,$46,$53; 22208
		dc.b $6C,$6C,$5F,$56,$60,$63,$63,$73,$8A,$84,$59,$42,$52,$5B,$49,$33,$4B,$8A,$AB,$B7,$B7,$B0,$B7,$BA,$B5,$9C,$7D,$56,$50,$68,$46, $F, $A,$1F,$49,$79,$93,$A8,$C1,$DE,$F1,$DA,$94,$59,$6F,$8D,$69,$49,$56,$73,$82,$67,$49,$52,$63,$6A,$76,$8A,$9C,$94,$7A,$6C,$6A,$59; 22272
		dc.b $45,$5C,$87,$A3,$C0,$C8,$C6,$C0,$BA,$B3,$9C,$77,$46,$4C,$86,$7D,$47,$41,$63,$86,$97,$B3,$D0,$D6,$E7,$EA,$C2,$8B,$77,$A7,$B3,$8A,$8A,$88,$79,$61,$33,$37,$59,$75,$96,$9D,$AA,$B3,$A2,$76,$46,$2C,$1E,$30,$4C,$6D,$8B,$AB,$DF,$F8,$DE,$C1,$B4,$A7,$78,$32,$3B,$6A; 22336
		dc.b $54,$31,$3D,$5D,$86,$93,$89,$9B,$B3,$BB,$BB,$B9,$B9,$B3,$C5,$C5,$8F,$70,$64,$53,$37,$22,$4D,$7A,$8A,$92,$9E,$A7,$8F,$69,$4B,$33,$23,$26,$36,$5C,$90,$AE,$BD,$CB,$D1,$C3,$AF,$9B,$74,$4E,$60,$95,$94,$64,$41,$5C,$7C,$72,$6E,$85,$AE,$DB,$F4,$E3,$D6,$CB,$AF,$9D; 22400
		dc.b $7E,$4E,$38,$34,$38,$3F,$46,$5F,$85,$A6,$AB,$B3,$A4,$83,$67,$45,$3B,$31,$2C,$4E,$82,$9E,$AA,$BC,$C9,$B8,$97,$8F,$91,$72,$47,$45,$79,$83,$52,$3A,$44,$5D,$73,$7D,$89,$A2,$CF,$F0,$EB,$D3,$A6,$7F,$81,$79,$50,$3B,$40,$59,$68,$64,$63,$66,$68,$71,$78,$60,$4F,$5E; 22464
		dc.b $71,$6F,$65,$44,$3E,$73,$94,$A2,$A6,$B7,$D6,$D5,$BA,$9E,$80,$53,$4A,$67,$3D,$10,$20,$37,$4D,$5A,$74,$A5,$C1,$D1,$D7,$D1,$BD,$96,$74,$6B,$6F,$59,$4C,$65,$70,$68,$61,$52,$5C,$5E,$5E,$73,$82,$8D,$95,$87,$6D,$55,$41,$58,$77,$7C,$95,$C9,$F0,$E4,$C9,$BA,$AF,$8A; 22528
		dc.b $52,$47,$55,$51,$54,$4D,$58,$77,$81,$99,$BB,$BF,$CC,$DF,$D8,$C2,$9E,$A4,$BB,$B2,$93,$7C,$79,$69,$52,$38,$28,$46,$74,$97,$AE,$A0,$96,$90,$69,$43,$18,  6,$34,$6C,$94,$BA,$D9,$F5,$F5,$DD,$B9,$8A,$5A,$37,$51,$74,$5F,$3E,$34,$52,$71,$6B,$6F,$87,$B3,$D9,$E6,$D9; 22592
		dc.b $BB,$A6,$AA,$B4,$A2,$71,$61,$6A,$62,$4F,$3D,$40,$61,$92,$A1,$8F,$90,$93,$82,$5F,$2F,$12,$18,$47,$7E,$A4,$C7,$ED,$F6,$D9,$AF,$84,$6B,$43,$38,$70,$94,$87,$5E,$4F,$69,$81,$83,$7D,$96,$C4,$ED,$F9,$E0,$BA,$9C,$8B,$7F,$62,$37,$2D,$42,$52,$60,$62,$62,$73,$9C,$B6; 22656
		dc.b $A2,$94,$87,$6B,$51,$32,$18,$22,$59,$9B,$BD,$BE,$BC,$C9,$CA,$A7,$8C,$80,$55,$43,$6C,$79,$57,$39,$3C,$5E,$6B,$62,$7B,$A1,$C8,$E9,$E4,$CF,$AC,$8D,$8F,$90,$64,$3E,$55,$6D,$59,$45,$43,$50,$70,$80,$78,$66,$57,$5A,$64,$52,$45,$40,$50,$7E,$A7,$C6,$D8,$CD,$C8,$D8; 22720
		dc.b $CD,$A4,$6C,$27,$2A,$60,$50,$14,  0,$21,$5B,$7B,$7A,$85,$BB,$EE,$EF,$D4,$B4,$95,$8D,$94,$8D,$63,$47,$49,$54,$58,$49,$38,$36,$60,$86,$87,$91,$95,$86,$73,$6C,$57,$3D,$4E,$78,$A4,$CE,$DE,$D6,$D4,$CA,$BB,$AA,$71,$3F,$53,$6C,$6A,$45,$30,$54,$7A,$91,$A1,$B0,$C8; 22784
		dc.b $DE,$E4,$D8,$B3,$86,$7A,$9F,$B0,$9E,$89,$7C,$8C,$93,$75,$43,$32,$6B,$9F,$A0,$8E,$73,$5D,$57,$49,$12,  0,$33,$6F,$A0,$BE,$D4,$FF,$FF,$EF,$C8,$94,$61,$5A,$5F,$43,$35,$38,$42,$52,$5A,$5F,$7C,$95,$BA,$DD,$E1,$D7,$BB,$AD,$B2,$AE,$93,$78,$73,$77,$61,$50,$47,$3C; 22848
		dc.b $56,$7E,$7F,$75,$8A,$9F,$79,$51,$4A,$2E,$32,$56,$77,$A5,$D3,$F2,$F7,$DF,$C7,$AB,$74,$29, $F,$41,$54,$4A,$3C,$4B,$8B,$B4,$C0,$C4,$C0,$D6,$F1,$E4,$AA,$74,$6C,$89,$8C,$58,$2B,$35,$56,$5B,$46,$26,$42,$8E,$AC,$B7,$C2,$BA,$A7,$79,$4C,$1F,  0,$24,$5D,$82,$A6,$D1; 22912
		dc.b $E8,$DB,$CD,$C9,$9D,$59,$36,$53,$68,$4E,$3A,$32,$59,$7B,$76,$82,$A0,$B9,$D9,$DF,$B8,$9A,$98,$8F,$7D,$74,$73,$78,$6E,$5F,$4D,$42,$45,$53,$5E,$5B,$6F,$9A,$8D,$3C,$1D,$3B,$42,$49,$53,$74,$B9,$EE,$FF,$FF,$D9,$CC,$D2,$95,$3F,$13,$25,$39,$2A,  0,  0,$29,$64,$8B; 22976
		dc.b $A2,$BA,$DC,$F9,$EB,$C3,$A5,$88,$8A,$9F,$91,$6B,$4C,$4D,$51,$3A,$20,$21,$3F,$59,$78,$A5,$AC,$7D,$64,$72,$62,$39,$3D,$6A,$A0,$C7,$DF,$E5,$DE,$DF,$D6,$A8,$5A,$45,$68,$54,$29,$1C,$29,$58,$82,$85,$9E,$CA,$FA,$FF,$E3,$B0,$B8,$CD,$8A,$3C,$46,$72,$A9,$A2,$76,$7A; 23040
		dc.b $84,$A7,$A8,$67,$49,$75,$B5,$AA,$51,$21,$3E,$4D,$45,$3A,$3C,$67,$A6,$D7,$E1,$DC,$E8,$F2,$CD,$8F,$7F,$73,$4B,$36,$24,$17,$22,$41,$6A,$99,$C6,$E2,$D8,$BA,$AF,$B1,$89,$5B,$76,$B1,$BC,$9F,$8C,$8D,$82,$63,$3B,$37,$40,$57,$8B,$7C,$50,$61,$86,$7E,$35,$26,$5B,$85; 23104
		dc.b $AF,$CB,$CE,$E2,$FF,$FF,$BE,$67,$5C,$7A,$59, $F,  0,$12,$3A,$5C,$7D,$8B,$BE,$FF,$FF,$F5,$C7,$C8,$D9,$9B,$50,$45,$5C,$6B,$56,$4A,$4C,$4D,$53,$4A,$3E,$3E,$6A,$B4,$BC,$A0,$9A,$8B,$78,$63,$51,$50,$6D,$9C,$B9,$C8,$D6,$D2,$AD,$83,$71,$74,$53,$2F,$2D,$40,$49,$42; 23168
		dc.b $50,$72,$9A,$D2,$EA,$C6,$C0,$D8,$D5,$9D,$46,$3D,$70,$89,$72,$4D,$48,$66,$70,$63,$42,$3C,$6D,$8F,$78,$51,$45,$45,$40,$43,$56,$60,$71,$9A,$CD,$E7,$E5,$E7,$D6,$B7,$A1,$92,$88,$5F,$34,$28, $C,  0,  0,$1F,$59,$81,$A5,$C4,$D9,$E3,$E3,$D6,$A3,$7E,$82,$85,$82,$70; 23232
		dc.b $5C,$5F,$5A,$4C,$4C,$51,$4F,$4B,$6A,$7C,$60,$53,$4C,$42,$50,$6E,$92,$A9,$BB,$DB,$FB,$F0,$C6,$AA,$A0,$8E,$86,$7E,$52,$33,$29,$2E,$33,$29,$40,$82,$BC,$DC,$F4,$FF,$FF,$FF,$DE,$91,$41,$35,$6E,$97,$A1,$72,$51,$73,$A4,$9C,$5C,$2E,$54,$AD,$C0,$81,$41,$55,$8C,$90; 23296
		dc.b $61,$3A,$5A,$A4,$E6,$E4,$B2,$A9,$C0,$B3,$90,$84,$60,$40,$42,$41,$2A,$15,$2B,$6C,$A3,$C3,$D8,$D7,$CC,$D5,$C9,$88,$5A,$63,$85,$8D,$7B,$82,$9A,$8D,$7C,$71,$63,$5B,$53,$6D,$72,$5C,$66,$6C,$4F,$36,$3C,$59,$7A,$9F,$CD,$EC,$EF,$FA,$F0,$B8,$89,$93,$8C,$42, $F, $B; 23360
		dc.b $36,$64,$6A,$56,$53,$86,$C0,$C9,$9F,$98,$D8,$FF,$D6,$97,$8C,$97,$9F,$80,$50,$2D,$22,$36,$50,$5A,$47,$58,$A1,$B9,$8B,$58,$42,$48,$5A,$6C,$78,$82,$BA,$F8,$FF,$F6,$C0,$9B,$83,$74,$5E,$21, $D,$33,$49,$41,$46,$53,$60,$85,$B0,$B7,$B4,$C2,$E2,$E9,$C7,$97,$8F,$A6; 23424
		dc.b $88,$5B,$3C,$22,$2A,$3A,$36,$46,$5B,$6C,$86,$99,$88,$50,$3B,$36,$2E,$4E,$68,$8D,$C9,$E9,$FF,$F7,$BB,$7D,$67,$6E,$6E,$59,$4E,$75,$8A,$6E,$48,$36,$34,$45,$5B,$67,$77,$97,$C3,$E6,$D9,$C5,$BC,$A5,$98,$77,$53,$4E,$52,$4E,$56,$6C,$6D,$65,$74,$8A,$7D,$50,$2A,$2A; 23488
		dc.b $32,$3A,$5A,$7A,$A1,$CF,$E2,$EE,$ED,$D0,$B3,$92,$80,$83,$7B,$5E,$44,$50,$57,$46,$2E,$2F,$53,$7B,$94,$B5,$D5,$EE,$FF,$FF,$D5,$BB,$AB,$A4,$8D,$62,$60,$6D,$69,$73,$5E,$39,$4A,$6A,$63,$63,$58,$51,$72,$72,$7E,$A2,$A1,$AF,$DF,$E7,$E4,$DB,$B9,$91,$7F,$81,$6B,$53; 23552
		dc.b $3A,$3F,$4B,$2D,$1C,$26,$41,$6B,$8C,$96,$9D,$D1,$FD,$EE,$D4,$BF,$A9,$9F,$93,$77,$63,$5D,$58,$55,$5C,$59,$50,$74,$82,$75,$7D,$64,$43,$4B,$5E,$6C,$70,$6B,$95,$BD,$D6,$F5,$D5,$AC,$B5,$C1,$8E,$4D,$4F,$66,$76,$7A,$56,$3A,$4A,$7C,$8C,$5B,$45,$78,$BC,$D0,$B3,$A2; 23616
		dc.b $B5,$BB,$B5,$AC,$80,$55,$5F,$7A,$6C,$3C,$2E,$6B,$A3,$93,$73,$69,$59,$51,$61,$56,$48,$62,$90,$CA,$F3,$E3,$D0,$C8,$AC,$A4,$82,$4A,$3B,$51,$5A,$51,$3F,$2C,$38,$5C,$74,$5C,$51,$89,$BB,$D2,$DC,$D9,$E9,$E9,$C0,$A7,$88,$59,$4E,$2E,$15,$26,$22,$44,$7A,$78,$5F,$54; 23680
		dc.b $40,$37,$50,$6E,$90,$91,$90,$CC,$F6,$E2,$B7,$99,$8D,$9D,$8D,$51,$36,$46,$64,$63,$3B,$26,$43,$67,$6F,$4D,$3E,$73,$AC,$BD,$C6,$C5,$D0,$F0,$D8,$A1,$83,$73,$61,$54,$48,$47,$49,$46,$60,$6E,$5E,$51,$54,$57,$52,$60,$70,$72,$82,$A4,$C4,$CE,$C0,$B3,$AB,$A4,$9D,$85; 23744
		dc.b $6F,$68,$6E,$6F,$58,$60,$5D,$41,$4A,$59,$55,$51,$75,$AF,$DA,$EC,$E1,$D1,$DC,$EF,$D5,$AB,$84,$78,$A0,$93,$4D,$19,$24,$53,$62,$3D,$24,$54,$8E,$9F,$83,$6F,$82,$B2,$C3,$97,$9C,$D1,$E1,$DA,$C3,$A2,$96,$8D,$66,$4B,$46,$40,$50,$44,$33,$40,$4E,$66,$6F,$75,$93,$B0; 23808
		dc.b $CD,$D3,$D2,$DF,$D9,$C3,$A2,$8B,$7A,$69,$61,$4B,$40,$4F,$52,$65,$63,$4F,$61,$62,$65,$75,$74,$77,$99,$BC,$B8,$B0,$98,$99,$CE,$DC,$B3,$76,$48,$5C,$9D,$8F,$35,$24,$70,$B7,$9F,$41,$1D,$5F,$A0,$9C,$7B,$7E,$BA,$FF,$FF,$CA,$82,$8B,$A5,$7C,$39,  5,$15,$47,$47,$5A; 23872
		dc.b $7D,$7F,$8B,$99,$93,$8A,$7E,$7F,$88,$90,$B0,$C9,$C9,$BA,$B0,$C4,$B3,$69,$33,$29,$3D,$45,$41,$3C,$47,$69,$6F,$63,$53,$49,$72,$93,$A3,$D1,$ED,$F3,$FF,$F4,$C3,$82,$5D,$54,$4E,$32, $C,$16,$36,$58,$81,$6B,$17,$1B,$59,$6D,$70,$60,$82,$C8,$D9,$DC,$DA,$C5,$AE,$B0; 23936
		dc.b $AC,$75,$3F,$3B,$46,$45,$48,$4D,$5B,$6B,$68,$6A,$4E,$19,$2E,$64,$78,$92,$AC,$D2,$FF,$FF,$F1,$BB,$79,$68,$78,$58,$27,$2B,$6D,$87,$75,$64,$43,$44,$5C,$5A,$50,$47,$77,$9F,$9A,$A6,$B0,$BB,$BE,$A2,$A1,$A5,$7D,$77,$8C,$82,$6E,$66,$6E,$73,$67,$53,$47,$21,$20,$61; 24000
		dc.b $9F,$B0,$CB,$FE,$FF,$FF,$EA,$AE,$92,$7C,$6D,$7A,$5B,$5B,$95,$9D,$7E,$45,$2D,$4D,$54,$3D,$44,$6A,$A3,$D3,$D0,$C6,$C2,$C7,$CE,$AE,$8C,$93,$93,$87,$87,$74,$54,$45,$5B,$7B,$74,$3F,$2C,$39,$3F,$5C,$78,$8E,$A9,$DB,$FF,$FF,$DE,$C5,$C5,$A4,$69,$48,$54,$5D,$6A,$75; 24064
		dc.b $61,$36,$25,$3C,$50,$51,$5B,$6A,$93,$C8,$CE,$C2,$B5,$9B,$8B,$87,$74,$77,$8C,$94,$B2,$B1,$7F,$60,$61,$62,$63,$49,$36,$4A,$58,$5A,$6D,$9E,$BC,$C0,$DB,$EF,$EA,$D6,$B4,$81,$5F,$54,$5F,$5E,$42,$52,$76,$72,$55,$2E,$39,$68,$71,$70,$7D,$A6,$D7,$D5,$B2,$92,$91,$A1; 24128
		dc.b $99,$87,$8C,$A6,$AB,$9D,$84,$59,$44,$51,$5F,$4B,$2F,$3B,$4B,$56,$55,$62,$8E,$93,$B3,$EF,$F2,$E1,$CD,$BE,$A6,$8F,$74,$58,$5C,$62,$58,$3C,$12, $B,$2B,$44,$37,$2F,$5C,$86,$A4,$A6,$83,$8B,$AE,$B7,$A9,$8F,$85,$AF,$CA,$AB,$8A,$6A,$59,$5E,$69,$58,$2B,$11,$2D,$54; 24192
		dc.b $59,$3E,$47,$82,$B3,$D4,$D1,$C1,$C7,$DF,$E0,$AD,$6C,$44,$58,$7C,$69,$33,$28,$4B,$73,$73,$3F,$21,$4E,$96,$BA,$A0,$80,$A3,$C8,$C5,$AB,$80,$61,$87,$B0,$8D,$61,$5C,$68,$5E,$4C,$4F,$5E,$5D,$60,$87,$92,$78,$6C,$84,$A7,$BA,$CC,$D8,$E0,$EB,$DE,$BD,$97,$6F,$48,$3C; 24256
		dc.b $54,$4F,$4C,$4E,$5A,$6C,$5C,$55,$5E,$6E,$96,$A5,$AE,$D4,$DF,$E4,$DE,$B5,$8E,$86,$9B,$84,$55,$46,$53,$6A,$66,$50,$66,$81,$7A,$74,$62,$4C,$51,$5D,$79,$9E,$B0,$BF,$E5,$FF,$DE,$B7,$A4,$8B,$79,$5C,$53,$78,$85,$7A,$6F,$56,$4D,$42,$27,$2E,$52,$71,$82,$9E,$BD,$CE; 24320
		dc.b $D4,$C1,$9E,$7E,$85,$A4,$84,$4D,$58,$88,$90,$68,$61,$7E,$84,$73,$58,$47,$4F,$4F,$58,$8A,$B6,$CA,$DF,$E5,$D2,$C8,$B6,$89,$67,$4D,$4A,$77,$91,$75,$62,$70,$7A,$4E,$17,$12,$33,$6A,$84,$9F,$CE,$ED,$FF,$FF,$C4,$84,$77,$8C,$72,$39,$45,$6F,$82,$68,$51,$4E,$49,$52; 24384
		dc.b $55,$50,$75,$91,$87,$96,$BD,$D9,$D2,$C5,$BA,$BA,$BA,$8E,$69,$59,$4F,$57,$65,$60,$5A,$6B,$68,$36,$10, $C,$1F,$3B,$55,$7F,$AF,$DC,$FC,$F2,$BF,$81,$5B,$54,$4D,$2F,$39,$78,$AF,$B2,$89,$67,$62,$63,$62,$4D,$3C,$56,$90,$BB,$B7,$B0,$AB,$B2,$B5,$89,$62,$52,$5A,$7A; 24448
		dc.b $81,$62,$69,$A6,$BD,$96,$69,$3F,$35,$2E,$1E,$32,$51,$7D,$B0,$CE,$D5,$D9,$CE,$9D,$61,$59,$6B,$55,$4C,$67,$92,$96,$70,$60,$5D,$52,$50,$5F,$5C,$67,$9B,$BC,$B8,$AC,$C2,$D4,$BC,$9C,$90,$89,$74,$79,$99,$98,$87,$9C,$B7,$99,$5F,$26,  8,  7,  2,$14,$46,$87,$CB,$FF; 24512
		dc.b $FF,$FF,$ED,$D2,$8F,$4E,$4A,$55,$78,$B6,$BE,$A6,$89,$6D,$54,$2F, $A, $E,$3F,$70,$99,$B7,$BD,$BF,$CF,$D4,$B0,$7D,$7E,$A1,$97,$86,$89,$9C,$A6,$9B,$9E,$90,$68,$40,$2E,$2A,$18,$1F,$54,$85,$B0,$DA,$E4,$D6,$C5,$AB,$7A,$45,$43,$55,$63,$88,$A3,$AC,$A5,$82,$5D,$45; 24576
		dc.b $32,$30,$59,$85,$B0,$DB,$E8,$D8,$C1,$A9,$7B,$48,$2D,$35,$52,$71,$93,$CD,$DE,$C6,$B7,$98,$71,$4B,$27,$19,$2C,$49,$68,$9E,$C9,$E0,$F2,$E0,$C6,$B1,$7B,$4A,$51,$6A,$70,$86,$A0,$B3,$AE,$84,$55,$30,$19,$14,$34,$5D,$81,$AC,$CF,$E1,$CF,$9F,$85,$7C,$5F,$61,$89,$9B; 24640
		dc.b $A2,$B9,$BD,$A4,$82,$61,$47,$20,  0,  0,  6,$24,$43,$6E,$9F,$C0,$D4,$BE,$9B,$92,$7C,$55,$48,$6E,$84,$8D,$BC,$B8,$90,$69,$31,$16, $C,  0,$24,$65,$9C,$DC,$FC,$F1,$CB,$9E,$7E,$63,$36,$35,$72,$A5,$BB,$C0,$BC,$B4,$A4,$74,$46,$23,  0,  2,$20,$3B,$5A,$79,$B1,$E0; 24704
		dc.b $E2,$CE,$9F,$8F,$84,$5D,$4F,$6A,$7C,$88,$B2,$B5,$84,$52,$36,$2D,$20, $C,$2F,$6E,$A7,$E0,$EA,$D5,$B5,$94,$77,$4D,$40,$4F,$85,$D3,$E9,$E5,$EC,$E4,$BE,$7D,$47,$19,  3,$11,$21,$41,$6D,$8C,$BA,$E0,$CC,$AB,$8E,$85,$87,$76,$70,$A3,$D7,$C8,$CD,$D3,$A6,$7F,$52,$27; 24768
		dc.b $1F,$13,$28,$71,$AD,$CC,$D9,$DC,$BD,$7F,$50,$24,$1F,$42,$68,$AC,$D9,$E8,$F7,$E4,$B8,$85,$4C,$2F,$2B,$34,$48,$58,$7C,$A0,$B3,$BF,$9A,$77,$7A,$6F,$78,$83,$86,$A4,$D4,$C2,$90,$8D,$82,$56,$29,$17,$2E,$52,$5B,$84,$C6,$E3,$E4,$CC,$9D,$68,$4B,$31,$2D,$4E,$6D,$AB; 24832
		dc.b $ED,$EE,$D6,$C5,$A5,$6D,$32, $F,  8,$20,$49,$66,$7D,$99,$BF,$DA,$C0,$96,$8F,$7D,$8A,$A5,$A0,$A0,$D0,$E3,$AC,$8D,$77,$4F,$28, $D,$19,$3B,$3D,$5A,$AF,$E0,$D7,$B9,$AB,$8C,$66,$45,$43,$7A,$98,$AC,$DD,$E6,$C0,$9E,$85,$5C,$24,$11,$21,$37,$4F,$61,$75,$7D,$77,$6C; 24896
		dc.b $6D,$60,$51,$64,$88,$AF,$BE,$AD,$C3,$D9,$9E,$68,$4F,$32,$1E,$16,$19,$3A,$67,$7C,$A0,$D2,$D0,$A7,$8D,$73,$5B,$48,$40,$75,$A7,$BA,$DB,$EF,$E4,$B9,$93,$74,$41,$30,$42,$4B,$5E,$71,$75,$6F,$5E,$59,$5C,$62,$5C,$69,$90,$B1,$C8,$C6,$B7,$C5,$AA,$6E,$50,$3C,$3F,$44; 24960
		dc.b $3D,$50,$68,$7B,$84,$89,$88,$7D,$78,$71,$5C,$5D,$73,$92,$C1,$D4,$D1,$D1,$C9,$A4,$77,$5D,$55,$54,$62,$81,$91,$96,$90,$7C,$64,$58,$54,$48,$4E,$70,$97,$BE,$DD,$E2,$DD,$D2,$BA,$8D,$5B,$41,$46,$5E,$70,$76,$8C,$AD,$A9,$A5,$8F,$6E,$69,$5D,$5A,$68,$69,$83,$BA,$D2; 25024
		dc.b $BE,$A7,$A2,$91,$71,$50,$4C,$74,$8E,$94,$9D,$92,$81,$68,$4B,$38,$34,$45,$5A,$7D,$9A,$B2,$C8,$CC,$B8,$A0,$82,$69,$6D,$5C,$5A,$7A,$99,$A1,$97,$8E,$7A,$6D,$65,$57,$51,$5C,$73,$94,$A0,$A6,$BE,$D1,$C6,$A4,$88,$7B,$75,$67,$56,$6E,$9E,$A0,$9B,$94,$79,$66,$50,$38; 25088
		dc.b $2F,$4F,$79,$8C,$B0,$CE,$D2,$D1,$BD,$A7,$8F,$67,$67,$7D,$76,$7C,$93,$9B,$96,$7F,$55,$45,$4E,$42,$4E,$6B,$7D,$9D,$BC,$BC,$B3,$AC,$A0,$90,$7B,$6C,$6B,$71,$74,$75,$90,$A1,$8F,$7B,$66,$4A,$3C,$26,$27,$41,$55,$6C,$87,$A2,$A9,$9C,$8F,$87,$7F,$73,$5F,$6A,$94,$96; 25152
		dc.b $8D,$8E,$8D,$87,$5B,$2B,$2A,$38,$45,$52,$6B,$93,$B1,$B9,$AA,$A5,$A6,$9A,$8E,$80,$83,$9A,$99,$85,$82,$8C,$99,$81,$59,$4B,$50,$51,$40,$43,$57,$67,$76,$82,$86,$80,$7F,$88,$8C,$8A,$91,$95,$8F,$9F,$A4,$8E,$76,$69,$5E,$42,$2C,$3C,$55,$63,$73,$8A,$9E,$A1,$9E,$95; 25216
		dc.b $92,$93,$87,$88,$8F,$92,$9B,$9F,$96,$8F,$8F,$8F,$84,$74,$70,$6F,$69,$6C,$76,$72,$72,$80,$81,$7F,$79,$7E,$8F,$A0,$A6,$A3,$AA,$B1,$B3,$AE,$9A,$88,$86,$7E,$6B,$54,$53,$6D,$79,$71,$76,$8A,$8C,$81,$82,$89,$86,$8B,$93,$91,$96,$9A,$A0,$9D,$89,$80,$7F,$7C,$6E,$66; 25280
		dc.b $6B,$77,$7E,$70,$6A,$6F,$66,$64,$68,$65,$71,$86,$9A,$A4,$A9,$B5,$AE,$A2,$97,$8A,$7F,$71,$67,$6C,$71,$7D,$85,$7D,$7F,$87,$86,$79,$72,$76,$7D,$85,$8C,$98,$9A,$91,$8A,$90,$8F,$7E,$74,$74,$81,$91,$8E,$84,$83,$87,$8B,$7C,$65,$5B,$66,$71,$70,$7D,$90,$A0,$A8,$A5; 25344
		dc.b $9C,$8C,$87,$82,$79,$78,$7C,$85,$88,$8C,$8F,$88,$7E,$76,$6E,$66,$6B,$6F,$6D,$7C,$8E,$90,$96,$93,$83,$7A,$7D,$7A,$71,$73,$7A,$84,$8C,$8A,$7F,$7A,$7A,$6F,$60,$52,$4C,$58,$64,$6B,$83,$92,$97,$98,$92,$89,$79,$71,$71,$74,$71,$74,$7E,$84,$89,$85,$76,$72,$77,$72; 25408
		dc.b $6E,$72,$7A,$81,$89,$8B,$85,$87,$84,$74,$6D,$6F,$72,$7B,$7E,$7E,$88,$8C,$8A,$85,$79,$72,$6A,$68,$66,$62,$6A,$76,$7B,$7D,$84,$8C,$85,$79,$7A,$77,$74,$7E,$85,$81,$83,$8E,$8A,$86,$82,$77,$77,$7B,$77,$78,$80,$82,$87,$8B,$8B,$8C,$89,$7F,$7A,$7A,$78,$7C,$85,$91; 25472
		dc.b $94,$8C,$89,$8E,$8B,$7F,$7B,$7C,$7C,$81,$88,$87,$85,$88,$8B,$8B,$83,$7B,$7E,$87,$83,$85,$93,$97,$90,$8F,$91,$87,$7E,$7D,$7D,$7C,$7E,$81,$85,$8A,$89,$89,$85,$7E,$79,$78,$7C,$7F,$7F,$8A,$92,$8E,$8D,$89,$7E,$78,$75,$75,$71,$72,$78,$7E,$86,$8B,$88,$87,$89,$83; 25536
		dc.b $7D,$7B,$7A,$7A,$7C,$7F,$81,$87,$90,$93,$95,$91,$88,$85,$85,$83,$80,$83,$8C,$93,$93,$8C,$80,$79,$79,$73,$6E,$72,$7A,$87,$90,$8E,$8E,$90,$88,$7B,$74,$71,$73,$78,$80,$82,$83,$84,$84,$82,$80,$81,$83,$84,$82,$81,$83,$84,$81,$81,$83,$83,$7F,$7B,$7B,$7C,$81,$88; 25600
		dc.b $8C,$8C,$8E,$94,$96,$91,$8B,$82,$7D,$7A,$75,$75,$78,$7A,$80,$86,$87,$88,$88,$7F,$7A,$77,$72,$71,$75,$7B,$7E,$79,$78,$7D,$78,$6E,$6C,$6B,$6D,$77,$7D,$7F,$84,$89,$85,$7C,$6F,$67,$67,$65,$62,$6A,$78,$7E,$84,$87,$84,$80,$80,$7D,$79,$7A,$7E,$83,$86,$86,$83,$80; 25664
		dc.b $7A,$74,$72,$72,$74,$78,$7B,$82,$89,$87,$88,$82,$77,$75,$76,$74,$70,$72,$76,$79,$7E,$7F,$7C,$7F,$80,$7E,$7E,$7C,$79,$7C,$7C,$76,$78,$79,$7D,$81,$80,$7F,$7D,$80,$85,$84,$82,$86,$8D,$8D,$8A,$86,$81,$80,$83,$82,$7E,$7D,$83,$8C,$92,$90,$90,$93,$8C,$83,$7F,$7F; 25728
		dc.b $7E,$80,$85,$86,$85,$85,$85,$84,$82,$82,$84,$86,$86,$85,$87,$85,$81,$7E,$7C,$7D,$7B,$79,$7A,$7C,$80,$85,$85,$83,$83,$87,$87,$87,$87,$84,$84,$83,$7F,$7D,$7D,$7D,$80,$83,$82,$84,$88,$85,$84,$83,$82,$84,$85,$85,$86,$86,$89,$8A,$86,$7F,$7F,$82,$84,$87,$89,$89; 25792
		dc.b $8B,$8C,$8A,$86,$81,$80,$81,$7D,$79,$7B,$7F,$80,$80,$81,$81,$80,$80,$80,$7F,$7F,$81,$82,$81,$7F,$7E,$7E,$7F,$7E,$80,$82,$83,$85,$83,$86,$88,$87,$86,$84,$80,$7E,$80,$81,$80,$83,$84,$85,$87,$86,$85,$87,$89,$88,$87,$86,$84,$82,$7F,$7A,$7B,$7D,$7E,$7F,$7F,$7F; 25856
		dc.b $7F,$80,$80,$7F,$7E,$7E,$80,$7F,$7E,$7C,$7A,$78,$78,$76,$73,$73,$74,$78,$7C,$7D,$7F,$82,$80,$7C,$78,$78,$77,$77,$76,$74,$76,$78,$78,$77,$76,$77,$78,$7A,$7B,$7C,$7F,$7F,$7E,$7E,$7D,$7D,$7A,$78,$7A,$7A,$79,$7B,$7F,$7F,$7E,$7E,$7E,$7F,$7E,$7B,$7A,$7A,$79,$7A; 25920
		dc.b $7B,$7B,$7D,$7F,$7F,$7E,$7F,$7D,$7B,$7A,$7A,$7B,$7E,$7E,$7E,$7D,$7D,$7C,$7A,$79,$7A,$7E,$81,$84,$85,$85,$84,$84,$83,$80,$7D,$7D,$7E,$7E,$7E,$81,$85,$86,$86,$86,$86,$85,$86,$87,$86,$86,$86,$86,$86,$86,$85,$82,$82,$83,$83,$83,$83,$84,$85,$8A,$8C,$89,$88,$85; 25984
		dc.b $82,$7F,$7D,$7C,$7D,$7F,$81,$83,$85,$86,$87,$86,$85,$84,$82,$82,$80,$82,$82,$83,$85,$86,$83,$80,$7F,$7D,$7D,$7E,$7F,$81,$83,$84,$85,$85,$85,$84,$81,$7F,$7F,$7E,$7E,$80,$83,$87,$87,$86,$88,$89,$86,$83,$82,$83,$83,$82,$83,$83,$84,$84,$84,$83,$81,$7F,$7E,$80; 26048
		dc.b $81,$80,$80,$81,$84,$83,$80,$7F,$7E,$7D,$7D,$7F,$81,$84,$88,$89,$89,$88,$85,$83,$81,$7F,$7E,$7E,$7E,$7F,$81,$84,$85,$86,$85,$86,$85,$83,$81,$80,$82,$84,$85,$86,$85,$83,$82,$80,$7D,$7B,$7A,$7A,$7D,$7F,$80,$80,$81,$81,$7E,$7B,$7A,$7A,$79,$78,$78,$79,$7B,$7C; 26112
		dc.b $7D,$7D,$7D,$7C,$7C,$7B,$7A,$79,$79,$7B,$7D,$7F,$7E,$7C,$7C,$7B,$78,$76,$76,$76,$77,$7A,$7D,$7E,$7D,$7C,$7D,$7D,$7C,$7A,$7A,$7B,$7D,$7E,$7F,$7F,$7F,$80,$7E,$7C,$7B,$7A,$7A,$7B,$7B,$7B,$7D,$7E,$7E,$7E,$7D,$7C,$7C,$7B,$7B,$7C,$7D,$7D,$7E,$7E,$7E,$7C,$7B,$7B; 26176
		dc.b $7B,$7B,$7B,$7B,$7D,$7E,$7F,$81,$82,$83,$83,$81,$80,$7F,$7D,$7C,$7C,$7C,$7D,$7E,$80,$81,$81,$81,$82,$83,$83,$84,$85,$86,$86,$86,$85,$85,$84,$82,$81,$81,$82,$83,$84,$84,$85,$85,$85,$85,$84,$83,$83,$83,$83,$83,$82,$82,$82,$82,$83,$83,$84,$85,$85,$85,$84,$84; 26240
		dc.b $84,$84,$83,$83,$84,$84,$83,$82,$82,$82,$81,$81,$81,$80,$80,$81,$82,$82,$81,$80,$81,$82,$81,$81,$82,$83,$84,$84,$83,$82,$83,$84,$84,$82,$82,$82,$83,$83,$83,$83,$84,$83,$83,$83,$82,$82,$81,$81,$82,$82,$81,$80,$80,$80,$7F,$7E,$7E,$7F,$80,$80,$81,$82,$83,$83; 26304
		dc.b $84,$85,$85,$85,$84,$84,$82,$80,$80,$80,$80,$80,$81,$81,$82,$83,$83,$82,$83,$84,$85,$84,$84,$83,$83,$83,$83,$83,$81,$80,$80,$80,$80,$7F,$7F,$80,$81,$80,$7E,$7E,$7D,$7C,$7C,$7C,$7C,$7B,$7C,$7C,$7C,$7B,$7C,$7C,$7D,$7D,$7D,$7D,$7D,$7C,$7C,$7B,$7C,$7B,$7B,$7C; 26368
		dc.b $7C,$7C,$7C,$7C,$7B,$7A,$78,$77,$77,$78,$79,$79,$7B,$7C,$7D,$7D,$7D,$7D,$7D,$7E,$7F,$7F,$7D,$7D,$7D,$7D,$7C,$7C,$7C,$7B,$7B,$7B,$7C,$7C,$7D,$7E,$7F,$7F,$7F,$7E,$7D,$7D,$7D,$7D,$7D,$7C,$7C,$7C,$7C,$7C,$7C,$7E,$7E,$7E,$7E,$7E,$7F,$7F,$7F,$7F,$80,$81,$82,$81; 26432
		dc.b $7F,$7E,$7E,$7E,$7D,$7D,$7E,$7F,$80,$81,$82,$82,$83,$83,$83,$82,$82,$83,$83,$85,$86,$86,$85,$84,$83,$82,$81,$81,$81,$82,$83,$84,$84,$83,$83,$83,$83,$82,$82,$83,$83,$83,$83,$83,$84,$84,$84,$84,$84,$83,$83,$83,$84,$84,$83,$83,$83,$83,$84,$84,$84,$84,$82,$80; 26496
		dc.b $80,$80,$80,$81,$81,$82,$82,$83,$82,$82,$82,$82,$82,$82,$83,$82,$82,$82,$82,$82,$82,$81,$82,$81,$81,$82,$84,$84,$84,$84,$84,$83,$82,$81,$80,$80,$81,$82,$81,$80,$80,$80,$80,$7F,$80,$80,$81,$81,$82,$82,$83,$83,$84,$83,$83,$82,$81,$80,$80,$7F,$7F,$80,$80,$81; 26560
		dc.b $82,$82,$82,$82,$82,$82,$82,$83,$83,$82,$82,$82,$83,$83,$83,$82,$81,$80,$7F,$7F,$7E,$7E,$7E,$7F,$7F,$7E,$7E,$7D,$7E,$7D,$7C,$7D,$7D,$7D,$7D,$7D,$7E,$7E,$7E,$7D,$7C,$7C,$7C,$7C,$7C,$7D,$7D,$7E,$7E,$7E,$7D,$7C,$7C,$7C,$7C,$7B,$7A,$7A,$7A,$7A,$79,$7A,$7B,$7B; 26624
		dc.b $7B,$7B,$7C,$7D,$7F,$7F,$7E,$7F,$7F,$7E,$7E,$7D,$7D,$7D,$7D,$7D,$7C,$7C,$7D,$7E,$7F,$7E,$7E,$7E,$7E,$7D,$7D,$7D,$7D,$7D,$7E,$7F,$7E,$7D,$7D,$7D,$7D,$7D,$7D,$7E,$7F,$7F,$7F,$80,$80,$7F,$7F,$7F,$7F,$7F,$7E,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$80,$80,$81,$83; 26688
		dc.b $83,$83,$83,$83,$83,$83,$83,$83,$83,$83,$82,$82,$82,$82,$81,$82,$82,$82,$81,$81,$81,$81,$81,$82,$83,$83,$83,$83,$83,$83,$83,$82,$82,$82,$82,$82,$82,$83,$83,$83,$83,$82,$82,$82,$82,$82,$82,$83,$82,$82,$82,$81,$80,$80,$80,$80,$80,$80,$81,$81,$82,$82,$82,$83; 26752
		dc.b $83,$82,$81,$80,$80,$81,$81,$82,$83,$83,$83,$83,$82,$82,$82,$82,$82,$82,$82,$82,$82,$81,$81,$81,$80,$80,$80,$80,$80,$80,$81,$81,$82,$82,$82,$82,$82,$82,$82,$81,$81,$81,$81,$81,$81,$81,$80,$80,$80,$80,$80,$80,$80,$80,$81,$82,$83,$83,$83,$83,$83,$82,$82,$82; 26816
		dc.b $81,$81,$82,$81,$81,$80,$7F,$7F,$7E,$7E,$7E,$7E,$7E,$7E,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$7E,$7E,$7D,$7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E,$7D,$7D,$7D,$7D,$7D,$7E,$7E,$7E,$7D,$7C,$7C,$7B,$7B,$7B,$7B,$7B,$7C,$7C,$7D,$7E,$7E,$7E,$7E,$7E,$7E,$7D,$7E,$7E,$7E,$7E,$7E; 26880
		dc.b $7E,$7F,$7F,$7E,$7E,$7D,$7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E,$7D,$7D,$7D,$7E,$7E,$7E,$7E,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$7E,$7F,$7F,$7F,$80,$80,$80,$7F,$7E,$7E,$7E,$7E,$7E,$7F,$80,$80,$81,$81,$81,$82,$82,$82,$82,$82,$82; 26944
