; ================================================================
; Hokey Pokey (GB version)
; ================================================================

; Debug flag
; If set to 1, enable debugging features.

DebugFlag		set	0

UseSRAM			set	1

; ================================================================
; Project includes
; ================================================================

include	"Variables.asm"
include	"Constants.asm"
include	"Macros.asm"
include	"hardware.inc"
include	"rgbgrafx.inc"

; ================================================================
; Reset vectors (actual ROM starts here)
; ================================================================

SECTION	"Reset $00",ROM0[$00]
PlaySFX:
	push	af
	ld	a,[SFXOff]
	and	a
	jr	nz,.nosfx
	ld	a,Bank(SFXData)
	ld	[rROMB0],a
	pop	af
	call	$4000	; play sound effect
	ld	a,%01110111
	ldh	[rNR50],a
	ld	a,Bank(DevSound)
	ld	[rROMB0],a
	ret
.nosfx
	pop	af
	ret

SECTION	"Reset $38",ROM0[$38]
Reset38:	jp	ErrorHandler

; ================================================================
; Interrupt vectors
; ================================================================

SECTION	"VBlank interrupt",ROM0[$40]
IRQ_VBlank:
	call	VBlank_HiColor
	jp	UpdateSound
	reti

SECTION	"LCD STAT interrupt",ROM0[$48]
IRQ_STAT:
	jp	DoStat

SECTION	"Timer interrupt",ROM0[$50]
IRQ_Timer:
	reti

SECTION	"Serial interrupt",ROM0[$58]
IRQ_Serial:
	reti

SECTION	"Joypad interrupt",ROM0[$60]
IRQ_Joypad:
	reti
	
; ================================================================
; System routines
; ================================================================

include	"SystemRoutines.asm"

; ================================================================
; ROM header
; ================================================================

SECTION	"ROM header",ROM0[$100]

EntryPoint:
	nop
	jp	ProgramStart

NintendoLogo:	; DO NOT MODIFY!!!
	db	$ce,$ed,$66,$66,$cc,$0d,$00,$0b,$03,$73,$00,$83,$00,$0c,$00,$0d
	db	$00,$08,$11,$1f,$88,$89,$00,$0e,$dc,$cc,$6e,$e6,$dd,$dd,$d9,$99
	db	$bb,$bb,$67,$63,$6e,$0e,$ec,$cc,$dd,$dc,$99,$9f,$bb,$b9,$33,$3e

ROMTitle:		db	"HOKEY POKEY"				; ROM title (11 bytes)
ProductCode:	ds	4							; Product code (4 bytes)
GBCSupport:		db	$c0							; GBC support (0 = DMG only, $80 = DMG/GBC, $C0 = GBC only)
NewLicenseCode:	dw	0							; new license code (2 bytes)
SGBSupport:		db	0							; SGB support
CartType:		db	$1b							; Cart type (MBC5 + RAM + Battery)
ROMSize:		ds	1							; ROM size (handled by post-linking tool)
RAMSize:		db	2							; RAM size
DestCode:		db	1							; Destination code (0 = Japan, 1 = All others)
OldLicenseCode:	db	$33							; Old license code (if $33, check new license code)
ROMVersion:		db	0							; ROM version
HeaderChecksum:	ds	1							; Header checksum (handled by post-linking tool)
ROMChecksum:	ds	2							; ROM checksum (2 bytes) (handled by post-linking tool)

; ================================================================
; Start of program code
; ================================================================

ProgramStart:
	ld	d,a
	ld	e,b	
	
.wait				; wait for VBlank before disabling the LCD
	ldh	a,[rLY]
	cp	$90
	jr	nz,.wait
	xor	a
	ld	[rLCDC],a	; disable LCD
	call	ClearWRAM
	xor	a
	ld	bc,$8080
.clearloop
	ld	[c],a
	inc	c
	dec	b
	jr	nz,.clearloop
	
.checkGBC
	ld	a,[GBType]
	cp	1
	jr	z,.dmg
	cp	2
	jp	z,.initdone
	cp	3
	jp	z,.initdone

	ld	a,d
	cp	$11
	ld	a,1			; xor a can't be used because it clears the zero flag
	jp	z,.gbc
	; display gbc only screen and halt
.dmg
	ld	[GBType],a
	ld	a,Bank(HCMenuTiles)
	ld	[rROMB0],a
	CopyTileset	MenuFont,0,46
	ld	a,Bank(GBCOnlyTiles)
	ldh	[ROMBank],a
	ld	[rROMB0],a
	CopyTileset	GBCOnlyTiles,$800,$45
	ld	hl,GBCOnlyMap
	call	LoadScreen2
	
	ld	a,%11100001
	ldh	[rBGP],a	; init BG palette
	ld	a,40
	ldh	[rSCY],a
	ld	a,%10010001
	ldh	[rLCDC],a	; enable LCD
	ld	a,IEF_VBLANK
	ldh	[rIE],a		; enable interrupts
	ei
	ld	a,10
	ld	hl,.gbcOnlyHeader
	call	PrintStringMenu
	ld	hl,.gbcOnlyText
	call	ShowMenuText
	ld	a,5
	ld	[DMGScreenTimer],a
	ld	b,60
.dmgloop
	push	bc
	call	CheckInput
	ld	a,[sys_btnHold]
	cp	_A+_Start
	jp	z,ShowSoundTest
	halt
	pop	bc
	dec	b
	jr	nz,.dmgloop
	ld	b,60
	ld	a,[DMGScreenTimer]
	dec	a
	ld	[DMGScreenTimer],a
	jr	nz,.dmgloop
	ld	hl,ClearText
	call	ShowMenuText
	ld	hl,.gbcOnlyText2
	call	ShowMenuText
	ld	a,60
	ld	[DMGScreenTimer],a
	ld	b,a
.dmgloop2
	push	bc
	call	CheckInput
	ld	a,[sys_btnHold]
	cp	_A+_Start
	jp	z,ShowSoundTest
	halt
	pop	bc
	dec	b
	jr	nz,.dmgloop2
	ld	b,60
	ld	a,[DMGScreenTimer]
	dec	a
	ld	[DMGScreenTimer],a
	jr	nz,.dmgloop2
	ld	hl,ClearText
	call	ShowMenuText
	ld	hl,.gbcOnlyText3
	call	ShowMenuText
.dmgloop3
	call	CheckInput
	ld	a,[sys_btnHold]
	cp	_A+_Start
	jp	z,ShowSoundTest
	halt
	jr	.dmgloop3
	
.gbcOnlyHeader
	db	"  - HOKEY POKEY -   ",0
.gbcOnlyText
	db	"THIS GAME WILL ONLY*",0
	db	"WORK ON A GAME BOY**",0
	db	"COLOR OR GAME BOY***",0
	db	"ADVANCE. PLEASE USE*",0
	db	"A GAME BOY COLOR OR*",0
	db	"GAME BOY ADVANCE TO*",0
	db	"PLAY THIS GAME.*****",0
	db	"********************",0
	db	"******************  ",0
	db	"TURN THE POWER OFF.*",$ff
	
.gbcOnlyText2
	db	"ALTERNATIVELY, PRESS",0
	db	"A + START TO GO TO**",0
	db	"THE SOUND TEST!*****",0
	db	"********************",0
	db	"********************",0
	db	"********************",0
	db	"********************",0
	db	"********************",0
	db	"********************",0
	db	"********************",$ff

.gbcOnlyText3
	db	"SINCE YOU SEEM TO BE",0
	db	"STICKING AROUND,****",0
	db	"I'LL LET YOU IN ON A",0
	db	"LITTLE SECRET: ON***",0
	db	"THE TITLE SCREEN,***",0
	db	"PRESS UP, DOWN,*****",0
	db	"DOWN, UP, RIGHT,****",0
	db	"LEFT, UP, DOWN TO***",0
	db	"ENABLE DEBUG MODE.**",0
	db	"********************",$ff
	
.gbc
	ld	a,e
	and	a			; check if on GBA
	ld	a,2
	jr	z,.notgba
	inc	a
.notgba
	ld	[GBType],a	
.initdone
	ld	a,[MusicOff]
	ld	a,[SFXOff]
	ld	a,Bank(DevSound)
	ld	[rROMB0],a
	call	DS_Stop
	call	DoubleSpeedMode
	if	UseSRAM
	call	CheckSRAM
	endc
	call	CopyDMARoutine
	di
	
	call	CheckInput
	ld	a,[sys_btnHold]
	bit	btnSelect,a
	jr	z,.noclear
	ld	a,2
	call	ShowSaveErrorScreen
.noclear	
	ld	a,Bank(CopyrightTiles)
	ldh	[ROMBank],a
	ld	[rROMB0],a
	
ShowCopyrightScreen:
	CopyTileset	CopyrightTiles,0,$100		; first half
	ld	a,1
	ldh	[rVBK],a
	CopyTileset	CopyrightTiles+$1000,0,$68	; second half
	xor	a
	ldh	[rVBK],a
.continue
	ld	hl,Pal_Copyright
	call	LoadBGPal
	ld	hl,Pal_White
	call	LoadObjPal
	
	ld	hl,ScreenMap
	call	LoadScreen
	
	ld	a,1
	ldh	[rVBK],a
	ld	hl,AttrMap_CopyrightScreen
	call	LoadScreen						; when VRAM bank 1 is selected this copies attribute tables
	xor	a
	ldh	[rVBK],a
	
	ld	a,IEF_VBLANK
	ldh	[rIE],a
	ld	a,%10010001
	ldh	[rLCDC],a	; enable LCD
	ld	a,180
	ld	[ScreenTimer],a
	ei
	
.waitloop
	call	CheckInput
	ld	a,[sys_btnPress]
	bit	btnStart,a
	jr	nz,.break
	ld	a,[ScreenTimer]
	dec	a
	ld	[ScreenTimer],a
	halt
	jr	nz,.waitloop
