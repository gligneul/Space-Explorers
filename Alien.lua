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
local Vector = require "Vector"
local Window = require "Window"

--- Class Alien
local Alien = Class(Ship)

--- Constants
Alien.LIFE = 200
Alien.SPEED_LIMIT = 150
Alien.ACCELERATION = 200
Alien.IMAGE_PATH = "data/alien.png"
Alien.SCORE = 1000
Alien.SHOOT_INTERVAL = 0.5
Alien.MAX_DISTANCE = 100

--- Creates a new Alien
--- Parameters
---   shootCallback Function that will be called when the alien shoot
---   player        The player that the alien will fight against
function Alien.create(shootCallback, player)
    local image = love.graphics.newImage(Alien.IMAGE_PATH)
    local image_w, image_h = image:getWidth(), image:getHeight()
    local x = Window.WIDTH + image_w
    local y = math.random(Window.HEIGHT - image_h)
    local self = Alien._create(x, y, nil, nil, 0, Window.HEIGHT - image_h,
            Alien.SPEED_LIMIT, Alien.ACCELERATION, Alien.LIFE, image)
    self.player = player
    self.shootCallback = shootCallback
    self.shoot_time = 0
    self.stop_moving = false
    self:setXForce(-1)
    return self
end

--- Defines the alien moviment
function Alien:moviment(dt)
    local bbox = self:getBBox()
    local player_bbox = self.player:getBBox()

    -- Horizontal moviment
    if not self.stop_moving and bbox.x < 850 then
        self.stop_moving = true
        self:setXForce(0)
    end

    -- Vertical moviment
    local player_center = player_bbox.y + player_bbox.h / 2
    local ship_center = bbox.y + bbox.h / 2
    local distance = player_center - ship_center
    if math.abs(distance) > Alien.MAX_DISTANCE then
        if distance < 0 then
            self:setYForce(-1)
        else
            self:setYForce(1)
        end
    else
        self:setYForce(0)
    end
end

--- Creates a alien's projectile
function Alien:createProjectile()
    local player_bbox = self.player:getBBox()
    local player_center = Vector.create(player_bbox.x + player_bbox.w / 2,
            player_bbox.y + player_bbox.h / 2)
    local bbox = self:getBBox()
    local x, y = bbox.x, bbox.y + bbox.h / 2
    local position = Vector.create(x, y)
    local direction = (player_center - position):normalize()
    return LaserBeam.create(x, y, direction, {255, 0, 0})
end

--- Shoots projectiles
function Alien:shoot(dt)
    if not self:isDestroyed() then
        self.shoot_time = self.shoot_time + dt
        if self.shoot_time > Alien.SHOOT_INTERVAL then
            self.shoot_time = self.shoot_time - Alien.SHOOT_INTERVAL
            local projectile = self:createProjectile()
            self.shootCallback(projectile)
        end
    end
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
    self:moviment(dt)
    self:shoot(dt)
end

return Alien
