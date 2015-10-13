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
local Player = require "Player"
local Ship = require "Ship"
local Stars = require "Stars"
local Window = require "Window"

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
    Ship.init()

    local self = Game._create()
    self.stars = Stars.create()
    self.allies = {}
    self.player = Player.create(function(projectile)
        self.allies[projectile] = true
    end)
    self.allies[self.player] = true
    self.enemies = {}
    self.explosions = {}
    self.gameover_font = love.graphics.newFont("data/zorque.ttf", 100)

    -- Asteroid launcher
    self.asteroid_time = 0
    self.asteroid_next = 0
    return self
end

--- Verifies the colisions between the allies and the enemies
function Game:computeColisions()
    for ally in pairs(self.allies) do
        for enemy in pairs(self.enemies) do
            if ally:getBBox():intersects(enemy:getBBox())
               and not ally:isDestroyed()
               and not enemy:isDestroyed() then
                ally:hit(enemy:getDamage())
                enemy:hit(ally:getDamage())
            end
        end
    end
end

--- Updates the game
function Game:update(dt)
    self.stars:update(dt)
    updateSet(self.allies, dt)
    updateSet(self.enemies, dt)
    updateSet(self.explosions, dt)
    self:computeColisions()

    -- Asteroid launcher
    self.asteroid_time = self.asteroid_time + dt
    if self.asteroid_time > self.asteroid_next then
        self.asteroid_time = 0
        self.asteroid_next = 0.5
        self.enemies[Asteroid.create()] = true
    end
end

--- Key pressed event
function Game:keypressed(key)
    if key == 'escape' then
        love.event.quit()
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

    if self.player:isDestroyed() then
        love.graphics.setColor(255, 255, 255)
        love.graphics.setFont(self.gameover_font)
        love.graphics.printf("Game Over", (Window.WIDTH - 500) / 2,
                -100 + Window.HEIGHT / 2, 500, 'center')
    end
end

return Game
