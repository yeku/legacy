-- Services
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

-- Functions
local Hide = function(Object, Property)
	if not Object or not Property then
		warn(`{Object}.{Property} ({debug.traceback()})`)
	end
	Object[Property] = false
	Object:GetPropertyChangedSignal(Property):Connect(function()
		Object[Property] = false
	end)
end

local Create = function(Class: string, Properties: { [string]: any })
	local Object = Instance.new(Class)
	for Property, Value in next, (Properties or {}) do
		Object[Property] = Value
	end

	return Object
end

local ChangeName = function(Player)
	local Character = Player.Character or Player.CharacterAdded:Wait()
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	if (Humanoid and Humanoid.DisplayName == Player.DisplayName) then
		Humanoid.DisplayName = Player.Name
	else
		Character.ChildAdded:Connect(function(Humanoid)
			if (Humanoid:IsA("Humanoid") and Humanoid.DisplayName == Player.DisplayName) then
				Humanoid.DisplayName = Player.Name
			end
		end)
	end
end

local NameChanger = function(Player)
	task.spawn(ChangeName, Player)
	Player.CharacterAdded:Connect(function()
		task.spawn(ChangeName, Player)
	end)
end

-- Variables
local Developer = (isfile and isfile("yeku.txt")) -- ud (ultra detected)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local RBXM = loadstring(game:HttpGet("https://raw.githubusercontent.com/yeku/forks/refs/heads/main/Scripts/RBXMSuite.luau"))()
local Module = (function()
	local Config = ({
		runscripts = true,
		debug = true
	})

	if (Developer and isfile("Legacy.rbxm")) then
		StarterGui:SetCore("SendNotification", {
			Title = "Legacy",
			Text = "Running dev build",
			Duration = 5,
		})

		return RBXM.launch("Legacy.rbxm", Config)
	end

	local Source = RBXM.download("yeku/Legacy@latest", "Legacy.rbxm")
	return RBXM.launch(Source, Config)
end)()

-- Setup
local Settings = getgenv().LegacySettings or ({
	Year = 2016,
	OldGraphics = true,
	HideDisplayName = true,
	SafeChat = false,
	OldConsole = false,
})

local NewRobloxGui = RBXM.require(Module):Start(Settings.Year, Settings.SafeChat)

RobloxGui.Enabled = false
task.spawn(Hide, CoreGui:WaitForChild("TopBarApp", 10):WaitForChild("TopBarApp", 10), "Enabled")
RobloxGui.NotificationFrame.Parent = NewRobloxGui

if (Settings.OldGraphics) then
	task.spawn(function()
		Lighting.GlobalShadows = false
		for _, Object in next, Lighting:GetChildren() do
			if (table.find({ "DepthOfFieldEffect", "SunRaysEffect", "BloomEffect", "BlurEffect", "ColorCorrectionEffect", "Atmosphere" }, Object.ClassName)) then
				if (not Object:IsA("Atmosphere")) then
					Hide(Object, "Enabled")
				else
					Object:Destroy()
				end
			end
		end

		Create("ColorCorrectionEffect", {
			Parent = Lighting,
			Saturation = 0,
			Contrast = -0.1,
		})

		if (sethiddenproperty) then
			sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
		end
	end)
end

if (Settings.HideDisplayName) then
	for _, Player in next, Players:GetPlayers() do
		NameChanger(Player)
	end

	Players.PlayerAdded:Connect(NameChanger)
end

if (Settings.OldConsole) then
	task.spawn(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yeku/forks/refs/heads/main/Scripts/LegacyConsole.luau"))()
	end)
end

task.spawn(function()
	local SettingsShield = RobloxGui:WaitForChild("SettingsClippingShield"):WaitForChild("SettingsShield")
	local Modal = SettingsShield and SettingsShield:WaitForChild("Modal")
	if (SettingsShield) then
		Hide(Modal, "Visible")
		Hide(Modal, "Modal")
	end
end)

task.spawn(function()
	local ControlFrame = RobloxGui:WaitForChild("ControlFrame", 10)
	if (ControlFrame) then
		ControlFrame:Destroy()
	end
end)