.break
	ld	a,1
	ld	[RGBG_fade_to_color],a
	call	RGBG_SimpleFadeOut
	xor	a
	ldh	[rLCDC],a
	
ShowDevSoftSplash:
	di
	call	ClearScreen
	call	ClearAttribute
	ld	a,Bank(DevsoftTiles)
	ld	[rROMB0],a
	CopyTileset	DevsoftTiles,0,$60
	ld	hl,DevsoftTilemap
	call	LoadScreen
	
	ld	a,%10010001
	ldh	[rLCDC],a	; enable LCD
	ei
	Pal_FadeToPal	Pal_Grayscale,1,8
	ld	a,180
	ld	[ScreenTimer],a
	
.loop
	call	CheckInput
	ld	a,[sys_btnPress]
	bit	btnStart,a
	jr	nz,.break
	ld	a,[ScreenTimer]
	dec	a
	ld	[ScreenTimer],a
	halt
	jr	nz,.loop
.break
	ld	a,0
	ld	[RGBG_fade_to_color],a
	call	RGBG_SimpleFadeOut
	xor	a
	ldh	[rLCDC],a

ShowKarmaSplash:
	di
	call	ClearScreen
	
	ld	a,Bank(KarmaTiles)
	ld	[rROMB0],a
	CopyTileset	KarmaTiles,0,$b1
	ld	hl,KarmaStudiosTilemap
	call	LoadScreen
	
	ld	a,1
	ldh	[rVBK],a
	ld	hl,AttrMap_Karma
	call	LoadScreen
	xor	a
	ldh	[rVBK],a

	ld	a,%10010001
	ldh	[rLCDC],a	; enable LCD
	Pal_FadeToPal	Pal_Karma,3,8
	ld	hl,Pal_Karma
	call	LoadBGPal
	ld	a,180
	ld	[ScreenTimer],a
	ei
.loop
	call	CheckInput
	ld	a,[sys_btnPress]
	bit	btnStart,a
	jr	nz,.break
	ld	a,[ScreenTimer]
	dec	a
	ld	[ScreenTimer],a
	halt
	jr	nz,.loop
.break
	ld	a,1
	ld	[RGBG_fade_to_color],a
	call	RGBG_SimpleFadeOut
	xor	a
	ldh	[rLCDC],a
		
ShowTitleScreen:
	di
	ld	a,Bank(TitleTiles)
	ldh	[ROMBank],a
	ld	[rROMB0],a
	
	CopyTileset	TitleTiles,0,$ec
	CopyTileset1BPP	HexFont,$f00,16
	
	ld	hl,TitleMap
	call	LoadScreen
	ld	a,1
	ldh	[rVBK],a
	ld	hl,AttrMap_Title
	call	LoadScreen
	xor	a
	ldh	[rVBK],a
	
	ld	hl,Pal_Title
	call	LoadBGPal
	ld	a,Bank(GFXBank1)
	ld	[rROMB0],a
	ld	hl,Pal_Grayscale
	xor	a
	call	LoadObjPal
	ld	a,1
	ld	[rROMB0],a
	
	if	!DebugFlag
		ld	a,[CheatModeOn]
		and	a
		jr	z,.nocheat
	endc
	ld	a,[CurrentLevel]
	ld	hl,$9800
	call	Title_DrawHex
.nocheat
	ld	a,%10010001
	ldh	[rLCDC],a
	
	ld	a,1
	ld	[rROMB0],a
	xor	a
	call	DS_Init
	
	xor	a
	ldh	[rSCX],a
	ldh	[rSCY],a
		
.loop
	di
	; temp menu code
	call	CheckInput
	ld	a,[sys_btnPress]
	bit	btnUp,a
	jr	nz,.cursorUp
	bit	btnDown,a
	jr	nz,.cursorDown
	bit	btnLeft,a
	jr	nz,.prevLevel
	bit	btnRight,a
	jr	nz,.nextLevel
	bit	btnStart,a
	jr	nz,.gotoMenu
	bit	btnSelect,a
	jr	nz,.soundTest
	jp	.continue

.cursorUp
	if	DebugFlag
		ld	a,SFX_Cursor
		rst	$00
	else
		ld	a,[CheatModeOn]
		and	a
		jp	nz,.continue
		call	CheckCheat
	endc
	jp	.continue
.cursorDown
	if	DebugFlag
		ld	a,SFX_Cursor
		rst	$00
	else
		ld	a,[CheatModeOn]
		and	a
		jp	nz,.continue
		call	CheckCheat
	endc
	jp	.continue
.prevLevel
	if	DebugFlag
		ld	a,[CurrentLevel]
		dec	a
		ld	[CurrentLevel],a
		push	af
		RGBG_WaitForVRAM
		pop	af
		ld	hl,_SCRN0
		call	Title_DrawHex
	else
		ld	a,[CheatModeOn]
		and	a
		jr	nz,.doPrev
		call	CheckCheat
		jr	.continue
.doPrev
		ld	a,[CurrentLevel]
		dec	a
		ld	[CurrentLevel],a
		push	af
		RGBG_WaitForVRAM
		pop	af
		ld	hl,_SCRN0
		call	Title_DrawHex
	endc
	jr	.continue
.nextLevel
	if	DebugFlag
		ld	a,[CurrentLevel]
		inc	a
		ld	[CurrentLevel],a
		push	af
		RGBG_WaitForVRAM
		pop	af
		ld	hl,_SCRN0
		call	Title_DrawHex
	else
		ld	a,[CheatModeOn]
		and	a
		jr	nz,.doNext
		call	CheckCheat
		jr	.continue
.doNext
		ld	a,[CurrentLevel]
		inc	a
		ld	[CurrentLevel],a
		push	af
		RGBG_WaitForVRAM
		pop	af
		ld	hl,_SCRN0
		call	Title_DrawHex
	endc
	jr	.continue
.soundTest
	if	!DebugFlag
		ld	a,[CheatModeOn]
		and	a
		jr	z,.continue
	endc
	jp	ShowSoundTest
	
.gotoMenu
	call	DS_Stop
	ld	a,%10000000
	EnableSound
	ld	a,SFX_GotKey
	rst	$00
	ld	a,1
	ld	[RGBG_fade_to_color],a
	call	RGBG_SimpleFadeOut
	ld	a,%10000000
	ldh	[rLCDC],a
	ld	a,15
	ld	[ScreenTimer],a
.loop2
	halt
	ld	a,[ScreenTimer]
	dec	a
	ld	[ScreenTimer],a
	jr	nz,.loop2
	jr	ShowMainMenu
	
.continue
	ei
	halt
	jp	.loop

; ================================================================
	
ShowMainMenu:
	di
	xor	a
	ldh	[rLCDC],a
	call	ClearVRAM
	ld	a,Bank(HCMenuTiles)
	ld	[rROMB0],a
	CopyTileset	HCMenuTiles,$800,$64
	CopyTileset	MenuFont,0,46			; for sprites
	CopyTileset	MenuFont,$1000,46		; for BG
	ld	hl,HCMenuMap
	call	LoadScreen
	ld	a,1
	ldh	[rVBK],a
	ld	hl,AttrMap_HCMenu
	call	LoadScreen
	xor	a
	ldh	[rVBK],a
	ld	[CurrentMenu],a
	ld	[MenuPos],a
	
	ld	a,136
	ld	[MenuItem1Offset],a
	ld	[MenuItem2Offset],a
	ld	[MenuItem3Offset],a
	ld	[MenuItem4Offset],a
	ld	[MenuItem5Offset],a
	
	call	ClearOAM
	call	$ff80
	
	ld	a,10
	ld	hl,MenuString_MainMenu
	call	PrintStringMenu
	
	ld	a,3
	ld	[MenuMax],a
	
	ld	a,Bank(DevSound)
	ld	[rROMB0],a
	ld	a,mus_Menu
	call	DS_Init
	
	ld	a,IEF_VBLANK+IEF_LCDC
	ldh	[rIE],a
	
	ld	a,1
	ld	[StatType],a
	ld	a,5
	ld	[StatCounter],a
	
	ld	a,%10000011
	ldh	[rLCDC],a
	ei
	
	ld	a,40
	ldh	[rSCY],a
	
	Pal_FadeToPal	Pal_Menu,1,8
	xor	a
	ld	hl,Pal_MenuSpr
	call	LoadObjPalLine
	
	ld	a,12
	ld	hl,MenuString_StartGame
	call	PrintStringMenu
	ld	a,14
	ld	hl,MenuString_Options
	call	PrintStringMenu
	ld	a,16
	ld	hl,MenuString_HowToPlay
	call	PrintStringMenu
	ld	a,18
	ld	hl,MenuString_Exit
	call	PrintStringMenu
	ld	a,20
	ld	hl,MenuString_Null
	call	PrintStringMenu
	ld	a,MenuItem1Scanline
	ldh	[rLYC],a
	ld	a,%01000000
	ldh	[rSTAT],a
	
	ld	a,1
	ld	[DoHiColor],a
	
	ld	hl,.scrollInTable
	xor	a
.scrollLoop
	ld	a,[hl+]
	cp	$ff
	jr	z,.scrollDone
	ld	[HiColorOffset],a
	push	hl
.halt
	halt
	ld	a,[VBLFlag]
	and	a
	jr	z,.halt
	xor	a
	ld	[VBLFlag],a
	pop	hl
	jr	.scrollLoop
.scrollDone
	xor	a
	ld	[HiColorOffset],a
.halt2
	halt
	ld	a,[VBLFlag]
	and	a
	jr	z,.halt2
	xor	a
	ld	[VBLFlag],a
	
	ld	hl,.menuScrollInTable
	call	DoMenuScroll
	
.loop
	call	CheckInput
	ld	a,[sys_btnPress]
	bit	btnUp,a
	jr	nz,.prevItem
	bit	btnDown,a
	jr	nz,.nextItem
	bit	btnA,a
	jr	nz,.selectItem
	bit	btnB,a
	jr	nz,.goBack
	jp	.done
