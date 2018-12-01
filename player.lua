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

    local DIVE_VELOCITY = 1000

    local DIVE_DURATION = 1.5
    local DIVE_END_VELOCITY_Y = 100

    player.vY = player.vY + ACCELERATION * dt

    ---- Charge the dive ----
    if love.keyboard.isDown("space") then
        player.diveCharge = player.diveCharge + dt
    end

    ---- Jump ----
    if keys.JUMP then
        if player.diveCharge <= DIVE_CHARGE_TIME then
            player.isDiving = false
            player.diveTime = 0
            player.vY = - BOUNCE_VELOCITY_Y
            player.vX = BOUNCE_VELOCITY_X * player.jumpDir
            player.jumpDir = -player.jumpDir
        else
            player.isDiving = true
        end
        player.diveCharge = 0
    end

    if player.isDiving then
        player.vX = 0
        player.vY = DIVE_VELOCITY
        player.diveTime = player.diveTime + dt
        if player.diveTime > DIVE_DURATION then
            player.isDiving = false
            player.diveTime = 0
            player.vY = -DIVE_END_VELOCITY_Y
            player.vX = BOUNCE_VELOCITY_X * player.jumpDir
        end
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
    if keys.JUMP and not player.isDiving then
        ---- Horizontal ----
        -- local bullet = {}
        -- bullet.x = player.x + player.w + 5 
        -- bullet.y = player.y
        -- bullet.vX = 500
        -- bullet.vY = 0
        -- bullet.w = 10
        -- bullet.h = 3
        -- table.insert(bullets, bullet)

        -- local bullet = {}
        -- bullet.x = player.x - 5 
        -- bullet.y = player.y
        -- bullet.vX = -500
        -- bullet.vY = 0
        -- bullet.w = 10
        -- bullet.h = 3
        -- table.insert(bullets, bullet)

        ---- Vertical ----
        local bullet = {}
        bullet.x = player.x + player.w / 2
        bullet.y = player.y - 5
        bullet.vX = 0
        bullet.vY = -500
        bullet.w = 3
        bullet.h = 10
        table.insert(bullets, bullet)

        local bullet = {}
        bullet.x = player.x + player.w / 2
        bullet.y = player.y + player.h + 5
        bullet.vX = 0
        bullet.vY = 500
        bullet.w = 3
        bullet.h = 10
        table.insert(bullets, bullet)
        
    end

    ---- Apply speed ----
    player.x = player.x + player.vX * dt
    player.y = player.y + player.vY * dt

    if player.y > WORLD_Y then
        player.y = player.y - WORLD_Y - player.h
    elseif player.y < - player.h then
        player.y = player.y + WORLD_Y + player.h
    end

    keys.JUMP = false
end


function collidePlayerWithMonster(monster, player, dt)
    local REPEL_SPEED_PLAYER = 300
    local REPEL_SPEED_MONSTER = 300

    local REPEL_SPEED_MONSTER_DIVE = 1000

    if AABB(monster, player) then
        if not player.isDiving then
            ---- Repel from each other ----
            local direction = normalize(monster.x - player.x, monster.y - player.y)

            player.vX = -direction.x * REPEL_SPEED_PLAYER
            player.vY = -direction.y * REPEL_SPEED_PLAYER

            --monster.vX = direction.x * REPEL_SPEED_MONSTER
            --monster.vY = direction.y * REPEL_SPEED_MONSTER

            ---- Take damage? ----
            if isInvulnerable(player) == false then
                player.health = player.health - 1
                player.invulnStart = love.timer.getTime()
            end
        else
            monster.state = "thrown"
        end
    end
end

function isInvulnerable(player)
    local PLAYER_INVULN_DURATION = 2.5

    return love.timer.getTime() < player.invulnStart + PLAYER_INVULN_DURATION
end