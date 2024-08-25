local inventory = {}

function inventory.init(keyDrawFunc, medkitDrawFunc)
    inventory.items = {}
    inventory.keyCount = 0
    inventory.isOpen = false
    inventory.keyDrawFunc = keyDrawFunc
    inventory.medkitDrawFunc = medkitDrawFunc
end

function inventory.addItem(item)
    if item == "key" then
        inventory.keyCount = inventory.keyCount + 1
    else
        table.insert(inventory.items, item)
    end
end

function inventory.useItem(index)
    if inventory.items[index] == "medkit" then
        local player = require("src.player")
        player.health = math.min(100, player.health + 50)
        table.remove(inventory.items, index)
    end
end

function inventory.toggleInventory()
    inventory.isOpen = not inventory.isOpen
end

function inventory.update(dt)
    -- Add any inventory update logic here
end

function inventory.draw()
    if inventory.isOpen then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 200, 100, 400, 400)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Inventory", 220, 120)
        love.graphics.print("Keys: " .. inventory.keyCount, 220, 150)
        love.graphics.push()
        love.graphics.translate(300, 145)
        love.graphics.scale(0.5, 0.5)
        inventory.keyDrawFunc()
        love.graphics.pop()
        for i, item in ipairs(inventory.items) do
            love.graphics.print(item, 220, 170 + i * 30)
            if item == "medkit" then
                love.graphics.push()
                love.graphics.translate(300, 165 + i * 30)
                love.graphics.scale(0.5, 0.5)
                inventory.medkitDrawFunc()
                love.graphics.pop()
            end
        end
    end
end

return inventory