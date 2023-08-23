local betterTurtle = require "/rc.apis.better-turtle"
local number = require "/rc.utils.number"

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

local forward = tonumber(arg[1]) - 1
local down = #tArgs == 3 and tonumber(arg[2]) or 1
local right = #tArgs == 2 and tonumber(arg[2]) or tonumber(arg[3])

print("Dig operation started...")

local startingX, startingY, startingZ = betterTurtle.navigate.coords()
local startingDir = betterTurtle.navigate.direction()

local function turn(totalRows, layer, row)
    -- TODO: How can we simplify this into an equation?
    if number.isEven(totalRows) and number.isEven(layer) and number.isEven(row) then
        betterTurtle.navigate.turnRight()
    elseif (number.isOdd(totalRows) or number.isOdd(layer)) and number.isOdd(row) then
        betterTurtle.navigate.turnRight()
    else
        betterTurtle.navigate.turnLeft()
    end
end

betterTurtle.dig.forward()

local x, y, z = betterTurtle.navigate.coords()

for layer = 1, down do
    for row = 1, right do
        for _ = 1, forward do
            betterTurtle.dig.forward()
        end

        if row ~= right then
            turn(right, layer, row)
            betterTurtle.dig.forward()
            turn(right, layer, row)
        end
    end

    if layer ~= down then
        betterTurtle.dig.down()
        betterTurtle.navigate.turnAround()
    end
end

print("Navigating back to start...")
betterTurtle.navigate.go(x, y, z)
betterTurtle.navigate.go(startingX, startingY, startingZ)
betterTurtle.navigate.face(startingDir)

print("Dig operation ended successfully!")
