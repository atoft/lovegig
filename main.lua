require "player"
require "bullet"
require "monster"
require "collision"

WORLD_X = 600
WORLD_Y = 800

DIVE_CHARGE_TIME = 0.25

function love.load()
    math.randomseed(os.time())
    -------------------------------
    love.graphics.setDefaultFilter("nearest", "nearest")
    images = {}
    images.playerJump = love.graphics.newImage('ninja_jump.png')
    images.playerJumpStart = love.graphics.newImage('ninja_jump_start.png')
    images.playerDive = love.graphics.newImage('ninja_dive.png')
    images.playerDiveStart = love.graphics.newImage('ninja_dive_start.png')
    images.playerDead = love.graphics.newImage('ninja_dead.png')
    images.sword = love.graphics.newImage('sword.png')

    images.monster = love.graphics.newImage('monster.png')
    images.monsterThrown = love.graphics.newImage('monster_thrown.png')

    images.ghost = love.graphics.newImage('ghost.png')
    images.ghostThrown = love.graphics.newImage('ghost_thrown.png')

    images.bat = love.graphics.newImage('bat.png')
    images.batThrown = love.graphics.newImage('bat_thrown.png')

    images.bg = love.graphics.newImage('bg.png')
    images.overlay = love.graphics.newImage('overlay.png')

    fonts = {}
    fonts.small = love.graphics.newFont('gamer.ttf', 48)
    fonts.large = love.graphics.newFont('gamer.ttf', 72)
    fonts.xlarge = love.graphics.newFont('gamer.ttf',100)
    -------------------------------

    require "waves"
    gameInit()
end

function gameInit()
    player = {}
    player.x = 200
    player.y = 200
    player.w = 60
    player.h = 80

    player.vX = 0
    player.vY = 0
    
    player.jumpDir = 1

    player.health = 5
    player.invulnStart = 0

    player.isDiving = false
    player.diveCharge = 0
    player.diveTime = 0

    player.state = "jump"
    keys.JUMP = false

    -------------------------------
    bullets = {}
    monsters = {}
    -------------------------------
    currentWave = 1
    killsThisWave = 0
    score = 0

    timeOfWaveChange = love.timer.getTime()

    state = "menu"
end

function love.update(dt)
    if state == "menu" then
        updateMenu(dt)
    elseif state == "gameplay" then
        updateGameplay(dt)
    elseif state == "gameOver" then
        updateGameOver(dt)
    elseif state == "victory" then
        updateVictory(dt)
    end
end

