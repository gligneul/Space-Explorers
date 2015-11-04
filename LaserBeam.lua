--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    LaserBeam.lua
--]]

local Class = require "Class"
local Rectangle = require "Rectangle"
local SpaceElement = require "SpaceElement"
local Vector = require "Vector"
local Window = require "Window"

--- Class LaserBeam
--- Represents a laser beam projectile
local LaserBeam = Class(SpaceElement)

--- Constants
LaserBeam.LIFE = 1
LaserBeam.DAMAGE = 13
LaserBeam.SPEED = 250
LaserBeam.LENGTH = 15

--- Creates a LaserBeam
--- Parameters
---   x         Initial x position
---   y         Initial y position
---   direction Unitary 2D vector {1 = x, 2 = y}
---   color     Laser color {r, g, b}
function LaserBeam.create(x, y, direction, color)
    local self = LaserBeam._create(LaserBeam.LIFE, LaserBeam.DAMAGE)
    self.x = x
    self.y = y
    self.w = direction.x * LaserBeam.LENGTH
    self.h = direction.y * LaserBeam.LENGTH
    self.direction = direction
    self.color = color
    return self
end

--- Returns whether the element can be removed from the game
function LaserBeam:isOffscreen()
    return self.x > Window.WIDTH or self:isDestroyed()
end

--- Obtains the element bounding box
function LaserBeam:getBBox()
    local x = math.min(self.x, self.x + self.w)
    local y = math.min(self.y, self.y + self.h)
    local w = math.abs(self.w)
    local h = math.abs(self.h)
    return Rectangle.create(x, y, w, h)
end

--- Updates the laser beam position
--- Parameters
---   dt      Time elapsed in milliseconds
function LaserBeam:update(dt)
    self.x = self.x + self.direction.x * LaserBeam.SPEED * dt
    self.y = self.y + self.direction.y * LaserBeam.SPEED * dt
end

--- Draws the laser beam
function LaserBeam:draw()
    love.graphics.setColor(self.color)
    love.graphics.line(self.x, self.y, self.x + self.w, self.y + self.h)
end

return LaserBeam
