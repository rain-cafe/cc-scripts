fs.makeDir("./libraries/apis")
fs.makeDir("./libraries/utils")
fs.makeDir("./libraries/programs")

local function download(fileName)
    fs.delete("./rain-scripts/" .. fileName)
    shell.run("wget", "https://raw.githubusercontent.com/rain-cafe/cc-scripts/main/" .. fileName,
        "./rain-scripts/" .. fileName)
end

local function alias(alias, fileName)
    shell.run("alias", alias, "./rain-scripts/" .. fileName)
end

download("startup.lua")

-- Download utils
download("libraries/utils/number.lua")
download("libraries/utils/table.lua")
download("libraries/utils/turn.lua")

-- Download APIs
download("libraries/apis/navigate.lua")

-- Download Programs
download("programs/face.lua")
download("programs/goto.lua")
download("programs/dig.lua")
