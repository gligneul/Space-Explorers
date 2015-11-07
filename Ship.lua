--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    Ship.lua
--]]

local Animation = require "Animation"
local Class = require "Class"
local Engine = require "Engine"
local SpaceElement = require "SpaceElement"
local Rectangle = require "Rectangle"

--- Class Ship
local Ship = Class(SpaceElement)

--- Constants
Ship.DAMAGE = 100
Ship.EXPLOSION_DT = 0.05

--- Initializes the shared data (explosion animation)
function Ship.init()
    Ship.explosion_images = Animation.loadImages("data/explosion_", ".png", 16)
    Ship.explosion_width = Ship.explosion_images[1]:getWidth()
end

--- Creates a new Ship
--- Parameters
---   x         Initial horizontal position
---   y         Initial vertial position
---   xmin      Minimum x position (default = -huge)
---   xmax      Maximum x position (default = +huge)
---   ymin      Minimum y position (default = -huge)
---   ymax      Maximum y position (default = +huge)
---   slimit    Speed absolute maximum
---   acc       Acceleration constant
---   life      Ship's initial life
---   image     Path for image that will be drawn
function Ship.create(x, y, xmin, xmax, ymin, ymax, slimit, acc, life, image)
    xmin = xmin or -math.huge
    xmax = xmax or math.huge
    ymin = ymin or -math.huge
    ymax = ymax or math.huge
    local self = Ship._create(life, Ship.DAMAGE)
    self.xengine = Engine.create(x, xmin, xmax, slimit, acc)
    self.yengine = Engine.create(y, ymin, ymax, slimit, acc)
    self.image = image
    return self
end

--- Draws the damage from the element's life
function Ship:hit(damage)
    SpaceElement.hit(self, damage)

    if self:isDestroyed() then
        local bbox = self:getBBox()
        local x, y = bbox.x + bbox.w / 2, bbox.y + bbox.h / 2
        local scale = self.image:getHeight() / Ship.explosion_width
        self.explosion = Animation.create(Ship.explosion_images,
                Ship.EXPLOSION_DT, 'once', x, y, 0, scale)
    end
end

--- Sets the vertical or horizontal force
function Ship:setXForce(f)
    self.xengine:setForce(f)
end
function Ship:setYForce(f)
    self.yengine:setForce(f)
end

--- Accumulates to the vertical or horizontal force
function Ship:addXForce(f)
    self.xengine:addForce(f)
end
function Ship:addYForce(f)
    self.yengine:addForce(f)
end

--- Draws the ship
function Ship:draw()
    if not self:isDestroyed() then
        love.graphics.setColor(255, 255, 255)
        local x, y = self.xengine:getPosition(), self.yengine:getPosition()
        love.graphics.draw(self.image, x, y)
        SpaceElement.draw(self)
    else
        self.explosion:draw()
    end
end

--- Returns whether the element can be removed from the game
function Ship:isOffscreen()
    return self.explosion and self.explosion:isOver()
end

--- Obtains the ship bounding box
function Ship:getBBox()
    return Rectangle.create(self.xengine:getPosition(), 
            self.yengine:getPosition(), self.image:getWidth(),
            self.image:getHeight())
end

--- Updates the ship position
--- Parameters
---   dt      Time elapsed in milliseconds
function Ship:update(dt)
    if not self:isDestroyed() then
        self.xengine:update(dt)
        self.yengine:update(dt)
    else
        self.explosion:update(dt)
    end
end

return Ship
