.int:		dc.w .deactivated-.int
		dc.w .activated1-.int
		dc.w .activated2-.int
; word_1370A:
.deactivated:	dc.w 4
		dc.w $E801,$2000,$2000,   -8
		dc.w $E801,$2800,$2800,	   0
		dc.w $F803,    6,    3,   -8
		dc.w $F803, $806, $803,	   0
; word_1372C:
.activated1:	dc.w 4
		dc.w $E801,    2,    1,   -8
		dc.w $E801, $802, $801,	   0
		dc.w $F803,    6,    3,   -8
		dc.w $F803, $806, $803,	   0
; word_1374E:
.activated2:	dc.w 4
		dc.w $E801,$2004,$2002,   -8
		dc.w $E801,$2804,$2802,	   0
		dc.w $F803,    6,    3,   -8
		dc.w $F803, $806, $803,	   0