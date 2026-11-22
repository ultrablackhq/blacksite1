print("[Campaign] Client started")

local DialogueUIController = require(script.Parent.Client:WaitForChild("DialogueUIController"))
DialogueUIController.Init()

-- Play the Cold Open scene:
DialogueUIController.PlayScene("Scene1_ColdOpen", function()
	print("Cold open finished! Ready to loot keycard.")
end)

wait(3)
-- Trigger an enemy grenade bark from a guard's Head part:
DialogueUIController.PlayBark("Grenade")
