

function normalize(x, y)
    local result = {}
    local magnitude = math.sqrt(x * x + y * y)

    result.x = x / magnitude;
    result.y = y / magnitude;

    return result
end