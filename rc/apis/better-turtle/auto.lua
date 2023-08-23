local slots = require "/rc.apis.better-turtle.slots"

local api = {}

function api.refuel()
    local level = turtle.getFuelLevel()
    if level == "unlimited" then
        return true
    end

    local limit = turtle.getFuelLimit()
    if level == limit then
        return true
    end

    local index = slots.findIndexBy(function(_, index)
        return turtle.isFuel(index)
    end)

    if index == nil then
        return false
    end

    slots.select(index)
    local refueled = turtle.refuel(1)
    slots.revertSelect()

    return refueled
end

function api.isFuel(index)
    if slots.select(index) then
        local isFuel = turtle.refuel(0)
        slots.revertSelect()
        return isFuel
    end

    return false
end

return api
