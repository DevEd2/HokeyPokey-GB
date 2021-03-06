section	"Graphics bank 2",romx,bank[4]

GFXBank2:
; ================================================================
; Tilesets
; ================================================================

TitleTiles:		incbin	"GFX/TitleTiles.bin"

MenuFont:		incbin	"GFX/MenuFont.bin"
HCMenuTiles:	incbin	"GFX/HCMenuTiles.bin"

; ================================================================
; Attribute maps
; ================================================================

AttrMap_Title:
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,1,1,1,0,1,1,1,0,0,0,0,0
	db	0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
	db	0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
	db	0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
	db	0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
	db	0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0
	db	0,0,2,3,0,2,4,1,1,1,1,1,1,1,1,1,6,0,0,0
	db	0,0,2,4,0,2,4,1,1,1,1,1,1,1,1,0,0,0,0,0
	db	0,0,0,4,0,2,3,7,7,1,1,1,1,1,1,0,0,0,0,0
	db	0,0,6,4,4,4,4,1,7,1,1,0,0,0,0,0,0,0,0,0
	db	0,0,6,5,5,5,4,1,7,7,1,6,6,0,0,0,0,0,0,0
	db	0,0,6,5,5,5,6,1,1,7,7,7,6,6,0,0,0,0,0,0
	db	0,0,6,6,6,4,4,1,1,4,4,6,6,6,6,0,0,0,0,0
	db	0,0,6,6,6,4,4,1,1,4,4,6,6,6,6,0,0,0,0,0
	db	0,0,6,6,4,4,4,4,4,4,4,6,1,1,0,0,0,0,0,0
	db	0,0,6,6,4,4,4,4,4,1,1,1,1,1,1,1,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	
AttrMap_HCMenu:
	incbin	"GFX/HCMenuAttr.bin"
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; ================================================================
; Palettes
; ================================================================

Pal_Title:
	dw	$66d3,$4d80,$2c80,$0000
	dw	$66d4,$41aa,$20e5,$0000
	dw	$36b9,$152f,$4d80,$2c80
	dw	$36b9,$152f,$2c80,$0000
	dw	$36b9,$152f,$00a7,$0000
	dw	$737b,$5a71,$3128,$0000
	dw	$2ed5,$0165,$00a0,$0000
	dw	$2db6,$10cf,$0009,$0000
	
Pal_HCMenu:
	incbin	"GFX/HCMenuPal.bin"
	
; ================================================================
; Metasprites
; ================================================================
			
; ================================================================
; Tilemaps
; ================================================================

TitleMap:
	db	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db	$00,$00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$00,$00
	db	$00,$00,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$00,$00
	db	$00,$00,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$30,$00,$00
	db	$00,$00,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$00,$00
	db	$00,$00,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$00,$00
	db	$00,$00,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f,$60,$00,$00
	db	$00,$00,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$00,$00
	db	$00,$00,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$00,$00
	db	$00,$00,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f,$90,$00,$00
	db	$00,$00,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$00,$00
	db	$00,$00,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$ab,$00,$00,$00,$00,$00,$00,$00
	db	$00,$00,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$00,$00,$00,$00,$00,$00
	db	$00,$00,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf,$c0,$c1,$c2,$c3,$c4,$00,$00,$00,$00,$00
	db	$00,$00,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1,$00,$00,$00,$00,$00
	db	$00,$00,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$00,$00,$00,$00,$00,$00
	db	$00,$00,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$00,$00,$00,$00
	db	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	
HCMenuMap:
	db	$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8A,$8B,$8C,$8D,$8E,$8F,$90,$91,$92,$93
	db	$94,$95,$96,$97,$98,$99,$9A,$9B,$9C,$9D,$9E,$9F,$A0,$A1,$A2,$A3,$A4,$A5,$A6,$A7
	db	$A8,$A9,$AA,$AB,$AC,$AD,$AE,$AF,$B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB
	db	$BC,$BD,$BE,$BF,$C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9,$CA,$CB,$CC,$CD,$CE,$CF
	db	$D0,$D1,$D2,$D3,$D4,$D5,$D6,$D7,$D8,$D9,$DA,$DB,$DC,$DD,$DE,$DF,$E0,$E1,$E2,$E3
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	
CreditsText:
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	DB	"      CREDITS       "
	DB	"                    "
	DB	"    DEVELOPED BY    "
	DB	"      DEVSOFT       "	
	DB	"                    "
	DB	"BASED OFF A GAME BY "
	DB	"   KARMA STUDIOS    "  
	DB	"                    "
	DB	"  LEAD PROGRAMMER   "
	DB	"   EDWARD WHALEN    "
	DB	"                    "
	DB	"     ADDITIONAL     "
	DB	"    PROGRAMMING     "
	DB	"   AARON ST. JOHN   "
	DB	"    ALEKSI EEBEN    "
	DB	"   JEFF FROHWEIN    "
	DB	"   ELDRED HABERT    "
	DB	"                    "
	DB	"      GRAPHICS      "
	DB	"   LARS VERHOEFF    "
	DB	"   EDWARD WHALEN    "
	DB	"                    "
	DB	"       MUSIC        "
	DB	"   EDWARD WHALEN    "
	DB	"                    "
	DB	"   SPECIAL THANKS   "
	DB	"  MARTIJN WENTING   "
	DB	"   FARIED VERHEUL   "
	DB	"   NIELS BROUWERS   "
	DB	"   BAS STEENDIJK    "
	DB	"    MARTIN KORTH    "
	DB	"   JEFF FROHWEIN    "
	DB	"  HIROKAZU TANAKA   "
	DB	"    GUMPEI YOKOI    "
	DB	"      AND YOU       "
	DB	"                    "
	DB	"THANKS FOR PLAYING! "
	DB	"                    "
	DB	"                    "
	DB	"                    "
	DB	"                    "
	DB	"                    "
	DB	"                    "
	DB	"                    "
	db	"                    "
	db	$80	; loop command