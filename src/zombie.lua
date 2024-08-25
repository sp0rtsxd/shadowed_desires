local zombie = {}

function zombie.init()
    zombie.x = 600
    zombie.y = 400
    zombie.speed = 50
    zombie.width = 32
    zombie.height = 32
end

function zombie.update(dt)
    -- Simple AI: move towards the player
    local player = require('src.player')
    local dx = player.x - zombie.x
    local dy = player.y - zombie.y
    local distance = math.sqrt(dx*dx + dy*dy)
    
    if distance > 0 then
        zombie.x = zombie.x + (dx / distance) * zombie.speed * dt
        zombie.y = zombie.y + (dy / distance) * zombie.speed * dt
    end
end

function zombie.draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle('fill', zombie.x, zombie.y, zombie.width, zombie.height)
end

return zombie