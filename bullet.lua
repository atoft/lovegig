
function updateBullet(bullet, dt)

    ---- Apply speed ----
    bullet.x = bullet.x + bullet.vX * dt
    bullet.y = bullet.y + bullet.vY * dt
end