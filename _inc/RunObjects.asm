; ===========================================================================
; ---------------------------------------------------------------------------
; This runs the code of all the objects that are in Object_RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; ObjectsLoad:
RunObjects:
		lea	(MainCharacter).w,a0
		moveq	#$7F,d7			; run the first $80 objects out of levels
		moveq	#0,d0
		cmpi.b	#6,(MainCharacter+routine).w	; is Sonic dead?
		bcc.s	RunObjectsWhenPlayerIsDead	; if yes, branch

; ---------------------------------------------------------------------------
; This is THE place where each individual object's code gets called from
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_CB44:
RunObject:
		move.b	(a0),d0		; get the object's ID
		beq.s	loc_CB54	; if it's obj00, skip it
		add.w	d0,d0
		add.w	d0,d0	; d0 = object ID * 4
		movea.l	Obj_Index-4(pc,d0.w),a1	; load the address of the object's code
		jsr	(a1)	; dynamic call! to one of the the entries in Obj_Index
		moveq	#0,d0

loc_CB54:
		lea	$40(a0),a0	; load obj address
		dbf	d7,RunObject
		rts
; ---------------------------------------------------------------------------
; this skips certain objects to make enemies and things pause when Sonic dies
; loc_CB5E:
RunObjectsWhenPlayerIsDead:
		moveq	#$1F,d7
		bsr.s	RunObject
		moveq	#$5F,d7

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_CB64:
RunObjectsDisplayOnly:
		moveq	#0,d0
		move.b	(a0),d0		; get the object's ID
		beq.s	loc_CB74	; if it's obj00, skip it
		tst.b	render_flags(a0)	; should we render it?
		bpl.s	loc_CB74	; if not, skip it
		bsr.w	DisplaySprite

loc_CB74:
		lea	$40(a0),a0	; load obj address
		dbf	d7,RunObjectsDisplayOnly
		rts
; End of function RunObjects