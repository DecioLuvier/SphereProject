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
    Noob = {
        Items = {
            {
                ItemID = "Pickaxe_Tier_00",
                Quantity = 1
            },
            {
                ItemID = "Axe_Tier_00",
                Quantity = 1
            },
            {
                ItemID = "Torch",
                Quantity = 1
            },
            {
                ItemID = "Bat",
                Quantity = 1
            },
            {
                ItemID = "PalSphere",
                Quantity = 5
            }
        }
    },
    Pro = {
        Items = {
            {
                ItemID = "PalSphere_Mega",
                Quantity = 5
            },
            {
                ItemID = "ClothArmor",
                Quantity = 1
            }
        }
    },
    Farmer = {
        Items = {
            {
                ItemID = "Pan",
                Quantity = 30
            },
            {
                ItemID = "Pancake",
                Quantity = 10
            }
        }
    },
    Alchemist = {
        Items = {
            {
                ItemID = "Horn",
                Quantity = 100
            },
            {
                ItemID = "Bone",
                Quantity = 30
            },
            {
                ItemID = "Berries",
                Quantity = 50
            }
        }
    },
    Reaper = {
        Items = {
            {
                ItemID = "PalUpgradeStone",
                Quantity = 20
            },
            {
                ItemID = "PalUpgradeStone2",
                Quantity = 8
            },
            {
                ItemID = "PalUpgradeStone3",
                Quantity = 4
            }
        }
    },
    Breeder = {
        Items = {
            {
                ItemID = "Cake",
                Quantity = 20
            }
        }
    },
    Admin = {
        Items = {
            {
                ItemID = "HandGun_Default_5",
                Quantity = 1
            },
            {
                ItemID = "HandgunBullet",
                Quantity = 100
            }
        }
    }
}

return CustomKits