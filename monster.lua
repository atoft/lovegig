require "tools"

function spawnMonster()
    local monster = {}

    monster.w = 60
    monster.h = 60

    edgeToSpawn = math.random(1, 2)

    if edgeToSpawn == 1 then
        monster.x = 0
        monster.y = math.random(1, WORLD_Y)
    elseif edgeToSpawn == 2 then
        monster.x = WORLD_X
        monster.y = math.random(1, WORLD_Y)
    end

    monster.vX = 0
    monster.vY = 0
    monster.state = "alive"
    monster.sprite_idle = WAVES[currentWave].monster.idle
    monster.sprite_thrown = WAVES[currentWave].monster.thrown

    table.insert(monsters, monster)
end

function updateMonster(monster, target, dt)
    local MONSTER_SPEED = WAVES[currentWave].monsterSpeed
    local MONSTER_THROW_SPEED = 1000

    direction = normalize(target.x - monster.x, target.y - monster.y)

    if monster.state == "alive" then
        monster.vX = direction.x * MONSTER_SPEED
        monster.vY = direction.y * MONSTER_SPEED
    elseif monster.state == "thrown" then
        if not AABB(monster, target) then
            monster.state = "dead"
        else
            if(direction.x > 0) then
                monster.vX = -MONSTER_THROW_SPEED
                print("Throw left")
            else
                monster.vX = MONSTER_THROW_SPEED
                print("throw right")
            end
        end
        monster.vY = 0
    end

    ---- Apply speed ----
    monster.x = monster.x + monster.vX * dt
    monster.y = monster.y + monster.vY * dt
end
