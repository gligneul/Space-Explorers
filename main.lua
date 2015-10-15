--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    main.lua
--]]

local Game = require "Game"
local Window = require "Window"

function love.load()
    Game.init()
    love.window.setMode(Window.WIDTH, Window.HEIGHT)
end

function love.draw()
    Game.instance:draw()
end

function love.update(dt)
    Game.instance:update(dt)
end

function love.keypressed(key)
   Game.instance:keypressed(key)
end

function love.keyreleased(key)
    Game.instance:keyreleased(key)
end

