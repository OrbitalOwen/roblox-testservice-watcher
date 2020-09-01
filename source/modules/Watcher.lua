local runTests = require(script.Parent.runTests)

local connections = {}

local Watcher = {}

function Watcher.addInstance(instance)
    if connections[instance] then
        return
    end

    local sourceConnection, childAddedConnection, removedConnection

    if instance:IsA("LuaSourceContainer") then
        local sourceEvent = instance:GetPropertyChangedSignal("Source")

        sourceConnection =
            sourceEvent:Connect(
            function()
                runTests()
            end
        )
    end

    local children = instance:GetChildren()
    for _, child in ipairs(children) do
        Watcher.addInstance(child)
    end

    childAddedConnection = instance.ChildAdded:Connect(Watcher.addInstance)

    removedConnection =
        instance.AncestryChanged:Connect(
        function(_, newParent)
            if not newParent then
                Watcher.removeInstance(instance)
            end
        end
    )

    connections[instance] = {
        sourceConnection,
        childAddedConnection,
        removedConnection
    }

    runTests()
end

function Watcher.removeInstance(instance)
    local instanceConnections = connections[instance]

    for _, connection in pairs(instanceConnections) do
        connection:Disconnect()
    end

    connections[instance] = nil
end

function Watcher.removeAll()
    for instance in pairs(connections) do
        Watcher.removeInstance(instance)
    end

    connections = {}
end

return Watcher
