section	"Graphics bank 3",romx,bank[5]

GFXBank3:
; ================================================================
; Tilesets
; ================================================================

SpriteTiles:	incbin	"GFX/Sprites.bin"
Tileset:		incbin	"GFX/Tileset.bin"

; ================================================================
; Attribute maps
; ================================================================

AttrMap_HUD:
	db	7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
	rept	17
		db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	endr

; ================================================================
; Palettes
; ================================================================

TilesetPal:
	dw	$477e,$26a3,$15e0,$0000
	dw	$7fff,$477e,$2e78,$0000
	dw	$7a91,$29b5,$0c8d,$0000
	dw	$7fff,$7a91,$65a9,$0000
	dw	$7a91,$18dc,$0014,$0000
	dw	$579e,$2a58,$1d72,$0000
	dw	$6b39,$7a69,$65a9,$0000
	dw	$0000,$3549,$6b18,$48c1

SpritePal:
	dw	$7c1f,$7fff,$2594,$0000
	dw	$7c1f,$7fff,$65a9,$0000
	dw	$7c1f,$7fff,$109a,$0000
	dw	$7c1f,$7fff,$2686,$0000
	dw	$7c1f,$7fff,$49ed,$0000
	dw	$7c1f,$1ebd,$04b4,$0000
	dw	$7c1f,$36da,$1d72,$08ca
	dw	$7c1f,$26a3,$15e0,$0d20

; ================================================================
; Metasprite definitions
; ================================================================

Sprite_HUDOverlay:
	db	8,19,$30,6
	db	8,93,$34,7
	db	8,101,$36,7
	db	8,99,$32,6
Sprite_HUDOverlay_End

Sprite_Pause:
	db	87,68,56,4
	db	87,76,58,4
	db	87,84,60,4
	db	87,92,62,4
	db	87,100,64,4
Sprite_Pause_End

Sprite_PauseDisabled:
	db	0,0,56,4
	db	0,0,58,4
	db	0,0,60,4
	db	0,0,62,4
	db	0,0,64,4
Sprite_PauseDisabled_End:
	
; ================================================================
; Tilemaps
; ================================================================

Tilemap_HUD:
	db	$2a,$2b,$2c,$2d,$2e,$29,$29,$29,$29,$29,$2f,$30,$31,$32,$33,$29,$29,$29,$29,$29
;	rept	17
;		db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	endr