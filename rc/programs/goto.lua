local betterTurtle = require "/rc.apis.better-turtle"

local function printUsage()
    print("Usage:")
    print("goto <x> [y] <z>")
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

local _, gpsY, _ = betterTurtle.navigate.coords()

local x = tonumber(arg[1])
local y = #tArgs == 3 and tonumber(arg[2]) or gpsY
local z = #tArgs == 2 and tonumber(arg[2]) or tonumber(arg[3])

print("Navigating to:", x, y, z)

betterTurtle.navigate.go(x, y, z)
betterTurtle.navigate.face(betterTurtle.navigate.DIRECTIONS.NORTH)
