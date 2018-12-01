function normalize(x, y)
    local result = {}
    local magnitude = math.sqrt(x * x + y * y)

    result.x = x / magnitude;
    result.y = y / magnitude;

    return result
end

function isOffScreen(entity)
    return entity.x > WORLD_X or
          entity.x < -entity.w or
          entity.y > WORLD_Y or
          entity.y < -entity.h
end

function clamp(val, min, max)
    return math.max(min, math.min(val, max));
end