--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    Vector.lua
--]]

local Class = require "Class"

--- Class Vector 
local Vector = Class()

--- Creates an new Vector
function Vector.create(x, y)
    local self = Vector._create()
    self.x = x
    self.y = y
    return self
end

--- Returns w = u - v
function Vector:__sub(v)
    return Vector.create(self.x - v.x, self.y - v.y)
end

--- Returns |u| ^ 2
function Vector:norm2()
    return self.x ^ 2 + self.y ^ 2
end

--- Returns |u|
function Vector:norm()
    return math.sqrt(self:norm2())
end

--- Returns u / |u|
function Vector:normalize()
    local norm = self:norm()
    return Vector.create(self.x / norm, self.y / norm)
end

return Vector
