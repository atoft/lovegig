function AABB(box1, box2)
    return box1.x < box2.x + box2.w and
        box1.x + box1.w > box2.x and
        box1.y < box2.h + box2.y and
        box1.y + box1.h > box2.y
end