local gameState = {}
local inventory = require("src.inventory")

gameState.scale = 1
gameState.width = 800
gameState.height = 600
gameState.currentLevel = 1
gameState.maxLevels = 3
gameState.state = "playing"

function gameState.init()
    love.window.setMode(gameState.width, gameState.height, {resizable=false, vsync=true})
end

function gameState.update(dt)
    local player = require("src.player")
    
    if gameState.state == "playing" then
        if player.health <= 0 then
            gameState.state = "game_over"
        elseif inventory.keyCount >= 3 and gameState.currentLevel == gameState.maxLevels then
            gameState.state = "win"
        elseif inventory.keyCount >= 1 then
            gameState.nextLevel()
        end
    end
end

function gameState.draw()
    if gameState.state == "game_over" then
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("Game Over", 0, gameState.height/2, gameState.width, "center")
    elseif gameState.state == "win" then
        love.graphics.setColor(0, 1, 0)
        love.graphics.printf("You Escaped!", 0, gameState.height/2, gameState.width, "center")
    end
end

function gameState.nextLevel()
    if gameState.currentLevel < gameState.maxLevels then
        gameState.currentLevel = gameState.currentLevel + 1
        inventory.keyCount = 0
        local player = require("src.player")
        player.init()  -- Reset player position
        local zombie = require("src.zombie")
        zombie.init()  -- Reset zombie position
        local girl = require("src.girl")
        girl.init()  -- Reset girl position
        local level = require("src.level")
        level.loadLevel(gameState.currentLevel)
    end
end

return gameState