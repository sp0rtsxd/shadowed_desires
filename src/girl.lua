local girl = {}

function girl.init()
    girl.x = 200
    girl.y = 200
    girl.width = 32
    girl.height = 32
end

function girl.update(dt)
    -- Add girl update logic here
end

function girl.draw()
    love.graphics.setColor(1, 0.5, 0.5)
    love.graphics.rectangle('fill', girl.x, girl.y, girl.width, girl.height)
end

return girl