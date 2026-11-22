-- StarterPlayer/StarterPlayerScripts/Client/DialogueUIController.luau
--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local TutorialDialogue = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("TutorialDialogue"))

type DialogueLine = TutorialDialogue.DialogueLine

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local DialogueUIController = {}

-- State
local isConsole = false
local currentQueueId = 0
local activeLine: DialogueLine? = nil

-- UI References
local screenGui: ScreenGui
local subtitleContainer: Frame
local speakerLabel: TextLabel
local mainTextLabel: TextLabel
local translationLabel: TextLabel
local promptBadge: Frame
local promptLabel: TextLabel
local voiceSound: Sound

local function updateInputDevice(inputType: Enum.UserInputType)
	if inputType == Enum.UserInputType.Gamepad1
		or inputType == Enum.UserInputType.Gamepad2
		or inputType == Enum.UserInputType.Gamepad3
		or inputType == Enum.UserInputType.Gamepad4
	then
		isConsole = true
	elseif inputType == Enum.UserInputType.Keyboard
		or inputType == Enum.UserInputType.MouseButton1
		or inputType == Enum.UserInputType.MouseMovement
	then
		isConsole = false
	end

	-- Live-refresh active keybind prompt if player switches between KBM and Controller
	if activeLine and promptBadge and promptLabel then
		local promptText = if isConsole then activeLine.PromptConsole else activeLine.PromptPC
		if promptText and promptText ~= "" then
			promptLabel.Text = promptText
			promptBadge.Visible = true
		else
			promptBadge.Visible = false
		end
	end
end

local function buildUI()
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "BlacksiteDialogueHUD"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 10
	screenGui.Parent = PlayerGui

	-- Bottom-center tactical subtitle stack
	subtitleContainer = Instance.new("Frame")
	subtitleContainer.Name = "SubtitleContainer"
	subtitleContainer.AnchorPoint = Vector2.new(0.5, 1)
	subtitleContainer.Position = UDim2.new(0.5, 0, 0.91, 0)
	subtitleContainer.Size = UDim2.new(0.62, 0, 0, 120)
	subtitleContainer.BackgroundTransparency = 1
	subtitleContainer.Parent = screenGui

	local layout = Instance.new("UIListLayout")
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 6)
	layout.Parent = subtitleContainer

	-- Dynamic Keybind Prompt Pill (e.g., "PRESS [F] TO LOOT" / "PRESS [X] TO LOOT")
	promptBadge = Instance.new("Frame")
	promptBadge.Name = "PromptBadge"
	promptBadge.AutomaticSize = Enum.AutomaticSize.XY
	promptBadge.BackgroundColor3 = Color3.fromRGB(14, 16, 20)
	promptBadge.BackgroundTransparency = 0.2
	promptBadge.BorderSizePixel = 0
	promptBadge.Visible = false
	promptBadge.LayoutOrder = 1
	promptBadge.Parent = subtitleContainer

	local badgeStroke = Instance.new("UIStroke")
	badgeStroke.Color = Color3.fromRGB(255, 195, 115)
	badgeStroke.Thickness = 1.2
	badgeStroke.Transparency = 0.35
	badgeStroke.Parent = promptBadge

	local badgePadding = Instance.new("UIPadding")
	badgePadding.PaddingTop = UDim.new(0, 5)
	badgePadding.PaddingBottom = UDim.new(0, 5)
	badgePadding.PaddingLeft = UDim.new(0, 14)
	badgePadding.PaddingRight = UDim.new(0, 14)
	badgePadding.Parent = promptBadge

	promptLabel = Instance.new("TextLabel")
	promptLabel.Name = "PromptText"
	promptLabel.AutomaticSize = Enum.AutomaticSize.XY
	promptLabel.BackgroundTransparency = 1
	promptLabel.Font = Enum.Font.RobotoMono
	promptLabel.TextSize = 15
	promptLabel.TextColor3 = Color3.fromRGB(255, 225, 170)
	promptLabel.Text = ""
	promptLabel.Parent = promptBadge

	-- Subtitle Backing Box
	local textBox = Instance.new("Frame")
	textBox.Name = "TextBox"
	textBox.AutomaticSize = Enum.AutomaticSize.XY
	textBox.BackgroundColor3 = Color3.fromRGB(10, 12, 15)
	textBox.BackgroundTransparency = 0.35
	textBox.BorderSizePixel = 0
	textBox.LayoutOrder = 2
	textBox.Parent = subtitleContainer

	local boxPadding = Instance.new("UIPadding")
	boxPadding.PaddingTop = UDim.new(0, 8)
	boxPadding.PaddingBottom = UDim.new(0, 8)
	boxPadding.PaddingLeft = UDim.new(0, 18)
	boxPadding.PaddingRight = UDim.new(0, 18)
	boxPadding.Parent = textBox

	local boxLayout = Instance.new("UIListLayout")
	boxLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	boxLayout.SortOrder = Enum.SortOrder.LayoutOrder
	boxLayout.Padding = UDim.new(0, 3)
	boxLayout.Parent = textBox

	-- Speaker Callsign
	speakerLabel = Instance.new("TextLabel")
	speakerLabel.Name = "Speaker"
	speakerLabel.AutomaticSize = Enum.AutomaticSize.XY
	speakerLabel.BackgroundTransparency = 1
	speakerLabel.Font = Enum.Font.RobotoMono
	speakerLabel.TextSize = 14
	speakerLabel.TextStrokeTransparency = 0.5
	speakerLabel.Text = ""
	speakerLabel.LayoutOrder = 1
	speakerLabel.Parent = textBox

	-- Primary Spoken Line
	mainTextLabel = Instance.new("TextLabel")
	mainTextLabel.Name = "MainText"
	mainTextLabel.AutomaticSize = Enum.AutomaticSize.XY
	mainTextLabel.BackgroundTransparency = 1
	mainTextLabel.Font = Enum.Font.GothamMedium
	mainTextLabel.TextSize = 19
	mainTextLabel.TextColor3 = Color3.fromRGB(245, 247, 250)
	mainTextLabel.TextStrokeTransparency = 0.45
	mainTextLabel.TextWrapped = true
	mainTextLabel.Size = UDim2.new(0, 760, 0, 0)
	mainTextLabel.Text = ""
	mainTextLabel.LayoutOrder = 2
	mainTextLabel.Parent = textBox

	-- English Translation Line (Visible only when Swedish is spoken)
	translationLabel = Instance.new("TextLabel")
	translationLabel.Name = "TranslationText"
	translationLabel.AutomaticSize = Enum.AutomaticSize.XY
	translationLabel.BackgroundTransparency = 1
	translationLabel.Font = Enum.Font.Gotham
	translationLabel.TextSize = 15
	translationLabel.TextColor3 = Color3.fromRGB(175, 185, 200)
	translationLabel.TextStrokeTransparency = 0.5
	translationLabel.TextWrapped = true
	translationLabel.Visible = false
	translationLabel.Text = ""
	translationLabel.LayoutOrder = 3
	translationLabel.Parent = textBox

	subtitleContainer.Visible = false

	-- Dedicated 2D Comms Audio Player
	voiceSound = Instance.new("Sound")
	voiceSound.Name = "DialogueVoiceTrack"
	voiceSound.Volume = 1.0
	voiceSound.Parent = SoundService
