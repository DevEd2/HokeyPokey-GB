; ================================================================
; Macros
; ================================================================

if	!def(incMacros)
incMacros	set	1

; ================================================================
; Global macros
; ================================================================

; Copy a tileset to a specified VRAM address.
; USAGE: CopyTileset [tileset],[VRAM address],[number of tiles to copy]
; "tiles" refers to any tileset.
CopyTileset:	macro
	ld	bc,$10*\3		; number of tiles to copy
	ld	hl,\1			; address of tiles to copy
	ld	de,$8000+\2		; address to copy to
	call	CopyTiles
	endm
	
; Copy a 1BPP tileset to a specified VRAM address.
; USAGE: CopyTileset1BPP [tileset],[VRAM address],[number of tiles to copy]
; "tiles" refers to any tileset.
CopyTileset1BPP:	macro
	ld	bc,$10*\3		; number of tiles to copy
	ld	hl,\1			; address of tiles to copy
	ld	de,$8000+\2		; address to copy to
	call	CopyTiles1BPP
	endm
	
Load8x1Sprite:		macro
	ld	a,\2
	ld	[OAMBuffer2+\4],a
	ld	a,\1
	ld	[(OAMBuffer2+\4)+1],a
	ld	a,(\3*2)
	ld	[(OAMBuffer2+\4)+2],a
	ld	a,\5
	ld	[(OAMBuffer2+\4)+3],a
	endm
	
LoadSprite:			macro
	ld	hl,\1
	ld	de,\2
	ld	b,\3
	call	MetaspriteToOAM
	endm
	
;fade to white
Pal_FadeToWhite:	macro
	ld a,0
	ld [RGBG_first_pal_to_fade_bkg],a
	ld a,4
	ld [RGBG_pals_to_fade_bkg],a
	ld hl,Pal_White
	ld c,8
	ld b,1
	call	RGBG_RunComplexFadeBkg
	endm
	
Pal_FadeToPal:		macro
	ld a,0
	ld [RGBG_first_pal_to_fade_bkg],a
	ld a,\2
	ld [RGBG_pals_to_fade_bkg],a
	ld hl,\1
	ld c,\3
	ld b,1
	call RGBG_RunComplexFadeBkg
	endm
	
PlaySong:	macro
	di
	ld	a,IEF_TIMER+IEF_VBLANK
	ldh	[rIE],a
	ld	a,$e0
	ldh	[rTMA],a
	ld	a,$8c
	ldh	[rTAC],a
	ld	a,\1
	call	$7f0
	ldh	a,[ROMBank]
	ld	[rROMB0],a
	ei
	endm
	
EnableSound:	macro
	ld	a,%10000000
	ldh	[rNR52],a
	xor	%11110111
	ldh	[rNR50],a
	or	%10001000
	ldh	[rNR51],a
	endm
	
ByteToRAM:		macro
	ld	a,[hl+]
	ld	[\1],a
	endm

; ================================================================
; Project-specific macros
; ================================================================

; Insert project-specific macros here.


endc