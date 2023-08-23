local number = {}

function number.isEven(value)
    return value % 2 == 0
end

function number.isOdd(value)
    return value % 2 == 1
end

return number