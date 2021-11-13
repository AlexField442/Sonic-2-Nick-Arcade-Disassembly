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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_71C6E:				; CODE XREF: sub_71C4E+18j
		tst.b	d5
		bpl.s	loc_71C84
		move.b	d5,$10(a5)
		move.b	(a4)+,d5
		bpl.s	loc_71C84
		subq.w	#1,a4
		move.b	$F(a5),$E(a5)
		bra.s	loc_71C88
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_71CAC:				; CODE XREF: sub_71C4E+54j
		subi.b	#-$78,d0
		move.b	byte_71CC4(pc,d0.w),d0
		move.b	d0,($A000EA).l
		move.b	#-$7D,($A01FFF).l
		rts
; End of function sub_71C4E

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_71CC4:	dc.b $12,$15,$1C,$1D,$FF,$FF; 0

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_71CCA:				; DATA XREF: sub_71B4C+96t
					; sub_71B4C+C0t ...

; FUNCTION CHUNK AT 000726E2 SIZE 0000001C BYTES

		subq.b	#1,$E(a5)
		bne.s	loc_71CE0
		bclr	#4,(a5)
		jsr	sub_71CEC(pc)
		jsr	sub_71E18(pc)
		bra.w	loc_726E2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_71CE0:				; CODE XREF: sub_71CCA+4j
		jsr	sub_71D9E(pc)
		jsr	sub_71DC6(pc)
		bra.w	loc_71E24
; End of function sub_71CCA


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_71D04:				; CODE XREF: sub_71CEC+10j
		jsr	sub_726FE(pc)
		tst.b	d5
		bpl.s	loc_71D1A
		jsr	sub_71D22(pc)
		move.b	(a4)+,d5
		bpl.s	loc_71D1A
		subq.w	#1,a4
		bra.w	sub_71D60
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_71D1A:				; CODE XREF: sub_71CEC+1Ej
					; sub_71CEC+26j
		jsr	sub_71D40(pc)
		bra.w	sub_71D60
; End of function sub_71CEC


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_71D40:				; DATA XREF: sub_71C4E:loc_71C84t
					; sub_71CEC:loc_71D1At	...
		move.b	d5,d0
		move.b	2(a5),d1

loc_71D46:				; CODE XREF: sub_71D40+Cj
		subq.b	#1,d1
		beq.s	loc_71D4E
		add.b	d5,d0
		bra.s	loc_71D46
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_71D4E:				; CODE XREF: sub_71D40+8j
		move.b	d0,$F(a5)
		move.b	d0,$E(a5)
		rts
; End of function sub_71D40

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; START	OF FUNCTION CHUNK FOR sub_71D22

loc_71D58:				; CODE XREF: sub_71D22+4j
		bset	#1,(a5)
		clr.w	$10(a5)
; END OF FUNCTION CHUNK	FOR sub_71D22

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_71DBE:				; CODE XREF: sub_71D9E+14j
		jsr	sub_729A0(pc)
		addq.w	#4,sp

locret_71DC4:				; CODE XREF: sub_71D9E+4j sub_71D9E+Aj
		rts
; End of function sub_71D9E


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_71DC6:				; DATA XREF: sub_71CCA+1At
					; sub_72850+1Et
		addq.w	#4,sp
		btst	#3,(a5)
		beq.s	locret_71E16
		tst.b	$18(a5)
		beq.s	loc_71DDA
		subq.b	#1,$18(a5)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_71DDA:				; CODE XREF: sub_71DC6+Cj
		subq.b	#1,$19(a5)
		beq.s	loc_71DE2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_71DE2:				; CODE XREF: sub_71DC6+18j
		movea.l	$14(a5),a0
		move.b	1(a0),$19(a5)
		tst.b	$1B(a5)
		bne.s	loc_71DFE
		move.b	3(a0),$1B(a5)
		neg.b	$1A(a5)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_71E4A:				; CODE XREF: sub_71E18+Aj
		bset	#1,(a5)
		rts