function updateGameplay(dt)
    
    if killsThisWave > WAVES[currentWave].countToClear then
        currentWave = currentWave + 1
        timeOfWaveChange = love.timer.getTime()
        killsThisWave = 0

        if currentWave > #WAVES then
            state = "victory"
            return
        end
    end

    if (math.random() < WAVES[currentWave].spawnProb and #monsters < WAVES[currentWave].maxEnemies)
        or #monsters < WAVES[currentWave].minEnemies then
        spawnMonster()
    end

    updatePlayer(player, dt)

    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        updateBullet(bullet, dt)
        if collideBullet(bullet, monsters, dt) or isOffScreen(bullet) then
            table.remove(bullets, i)
        end              
    end

    for i = #monsters, 1, -1 do
        monster = monsters[i]
        updateMonster(monster, player, dt)
        collidePlayerWithMonster(monster, player)

        if monster.state == "dead" then
            score = score + 1
            killsThisWave = killsThisWave + 1
            table.remove(monsters, i)
        end
    end

    if player.health == 0 then
        state = "gameOver"
        player.state = "dead"
    end
end

function updateGameOver(dt)
    if keys.JUMP then
        gameInit()
        state = "menu"
    end
end

function updateVictory(dt)
    if keys.JUMP then
        gameInit()
    end
end

function updateMenu(dt)
    if keys.JUMP then
        state = "gameplay"
    end
end
-----------------------------------------------------

function love.draw()
    if state == "gameplay" then
        drawGameplay()
    elseif state == "gameOver" then
        drawGameplay()
        drawGameOver()
    elseif state == "victory" then
        drawGameplay()
        drawVictory()
    elseif state == "menu" then
        drawMenu()
    end
end

function drawMenu()
    love.graphics.setColor(1,1,1)

    love.graphics.draw(images.bg, 0,0)

    for i = 0, WORLD_X / 32, 1 do
        for j = 0, WORLD_Y / 32, 1 do
            love.graphics.draw(images.bg, i * 16 * 4, j * 16 * 4,0, 4, 4, 0, 0)
        end
    end

    love.graphics.draw(images.playerDive, 100, 250, 0, 10, 10, 0, 0)

    love.graphics.setFont(fonts.xlarge)
    love.graphics.print("NinjaBANG!", 130, 200)
    love.graphics.setFont(fonts.small)
    love.graphics.print("TAP [SPACE]  TO JUMP", 50, 600)
    love.graphics.print("HOLD [SPACE] TO DASH ATTACK", 50, 640)
end


function drawGameplay()
    love.graphics.setColor(1,1,1)

    love.graphics.draw(images.bg, 0,0)

    for i = 0, WORLD_X / 32, 1 do
        for j = 0, WORLD_Y / 32, 1 do
            love.graphics.draw(images.bg, i * 16 * 4, j * 16 * 4,0, 4, 4, 0, 0)
        end
    end
    
    local showPlayer = true

    if(isInvulnerable(player)) then
        --love.graphics.setColor(1,0.5,0.5)
        showPlayer = math.fmod(love.timer.getTime(), 0.2) > 0.1
    else
        showPlayer = true
    end

    love.graphics.setColor(1,1 - (player.diveCharge / DIVE_CHARGE_TIME),1 - (player.diveCharge / DIVE_CHARGE_TIME))

    --love.graphics.rectangle('fill', player.x, player.y, player.w, player.h)
    
    if player.state == "jump" then
        sprite = images.playerJump
    elseif player.state == "jump_start" then
        sprite = images.playerJumpStart
    elseif player.state == "dive" then
        sprite = images.playerDive
    elseif player.state == "dive_start" then
        sprite = images.playerDiveStart
    elseif player.state == "dead" then
        sprite = images.playerDead
    else
        sprite = images.playerJump
    end

    if player.jumpDir > 0 then
        offset = 24
    else
        offset = 10
    end

    if showPlayer then
        love.graphics.draw(sprite, player.x, player.y, 0, 4 * -player.jumpDir, 4, offset, 8)
    end

    love.graphics.setColor(1,1,1)
    --love.graphics.setColor(0,1,0)
    for i = 1, #bullets, 1 do
        bullet = bullets[i]
        --love.graphics.rectangle('fill', bullet.x, bullet.y, bullet.w, bullet.h)

        if bullet.vY < 0 then
            scale = 1
            offset = 0
        else
            scale = -1
            offset = 11
        end

        love.graphics.draw(images.sword, bullet.x, bullet.y, 0, 4, 4 * scale, 0, offset)
    end

    --love.graphics.setColor(1,0,0)
    for i = 1, #monsters, 1 do
        monster = monsters[i]
        --love.graphics.rectangle('fill', monster.x, monster.y, monster.w, monster.h)

        if monster.state == "alive" then
            sprite = monster.sprite_idle
        elseif monster.state == "thrown" then
            sprite = monster.sprite_thrown
        end

        if monster.vX < 0 then
            scale = 1
            offset = 0
        else
            scale = -1
            offset = 15
        end

        love.graphics.draw(sprite, monster.x, monster.y, 0, 4 * scale, 4, offset, 0)
    end

    love.graphics.draw(images.overlay, 0, 0, 0, 4, 4 , 0, 0)

    love.graphics.setColor(1,1,1)
    love.graphics.setFont(fonts.small)
    love.graphics.print("HEALTH " .. player.health, 20, 10)
    love.graphics.print("SCORE " .. score, 20, 40)

    if timeOfWaveChange > love.timer.getTime() - 2 then 
        showWaves = math.fmod(love.timer.getTime(), 0.2) > 0.1
    else 
        showWaves = true
    end

    if showWaves then
        love.graphics.print("WAVE " .. currentWave, 450, 10)
    end
end

function drawGameOver()
    love.graphics.setFont(fonts.large)
    love.graphics.print("GAME OVER :( ", 150, 200)
end

function drawVictory()
    love.graphics.setFont(fonts.large)
    love.graphics.print("YOU WIN!! ", 200, 200)
end