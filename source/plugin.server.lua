local TestService = game:GetService("TestService")
local RunService = game:GetService("RunService")

local updateDirectories = require(script.Parent.modules.updateDirectories)
local Watcher = require(script.Parent.modules.Watcher)

local DIRECTORIES_MODULE_NAME = "__WatcherDirectories"

local isEnabled = false
local connection1, connection2

if RunService:IsRunning() or not RunService:IsEdit() then
	return
end

local function lookForDirectoriesModule()
	local directoriesModule = TestService:FindFirstChild(DIRECTORIES_MODULE_NAME)

	if directoriesModule then
		updateDirectories(directoriesModule)
	end
end

local function enable()
	if not isEnabled then
		connection1 = TestService.ChildAdded:Connect(function(child)
			if child.Name == DIRECTORIES_MODULE_NAME then
				updateDirectories(child)
			end
		end)

		connection2 = TestService.ChildRemoved:Connect(function(child)
			if child.Name == DIRECTORIES_MODULE_NAME then
				Watcher.removeAll()
				lookForDirectoriesModule()
			end
		end)

		lookForDirectoriesModule()

		isEnabled = true
	end
end

local function disable()
	if isEnabled then
		connection1:Disconnect()
		connection2:Disconnect()

		Watcher.removeAll()

		isEnabled = false
	end
end

local function setupButton()
	local toolbar = plugin:CreateToolbar("TestService Watcher")
	local button = toolbar:CreateButton("Enable Watcher", "Enable TestService Watcher", "")
	button.ClickableWhenViewportHidden = true
	button:SetActive(isEnabled)

	button.Click:Connect(function()
		if isEnabled then
			disable()
		else
			enable()
		end

		button:SetActive(isEnabled)
	end)
end

enable()
setupButton()
