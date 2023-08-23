local betterTurtle = require "/rc.apis.better-turtle"

local function printUsage()
    print("Usage:")
    print("turn <north|east|south|west>")
end

local tArgs = {...}
if #tArgs < 1 then
    printUsage()
    return
end

local dir = arg[1]

betterTurtle.navigate.face(betterTurtle.navigate.dehumanizeDirection(dir))