.prevItem
	ld	a,[MenuPos]
	dec	a
	cp	$ff
	jr	nz,.noMin
	ld	a,[MenuMax]
.noMin
	ld	[MenuPos],a
	ld	a,SFX_Cursor
	rst	$00
	jp	.done
.nextItem
	ld	a,[MenuPos]
	inc	a
	ld	b,a
	ld	a,[MenuMax]
	inc	a
	cp	b
	ld	a,b
	jr	nz,.noMax
	xor	a
.noMax
	ld	[MenuPos],a
	ld	a,SFX_Cursor
	rst	$00
	jp	.done
.selectItem
	ld	a,SFX_MenuSelect
	rst	$00
	ld	a,[CurrentMenu]
	and	a
	jr	nz,.selectNotMenu
	ld	a,[MenuPos]
	add	a
	add	a,.mainMenuSelectList%256
	ld	l,a
	adc	a,.mainMenuSelectList/256
	sub	l
	ld	h,a
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	jp	hl
.selectNotMenu
	ld	a,[CurrentMenu]
	dec	a
	jp	nz,.done
	ld	a,[MenuPos]
	add	a
	add	a,.optionsMenuSelectList%256
	ld	l,a
	adc	a,.optionsMenuSelectList/256
	sub	l
	ld	h,a
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	jp	hl
	
.goBack
	call	ClearOAM
	ld	a,SFX_MenuBack
	rst	$00
	ld	a,[CurrentMenu]
	and	a
	jp	z,.exit
	dec	a
	jr	z,.gotoMain
	dec	a
	jr	z,.gotoMain
	jp	.exit
.gotoMain
	ld	a,10
	ld	hl,MenuString_MainMenu
	call	PrintStringMenu
	xor	a
	ld	[CurrentMenu],a
	ld	a,1
	ld	[MenuPos],a
	ld	hl,.menuScrollOutTable
	call	DoMenuScroll
.gotoMain_noscroll	
	ld	a,136
	ld	[MenuItem1Offset],a
	ld	[MenuItem2Offset],a
	ld	[MenuItem3Offset],a
	ld	[MenuItem4Offset],a
	ld	[MenuItem5Offset],a
	ld	a,3
	ld	[MenuMax],a
	ld	a,%01000000
	ldh	[rSTAT],a
	ld	a,12
	ld	hl,MenuString_StartGame
	call	PrintStringMenu
	ld	a,14
	ld	hl,MenuString_Options
	call	PrintStringMenu
	ld	a,16
	ld	hl,MenuString_HowToPlay
	call	PrintStringMenu
	ld	a,18
	ld	hl,MenuString_Exit
	call	PrintStringMenu
	ld	a,20
	ld	hl,MenuString_Null
	call	PrintStringMenu
	
	ld	hl,.menuScrollInTable
	call	DoMenuScroll
	jp	.done
	
.done
	ld	hl,.oscTable
	ld	a,[MenuCursorOffset]
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl]
	cp	$80
	jr	nz,.noreset
	xor	a
	ld	[MenuCursorOffset],a
	jr	.done	; read new value
.noreset
	ld	c,a
	ld	a,[MenuCursorOffset]
	inc	a
	ld	[MenuCursorOffset],a

	ld	hl,OAMBuffer
	ld	a,[MenuPos]
	swap	a
	add	72
	ld	[hl+],a
	push	af
	ld	a,MenuCursor1X
	add	c
	ld	[hl+],a
	ld	a,44
	ld	[hl+],a
	xor	a
	ld	[hl+],a
	pop	af
	ld	[hl+],a
	ld	a,MenuCursor2X
	sub	c
	ld	[hl+],a
	ld	a,44
	ld	[hl+],a
	ld	a,XFlip
	ld	[hl],a
	
	call	$ff80
.halt3
	halt
	ld	a,[VBLFlag]
	and	a
	jr	z,.halt3
	xor	a
	ld	[VBLFlag],a
	ld	a,MenuItem1Scanline
	ldh	[rLYC],a
	jp	.loop

.scrollInTable
	db	40,38,36,34,32,30,28,26,24,22,20,18,16,15,14,13,12,11,10,9,8,7,7,6,6,5,5,4,4,3,3,2,2,$ff
	
.menuScrollInTable
	db	0,128,133,138,142,147,152,157,162,167,172,176,181,185,190,194,198
	db	202,206,210,214,218,221,224,228,231,234,236,239,241,243,245,247
	db	249,250,251,253,253,254,255,255,0
	
.scrollOutTable
	db	2,3,4,6,8,10,12,15,18,21,24,28,30,33,36,39,40,$ff
	
.menuScrollOutTable
	db	1,255,255,254,253,253,251,250,249,247,245,243,241,239,236,234,231,228
	db	224,221,218,214,210,206,202,198,194,190,185,181,176,172,167,162
	db	157,152,147,142,138,133,128,0

.oscTable
	db	1,1,2,2,2,2,1,1,0,0,-1,-1,-2,-2,-2,-2,-1,-1,0,0,$80
	
.startGame
	call	DS_Stop
	ld	a,%10000000
	EnableSound
	ld	a,SFX_GotKey
	rst	$00
	
	call	ClearOAM
	
	ld	hl,.menuScrollOutTable
	call	DoMenuScroll
	
	ld	hl,.scrollOutTable
	xor	a
.scrollLoop2
	ld	a,[hl+]
	cp	$ff
	jr	z,.scrollDone2
	ld	[HiColorOffset],a
	push	hl
.halt4
	halt
	ld	a,[VBLFlag]
	and	a
	jr	z,.halt4
	xor	a
	ld	[VBLFlag],a
	pop	hl
	jr	.scrollLoop2
.scrollDone2

	xor	a
	ld	[DoHiColor],a
	ld	a,1
	ld	[RGBG_fade_to_color],a
	call	RGBG_SimpleFadeOut
	xor	a
	ldh	[rLCDC],a
	jp	InitGame
	
.exit
	ld	a,SFX_MenuBack
	rst	$00
	call	ClearOAM
	ld	hl,.menuScrollOutTable
	call	DoMenuScroll

	call	DS_Fade
	ld	hl,.scrollOutTable
	xor	a
.scrollLoop3
	ld	a,[hl+]
	cp	$ff
	jr	z,.scrollDone3
	ld	[HiColorOffset],a
	push	hl
	halt
	pop	hl
	jr	.scrollLoop3
.scrollDone3
	xor	a
	ld	[DoHiColor],a
	
	ld	a,1
	ld	[RGBG_fade_to_color],a
	call	RGBG_SimpleFadeOut
	xor	a
	ldh	[rLCDC],a
	jp	ShowTitleScreen
	
.mainMenuSelectList:
	dw	.startGame
	dw	.showOptionsMenu
	dw	.howToPlay
	dw	.exit
	
.optionsMenuSelectList
	dw	.toggleMusic
	dw	.soundTest
	dw	.credits
	dw	.clearSave
	dw	.goBack
	
.showOptionsMenu
	call	ClearOAM
	ld	a,10
	ld	hl,MenuString_OptionsMenu
	call	PrintStringMenu
	ld	a,1
	ld	[CurrentMenu],a	
	xor	a
	ld	[rSTAT],a
	ld	[MenuPos],a
	ld	a,4
	ld	[MenuMax],a
	
	ld	hl,.menuScrollOutTable
	call	DoMenuScroll
.showOptionsMenu_noscroll
	ld	a,128
	ld	[MenuItem1Offset],a
	ld	[MenuItem2Offset],a
	ld	[MenuItem3Offset],a
	ld	[MenuItem4Offset],a
	ld	[MenuItem5Offset],a
	ld	a,%01000000
	ldh	[rSTAT],a
	ld	a,[MusicOff]
	and	a
	ld	a,12
	jr	nz,.showOptionsMusicOff
	ld	hl,MenuString_MusicOn
	jr	.showOptionsPrintMusicString
.showOptionsMusicOff
	ld	hl,MenuString_MusicOff
.showOptionsPrintMusicString
	call	PrintStringMenu
	ld	a,14
	ld	hl,MenuString_SoundTest
	call	PrintStringMenu
	ld	a,16
	ld	hl,MenuString_Credits
	call	PrintStringMenu
	ld	a,18
	ld	hl,MenuString_ClearSave
	call	PrintStringMenu
	ld	a,20
	ld	hl,MenuString_Back
	call	PrintStringMenu
	ld	a,128
	ld	hl,.menuScrollInTable
	call	DoMenuScroll
	jp	.done

.toggleMusic
	ld	a,[MusicOff]
	xor	1
	ld	[MusicOff],a
	and	a
	ld	a,12
	jr	nz,.toggleMusicOff
	push	af
	ld	a,mus_Menu
	call	DS_Init
	pop	af
	ld	hl,MenuString_MusicOn
	jr	.toggleMusicDone
.toggleMusicOff
	push	af
	call	DS_Stop
	EnableSound
	pop	af
	ld	hl,MenuString_MusicOff
.toggleMusicDone
	call	PrintStringMenu
	jp	.done
	
.soundTest
	; TODO: Replace this with something fancier
	call	ClearOAM
	ld	hl,.menuScrollOutTable
	call	DoMenuScroll	
	ld	[DoHiColor],a
	ld	[rSCX],a
	ld	[rSCY],a
	ld	[MenuPos],a
	ld	hl,MusicOff
	ld	a,[hl]
	ld	[TempMusicOff],a
	xor	a
	ld	[hl+],a
	ld	a,[hl]
	ld	[TempSFXOff],a
	xor	a
	ld	[hl],a
	jp	ShowSoundTest
	
.credits
	ld	a,10
	ld	hl,MenuString_CreditsMenu
	call	PrintStringMenu
	call	ClearOAM
	ld	hl,.menuScrollOutTable
	call	DoMenuScroll
	ld	hl,CreditsMenu
	call	ShowMenuText
	xor	a
	ldh	[rSTAT],a
