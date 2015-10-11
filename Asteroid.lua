--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    asteroid.lua
--]]

local Animation = require "Animation"
local Rectangle = require "Rectangle"
local Window = require "Window"

--- Class Asteroid
--- Represents an asteroid projectile
local Asteroid = {}
Asteroid.__index = Asteroid

--- Constants
Asteroid.ANIMATION_DT = 0.07

--- Initializes the shared data (animation)
function Asteroid.init()
    Asteroid.images = {}
    Asteroid.images[1] = Animation.loadImages("data/asteroid_a_", ".png", 31)
    Asteroid.images[2] = Animation.loadImages("data/asteroid_b_", ".png", 31)
    Asteroid.default_width = Asteroid.images[1][1]:getWidth()
    Asteroid.default_height = Asteroid.images[1][1]:getHeight()
end

--- Creates an asteroid at random position
function Asteroid.create()
    local self = setmetatable({}, Asteroid)
    self.images = Asteroid.images[math.random(#Asteroid.images)]
    self.scale = math.random(400, 1200) / 1000
    self.width = Asteroid.default_width * self.scale
    self.height = Asteroid.default_height * self.scale
    self.x = Window.WIDTH + self.width
    self.y = math.random(Window.HEIGHT)
    self.alpha = 0
    self.speed = math.random(150, 300)
    self.rotation_speed = (math.pi / 18) * math.random(2, 8)
            * (math.random(2) == 1 and 1 or -1)
    self.animation = Animation.create(self.images, Asteroid.ANIMATION_DT,
                'repeat', self.x, self.y, self.alpha, self.scale)
    return self
end

--- Returns whether the projectile is offscreen
function Asteroid:isDead()
    return self.x < -self.width
end

--- Obtains the asteroidbounding box
function Asteroid:getBBox()
    return Rectangle.create(self.x - self.width / 2, self.y - self.height / 2,
            self.width, self.height)
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
