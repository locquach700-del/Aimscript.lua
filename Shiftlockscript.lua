-- CUSTOM SHIFT LOCK WITH UI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local shiftLock = false
local connection

-- ===== TẠO UI =====
local gui = Instance.new("ScreenGui")
gui.Name = "ShiftLockGui"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 100, 0, 40)
button.Position = UDim2.new(0.85, 0, 0.7, 0)
button.Text = "Shift Lock: OFF"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(40,40,40)
button.TextColor3 = Color3.new(1,1,1)
button.Parent = gui

local corner = Instance.new("UICorner", button)
corner.CornerRadius = UDim.new(0, 10)

-- ===== BẬT SHIFT LOCK =====
local function EnableShiftLock()
	local char = player.Character
	if not char then return end
	local humanoid = char:WaitForChild("Humanoid")
	local root = char:WaitForChild("HumanoidRootPart")

	humanoid.AutoRotate = false

	connection = RunService.RenderStepped:Connect(function()
		local _, y, _ = camera.CFrame:ToEulerAnglesYXZ()
		root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, y, 0)
	end)
end

-- ===== TẮT SHIFT LOCK =====
local function DisableShiftLock()
	local char = player.Character
	if not char then return end
	local humanoid = char:WaitForChild("Humanoid")

	humanoid.AutoRotate = true

	if connection then
		connection:Disconnect()
		connection = nil
	end
end

-- ===== CLICK UI =====
button.MouseButton1Click:Connect(function()
	shiftLock = not shiftLock
	
	if shiftLock then
		button.Text = "Shift Lock: ON"
		button.BackgroundColor3 = Color3.fromRGB(150,0,0)
		EnableShiftLock()
	else
		button.Text = "Shift Lock: OFF"
		button.BackgroundColor3 = Color3.fromRGB(40,40,40)
		DisableShiftLock()
	end
end)

-- ===== PC NHẤN SHIFT CŨNG DÙNG ĐƯỢC =====
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	
	if input.KeyCode == Enum.KeyCode.LeftShift then
		button:Activate()
	end
end)