.creditsWait
	call	CheckInput
	ld	a,[sys_btnPress]
	and	a
	jr	nz,.exitCredits
	halt
	jr	.creditsWait
.exitCredits
	ld	a,10
	ld	hl,MenuString_OptionsMenu
	call	PrintStringMenu
	ld	a,SFX_MenuSelect
	rst	$00
	ld	hl,ClearText
	call	ShowMenuText
	xor	a
	ld	[MenuItem1Offset],a
	ld	[MenuItem2Offset],a
	ld	[MenuItem3Offset],a
	ld	[MenuItem4Offset],a
	ld	[MenuItem5Offset],a
	ld	a,MenuItem1Scanline
	ldh	[rLYC],a
	jp	.showOptionsMenu_noscroll
	
.howToPlay
	ld	a,10
	ld	hl,MenuString_HelpMenu
	call	PrintStringMenu
	call	ClearOAM
	ld	hl,.menuScrollOutTable
	call	DoMenuScroll
	ld	hl,HelpText
	ld	hl,HelpText
	call	ShowMenuText
	xor	a
	ldh	[rSTAT],a
.helpWaitLoop
	call	CheckInput
	ld	a,[sys_btnPress]
	and	a
	jr	nz,.exitHelpMenu
	halt
	jr	.helpWaitLoop
.exitHelpMenu
	ld	a,10
	ld	hl,MenuString_MainMenu
	call	PrintStringMenu
	ld	a,SFX_MenuSelect
	rst	$00
	ld	hl,ClearText
	call	ShowMenuText
	xor	a
	ld	[MenuItem1Offset],a
	ld	[MenuItem2Offset],a
	ld	[MenuItem3Offset],a
	ld	[MenuItem4Offset],a
	ld	[MenuItem5Offset],a
	ld	a,MenuItem1Scanline
	ldh	[rLYC],a
	jp	.gotoMain_noscroll
	
.clearSave
	ld	a,SFX_Trill
	rst	$00
	jp	.done
	
Pal_Menu:
	dw	$45ec,$7fff,$354a,$0000
Pal_MenuSpr:
	dw	$7c1f,$7fff,$354a,$0000

; main menu
MenuString_Null:			db	"                    ",0
MenuString_MainMenu:		db	"   - MAIN  MENU -   ",0
MenuString_StartGame:		db	"     START GAME     ",0
MenuString_Options:			db	"      SETTINGS      ",0
MenuString_HowToPlay		db	"        HELP        ",0
MenuString_Exit:			db	"        EXIT        ",0

MenuString_OptionsMenu:		db	"    - SETTINGS -    ",0
MenuString_MusicOn:			db	"    MUSIC     ON    ",0
MenuString_MusicOff:		db	"    MUSIC    OFF    ",0
MenuString_SoundTest:		db	"     SOUND TEST     ",0
MenuString_Credits:			db	"      CREDITS       ",0
MenuString_ClearSave:		db	"     CLEAR SAVE     ",0
MenuString_Back:			db	"        BACK        ",0

MenuString_SoundTestMenu:	db	"   - SOUND TEST -   ",0
MenuString_CreditsMenu:		db	"    - CREDITS -     ",0

MenuString_HelpMenu:		db	"      - HELP -      ",0

; For menu text, command 0 will jump to the next line, and $FF terminates the text.
; * is a special command which will print the next character immediately.
HelpText:				
	db	"GET HOKEY AND POKEY*",0
	db	"TO THE EXIT IN TIME.",0
	db	"**USE THE D-PAD TO**",0
	db	"MOVE, AND PRESS A OR",0
	db	"**B TO FIRE. PRESS**",0
	db	"*START TO PAUSE THE*",0
	db	"*******GAME.        ",0
	db	"     GOOD LUCK!*****",0
	db	"**************      ",0
	db	"- PRESS ANY BUTTON -",$ff
	
CreditsMenu:
	db	"PROGRAMMING:********",0
	db	"***    EDWARD WHALEN",0
	db	"***    ELDRED HABERT",0
	db	"****************    ",0
	db	"GRAPHICS:***********",0
	db	"***    LARS VERHOEFF",0
	db	"***    EDWARD WHALEN",0
	db	"****************    ",0
	db	"MUSIC AND FX:*******",0
	db	"***    EDWARD WHALEN",$ff
						
ClearText:
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",$ff

DoMenuScroll:
	ld	d,h
	ld	e,l
	ld	a,1
	ld	[MenuItem1ScrollPos],a
	ld	[MenuItem2ScrollPos],a
	ld	[MenuItem3ScrollPos],a
	ld	[MenuItem4ScrollPos],a
	ld	[MenuItem5ScrollPos],a
	dec	a
	ld	[MenuItem1Timer],a
	add	4
	ld	[MenuItem2Timer],a
	add	4
	ld	[MenuItem3Timer],a
	add	4
	ld	[MenuItem4Timer],a
	add	4
	ld	[MenuItem5Timer],a
	ld	a,[hl]
	ld	[MenuDoClear],a
	ld	a,%01000000
	ldh	[rSTAT],a
.menuscroll1
	ld	a,[MenuItem1Timer]
	dec	a
	cp	$ff
	jr	z,.menunoreset1
	ld	[MenuItem1Timer],a
	jr	.menuscroll2
.menunoreset1
	ld	h,d
	ld	l,e
	ld	a,[MenuItem1ScrollPos]
	ld	b,a
	add	l
	ld	l,a
	jr	nc,.menuscrollnc1
	inc	h
.menuscrollnc1
	ld	a,[hl]
	and	a
	jr	nz,.doscroll1
	xor	a
	ld	[MenuItem1Offset],a
	ld	a,[MenuDoClear]
	and	a
	jr	z,.menuscroll2
	ld	a,$c
	ld	hl,MenuString_Null
	push	de
	call	PrintString
	pop	de
	jr	.menuscroll2
.doscroll1
	ld	[MenuItem1Offset],a
	ld	a,b
	inc	a
	ld	[MenuItem1ScrollPos],a
.menuscroll2
	ld	a,[MenuItem2Timer]
	dec	a
	cp	$ff
	jr	z,.menunoreset2
	ld	[MenuItem2Timer],a
	jr	.menuscroll3
.menunoreset2
	ld	h,d
	ld	l,e
	ld	a,[MenuItem2ScrollPos]
	ld	b,a
	add	l
	ld	l,a
	jr	nc,.menuscrollnc2
	inc	h
.menuscrollnc2
	ld	a,[hl]
	and	a
	jr	nz,.doscroll2
	xor	a
	ld	[MenuItem2Offset],a
	ld	a,[MenuDoClear]
	and	a
	jr	z,.menuscroll3
	ld	a,$e
	ld	hl,MenuString_Null
	push	de
	call	PrintString
	pop	de
	jr	.menuscroll3
.doscroll2
	ld	[MenuItem2Offset],a
	ld	a,b
	inc	a
	ld	[MenuItem2ScrollPos],a
.menuscroll3
	ld	a,[MenuItem3Timer]
	dec	a
	cp	$ff
	jr	z,.menunoreset3
	ld	[MenuItem3Timer],a
	jr	.menuscroll4
.menunoreset3
	ld	h,d
	ld	l,e
	ld	a,[MenuItem3ScrollPos]
	ld	b,a
	add	l
	ld	l,a
	jr	nc,.menuscrollnc3
	inc	h
.menuscrollnc3
	ld	a,[hl]
	and	a
	jr	nz,.doscroll3
	xor	a
	ld	[MenuItem3Offset],a
	ld	a,[MenuDoClear]
	and	a
	jr	z,.menuscroll4
	ld	a,$10
	ld	hl,MenuString_Null
	push	de
	call	PrintString
	pop	de
	jr	.menuscroll4
.doscroll3
	ld	[MenuItem3Offset],a
	ld	a,b
	inc	a
	ld	[MenuItem3ScrollPos],a
.menuscroll4
	ld	a,[MenuItem4Timer]
	dec	a
	cp	$ff
	jr	z,.menunoreset4
	ld	[MenuItem4Timer],a
	jr	.menuscroll5
.menunoreset4
	ld	h,d
	ld	l,e
	ld	a,[MenuItem4ScrollPos]
	ld	b,a
	add	l
	ld	l,a
	jr	nc,.menuscrollnc4
	inc	h
.menuscrollnc4
	ld	a,[hl]
	and	a
	jr	nz,.doscroll4
	xor	a
	ld	[MenuItem4Offset],a
	ld	a,[MenuDoClear]
	and	a
	jr	z,.menuscroll5
	ld	a,$12
	ld	hl,MenuString_Null
	push	de
	call	PrintString
	pop	de
	jr	.menuscroll5
.doscroll4
	ld	[MenuItem4Offset],a
	ld	a,b
	inc	a
	ld	[MenuItem4ScrollPos],a
.menuscroll5
	ld	a,[MenuItem5Timer]
	dec	a
	cp	$ff
	jr	z,.menunoreset5
	ld	[MenuItem5Timer],a
	jr	.menuscrollhalt
.menunoreset5
	ld	h,d
	ld	l,e
	ld	a,[MenuItem5ScrollPos]
	ld	b,a
	add	l
	ld	l,a
	jr	nc,.menuscrollnc5
	inc	h
.menuscrollnc5
	ld	a,[hl]
	and	a
	jr	nz,.doscroll5
	xor	a
	ld	[MenuItem5Offset],a
	ld	a,[MenuDoClear]
	and	a
	jr	z,.menuscrolldone
	ld	a,$14
	ld	hl,MenuString_Null
	call	PrintString
	jr	.menuscrolldone
.doscroll5
	ld	[MenuItem5Offset],a
	ld	a,b
	inc	a
	ld	[MenuItem5ScrollPos],a
.menuscrollhalt
	push	de
	halt
	pop	de
	ld	a,[VBLFlag]
	and	a
	jr	z,.menuscrollhalt
	xor	a
	ld	[VBLFlag],a
	jp	.menuscroll1
