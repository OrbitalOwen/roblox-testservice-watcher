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

    local realDebug = debug

    newEnv.debug =
        setmetatable(
        {
            traceback = function(message)
                -- Block traces to prevent overly verbose TestEZ output
                return message or ""
            end
        },
        {__index = realDebug}
    )

    return newEnv
end
