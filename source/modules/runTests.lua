local TestService = game:GetService("TestService")

local getEnv = require(script.Parent.getEnv)
local ModuleCache = require(script.Parent.ModuleCache)
local generateScriptHeader = require(script.Parent.generateScriptHeader)

return function()
    ModuleCache.clear()

    local scripts = TestService:GetChildren()

    for _, scriptObject in ipairs(scripts) do
        if scriptObject:IsA("Script") then
            local scriptFn = loadstring(generateScriptHeader(scriptObject) .. scriptObject.Source)

            local env = getEnv(scriptObject)
            env.require = ModuleCache.require

            setfenv(scriptFn, env)

            local success, result = pcall(scriptFn)
            if not success then
                local found = string.find(result, "%.%.%.\"]")
                if found then
                    result = string.sub(result, found + 6)
                end
                TestService:Error(string.format("Error running: %s", result), scriptObject)
            end
        end
    end
end
