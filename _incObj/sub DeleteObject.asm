; ---------------------------------------------------------------------------
; Subroutine to delete an object
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


DeleteObject:
		movea.l	a0,a1
; sub_CF3C:
DeleteObject2:
		moveq	#0,d1
		moveq	#$F,d0	; we want to clear up to the next object
		; delete the object by setting all of its bytes to 0
loc_CF40:
		move.l	d1,(a1)+
		dbf	d0,loc_CF40
		rts
; End of function DeleteObject