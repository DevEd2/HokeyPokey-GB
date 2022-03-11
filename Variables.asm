; ================================================================
; Variables
; ================================================================

if !def(incVars)
incVars	set	1

SECTION	"Variables",WRAM0

; ================================================================
; Global variables
; ================================================================

GBType				ds	1	; current GB type (0 = DMG, 1 = GBC, 2 = GBA)
sys_btnHold			ds	1	; held buttons
sys_btnPress		ds	1	; pressed buttons
DoHiColor			ds	1
HiColorOffset		ds	1
RandPtr				ds	1

DMGScreenTimer		ds	1
DMGCurrentScreen	ds	1

StatType			ds	1
StatCounter			ds	1

MenuPos				ds	1
CurrentMenu			ds	1
MenuCursorOffset	ds	1
MenuMax				ds	1
MenuItem5Offset		ds	1
MenuItem4Offset		ds	1
MenuItem3Offset		ds	1
MenuItem2Offset		ds	1
MenuItem1Offset		ds	1
MenuItem5ScrollPos	ds	1
MenuItem4ScrollPos	ds	1
MenuItem3ScrollPos	ds	1
MenuItem2ScrollPos	ds	1
MenuItem1ScrollPos	ds	1
MenuItem5Timer		ds	1
MenuItem4Timer		ds	1
MenuItem3Timer		ds	1
MenuItem2Timer		ds	1
MenuItem1Timer		ds	1
MenuDoClear			ds	1
MenuTextTimer		ds	1
VBLFlag				ds	1

STMusID				ds	1
STSFXID				ds	1

CheatOffset			ds	1
CheatModeOn			ds	1

MusicOff			ds	1
SFXOff				ds	1
TempMusicOff		ds	1
TempSFXOff			ds	1

; ================================================================
; Project-specific variables
; ================================================================

ScreenTimer			ds	1	; screen timer

CurrentScore		ds	2
CurrentTime			ds	2

HokeyX				ds	1	; Hokey X pos
PokeyX				ds	1	; Pokey X pos
HokeyY				ds	1	; Hokey Y pos
PokeyY				ds	1	; Pokey Y pos
HokeyDir			ds	1	; Hokey dir (0 = up, 1 = right, 2 = down, 3 = left)
PokeyDir			ds	1	; Pokey dir (0 = up, 1 = right, 2 = down, 3 = left)
PlayerFlip			ds	1	; whether to flip the player sprites
PlayerMoveTimer		ds	1

NeedKey				ds	1	; whether or not the player needs a key in order to clear the level
HaveKey				ds	1	; whether or not the player has a key

Score100			ds	1	; score (100s digit)
Score10				ds	1	; score (10s digit and 1s digit)

LevelTimer			ds	2	; level timer

CurrentLevel		ds	1

FruitCount			ds	1
EnemyCount			ds	1

TouchingGoal		ds	1

KeyX				ds	1	; key X pos
KeyY				ds	1	; key Y pos
GoalX				ds	1
GoalY				ds	1
CollectedFruit		ds	1	; 0 = not collected, 1 = collected
Fruit1X				ds	1
Fruit1Y				ds	1
Fruit2X				ds	1
Fruit2Y				ds	1
Fruit3X				ds	1
Fruit3Y				ds	1
Fruit4X				ds	1
Fruit4Y				ds	1
Fruit5X				ds	1
Fruit5Y				ds	1
Fruit6X				ds	1
Fruit6Y				ds	1
Fruit7X				ds	1
Fruit7Y				ds	1
Fruit8X				ds	1
Fruit8Y				ds	1
Enemy1X				ds	1
Enemy1Y				ds	1
Enemy2X				ds	1
Enemy2Y				ds	1
Enemy3X				ds	1
Enemy3Y				ds	1
Enemy4X				ds	1
Enemy4Y				ds	1
Enemy5X				ds	1
Enemy5Y				ds	1
Enemy6X				ds	1
Enemy6Y				ds	1
Enemy7X				ds	1
Enemy7Y				ds	1
Enemy8X				ds	1
Enemy8Y				ds	1
Fruit1Spr			ds	1
Fruit2Spr			ds	1
Fruit3Spr			ds	1
Fruit4Spr			ds	1
Fruit5Spr			ds	1
Fruit6Spr			ds	1
Fruit7Spr			ds	1
Fruit8Spr			ds	1
Enemy1Spr			ds	1
Enemy2Spr			ds	1
Enemy3Spr			ds	1
Enemy4Spr			ds	1
Enemy5Spr			ds	1
Enemy6Spr			ds	1
Enemy7Spr			ds	1
Enemy8Spr			ds	1

section	"OAM buffer 1",WRAM0[$c100]
OAMBuffer			ds	$a0
section	"OAM buffer 2",WRAM0[$c200]
OAMBuffer2			ds	$a0

; ================================================================
; SRAM variables
; ================================================================

SECTION	"SRAM variables",SRAM

SRAMChecksum			ds	1

; ================================================================
; HRAM variables
; ================================================================

SECTION "Temporary register storage space",HRAM

_OAM_DMA			ds	16
_OAM_DMA2			ds	16
tempAF				ds	2
tempBC				ds	2
tempDE				ds	2
tempHL				ds	2
tempSP				ds	2
tempPC				ds	2
tempIF				ds	1
tempIE				ds	1
ROMBank				ds	1
endc
