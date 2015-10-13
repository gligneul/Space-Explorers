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
local Window = require "Window"

--- Class LaserBeam
--- Represents a laser beam projectile
local LaserBeam = Class(SpaceElement)

--- Constants
LaserBeam.LIFE = 1
LaserBeam.DAMAGE = 25
LaserBeam.SPEED = 500
LaserBeam.HEIGHT = 1
LaserBeam.WIDTH = 15

--- Creates a LaserBeam
--- Parameters
---   x         Initial x position
---   y         Initial y position
---   direction 'right' or 'left'
---   color     Laser color {r, g, b}
function LaserBeam.create(x, y, direction, color)
    assert(direction == 'right' or direction == 'left', "Invalid direction")

    local self = LaserBeam._create(LaserBeam.LIFE, LaserBeam.DAMAGE)
    self.x = x
    self.y = y
    self.direction = (direction == 'right' and 1 or -1)
    self.color = color
    return self
end

--- Returns whether the element can be removed from the game
function LaserBeam:isOffscreen()
    return self.x > Window.WIDTH or self:isDestroyed()
end

--- Obtains the element bounding box
function LaserBeam:getBBox()
    return Rectangle.create(self.x, self.y, LaserBeam.WIDTH, LaserBeam.HEIGHT)
end

--- Updates the laser beam position
--- Parameters
---   dt      Time elapsed in milliseconds
function LaserBeam:update(dt)
    self.x = self.x + self.direction * LaserBeam.SPEED * dt
end

--- Draws the laser beam
function LaserBeam:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, LaserBeam.WIDTH,
            LaserBeam.HEIGHT)
end

return LaserBeam
