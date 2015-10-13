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
local SpaceElement = require "SpaceElement"
local Rectangle = require "Rectangle"
local Window = require "Window"

--- Class Asteroid
--- Represents an asteroid projectile
local Asteroid = Class(SpaceElement)

--- Constants
Asteroid.LIFE = 300
Asteroid.DAMAGE = 99999
Asteroid.ANIMATION_DT = 0.07
Asteroid.EXPLOSION_DT = 0.02

--- Initializes the shared data (animation)
function Asteroid.init()
    Asteroid.images = {}
    Asteroid.images[1] = Animation.loadImages("data/asteroid_a_", ".png", 31)
    Asteroid.images[2] = Animation.loadImages("data/asteroid_b_", ".png", 31)
    Asteroid.default_width = Asteroid.images[1][1]:getWidth()
    Asteroid.default_height = Asteroid.images[1][1]:getHeight()
    Asteroid.explosion_images = Animation.loadImages(
            "data/asteroid_explosion_", ".png", 25)
    Asteroid.explosion_width = Asteroid.explosion_images[1]:getWidth()
end

--- Creates an asteroid at random position
function Asteroid.create()
    local scale = math.random(300, 600) / 1000
    local life = Asteroid.LIFE * scale
    local images = Asteroid.images[math.random(#Asteroid.images)]
    local self = Asteroid._create(life, Asteroid.DAMAGE)
    self.w = Asteroid.default_width * scale
    self.h = Asteroid.default_height * scale
    self.x = Window.WIDTH + self.w
    self.y = math.random(Window.HEIGHT)
    self.alpha = 0
    self.speed = math.random(100, 200)
    self.rotation_speed = (math.pi / 18) * math.random(2, 8)
            * (math.random(2) == 1 and 1 or -1)
    self.animation = Animation.create(images, Asteroid.ANIMATION_DT,
            'repeat', self.x, self.y, self.alpha, scale)
    self.explosion = Animation.create(Asteroid.explosion_images,
            Asteroid.EXPLOSION_DT, 'once', 0, 0, 0,
            self.w / Asteroid.explosion_width)
    return self
end

--- Returns whether the projectile is offscreen
function Asteroid:isOffscreen()
    return self.x < -self.w or self.explosion:isOver()
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
    if not self:isDestroyed() then
        self.x = self.x - self.speed * dt
        self.alpha = self.alpha + self.rotation_speed * dt
        self.animation:setPosition(self.x)
        self.animation:setOrientation(self.alpha)
        self.animation:update(dt)
    else
        self.explosion:setPosition(self.x, self.y)
        self.explosion:update(dt)
    end
end

--- Draws the asteroid
function Asteroid:draw()
    if not self:isDestroyed() then
        self.animation:draw()
        SpaceElement.draw(self)
    else
        self.explosion:draw()
    end
end

return Asteroid
