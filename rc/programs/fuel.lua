local betterTurtle = require "/rc.apis.better-turtle"

if betterTurtle.auto.refuel() then
    print("Refueled!")
else
    print("Unable to refuel... :<")
end