.menuscrolldone
	xor	a
	ldh	[rSTAT],a
	ret
	
ShowMenuText:
	ld	de,$9980
	jr	.start
.loop
	pop	de
	pop	hl
.start
	call	CheckInput
	ld	a,[sys_btnHold]
	bit	btnA,a
	jr	z,.slow
	ld	a,1
	jr	.setSpeed
.slow
	ld	a,2
.setSpeed
	ld	[MenuTextTimer],a
	ld	a,[hl+]
	push	hl
	and	a
	jr	z,.newline
	cp	1
	jr	z,.newlineFixedTimer
	cp	$ff
	jr	z,.exit
	cp	"*"
	jr	nz,.noskip
	xor	a
	ld	[MenuTextTimer],a
	jr	.noconvert
.noskip
	sub	32
	call	ConvertChar
	and	a
	call	nz,.playTypeSound
.noconvert
	push	af
	RGBG_WaitForVRAM
	pop	af
	ld	[de],a
	inc	de
	push	de
.halt
	ld	a,[MenuTextTimer]
	dec	a
	ld	[MenuTextTimer],a
	cp	$ff
	jr	z,.loop
	halt
	jr	.halt
.newline
	ld	a,e
	add	12
	ld	e,a
	jr	nc,.nocarry
	inc	d
.nocarry
	push	de
.halt2
	ld	a,[MenuTextTimer]
	dec	a
	ld	[MenuTextTimer],a
	cp	$ff
	jr	z,.loop
	halt
	jr	.halt2
.newlineFixedTimer
	ld	a,2
	ld	[MenuTextTimer],a
	jr	.newline
.exit
	pop	hl
	ret
.playTypeSound
	push	af
	push	de
	ld	a,SFX_Type
	rst	$00
	pop	de
	pop	af
	ret
	
; ================================================================

InitGame:
	xor	a
	ldh	[rLCDC],a
	ldh	[rSCX],a
	ldh	[rSCY],a
	
	di
	
	call	ClearVRAM
	ld	a,1
	ldh	[rVBK],a
	call	ClearVRAM
	call	ClearAttribute
	xor	a
	ldh	[rVBK],a
	
	ld	a,Bank(SpriteTiles)
	ld	[rROMB0],a
	CopyTileset	SpriteTiles,0,66
	CopyTileset	Tileset,$1010,$3e
	
	; load BG pal
	ld	hl,TilesetPal
	call	LoadBGPal
	ld	hl,SpritePal
	call	LoadObjPal
	
	ld	hl,Tilemap_HUD
	call	LoadBGLine
	ld	a,1
	ldh	[rVBK],a
	ld	hl,AttrMap_HUD
	call	LoadBGLine
	xor	a
	ldh	[rVBK],a
	
	LoadSprite	Sprite_HUDOverlay,OAMBuffer2+HUDOverlayOAMPos,Sprite_HUDOverlay_End-Sprite_HUDOverlay
	LoadSprite	Sprite_PauseDisabled,OAMBuffer2,Sprite_PauseDisabled_End-Sprite_PauseDisabled
	
	Load8x1Sprite	0,0,0,HokeyOAMPos,0
	Load8x1Sprite	0,0,0,PokeyOAMPos,1+XFlip
	Load8x1Sprite	0,0,13,GoalOAMPos,0
	Load8x1Sprite	0,0,15,KeyOAMPos,5
	
	ld	a,[CurrentLevel]
	call	LoadLevel
	
	ei
	
	ld	a,IEF_VBLANK
	ldh	[rIE],a
	
	ld	a,%10000111
	ldh	[rLCDC],a
	
GameLoop:	
	call	CheckInput
	ld	a,[sys_btnPress]
	; actions
	bit	btnA,a
	jp	nz,.shoot
	bit	btnB,a
	jp	nz,.shoot
	bit	btnStart,a
	jp	nz,.pause
	; movement
	ld	a,[sys_btnHold]
	bit	btnDown,a
	jr	nz,.moveDown
	bit	btnLeft,a
	jp	nz,.moveLeft
	bit	btnRight,a
	jp	nz,.moveRight
	bit	btnUp,a
	jp	z,.done
.moveUp
	ld	a,[PlayerMoveTimer]
	and	a
	jp	nz,.done
	xor	a
	ld	[HokeyDir],a
	ld	[PokeyDir],a
	ld	a,8
	ld	[PlayerMoveTimer],a
	jp	.done
.moveDown
	ld	a,[PlayerMoveTimer]
	and	a
	jp	nz,.done
	ld	a,2
	ld	[HokeyDir],a
	ld	[PokeyDir],a
	ld	a,8
	ld	[PlayerMoveTimer],a
	jp	.done
.moveLeft
	ld	a,[PlayerMoveTimer]
	and	a
	jp	nz,.done
	ld	a,3
	ld	[HokeyDir],a
	ld	a,1
	ld	[PokeyDir],a
	ld	[PlayerFlip],a
	ld	a,8
	ld	[PlayerMoveTimer],a
	jp	.done
.moveRight
	ld	a,[PlayerMoveTimer]
	and	a
	jp	nz,.done
	ld	a,1
	ld	[HokeyDir],a
	ld a, 3
	ld	[PokeyDir],a
	xor	a
	ld	[PlayerFlip],a
	ld	a,8
	ld	[PlayerMoveTimer],a
	jp	.done
.shoot
	ld	a,SFX_Trill
	rst	$00
	jp	.done
.pause
	xor	a
	ld	[SoundEnabled],a
	xor	a
	ldh	[rNR52],a
	EnableSound
	ld	a,SFX_Pause
	rst	$00
	ld	a,Bank(Sprite_Pause)
	ld	[rROMB0],a
	LoadSprite	Sprite_Pause,OAMBuffer2,Sprite_Pause_End-Sprite_Pause
	ld	a,1
	ld	[rROMB0],a
.pauseloop
	halt
	call	$ff90
	call	CheckInput
	
	ld	a,[sys_btnPress]
	if	!DebugFlag
		ld	a,[CheatModeOn]
		and	a
		jr	z,.nocheat
		ld	a,[sys_btnPress]
	endc
	bit	btnSelect,a
	jr	nz,.nextLevel
.nocheat
	ld	a,[sys_btnPress]
	bit	btnStart,a	
	jr	z,.pauseloop

	ld	a,1
	ld	[SoundEnabled],a
	ld	a,Bank(Sprite_Pause)
	ld	[rROMB0],a
	LoadSprite	Sprite_PauseDisabled,OAMBuffer2,Sprite_PauseDisabled_End-Sprite_PauseDisabled
	ld	a,1
	ld	[rROMB0],a
	jr	.done
	
.nextLevel
	ld	a,[CurrentLevel]
	inc	a
	ld	[CurrentLevel],a
	xor	a
	ld	[TouchingGoal],a
	call	DS_Fade
	ld	a,1
	ld	[RGBG_fade_to_color],a
	call	RGBG_SimpleFadeOut
	jp	InitGame
	
.done
	ld	a,[PlayerMoveTimer]
	and	a
	jr	z,.nomove
	dec	a
	ld	[PlayerMoveTimer],a
	call	MovePlayerSprites
.nomove
	call	UpdatePlayerSprites
	call	UpdateEnemySprites
	call	UpdateCollectableSprites
	
	; check if player is touching a key
	ld	a,[HaveKey]
	and	a
	jr	nz,.nokey
	ld	a,[KeyY]
	ld	b,a
	ld	a,[HokeyY]
	cp	b
	call	z,.checkhokeyx
	ld	a,[KeyY]
	ld	b,a
	ld	a,[PokeyY]
	cp	b
	call	z,.checkpokeyx
	jr	.nokey
.checkhokeyx
	ld	a,[KeyX]
	ld	b,a
	ld	a,[HokeyX]
	add	8
	cp	b
	ret	nz
	jr	.getKey
.checkpokeyx
	ld	a,[KeyX]
	ld	b,a
	ld	a,[PokeyX]
	add	8
	cp	b
	ret	nz
.getKey
	ld	a,1
	ld	[HaveKey],a
	ld	a,SFX_Collect
	rst	$00
	xor	a
	ld	[KeyX],a
	ld	[KeyY],a
	ret
.nokey
	
	; check if Hokey and Pokey are touching the goal

	ld	a,[HokeyY]
	ld	b,a
	ld	a,[PokeyY]
	cp	b
	jr	nz,.nogoal
	ld	a,[GoalY]
	cp	b
	jr	nz,.nogoal
	
	ld	a,[HokeyX]
	ld	b,a
	ld	a,[PokeyX]
	cp	b
	jr	nz,.nogoal
	ld	a,[GoalX]
	sub	8
	cp	b
	jr	nz,.nogoal
	
	; if both Hokey and Pokey are touching the goal...
	ld	a,[NeedKey]
	and	a
	jp	z,.nextLevel	; if a key is not required, go to next level
	ld	a,[HaveKey]
	and	a
	jr	nz,.levelClear	; if player has a key, go to next level
	
	ld	a,[TouchingGoal]
	and	a
	jr	nz,.nogoal
	ld	a,1
	ld	[TouchingGoal],a
	ld	a,SFX_Trill
	rst	$00
	jr	.nogoal
	
.levelClear
	; score tally goes here
	jp	.nextLevel
	
.nogoal
	xor	a
	ld	[TouchingGoal],a
	halt
	call	$ff90
	jp	GameLoop
	
UpdatePlayerSprites:
	ld	hl,OAMBuffer2+HokeyOAMPos
	ld	a,[HokeyY]
	ld	[hl+],a
	ld	a,[HokeyX]
	add	8
	ld	[hl+],a
	inc	hl
	ld	a,[PlayerFlip]
	swap	a
	rla
	ld	[hl+],a
	
	ld	hl,OAMBuffer2+PokeyOAMPos
	ld	a,[PokeyY]
	ld	[hl+],a
	ld	a,[PokeyX]
	add	8
	ld	[hl+],a
	inc	hl
	ld	a,[PlayerFlip]
	xor	1
	swap	a
	rla
	inc	a
	ld	[hl+],a
	ret
	
