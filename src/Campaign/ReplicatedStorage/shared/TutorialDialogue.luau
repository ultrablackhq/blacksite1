-- ReplicatedStorage/Shared/TutorialDialogue.luau
--!strict

export type DialogueLine = {
	Speaker: string,
	Color: Color3,
	Text: string,
	SubtitleEN: string?,
	Duration: number,
	SoundId: string?,
	PromptPC: string?,
	PromptConsole: string?,
}

export type BarkEntry = {
	Text: string,
	SubtitleEN: string,
	SoundId: string?,
}

local COLORS = {
	VARG = Color3.fromRGB(165, 205, 255),
	VARGETTE = Color3.fromRGB(255, 195, 115),
	UNIT44 = Color3.fromRGB(255, 85, 85),
	SYSTEM = Color3.fromRGB(190, 195, 205),
}

local TutorialDialogue = {}

TutorialDialogue.Scenes = {
	Scene1_ColdOpen = {
		{ Speaker = "UNIT-44", Color = COLORS.UNIT44, Text = "Ey mannen, inga märken, inget ID... vem fan är du ens?", SubtitleEN = "Yo bro, no patches, no ID... who the hell even are you?", Duration = 3.2, SoundId = "rbxassetid://0" },
		{ Speaker = "VARG", Color = COLORS.VARG, Text = "Uh... Vargette? What is he saying?", Duration = 2.2, SoundId = "rbxassetid://0" },
		{ Speaker = "VARGETTE", Color = COLORS.VARGETTE, Text = "He's asking who the hell you are! Stall him!", Duration = 2.2, SoundId = "rbxassetid://0" },
		{ Speaker = "VARG", Color = COLORS.VARG, Text = "Hola, cómo estás, amigos?", Duration = 2.2, SoundId = "rbxassetid://0" },
		{ Speaker = "UNIT-44", Color = COLORS.UNIT44, Text = "VAD?!", SubtitleEN = "WHAT?!", Duration = 1.0, SoundId = "rbxassetid://0" },
		-- Sniper shots -> BLACKSITE -> A GAME BY NIVRAIS
		{ Speaker = "VARGETTE", Color = COLORS.VARGETTE, Text = "Spanish?! Really, Varg?! Grab his keycard and rifle off the snow before I freeze to death up here.", Duration = 4.6, SoundId = "rbxassetid://0", PromptPC = "PRESS [F] TO LOOT", PromptConsole = "PRESS [X] TO LOOT" },
	} :: { DialogueLine },

	Scene2_Airlock = {
		{ Speaker = "VARG", Color = COLORS.VARG, Text = "Hey! The keycard reader has some weird writing on it. I don't speak Finnish!", Duration = 3.4, SoundId = "rbxassetid://0" },
		{ Speaker = "VARGETTE", Color = COLORS.VARGETTE, Text = "It's Swedish, you stupid— agh... focus up. Swipe the card and breach inside.", Duration = 4.2, SoundId = "rbxassetid://0", PromptPC = "PRESS [F] TO BREACH", PromptConsole = "PRESS [X] TO BREACH" },
		{ Speaker = "VARG", Color = COLORS.VARG, Text = "Okay, okay, I'm in. Are you sure this is the right bunker?", Duration = 3.0, SoundId = "rbxassetid://0" },
		{ Speaker = "VARGETTE", Color = COLORS.VARGETTE, Text = "Unless there's another facility in Norrland stealing half of Kiruna's power grid, yeah. Keep low and thread your suppressor.", Duration = 4.8, SoundId = "rbxassetid://0", PromptPC = "[C] CROUCH  |  [T] SUPPRESSOR", PromptConsole = "[B] CROUCH  |  [D-PAD LEFT] SUPPRESSOR" },
		{ Speaker = "SYSTEM", Color = COLORS.SYSTEM, Text = "WARNING: GEOMAGNETIC INTERFERENCE — OVERWATCH SIGNAL DEGRADED", Duration = 3.0 },
	} :: { DialogueLine },

	Scene3_GuardPost = {
		{ Speaker = "UNIT-44 [ORTEN]", Color = COLORS.UNIT44, Text = "Wallah bror, jag pallar inte de här maskerna len. Alla låter som exakt samma shuno.", SubtitleEN = "I swear bro, I can't stand these masks man. Everyone sounds like the exact same guy.", Duration = 4.4, SoundId = "rbxassetid://0" },
		{ Speaker = "UNIT-44", Color = COLORS.UNIT44, Text = "SVENSKA! PRATA SVENSKA! ...Jag kommer att 'walla' dig själv.", SubtitleEN = "SWEDISH! SPEAK SWEDISH! ...I'm gonna 'walla' you myself.", Duration = 3.8, SoundId = "rbxassetid://0" },
		{ Speaker = "VARG", Color = COLORS.VARG, Text = "Translator? Did they spot me?", Duration = 2.2, SoundId = "rbxassetid://0" },
		{ Speaker = "VARGETTE", Color = COLORS.VARGETTE, Text = "No, they're just arguing about Stockholm street slang... drop 'em clean and reload.", Duration = 4.4, SoundId = "rbxassetid://0", PromptPC = "[RMB] AIM  |  [R] RELOAD", PromptConsole = "[LT] AIM  |  [X] RELOAD" },
	} :: { DialogueLine },

	Scene4_ControlRoom = {
		{ Speaker = "VARGETTE", Color = COLORS.VARGETTE, Text = "Power just cut—flip on your night vision and clear the room! Use a frag if they dig behind cover.", Duration = 4.6, SoundId = "rbxassetid://0", PromptPC = "[N] NIGHT VISION  |  [G] FRAG GRENADE", PromptConsole = "[D-PAD UP] NIGHT VISION  |  [RB] FRAG GRENADE" },
	} :: { DialogueLine },

	Scene4_GrenadeFollowup = {
		{ Speaker = "VARG", Color = COLORS.VARG, Text = "Uhh, what does 'fan' mean? Is that English or...", Duration = 2.8, SoundId = "rbxassetid://0" },
		{ Speaker = "VARG", Color = COLORS.VARG, Text = "Actually never mind—ey, wallah bror, those shunos got completely smoked. Jalla, what's next?", Duration = 4.2, SoundId = "rbxassetid://0" },
		{ Speaker = "VARGETTE", Color = COLORS.VARGETTE, Text = "...Please never say that again. Just get to the terminal.", Duration = 3.2, SoundId = "rbxassetid://0" },
	} :: { DialogueLine },

	Scene5_TerminalStart = {
		{ Speaker = "SYSTEM", Color = COLORS.SYSTEM, Text = "ANLÄGGNING 44 // DEKRYPTERAR LOGGAR...", SubtitleEN = "BLACKSITE 44 // DECRYPTING LOGS...", Duration = 3.0 },
		{ Speaker = "VARG", Color = COLORS.VARG, Text = "Yeah, the terminal's all in Swedish too. Please tell me that's a progress bar.", Duration = 3.4, SoundId = "rbxassetid://0" },
		{ Speaker = "VARGETTE", Color = COLORS.VARGETTE, Text = "It's decrypting—and it says Sub-Level 3 containment is at twelve percent. Whatever that means, hurry up.", Duration = 4.4, SoundId = "rbxassetid://0" },
	} :: { DialogueLine },

	Scene6_Cliffhanger = {
		{ Speaker = "VARGETTE", Color = COLORS.VARGETTE, Text = "Varg, get out of there, NOW! Somebody just remotely sealed the outer blast doors—and there's heat signatures coming UP from Sub-Level 3!", Duration = 5.2, SoundId = "rbxassetid://0" },
		{ Speaker = "VARG", Color = COLORS.VARG, Text = "Tell me you've got another way out, Vargette!", Duration = 2.6, SoundId = "rbxassetid://0" },
		{ Speaker = "VARGETTE", Color = COLORS.VARGETTE, Text = "Working on it! Don't you dare die before I crack this override—!", Duration = 3.6, SoundId = "rbxassetid://0" },
		{ Speaker = "SYSTEM", Color = COLORS.SYSTEM, Text = "SIGNAL LOST — OVERRIDE LOCKOUT ACTIVE", Duration = 2.5 },
		{ Speaker = "UNIT-44", Color = COLORS.UNIT44, Text = "SPRÄNG SKITEN! INGEN KOMMER UT HÄRIFRÅN!", SubtitleEN = "BLOW THE DOOR! NOBODY GETS OUT OF HERE!", Duration = 3.0, SoundId = "rbxassetid://0" },
		{ Speaker = "VARG", Color = COLORS.VARG, Text = "...Didn't need a translator for that one.", Duration = 2.6, SoundId = "rbxassetid://0" },
	} :: { DialogueLine },
}

