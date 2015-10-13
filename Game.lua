--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    Game.lua
--]]

local Asteroid = require "Asteroid"
local Class = require "Class"
local Explosion = require "Explosion"
local Player = require "Player"
local Stars = require "Stars"

--- Class Game
local Game = Class()

--- Auxiliary functions that updates a set
local function updateSet(set, dt)
    for e in pairs(set) do
        e:update(dt)
        if e:isOffscreen() then
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

--- Creates a new Game
function Game.create()
    Asteroid.init()
    Explosion.init()

    local self = Game._create()
    self.stars = Stars.create()
    self.allies = {}
    self.player = Player.create(function(projectile)
        self.allies[projectile] = true
    end)
    self.allies[self.player] = true
    self.enemies = {}
    self.explosions = {}
    return self
end

--- Verifies the colisions between the allies and the enemies
function Game:computeColisions()
end

--- Updates the game
function Game:update(dt)
    self.stars:update(dt)
    updateSet(self.allies, dt)
    updateSet(self.enemies, dt)
    updateSet(self.explosions, dt)
    self:computeColisions()

    if self.player:isDestroyed() then
        print("Game Over!")
    end
end

--- Key pressed event
function Game:keypressed(key)
    if key == 'escape' then
        love.event.quit()

    elseif key == 'a' then
        self.enemies[Asteroid.create()] = true

    end
    self.player:keypressed(key)
end

--- Key released event
function Game:keyreleased(key)
    self.player:keyreleased(key)
end

-- Draws the game
function Game:draw()
    self.stars:draw()
    drawSet(self.allies)
    drawSet(self.enemies)
    drawSet(self.explosions)
end

return Game
