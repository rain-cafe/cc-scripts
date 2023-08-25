local turn = require "/rc.utils.turn"

local api = {}

local DIRECTIONS = {
    UNKNOWN = -1,
    NORTH = 0,
    EAST = 1,
    SOUTH = 2,
    WEST = 3
}

local MODES = {
    UNKNOWN = -1,
    WORLD_RELATIVE = 0,
    TURTLE_RELATIVE = 1
}

-- -1: We have no idea what the current direction is
--  0: We're facing "north"
--  1: We're facing "east"
--  2: We're facing "south"
--  3: We're facing "west"
local _direction = -1
local _x = nil
local _y = nil
local _z = nil
local _mode = nil

function api.coords()
    if _x == nil or _y == nil or _z == nil then
        local x, y, z = gps.locate(2)

        if x == nil then
            print("GPS not setup, running in turtle space...")
            _x = 0
            _y = 0
            _z = 0

            _mode = MODES.TURTLE_RELATIVE
        else
            _x = math.floor(x)
            _y = math.floor(y)
            _z = math.floor(z)

            _mode = MODES.WORLD_RELATIVE
        end
    end

    return _x, _y, _z
end

function api.mode()
    if _mode == nil then
        api.coords()
    end

    return _mode
end

function api.direction()
    if _direction == -1 then
        if turtle.getFuelLevel() == 0 then
            printError("Please refuel your turtle!")
            return
        end

        local x, _, z = api.coords()

        if api.mode() == MODES.TURTLE_RELATIVE then
            _direction = DIRECTIONS.NORTH
        else
            turtle.turnRight()
            turtle.turnRight()

            if turtle.detect() then
                turtle.dig()
            end

            turtle.turnRight()
            turtle.turnRight()

            turtle.back()

            local newX, _, newZ = gps.locate()

            turtle.forward()

            local deltaX = newX - x
            local deltaZ = newZ - z

            if deltaZ < 0 then
                _direction = DIRECTIONS.SOUTH
            elseif deltaZ > 0 then
                _direction = DIRECTIONS.NORTH
            elseif deltaX < 0 then
                _direction = DIRECTIONS.EAST
            elseif deltaX > 0 then
                _direction = DIRECTIONS.WEST
            else
                printError("Unable to determine turtle direction.")
            end
        end
    end

    return _direction
end

function api.humanizeDirection(dir)
    dir = dir or api.direction()

    if dir == DIRECTIONS.UNKNOWN then
        return "unknown"
    elseif dir == DIRECTIONS.NORTH then
        return "north"
    elseif dir == DIRECTIONS.EAST then
        return "east"
    elseif dir == DIRECTIONS.SOUTH then
        return "south"
    elseif dir == DIRECTIONS.WEST then
        return "west"
    end

    return nil
end

function api.dehumanizeDirection(dir)
    dir = dir or api.direction()

    if dir == "unknown" then
        return DIRECTIONS.UNKNOWN
    elseif dir == "north" or dir == "n" then
        return DIRECTIONS.NORTH
    elseif dir == "east" or dir == "e" then
        return DIRECTIONS.EAST
    elseif dir == "south" or dir == "s" then
        return DIRECTIONS.SOUTH
    elseif dir == "west" or dir == "w" then
        return DIRECTIONS.WEST
    end

    return nil
end

function api.turnRight()
    local dir = api.direction()

    turtle.turnRight()

    _direction = dir >= 3 and 0 or dir + 1
end

function api.turnLeft()
    local dir = api.direction()

    turtle.turnLeft()

    _direction = dir <= 0 and 3 or dir - 1
end

function api.turnAround()
    api.turnRight()
    api.turnRight()
end

function api.turnDistance(dir)
    local diff = dir - api.direction()
    if diff < 0 then
        diff = diff + 4
    end

    if diff > 2 then
        return -1
    end

    return 1
end

-- north, south, east, or west
function api.face(dir)
    local side = turn.side(api.direction(), dir)

    while api.direction() ~= dir do
        if side == 1 then
            api.turnRight()
        else
            api.turnLeft()
        end
    end
end

function api.forward()
    local dir = api.direction()

    if turtle.forward() then
        if dir == DIRECTIONS.NORTH then
            _z = _z - 1
        elseif dir == DIRECTIONS.SOUTH then
            _z = _z + 1
        elseif dir == DIRECTIONS.EAST then
            _x = _x + 1
        elseif dir == DIRECTIONS.WEST then
            _x = _x - 1
        end

        return true
    end

    return false
end

function api.back()
    local dir = api.direction()

    if turtle.back() then
        if dir == DIRECTIONS.NORTH then
            _z = _z - 1
        elseif dir == DIRECTIONS.SOUTH then
            _z = _z + 1
        elseif dir == DIRECTIONS.EAST then
            _x = _x - 1
        elseif dir == DIRECTIONS.WEST then
            _x = _x + 1
        end

        return true
    end

    return false
end

function api.up()
    api.coords()

    if turtle.up() then
        _y = _y + 1

        return true
    end

    return false
end

function api.down()
    api.coords()

    if turtle.down() then
        _y = _y - 1

        return true
    end

    return false
end

function api.spinny(counter)
    if counter then
        api.face(DIRECTIONS.WEST)
        api.face(DIRECTIONS.SOUTH)
        api.face(DIRECTIONS.EAST)
        api.face(DIRECTIONS.NORTH)
    else
        api.face(DIRECTIONS.EAST)
        api.face(DIRECTIONS.SOUTH)
        api.face(DIRECTIONS.WEST)
        api.face(DIRECTIONS.NORTH)
    end
end

function api.go(targetX, targetY, targetZ)
    -- TODO: Try to make this more efficient, maybe caching?
    local x, y, z = api.coords()

    local deltaX = targetX - x
    local deltaY = targetY - y
    local deltaZ = targetZ - z

    if deltaX > 0 then
        api.face(DIRECTIONS.EAST)
    elseif deltaX < 0 then
        api.face(DIRECTIONS.WEST)
    end

    for _ = 1, math.abs(deltaX) do
        if turtle.detect() then
            turtle.dig()
        end

        api.forward()
    end

    if deltaZ > 0 then
        api.face(DIRECTIONS.SOUTH)
    elseif deltaZ < 0 then
        api.face(DIRECTIONS.NORTH)
    end

    for _ = 1, math.abs(deltaZ) do
        if turtle.detect() then
            turtle.dig()
        end

        api.forward()
    end

    for _ = 1, math.abs(deltaY) do
        if deltaY > 0 then
            if turtle.detectUp() then
                turtle.digUp()
            end

            api.up()
        elseif deltaY < 0 then
            if turtle.detectDown() then
                turtle.digDown()
            end

            api.down()
        end
    end
end

api.DIRECTIONS = DIRECTIONS
api.MODES = MODES

return api
