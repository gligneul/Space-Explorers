--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    Destroyable.lua
--]]

local Class = require "Class"
local Rectangle = require "Rectangle"

--- Class Destroyable
--- Superclass for managing an element life
local Destroyable = Class()

--- Creates a new Destroyable
--- Parameters
---   life      Initial life
function Destroyable.create(life)
    local self = Destroyable._create()
    self.initial_life = life
    self.life = life
    return self
end

--- Hits the element
function Destroyable:hit(damage)
    self.life = self.life - damage
end

--- Returns whether the element is destroyed
function Destroyable:isDestroyed()
    return self.life <= 0
end

--- Draws the life bar above the element
function Destroyable:draw()
    local bbox = self:getBBox()
    local w = 0.5 * bbox.w * (self.life / self.initial_life)
    local h = 2
    local x = bbox.x + 0.25 * bbox.w
    local y = bbox.y - 10
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('fill', x, y, w, h)
end

return Destroyable
