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
    elseif player.x >= 720 - player.w then
        player.vX = -BOUNCE_VELOCITY_X
        player.jumpDir = 1
    end

    ---- Apply speed ----
    player.x = player.x + player.vX * dt
    player.y = player.y + player.vY * dt

    keys.JUMP = false
end