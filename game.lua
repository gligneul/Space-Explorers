--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    game.lua
--]]

local Asteroid = require "asteroid"
local Explosion = require "explosion"
local Player = require "player"
local Stars = require "stars"
local Window = require "window"

-- Class Game
local Game = {}

-- Auxiliary functions that updates a set
local function updateSet(set, dt)
    for e in pairs(set) do
        e:update(dt)
        if e:isDead() then
            set[e] = nil
        end
    end
end

-- Auxiliary function that draws a set
local function drawSet(set)
    for e in pairs(set) do
        e:draw()
    end
end

-- Creates a new Game
function Game.create()
    Asteroid.init()
    Explosion.init()

    local player_projectiles = {}
    local function player_shoot_cb(projectile)
        player_projectiles[projectile] = true
    end

    local self = {
        stars = Stars.create(),
        player = Player.create(Window.WIDTH, Window.HEIGHT, player_shoot_cb),
        player_projectiles = player_projectiles,
        enemies = {},
        explosions = {}
    }
    return setmetatable(self, {__index = Game})
end

-- Updates the game
function Game:update(dt)
    self.stars:update(dt)
    updateSet(self.player_projectiles, dt)
    updateSet(self.enemies, dt)
    updateSet(self.explosions, dt)
    self.player:update(dt)
end

-- Key pressed event
function Game:keypressed(key)
    if key == 'escape' then
        love.event.quit()

    elseif key == 'a' then
        self.enemies[Asteroid.create()] = true

    end
    self.player:keypressed(key)
end

-- Key released event
function Game:keyreleased(key)
    self.player:keyreleased(key)
end

-- Draws the game
function Game:draw()
    self.stars:draw()
    drawSet(self.player_projectiles)
    drawSet(self.enemies)
    drawSet(self.explosions)
    self.player:draw()
end

return Game
