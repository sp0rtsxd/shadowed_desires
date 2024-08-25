local gameState = {}

gameState.scale = 1
gameState.width = 800
gameState.height = 600

function gameState.init()
    love.window.setMode(gameState.width, gameState.height, {resizable=false, vsync=true})
end

function gameState.update(dt)
    -- Add game state update logic here
end

function gameState.draw()
    -- Add game state drawing logic here
end

return gameState