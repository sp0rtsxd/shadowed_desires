local gameState = require("src.gameState")
local player = require("src.player")
local girl = require("src.girl")
local zombie = require("src.zombie")
local level = require("src.level")
local inventory = require("src.inventory")
local item = require("src.item")
local svgGenerator = require("src.svgGenerator")
local level = require("src.level")
local flashlightRadius = 200
local camera = {x = 0, y = 0}
local backgroundMusic
local speedboostDraw = svgGenerator.speedboost()
item.init(keyDraw, medkitDraw, speedboostDraw)
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    -- Generate drawing functions
    local playerDraw = svgGenerator.player()
    local zombieDraw = svgGenerator.zombie()
    local girlDraw = svgGenerator.girl()
    local keyDraw = svgGenerator.key()
    local medkitDraw = svgGenerator.medkit()
    local wallDraw = svgGenerator.wall()
    local floorDraw = svgGenerator.floor()
        level.init()
        level.loadLevel(1)  -- Load the first level
    gameState.init()
    player.init(playerDraw)
    girl.init(girlDraw)
    zombie.init(zombieDraw)
    level.init(wallDraw, floorDraw)
    inventory.init(keyDraw, medkitDraw)
    item.init(keyDraw, medkitDraw)
    
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    
    -- Load and play background music
    backgroundMusic = love.audio.newSource("assets/sounds/background.wav", "stream")
    backgroundMusic:setLooping(true)
    backgroundMusic:play()
end

function love.update(dt)
    if gameState.state == "playing" then
        player.update(dt)
        girl.update(dt)
        zombie.update(dt)
        level.update(dt)
        inventory.update(dt)
        item.update(dt)

        -- Update camera to follow player
        camera.x = player.x - love.graphics.getWidth() / 2
        camera.y = player.y - love.graphics.getHeight() / 2
    end
    gameState.update(dt)
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(-camera.x, -camera.y)
    
    if gameState.state == "playing" then
        level.draw()
        item.draw()
        player.draw()
        girl.draw()
        zombie.draw()
        
        -- Draw dark overlay (less opaque)
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle('fill', camera.x, camera.y, love.graphics.getWidth(), love.graphics.getHeight())
        
        -- Draw flashlight effect
        love.graphics.stencil(function()
            love.graphics.circle('fill', player.x + player.width/2, player.y + player.height/2, flashlightRadius)
        end, 'replace', 1)
        
        love.graphics.setStencilTest('less', 1)
        love.graphics.setColor(1, 1, 1, 0.7)
        love.graphics.rectangle('fill', camera.x, camera.y, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setStencilTest()
    end
    
    love.graphics.pop()
    
   -- Draw UI elements
   love.graphics.setColor(1, 1, 1)
   love.graphics.print("Health: " .. player.health, 10, 10)
   love.graphics.print("Sanity: " .. math.floor(player.sanity), 10, 30)
   love.graphics.print("Keys: " .. inventory.keyCount, 10, 50)
   love.graphics.print("Use arrow keys to move", 10, 70)
   love.graphics.print("Blue: Player, Pink: Girl (restores sanity), Green: Zombie (damages you)", 10, 90)
   
   inventory.draw()
   gameState.draw()
end

function love.keypressed(key)
    if key == "e" then
        inventory.toggleInventory()
    end
end