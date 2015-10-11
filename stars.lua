--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    stars.lua
--]]

local Window = require "window"

--- Class Stars
--- Represent the stars moving in the background
local Stars = {}
Stars.__index = Stars

--- Constants
Stars.N_STARS = 250
Stars.SPEED = 120

--- Creates a new star set
function Stars.create()
    local self = setmetatable({}, Stars)
    self.stars = {}
    for i = 0, Stars.N_STARS do
        table.insert(self.stars, {
            x = math.random(Window.WIDTH),
            y = math.random(Window.HEIGHT)
        })
    end
    return self
end

--- Updates the stars position based on the speed
--- Parameters
---     dt      Time elapsed in milliseconds
function Stars:update(dt)
    for _, star in ipairs(self.stars) do
        star.x = star.x - Stars.SPEED * dt

        -- If the star gets out of the screen reposition it at the begining
        if star.x < 0 then
            star.x = Window.WIDTH
            star.y = math.random(Window.HEIGHT)
        end
    end
end

--- Draws the stars 
function Stars:draw()
    love.graphics.setColor(255, 255, 255)
    for _, star in ipairs(self.stars) do
        love.graphics.point(star.x, star.y)
    end
end

return Stars

