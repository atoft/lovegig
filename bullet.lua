
function updateBullet(bullet, dt)

    ---- Apply speed ----
    bullet.x = bullet.x + bullet.vX * dt
    bullet.y = bullet.y + bullet.vY * dt
end

function collideBullet(bullet, monsters, dt)
    for j = #monsters, 1, -1 do
        local monster = monsters[j]
        if AABB(bullet, monster) then
            table.remove(monsters, j)
            table.remove(bullets, i)
        end
    end
end