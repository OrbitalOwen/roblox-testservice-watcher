local baseEnv = getfenv()

return function(scriptRelativeTo)
    local newEnv = {}

    setmetatable(
        newEnv,
        {
            __index = function(_, key)
                if key ~= "plugin" then
                    return baseEnv[key]
                end
            end
        }
    )

    newEnv.script = scriptRelativeTo

    return newEnv
end
