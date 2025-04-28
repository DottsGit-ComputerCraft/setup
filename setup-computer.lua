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

local function redirectTerm_To_Dummy(term)
    local originalTerm = term.current()
    local dummyTerm = term.current()
    term.redirect(dummyTerm)
    return originalTerm
end

-- Check if directories exist
print("Checking directories...")
local originalTerm = redirectTerm_To_Dummy(term)
if not fs.exists("workspace") then
    shell.run("mkdir workspace")
end
if not fs.exists("workspace/autorun") then
    shell.run("mkdir workspace/autorun")
end
if not fs.exists("workspace/utils") then
    shell.run("mkdir workspace/utils")
end
term.redirect(originalTerm)
write("ok")


print("Checking utils...")
local originalTerm = redirectTerm_To_Dummy(term)
local utilsUrl = "https://raw.githubusercontent.com/DottsGit-ComputerCraft/utils/refs/heads/main/"
local utilsScripts = {
    "lua.lua"
}
local utilsSavePath = "workspace/utils/"
for _, script in ipairs(utilsScripts) do
    downloadFile(utilsUrl .. script, utilsSavePath .. script)
end
term.redirect(originalTerm)
write("ok")

print("Checking startup script...")
local originalTerm = redirectTerm_To_Dummy(term)
local startupUrl = "https://raw.githubusercontent.com/DottsGit-ComputerCraft/autorun/refs/heads/main/startup-computer.lua"
local startupSavePath = "startup.lua" -- Save in the root directory
downloadFile(startupUrl, startupSavePath)
term.redirect(originalTerm)
write("ok")

print("Checking autorun scripts...")
local originalTerm = redirectTerm_To_Dummy(term)
local autorunUrl = "https://raw.githubusercontent.com/DottsGit-ComputerCraft/autorun/refs/heads/main/"
local autorunScripts = {
    "set-custom-aliases.lua"
}
local autorunSavePath = "workspace/autorun/"
for _, script in ipairs(autorunScripts) do
    downloadFile(autorunUrl .. script, autorunSavePath .. script)
end
term.redirect(originalTerm)
write("ok")

-- Remove the setup script from the root directory and put it in the utils folder
if not fs.exists("workspace/autorun/setup-computer.lua") then
    print("Removing setup script...")
    local originalTerm = redirectTerm_To_Dummy(term)
    shell.run("mv setup-computer.lua workspace/autorun/setup-computer.lua")
    term.redirect(originalTerm)
    write("ok")
end

print("Environment setup complete!")
