local player = {}
local level = require("src.level")
local footstepSound
local heartbeatSound

function player.init(drawFunc)
    player.x = 100
    player.y = 100
    player.speed = 200
    player.width = 64
    player.height = 64
    player.health = 100
    player.sanity = 100
    player.drawFunc = drawFunc
    
    footstepSound = love.audio.newSource("assets/sounds/footstep.wav", "static")
    heartbeatSound = love.audio.newSource("assets/sounds/heartbeat.wav", "static")
end

function player.update(dt)
    local dx, dy = 0, 0
    
    if love.keyboard.isDown('left') then dx = dx - 1 end
    if love.keyboard.isDown('right') then dx = dx + 1 end
    if love.keyboard.isDown('up') then dy = dy - 1 end
    if love.keyboard.isDown('down') then dy = dy + 1 end
    
    if dx ~= 0 or dy ~= 0 then
        local length = math.sqrt(dx * dx + dy * dy)
        dx, dy = dx / length, dy / length
        
        local newX = player.x + dx * player.speed * dt
        local newY = player.y + dy * player.speed * dt
        
        if not level.getCollision(newX, player.y) then
            player.x = newX
        end
        if not level.getCollision(player.x, newY) then
            player.y = newY
        end
        
        if not footstepSound:isPlaying() then
            footstepSound:play()
        end
    end
    
    -- Decrease sanity over time
    player.sanity = math.max(0, player.sanity - dt)
    
    -- Play heartbeat sound when sanity is low
    if player.sanity < 30 and not heartbeatSound:isPlaying() then
        heartbeatSound:play()
    elseif player.sanity >= 30 and heartbeatSound:isPlaying() then
        heartbeatSound:stop()
    end
end

function player.draw()
    love.graphics.push()
    love.graphics.translate(player.x, player.y)
    love.graphics.scale(2, 2)  -- Scale up the player sprite
    player.drawFunc()
    love.graphics.pop()
end

function player.takeDamage(amount)
    player.health = math.max(0, player.health - amount)
    if player.health == 0 then
        -- Game over logic
    end
end

function player.restoreSanity(amount)
    player.sanity = math.min(100, player.sanity + amount)
end

return player