UpdateEnemySprites:
	ret
	
UpdateCollectableSprites:
	ld	hl,OAMBuffer2+KeyOAMPos
	ld	a,[KeyY]
	ld	[hl+],a
	ld	a,[KeyX]
	ld	[hl+],a
	ld	hl,OAMBuffer2+GoalOAMPos
	ld	a,[GoalY]
	ld	[hl+],a
	ld	a,[GoalX]
	ld	[hl+],a
	; insert rest of update routine here
	ret
	
FruitSprTable:
	db	28,32,34,36,38
FruitPalTable:
	db	2,5,2,2,3
	
EnemySprTable:
	db	2,6,10,14,18,22
EnemyPalTable:
	db	2,3,4,0,0,1
	
Pal_Grayscale:
	dw	$7fff,$6e94,$354a,$0000
	
MovePlayerSprites:
	ld	a,[HokeyDir]
	and	a
	call	z,.hokeyUp
	dec	a
	call	z,.hokeyRight
	dec	a
	call	z,.hokeyDown
	dec	a
	call	z,.hokeyLeft
	ld	a,[PokeyDir]
	and	a
	call	z,.pokeyUp
	dec	a
	call	z,.pokeyLeft
	dec	a
	call	z,.pokeyDown
	dec	a
	call	z,.pokeyRight
	ret
	
.hokeyUp
	push	af
	ld	a,[HokeyX]
	ld	b,a
	ld	a,[HokeyY]
	dec	a
	ld	c,a
	push bc
	call	CheckCollisionBG
	pop bc
	jr	nz,.noUpH
	ld	a,b
	add HitboxWidth
	ld	b,a
	call	CheckCollisionBG
	jr	nz,.noUpH
	ld	a,[HokeyY]
	dec	a
	ld	[HokeyY],a
.noUpH
	pop	af
	ret
.pokeyUp
	push	af
	ld	a,[PokeyX]
	ld	b,a
	ld	a,[PokeyY]
	dec	a
	ld	c,a
	push bc
	call	CheckCollisionBG
	pop bc
	jr	nz,.noUpP
	ld	a,b
	add HitboxWidth
	ld	b,a
	call	CheckCollisionBG
	jr	nz,.noUpP
	ld	a,[PokeyY]
	dec	a
	ld	[PokeyY],a
.noUpP
	pop	af
	ret

.hokeyDown	
	push	af
	ld	a,[HokeyX]
	ld	b,a
	ld	a,[HokeyY]
	add	HitboxHeight + 1
	ld	c,a
	push bc
	call	CheckCollisionBG
	pop bc
	jr	nz,.noDownH
	ld	a,b
	add HitboxWidth
	ld	b,a
	call	CheckCollisionBG
	jr	nz,.noDownH
	ld	a,[HokeyY]
	inc	a
	ld	[HokeyY],a
.noDownH
	pop	af
	ret
.pokeyDown
	push	af
	ld	a,[PokeyX]
	ld	b,a
	ld	a,[PokeyY]
	add	HitboxHeight + 1
	ld	c,a
	push bc
	call	CheckCollisionBG
	pop bc
	jr	nz,.noDownP
	ld	a,b
	add HitboxWidth
	ld	b,a
	call	CheckCollisionBG
	jp	nz,.noDownP
	ld	a,[PokeyY]
	inc	a
	ld	[PokeyY],a
.noDownP
	pop	af
	ret

.hokeyLeft
	push	af
	ld	a,[HokeyX]
	dec	a
	ld	b,a
	ld	a,[HokeyY]
	ld	c,a
	push bc
	call	CheckCollisionBG
	pop bc
	jr	nz,.noLeftH
	ld	a,c
	add HitboxHeight
	ld	c,a
	call	CheckCollisionBG
	jr	nz,.noLeftH
	ld	a,[HokeyX]
	dec	a
	ld	[HokeyX],a
.noLeftH
	pop	af
	ret
.pokeyLeft
	push	af
	ld	a,[PokeyX]
	add	HitboxWidth + 1
	ld	b,a
	ld	a,[PokeyY]
	ld	c,a
	push bc
	call	CheckCollisionBG
	pop bc
	jr	nz,.noLeftP
	ld	a,c
	add HitboxHeight
	ld	c,a
	call	CheckCollisionBG
	jr	nz,.noLeftP
	ld	a,[PokeyX]
	inc	a
	ld	[PokeyX],a
.noLeftP
	pop	af
	ret
	
.hokeyRight
	push	af
	ld	a,[HokeyX]
	add	HitboxWidth + 1
	ld	b,a
	ld	a,[HokeyY]
	ld	c,a
	push bc
	call	CheckCollisionBG
	pop bc
	jr	nz,.noRightH
	ld	a,c
	add HitboxHeight
	ld	c,a
	call	CheckCollisionBG
	jr	nz,.noRightH
	ld	a,[HokeyX]
	inc	a
	ld	[HokeyX],a
.noRightH
	pop	af
	ret
.pokeyRight
	push	af
	ld	a,[PokeyX]
	dec	a
	ld	b,a
	ld	a,[PokeyY]
	ld	c,a
	push bc
	call	CheckCollisionBG
	pop bc
	jr	nz,.noRightP
	ld	a,c
	add HitboxHeight
	ld	c,a
	call	CheckCollisionBG
	jr	nz,.noRightP
	ld	a,[PokeyX]
	dec	a
	ld	[PokeyX],a
.noRightP
	pop	af
	ret
	
; ================================================================

ShowSoundTest:
	xor	a
	ldh	[rLCDC],a
	ldh	[rSCX],a
	ldh	[rSCY],a
	ld	a,Bank(DevSound)
	ld	[rROMB0],a
	call	DS_Stop
	EnableSound
	ld	a,Bank(GFXBank1)
	CopyTileset1BPP	DebugFont,0,97
	ld	a,[GBType]
	cp	1
	jr	nz,.gbc
	ld	a,%11100100
	ldh	[rBGP],a
	ld	hl,SoundTestMap
	call	LoadScreenText
	ld	a,16
	ld	hl,MenuString_Null
	call	PrintString
	jr	.continue
.gbc
	ld	hl,Pal_Grayscale
	xor	a
	call	LoadBGPalLine
	ld	hl,SoundTestMap
	call	LoadScreenText
	call	ClearAttribute
.continue
	ld	a,Bank(DevSound)
	ld	[rROMB0],a
	ld	a,%10010001
	ldh	[rLCDC],a
	halt
	
.loop
	di
	RGBG_WaitForVRAM
	ld	a,[STMusID]
	ld	hl,ST_MusIDPos
	call	DrawHex
	RGBG_WaitForVRAM
	ld	a,[STSFXID]
	ld	hl,ST_SFXIDPos
	call	DrawHex
	ld	a,[MenuPos]
	and	a
	jr	nz,.item1
.item0
	RGBG_WaitForVRAM
	ld	a,">"-$20
	ld	[$9860],a
	xor	a
	ld	[$9880],a
	jr	.continue2
.item1
	RGBG_WaitForVRAM
	xor	a
	ld	[$9860],a
	or	">"-$20
	ld	[$9880],a
.continue2
	ld	a,Bank(DevSound)
	ld	[rROMB0],a
	call	CheckInput
	ld	a,[sys_btnPress]
	bit	btnStart,a
	jp	nz,.exit
	bit	btnUp,a
	jr	nz,.toggleMenuPos
	bit	btnDown,a
	jr	nz,.toggleMenuPos
	bit	btnLeft,a
	jr	nz,.prevItem
	bit	btnRight,a
	jr	nz,.nextItem
	bit	btnA,a
	jr	nz,.playSong
	push	af
	bit	btnB,a
	call	nz,DS_Stop
	pop	af
	
.done
	ei
	halt
	jr	.loop
.exit
	ld	a,[GBType]
	cp	1
	jr	z,.done
	ld	hl,MusicOff
	ld	a,[TempMusicOff]
	ld	[hl+],a
	ld	a,[TempSFXOff]
	ld	[hl+],a
	xor	a
	ldh	[rLCDC],a
	jp	ShowTitleScreen
.toggleMenuPos
	ld	a,[MenuPos]
	xor	1	; toggle
	ld	[MenuPos],a
	jr	.done
.nextItem
	ld	a,[MenuPos]
	and	a
	jr	z,.nextItem_mus
	ld	a,[STSFXID]
	inc	a
	ld	[STSFXID],a
	jr	.done
.nextItem_mus
	ld	a,[STMusID]
	inc	a
	ld	[STMusID],a
	jr	.done
.prevItem
	ld	a,[MenuPos]
	and	a
	jr	z,.prevItem_mus
	ld	a,[STSFXID]
	dec	a
	ld		[STSFXID],a
	jr	.done
.prevItem_mus
	ld	a,[STMusID]
	dec	a
	ld	[STMusID],a
	jr	.done
.playSong
	ld	a,[MenuPos]
	and	a
	jr	nz,.playSFX
	ld	a,[STMusID]
	call	DS_Init
	jr	.done
.playSFX
	EnableSound
	ld	a,[STSFXID]
	rst	$00
	jr	.done
	
SoundTestMap:
;		 --------------------
	db	"                    "
	db	"   - SOUND TEST -   "
	db	"                    "
	db	"  Music:       $??  "
	db	"  SFX:         $??  "
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
	db	"Press Start to exit."
	db	"                    "
	
; ================================================================
; Misc routines
; ================================================================

; Input: HL = null-terminated string to print, B = line no.
PrintString:
	push	hl
	ld	de,$9800
	ld	hl,$9800
	ld	b,a
.loop1
	ld	a,$20
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	dec	b
	jr	nz,.loop1
	ld	d,h
	ld	e,l
	pop	hl
