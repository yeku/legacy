--[[
 ___       _______   ________  ________  ________      ___    ___ 
|\  \     |\  ___ \ |\   ____\|\   __  \|\   ____\    |\  \  /  /|
\ \  \    \ \   __/|\ \  \___|\ \  \|\  \ \  \___|    \ \  \/  / /
 \ \  \    \ \  \_|/_\ \  \  __\ \   __  \ \  \        \ \    / / 
  \ \  \____\ \  \_|\ \ \  \|\  \ \  \ \  \ \  \____    \/   / /  
   \ \_______\ \_______\ \_______\ \__\ \__\ \_______\__/   / /   
    \|_______|\|_______|\|_______|\|__|\|__|\|_______|\____/ /    
                                                     \|____|/     
                                                                  
> github.com/yeku/legacy
>> a ROBLOX coregui changer that lets you use older designs
[!] only supports 2012, 2013, 2014, 2015, 2016
]]

if (not game:IsLoaded()) then
	game.Loaded:Wait()
end

-- Settings
local Developer = (isfile and (isfile("yeku.txt") and isfile("Legacy.rbxm")))
local Environment = (getgenv or function() return _G end)
local Settings = Environment().LegacySettings or ({
    Year = 2012,
    OldGraphics = true,
    HideDisplayName = true,
    SafeChat = true,
    OldConsole = true,
    OldBubbleChat = true,
})

-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local TextChatService = game:GetService("TextChatService")

-- Variables
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ChatBubbles = CoreGui:WaitForChild("ExperienceChat"):WaitForChild("bubbleChat")

-- Types
export type Properties = { [string]: any }

-- Functions
local Force = function(Object: Instance, Property: string, Value: any)
	if (Object[Property] ~= Value) then
		Object[Property] = Value
	end

    Object:GetPropertyChangedSignal(Property):Connect(function()
        if (Object[Property] ~= Value) then
            Object[Property] = Value
        end
    end)
end

local Set = function(Object: Instance, Properties: Properties, Forced: boolean)
	if (not Object) then
		return
    end

    for Property, Value in next, Properties do
    	local Success, Result = pcall(function()
    		Object[Property] = Value

            if (Forced) then
            	Force(Object, Property, Value)
            end
        end)

        if (not Success) then
        	warn(`{Result} | {debug.traceback()}`)
        end
    end
end

local Create = function(ClassName: string, Properties: Properties, Forced: boolean, Parent: Instance?)
	local Object = Instance.new(ClassName)

    if (Parent) then
    	Object.Parent = Parent
    end

    Set(Object, Properties, Forced)

    return Object
end

local Run = function(Bool: boolean, Callback: () -> ())
    if (Bool) then
    	task.spawn(Callback)
    end
end

-- Module
local Suite = Environment().Suite or loadstring(game:HttpGet("https://raw.githubusercontent.com/yeku/forks/refs/heads/main/Scripts/RBXMSuite.luau"))()
local Legacy = (function()
	local Path do
		if (Developer) then
            StarterGui:SetCore("SendNotification", { Title = "Legacy", Text = "Running the developer build", Duration = 5 })
            Path = "Legacy.rbxm"
        else
            local RBXM = Suite.download("yeku/legacy@latest", "Legacy.rbxm")
            Path = RBXM
        end
    end

    return Suite.launch(Path, { runscripts = true, debug = true })
end)()

-- Setup
local LegacyGui = Suite.require(Legacy):Start(Settings.Year, Settings.SafeChat)

RobloxGui.Enabled = false
RobloxGui.NotificationFrame.Parent = LegacyGui

Run(Settings.OldConsole == true, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/yeku/forks/refs/heads/main/Scripts/LegacyConsole.luau"))()
end)

Run(Settings.OldGraphics == true, function()
    if (sethiddenproperty) then
    	task.spawn(sethiddenproperty, Lighting, "Technology", Enum.Technology.Compatibility)
    end

    for _, Hidden in next, Lighting:QueryDescendants("> DepthOfFieldEffect, > SunRaysEffect, > BloomEffect, > BlurEffect, > ColorCorrectionEffect, > Atmosphere") do
    	if (Hidden:IsA("Atmosphere")) then
    		Hidden:Destroy()
        else
        	Force(Hidden, "Enabled", false)
        end
    end

    Create("ColorGradingEffect", { TonemapperPreset = Enum.TonemapperPreset.Retro })
    Create("ColorCorrectionEffect", {
        Saturation = 0,
        Contrast = -0.1,
        Parent = Lighting,
    })
end)

