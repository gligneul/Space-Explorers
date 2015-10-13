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
---   xmin      Minimum x position
---   xmax      Maximum x position
---   ymin      Minimum y position
---   ymax      Maximum y position
---   slimit    Speed absolute maximum
---   acc       Acceleration constant
---   life      Ship's initial life
---   image     Path for image that will be drawn
function Ship.create(x, y, xmin, xmax, ymin, ymax, slimit, acc, life, image)
    local self = Ship._create(life, Ship.DAMAGE)
    self.xengine = Engine.create(x, xmin, xmax, slimit, acc)
    self.yengine = Engine.create(y, ymin, ymax, slimit, acc)
    self.image = image
    self.explosion = Animation.create(Ship.explosion_images, Ship.EXPLOSION_DT,
            'once', x, y, 0, Ship.explosion_width / image:getWidth())
    return self
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

--- Returns whether the element can be removed from the game
function Ship:isOffscreen()
    return self.explosion:isOver()
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
        local bbox = self:getBBox()
        local x, y = bbox.x + bbox.w / 2, bbox.y + bbox.h / 2
        self.explosion:setPosition(x, y)
        self.explosion:update(dt)
    end
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

return Ship
