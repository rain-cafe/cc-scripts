require "/libraries/apis/turtle"

if turtle.auto.refuel() then
    print("Refueled!")
else
    print("Unable to refuel... :<")
end