.loop2
	ld	a,[hl+]
	and	a
	ret	z
	sub	32
	push	af
	RGBG_WaitForVRAM
	pop	af
	ld	[de],a
	inc	de
	jr	.loop2
	ret

; Input: HL = null-terminated string to print, B = line no.
PrintStringMenu:
	push	hl
	ld	de,$9800
	ld	hl,$9800
	ld	b,a
.loop1
	ld	a,$20
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	dec	b
	jr	nz,.loop1
	ld	d,h
	ld	e,l
	pop	hl
.loop2
	ld	a,[hl+]
	and	a
	ret	z
	sub	32
	call	ConvertChar
	push	af
	RGBG_WaitForVRAM
	pop	af
	ld	[de],a
	inc	de
	jr	.loop2
	ret


; Input: a = char
ConvertChar:
	bit	7,a
	ret	nz
	push	hl
	ld	hl,MenuCharConvTable
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl]
	pop	hl
	ret
	
MenuCharConvTable:
;			!  "  #  $  %  &  '  (  )  *  +  ,  -  .  /
	db	00,37,43,00,00,00,00,00,00,00,00,45,40,42,39,00
;		 0  1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ?
	db	27,28,29,30,31,32,33,34,35,36,41,00,00,00,00,38
;		 @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O
	db	00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15
;		 P  Q  R  S  T  U  V  W  X  Y  Z  [  \  ]  ^  _
	db	16,17,18,19,20,21,22,23,24,25,26,00,00,00,00,00
