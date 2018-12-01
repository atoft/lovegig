require "player"

print("hello")

function love.load()
    math.randomseed(os.time())
    -------------------------------
    images = {}
    images.player = love.graphics.newImage('player_down.png')
    -------------------------------
    player = {}
    player.x = 200
    player.y = 200
    player.w = 100
    player.h = 100

    player.vX = 0
    player.vY = 0
    
    player.jumpDir = 1

    score = 0
    -------------------------------

end

function love.update(dt)
    updatePlayer(player, dt)
end

-----------------------------------------------------

function love.draw()
    love.graphics.setColor(1,1,1)
    
    love.graphics.rectangle('fill', player.x, player.y, player.w, player.h)
    --love.graphics.draw(images.player, player.x, player.y, 0, 1, 1, 22, 14)

    love.graphics.setColor(0,1,0)

end