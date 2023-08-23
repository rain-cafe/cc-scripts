local turn = require "/libraries/utils/turn"
local table = require "/libraries/utils/table"

local navigate = {}

local DIRECTIONS = {
    UNKNOWN = -1,
    NORTH = 0,
    EAST = 1,
    SOUTH = 2,
    WEST = 3,
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
local _coords = nil
local _mode = nil

function navigate.coords()
    if _coords == nil then
        local x, y, z = gps.locate()

        if x == nil then
            print("GPS not setup, running in turtle space...")
            _coords = {
                x = 0,
                y = 0,
                z = 0
            }

            _mode = MODES.TURTLE_RELATIVE
        else
            _coords = {
                x = x,
                y = y,
                z = z
            }

            _mode = MODES.WORLD_RELATIVE
        end
    end

    return table.clone(_coords)
end

function navigate.mode()
    if _mode == nil then
        navigate.coords()
    end

    return _mode
end

function navigate.direction()
    if _direction == -1 then
        if turtle.getFuelLevel() == 0 then
            printError("Please refuel your turtle!")
            return
        end

        local coords = navigate.coords()

        if navigate.mode() == MODES.TURTLE_RELATIVE then
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

            local newX, newY, newZ = gps.locate()

            turtle.forward()

            local deltaX = newX - coords.x
            local deltaZ = newZ - coords.z

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

function navigate.humanizeDirection(dir)
    dir = dir or navigate.direction()

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

function navigate.dehumanizeDirection(dir)
    dir = dir or navigate.direction()

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

function navigate.turnRight()
    local dir = navigate.direction()

    turtle.turnRight()

    _direction = dir >= 3 and 0 or dir + 1
end

function navigate.turnLeft()
    local dir = navigate.direction()

    turtle.turnLeft()

    _direction = dir <= 0 and 3 or dir - 1
end

function navigate.turnAround()
    navigate.turnRight()
    navigate.turnRight()
end

function navigate.turnDistance(dir)
    local diff = dir - navigate.direction()
    if diff < 0 then
        diff = diff + 4
    end

    if diff > 2 then
        return -1
    end

    return 1
end

-- north, south, east, or west
function navigate.face(dir)
    local side = turn.side(navigate.direction(), dir)

    while navigate.direction() ~= dir do
        if side == 1 then
            navigate.turnRight()
        else
            navigate.turnLeft()
        end
    end
end

function navigate.forward()
    local dir = navigate.direction()

    if turtle.forward() then
        if dir == DIRECTIONS.NORTH then
            _coords.z = _coords.z - 1
        elseif dir == DIRECTIONS.SOUTH then
            _coords.z = _coords.z + 1
        elseif dir == DIRECTIONS.EAST then
            _coords.x = _coords.x + 1
        elseif dir == DIRECTIONS.WEST then
            _coords.x = _coords.x - 1
        end

        return true
    end

    return false
end

function navigate.back()
    local dir = navigate.direction()

    if turtle.back() then
        if dir == DIRECTIONS.NORTH then
            _coords.z = _coords.z - 1
        elseif dir == DIRECTIONS.SOUTH then
            _coords.z = _coords.z + 1
        elseif dir == DIRECTIONS.EAST then
            _coords.x = _coords.x - 1
        elseif dir == DIRECTIONS.WEST then
            _coords.x = _coords.x + 1
        end

        return true
    end

    return false
end

function navigate.up()
    navigate.coords()

    if turtle.up() then
        _coords.y = _coords.y + 1

        return true
    end

    return false
end

function navigate.down()
    navigate.coords()

    if turtle.down() then
        _coords.y = _coords.y - 1

        return true
    end

    return false
end

function navigate.spinny(counter)
    if counter then
        navigate.face(DIRECTIONS.WEST)
        navigate.face(DIRECTIONS.SOUTH)
        navigate.face(DIRECTIONS.EAST)
        navigate.face(DIRECTIONS.NORTH)
    else
        navigate.face(DIRECTIONS.EAST)
        navigate.face(DIRECTIONS.SOUTH)
        navigate.face(DIRECTIONS.WEST)
        navigate.face(DIRECTIONS.NORTH)
    end
end

function navigate.goto(x, y, z)
    -- TODO: Try to make this more efficient, maybe caching?
    local coords = navigate.coords()

    if navigate.mode() == MODES.TURTLE_RELATIVE then
        printError("Go-to is unable to function without a GPS!")
        return
    end

    local deltaX = x - coords.x
    local deltaY = y - coords.y
    local deltaZ = z - coords.z

    if deltaX > 0 then
        navigate.face(DIRECTIONS.EAST)
    elseif deltaX < 0 then
        navigate.face(DIRECTIONS.WEST)
    end

    for i = 1, math.abs(deltaX) do
        if turtle.detect() then
            turtle.dig()
        end

        navigate.forward()
    end

    if deltaZ > 0 then
        navigate.face(DIRECTIONS.SOUTH)
    elseif deltaZ < 0 then
        navigate.face(DIRECTIONS.NORTH)
    end

    for i = 1, math.abs(deltaZ) do
        if turtle.detect() then
            turtle.dig()
        end

        navigate.forward()
    end

    for i = 1, math.abs(deltaY) do
        if deltaY > 0 then
            if turtle.detectUp() then
                turtle.digUp()
            end

            navigate.up()
        elseif deltaY < 0 then
            if turtle.detectDown() then
                turtle.digDown()
            end

            navigate.down()
        end
    end
end

navigate.DIRECTIONS = DIRECTIONS
navigate.MODES = MODES

return navigate
