local girl = {}
local level = require("src.level")

function girl.init(drawFunc)
    girl.x = 200
    girl.y = 200
    girl.width = 64
    girl.height = 64
    girl.drawFunc = drawFunc
    girl.state = "idle"
    girl.dialogueTimer = 0
    girl.currentDialogue = ""
    girl.dialogues = {
        "Help me...",
        "We need to escape!",
        "The darkness is coming...",
        "Don't let it get you...",
    }
end

function girl.update(dt)
    local player = require('src.player')
    local dx = player.x - girl.x
    local dy = player.y - girl.y
    local distance = math.sqrt(dx*dx + dy*dy)
    
    if distance < 100 and girl.dialogueTimer <= 0 then
        girl.currentDialogue = girl.dialogues[love.math.random(#girl.dialogues)]
        girl.dialogueTimer = 3  -- Display dialogue for 3 seconds
        player.restoreSanity(5)  -- Restore some sanity when near the girl
    end
    
    girl.dialogueTimer = math.max(0, girl.dialogueTimer - dt)
end

function girl.draw()
    love.graphics.push()
    love.graphics.translate(girl.x, girl.y)
    love.graphics.scale(2, 2)  -- Scale up the girl sprite
    girl.drawFunc()
    love.graphics.pop()
    
    if girl.dialogueTimer > 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(girl.currentDialogue, girl.x - 50, girl.y - 60, 100, "center")
    end
end

return girl