end

local function clearDisplay()
	activeLine = nil
	subtitleContainer.Visible = false
	promptBadge.Visible = false
	translationLabel.Visible = false
	voiceSound:Stop()
end

-- Plays a single DialogueLine and yields for its duration
function DialogueUIController.PlayLine(line: DialogueLine, queueId: number?)
	if queueId and queueId ~= currentQueueId then
		return
	end

	activeLine = line
	speakerLabel.Text = string.format("[ %s ]", line.Speaker)
	speakerLabel.TextColor3 = line.Color
	mainTextLabel.Text = line.Text

	if line.SubtitleEN and line.SubtitleEN ~= "" then
		translationLabel.Text = string.format("(%s)", line.SubtitleEN)
		translationLabel.Visible = true
	else
		translationLabel.Visible = false
	end

	local promptText = if isConsole then line.PromptConsole else line.PromptPC
	if promptText and promptText ~= "" then
		promptLabel.Text = promptText
		promptBadge.Visible = true
	else
		promptBadge.Visible = false
	end

	subtitleContainer.Visible = true

	-- Play voice recording if uploaded (ignores placeholder "rbxassetid://0")
	voiceSound:Stop()
	if line.SoundId and line.SoundId ~= "" and line.SoundId ~= "rbxassetid://0" then
		voiceSound.SoundId = line.SoundId
		voiceSound:Play()
	end

	task.wait(line.Duration)

	if not queueId or queueId == currentQueueId then
		clearDisplay()
	end
end

-- Plays an entire scene sequence from TutorialDialogue.Scenes (e.g., "Scene1_ColdOpen")
function DialogueUIController.PlayScene(sceneName: string, onComplete: (() -> ())?)
	local sceneLines = TutorialDialogue.Scenes[sceneName]
	if not sceneLines then
		warn("[DialogueUIController] Unknown scene:", sceneName)
		return
	end

	currentQueueId += 1
	local myQueueId = currentQueueId

	task.spawn(function()
		for _, line in ipairs(sceneLines) do
			if myQueueId ~= currentQueueId then
				return
			end
			DialogueUIController.PlayLine(line, myQueueId)
		end

		if myQueueId == currentQueueId then
			clearDisplay()
			if onComplete then
				onComplete()
			end
		end
	end)
end

-- Plays a quick 3D-world enemy bark (e.g., "Grenade", "OrtenGuy", "Combat")
function DialogueUIController.PlayBark(category: string, emitterPart: BasePart?)
	local bark = TutorialDialogue.GetRandomBark(category)
	if not bark then
		return
	end

	-- Play 3D positional audio from the guard's head/torso if provided
	if emitterPart and bark.SoundId and bark.SoundId ~= "" and bark.SoundId ~= "rbxassetid://0" then
		local sound3D = Instance.new("Sound")
		sound3D.SoundId = bark.SoundId
		sound3D.RollOffMaxDistance = 85
		sound3D.RollOffMinDistance = 12
		sound3D.Volume = 1.0
		sound3D.Parent = emitterPart
		sound3D:Play()
		sound3D.Ended:Once(function()
			sound3D:Destroy()
		end)
	endf

	-- Show subtle subtitle only if no critical scripted scene line is currently active
	if not activeLine then
		currentQueueId += 1
		local myQueueId = currentQueueId
		task.spawn(function()
			DialogueUIController.PlayLine({
				Speaker = "UNIT-44",
				Color = Color3.fromRGB(255, 85, 85),
				Text = bark.Text,
				SubtitleEN = bark.SubtitleEN,
				Duration = 2.6,
			}, myQueueId)
		end)
	end
end

function DialogueUIController.StopAll()
	currentQueueId += 1
	clearDisplay()
end

function DialogueUIController.Init()
	buildUI()
	updateInputDevice(UserInputService:GetLastInputType())
	UserInputService.LastInputTypeChanged:Connect(updateInputDevice)
end

return DialogueUIController
