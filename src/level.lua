local level = {}
local currentLevel = 1

local levels = {
    {
        map = {
            {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
            {1,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
            {1,0,1,1,1,1,0,1,0,1,1,1,1,0,1},
            {1,0,1,0,0,0,0,0,0,0,0,0,1,0,1},
            {1,0,1,0,1,1,1,1,1,1,1,0,1,0,1},
            {1,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,0,1,1,1,1,0,1,0,1,1,1,1,0,1},
            {1,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
            {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        },
        items = {
            {type = "key", x = 6, y = 5},
            {type = "medkit", x = 2, y = 2},
        }
    },
    -- Add more levels here
}

function level.init(wallDrawFunc, floorDrawFunc)
    level.tileSize = 64
    level.wallDrawFunc = wallDrawFunc
    level.floorDrawFunc = floorDrawFunc
end

function level.update(dt)
    -- Add level-specific update logic here
end

function level.draw()
    local currentMap = levels[currentLevel].map
    for y, row in ipairs(currentMap) do
        for x, tile in ipairs(row) do
            local drawX = (x-1) * level.tileSize
            local drawY = (y-1) * level.tileSize
            love.graphics.push()
            love.graphics.translate(drawX, drawY)
            if tile == 1 then
                level.wallDrawFunc()
            else
                level.floorDrawFunc()
            end
            love.graphics.pop()
        end
    end
end

function level.getCollision(x, y)
    local tileX = math.floor(x / level.tileSize) + 1
    local tileY = math.floor(y / level.tileSize) + 1
    return levels[currentLevel].map[tileY] and levels[currentLevel].map[tileY][tileX] == 1
end

function level.removeItem(x, y)
    for i, item in ipairs(levels[currentLevel].items) do
        if item.x == x and item.y == y then
            table.remove(levels[currentLevel].items, i)
            return item.type
        end
    end
    return nil
end

function level.loadLevel(levelNum)
    currentLevel = levelNum
    -- Add any additional level loading logic here
end

function level.getCurrentLevel()
    return levels[currentLevel]
end

return level