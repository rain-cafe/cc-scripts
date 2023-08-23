local slots = require "/libraries/apis/slots"

turtle.auto = {}

function turtle.auto.refuel()
    local level = turtle.getFuelLevel()
    if level == "unlimited" then
        return true
    end

    local limit = turtle.getFuelLimit()
    if level == limit then
        return true
    end

    local index = slots.findIndexBy(function(item, index)
        return turtle.isFuel(index)
    end)

    if index == nil then
        return false
    end

    turtle.auto.select(index)
    local refueled, reason = turtle.refuel(1)
    turtle.auto.revertSelect()

    return refueled
end

function turtle.auto.select(index)
    local priorSelection = turtle.getSelectedSlot()

    if turtle.select(index) then
        turtle.auto._priorSelection = priorSelection
        return true
    end

    return false
end

function turtle.auto.revertSelect()
    local priorSelection = turtle.auto._priorSelection

    if priorSelection ~= nil and turtle.select(priorSelection) then
        priorSelection = nil
        return true
    end

    return false
end

function turtle.isFuel(index)
    if turtle.auto.select(index) then
        local isFuel = turtle.refuel(0)
        turtle.auto.revertSelect()
        return isFuel
    end

    return false
end
