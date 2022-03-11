; ================================================================
; SRAM routines
; ================================================================
 
CalculateChecksum:	; WARNING: This assumes SRAM is already enabled!
	ld	hl,$a001
	ld	de,$1fff
	xor a
	ld	b,a			; both a and b need to be zero
.loop
	ld	a,[hl+]
	add b
	ld	b,a
	dec de
	ld	a,d
	or	e
	jr	nz,.loop
	ret

VerifyChecksum:
	di
	ld	a,10
	ld	[$0000],a	 			; enable SRAM
	ld	a,[SRAMChecksum]		; get stored checksum
	push	af
	call	CalculateChecksum
	pop	af
	cp	b						; compare with calculated checksum
	jr	z,.pass					; if checksums match, go to .pass
	reti
.pass
	xor a
	ld	[$0000],a				; disable SRAM
	reti
	
; Verify whether SRAM is working properly
CheckSRAM:
	di
	ld	a,10
	ld	[$0000],a				; enable SRAM
.readcheck						; verify that SRAM can be read from
	ld	hl,$bfff
	ld	a,[hl]					; read value from $bfff
	cp	$ff
	jr	nz,.writecheck			; if value != $ff, test passes
	; pass 2
	ld	hl,$bff0
	ld	a,[hl]					; read value from $bff0
	cp	$ff
	jr	nz,.writecheck2			; if value != $ff, test passes
.writecheck						; verify that SRAM can be written to
	ld	a,$ed					; (code will work no matter what this value is)
	ld	b,a						; store control value for comparison
	ld	[hl],a					; write value to SRAM
	ld	a,[hl]					; read value back
	cp	b						; check if values match
	jr	nz,.fail				; if they don't, jump
.pass							; all checks passed - SRAM is healthy
	xor	a
	ld	[hl],a
	; We're not done yet! We still need to do a checksum to make sure the actual save data is good.
	call	VerifyChecksum		; verify SRAM checksum
	jr	nz,.fail2				; if checksum fails, jump ahead
	reti						; otherwise, we are done!
.writecheck2
	ld	a,$ed					; (code will work no matter what this value is)
	ld	b,a						; store control value for comparison
	ld	[hl],a					; write value to SRAM
	ld	a,[hl]					; read value back from SRAM
	cp	b						; check if values match
	jr	z,.pass					; if they do, SRAM is healthy - go to next part
.fail							; case 1: SRAM either could not be read from or could not be written to
	xor	a
	ld	[$0000],a				; disable SRAM
	ld	a,1						; error type 1: sram init failed
	jp	ShowSaveErrorScreen
.fail2							; case 2: SRAM is healthy but checksum failed
	call	ClearSRAM
	xor	a						; error type 1: save data corrupt
	jp	ShowSaveErrorScreen
	
; Input: HL = address of data to write, B = length of data
DataToSRAM:
	di
	ld	a,10
	ld	[$0000],a				; enable SRAM
.loop
	ld	a,[hl+]					; read byte
	ld	[de],a					; store in SRAM
	inc de
	dec b
	jr	nz,.loop				; loop until done
	call	CalculateChecksum
	ld	a,b
	ld	[SRAMChecksum],a		; store checksum
	xor a
	ld	[$0000],a				; disable SRAM
	reti
 
; Input: HL = address of data to copy, DE = destination, B = length of data
SRAMToRAM:
	di
	ld	a,10
	ld	[$0000],a				; enable SRAM
.loop
	ld	a,[hl+]					; read byte from SRAM
	ld	[de],a					; store
	inc de
	dec b
	jr	nz,.loop				; loop until done
	xor a
	ld	[$0000],a				; disable SRAM 
	reti
 
ClearSRAM:
	di
	ld	a,10
	ld	[$0000],a				; enable SRAM
	ld	hl,$a000				; SRAM start
	ld	bc,$2000				; SRAM end minus $A000
.loop
	xor a
	ld	[hl+],a
	dec bc
	ld	a,b
	or	c
	jr	nz,.loop				; loop until done
	xor a
	ld	[$0000],a				; disable SRAM
	reti
	
