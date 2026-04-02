; ===========================================================================
; ---------------------------------------------------------------------------
; Single object loading subroutine
; Find an empty object array
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_E182: SingleObjectLoad: SingleObjLoad:
AllocateObject:
		lea	(Object_RAM+$800).w,a1	; a1=object
		move.w	#$5F,d0			; search to end of table

loc_E18A:
		tst.b	(a1)		; is object RAM slot empty?
		beq.s	locret_E196	; if yes, branch
		lea	$40(a1),a1	; load obj address ; goto next object RAM slot
		dbf	d0,loc_E18A	; repeat until end

locret_E196:
		rts
; End of function AllocateObject

; ===========================================================================
; ---------------------------------------------------------------------------
; Single object loading subroutine
; Find an empty object array AFTER the current one in the table
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_E198: S1SingleObjectLoad2: SingleObjLoad2:
AllocateObjectAfterCurrent:
		movea.l	a0,a1
		move.w	#$D000,d0
		sub.w	a0,d0	; subtract current object location
		lsr.w	#6,d0	; divide by $40
		subq.w	#1,d0	; keep from going over the object zone
		bcs.s	locret_E1B2

loc_E1A6:
		tst.b	(a1)		; is object RAM slot empty?
		beq.s	locret_E1B2	; if yes, branch
		lea	$40(a1),a1	; load obj address ; goto next object RAM slot
		dbf	d0,loc_E1A6	; repeat until end

locret_E1B2:
		rts
; End of function AllocateObjectAfterCurrent

; ===========================================================================
; ---------------------------------------------------------------------------
; Single object loading subroutine
; Find an empty object at or within < 12 slots after a3
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E1B4: SingleObjLoad3:
AllocateObject_2P:
		movea.l	a3,a1
		move.w	#$B,d0

loc_E1BA:
		tst.b	(a1)		; is object RAM slot empty?
		beq.s	locret_E1C6	; if yes, branch
		lea	$40(a1),a1	; load obj address ; goto next object RAM slot
		dbf	d0,loc_E1BA	; repeat until end

locret_E1C6:
		rts
; End of function AllocateObject_2P