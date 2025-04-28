-- setup-computer.lua
-- Purpose: Sets up the workspace and downloads necessary files.

local function downloadFile(url, savePath)
    -- Construct the wget command string. Quotes around URL/path aren't strictly needed
    -- by wget itself unless they contain spaces/special chars, but don't hurt.
    local command = "wget \"" .. url .. "\" \"" .. savePath .. "\""
    local success = shell.run(command)

    if success and fs.exists(savePath) then
        --print("Successfully downloaded: " .. savePath)
        return true
    else
        --printError("ERROR: Failed to download or save file: " .. savePath)
        --if fs.exists(savePath) then
        --    printError("  (Downloaded file might exist but wget reported failure)")
        --end
        return false
    end
end

-- Check if directories exist
print("Checking directories...")
if not fs.exists("workspace") then
    -- 1. Create Directories
    shell.run("mkdir workspace")
end
if not fs.exists("workspace/autorun") then
    shell.run("mkdir workspace/autorun")
end
if not fs.exists("workspace/utils") then
    shell.run("mkdir workspace/utils")
end
write("ok")

print("Checking utils...")
local utilsUrl = "https://raw.githubusercontent.com/DottsGit-ComputerCraft/utils/refs/heads/main/"
local utilsScripts = {
    "lua.lua"
}
local utilsSavePath = "workspace/utils/"
for _, script in ipairs(utilsScripts) do
    downloadFile(utilsUrl .. script, utilsSavePath .. script)
end
write("ok")

print("Checking startup script...")
local startupUrl = "https://raw.githubusercontent.com/DottsGit-ComputerCraft/autorun/refs/heads/main/startup-computer.lua"
local startupSavePath = "startup.lua" -- Save in the root directory
downloadFile(startupUrl, startupSavePath)
write("ok")

print("Checking autorun scripts...")
local autorunUrl = "https://raw.githubusercontent.com/DottsGit-ComputerCraft/autorun/refs/heads/main/"
local autorunScripts = {
    "set-custom-aliases.lua"
}
local autorunSavePath = "workspace/autorun/"
for _, script in ipairs(autorunScripts) do
    downloadFile(autorunUrl .. script, autorunSavePath .. script)
end
write("ok")

-- Remove the setup script from the root directory and put it in the utils folder
if not fs.exists("workspace/autorun/setup-computer.lua") then
    print("Removing setup script...")
    shell.run("mv setup-computer.lua workspace/autorun/setup-computer.lua")
    write("ok")
end

print("Environment setup complete!")
