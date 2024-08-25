local gameState = require("src.gameState")
local player = require("src.player")
local girl = require("src.girl")
local zombie = require("src.zombie")

function love.load()
    gameState.init()
    player.init()
    girl.init()
    zombie.init()
end

function love.update(dt)
    player.update(dt)
    girl.update(dt)
    zombie.update(dt)
    gameState.update(dt)
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(gameState.scale)
    
    player.draw()
    girl.draw()
    zombie.draw()
    gameState.draw()
    
    love.graphics.pop()
end