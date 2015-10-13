--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    LaserBeam.lua
--]]

local Class = require "Class"
local Window = require "Window"

--- Class LaserBeam
--- Represents a laser beam projectile
local LaserBeam = Class()

--- Constants
local SPEED = 500
local HEIGHT = 1
local WIDTH = 15

--- Creates a LaserBeam
--- Parameters
---   x         Initial x position
---   y         Initial y position
---   direction 'right' or 'left'
---   color     Laser color {r, g, b}
function LaserBeam.create(x, y, direction, color)
    local self = LaserBeam._create()
    self.x = x
    self.y = y
    self.direction = direction == 'right' and 1 or -1
    self.color = color
    return self
end

--- Returns whether the projectile is offscreen
function LaserBeam:isOffscreen()
    return self.x > Window.WIDTH
end

--- Updates the laser beam position
--- Parameters
---   dt      Time elapsed in milliseconds
function LaserBeam:update(dt)
    self.x = self.x + self.direction * SPEED * dt
end

--- Draws the laser beam
function LaserBeam:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, WIDTH, HEIGHT)
end

return LaserBeam
