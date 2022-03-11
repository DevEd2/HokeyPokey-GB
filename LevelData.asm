section	"Level data",romx,bank[6]
LevelData:
; ================================================================
; Level data
; ================================================================

LevelTable:
	dw	Level1
	dw	Level2
	dw	Level3
	dw	Level4
	dw	Level5
	dw	Level6
	dw	Level7
	dw	Level8
	dw	Level9
	dw	DummyLevel
	
Level1:
.hokeyX		db	$10
.pokeyX		db	$80
.playerY	db	$88
.needKey	db	0
.fruitCount	db	0
.enemyCount	db	0
.goalpos	db	80,24
.keypos		db	0,0
.fruit1pos	db	0,0
.fruit2pos	db	0,0
.fruit3pos	db	0,0
.fruit4pos	db	0,0
.fruit5pos	db	0,0
.fruit6pos	db	0,0
.fruit7pos	db	0,0
.fruit8pos	db	0,0
.enemy1pos	db	0,0
.enemy2pos	db	0,0
.enemy3pos	db	0,0
.enemy4pos	db	0,0
.enemy5pos	db	0,0
.enemy6pos	db	0,0
.enemy7pos	db	0,0
.enemy8pos	db	0,0
.levelTune	db	mus_Menu	; replace with mus_Bricks once it is made
.map		incbin	"Data/Level1.bin"

Level2:
.hokeyX		db	$10
.pokeyX		db	$80
.playerY	db	$88
.needKey	db	1
.fruitCount	db	0
.enemyCount	db	0
.goalpos	db	80,40
.keypos		db	80,72
.fruit1pos	db	0,0
.fruit2pos	db	0,0
.fruit3pos	db	0,0
.fruit4pos	db	0,0
.fruit5pos	db	0,0
.fruit6pos	db	0,0
.fruit7pos	db	0,0
.fruit8pos	db	0,0
.enemy1pos	db	0,0
.enemy2pos	db	0,0
.enemy3pos	db	0,0
.enemy4pos	db	0,0
.enemy5pos	db	0,0
.enemy6pos	db	0,0
.enemy7pos	db	0,0
.enemy8pos	db	0,0
.levelTune	db	mus_Beach
.map	incbin	"Data/Level2.bin"

Level3:
.hokeyX		db	$10
.pokeyX		db	$80
.playerY	db	$58
.needKey	db	1
.fruitCount	db	0
.enemyCount	db	0
.goalpos	db	80,24
.keypos		db	48,120
.fruit1pos	db	0,0
.fruit2pos	db	0,0
.fruit3pos	db	0,0
.fruit4pos	db	0,0
.fruit5pos	db	0,0
.fruit6pos	db	0,0
.fruit7pos	db	0,0
.fruit8pos	db	0,0
.enemy1pos	db	0,0
.enemy2pos	db	0,0
.enemy3pos	db	0,0
.enemy4pos	db	0,0
.enemy5pos	db	0,0
.enemy6pos	db	0,0
.enemy7pos	db	0,0
.enemy8pos	db	0,0
.levelTune	db	mus_Snow
.map	incbin	"Data/Level3.bin"

Level4:
.hokeyX		db	$10
.pokeyX		db	$80
.playerY	db	$88
.needKey	db	0
.fruitCount	db	0
.enemyCount	db	0
.goalpos	db	80,24
.keypos		db	0,0
.fruit1pos	db	0,0
.fruit2pos	db	0,0
.fruit3pos	db	0,0
.fruit4pos	db	0,0
.fruit5pos	db	0,0
.fruit6pos	db	0,0
.fruit7pos	db	0,0
.fruit8pos	db	0,0
.enemy1pos	db	0,0
.enemy2pos	db	0,0
.enemy3pos	db	0,0
.enemy4pos	db	0,0
.enemy5pos	db	0,0
.enemy6pos	db	0,0
.enemy7pos	db	0,0
.enemy8pos	db	0,0
.levelTune	db	mus_Menu	; replace with mus_Blocks once it is made
.map		incbin	"Data/Level4.bin"

Level5:
.hokeyX		db	$10
.pokeyX		db	$80
.playerY	db	$88
.needKey	db	0
.fruitCount	db	0
.enemyCount	db	0
.goalpos	db	80,24
.keypos		db	0,0
.fruit1pos	db	0,0
.fruit2pos	db	0,0
.fruit3pos	db	0,0
.fruit4pos	db	0,0
.fruit5pos	db	0,0
.fruit6pos	db	0,0
.fruit7pos	db	0,0
.fruit8pos	db	0,0
.enemy1pos	db	0,0
.enemy2pos	db	0,0
.enemy3pos	db	0,0
.enemy4pos	db	0,0
.enemy5pos	db	0,0
.enemy6pos	db	0,0
.enemy7pos	db	0,0
.enemy8pos	db	0,0
.levelTune	db	mus_Desert
.map		incbin	"Data/Level5.bin"

