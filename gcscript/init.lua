-- GrillCheese Script
-- Main entry point

local compiler = require("gcscript.compiler")

local gcscript = {}

-- Compile GrillCheese script to Lua
function gcscript.compile(source)
    return compiler.compile(source)
end

-- Compile from file to file
function gcscript.compileFile(inputPath, outputPath)
    return compiler.compileFile(inputPath, outputPath)
end

-- Load and execute a GCScript module
function gcscript.load(modulePath)
    -- Convert module path to file path
    local filePath = modulePath:gsub("%.", "/") .. ".gcs"
    
    -- Try to find the file in common locations
    local searchPaths = {
        filePath,
        "sprlib/" .. filePath,
        "gcscript/" .. filePath
    }
    
    local foundPath = nil
    for _, path in ipairs(searchPaths) do
        local file = io.open(path, "r")
        if file then
            file:close()
            foundPath = path
            break
        end
    end
    
    if not foundPath then
        error("Could not find GCScript module: " .. modulePath)
    end
    
    -- Read and compile the GCScript source
    local file = io.open(foundPath, "r")
    if not file then
        error("Could not open GCScript module: " .. foundPath)
    end
    local source = file:read("*all")
    file:close()
    
    local luaCode = compiler.compile(source)
    
    -- Create a temporary environment to execute the module
    local moduleEnv = {
        require = function(modName)
            if modName == "sprlib.colors" then
                -- Load the colors module
                local colorsPath = "sprlib/colors.gcs"
                local file = io.open(colorsPath, "r")
                if not file then
                    error("Could not find colors module: " .. colorsPath)
                end
                local source = file:read("*all")
                file:close()
                
                local colorsLua = compiler.compile(source)
                local colorsEnv = {}
                local chunk = load(colorsLua, colorsPath, "t", colorsEnv)
                if not chunk then
                    error("Failed to compile colors module")
                end
                
                local success, result = pcall(chunk)
                if not success then
                    error("Failed to execute colors module: " .. result)
                end
                
                return colorsEnv
            else
                error("Unknown module: " .. modName)
            end
        end,
        print = print,
        error = error,
        tostring = tostring,
        math = math,
        string = string,
        table = table,
        love = love -- luacheck: globals love
    }
    local chunk = load(luaCode, foundPath, "t", moduleEnv)
    if not chunk then
        error("Failed to compile GCScript module: " .. modulePath)
    end
    
    local success, result = pcall(chunk)
    if not success then
        error("Failed to execute GCScript module: " .. result)
    end
    
    return moduleEnv
end

return gcscript