;		 `  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o
	db	00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15
;		 p  q  r  s  t  u  v  w  x  y  z  {  |  }  ~
	db	16,17,18,19,20,21,22,23,24,25,26,00,00,00,00,00
	
; Check for a collision on the BG layer at a given position
; INPUT:  b = x pos, c = y pos
; OUTPUT: zero flag is set if no collision found
CheckCollisionBG:
	ld	a,b
	and	$f8
	rrca
	rrca
	rrca
	and	$1f
	ld	b,a
	ld	a,c
	sub	8
	and	$f8
	rrca
	rrca
	rrca
	and	$1f
	ld	c,a
	call	GetTileAtPos
	ld	hl,TileColTable
	add	l
	ld	l,a
	jr	nc,.nocarry2
	inc	h
.nocarry2
	ld	a,[hl+]
	and	a
	ret

TileColTable:
	db	1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0
	db	0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0
	db	0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1
	db	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

; Get the ID of a tile at a given position
; INPUT: b = x pos, c = y pos
; OUTPUT: a = tile ID
GetTileAtPos:
	call	CoordsToBGMapAddress
.getTile
	RGBG_WaitForVRAM	; wait for VRAM accessibility before reading tile ID otherwise we get $FF
	ld	a,[hl]
	ret

; INPUT: b = x pos, c = y pos
; OUTPUT: hl = BG map address
CoordsToBGMapAddress:
	ld	hl,_SCRN0
	ld	a,b
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,c
	add	a
	ld	c,a
	ld	b,0
	ld	d,16
.loop
	add	hl,bc
	dec	d
	jr	nz,.loop
	ret

; Place a tile on the screen at a given position
; Input: a = tile number, b = x pos, c = y pos, d = tile attributes
PlaceTileAtPosition:
	push	af
	call	CoordsToBGMapAddress
	RGBG_WaitForVRAM
	pop	af
	ld	[hl],a		; copy tile
	ld	a,1
	ldh	[rVBK],a
	RGBG_WaitForVRAM
	ld	a,d
	ld	[hl],a
	xor	a
	ldh	[rVBK],a
	ret
	
Title_DrawHex:
	push	af
	swap	a
	and	$f
	add	$f0
	ld	[hl+],a
	pop	af
	and	$f
	add	$f0
	ld	[hl],a
	ret
	
CopyTiles:
	ld	a,[hl+]
	ld	[de],a
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,CopyTiles
	ret

CopyTiles1BPP:
	ld	a,[hl+]			; get byte
	ld	[de],a			; write byte
	inc	de				; increment destination address
	ld	[de],a			; write tile byte
	inc	de				; increment destination address again
	dec	bc
	dec	bc				; since we're copying two bytes, we need to dec bc twice
	ld	a,b
	or	c
	jr	nz,CopyTiles1BPP
	ret

LoadScreen:
	ld	de,_SCRN0
	ld	bc,$1214
.loop
	ld	a,[hl+]	
	ld	[de],a
	inc	de
	dec	c
	jr	nz,.loop
	ld	c,$14
	ld	a,e
	add	$C
	jr	nc,.continue
	inc	d
.continue
	ld	e,a
	dec	b
	jr	nz,.loop
	ret
	
LoadScreen2:
	ld	de,_SCRN0
	ld	bc,$1214
.loop
	ld	a,[hl+]
	add	$81
	ld	[de],a
	inc	de
	dec	c
	jr	nz,.loop
	ld	c,$14
	ld	a,e
	add	$C
	jr	nc,.continue
	inc	d
.continue
	ld	e,a
	dec	b
	jr	nz,.loop
	ret
	
LoadBGLine:
	ld	de,_SCRN0
	ld	c,$14
.loop
	ld	a,[hl+]	
	ld	[de],a
	inc	de
	dec	c
	jr	nz,.loop
	ret
	
LoadLevel:
	push	af
	ld	a,Bank(LevelData)
	ld	[rROMB0],a
	ld	a,[CurrentLevel]
	cp	20
	jr	c,.getlevel
	pop	af
	ld	hl,DummyLevel
	jr	.load
.getlevel
	ld	hl,LevelTable
	pop	af
	add	a
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
.load
	ByteToRAM	HokeyX
	ByteToRAM	PokeyX
	ByteToRAM	HokeyY
	ld	[PokeyY],a
	ByteToRAM	NeedKey
	ByteToRAM	FruitCount
	ByteToRAM	EnemyCount
	ByteToRAM	GoalX
	ByteToRAM	GoalY
	ByteToRAM	KeyX
	ByteToRAM	KeyY
	ByteToRAM	Fruit1X
	ByteToRAM	Fruit1Y
	ByteToRAM	Fruit2X
	ByteToRAM	Fruit2Y
	ByteToRAM	Fruit3X
	ByteToRAM	Fruit3Y
	ByteToRAM	Fruit4X
	ByteToRAM	Fruit4Y
	ByteToRAM	Fruit5X
	ByteToRAM	Fruit5Y
	ByteToRAM	Fruit6X
	ByteToRAM	Fruit6Y
	ByteToRAM	Fruit7X
	ByteToRAM	Fruit7Y
	ByteToRAM	Fruit8X
	ByteToRAM	Fruit8Y
	ByteToRAM	Enemy1X
	ByteToRAM	Enemy1Y
	ByteToRAM	Enemy2X
	ByteToRAM	Enemy2Y
	ByteToRAM	Enemy3X
	ByteToRAM	Enemy3Y
	ByteToRAM	Enemy4X
	ByteToRAM	Enemy4Y
	ByteToRAM	Enemy5X
	ByteToRAM	Enemy5Y
	ByteToRAM	Enemy6X
	ByteToRAM	Enemy6Y
	ByteToRAM	Enemy7X
	ByteToRAM	Enemy7Y
	ByteToRAM	Enemy8X
	ByteToRAM	Enemy8Y
	ld	a,[hl+]
	push	af
	
	xor	a
	ld	[HaveKey],a
	inc	a
	ld	[HokeyDir],a
	add	2
	ld	[PokeyDir],a
	call	.map2vram
	ld	a,1
	ldh	[rVBK],a
	call	.map2vram
	xor	a
	ldh	[rVBK],a
	ld	a,Bank(DevSound)
	ld	[rROMB0],a
	pop	af
	call	DS_Init
	ret
	
.map2vram
	ld	bc,$1114
	ld	de,_SCRN0+$20
.loop
	ld	a,[hl+]
	ld	[de],a
	inc	de
	dec	c
	jr	nz,.loop
	ld	c,$14
	ld	a,e
	add	$C
	jr	nc,.continue
	inc	d
.continue
	ld	e,a
	dec	b
	jr	nz,.loop
	ret
	
LoadScreenText:
	ld	de,_SCRN0
	ld	bc,$1214
.loop
	ld	a,[hl+]
	sub 32	
	ld	[de],a
	inc	de
	dec	c
	jr	nz,.loop
	ld	c,$14
	ld	a,e
	add	$C
	jr	nc,.continue
	inc	d
.continue
	ld	e,a
	dec	b
	jr	nz,.loop
	ret
	
ClearAttribute:
	ld	a,1
	ldh	[rVBK],a
	call	ClearScreen
	xor	a
	ldh	[rVBK],a
	ret

; Input: hl = palette data	
LoadBGPal:
	ld	a,0
	call	LoadBGPalLine
	ld	a,1
	call	LoadBGPalLine
	ld	a,2
	call	LoadBGPalLine
	ld	a,3
	call	LoadBGPalLine
	ld	a,4
	call	LoadBGPalLine
	ld	a,5
	call	LoadBGPalLine
	ld	a,6
	call	LoadBGPalLine
	ld	a,7
	call	LoadBGPalLine
	ret
	
; Input: hl = palette data	
LoadObjPal:
	ld	a,0
	call	LoadObjPalLine
	ld	a,1
	call	LoadObjPalLine
	ld	a,2
	call	LoadObjPalLine
	ld	a,3
	call	LoadObjPalLine
	ld	a,4
	call	LoadObjPalLine
	ld	a,5
	call	LoadObjPalLine
	ld	a,6
	call	LoadObjPalLine
	ld	a,7
	call	LoadObjPalLine
	ret
	
; Input: hl = palette data
LoadBGPalLine:
	swap	a	; \  multiply
	rrca		; /  palette by 8
	or	$80		; auto increment
	push	af
	RGBG_WaitForVRAM
	pop	af
	ld	[rBCPS],a
	ld	a,[hl+]
	ld	[rBCPD],a
	ld	a,[hl+]
	ld	[rBCPD],a
	ld	a,[hl+]
	ld	[rBCPD],a
	ld	a,[hl+]
	ld	[rBCPD],a
	ld	a,[hl+]
	ld	[rBCPD],a
	ld	a,[hl+]
	ld	[rBCPD],a
	ld	a,[hl+]
	ld	[rBCPD],a
	ld	a,[hl+]
	ld	[rBCPD],a
	ret
	
; Input: hl = palette data
LoadObjPalLine:
	swap	a	; \  multiply
	rrca		; /  palette by 8
	or	$80		; auto increment
	push	af
	RGBG_WaitForVRAM
	pop	af
	ld	[rOCPS],a
	ld	a,[hl+]
	ld	[rOCPD],a
	ld	a,[hl+]
	ld	[rOCPD],a
	ld	a,[hl+]
	ld	[rOCPD],a
	ld	a,[hl+]
	ld	[rOCPD],a
	ld	a,[hl+]
	ld	[rOCPD],a
	ld	a,[hl+]
	ld	[rOCPD],a
	ld	a,[hl+]
	ld	[rOCPD],a
	ld	a,[hl+]
	ld	[rOCPD],a
	ret
	
MetaspriteToOAM:
	ld	a,[hl+]
	ld	[de],a
	inc	de
	dec	b
	jr	nz,MetaspriteToOAM
	ret
	
include		"FadeRoutines.asm"

UpdateSound:
	push	af
	ld	a,Bank(DevSound)
	ld	[rROMB0],a
	ld	a,[MusicOff]
	and	a
	jr	nz,.nomusic
	call	DS_Play
.nomusic
	ld	a,Bank(SFXData)
	ld	[rROMB0],a
	ld	a,[SFXOff]
	and	a
	jr	nz,.nosfx
	call	$4006
	ld	a,Bank(DevSound)
	ld	[rROMB0],a
.nosfx
	pop	af
	reti

OAM_DMA:
	ld	a,$c1
	ldh	[rDMA],a
	ld	a,$28
.wait
	dec	a
	jr	nz,.wait
	ret
OAM_DMA_End

CopyDMARoutine:
	ld	hl,OAM_DMA
	push	hl
	ld	de,$ff80
	ld	b,OAM_DMA_End-OAM_DMA
	ld	c,$91
.loop
	ld	a,[hl+]
	ld	[de],a
	inc	de
	dec	b
	jr	nz,.loop
	pop	hl
	ld	de,$ff90
	ld	b,OAM_DMA_End-OAM_DMA
.loop2
	ld	a,[hl+]
	ld	[de],a
	inc	de
	dec	b
	jr	nz,.loop2
	ld	a,$c2
	ld	[c],a
	ret	

ClearOAM:
	xor	a
	ld	hl,OAMBuffer
	ld	b,$9f
.clearloop
	ld	[hl+],a
	dec	b
	jr	nz,.clearloop
	jp	$ff80			; do OAM DMA then exit
	
RandomNumber:
	push	hl
	ld	a,[RandPtr]
	inc	a
	ld	[RandPtr],a
	ld	hl,RandTable
	add	a,l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl]
	pop	hl
	ret
	
RandTable:
	db      $3b,$02,$b7,$6b,$08,$74,$1a,$5d,$21,$99,$95,$66,$d5,$59,$05,$42
	db      $f8,$03,$0f,$53,$7d,$8f,$57,$fb,$48,$26,$f2,$4a,$3d,$e4,$1d,$d9
	db      $9d,$dc,$2f,$f5,$92,$5c,$cc,$00,$73,$15,$bf,$b1,$bb,$eb,$9e,$2e
	db      $32,$fc,$4b,$cd,$a7,$e6,$c2,$10,$11,$80,$52,$b2,$da,$77,$4f,$ec
	db      $13,$54,$64,$ed,$94,$8c,$c6,$9a,$19,$9f,$75,$fa,$aa,$8d,$fe,$91
	db      $01,$23,$07,$c1,$40,$18,$51,$76,$3c,$bd,$2a,$88,$2d,$f1,$8a,$72
	db      $f6,$98,$35,$97,$68,$93,$b3,$0c,$82,$4e,$cb,$39,$d8,$5f,$c7,$d4
	db      $ce,$ae,$6d,$a3,$7c,$6a,$b8,$a6,$6f,$5e,$e5,$1b,$f4,$b5,$3a,$14
	db      $78,$fd,$d0,$7a,$47,$2c,$a8,$1e,$ea,$2b,$9c,$86,$83,$e1,$7b,$71
	db      $f0,$ff,$d1,$c3,$db,$0e,$46,$1c,$c9,$16,$61,$55,$ad,$36,$81,$f3
	db      $df,$43,$c5,$b4,$af,$79,$7f,$ac,$f9,$37,$e7,$0a,$22,$d3,$a0,$5a
	db      $06,$17,$ef,$67,$60,$87,$20,$56,$45,$d7,$6e,$58,$a9,$b0,$62,$ba
	db      $e3,$0d,$25,$09,$de,$44,$49,$69,$9b,$65,$b9,$e0,$41,$a4,$6c,$cf
	db      $a1,$31,$d6,$29,$a2,$3f,$e2,$96,$34,$ee,$dd,$c0,$ca,$63,$33,$5b
	db      $70,$27,$f7,$1f,$be,$12,$b6,$50,$bc,$4d,$28,$c8,$84,$30,$a5,$4c
	db      $ab,$e9,$8e,$e8,$7e,$c4,$89,$8b,$0b,$24,$85,$3e,$38,$04,$d2,$90
	
; ================================================================
; Check if a cheat code is being entered
; ================================================================

CheckCheat:
	ld	a,[CheatModeOn]
	and	a
	ret	nz
	ld	hl,CheatModeCode
	ld	a,[CheatOffset]
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[sys_btnPress]
	ld	b,a
	ld	a,[hl+]
	cp	b
	jr	nz,.nocheat
	ld	a,[CheatOffset]
	inc	a
	ld	[CheatOffset],a
	ld	a,[hl]
	cp	$ed				; check for terminating entry ($ED)
	jr	z,.enableCheat	; if terminating entry found, enable effects of cheat
	ret
.enableCheat
	xor	a
	ld	[CheatOffset],a
	inc	a
	ld	[CheatModeOn],a
	; insert all effects of cheat code here
	ret
.nocheat
	xor	a
	ld	[CheatOffset],a
	ret
	
CheatModeCode:	db	_Up,_Up,_Down,_Down,_Left,_Right,_Left,_Right,$ed
	
; ================================================================
; Error handler
; ================================================================

section	"Error handler",ROM0
include	"ErrorHandler.asm"

; ================================================================
; SRAM routines
; ================================================================

if	UseSRAM
include	"SRAM.asm"
endc

; ================================================================
; High color routines
; ================================================================

VBlank_HiColor:
	push	af
	ld	a,[DoHiColor]
	and	a
	jp	z,.done
	ld	a,[HiColorOffset]
	res	0,a
	ldh	[rSCY],a
	xor	a
	ldh	[rSCX],a
	ld	a,Bank(Pal_HCMenu)
	ld	[rROMB0],a
	push	af
	ld	[tempSP],sp
	
	ld	a,1
	ldh	[rVBK],a
	ld	hl,Pal_HCMenu
	
	ld	a,[HiColorOffset]
	and	a
	jr	z,.noadd
	res	0,a
	ldh	[rSCY],a
	ld	bc,$0010
.addloop
	add	hl,bc
	add	hl,bc
	dec	a
	jr	nz,.addloop
.noadd
	
	ld	sp,hl
	ld	a,$80
	ld	hl,rBCPS
	ld	[hl],a
	ld	hl,rLY
	xor	a
.wait
	cp	[hl]
	jr	nz,.wait
.palloop
	pop	de
	ld	l,rSTAT & 255
.waitstat
	bit	1,[hl]
	jr	nz,.waitstat
	ld	l,rBCPD & 255
	ld	[hl],e
	ld	[hl],d
	rept	15
		pop	de
		ld	[hl],e
		ld	[hl],d
	endr
	ldh	a,[rLY]
	cp	40
	jr	nz,.palloop
	ld	[rSCY],a
	ld	hl,tempSP
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	sp,hl
	xor	a
	ld	hl,Pal_Menu
	call	LoadBGPalLine
	pop	af
	ld	[rROMB0],a
.done
	xor	a
	ldh	[rVBK],a
	ld	a,1
	ld	[VBLFlag],a
	ld	a,5
	ld	[StatCounter],a
	pop	af
	ret
	
DoStat:
	push	af
	ld	a,[StatType]
	and	a
	jr	nz,.statMenu
	pop	af
	reti

.statMenu
	push	bc
	push	hl
	ld	a,[StatCounter]
	dec	a
	cp	$ff
	jr	z,.done
	ld	[StatCounter],a
	ld	b,a	
	ld	hl,MenuItem5Offset
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	ld	a,[hl]
	rr	b
	jr	nc,.notodd
	cpl
	inc	a
.notodd
	ldh	[rSCX],a
	ldh	a,[rLYC]
	add	16
	ldh	[rLYC],a
	jr	.reti
.done
	ld	a,MenuItem1Scanline
	ldh	[rLYC],a
.reti
	pop	hl
	pop	bc
	pop	af
	reti

; ================================================================

HexFont:	incbin	"GFX/HexFont.bin"
	
; ================================================================
; Sound driver
; ================================================================

section	"Sound driver bank 1",romx,bank[1]
include "DevSound.asm"

; ================================================================
; SFX data
; ================================================================

section	"SFX data bank",romx,bank[2]
SFXData:		incbin	"Data/SFX.bin"
	
; ================================================================
; Graphics data
; ================================================================

include	"GFXBank1.asm"
include	"GFXBank2.asm"
include	"GFXBank3.asm"

include	"LevelData.asm"