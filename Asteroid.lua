--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    Asteroid.lua
--]]

local Animation = require "Animation"
local Class = require "Class"
local Destroyable = require "Destroyable"
local Rectangle = require "Rectangle"
local Window = require "Window"

--- Class Asteroid
--- Represents an asteroid projectile
local Asteroid = Class(Destroyable)

--- Constants
Asteroid.ANIMATION_DT = 0.07
Asteroid.BASE_LIFE = 100

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
    local scale = math.random(600, 1000) / 1000
    local life = Asteroid.BASE_LIFE * scale
    local self = Asteroid._create(life)
    self.w = Asteroid.default_width * scale
    self.h = Asteroid.default_height * scale
    self.x = Window.WIDTH + self.w
    self.y = math.random(Window.HEIGHT)
    self.images = Asteroid.images[math.random(#Asteroid.images)]
    self.alpha = 0
    self.speed = math.random(150, 300)
    self.rotation_speed = (math.pi / 18) * math.random(2, 8)
            * (math.random(2) == 1 and 1 or -1)
    self.animation = Animation.create(self.images, Asteroid.ANIMATION_DT,
                'repeat', self.x, self.y, self.alpha, scale)
    return self
end

--- Returns whether the projectile is offscreen
function Asteroid:isDead()
    return self.x < -self.w
end

--- Obtains the asteroidbounding box
function Asteroid:getBBox()
    return Rectangle.create(self.x - self.w / 2, self.y - self.h / 2,
            self.w, self.h)
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
    local bbox = self:getBBox()
    self.animation:draw()
    self:_super(bbox)
end

return Asteroid
