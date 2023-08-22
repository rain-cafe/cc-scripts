local function printUsage()
    print("Usage:")
    print("dig <forward> <right> <down>")
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
local right = tonumber(arg[2])
local down = tonumber(arg[3]) or 1

print("Forward:", forward, "Right:", right, "Down", down)

local function turn(i)
    if i % 2 == 1 then
        turtle.turnRight()
    else
        turtle.turnLeft()
    end
end

local function digAndMove()
    turtle.dig()
    turtle.forward()
end

local function digLayer(x, y, iz)
    for iy = 1, y do
        print(y, iy)
        for ix = 1, x do
            print(ix, iy)
            digAndMove()
        end

        -- Move down a row and face the other direction
        if iy < y then
            turn(iy + iz)
            digAndMove()
            turn(iy + iz)
        end
    end
end

local function digLayers(x, y, z)
    for iz = 1, z do
        print("Digging Layer:", iz)

        digLayer(x, y, iz)

        if iz < z then
            turtle.digDown()
            turtle.down()
            turtle.turnLeft()
            turtle.turnLeft()
        end
    end
end

print("Dig operation started...")

digAndMove()

print(right)

digLayers(forward, right, down)

print("Dig operation ended successfully!")

-- for iz = 1, z do
--   for iy = 1, y do
--     for ix = 1, x do
--       output(ix, iy, iz)
--       digAndMove()
--     end

--     -- Move down a row and face the other direction
--     if iy ~= y then
--       turn(iy)
--       digAndMove()
--       turn(iy)
--     end
--   end

--   --
--   if iz ~= z then
--     turtle.digDown()
--     turtle.down()
--     turtle.turnLeft()
--     turtle.turnLeft()
--   end
-- end
