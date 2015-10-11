--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    ship.lua
--]]

local Engine = require "engine"

--- Class Ship
--- Represents a spaceship that can me moved by applying forces on it
local Ship = {}

--- Creates a new Ship
--- Parameters
---   x       Initial horizontal position
---   y       Initial vertial position
---   xmin    Minimum x position
---   xmax    Maximum x position
---   ymin    Minimum y position
---   ymax    Max y position
---   slimit  Speed absolute maximum
---   acc     Acceleration constant
---   image   Path for image that will be drawn
function Ship.create(x, y, xmin, xmax, ymin, ymax, slimit, acc, image)
    local self = {
        xengine = Engine.create(x, xmin, xmax, slimit, acc),
        yengine = Engine.create(y, ymin, ymax, slimit, acc),
        image = image
    }
    return setmetatable(self, {__index = Ship})
end

--- Sets the x force
--- Parameters
---   f     Force beeing applied
function Ship:addXForce(f)
    self.xengine:addForce(f)
end

--- Sets the y force
--- Parameters
---   f     Force beeing applied
function Ship:addYForce(f)
    self.yengine:addForce(f)
end

--- Obtains the ship bounding box
function Ship:getBBox()
    return {
        x = self.xengine:getPosition(),
        y = self.yengine:getPosition(),
        w = self.image:getWidth(),
        h = self.image:getHeight()
    }
end

--- Updates the ship position
--- Parameters
---   dt      Time elapsed in milliseconds
function Ship:update(dt)
    self.xengine:update(dt)
    self.yengine:update(dt)
end

--- Draws the ship
function Ship:draw()
    love.graphics.setColor(255, 255, 255)
    local x, y = self.xengine:getPosition(), self.yengine:getPosition()
    love.graphics.draw(self.image, x, y)
end

return Ship
