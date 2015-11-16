--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    Pirate.lua
--]]

local Class = require "Class"
local LaserBeam = require "LaserBeam"
local Ship = require "Ship"
local Vector = require "Vector"
local Window = require "Window"

--- Class Pirate
local Pirate = Class(Ship)

--- Constants
Pirate.LIFE = 150
Pirate.SPEED_LIMIT = 150
Pirate.ACCELERATION = 150
Pirate.IMAGE_PATH = "data/pirate.png"
Pirate.SCORE = 500
Pirate.MIN_X = 700
Pirate.RELOAD_INTERVAL = 1.0
Pirate.SHOOT_INTERVAL = 2.0
Pirate.PROJECTILE_INTERVAL = 0.2

--- Creates a new Pirate
--- Parameters
---   shootCallback Function that will be called when the pirate shoot
---   player        The player that the pirate will fight against
function Pirate.create(shootCallback, player)
    local image = love.graphics.newImage(Pirate.IMAGE_PATH)
    local image_w, image_h = image:getWidth(), image:getHeight()
    local x = Window.WIDTH + image_w
    local y = math.random(Window.HEIGHT - image_h)
    local self = Pirate._create(x, y, nil, nil, 0, Window.HEIGHT - image_h,
            Pirate.SPEED_LIMIT, Pirate.ACCELERATION, Pirate.LIFE, image)
    self.player = player
    self.shootCallback = shootCallback
    self.shoot_coroutine = coroutine.create(Pirate.shoot)
    self:setXForce(-1)
    self:setYForce(-1)
    return self
end

--- Defines the pirate moviment
function Pirate:moviment(dt)
    local bbox = self:getBBox()
    local player_bbox = self.player:getBBox()

    -- Horizontal moviment
    if bbox.x < Pirate.MIN_X then
        self:setXForce(1)
    elseif bbox.x > Window.WIDTH - 2 * self.image:getWidth() then
        self:setXForce(-1)
    end

    -- Vertical moviment
    if bbox.y < self.image:getHeight() then
        self:setYForce(1)
    elseif bbox.y > Window.HEIGHT - 2 * self.image:getHeight() then
        self:setYForce(-1)
    end
end

--- Creates a pirate's projectile
function Pirate:createProjectile()
    local bbox = self:getBBox()
    local x, y = bbox.x, bbox.y + bbox.h / 2
    local dir_x = - bbox.x
    local dir_y = math.random(Window.HEIGHT) - bbox.y
    local direction = Vector.create(dir_x, dir_y):normalize()
    return LaserBeam.create(x, y, direction, {255, 0, 0})
end

--- Shoots projectiles
function Pirate:shoot(dt)
    while not self:isDestroyed() do
        local reload_time = 0
        while reload_time < Pirate.RELOAD_INTERVAL do
            self, dt = coroutine.yield()
            reload_time = reload_time + dt
        end
        local shoot_time = 0
        while shoot_time < Pirate.SHOOT_INTERVAL do
            local projectile_time = 0
            while projectile_time < Pirate.PROJECTILE_INTERVAL do
                self, dt = coroutine.yield()
                shoot_time = shoot_time + dt
                projectile_time = projectile_time + dt
            end
            local projectile = self:createProjectile()
            self.shootCallback(projectile)
        end
    end
end

--- Returns the score earned after destroying the element
function Pirate:getScore()
    return Pirate.SCORE
end

--- Updates the ship position
--- Parameters
---   dt      Time elapsed in milliseconds
function Pirate:update(dt)
    Ship.update(self, dt)
    self:moviment(dt)
    --coroutine.resume(self.shoot_coroutine, self, dt)
    local status, err = coroutine.resume(self.shoot_coroutine, self, dt)
    if not status then print(err) end
end

return Pirate
