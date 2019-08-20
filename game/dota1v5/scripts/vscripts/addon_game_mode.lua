-- Generated from template

if Dota1V5 == nil then
	_G.Dota1V5 = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	PrecacheUnitByNameSync("npc_dota_hero_tinker", context)
	PrecacheUnitByNameSync("npc_dota_hero_antimage", context)
	PrecacheUnitByNameSync("npc_dota_hero_crystal_maiden", context)
	PrecacheUnitByNameSync("npc_dota_hero_nevermore", context)
	PrecacheUnitByNameSync("npc_dota_hero_juggernaut", context)
	PrecacheUnitByNameSync("npc_dota_hero_pudge", context)
	PrecacheUnitByNameSync("npc_dota_hero_earthshaker", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = _G.Dota1V5()
	GameRules.AddonTemplate:InitGameMode()
end

function _G.Dota1V5:InitGameMode()
	print( "Template addon is loaded." )
	--监听游戏进度
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(_G.Dota1V5, "OnGameRulesStateChange"), self) 

	--监听UI事件,这是新的事件管理器
  CustomGameEventManager:RegisterListener( "SelectHero", SelectHero )

	--GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
end

function _G.Dota1V5:OnGameRulesStateChange(keys)
	local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		PlayerResource:SetCustomTeamAssignment( 0, DOTA_TEAM_GOODGUYS )
		GameRules:SetCustomGameSetupTimeout(0)
		GameRules:EnableCustomGameSetupAutoLaunch( false )

	elseif state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		_G.listener = CustomGameEventManager:RegisterListener( "GoNext", GoNext )
	elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
		--CustomUI:DynamicHud_Create(-1,"MyUIButton","file://{resources}/layout/custom_game/MyUI_button.xml",nil)

	end
end

-- Evaluate the state of the game
function _G.Dota1V5:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function SelectHero(index, keys)
	
	print("xxxxxxx2")
	print(keys.PlayerID)
	print(keys.HeroName)
	GameRules:GetGameModeEntity():SetCustomGameForceHero(keys.HeroName);
	AssignHero(keys.PlayerID, keys.HeroName)

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "AfterTeamSelection", {})
end

function GoNext(index, keys)
	print("xxxxxxx")
	print(keys.PlayerID)
	print(keys.HeroName)
	AssignHero(keys.PlayerID, keys.HeroName)	
end

--[[
	AssignHero
	Assign a hero to the player. Replaces the current hero of the player
	with the selected hero, after it has finished precaching.
	Params:
		- player {integer} - The playerID of the player to assign to.
		- hero {string} - The unit name of the hero to assign (e.g. 'npc_dota_hero_rubick')
]]
function AssignHero( player, hero )
	PrecacheUnitByNameAsync( hero, function()
		print("abababa")
		PlayerResource:ReplaceHeroWith( player, hero, 0, 0 )
	end, player)
end