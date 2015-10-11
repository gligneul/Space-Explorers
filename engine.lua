--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    engine.lua
--]]

--- Class Engine
--- It is used to control the spaceship position and speed in a single axis.
--- For instance, in the 2d world, it is necessary two engines: a vertical one
--- and a horizontal one.
local Engine = {}
Engine.__index = Engine

--- Auxiliary Function that clamps a value to a range
local function clampValue(x, min, max)
    if x > max then
        x = max
    elseif x < min then
        x = min
    end
    return x
end

--- Creates a new Engine
--- Parameters
---   p       Initial position
---   pmin    Minimum position
---   pmax    Maximum position
---   slimit  Speed absolute maximum
---   a       Acceleration constant
function Engine.create(p, pmin, pmax, slimit, a)
    local self = setmetatable({}, Engine)
    self.p = p
    self.pmin = pmin
    self.pmax = pmax
    self.s = 0
    self.slimit = slimit
    self.a = a
    self.f = 0
    return self
end

--- Updates the engine position by applying a force on it
--- Parameters
---   dt      Time elapsed in milliseconds
function Engine:update(dt)
    local f = self.f
    local smin, smax = -self.slimit, self.slimit

    -- Apply inverse force if the engine is moving without a force being aplied
    if f == 0 then
        if self.s < 0 then
            f = 1
            smax = 0
        elseif self.s > 0 then
            f = -1
            smin = 0
        end
    end

    -- Updates speed and position
    local a = f * self.a
    self.s = self.s + a * dt
    self.s = clampValue(self.s, smin, smax)
    self.p = self.p + self.s * dt
    self.p = clampValue(self.p, self.pmin, self.pmax)
end

--- Adds f to the current force
function Engine:addForce(f)
    self.f = self.f + f
end

--- Obtains the position of the engine
function Engine:getPosition()
    return self.p
end

return Engine
