--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    asteroid.lua
--]]

local Window = require "window"
local Animation = require "animation"

--- Class Asteroid
--- Represents an asteroid projectile
local Asteroid = {}

--- Constants
Asteroid.ANIMATION_DT = 0.07

--- Initializes the shared data (animation)
function Asteroid.init()
    Asteroid.images = {}
    Asteroid.images[1] = Animation.loadImages("data/asteroid_a_", ".png", 31)
    Asteroid.images[2] = Animation.loadImages("data/asteroid_b_", ".png", 31)
    Asteroid.default_width = Asteroid.images[1][1]:getWidth()
end

--- Creates an asteroid at random position
function Asteroid.create()
    local images = Asteroid.images[math.random(#Asteroid.images)]
    local scale = math.random(400, 1200) / 1000
    local width = Asteroid.default_width * scale
    local speed = math.random(150, 300)
    local rotation_speed = (math.pi / 18)
            * math.random(2, 8) * (math.random(2) == 1 and 1 or -1)
    local x, y = Window.WIDTH + width, math.random(Window.HEIGHT)
    local animation = Animation.create(images, Asteroid.ANIMATION_DT,
                'repeat', x, y, 0, scale)

    local self = {
        x = x, width = width, speed = speed, alpha = 0,
        rotation_speed = rotation_speed, animation = animation
    }
    return setmetatable(self, {__index = Asteroid})
end

--- Returns whether the projectile is offscreen
function Asteroid:isDead()
    return self.x < -self.width
end

--- Updates the asteroid position
--- Parameters
---   dt      Time elapsed in milliseconds
function Asteroid:update(dt)
    self.x = self.x - self.speed * dt
    self.alpha = self.alpha + self.rotation_speed * dt
    self.animation:setPosition(self.x)
    self.animation:setOrientation(self.alpha)
    self.animation:update(dt)
end

--- Draws the asteroid
function Asteroid:draw()
    self.animation:draw()
end

return Asteroid
