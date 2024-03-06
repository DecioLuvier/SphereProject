local ConfigDataManager = {}

ConfigDataManager.paths = {}

ConfigDataManager.paths.root = "Sphere\\"
ConfigDataManager.paths.data =  ConfigDataManager.paths.root .. "Data\\"

ConfigDataManager.entries = {
    Pals = {
        path = ConfigDataManager.paths.data,
        schema =  require("./DataManager/schemas/Pals"),
        copyDefault = false,
        overwrite = false
    },
    Kits = {
        path = ConfigDataManager.paths.data,
        schema =  require("./DataManager/schemas/Kits"),
        copyDefault = false,
        overwrite = false
    },
    Configs = {
        path = ConfigDataManager.paths.root,
        schema =  require("./DataManager/schemas/Configs"),
        copyDefault = true,
        overwrite = false
    }
}

return ConfigDataManager