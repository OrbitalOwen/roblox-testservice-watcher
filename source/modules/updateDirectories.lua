local Watcher = require(script.Parent.Watcher)
local runTests = require(script.Parent.runTests)

local connection

local function updateDirectories(directoriesModule)
    local directories = loadstring(directoriesModule.Source)()

    Watcher.removeAll()

    for _, instance in ipairs(directories) do
        Watcher.addInstance(instance)
    end

    local sourceEvent = directoriesModule:GetPropertyChangedSignal("Source")

    if connection then
        connection:Disconnect()
    end

    connection =
        sourceEvent:Connect(
        function()
            updateDirectories(directoriesModule)
        end
    )
end

return updateDirectories
