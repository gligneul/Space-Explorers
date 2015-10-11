--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    explosion.lua
--]]

local Animation = require "animation"

--- Class Explosion
local Explosion = {}

--- Constants
Explosion.ANIMATION_DT = 0.05

--- Initializes the shared data (animation)
function Explosion.init()
    Explosion.images = Animation.loadImages("data/explosion_", ".png", 16)
    Explosion.width = Explosion.images[1]:getWidth()
    Explosion.height = Explosion.images[1]:getHeight()
end

--- Creates a new explosion
--- Parameters
---   bBox      Explosion's bouding box
function Explosion.create(bbox)
    local scale = math.min(bbox.w / Explosion.width, bbox.h / Explosion.height)
    return Animation.create(Explosion.images, Explosion.ANIMATION_DT, 'once',
            bbox.x, bbox.y, 0, scale)
end

return Explosion
