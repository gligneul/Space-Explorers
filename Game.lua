--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    game.lua
--]]

local Asteroid = require "Asteroid"
local Explosion = require "Explosion"
local Player = require "Player"
local Stars = require "Stars"

--- Class Game
local Game = {}
Game.__index = Game

--- Auxiliary functions that updates a set
local function updateSet(set, dt)
    for e in pairs(set) do
        e:update(dt)
        if e:isDead() then
            set[e] = nil
        end
    end
end

--- Auxiliary function that draws a set
local function drawSet(set)
    for e in pairs(set) do
        e:draw()
    end
end

--- Returns wheter if there is a colision with the bbox and the set
local function hasColision(bbox, set)
    for e in pairs(set) do
        if bbox:intersects(e:getBBox()) then
            return true
        end
    end
    return false
end

--- Creates a new Game
function Game.create()
    Asteroid.init()
    Explosion.init()

    local player_projectiles = {}
    local function player_shoot_cb(projectile)
        player_projectiles[projectile] = true
    end

    local self = setmetatable({}, Game)
    self.stars = Stars.create()
    self.player = Player.create(player_shoot_cb)
    self.player_projectiles = player_projectiles
    self.enemies = {}
    self.explosions = {}
    return self
end

--- Verifies if something colides with the player
function Game:verifyPlayerColision()
    local player_bbox = self.player:getBBox()
    if hasColision(player_bbox, self.enemies) then
        self.explosions[Explosion.create(player_bbox)] = true
        self.player = nil
    end
end

--- Updates the game
function Game:update(dt)
    self.stars:update(dt)
    updateSet(self.player_projectiles, dt)
    updateSet(self.enemies, dt)
    updateSet(self.explosions, dt)
    if self.player then 
        self.player:update(dt)
        self:verifyPlayerColision()
    end
end

--- Key pressed event
function Game:keypressed(key)
    if key == 'escape' then
        love.event.quit()

    elseif key == 'a' then
        self.enemies[Asteroid.create()] = true

    end
    if self.player then self.player:keypressed(key) end
end

--- Key released event
function Game:keyreleased(key)
    if self.player then self.player:keyreleased(key) end
end

-- Draws the game
function Game:draw()
    self.stars:draw()
    drawSet(self.player_projectiles)
    drawSet(self.enemies)
    drawSet(self.explosions)
    if self.player then self.player:draw() end
end

return Game
