local svgGenerator = {}

function svgGenerator.player()
    return function()
        love.graphics.setColor(0.29, 0.56, 0.89)  -- Light blue
        love.graphics.circle("fill", 16, 16, 14)
        love.graphics.setColor(1, 1, 1)  -- White
        love.graphics.circle("fill", 11, 13, 3)
        love.graphics.circle("fill", 21, 13, 3)
        love.graphics.setColor(1, 1, 1)
        love.graphics.arc("line", "open", 16, 20, 6, 0, math.pi)
    end
end

function svgGenerator.zombie()
    return function()
        love.graphics.setColor(0.55, 0.76, 0.29)  -- Green
        love.graphics.circle("fill", 16, 16, 14)
        love.graphics.setColor(1, 0, 0)  -- Red
        love.graphics.circle("fill", 11, 13, 3)
        love.graphics.circle("fill", 21, 13, 3)
        love.graphics.setColor(0, 0, 0)
        love.graphics.arc("line", "open", 16, 22, 6, math.pi, 2*math.pi)
    end
end

function svgGenerator.girl()
    return function()
        love.graphics.setColor(1, 0.41, 0.71)  -- Pink
        love.graphics.circle("fill", 16, 16, 14)
        love.graphics.setColor(1, 1, 1)  -- White
        love.graphics.circle("fill", 11, 13, 3)
        love.graphics.circle("fill", 21, 13, 3)
        love.graphics.arc("line", "open", 16, 20, 6, 0, math.pi)
        love.graphics.setColor(1, 1, 0)  -- Yellow
        love.graphics.polygon("fill", 16, 4, 20, 8, 16, 12, 12, 8)  -- Hair bow
    end
end

function svgGenerator.key()
    return function()
        love.graphics.setColor(1, 0.84, 0)  -- Gold
        love.graphics.circle("fill", 8, 8, 6)
        love.graphics.rectangle("fill", 14, 6, 14, 4)
        love.graphics.rectangle("fill", 22, 6, 4, 8)
    end
end

function svgGenerator.medkit()
    return function()
        love.graphics.setColor(1, 1, 1)  -- White
        love.graphics.rectangle("fill", 2, 6, 28, 20)
        love.graphics.setColor(1, 0, 0)  -- Red
        love.graphics.rectangle("line", 2, 6, 28, 20)
        love.graphics.rectangle("fill", 14, 2, 4, 8)
        love.graphics.rectangle("fill", 8, 14, 16, 4)
        love.graphics.rectangle("fill", 14, 8, 4, 16)
    end
end

function svgGenerator.wall()
    return function()
        love.graphics.setColor(0.55, 0.27, 0.07)  -- Brown
        love.graphics.rectangle("fill", 0, 0, 32, 32)
        love.graphics.setColor(0.42, 0.24, 0.15)  -- Darker brown
        love.graphics.line(0, 8, 32, 8)
        love.graphics.line(0, 24, 32, 24)
        love.graphics.line(8, 0, 8, 32)
        love.graphics.line(24, 0, 24, 32)
    end
end

function svgGenerator.floor()
    return function()
        love.graphics.setColor(0.87, 0.72, 0.53)  -- Light brown
        love.graphics.rectangle("fill", 0, 0, 32, 32)
        love.graphics.setColor(0.76, 0.60, 0.42)  -- Darker brown
        love.graphics.line(0, 8, 32, 8)
        love.graphics.line(0, 24, 32, 24)
        love.graphics.line(8, 0, 8, 32)
        love.graphics.line(24, 0, 24, 32)
    end
end

return svgGenerator