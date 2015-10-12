--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    Destroyable.lua
--]]

--- Class Destroyable
--- Superclass for managing an element life
local Destroyable = {}
Destroyable.__index = Destroyable

--- Creates a new Destroyable
--- Parameters
---   bbox      Element bounding box
---   life      Initial life
function Destroyable.create(bbox, life)
    local self = setmetatable({}, Destroyable)
    self.bbox = bbox
    self.total_life = life
    self.life = life
    return self
end

--- Hits the element
function Destroyable.hit(damage)
    self.life = self.life - damage
end

--- Returns whether the element is destroyed
function Destroyable.isDestroyed()
    return self.life <= 0
end

--- Sets the bounding box
function Destroyable.setBBox(bbox)
    self.bbox = bbox
end

--- Draws the life bar above the element
function Destroyable.draw()
    local base_w = 0.5 * self.bbox.w
    local w = base_w * (self.life / self.total_life)
    local h = 2
    local x = (self.bbox.x + self.bbox.w) / 2 - base_w
    local y = self.bbox.y - 10
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('fill', x, y, w, h)
end

return Destroyable