; End of function sub_71E18

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_71F8E:				; CODE XREF: Sound_ChkValue+3Ej
		subi.b	#$E0,d7
		lsl.w	#2,d7
		jmp	loc_71F98(pc,d7.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_71F98:
		bra.w	Sound_E0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_71FAC
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	Sound_E2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	Sound_E3
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	Sound_E4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_721BA:	dc.b 6,	0, 1, 2, 4, 5, 6, 0 ; DATA XREF: Sound_ChkValue+148t
byte_721C2:	dc.b $80, $A0, $C0, 0	; DATA XREF: Sound_ChkValue+1D6t
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_722C6:				; CODE XREF: Sound_ChkValue+27Ej
					; Sound_ChkValue+286j ...
		clr.b	0(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dword_722CC:	dc.l   $FFF0D0,	       0,  $FFF100,  $FFF130; 0
					; DATA XREF: Sound_ChkValue:loc_72170t
					; Sound_ChkValue+2EAt ...
		dc.l   $FFF190,	 $FFF1C0,  $FFF1F0,  $FFF1F0; 4
dword_722EC:	dc.l   $FFF220,	       0,  $FFF250,  $FFF280; 0
		dc.l   $FFF2B0,	 $FFF2E0,  $FFF310,  $FFF310; 4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dc.l $FFF100, $FFF1F0, $FFF250,	$FFF310, $FFF340, $FFF370

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_72504:				; DATA XREF: sub_71B4C+58t
		move.b	6(a6),d0
		beq.s	loc_72510
		subq.b	#1,6(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72558:				; CODE XREF: sub_72504+4Cj
		move.b	9(a5),d6
		jsr	sub_7296A(pc)

loc_72560:				; CODE XREF: sub_72504+40j
					; sub_72504+52j
		adda.w	#$30,a5
		dbf	d7,loc_72542
		rts
; End of function sub_72504


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_7263E:				; CODE XREF: Sound_ChkValue+6DCj
		move.b	$3C9(a6),$3A2(a6)
		move.b	$3C9(a6),$3A1(a6)
		move.b	#-$80,$3CA(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_7266A:				; CODE XREF: Sound_ChkValue+70Aj
		move.b	$3C8(a6),$3A2(a6)
		move.b	$3C8(a6),$3A1(a6)
		clr.b	$3CA(a6)
		rts
; END OF FUNCTION CHUNK	FOR Sound_ChkValue

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_7267C:				; DATA XREF: sub_71B4C+62t
		tst.b	$25(a6)
		beq.s	loc_72688
		subq.b	#1,$25(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_726D6:				; CODE XREF: sub_7267C+10j
		bclr	#2,$40(a6)
		clr.b	$24(a6)
		rts
; End of function sub_7267C

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

locret_726FC:				; CODE XREF: sub_71CCA+A1Cj
					; sub_71CCA+A22j
		rts
; END OF FUNCTION CHUNK	FOR sub_71CCA

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

locret_72714:				; CODE XREF: sub_726FE+4j sub_726FE+Aj
		rts
; End of function sub_726FE

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72716:				; CODE XREF: ROM:00072AE6j
		btst	#2,(a5)
		bne.s	locret_72720
		bra.w	sub_72722
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

locret_72720:				; CODE XREF: ROM:0007271Aj
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_72722:				; CODE XREF: ROM:0007271Cj
					; DATA XREF: sub_71E18+22t ...

; FUNCTION CHUNK AT 0007275A SIZE 0000000A BYTES

		btst	#2,1(a5)
		bne.s	loc_7275A
		add.b	1(a5),d0
; End of function sub_72722


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; START	OF FUNCTION CHUNK FOR sub_72722

loc_7275A:				; CODE XREF: sub_72722+6j
		move.b	1(a5),d2
		bclr	#2,d2
		add.b	d2,d0
; END OF FUNCTION CHUNK	FOR sub_72722

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_72850:				; DATA XREF: sub_71B4C+A8t
					; sub_71B4C+D2t ...
		subq.b	#1,$E(a5)
		bne.s	loc_72866
		bclr	#4,(a5)
		jsr	sub_72878(pc)
		jsr	sub_728DC(pc)
		bra.w	loc_7292E
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72866:				; CODE XREF: sub_72850+4j
		jsr	sub_71D9E(pc)
		jsr	sub_72926(pc)
		jsr	sub_71DC6(pc)
		jsr	sub_728E2(pc)
		rts
; End of function sub_72850


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72890:				; CODE XREF: sub_72878+10j
		tst.b	d5
		bpl.s	loc_728A4
		jsr	sub_728AC(pc)
		move.b	(a4)+,d5
		tst.b	d5
		bpl.s	loc_728A4
		subq.w	#1,a4
		bra.w	sub_71D60
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_728A4:				; CODE XREF: sub_72878+1Aj
					; sub_72878+24j
		jsr	sub_71D40(pc)
		bra.w	sub_71D60
; End of function sub_72878


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_728AC:				; DATA XREF: sub_72878+1Ct
		subi.b	#-$7F,d5
		bcs.s	loc_728CA
		add.b	8(a5),d5
		andi.w	#$7F,d5
		lsl.w	#1,d5
		lea	word_729CE(pc),a0
		move.w	(a0,d5.w),$10(a5)
		bra.w	sub_71D60
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_728CA:				; CODE XREF: sub_728AC+4j
		bset	#1,(a5)
		move.w	#$FFFF,$10(a5)
		jsr	sub_71D60(pc)
		bra.w	sub_729A0
; End of function sub_728AC


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_728DC:				; DATA XREF: sub_72850+Et

; FUNCTION CHUNK AT 00072920 SIZE 00000006 BYTES

		move.w	$10(a5),d6
		bmi.s	loc_72920
; End of function sub_728DC


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; START	OF FUNCTION CHUNK FOR sub_728DC

loc_72920:				; CODE XREF: sub_728DC+4j
		bset	#1,(a5)
		rts
; END OF FUNCTION CHUNK	FOR sub_728DC

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_7298C:				; CODE XREF: sub_7296A+10j
		tst.b	$13(a5)
		beq.s	loc_7297C
		tst.b	$12(a5)
		bne.s	loc_7297C
		rts
; End of function sub_7296A

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; START	OF FUNCTION CHUNK FOR sub_72926

loc_7299A:				; CODE XREF: sub_72926+38j
		subq.b	#1,$C(a5)
		rts
; END OF FUNCTION CHUNK	FOR sub_72926

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
word_729CE:	dc.w $356, $326, $2F9, $2CE, $2A5, $280, $25C, $23A, $21A
					; DATA XREF: sub_728AC+10t
		dc.w $1FB, $1DF, $1C4, $1AB, $193, $17D, $167, $153, $140
		dc.w $12E, $11D, $10D, $FE, $EF, $E2, $D6, $C9,	$BE, $B4
		dc.w $A9, $A0, $97, $8F, $87, $7F, $78,	$71, $6B, $65
		dc.w $5F, $5A, $55, $50, $4B, $47, $43,	$40, $3C, $39
		dc.w $36, $33, $30, $2D, $2B, $28, $26,	$24, $22, $20
		dc.w $1F, $1D, $1B, $1A, $18, $17, $16,	$15, $13, $12
		dc.w $11, 0

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_72A5A:				; DATA XREF: sub_71C4E+1At
					; sub_71CEC+12t ...
		subi.w	#$E0,d5
		lsl.w	#2,d5
		jmp	loc_72A64(pc,d5.w)
; End of function sub_72A5A

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72A64:
		bra.w	loc_72ACC
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72AEC
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72AF2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72AF8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72B14
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72B9E
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72BA4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72BAE
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72BB4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72BBE
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72BC6
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72BD0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72BE6
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72BEE
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72BF4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72C26
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72D30
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72D52
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72D58
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72E06
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72E20
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72E26
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72E2C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72E38
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72E52
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.w	loc_72E64
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

locret_72AEA:				; CODE XREF: ROM:00072AD2j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72AEC:				; CODE XREF: ROM:00072A68j
		move.b	(a4)+,$1E(a5)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72AF2:				; CODE XREF: ROM:00072A6Cj
		move.b	(a4)+,7(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72AF8:				; CODE XREF: ROM:00072A70j
		moveq	#0,d0
		move.b	$D(a5),d0
		movea.l	(a5,d0.w),a4
		move.l	#0,(a5,d0.w)
		addq.w	#2,a4
		addq.b	#4,d0
		move.b	d0,$D(a5)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72B9E:				; CODE XREF: ROM:00072A78j
		move.b	(a4)+,2(a5)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72BA4:				; CODE XREF: ROM:00072A7Cj
		move.b	(a4)+,d0
		add.b	d0,9(a5)
		bra.w	sub_72CB4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72BAE:				; CODE XREF: ROM:00072A80j
		bset	#4,(a5)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72BB4:				; CODE XREF: ROM:00072A84j
		move.b	(a4),$12(a5)
		move.b	(a4)+,$13(a5)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72BBE:				; CODE XREF: ROM:00072A88j
		move.b	(a4)+,d0
		add.b	d0,8(a5)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72BC6:				; CODE XREF: ROM:00072A8Cj
		move.b	(a4),2(a6)
		move.b	(a4)+,1(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72BE6:				; CODE XREF: ROM:00072A94j
		move.b	(a4)+,d0
		add.b	d0,9(a5)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72BEE:				; CODE XREF: ROM:00072A98j
		clr.b	$2C(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_72CAC:	dc.b   8,  8,  8,  8	; 0
		dc.b  $A, $E, $E, $F	; 4

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


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

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_72D18:	dc.b $30, $38, $34, $3C, $50, $58, $54,	$5C, $60, $68
					; DATA XREF: sub_72C4E+1Et
		dc.b $64, $6C, $70, $78, $74, $7C, $80,	$88, $84, $8C
byte_72D2C:	dc.b $40, $48, $44, $4C	; DATA XREF: sub_72CB4+36t
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72D52:				; CODE XREF: ROM:00072AA8j
		bset	#3,(a5)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72D58:				; CODE XREF: ROM:00072AACj
		bclr	#7,(a5)
		bclr	#4,(a5)
		tst.b	1(a5)
		bmi.s	loc_72D74
		tst.b	8(a6)
		bmi.w	loc_72E02
		jsr	sub_726FE(pc)
		bra.s	loc_72D78
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72E06:				; CODE XREF: ROM:00072AB0j
		move.b	#-$20,1(a5)
		move.b	(a4)+,$1F(a5)
		btst	#2,(a5)
		bne.s	locret_72E1E
		move.b	-1(a4),($C00011).l

locret_72E1E:				; CODE XREF: ROM:00072E14j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72E20:				; CODE XREF: ROM:00072AB4j
		bclr	#3,(a5)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72E26:				; CODE XREF: ROM:00072AB8j
		move.b	(a4)+,$B(a5)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72E2C:				; CODE XREF: ROM:00072ABCj
					; ROM:00072E4Cj ...
		move.b	(a4)+,d0
		lsl.w	#8,d0
		move.b	(a4)+,d0
		adda.w	d0,a4
		subq.w	#1,a4
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72E52:				; CODE XREF: ROM:00072AC4j
		moveq	#0,d0
		move.b	$D(a5),d0
		subq.b	#4,d0
		move.l	a4,(a5,d0.w)
		move.b	d0,$D(a5)
		bra.s	loc_72E2C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_72E64:				; CODE XREF: ROM:00072AC8j
		move.b	#-$78,d0
		move.b	#$F,d1
		jsr	sub_7272E(pc)
		move.b	#-$74,d0
		move.b	#$F,d1
		bra.w	sub_7272E
; ===========================================================================
Kos_Z80:	incbin	"sound/Z80.bin"
		even

Music81:	incbin	"sound/music/GHZ.bin"
		even
Music82:	incbin	"sound/music/LZ.bin"
		even
Music83:	incbin	"sound/music/CPZ.bin"
		even
Music84:	incbin	"sound/music/EHZ.bin"
		even
Music85:	incbin	"sound/music/HPZ.bin"
		even
Music86:	incbin	"sound/music/HTZ.bin"
		even
Music87:	incbin	"sound/music/Invincible.bin"
		even
Music88:	incbin	"sound/music/Extra Life.bin"
		even
Music89:	incbin	"sound/music/Special Stage.bin"
		even
Music8A:	incbin	"sound/music/Title.bin"
		even
Music8B:	incbin	"sound/music/Ending.bin"
		even
Music8C:	incbin	"sound/music/Boss.bin"
		even
Music8D:	incbin	"sound/music/FZ.bin"
		even
Music8E:	incbin	"sound/music/Act Clear.bin"
		even
Music8F:	incbin	"sound/music/Game Over.bin"
		even
Music90:	incbin	"sound/music/Continue.bin"
		even
Music91:	incbin	"sound/music/Credits.bin"
		even
Music92:	incbin	"sound/music/Drowning.bin"
		even
Music93:	incbin	"sound/music/Emerald.bin"
		even
; ---------------------------------------------------------------------------
; Sound	effect pointers
; ---------------------------------------------------------------------------
SoundIndex:	dc.l SoundA0
		dc.l SoundA1
		dc.l SoundA2
		dc.l SoundA3
		dc.l SoundA4
		dc.l SoundA5
		dc.l SoundA6
		dc.l SoundA7
		dc.l SoundA8
		dc.l SoundA9
		dc.l SoundAA
		dc.l SoundAB
		dc.l SoundAC
		dc.l SoundAD
		dc.l SoundAE
		dc.l SoundAF
		dc.l SoundB0
		dc.l SoundB1
		dc.l SoundB2
		dc.l SoundB3
		dc.l SoundB4
		dc.l SoundB5
		dc.l SoundB6
		dc.l SoundB7
		dc.l SoundB8
		dc.l SoundB9
		dc.l SoundBA
		dc.l SoundBB
		dc.l SoundBC
		dc.l SoundBD
		dc.l SoundBE
		dc.l SoundBF
		dc.l SoundC0
		dc.l SoundC1
		dc.l SoundC2
		dc.l SoundC3
		dc.l SoundC4
		dc.l SoundC5
		dc.l SoundC6
		dc.l SoundC7
		dc.l SoundC8
		dc.l SoundC9
		dc.l SoundCA
		dc.l SoundCB
		dc.l SoundCC
		dc.l SoundCD
		dc.l SoundCE
		dc.l SoundCF

SoundD0Index:	dc.l SoundD0

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

SegaPCM:	incbin	"sound/PCM/Sega.bin"
		even