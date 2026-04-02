; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


PalCycle_Sega:				; CODE XREF: ROM:000031A0p
		tst.b	(PalCycle_Timer+1).w
		bne.s	loc_2404
		lea	(Normal_palette_line2).w,a1
		lea	(Pal_Sega1).l,a0
		moveq	#5,d1
		move.w	(PalCycle_Frame).w,d0

loc_23BA:				; CODE XREF: PalCycle_Sega+1Ej
		bpl.s	loc_23C4
		addq.w	#2,a0
		subq.w	#1,d1
		addq.w	#2,d0
		bra.s	loc_23BA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_23C4:				; CODE XREF: PalCycle_Sega:loc_23BAj
					; PalCycle_Sega+36j
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_23CE
		addq.w	#2,d0

loc_23CE:				; CODE XREF: PalCycle_Sega+26j
		cmpi.w	#$60,d0	; '`'
		bcc.s	loc_23D8
		move.w	(a0)+,(a1,d0.w)

loc_23D8:				; CODE XREF: PalCycle_Sega+2Ej
		addq.w	#2,d0
		dbf	d1,loc_23C4
		move.w	(PalCycle_Frame).w,d0
		addq.w	#2,d0
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_23EE
		addq.w	#2,d0

loc_23EE:				; CODE XREF: PalCycle_Sega+46j
		cmpi.w	#$64,d0	; 'd'
		blt.s	loc_23FC
		move.w	#$401,(PalCycle_Timer).w
		moveq	#$FFFFFFF4,d0

loc_23FC:				; CODE XREF: PalCycle_Sega+4Ej
		move.w	d0,(PalCycle_Frame).w
		moveq	#1,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_2404:				; CODE XREF: PalCycle_Sega+4j
		subq.b	#1,(PalCycle_Timer).w
		bpl.s	loc_2456
		move.b	#4,(PalCycle_Timer).w
		move.w	(PalCycle_Frame).w,d0
		addi.w	#$C,d0
		cmpi.w	#$30,d0	; '0'
		bcs.s	loc_2422
		moveq	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_2422:				; CODE XREF: PalCycle_Sega+78j
		move.w	d0,(PalCycle_Frame).w
		lea	(Pal_Sega2).l,a0
		lea	(a0,d0.w),a0
		lea	(Normal_palette+4).w,a1
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.w	(a0)+,(a1)
		lea	(Normal_palette_line2).w,a1
		moveq	#0,d0
		moveq	#$2C,d1	; ','

loc_2442:				; CODE XREF: PalCycle_Sega+AEj
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_244C
		addq.w	#2,d0

loc_244C:				; CODE XREF: PalCycle_Sega+A4j
		move.w	(a0),(a1,d0.w)
		addq.w	#2,d0
		dbf	d1,loc_2442

loc_2456:				; CODE XREF: PalCycle_Sega+64j
		moveq	#1,d0
		rts
; End of function PalCycle_Sega

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Pal_Sega1:	dc.w  $EEE, $EEA, $EE4,	$EC0, $EE4, $EEA; 0 ; DATA XREF: PalCycle_Sega
Pal_Sega2:	dc.w  $EEC, $EEA, $EEA,	$EEA, $EEA, $EEA, $EEC,	$EEA, $EE4, $EC0, $EC0,	$EC0, $EEC, $EEA, $EE4,	$EC0
		dc.w  $EA0, $E60, $EEA,	$EE4, $EC0, $EA0, $E80,	$E00