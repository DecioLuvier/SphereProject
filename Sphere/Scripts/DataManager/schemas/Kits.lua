local validation = require("libs/validation")
local Items = require("enums/Items")

local CustomKits = {}

CustomKits.validate = validation.is_array(
    validation.is_table {
        Items =  validation.optional(validation.is_array(
            validation.is_table { 
                ItemID = validation.required(validation.is_string(validation.is_KeyOfList(Items))),
                Quantity = validation.optional(validation.is_integer())
            }
        ))
    }
)

CustomKits.default = {
    Alchemist = {
        Items = {
            { Quantity = 100, ItemID = "Horn" },
            { Quantity = 30, ItemID = "Bone" },
            { Quantity = 50, ItemID = "Berries" }
        }
    },
    Pro = {
        Items = {
            { Quantity = 5, ItemID = "PalSphere_Mega" },
            { Quantity = 1, ItemID = "ClothArmor" }
        }
    },
    Noob = {
        Items = {
            { Quantity = 1, ItemID = "Pickaxe_Tier_00" },
            { Quantity = 1, ItemID = "Axe_Tier_00" },
            { Quantity = 1, ItemID = "Torch" },
            { Quantity = 1, ItemID = "Bat" },
            { Quantity = 5, ItemID = "PalSphere" }
        }
    },
    Reaper = {
        Items = {
            { Quantity = 20, ItemID = "PalUpgradeStone" },
            { Quantity = 8, ItemID = "PalUpgradeStone2" },
            { Quantity = 4, ItemID = "PalUpgradeStone3" }
        }
    },
    Admin = {
        Items = {
            { Quantity = 1, ItemID = "HandGun_Default_5" },
            { Quantity = 100, ItemID = "HandgunBullet" }
        }
    },
    Breeder = {
        Items = {
            { Quantity = 20, ItemID = "Cake" }
        }
    },
    Farmer = {
        Items = {
            { Quantity = 30, ItemID = "Pan" },
            { Quantity = 10, ItemID = "Pancake" }
        }
    }
}

return CustomKits