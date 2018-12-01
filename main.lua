require "player"
require "bullet"
require "monster"
require "collision"

WORLD_X = 720
WORLD_Y = 1000

DIVE_CHARGE_TIME = 0.25

function love.load()
    math.randomseed(os.time())
    -------------------------------
    images = {}
    images.player = love.graphics.newImage('player_down.png')
    -------------------------------
    player = {}
    player.x = 200
    player.y = 200
    player.w = 60
    player.h = 100

    player.vX = 0
    player.vY = 0
    
    player.jumpDir = 1

    player.health = 5
    player.invulnStart = 0

    player.isDiving = false
    player.diveCharge = 0
    player.diveTime = 0
    -------------------------------
    bullets = {}
    monsters = {}

end

function love.update(dt)
    if math.random() < 0.01 then
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
            table.remove(monsters, i)
        end
    end
end

-----------------------------------------------------

function love.draw()
    love.graphics.setColor(1,1,1)
    
    if(isInvulnerable(player)) then
        love.graphics.setColor(1,0.5,0.5)
    end

    love.graphics.setColor(1,1,1 - (player.diveCharge / DIVE_CHARGE_TIME))

    love.graphics.rectangle('fill', player.x, player.y, player.w, player.h)
    --love.graphics.draw(images.player, player.x, player.y, 0, 1, 1, 22, 14)

    love.graphics.setColor(0,1,0)
    for i = 1, #bullets, 1 do
        bullet = bullets[i]
        love.graphics.rectangle('fill', bullet.x, bullet.y, bullet.w, bullet.h)
    end

    love.graphics.setColor(1,0,0)
    for i = 1, #monsters, 1 do
        monster = monsters[i]
        love.graphics.rectangle('fill', monster.x, monster.y, monster.w, monster.h)
    end

    love.graphics.setColor(1,1,1)
    love.graphics.print("HEALTH " .. player.health, 10, 10)
end