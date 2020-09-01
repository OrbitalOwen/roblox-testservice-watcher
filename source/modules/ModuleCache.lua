local getEnv = require(script.Parent.getEnv)

local cache = {}

local function validateValues(returnValues)
    for key in pairs(returnValues) do
        if key ~= 1 and key ~= 2 then
            return false
        end
    end

    return returnValues[2] and true or false
end

local function accessModule(moduleScript)
    local returnValues = cache[moduleScript]

    local success = returnValues[1]
    local result = returnValues[2]

    assert(success, "Requested module experienced an error while loading")
    assert(validateValues(returnValues), "Module code did not return exactly one value")

    return result
end

local ModuleCache = {}

function ModuleCache.require(moduleScript)
    assert(moduleScript:IsA("ModuleScript"), "Attempted to call require with invalid argument(s).")

    if cache[moduleScript] then
        return accessModule(moduleScript)
    end

    local moduleFn = loadstring(moduleScript.Source)
    local env = getEnv(moduleScript)
    env.require = ModuleCache.require

    setfenv(moduleFn, env)

    local returnValues = {pcall(moduleFn)}

    cache[moduleScript] = returnValues

    return accessModule(moduleScript)
end

function ModuleCache.clear()
    cache = {}
end

return ModuleCache
