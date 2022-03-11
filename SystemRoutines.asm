; ================================================================
; System routines
; ================================================================

; ================================================================
; Clear work RAM
; ================================================================

ClearWRAM:
	ld	hl,$c001	; don't clear first byte of WRAM (preserve GBType)
	ld	bc,$1fff
	jr	ClearLoop	; routine continues in ClearLoop

; ================================================================
; Clear tilemap area
; ================================================================

ClearScreen:
	ld	hl,$9800
	ld	bc,$7ff
	jr	ClearLoop	; routine continues in ClearLoop
	
; ================================================================
; Clear video RAM
; ================================================================

ClearVRAM:
	ld	hl,$8000
	ld	bc,$1fff
	; routine continues in ClearLoop

; ================================================================
; Clear a section of RAM
; ================================================================
	
ClearLoop:
	xor	a
	ld	[hl+],a
	dec	bc
	ld	a,b
	or	c
	jr	nz,ClearLoop
	ret

; ================================================================
; Wait for LCD status to change
; ================================================================

WaitStat:
	push	af
.wait
	ld	a,[rSTAT]
	and	2
	jr	z,.wait
.wait2
	ld	a,[rSTAT]
	and	2
	jr	nz,.wait2
	pop	af
	ret
	
; ================================================================
; Check joypad input
; ================================================================

CheckInput:
	ld	a,P1F_5
	ld	[rP1],a
	ld	a,[rP1]
	ld	a,[rP1]
	cpl
	and	a,$f
	swap	a
	ld	b,a
	
	ld	a,P1F_4
	ld	[rP1],a
	ld	a,[rP1]
	ld	a,[rP1]
	ld	a,[rP1]
	ld	a,[rP1]
	ld	a,[rP1]
	ld	a,[rP1]
	cpl
	and	a,$f
	or	a,b
	ld	b,a
	
	ld	a,[sys_btnHold]
	xor	a,b
	and	a,b
	ld	[sys_btnPress],a
	ld	a,b
	ld	[sys_btnHold],a
	ld	a,P1F_5|P1F_4
	ld	[rP1],a
	ret

; ================================================================
; Draw hexadecimal number A at HL
; ================================================================

DrawHex:
	push	af
	swap	a
	call	.loop1
	pop	af
.loop1
	and	$f
	cp	$a
	jr	c,.loop2
	add	a,$7
.loop2
	add	a,$10
	ld	[hl+],a
	ret
	
; ================================================================
; Switching CPU speeds on the GBC
;  written for RGBASM
; ================================================================

;  This is the code needed to switch the GBC
; speed from single to double speed or from
; double speed to single speed.
;
; Note: The 'nop' below is ONLY required if
; you are using RGBASM version 1.10c or earlier
; and older versions of the GBDK assembly
; language compiler. If you are not sure if
; you need it or not then leave it in.
;
;  The real opcodes for 'stop' are $10,$00.
; Some older assemblers just compiled 'stop'
; to $10 hence the need for the extra byte $00.
; The opcode for 'nop' is $00 so no harm is
; done if an extra 'nop' is included

; *** Set single speed mode ***

SingleSpeedMode:
	ld      a,[rKEY1]
	rlca	    ; Is GBC already in single speed mode?
	ret     nc      ; yes, exit
	jr      CPUToggleSpeed

; *** Set double speed mode ***

DoubleSpeedMode:
	ld      a,[rKEY1]
	rlca	    ; Is GBC already in double speed mode?
	ret     c       ; yes, exit

CPUToggleSpeed:
	di
	ld      hl,rIE
	ld      a,[hl]
	push    af
	xor     a
	ld      [hl],a	 ;disable interrupts
	ld      [rIF],a
	ld      a,$30
	ld      [rP1],a
	ld      a,1
	ld      [rKEY1],a
	stop
	pop     af
	ld      [hl],a
	ei
	ret