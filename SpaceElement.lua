--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    SpaceElement.lua
--]]

local Class = require "Class"

--- Class SpaceElement
--- Base class for managing a space element
local SpaceElement = Class()

--- Creates a new SpaceElement
--- Parameters
---   life      Initial life
---   damage    Damage caused by the element on hit
function SpaceElement.create(life, damage)
    local self = SpaceElement._create()
    self.initial_life = life
    self.life = life
    self.damage = damage
    return self
end

--- Obtains the damage caused by the element on hit
function SpaceElement:getDamage()
    return self.damage
end

--- Draws the damage from the element's life
function SpaceElement:hit(damage)
    self.life = self.life - damage
end

--- Returns whether the element is destroyed
function SpaceElement:isDestroyed()
    return self.life <= 0
end

--- Draws the life bar above the element
function SpaceElement:draw()
    local bbox = self:getBBox()
    local w = 0.5 * bbox.w * (self.life / self.initial_life)
    local h = 2
    local x = bbox.x + 0.25 * bbox.w
    local y = bbox.y - 10
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('fill', x, y, w, h)
end

--- Returns whether the element can be removed from the game
function SpaceElement:isOffscreen()
    error("Unimplemented abstract method")
end

--- Obtains the element bounding box
function SpaceElement:getBBox()
    error("Unimplemented abstract method")
end

--- Updates the element by dt milliseconds
function SpaceElement:update(dt)
    error("Unimplemented abstract method")
end

return SpaceElement
