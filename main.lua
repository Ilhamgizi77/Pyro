repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local InfiniteJumpEnabled = false
local JumpConnection = nil -- Variabel untuk menyimpan koneksi event
local plr = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")

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
local function rj()
	local tpService = game:GetService("TeleportService")
	local player = game.Players.LocalPlayer
	local placeId = game.PlaceId
	local jobId = game.JobId
	if player then
		tpService:TeleportToPlaceInstance(placeId, jobId, player)
	end
end
local function hopserver()
	local serv = game["Teleport Service"]
	if plr then
		serv:TeleportToPlaceInstance(game.PlaceId, plr)
	end
end

local Window = Fluent:CreateWindow({
	Title = "Pyro Hub   " .. Fluent.Version,
	SubTitle = "by dzkkkr",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = plr.PlayerGui
screenGui.ResetOnSpawn = false
local PYROLOGO = Instance.new("ImageLabel")
PYROLOGO.Parent = screenGui
PYROLOGO.Size = UDim2.fromOffset(75, 75)
PYROLOGO.Position = UDim2.new(0.031, 0,0.225, 0)
PYROLOGO.Image = ""
local textbut = Instance.new("TextButton")
textbut.Parent = PYROLOGO
textbut.Size = UDim2.new(1,0,1,0)
textbut.Transparency = 1
textbut.Text = ""

textbut.MouseButton1Click:Connect(function()
	Window.Parent.Visible = not Window.Parent.Visible
end)

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
	LocalPlayer = Window:AddTab({ Title = "LocalPlayer", Icon = "align-justify" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
	Tabs.LocalPlayer:AddParagraph({
		Title = "LocalPlayer",
		Content = "You can change speed or smth else in this tab"
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
	
	Tabs.LocalPlayer:AddButton("IY", {
		Title = "Load Infinite Yield",
		Description = "Load Infinite Yield Admin Commands!",
		Callback = function()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
		end
	})
	
	
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

