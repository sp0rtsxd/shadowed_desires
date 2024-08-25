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
    player.speedBoost = 1
    player.speedBoostTimer = 0
    
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
        
        local newX = player.x + dx * player.speed * player.speedBoost * dt
        local newY = player.y + dy * player.speed * player.speedBoost * dt
        
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
    
    -- Update speed boost
    if player.speedBoostTimer > 0 then
        player.speedBoostTimer = player.speedBoostTimer - dt
        if player.speedBoostTimer <= 0 then
            player.speedBoost = 1
        end
    end
end

function player.draw()
    love.graphics.push()
    love.graphics.translate(player.x, player.y)
    love.graphics.scale(2, 2)  -- Scale up the player sprite
    player.drawFunc()
    love.graphics.pop()
    
    -- Add warning for low health or sanity
    if player.health < 30 or player.sanity < 30 then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("WARNING: Low health or sanity!", love.graphics.getWidth()/2 - 100, 10)
    end
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

function player.activateSpeedBoost(duration)
    player.speedBoost = 2
    player.speedBoostTimer = duration
end

return player