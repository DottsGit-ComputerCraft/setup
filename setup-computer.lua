-- setup-computer.lua
-- Purpose: Sets up the workspace, downloads necessary files, and runs autorun scripts.

local function createDir(path)
    if not fs.isDir(path) then
        print("Creating directory: " .. path)
        fs.makeDir(path)
        if not fs.isDir(path) then
            printError("ERROR: Failed to create directory: " .. path)
            return false
        end
        print("Successfully created: " .. path)
        return true
    else
        print("Directory already exists: " .. path)
        return true -- Already exists, counts as success for setup purposes
    end
end

local function downloadFile(url, savePath)
    print("Downloading " .. url .. " to " .. savePath .. " ...")
    -- Construct the wget command string. Quotes around URL/path aren't strictly needed
    -- by wget itself unless they contain spaces/special chars, but don't hurt.
    local command = "wget \"" .. url .. "\" \"" .. savePath .. "\""
    local success = shell.run(command)

    if success and fs.exists(savePath) then
        print("Successfully downloaded: " .. savePath)
        return true
    else
        printError("ERROR: Failed to download or save file: " .. savePath)
        if fs.exists(savePath) then
           printError("  (Downloaded file might exist but wget reported failure)")
        end
        return false
    end
end

-- 1. Create Directories
print("\n--- Creating Directories ---")
local dirsCreated = true
dirsCreated = createDir("workspace") and dirsCreated
-- Only attempt to create subdirs if parent was created/existed
if dirsCreated then
    dirsCreated = createDir("workspace/autorun") and dirsCreated
    dirsCreated = createDir("workspace/utils") and dirsCreated
end

if not dirsCreated then
    printError("ERROR: Failed to create one or more base directories. Aborting further setup steps that depend on them.")
    return -- Stop if essential directories couldn't be made
end

-- 2. Download lua.lua using wget
print("\n--- Downloading Utilities ---")
local luaUrl = "https://raw.githubusercontent.com/DottsGit-ComputerCraft/lua-handler/refs/heads/main/lua.lua"
local luaSavePath = "workspace/utils/lua" -- Save directly as 'lua'
downloadFile(luaUrl, luaSavePath)

-- 3. Download startup-computer.lua using wget
print("\n--- Downloading Startup Script ---")
local startupUrl = "https://raw.githubusercontent.com/DottsGit-ComputerCraft/startup/refs/heads/main/startup-computer.lua"
local startupSavePath = "startup.lua" -- Save in the root directory
downloadFile(startupUrl, startupSavePath)

-- 4. Download set-custom-alias.lua using wget
print("\n--- Downloading Aliases Script ---")
local startupUrl = "https://raw.githubusercontent.com/DottsGit-ComputerCraft/startup/refs/heads/main/set-custom-aliases.lua"
local startupSavePath = "workspace/autorun/set-custom-aliases.lua"
downloadFile(startupUrl, startupSavePath)