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


return gcscript