Run(Settings.OldBubbleChat == true, function()
	-- Variables
    local BubbleChatConfiguration = TextChatService:WaitForChild("BubbleChatConfiguration")
    local SourceSans = Font.fromEnum(Enum.Font.SourceSans)
    local Size = UDim2.fromOffset(46, 35)
    local PaddingData = ({ 
        PaddingBottom = UDim.new(0, 4),
	    PaddingTop = UDim.new(0, 4),
	    PaddingLeft = UDim.new(0, 6),
	    PaddingRight = UDim.new(0, 6),
    })

    -- Functions
    local ConvertTail = function(Tail)
        if (Tail) then
        	Set(Tail, {
                Size = UDim2.fromOffset(25, 10),
                ImageTransparency = 0,
                Image = "rbxassetid://89395716827984"
            })
        end
    end

    local ConvertDistantBubble = function(DistantBubble)
        local RoundedFrame = (DistantBubble and DistantBubble:FindFirstChild("RoundedFrame"))
        local Corner = (RoundedFrame and RoundedFrame:FindFirstChildOfClass("UICorner"))
        local Contents = (RoundedFrame and RoundedFrame:FindFirstChild("Contents"))
        local Padding = (Contents and Contents:FindFirstChildOfClass("UIPadding"))
        local Ellipsis = (Contents and Contents:FindFirstChildOfClass("TextLabel"))

        ConvertTail(DistantBubble:FindFirstChild("Carat"))
        Set(DistantBubble, { Size = Size }, true)
        Set(RoundedFrame, { Size = Size }, true)
        Set(Contents, { Size = Size }, true)
        Set(Corner, { CornerRadius = UDim.new(0, 5) })
        Set(Padding, PaddingData)
        Set(Ellipsis, {
            FontFace = SourceSans,
            TextSize = 22,
            TextColor3 = Color3.fromRGB(60, 68, 75),
            TextTransparency = 0,
        }, true)
    end

    local Convert = function(Object: Instance)
    	if (Object.Name == "Caret") then
            ConvertTail(Object)
        elseif (Object.Name == "DistantBubble") then
            ConvertDistantBubble(Object)
        end
    end

    -- Setup
    Set(BubbleChatConfiguration, {
        FontFace = SourceSans,
        TextSize = 22,
        TextColor3 = Color3.fromRGB(60, 68, 75),
        BackgroundTransparency = 0,
        LocalPlayerStudsOffset = Vector3.new(0, 0.4, 0),
    }, true)

    Create("UICorner", { Parent = BubbleChatConfiguration, CornerRadius = UDim.new(0, 5) })
    Create("UIPadding", PaddingData, false, BubbleChatConfiguration)

    for _, Object in next, ChatBubbles:QueryDescendants(`#Caret, #DistantBubble`) do
     	Convert(Object)
    end

    ChatBubbles.DescendantAdded:Connect(Convert)
end)

Run(Settings.HideDisplayName, function()
    -- Functions
    local Change = function(Player)
    	local Character = (Player.Character or Player.CharacterAdded:Wait())
        local Humanoid = (Character and Character:FindFirstChildOfClass("Humanoid"))

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

    local Joined = function(Player)
    	Change(Player)
        Player.CharacterAdded:Connect(function()
        	Change(Player)
        end)
    end

    -- Setup
    for _, Player in next, Players:GetPlayers() do
        task.spawn(Joined, Player)
    end

    Players.PlayerAdded:Connect(Joined)
end)

task.spawn(function()
    local TopBarApp = CoreGui:WaitForChild("TopBarApp", 10):WaitForChild("TopBarApp", 10)
    Force(TopBarApp, "Enabled", false)
end)

task.spawn(function()
	local SettingsShield = RobloxGui:WaitForChild("SettingsClippingShield"):WaitForChild("SettingsShield")
	local Modal = (SettingsShield and SettingsShield:WaitForChild("Modal"))

	if (Modal) then
        Set(Modal, {
            Visible = false,
            Modal = false,
        }, true)
	end
end)

task.spawn(function()
	local ControlFrame = RobloxGui:WaitForChild("ControlFrame", 10)

	if (ControlFrame) then
		ControlFrame:Destroy()
	end
end)
