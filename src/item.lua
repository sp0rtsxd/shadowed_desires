local item = {}
local inventory = require("src.inventory")
local collectSound
local keyCollectEffect = {timer = 0, duration = 0.5}

function item.init(keyDrawFunc, medkitDrawFunc)
    item.keyDrawFunc = keyDrawFunc
    item.medkitDrawFunc = medkitDrawFunc
    collectSound = love.audio.newSource("assets/sounds/collect_item.wav", "static")
end

function item.update(dt)
    local player = require("src.player")
    local level = require("src.level")
    
    local playerTileX = math.floor(player.x / level.tileSize) + 1
    local playerTileY = math.floor(player.y / level.tileSize) + 1
    
    local collectedItem = level.removeItem(playerTileX, playerTileY)
    if collectedItem then
        inventory.addItem(collectedItem)
        collectSound:play()
        if collectedItem == "key" then
            keyCollectEffect.timer = keyCollectEffect.duration
        elseif collectedItem == "medkit" then
            player.health = math.min(100, player.health + 50)
        end
    end
    
    keyCollectEffect.timer = math.max(0, keyCollectEffect.timer - dt)
end

function item.draw()
    local level = require("src.level")
    for _, itemObj in ipairs(level.getCurrentLevel().items) do
        local x = (itemObj.x - 1) * level.tileSize
        local y = (itemObj.y - 1) * level.tileSize
        love.graphics.push()
        love.graphics.translate(x, y)
        love.graphics.scale(2, 2)
        if itemObj.type == "key" and item.keyDrawFunc then
            item.keyDrawFunc()
        elseif itemObj.type == "medkit" and item.medkitDrawFunc then
            item.medkitDrawFunc()
        end
        love.graphics.pop()
    end
    
    -- Draw key collect effect
    if keyCollectEffect.timer > 0 then
        love.graphics.setColor(1, 1, 0, keyCollectEffect.timer / keyCollectEffect.duration)
        love.graphics.circle("fill", love.graphics.getWidth()/2, love.graphics.getHeight()/2, 50)
    end
end

return item