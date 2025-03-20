local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer.PlayerGui
local but = Instance.new("ImageButton")
but.Parent = screenGui
but.Size = UDim2.fromOffset(100, 100)
but.MouseButton1Click:Connect(pressLeftCtrl)
local UIS = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local frame =but-- Ganti ini dengan objek UI yang mau di-drag

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local InfiniteJumpEnabled = false
local JumpConnection = nil -- Variabel untuk menyimpan koneksi event
local plr = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:FindFirstChild("CoreGui") or game:GetService("CoreGui")
local teleportLocations = {
	Moosewod = Vector3.new(391, 135, 249),
	Roslit = Vector3.new(-1470, 133, 700),
	Forsaken = Vector3.new(-2483, 133, 1562),
	GrandReef = Vector3.new(-3576, 151, 522),
	["Atlantean Storm"] = Vector3.new(-3642, 131, 773),
	Spike = Vector3.new(-1281, 140, 1526),
	Therapin = Vector3.new(-175, 143, 1924),
	Ancient = Vector3.new(6058, 196, 303),
	Mushgrove = Vector3.new(2498, 134, -773),
	Arch = Vector3.new(1007, 135, -1254),
	Enchant = Vector3.new(1310, -802, -83),
	Atlantis = Vector3.new(-4259, -603, 1813),
	["Zeus Room"] = Vector3.new(-4309, -619, 2674),
	["Kraken Pool"] = Vector3.new(-4396, -995, 2046),
	["Poseidon Trial"] = Vector3.new(-3832, -545, 1025),
	["Poseidon Room"] = Vector3.new(-4033, -558, 907),
	["Ethereal Abyss Room"] = Vector3.new(-3798, -564, 1838),
	Snowcap = Vector3.new(2625, 143, 2466),
	["Snowcap Upper"] = Vector3.new(2815, 280, 2558),
	["Snowcap Cave"] = Vector3.new(2806, 136, 2732),
	["Sunken Pool"] = Vector3.new(-4996, -581, 1847),
	["Sunken Trial"] = Vector3.new(-4625, -598, 1844),
	["Kraken Door"] = Vector3.new(-4389, -984, 1808),
	["Podium 1"] = Vector3.new(-3405, -2263, 3825),
	["Podium 2"] = Vector3.new(-768, -3283, -688),
	["Podium 3"] = Vector3.new(-13538, -11050, 129)
}
function pressLeftCtrl()
	UserInputService.InputBegan:Fire(Enum.KeyCode.LeftControl, false)
end
local function teleportToLocation(locationName)
	if plr and plr.Character then
		local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
		if hrp and teleportLocations[locationName] then
			hrp.CFrame = CFrame.new(teleportLocations[locationName])
		end
	end
end



local function setSpeed(speed)
	local player = game.Players.LocalPlayer
	if player and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = speed
		print("Speed changed to:", speed)
	else
		warn("Player or Humanoid not found!")
	end
end