Level6:
.hokeyX		db	$18
.pokeyX		db	$78
.playerY	db	$88
.needKey	db	1
.fruitCount	db	0
.enemyCount	db	0
.goalpos	db	80,80
.keypos		db	80,136
.fruit1pos	db	0,0
.fruit2pos	db	0,0
.fruit3pos	db	0,0
.fruit4pos	db	0,0
.fruit5pos	db	0,0
.fruit6pos	db	0,0
.fruit7pos	db	0,0
.fruit8pos	db	0,0
.enemy1pos	db	0,0
.enemy2pos	db	0,0
.enemy3pos	db	0,0
.enemy4pos	db	0,0
.enemy5pos	db	0,0
.enemy6pos	db	0,0
.enemy7pos	db	0,0
.enemy8pos	db	0,0
.levelTune	db	mus_Menu	; replace with mus_Bricks once it is made
.map		incbin	"Data/Level6.bin"

Level7:
.hokeyX		db	$10
.pokeyX		db	$80
.playerY	db	$88
.needKey	db	0
.fruitCount	db	0
.enemyCount	db	0
.goalpos	db	80,24
.keypos		db	0,0
.fruit1pos	db	0,0
.fruit2pos	db	0,0
.fruit3pos	db	0,0
.fruit4pos	db	0,0
.fruit5pos	db	0,0
.fruit6pos	db	0,0
.fruit7pos	db	0,0
.fruit8pos	db	0,0
.enemy1pos	db	0,0
.enemy2pos	db	0,0
.enemy3pos	db	0,0
.enemy4pos	db	0,0
.enemy5pos	db	0,0
.enemy6pos	db	0,0
.enemy7pos	db	0,0
.enemy8pos	db	0,0
.levelTune	db	mus_Desert
.map		incbin	"Data/Level7.bin"

Level8:
.hokeyX		db	$10
.pokeyX		db	$80
.playerY	db	$88
.needKey	db	0
.fruitCount	db	0
.enemyCount	db	0
.goalpos	db	80,56
.keypos		db	0,0
.fruit1pos	db	0,0
.fruit2pos	db	0,0
.fruit3pos	db	0,0
.fruit4pos	db	0,0
.fruit5pos	db	0,0
.fruit6pos	db	0,0
.fruit7pos	db	0,0
.fruit8pos	db	0,0
.enemy1pos	db	0,0
.enemy2pos	db	0,0
.enemy3pos	db	0,0
.enemy4pos	db	0,0
.enemy5pos	db	0,0
.enemy6pos	db	0,0
.enemy7pos	db	0,0
.enemy8pos	db	0,0
.levelTune	db	mus_Beach
.map		incbin	"Data/Level8.bin"

Level9:
.hokeyX		db	$10
.pokeyX		db	$80
.playerY	db	$88
.needKey	db	0
.fruitCount	db	0
.enemyCount	db	0
.goalpos	db	80,104
.keypos		db	0,0
.fruit1pos	db	0,0
.fruit2pos	db	0,0
.fruit3pos	db	0,0
.fruit4pos	db	0,0
.fruit5pos	db	0,0
.fruit6pos	db	0,0
.fruit7pos	db	0,0
.fruit8pos	db	0,0
.enemy1pos	db	0,0
.enemy2pos	db	0,0
.enemy3pos	db	0,0
.enemy4pos	db	0,0
.enemy5pos	db	0,0
.enemy6pos	db	0,0
.enemy7pos	db	0,0
.enemy8pos	db	0,0
.levelTune	db	mus_Snow
.map		incbin	"Data/Level9.bin"

DummyLevel:
.hokeyX		db	$10
.pokeyX		db	$80
.playerY	db	$88
.needKey	db	1
.fruitCount	db	0
.enemyCount	db	0
.goalpos	db	88,16
.keypos		db	72,24
.fruit1pos	db	0,0
.fruit2pos	db	0,0
.fruit3pos	db	0,0
.fruit4pos	db	0,0
.fruit5pos	db	0,0
.fruit6pos	db	0,0
.fruit7pos	db	0,0
.fruit8pos	db	0,0
.enemy1pos	db	0,0
.enemy2pos	db	0,0
.enemy3pos	db	0,0
.enemy4pos	db	0,0
.enemy5pos	db	0,0
.enemy6pos	db	0,0
.enemy7pos	db	0,0
.enemy8pos	db	0,0
.levelTune	db	mus_Title
.map	incbin	"Data/DummyLevel.bin"