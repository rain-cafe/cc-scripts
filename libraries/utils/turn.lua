local turn = {}

-- 1 == right, -1 == left
function turn.side(current, target)
    local diff = target - current
    if diff < 0 then
        diff = diff + 4
    end

    if diff > 2 then
        return -1
    end

    return 1
end

return turn