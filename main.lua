--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    main.lua
--]]

local Player = require "player"
local Stars = require "stars"

--- Constants
local WIDTH = 1280
local HEIGHT = 720

local stars
local player
local player_projectiles = {}

local function playerShootCallback(projectile)
    table.insert(player_projectiles, projectile)
end

function love.load()
    stars = Stars.create(WIDTH, HEIGHT)
    player = Player.create(WIDTH, HEIGHT, playerShootCallback)
    love.window.setMode(WIDTH, HEIGHT)
end

function love.draw()
    stars:draw()
    for _, p in pairs(player_projectiles) do
        p:draw()
    end
    player:draw()
end

function love.update(dt)
    stars:update(dt)
    for _, p in ipairs(player_projectiles) do
        p:update(dt)
    end
    player:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    player:keypressed(key)
end

function love.keyreleased(key)
    player:keyreleased(key)
end