TutorialDialogue.EnemyBarks = {
	Idle = {
		{ Text = "Asså det är fett skumt med elen nere på trean igen.", SubtitleEN = "Man, the power down on level three is acting super sketchy again.", SoundId = "rbxassetid://0" },
		{ Text = "Varför fan svarar inte grabbarna vid porten?", SubtitleEN = "Why the hell aren't the guys at the gate answering?", SoundId = "rbxassetid://0" },
	} :: { BarkEntry },

	OrtenGuy = {
		{ Text = "Ey bror, det är helt kaos här inne len—nån shuno smyger runt!", SubtitleEN = "Yo bro, it's total chaos in here man—some dude is sneaking around!", SoundId = "rbxassetid://0" },
		{ Text = "Wallah han har ljuddämpare, jag ser inte ett skit!", SubtitleEN = "I swear he's got a suppressor, I can't see a damn thing!", SoundId = "rbxassetid://0" },
		{ Text = "Jalla, jalla, runda honom bror!", SubtitleEN = "Move, move, flank him bro!", SoundId = "rbxassetid://0" },
		{ Text = "EY GRANAT LEN! TAGGA DÄRIFRÅN!", SubtitleEN = "YO GRENADE MAN! GET OUT OF THERE!", SoundId = "rbxassetid://0" },
	} :: { BarkEntry },

	Suspicious = {
		{ Text = "Ey, vänta... hörde du det där?", SubtitleEN = "Yo, hold up... did you hear that?", SoundId = "rbxassetid://0" },
		{ Text = "Det är nån snubbe uppe på bryggan, gå och kolla.", SubtitleEN = "There's some dude up on the catwalk, go check it out.", SoundId = "rbxassetid://0" },
	} :: { BarkEntry },

	Combat = {
		{ Text = "KONTAKT! Han är inne i kontrollrummet!", SubtitleEN = "CONTACT! He's inside the control room!", SoundId = "rbxassetid://0" },
		{ Text = "HELVETE! VI BLIR BESKJUTNA!", SubtitleEN = "HELL! WE'RE TAKING FIRE!", SoundId = "rbxassetid://0" },
		{ Text = "Snubben kör ljuddämpare—jag ser inte ett skit!", SubtitleEN = "Dude's running a suppressor—I can't see a damn thing!", SoundId = "rbxassetid://0" },
		{ Text = "Runda honom till vänster! Låt honom inte röra datorn!", SubtitleEN = "Flank him left! Don't let him touch the computer!", SoundId = "rbxassetid://0" },
	} :: { BarkEntry },

	Grenade = {
		{ Text = "FAN! GRANAT!!!!", SubtitleEN = "DAMN! GRENADE!!!!", SoundId = "rbxassetid://0" },
		{ Text = "AKTA! GRANAT, DRA ER UNDAN!", SubtitleEN = "WATCH OUT! GRENADE, GET BACK!", SoundId = "rbxassetid://0" },
		{ Text = "DEN LANDADE RAKT VID OSS—SPRING FÖR FAN!", SubtitleEN = "IT LANDED RIGHT ON US—RUN DAMN IT!", SoundId = "rbxassetid://0" },
	} :: { BarkEntry },

	SquadmateDown = {
		{ Text = "MANNEN NERE! HAN TOG HONOM!", SubtitleEN = "MAN DOWN! HE GOT HIM!", SoundId = "rbxassetid://0" },
		{ Text = "Asså alla är döda! Skicka folk till våning ett, NU!", SubtitleEN = "Bro everyone's dead! Send backup to level one, NOW!", SoundId = "rbxassetid://0" },
	} :: { BarkEntry },

	Reloading = {
		{ Text = "TOMT MAGASIN—LADDAR OM!", SubtitleEN = "EMPTY MAG—RELOADING!", SoundId = "rbxassetid://0" },
		{ Text = "Täck mig bror, jag måste ladda!", SubtitleEN = "Cover me bro, I gotta reload!", SoundId = "rbxassetid://0" },
	} :: { BarkEntry },

	Blinded = {
		{ Text = "JAG SER INTE ETT SKIT! FAN!", SubtitleEN = "I CAN'T SEE A DAMN THING! DAMN!", SoundId = "rbxassetid://0" },
	} :: { BarkEntry },
}

function TutorialDialogue.GetRandomBark(category: string): BarkEntry?
	local pool = TutorialDialogue.EnemyBarks[category]
	return if pool and #pool > 0 then pool[math.random(1, #pool)] else nil
end

return TutorialDialogue
