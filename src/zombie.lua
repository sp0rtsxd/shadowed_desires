local zombie = {}
local level = require("src.level")
local zombieGroanSound

function zombie.init(drawFunc)
    zombie.x = 600
    zombie.y = 400
    zombie.speed = 50
    zombie.width = 64
    zombie.height = 64
    zombie.drawFunc = drawFunc
    zombie.state = "idle"
    zombie.idleTimer = 0
    zombie.wanderDirection = {x = 0, y = 0}
    zombie.wanderTimer = 0
    
    zombieGroanSound = love.audio.newSource("assets/sounds/zombie_groan.wav", "static")
end

function zombie.update(dt)
    local player = require('src.player')
    local dx = player.x - zombie.x
    local dy = player.y - zombie.y
    local distance = math.sqrt(dx*dx + dy*dy)
    
    if distance < 150 then
        zombie.state = "chase"
    elseif zombie.state == "chase" and distance > 200 then
        zombie.state = "idle"
        zombie.idleTimer = love.math.random(1, 3)
    end
    
    if zombie.state == "chase" then
        if distance > 0 then
            local moveX = (dx / distance) * zombie.speed * dt
            local moveY = (dy / distance) * zombie.speed * dt
            
            if not level.getCollision(zombie.x + moveX, zombie.y) then
                zombie.x = zombie.x + moveX
            end
            if not level.getCollision(zombie.x, zombie.y + moveY) then
                zombie.y = zombie.y + moveY
            end
        end
        
        if not zombieGroanSound:isPlaying() then
            zombieGroanSound:play()
        end
    elseif zombie.state == "idle" then
        zombie.idleTimer = zombie.idleTimer - dt
        if zombie.idleTimer <= 0 then
            zombie.state = "wander"
            zombie.wanderDirection = {
                x = love.math.random() - 0.5,
                y = love.math.random() - 0.5
            }
            zombie.wanderTimer = love.math.random(2, 5)
        end
    elseif zombie.state == "wander" then
        local moveX = zombie.wanderDirection.x * zombie.speed * 0.5 * dt
        local moveY = zombie.wanderDirection.y * zombie.speed * 0.5 * dt
        
        if not level.getCollision(zombie.x + moveX, zombie.y) then
            zombie.x = zombie.x + moveX
        else
            zombie.wanderDirection.x = -zombie.wanderDirection.x
        end
        
        if not level.getCollision(zombie.x, zombie.y + moveY) then
            zombie.y = zombie.y + moveY
        else
            zombie.wanderDirection.y = -zombie.wanderDirection.y
        end
        
        zombie.wanderTimer = zombie.wanderTimer - dt
        if zombie.wanderTimer <= 0 then
            zombie.state = "idle"
            zombie.idleTimer = love.math.random(1, 3)
        end
    end
    
    -- Check for collision with player
    if distance < (zombie.width + player.width) / 2 then
        player.takeDamage(10)
        player.sanity = math.max(0, player.sanity - 15)
    end
end

function zombie.draw()
    love.graphics.push()
    love.graphics.translate(zombie.x, zombie.y)
    love.graphics.scale(2, 2)  -- Scale up the zombie sprite
    zombie.drawFunc()
    love.graphics.pop()
end

return zombie