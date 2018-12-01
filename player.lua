local keys = {}
keys.JUMP = false

function love.keyreleased(key)
   if key == "space" then
      keys.JUMP = true
   end
end


function updatePlayer(player, dt)
    local ACCELERATION = 300
    local BOUNCE_VELOCITY_Y = 300
    local BOUNCE_VELOCITY_X = 200

    player.vY = player.vY + ACCELERATION * dt

    ---- Jump ----
    if keys.JUMP then
        player.vY = - BOUNCE_VELOCITY_Y
        player.vX = BOUNCE_VELOCITY_X * player.jumpDir
        player.jumpDir = -player.jumpDir
    end

    ---- Rebound from walls ----
    if player.x < 0 then
        player.vX = BOUNCE_VELOCITY_X
        player.jumpDir = -1
    elseif player.x >= WORLD_X - player.w then
        player.vX = -BOUNCE_VELOCITY_X
        player.jumpDir = 1
    end

    ---- Spawn bullets ----
    if keys.JUMP then
        ---- Horizontal ----
        local bullet1 = {}
        bullet1.x = player.x + player.w + 5 
        bullet1.y = player.y
        bullet1.vX = 500
        bullet1.vY = 0
        bullet1.w = 10
        bullet1.h = 3
        table.insert(bullets, bullet1)

        local bullet2 = {}
        bullet2.x = player.x - 5 
        bullet2.y = player.y
        bullet2.vX = -500
        bullet2.vY = 0
        bullet2.w = 10
        bullet2.h = 3
        table.insert(bullets, bullet2)
        
    end

    ---- Apply speed ----
    player.x = player.x + player.vX * dt
    player.y = player.y + player.vY * dt

    keys.JUMP = false
end


function collidePlayerWithMonster(monster, player, dt)
    local REPEL_SPEED_PLAYER = 300
    local REPEL_SPEED_MONSTER = 100

    if AABB(monster, player) then
        local direction = normalize(monster.x - player.x, monster.y - player.y)

        player.vX = -direction.x * REPEL_SPEED_PLAYER
        player.vY = -direction.y * REPEL_SPEED_PLAYER

        monster.vX = direction.x * REPEL_SPEED_PLAYER
        monster.vY = direction.y * REPEL_SPEED_PLAYER
    end
end