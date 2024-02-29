local config = {}

config.commands = {  
    gkit = require("Chat/commands/givekit"),  
    gpal = require("Chat/commands/givepal"),   
    spawn = require("Chat/commands/spawn"), 
    tp = require("Chat/commands/teleport"),    
    reloadsphere = require("Chat/commands/reloadData")
}

return config
