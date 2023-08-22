fs.makeDir("./rain-scripts")

local function download(fileName)
    fs.delete("./rain-scripts/"..fileName)
    shell.run("wget", "https://raw.githubusercontent.com/rain-cafe/cc-scripts/main/"..fileName, "./rain-scripts/"..fileName)
end

local function alias(alias, fileName)
    shell.run("alias", alias, "./rain-scripts/"..fileName)
end

download("download.lua")
alias("pull", "download.lua")
download("dig.lua")