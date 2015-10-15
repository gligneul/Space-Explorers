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

--- Constants
Game.FONT_PATH = "data/zorque.ttf"
Game.FONTS_SIZES = {8, 16, 24, 32, 64, 128}

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

--- Initializes the game and creates the unique isntance
function Game.init()
    Asteroid.init()
    Ship.init()
    Game.instance = Game.create()
end

--- Creates a new Game
function Game.create()
    local self = Game._create()
    self.stars = Stars.create()
    self.allies = {}
    self.player = Player.create(function(projectile)
        self.allies[projectile] = true
    end)
    self.allies[self.player] = true
    self.enemies = {}
    self.explosions = {}
    self.asteroid_time = 0
    self.font = {}
    self.score = 0
    for _, size in ipairs(Game.FONTS_SIZES) do
        self.font[size] = love.graphics.newFont(Game.FONT_PATH, size)
    end
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

                if enemy:isDestroyed() then
                    self.score = self.score + enemy:getScore()
                end
            end
        end
    end
end

--- Launch asteroids
function Game:launchAsteroids(dt)
    self.asteroid_time = self.asteroid_time + dt
    if self.asteroid_time > 2 then
        self.asteroid_time = 0
        self.enemies[Asteroid.create()] = true
    end
end

--- Updates the game
function Game:update(dt)
    self.stars:update(dt)
    updateSet(self.allies, dt)
    updateSet(self.enemies, dt)
    updateSet(self.explosions, dt)
    self:computeColisions()
    self:launchAsteroids(dt)
end

--- Key pressed event
function Game:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if not self.player:isDestroyed() then
        self.player:keypressed(key)
    else
        if key == 'return' then
            Game.instance = Game.create()
        end
    end
end

--- Key released event
function Game:keyreleased(key)
    self.player:keyreleased(key)
end

--- Draws the current player score
function Game:drawScore()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(self.font[32])
    love.graphics.print("Score: " .. self.score, 30, 30)
end

--- Draws the game over screen
function Game:drawGameOver()
    local w = Window.WIDTH
    local h = Window.HEIGHT
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(self.font[128])
    love.graphics.printf("Game Over", 0, -64 + h / 2, w, 'center')
    love.graphics.setFont(self.font[64])
    love.graphics.printf("Score: " .. self.score, 0, 80 + h / 2, w, 'center')
    love.graphics.setFont(self.font[32])
    love.graphics.printf("Press return to play again...", 0, 170 + h / 2, w,
            'center')
end

-- Draws the game
function Game:draw()
    self.stars:draw()
    drawSet(self.allies)
    drawSet(self.enemies)
    drawSet(self.explosions)

    if not self.player:isDestroyed() then
        self:drawScore()
    else
        self:drawGameOver()
    end
end

return Game
