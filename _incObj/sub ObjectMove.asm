; ---------------------------------------------------------------------------
; Subroutine to make an object move and fall downward increasingly fast
; This moves the object horizontally and vertically
; and also applies gravity to its speed
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; ObjectFall:
ObjectMoveAndFall:
		move.l	x_pos(a0),d2	; load x position
		move.l	y_pos(a0),d3	; load y position
		move.w	x_vel(a0),d0	; load x speed
		ext.l	d0
		asl.l	#8,d0		; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,d2		; add x speed to x position
		move.w	y_vel(a0),d0	; load y speed
		addi.w	#$38,y_vel(a0)	; increase vertical speed (apply gravity)
		ext.l	d0
		asl.l	#8,d0		; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,d3		; add old y speed to y position
		move.l	d2,x_pos(a0)	; store new x position
		move.l	d3,y_pos(a0)	; store new y position
		rts
; End of function ObjectMoveAndFall

; ---------------------------------------------------------------------------
; Subroutine translating object speed to update object position
; This moves the object horizontally and vertically
; but does not apply gravity to it
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; SpeedToPos:
ObjectMove:
		move.l	x_pos(a0),d2	; load x position
		move.l	y_pos(a0),d3	; load y position
		move.w	x_vel(a0),d0	; load x speed
		ext.l	d0
		asl.l	#8,d0		; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,d2		; add x speed to x position
		move.w	y_vel(a0),d0	; load y speed
		ext.l	d0
		asl.l	#8,d0		; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,d3		; add old y speed to y position
		move.l	d2,x_pos(a0)	; store new x position
		move.l	d3,y_pos(a0)	; store new y position
		rts
; End of function ObjectMove