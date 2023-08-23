local navigate = require "/libraries/apis/navigate"

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

local gpsX, gpsY, gpsZ = gps.locate()

local debug = true
local x = tonumber(arg[1])
local y = #tArgs == 3 and tonumber(arg[2]) or gpsY
local z = #tArgs == 2 and tonumber(arg[2]) or tonumber(arg[3])

navigate.goto(x, y, z)
navigate.face(navigate.DIRECTIONS.NORTH)
