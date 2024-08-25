local player = {}

function player.init()
    player.x = 400
    player.y = 300
    player.speed = 200
    player.width = 32
    player.height = 32
end

function player.update(dt)
    if love.keyboard.isDown('left') then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown('right') then
        player.x = player.x + player.speed * dt
    end

    if love.keyboard.isDown('up') then
        player.y = player.y - player.speed * dt
    elseif love.keyboard.isDown('down') then
        player.y = player.y + player.speed * dt
    end
end

function player.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', player.x, player.y, player.width, player.height)
end

return player