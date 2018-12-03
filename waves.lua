
MONSTER_EYE = {}
MONSTER_EYE.idle = images.monster
MONSTER_EYE.thrown = images.monsterThrown

MONSTER_GHOST = {}
MONSTER_GHOST.idle = images.ghost
MONSTER_GHOST.thrown = images.ghostThrown

MONSTER_BAT = {}
MONSTER_BAT.idle = images.bat
MONSTER_BAT.thrown = images.batThrown


WAVES = {}

wave = {}
wave.spawnProb = 0.01
wave.minEnemies = 1
wave.maxEnemies = 3
wave.countToClear = 8
wave.monsterSpeed = 50
wave.monster = MONSTER_EYE
table.insert(WAVES, wave)

wave = {}
wave.spawnProb = 0.01
wave.minEnemies = 1
wave.maxEnemies = 4
wave.countToClear = 10
wave.monsterSpeed = 80
wave.monster = MONSTER_GHOST
table.insert(WAVES, wave)

wave = {}
wave.spawnProb = 0.01
wave.minEnemies = 1
wave.maxEnemies = 4
wave.countToClear = 12
wave.monsterSpeed = 80
wave.monster = MONSTER_EYE
table.insert(WAVES, wave)

wave = {}
wave.spawnProb = 0.01
wave.minEnemies = 1
wave.maxEnemies = 4
wave.countToClear = 12
wave.monsterSpeed = 100
wave.monster = MONSTER_BAT
table.insert(WAVES, wave)

wave = {}
wave.spawnProb = 0.01
wave.minEnemies = 1
wave.maxEnemies = 5
wave.countToClear = 12
wave.monsterSpeed = 100
wave.monster = MONSTER_GHOST
table.insert(WAVES, wave)