; ================================================================

ShowSaveErrorScreen:
	ld	b,a						; store error type for safekeeping
	push	af
	push	bc
	
	; Load error screen graphics
	ld	a,Bank(HCMenuTiles)
	ld	[rROMB0],a
	CopyTileset	HCMenuTiles,$800,$64
	CopyTileset	MenuFont,$1000,46
	ld	hl,HCMenuMap
	call	LoadScreen
	ld	a,1
	ldh	[rVBK],a
	ld	hl,AttrMap_HCMenu
	call	LoadScreen
	; Setup display parameters
	xor	a
	ldh	[rVBK],a
	ld	a,IEF_VBLANK
	ldh	[rIE],a
	ld	a,%10000001
	ldh	[rLCDC],a
	
	ld	a,1
	ld	[DoHiColor],a
	ei
	ld	hl,ErrorTable
	pop	bc
	ld	a,b
	add	a
	add	a
	add	l
	ld	l,a
	jr	nc,.nocarry
	inc	h
.nocarry
	push	hl
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	ld	a,10
	call	PrintStringMenu
	pop	hl
	inc	hl
	inc	hl
	ld	a,[hl+]
	ld	h,[hl]
	ld	l,a
	call	ShowMenuText
	pop	af
	cp	2
	jr	z,.clearSaveScreen

.normalLoop
	call	CheckInput
	ld	a,[sys_btnPress]
	bit	btnA,a
	jr	nz,.exit
	halt
	jr	.normalLoop
	
.exit
	halt
	xor	a
	ld	[DoHiColor],a
	ldh	[rLCDC],a
	ldh	[rSCY],a
	ret
	
.clearSaveScreen
	call	CheckInput
	ld	a,[sys_btnPress]
	bit	btnA,a
	jr	nz,.exit
	ld	a,[sys_btnHold]
	cp	_Up+_B+_Select
	jr	z,.doclear
	halt
	jr	.clearSaveScreen
.doclear
	ld	hl,ClearText
	call	ShowMenuText
	xor	a
	ld	[DoHiColor],a
	call	ClearSRAM
	ld	a,1
	ld	[DoHiColor],a
	ld	hl,SaveDataCleared
	call	ShowMenuText
.loop2
	call	CheckInput
	ld	a,[sys_btnPress]
	bit	btnA,a
	jr	nz,.exit
	halt
	jr	.loop2

ErrorHeader:	db	"     - ERROR -      ",0
WarningHeader:	db	"    - WARNING -     ",0
	
ErrorTable:
	dw	ErrorHeader,SaveCorrupt
	dw	ErrorHeader,SaveFailed
	dw	WarningHeader,ClearSaveData
	
SaveCorrupt:
	db	"THE SAVED GAME DATA ",0
	db	"IS CORRUPT AND HAS *",0
	db	"BEEN FORMATTED.*****",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"    - PRESS  A -    ",$ff
	
SaveFailed:
	db	"FAILED TO INITIALIZE",0
	db	"SAVE RAM. YOU CAN **",0
	db	"STILL PLAY THE GAME,",1
	db	"BUT YOUR PROGRESS **",0
	db	"WILL NOT BE SAVED.**",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"    - PRESS  A -    ",$ff
	
ClearSaveData:
	db	"ARE YOU SURE YOU ***",0
	db	"WANT TO DELETE ALL *",0
	db	"SAVED DATA? ONCE ***",0
	db	"DELETED, IT CAN ****",0
	db	"NEVER BE RECOVERED!*",0
	db	"****************    ",1
	db	"TO CONFIRM, PRESS***",0
	db	"UP + B + SELECT. TO*",0
	db	"CANCEL, PRESS A.****",0
	db	"********************",$ff
	
SaveDataCleared:
	db	"ALL SAVED DATA HAS *",0
	db	"BEEN CLEARED.*******",0
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"********************",1
	db	"    - PRESS  A -    ",$ff