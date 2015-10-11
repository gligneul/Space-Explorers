--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    main.lua
--]]

local Game = require "game"
local Window = require "window"

--- Game engine
local game

function love.load()
    game = Game.create()
    love.window.setMode(Window.WIDTH, Window.HEIGHT)
end

function love.draw()
    game:draw()
end

function love.update(dt)
    game:update(dt)
end

function love.keypressed(key)
    game:keypressed(key)
end

function love.keyreleased(key)
    game:keyreleased(key)
end

