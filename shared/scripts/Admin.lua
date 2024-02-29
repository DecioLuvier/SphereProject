local Static = require("scripts/Static")
local Player = require("scripts/Player")
local FVector = require("constructors/FVector")
local FQuat = require("constructors/FQuat")

local Admin = {}

---@param character APalCharacter
---@param exp number
function Admin.GiveXpToMonster(Character,exp)
    local PalUtility = Static.GetPalUtility()
    PalUtility:GiveExpToAroundCharacter(
        Character,
        FVector.translate(Character.CharacterMovement.LastUpdateLocation),
        10, --See what is the ideal number here
        exp,
        Character.CharacterParameterComponent.IndividualParameter.SaveParameter.CharacterClass, --See if this works on players
        false
    )  
end

---@param character APalPlayerCharacter
---@param exp number
function Admin.GiveXpToPlayer(Character,exp)
    Character:GetPalPlayerState():GrantExpForParty(exp)
end

--These two functions bellow are actually exploits, so they should be removed from future versions
---@param PlayerController APalPlayerController
---@param ItemID string
---@param Quantity number
function Admin.GiveItemToPlayer(PlayerController, ItemID, Quantity)
    local PalNetworkPlayerComponent = Player.GetPalNetworkPlayerComponent(PlayerController)
    PalNetworkPlayerComponent:RequestAddItem_ToServer(FName(ItemID), Quantity, true)
end

---@param PlayerController APalPlayerController
---@param Quantity number
function Admin.GiveTechToPlayer(PlayerController, Quantity)
    local PalNetworkPlayerComponent = Player.GetPalNetworkPlayerComponent(PlayerController)
    PalNetworkPlayerComponent:RequestAddTechnolgyPoint_ToServer(Quantity)
end

local Debugger = require("scripts/Debugger")

---@param Character APalCharacter
---@param Target APalCharacter
function Admin.TeleportCharacterToCharacter(Character, Target)
    local PalUtility = Static.GetPalUtility()
    local locationTarget =  FVector.translate(Target.CharacterMovement.LastUpdateLocation)
    PalUtility:TeleportAroundLoccation(Character, locationTarget, FQuat.new(0,0,0,0))
end

---@param Character APalCharacter
---@param Target FVector
function Admin.TeleportCharacterToLocation(Character, Target)
    local PalUtility = Static.GetPalUtility()
    PalUtility:TeleportAroundLoccation(Character, Target, FQuat.new(0,0,0,0))
end

---@param SpawnedInstance APalCharacter
---@param PlayerInstance APalPlayerCharacter
function Admin.ForceCaptureToPlayer(SpawnedInstance,PlayerInstance)
    local PalUtility = Static.GetPalUtility()
    PalUtility:PalCaptureSuccess(PlayerInstance, SpawnedInstance)
end

return Admin