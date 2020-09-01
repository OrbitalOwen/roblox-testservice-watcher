local TestService = game:GetService("TestService")

local getEnv = require(script.Parent.getEnv)
local ModuleCache = require(script.Parent.ModuleCache)

return function()
    ModuleCache.clear()

    local scripts = TestService:GetChildren()

    for _, scriptObject in ipairs(scripts) do
        local scriptFn = loadstring(scriptObject.Source)

        local env = getEnv(scriptObject)
        env.require = ModuleCache.require

        setfenv(scriptFn, env)

        local success, result = pcall(scriptFn)
        if not success then
            error(string.format("Error running TestService Script %s: %s", scriptObject:GetFullName(), result))
        end
    end
end
