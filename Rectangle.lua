--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    Rectangle.lua
--]]

local Class = require "Class"

--- Class Rectangle
local Rectangle = Class()

--- Creates an new Rectangle
---   x         Top x coordinate
---   y         Left y coordinate
---   w         Width
---   h         Height
function Rectangle.create(x, y, w, h)
    local self = Rectangle._create()
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    return self
end

--- Collision detection function
--- Returns true if two boxes overlap, false if they don't
function Rectangle:intersects(bbox)
    return self.x < bbox.x + bbox.w and
           bbox.x < self.x + self.w and
           self.y < bbox.y + bbox.h and
           bbox.y < self.y + self.h
end

return Rectangle
