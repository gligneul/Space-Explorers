--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    Alien.lua
--]]

local Class = require "Class"
local LaserBeam = require "LaserBeam"
local Ship = require "Ship"
local Window = require "Window"

--- Class Alien
local Alien = Class(Ship)

--- Constants
Alien.LIFE = 200
Alien.SPEED_LIMIT = 200
Alien.ACCELERATION = 200
Alien.IMAGE_PATH = "data/alien.png"
Alien.SCORE = 1000

--- Creates a new Alien
--- Parameters
---   shootCallback Function that will be called when the alien shoot
---   player        The player that the alien will fight against
function Alien.create(shootCallback, player)
    local image = love.graphics.newImage(Alien.IMAGE_PATH)
    local image_w, image_h = image:getWidth(), image:getHeight()
    local x = Window.WIDTH + image_w
    local y = math.random(Window.HEIGHT - image_h)
    local self = Alien._create(x, y, 850, nil, nil, nil, Alien.SPEED_LIMIT,
            Alien.ACCELERATION, Alien.LIFE, image)
    self.shootCallback = shootCallback
    self.player = player
    self:addXForce(-1)
    return self
end

--- Returns the score earned after destroying the element
function Alien:getScore()
    return Alien.SCORE
end

--- Updates the ship position
--- Parameters
---   dt      Time elapsed in milliseconds
function Alien:update(dt)
    Ship.update(self, dt)
end

return Alien
