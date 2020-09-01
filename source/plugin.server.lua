local TestService = game:GetService("TestService")

local updateDirectories = require(script.Parent.modules.updateDirectories)

local DIRECTORIES_MODULE_NAME = "__WatcherDirectories"

local directoriesModule = TestService:FindFirstChild(DIRECTORIES_MODULE_NAME)

if directoriesModule then
    updateDirectories(directoriesModule)
end

TestService.ChildAdded:Connect(
    function(child)
        if child.Name == DIRECTORIES_MODULE_NAME then
            updateDirectories(child)
        end
    end
)
