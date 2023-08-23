if not turtle then
    printError("[slots]: The 'slots' api is only usable by turtles!")
end

local api = {}
local _slots = nil

function api.slots(refresh)
    if refresh then
        _slots = nil
    end

    if _slots == nil then
        _slots = {}

        for i = 1, 16 do
            _slots[i] = turtle.getItemDetail(i)
        end
    end

    return _slots
end

function api.slot(index)
    local slots = api.slots()

    return slots[index]
end

function api.findIndexBy(predicate)
    local slots = api.slots()

    for i = 1, 16 do
        if slots[i] ~= nil and predicate(slots[i], i) then
            return i
        end
    end

    return nil
end

function api.findBy(predicate)
    local index = api.findIndexBy(predicate)

    if index == nil then
        return nil
    end

    return api.slot(index)
end

return api
