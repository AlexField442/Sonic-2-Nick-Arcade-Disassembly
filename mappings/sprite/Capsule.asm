.int:		dc.w .capsule-.int
		dc.w .switch1-.int
		dc.w .broken-.int
		dc.w .switch2-.int
		dc.w .center1-.int
		dc.w .center2-.int
		dc.w .blank-.int
; word_19742:
.capsule:	dc.w 7
		dc.w $E00C,$2000,$2000, -$10
		dc.w $E80D,$2004,$2002, -$20
		dc.w $E80D,$200C,$2006,	   0
		dc.w $F80E,$2014,$200A, -$20
		dc.w $F80E,$2020,$2010,	   0
		dc.w $100D,$202C,$2016, -$20
		dc.w $100D,$2034,$201A,	   0
; word_1977C:
.switch1:	dc.w 1
		dc.w $F809,  $3C,  $1E,  -$C
; word_19786:
.broken:	dc.w 6
		dc.w	 8,$2042,$2021, -$20
		dc.w  $80C,$2045,$2022, -$20
		dc.w	 4,$2049,$2024,	 $10
		dc.w  $80C,$204B,$2025,	   0
		dc.w $100D,$202C,$2016, -$20
		dc.w $100D,$2034,$201A,	   0
; word_197B8:
.switch2:	dc.w 1
		dc.w $F809,  $4F,  $27,  -$C
; word_197C2:
.center1:	dc.w 2
		dc.w $E80E,$2055,$202A, -$10
		dc.w	$E,$2061,$2030, -$10
; word_197D4:
.center2:	dc.w 1
		dc.w $F007,$206D,$2036,   -8
; word_197DE:
.blank:		dc.w 0