local function ToggleInfiniteJump(Player)
	InfiniteJumpEnabled = not InfiniteJumpEnabled
	print("Infinite Jump:", InfiniteJumpEnabled and "Aktif" or "Nonaktif")

	if InfiniteJumpEnabled then
		-- Aktifkan Infinite Jump
		JumpConnection = UserInputService.JumpRequest:Connect(function()
			local Character = Player.Character or Player.CharacterAdded:Wait()
			local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
			if Humanoid then
				Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	else
		-- Nonaktifkan Infinite Jump
		if JumpConnection then
			JumpConnection:Disconnect()
			JumpConnection = nil
		end
	end
end
local function hopserver()
	local serv = game:GetService("TeleportService")
	if plr then
		serv:TeleportToPlaceInstance(game.PlaceId, plr)
	end
end
local function rj()
	local tpService = game:GetService("TeleportService")
	local player = game.Players.LocalPlayer
	local placeId = game.PlaceId
	local jobId = game.JobId
	if player then
		tpService:TeleportToPlaceInstance(placeId, jobId, player)
	end
end


local Window = Fluent:CreateWindow({
	Title = "Pyro Hub " .. Fluent.Version,
	SubTitle = "by dzkkkr",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})


--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
	LocalPlayer = Window:AddTab({ Title = "LocalPlayer", Icon = "align-justify" }),
	Main = Window:AddTab({ Title = "Main", Icon = "house" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
	Fluent:Notify({
		Title = "Notification",
		Content = "Thanks For trying this script!",
		Duration = 5 -- Set to nil to make the notification not disappear
	})



	Tabs.LocalPlayer:AddParagraph({
		Title = "LocalPlayer",
		Content = "You can change speed or smth else in this tab"
	})

	local Dropdown = Tabs.LocalPlayer:AddDropdown("Dropdown", {
		Title = "Teleport to...",
		Description = "Select a location to teleport",
		Values = table.keys(teleportLocations), -- Menggunakan nama lokasi sebagai opsi dropdown
		Multi = false,
		Default = 1,
		Callback = function(selected)
			teleportToLocation(selected) -- Panggil fungsi teleportasi
		end
	})

	Tabs.LocalPlayer:AddButton({
		Title = "Rejoin",
		Description = "Rejoin The Game",
		Callback = function()
			Window:Dialog({
				Title = "Rejoin",
				Content = "Are You Sure Want To Rejoin?",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							print("Confirmed the dialog.")
							wait()
							rj()
						end
					},
					{
						Title = "Cancel",
						Callback = function()
							print("Cancelled the dialog.")
						end
					}
				}
			})
		end
	})
	Tabs.LocalPlayer:AddButton({
		Title = "Load Infinite Yield",
		Description = "Load Infinite Yield Admin Commands!",
		Callback = function()
			Window:Dialog({
				Title = "Load IY",
				Content = "Load The Infinite Yield",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
						end
					},
					{
						Title = "Cancel",
						Callback = function()
							return print("Cancelled the dialog.")
						end
					}
				}
			})

		end
	})

	Tabs.LocalPlayer:AddButton({
		Title = "Hop Server",
		Description = "Hop To Random Server",
		Callback = function()
			Window:Dialog({
				Title = "Hop Server",
				Content = "Are You Sure Want To Continue?",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							print("Confirmed the dialog.")
							wait()
							hopserver()
						end
					},
					{
						Title = "Cancel",
						Callback = function()
							print("Cancelled the dialog.")
						end
					}
				}
			})
		end
	})

	local Toggle = Tabs.LocalPlayer:AddToggle("MyToggle", {Title = "Infinite Jump", Default = false })

	Toggle:OnChanged(function()
		print("Toggle changed:", Options.MyToggle.Value)
		if Options.MyToggle.Value == false  then
			ToggleInfiniteJump(plr)
		end
		if Options.MyToggle.Value == true then
			ToggleInfiniteJump(plr)
		end
	end)

	Options.MyToggle:SetValue(false)

	local function setSpeed(speed)
		local player = game.Players.LocalPlayer
		if player and player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.WalkSpeed = speed
			print("Speed changed to:", speed)
		else
			warn("Player or Humanoid not found!")
		end
	end

	-- Input Box untuk memasukkan angka kecepatan
	local Input = Tabs.LocalPlayer:AddInput("SpeedInput", {
		Title = "Speed Changer",
		Default = "16",
		Placeholder = "Enter Speed",
		Numeric = true,
		Finished = true,
		Callback = function(Value)
			if Options.SpeedToggle.Value then
				local speed = tonumber(Value) or 16
				setSpeed(speed)
			end
		end
	})


	-- Toggle untuk mengaktifkan/mematikan speed changer
	local Toggle = Tabs.LocalPlayer:AddToggle("SpeedToggle", {
		Title = "Change Speed",
		Default = false,
		Callback = function(state)
			if state then
				local speed = tonumber(Options.SpeedInput.Value) or 16
				setSpeed(speed)
			else
				setSpeed(16) -- Reset ke default speed
			end
		end
	})

	Options.SpeedToggle:SetValue(false)

end


-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
	Title = "Fluent",
	Content = "The script has been loaded.",
	Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()