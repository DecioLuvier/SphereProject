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
    
    --This here is a support for palguard, more info on README on github
    reloadcfg = require("./commands/ignore"),  
    imcheater = require("./commands/ignore"),  
    kick = require("./commands/ignore"),  
    kickid = require("./commands/ignore"),  
    ban = require("./commands/ignore"),  
    banid = require("./commands/ignore"),  
    ipban = require("./commands/ignore"),  
    ipbanid = require("./commands/ignore"),  
    ipban_ip = require("./commands/ignore"),  
    addadminip = require("./commands/ignore"),  
    setadmin = require("./commands/ignore"),  
    --give = require("./commands/ignore"),  
    --give_exp = require("./commands/ignore"),  
    whitelist_add = require("./commands/ignore"),  
    whitelist_remove = require("./commands/ignore"),  
    whitelist_get = require("./commands/ignore"),  
    --givepal = require("./commands/ignore"),  
    giveegg = require("./commands/ignore"),  
    jetragon = require("./commands/ignore"),  
    catwaifu = require("./commands/ignore"),  
}

return manager
