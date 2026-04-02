; ---------------------------------------------------------------------------
; Enigma Decompression Algorithm

; ARGUMENTS:
; d0 = starting art tile (added to each 8x8 before writing to destination)
; a0 = source address
; a1 = destination address

; For format explanation see http://info.sonicretro.org/Enigma_compression
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


EniDec:
		movem.l	d0-d7/a1-a5,-(sp)
		movea.w	d0,a3
		move.b	(a0)+,d0
		ext.w	d0
		movea.w	d0,a5
		move.b	(a0)+,d4
		lsl.b	#3,d4
		movea.w	(a0)+,a2
		adda.w	a3,a2
		movea.w	(a0)+,a4
		adda.w	a3,a4
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5
		moveq	#$10,d6

loc_182E:				; CODE XREF: ROM:00001860j
					; ROM:00001868j ...
		moveq	#7,d0
		move.w	d6,d7
		sub.w	d0,d7
		move.w	d5,d1
		lsr.w	d7,d1
		andi.w	#$7F,d1	; ''
		move.w	d1,d2
		cmpi.w	#$40,d1	; '@'
		bcc.s	loc_1848
		moveq	#6,d0
		lsr.w	#1,d2

loc_1848:				; CODE XREF: EniDec+34j
		bsr.w	sub_197C
		andi.w	#$F,d2
		lsr.w	#4,d1
		add.w	d1,d1
		jmp	loc_18A4(pc,d1.w)
; End of function EniDec

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1858:				; CODE XREF: ROM:0000185Cj
					; ROM:loc_18A4j ...
		move.w	a2,(a1)+
		addq.w	#1,a2
		dbf	d2,loc_1858
		bra.s	loc_182E
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1862:				; CODE XREF: ROM:00001864j
					; ROM:000018A8j ...
		move.w	a4,(a1)+
		dbf	d2,loc_1862
		bra.s	loc_182E
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_186A:				; CODE XREF: ROM:000018ACj
		bsr.w	sub_18CC

loc_186E:				; CODE XREF: ROM:00001870j
		move.w	d1,(a1)+
		dbf	d2,loc_186E
		bra.s	loc_182E
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1876:				; CODE XREF: ROM:000018AEj
		bsr.w	sub_18CC

loc_187A:				; CODE XREF: ROM:0000187Ej
		move.w	d1,(a1)+
		addq.w	#1,d1
		dbf	d2,loc_187A
		bra.s	loc_182E
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1884:				; CODE XREF: ROM:000018B0j
		bsr.w	sub_18CC

loc_1888:				; CODE XREF: ROM:0000188Cj
		move.w	d1,(a1)+
		subq.w	#1,d1
		dbf	d2,loc_1888
		bra.s	loc_182E
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1892:				; CODE XREF: ROM:000018B2j
		cmpi.w	#$F,d2
		beq.s	loc_18B4

loc_1898:				; CODE XREF: ROM:0000189Ej
		bsr.w	sub_18CC
		move.w	d1,(a1)+
		dbf	d2,loc_1898
		bra.s	loc_182E
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18A4:
		bra.s	loc_1858
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.s	loc_1858
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.s	loc_1862
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.s	loc_1862
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.s	loc_186A
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.s	loc_1876
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.s	loc_1884
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		bra.s	loc_1892
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18B4:				; CODE XREF: ROM:00001896j
		subq.w	#1,a0
		cmpi.w	#$10,d6
		bne.s	loc_18BE
		subq.w	#1,a0

loc_18BE:				; CODE XREF: ROM:000018BAj
		move.w	a0,d0
		lsr.w	#1,d0
		bcc.s	loc_18C6
		addq.w	#1,a0

loc_18C6:				; CODE XREF: ROM:000018C2j
		movem.l	(sp)+,d0-d7/a1-a5
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_18CC:				; CODE XREF: ROM:loc_186Ap
					; ROM:loc_1876p ...
		move.w	a3,d3
		move.b	d4,d1
		add.b	d1,d1
		bcc.s	loc_18DE
		subq.w	#1,d6
		btst	d6,d5
		beq.s	loc_18DE
		ori.w	#$8000,d3

loc_18DE:				; CODE XREF: sub_18CC+6j sub_18CC+Cj
		add.b	d1,d1
		bcc.s	loc_18EC
		subq.w	#1,d6
		btst	d6,d5
		beq.s	loc_18EC
		addi.w	#$4000,d3

loc_18EC:				; CODE XREF: sub_18CC+14j sub_18CC+1Aj
		add.b	d1,d1
		bcc.s	loc_18FA
		subq.w	#1,d6
		btst	d6,d5
		beq.s	loc_18FA
		addi.w	#$2000,d3

loc_18FA:				; CODE XREF: sub_18CC+22j sub_18CC+28j
		add.b	d1,d1
		bcc.s	loc_1908
		subq.w	#1,d6
		btst	d6,d5
		beq.s	loc_1908
		ori.w	#$1000,d3

loc_1908:				; CODE XREF: sub_18CC+30j sub_18CC+36j
		add.b	d1,d1
		bcc.s	loc_1916
		subq.w	#1,d6
		btst	d6,d5
		beq.s	loc_1916
		ori.w	#$800,d3

loc_1916:				; CODE XREF: sub_18CC+3Ej sub_18CC+44j
		move.w	d5,d1
		move.w	d6,d7
		sub.w	a5,d7
		bcc.s	loc_1946
		move.w	d7,d6
		addi.w	#$10,d6
		neg.w	d7
		lsl.w	d7,d1
		move.b	(a0),d5
		rol.b	d7,d5
		add.w	d7,d7
		and.w	loc_195A(pc,d7.w),d5
		add.w	d5,d1

loc_1934:				; CODE XREF: sub_18CC:loc_195Aj
		move.w	a5,d0
		add.w	d0,d0
		and.w	loc_195A(pc,d0.w),d1
		add.w	d3,d1
		move.b	(a0)+,d5
		lsl.w	#8,d5
		move.b	(a0)+,d5
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1946:				; CODE XREF: sub_18CC+50j
		beq.s	loc_1958
		lsr.w	d7,d1
		move.w	a5,d0
		add.w	d0,d0
		and.w	loc_195A(pc,d0.w),d1
		add.w	d3,d1
		move.w	a5,d0
		bra.s	sub_197C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1958:				; CODE XREF: sub_18CC:loc_1946j
		moveq	#$10,d6

loc_195A:
		bra.s	loc_1934
; End of function sub_18CC

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dc.w	 1,    3,    7,	  $F; 0
		dc.w   $1F,  $3F,  $7F,	 $FF; 4
		dc.w  $1FF, $3FF, $7FF,	$FFF; 8
		dc.w $1FFF,$3FFF,$7FFF,$FFFF; 12

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_197C:				; CODE XREF: EniDec:loc_1848p
					; sub_18CC+8Aj
		sub.w	d0,d6
		cmpi.w	#9,d6
		bcc.s	locret_198A
		addq.w	#8,d6
		asl.w	#8,d5
		move.b	(a0)+,d5

locret_198A:				; CODE XREF: sub_197C+6j
		rts
; End of function sub_197C