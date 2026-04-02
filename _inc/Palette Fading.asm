; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to fade in from black
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Pal_FadeTo:
Pal_FadeFromBlack:
		move.w	#$3F,(Palette_fade_range).w
; Pal_FadeTo2:
Pal_FadeFromBlack2:
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		move.b	(Palette_fade_start).w,d0
		adda.w	d0,a0
		moveq	#0,d1
		move.b	(Palette_fade_length).w,d0

loc_2162:
		move.w	d1,(a0)+
		dbf	d0,loc_2162		; fill palette with $000 (black)
		move.w	#$15,d4

loc_216C:
		move.b	#VintID_Fade,(Vint_routine).w
		bsr.w	WaitForVint
		bsr.s	Pal_FadeIn
		bsr.w	RunPLC_RAM
		dbf	d4,loc_216C
		rts
; End of function Pal_FadeFromBlack

; ---------------------------------------------------------------------------
; Subroutine to update all colours once
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Pal_FadeIn:
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		lea	(Target_palette).w,a1
		move.b	(Palette_fade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(Palette_fade_length).w,d0

loc_2198:
		bsr.s	Pal_AddColor
		dbf	d0,loc_2198
		tst.b	(Water_flag).w
		beq.s	locret_21C0
		moveq	#0,d0
		lea	(Underwater_palette).w,a0
		lea	(Underwater_target_palette).w,a1
		move.b	(Palette_fade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(Palette_fade_length).w,d0

loc_21BA:
		bsr.s	Pal_AddColor
		dbf	d0,loc_21BA

locret_21C0:
		rts
; End of function Pal_FadeIn

; ---------------------------------------------------------------------------
; Subroutine to update a single colour once
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Pal_AddColor:
		move.w	(a1)+,d2
		move.w	(a0),d3
		cmp.w	d2,d3
		beq.s	Pal_AddNone
		move.w	d3,d1
		addi.w	#$200,d1
		cmp.w	d2,d1
		bhi.s	Pal_AddGreen
		move.w	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

Pal_AddGreen:
		move.w	d3,d1
		addi.w	#$20,d1
		cmp.w	d2,d1
		bhi.s	Pal_AddRed
		move.w	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

Pal_AddRed:
		addq.w	#2,(a0)+
		rts
; ---------------------------------------------------------------------------
; Pal_NoAdd:
Pal_AddNone:
		addq.w	#2,a0
		rts
; End of function Pal_AddColor


; ---------------------------------------------------------------------------
; Subroutine to fade out to black
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Pal_FadeFrom:
Pal_FadeToBlack:
		move.w	#$3F,(Palette_fade_range).w
		move.w	#$15,d4

loc_21F8:
		move.b	#VintID_Fade,(Vint_routine).w
		bsr.w	WaitForVint
		bsr.s	Pal_FadeOut
		bsr.w	RunPLC_RAM
		dbf	d4,loc_21F8
		rts
; End of function Pal_FadeFrom

; ---------------------------------------------------------------------------
; Subroutine to update all colours once
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Pal_FadeOut:
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		move.b	(Palette_fade_start).w,d0
		adda.w	d0,a0
		move.b	(Palette_fade_length).w,d0

loc_221E:
		bsr.s	Pal_DecColor
		dbf	d0,loc_221E
		moveq	#0,d0
		lea	(Underwater_palette).w,a0
		move.b	(Palette_fade_start).w,d0
		adda.w	d0,a0
		move.b	(Palette_fade_length).w,d0

loc_2234:
		bsr.s	Pal_DecColor
		dbf	d0,loc_2234
		rts
; End of function Pal_FadeOut


; ---------------------------------------------------------------------------
; Subroutine to update a single colour once
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Pal_DecColor:
		move.w	(a0),d2
		beq.s	Pal_NoDec
		move.w	d2,d1
		andi.w	#$E,d1
		beq.s	Pal_DecGreen
		subq.w	#2,(a0)+
		rts
; ---------------------------------------------------------------------------

Pal_DecGreen:
		move.w	d2,d1
		andi.w	#$E0,d1
		beq.s	Pal_DecBlue
		subi.w	#$20,(a0)+
		rts
; ---------------------------------------------------------------------------

Pal_DecBlue:
		move.w	d2,d1
		andi.w	#$E00,d1
		beq.s	Pal_NoDec
		subi.w	#$200,(a0)+
		rts
; ---------------------------------------------------------------------------

Pal_NoDec:
		addq.w	#2,a0
		rts
; End of function Pal_DecColor


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Pal_MakeWhite:				; CODE XREF: ROM:00005166p
		move.w	#$3F,(Palette_fade_range).w ; '?'
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		move.b	(Palette_fade_start).w,d0
		adda.w	d0,a0
		move.w	#$EEE,d1
		move.b	(Palette_fade_length).w,d0

loc_2286:				; CODE XREF: Pal_MakeWhite+1Cj
		move.w	d1,(a0)+
		dbf	d0,loc_2286
		move.w	#$15,d4

loc_2290:				; CODE XREF: Pal_MakeWhite+34j
		move.b	#VintID_Fade,(Vint_routine).w
		bsr.w	WaitForVint
		bsr.s	Pal_WhiteToBlack
		bsr.w	RunPLC_RAM
		dbf	d4,loc_2290
		rts
; End of function Pal_MakeWhite


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Pal_WhiteToBlack:			; CODE XREF: Pal_MakeWhite+2Ep
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		lea	(Target_palette).w,a1
		move.b	(Palette_fade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(Palette_fade_length).w,d0

loc_22BC:				; CODE XREF: Pal_WhiteToBlack+18j
		bsr.s	Pal_DecColor2
		dbf	d0,loc_22BC
		tst.b	(Water_flag).w
		beq.s	locret_22E4
		moveq	#0,d0
		lea	(Underwater_palette).w,a0
		lea	(Underwater_target_palette).w,a1
		move.b	(Palette_fade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(Palette_fade_length).w,d0

loc_22DE:				; CODE XREF: Pal_WhiteToBlack+3Aj
		bsr.s	Pal_DecColor2
		dbf	d0,loc_22DE

locret_22E4:				; CODE XREF: Pal_WhiteToBlack+20j
		rts
; End of function Pal_WhiteToBlack


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Pal_DecColor2:				; CODE XREF: Pal_WhiteToBlack:loc_22BCp
					; Pal_WhiteToBlack:loc_22DEp
		move.w	(a1)+,d2
		move.w	(a0),d3
		cmp.w	d2,d3
		beq.s	loc_2312
		move.w	d3,d1
		subi.w	#$200,d1
		bcs.s	loc_22FE
		cmp.w	d2,d1
		bcs.s	loc_22FE
		move.w	d1,(a0)+
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_22FE:				; CODE XREF: Pal_DecColor2+Ej
					; Pal_DecColor2+12j
		move.w	d3,d1
		subi.w	#$20,d1	; ' '
		bcs.s	loc_230E
		cmp.w	d2,d1
		bcs.s	loc_230E
		move.w	d1,(a0)+
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_230E:				; CODE XREF: Pal_DecColor2+1Ej
					; Pal_DecColor2+22j
		subq.w	#2,(a0)+
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_2312:				; CODE XREF: Pal_DecColor2+6j
		addq.w	#2,a0
		rts
; End of function Pal_DecColor2


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Pal_MakeFlash:				; CODE XREF: ROM:00005024p
					; ROM:000052CEp
		move.w	#$3F,(Palette_fade_range).w ; '?'
		move.w	#$15,d4

loc_2320:				; CODE XREF: Pal_MakeFlash+1Aj
		move.b	#VintID_Fade,(Vint_routine).w
		bsr.w	WaitForVint
		bsr.s	Pal_ToWhite
		bsr.w	RunPLC_RAM
		dbf	d4,loc_2320
		rts
; End of function Pal_MakeFlash


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Pal_ToWhite:				; CODE XREF: Pal_MakeFlash+14p
					; ROM:00005210p
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		move.b	(Palette_fade_start).w,d0
		adda.w	d0,a0
		move.b	(Palette_fade_length).w,d0

loc_2346:				; CODE XREF: Pal_ToWhite+12j
		bsr.s	Pal_AddColor2
		dbf	d0,loc_2346
		moveq	#0,d0

loc_234E:
		lea	(Underwater_palette).w,a0
		move.b	(Palette_fade_start).w,d0
		adda.w	d0,a0
		move.b	(Palette_fade_length).w,d0

loc_235C:				; CODE XREF: Pal_ToWhite+28j
		bsr.s	Pal_AddColor2
		dbf	d0,loc_235C
		rts
; End of function Pal_ToWhite


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Pal_AddColor2:				; CODE XREF: Pal_ToWhite:loc_2346p
					; Pal_ToWhite:loc_235Cp
		move.w	(a0),d2
		cmpi.w	#$EEE,d2
		beq.s	loc_23A0
		move.w	d2,d1
		andi.w	#$E,d1
		cmpi.w	#$E,d1
		beq.s	loc_237C
		addq.w	#2,(a0)+
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_237C:				; CODE XREF: Pal_AddColor2+12j
		move.w	d2,d1
		andi.w	#$E0,d1	; 'à'
		cmpi.w	#$E0,d1	; 'à'
		beq.s	loc_238E

loc_2388:
		addi.w	#$20,(a0)+ ; ' '
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_238E:				; CODE XREF: Pal_AddColor2+22j
		move.w	d2,d1
		andi.w	#$E00,d1
		cmpi.w	#$E00,d1
		beq.s	loc_23A0
		addi.w	#$200,(a0)+
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_23A0:				; CODE XREF: Pal_AddColor2+6j
					; Pal_AddColor2+34j
		addq.w	#2,a0
		rts
; End of function Pal_AddColor2