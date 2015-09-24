--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    stars.lua
--]]

--- Class Stars
--- Represent the stars moving in the background
local Stars = {}

--- Constants
local N_STARS = 250
local SPEED = 120

--- Creates a new star set
--- Parameters
---     width       Screen width
---     height      Screen height
function Stars.create(width, height)
    local self = {
        stars = {},
        width = width,
        height = height
    }

    for i = 0, N_STARS do
        table.insert(self.stars, {
            x = math.random(width),
            y = math.random(height)
        })
    end

    return setmetatable(self, {__index = Stars})
end

--- Updates the stars position based on the speed
--- Parameters
---     dt      Time elapsed in milliseconds
function Stars:update(dt)
    for _, star in ipairs(self.stars) do
        star.x = star.x - SPEED * dt

        -- If the star gets out of the screen reposition it at the begining
        if star.x < 0 then
            star.x = self.width
            star.y = math.random(self.height)
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

