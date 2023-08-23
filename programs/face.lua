local navigate = require "/libraries/apis/navigate"

local function printUsage()
    print("Usage:")
    print("turn <north|east|south|west>")
end

local tArgs = {...}
if #tArgs < 1 then
    printUsage()
    return
end

if not turtle then
    printError("This command can only be executed on a turtle")
    return
end

local dir = arg[1]

navigate.face(navigate.dehumanizeDirection(dir))
