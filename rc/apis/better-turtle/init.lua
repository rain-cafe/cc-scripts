if not turtle then
    printError("[better-turtle]: The 'better-turtle' api is only usable by turtles!")
end

return {
    slots = require "/rc.apis.better-turtle.slots",
    navigate = require "/rc.apis.better-turtle.navigate",
    auto = require "/rc.apis.better-turtle.auto",
    dig = require "/rc.apis.better-turtle.dig"
}
