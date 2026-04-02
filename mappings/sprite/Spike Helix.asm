.int:		dc.w .spike1-.int
		dc.w .spike2-.int
		dc.w .spike3-.int
		dc.w .spike4-.int
		dc.w .spike5-.int
		dc.w .spike6-.int
		dc.w .blank-.int
		dc.w .spike7-.int
; word_87C4:
.spike1:	dc.w 1
		dc.w $F001,    0,    0, -4
; word_87CE:
.spike2:	dc.w 1
		dc.w $F505,    2,    1, -8
; word_87D8:
.spike3:	dc.w 1
		dc.w $F805,    6,    3, -8
; word_87E2:
.spike4:	dc.w 1
		dc.w $FB05,   $A,    5, -8
; word_87EC:
.spike5:	dc.w 1
		dc.w	 1,   $E,    7, -4
; word_87F6:
.spike6:	dc.w 1
		dc.w  $400,  $10,    8, -3
; word_8800:
.spike7:	dc.w 1
		dc.w $F400,  $11,    8, -3
; word_880A:
.blank:		dc.w 0