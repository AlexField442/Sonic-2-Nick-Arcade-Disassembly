		opt	l.					; . is the local label symbol
		opt	ae-					; automatic evens disabled by defaultz
		opt	an+					; allow Intel/Zilog-style number suffixes (used in the Z80 code and definitions)
		opt	ws+					; allow statements to contain white-spaces
		opt	w+					; print warnings

; redefine align in terms of cnop, for the padding counter
align macro
	cnop 0,\1
	endm