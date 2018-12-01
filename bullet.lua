
function updateBullet(bullet, dt)

    ---- Apply speed ----
    bullet.x = bullet.x + bullet.vX * dt
    bullet.y = bullet.y + bullet.vY * dt
end

function collideBullet(bullet, monsters, dt)
    for j = 1, #monsters, 1 do
        local monster = monsters[j]
        if AABB(bullet, monster) then
            monster.state = "dead"
            return true
        end
    end

    return false
end