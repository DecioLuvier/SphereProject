local manager = {}

manager.commands = {  
    gkit = require("./commands/givekit"),  
    gitem = require("./commands/giveitem"),    
    gpal = require("./commands/givepal"), 
    gtech = require("./commands/givetech"),   
    gexp = require("./commands/givexp"), 
    spawngroup = require("./commands/spawngroup"), 
    spawn = require("./commands/spawn"), 
    teleport = require("./commands/teleport"),    
    exitguild = require("./commands/exitguild"), 
    spec = require("./commands/spec"), 
    time = require("./commands/time"), 
}

manager.ignore = {
    shutdown = require("./commands/ignore"),   
    doexit = require("./commands/ignore"),   
    broadcast = require("./commands/ignore"),   
    banplayer = require("./commands/ignore"),   
    teleporttoplayer = require("./commands/ignore"),   
    teleporttome = require("./commands/ignore"),   
    showplayers = require("./commands/ignore"),   
    info = require("./commands/ignore"),   
    save = require("./commands/ignore"),   
    adminpassword = require("./commands/ignore"),   
}

return manager