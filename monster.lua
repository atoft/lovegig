require "tools"

function spawnMonster()
    local monster = {}

    monster.w = 100
    monster.h = 100

    edgeToSpawn = math.random(1, 4)

    if edgeToSpawn == 1 then
        monster.x = 0
        monster.y = math.random(1, WORLD_Y)
    elseif edgeToSpawn == 2 then
        monster.x = WORLD_X
        monster.y = math.random(1, WORLD_Y)
    elseif edgeToSpawn == 3 then
        monster.x = math.random(1, WORLD_X)
        monster.y = 0
    elseif edgeToSpawn == 4 then
        monster.x = math.random(1, WORLD_Y)
        monster.y = 0
    end

    monster.vX = 0
    monster.vY = 0
    
    table.insert(monsters, monster)
end

function updateMonster(monster, target, dt)
    local MONSTER_SPEED = 100

    direction = normalize(target.x - monster.x, target.y - monster.y)
    monster.vX = direction.x * MONSTER_SPEED
    monster.vY = direction.y * MONSTER_SPEED

    ---- Apply speed ----
    monster.x = monster.x + monster.vX * dt
    monster.y = monster.y + monster.vY * dt
end
