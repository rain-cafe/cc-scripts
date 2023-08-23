local navigate = require "/libraries/apis/navigate"
local number = require "/libraries/utils/number"

local function printUsage()
    print("Usage:")
    print("dig <forward> [down] <right>")
end

local tArgs = {...}
if #tArgs < 2 then
    printUsage()
    return
end

if not turtle then
    printError("This command can only be executed on a turtle")
    return
end

local debug = true
local forward = tonumber(arg[1]) - 1
local down = #tArgs == 3 and tonumber(arg[2]) or 1
local right = #tArgs == 2 and tonumber(arg[2]) or tonumber(arg[3])

print("Dig operation started...")

local startingCoords = navigate.coords()
local startingDir = navigate.direction()

local function digForward()
    turtle.dig()
    navigate.forward()
end

local function turn(totalRows, layer, row)
    print((totalRows + row + 1) % 2 == 1 and "right" or "left")

    -- TODO: How can we simplify this into an equation?
    if number.isEven(totalRows) and number.isEven(layer) and number.isEven(row) then
        navigate.turnRight()
    elseif (number.isOdd(totalRows) or number.isOdd(layer)) and number.isOdd(row) then
        navigate.turnRight()
    else
        navigate.turnLeft()
    end
end

digForward()

local coords = navigate.coords()

for layer = 1, down do
    for row = 1, right do
        for i = 1, forward do
            digForward()
        end

        if row ~= right then
            turn(right, layer, row)
            digForward()
            turn(right, layer, row)
        end
    end

    if layer ~= down then
        turtle.digDown()
        navigate.down()
        navigate.turnAround()
    end
end

if navigate.mode() == navigate.MODES.WORLD_RELATIVE then
    print("Navigating back to start...")
    navigate.goto(coords.x, coords.y, coords.z)
    navigate.goto(startingCoords.x, startingCoords.y, startingCoords.z)
    navigate.face(startingDir)
end

print("Dig operation ended successfully!")
