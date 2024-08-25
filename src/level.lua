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
            {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
        },
        items = {
            {type = "key", x = 6, y = 5},
            {type = "medkit", x = 2, y = 2},
            {type = "speedboost", x = 8, y = 7}
        },
        enemies = {
            {type = "patrol", x = 3, y = 3, direction = "right", speed = 50},
            {type = "static", x = 10, y = 5}
        }
    }
    -- Add more levels here
}

function level.init(wallDrawFunc, floorDrawFunc, itemDrawFunc, enemyDrawFunc)
    level.tileSize = 64
    level.wallDrawFunc = wallDrawFunc or function() love.graphics.rectangle("fill", 0, 0, level.tileSize, level.tileSize) end
    level.floorDrawFunc = floorDrawFunc or function() end
    level.itemDrawFunc = itemDrawFunc or function(itemType)
        love.graphics.setColor(1, 1, 0)  -- Yellow color for items
        love.graphics.circle("fill", level.tileSize/2, level.tileSize/2, level.tileSize/4)
        love.graphics.setColor(1, 1, 1)  -- Reset color
    end
    level.enemyDrawFunc = enemyDrawFunc or function(enemyType)
        love.graphics.setColor(1, 0, 0)  -- Red color for enemies
        love.graphics.rectangle("fill", level.tileSize/4, level.tileSize/4, level.tileSize/2, level.tileSize/2)
        love.graphics.setColor(1, 1, 1)  -- Reset color
    end
end

function level.update(dt)
    local currentLevelData = levels[currentLevel]
    
    -- Update enemies
    for _, enemy in ipairs(currentLevelData.enemies) do
        if enemy.type == "patrol" then
            -- Move patrol enemies
            if enemy.direction == "right" then
                enemy.x = enemy.x + enemy.speed * dt
                if level.getCollision(enemy.x + 1, enemy.y) then
                    enemy.direction = "left"
                end
            else
                enemy.x = enemy.x - enemy.speed * dt
                if level.getCollision(enemy.x - 1, enemy.y) then
                    enemy.direction = "right"
                end
            end
        end
    end
end

function level.draw()
    local currentLevelData = levels[currentLevel]
    
    -- Draw map
    for y, row in ipairs(currentLevelData.map) do
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
    
    -- Draw items
    for _, item in ipairs(currentLevelData.items) do
        love.graphics.push()
        love.graphics.translate((item.x-1) * level.tileSize, (item.y-1) * level.tileSize)
        level.itemDrawFunc(item.type)
        love.graphics.pop()
    end
    
    -- Draw enemies
    for _, enemy in ipairs(currentLevelData.enemies) do
        love.graphics.push()
        love.graphics.translate(enemy.x * level.tileSize, enemy.y * level.tileSize)
        level.enemyDrawFunc(enemy.type)
        love.graphics.pop()
    end
end

function level.getCollision(x, y)
    local tileX = math.floor(x / level.tileSize) + 1
    local tileY = math.floor(y / level.tileSize) + 1
    return levels[currentLevel].map[tileY] and levels[currentLevel].map[tileY][tileX] == 1
end

function level.removeItem(x, y)
    local currentLevelData = levels[currentLevel]
    for i, item in ipairs(currentLevelData.items) do
        if item.x == x and item.y == y then
            table.remove(currentLevelData.items, i)
            return item.type
        end
    end
    return nil
end

function level.loadLevel(levelNum)
    if levels[levelNum] then
        currentLevel = levelNum
        -- Reset enemy positions or other level-specific data here
    else
        print("Error: Level " .. levelNum .. " does not exist.")
    end
end

function level.getCurrentLevel()
    return levels[currentLevel]
end

return level