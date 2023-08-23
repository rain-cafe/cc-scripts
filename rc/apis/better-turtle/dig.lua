local navigate = require "/rc.apis.better-turtle.navigate"

local api = {}

function api.forward(stay)
    local brokeBlock = turtle.dig()

    if stay ~= true then
        navigate.forward()
    end

    return brokeBlock
end

function api.down(stay)
    local brokeBlock = turtle.digDown()

    if stay ~= true then
        navigate.down()
    end

    return brokeBlock
end

return api
