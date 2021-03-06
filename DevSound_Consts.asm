; ================================================================
; DevSound constants
; ================================================================

if !def(incDSConsts)
incDSConsts	set	1

; Note values

C_2		equ	$00
C#2		equ	$01
D_2		equ	$02
D#2		equ	$03
E_2		equ	$04
F_2		equ	$05
F#2		equ	$06
G_2		equ	$07
G#2		equ	$08
A_2		equ	$09
A#2		equ	$0a
B_2		equ	$0b
C_3		equ	$0c
C#3		equ	$0d
D_3		equ	$0e
D#3		equ	$0f
E_3		equ	$10
F_3		equ	$11
F#3		equ	$12
G_3		equ	$13
G#3		equ	$14
A_3		equ	$15
A#3		equ	$16
B_3		equ	$17
C_4		equ	$18
C#4		equ	$19
D_4		equ	$1a
D#4		equ	$1b
E_4		equ	$1c
F_4		equ	$1d
F#4		equ	$1e
G_4		equ	$1f
G#4		equ	$20
A_4		equ	$21
A#4		equ	$22
B_4		equ	$23
C_5		equ	$24
C#5		equ	$25
D_5		equ	$26
D#5		equ	$27
E_5		equ	$28
F_5		equ	$29
F#5		equ	$2a
G_5		equ	$2b
G#5		equ	$2c
A_5		equ	$2d
A#5		equ	$2e
B_5		equ	$2f
C_6		equ	$30
C#6		equ	$31
D_6		equ	$32
D#6		equ	$33
E_6		equ	$34
F_6		equ	$35
F#6		equ	$36
G_6		equ	$37
G#6		equ	$38
A_6		equ	$39
A#6		equ	$3a
B_6		equ	$3b
C_7		equ	$3c
C#7		equ	$3d
D_7		equ	$3e
D#7		equ	$3f
E_7		equ	$40
F_7		equ	$41
F#7		equ	$42
G_7		equ	$43
G#7		equ	$44
A_7		equ	$45
A#7		equ	$46
B_7		equ	$47
rest	equ	$48

fix		equ	C_2

; Command definitions

SetInstrument		equ	$80
SetLoopPoint		equ	$81
GotoLoopPoint		equ	$82
CallSection			equ	$83
SetChannelPtr		equ	$84
PitchBendUp			equ	$85
PitchBendDown		equ	$86
SetSweep			equ	$87
SetPan				equ	$88
SetSpeed			equ	$89
SetInsAlternate		equ	$8a
RandomizeWave		equ	$8b
CombineWaves		equ	$8c
EnablePWM			equ	$8d
EnableRandomizer	equ	$8e
DisableAutoWave		equ	$8f
Arp					equ	$90
DummyCommand		equ	$91
EndChannel			equ	$FF

endc
