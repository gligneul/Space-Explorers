--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    Player.lua
--]]

local Class = require "Class"
local LaserBeam = require "LaserBeam"
local Ship = require "Ship"
local Window = require "Window"

--- Class Player
--- Represents the player of the game
local Player = Class(Ship)

--- Constants
Player.LIFE = 500
Player.SPEED_LIMIT = 200
Player.ACCELERATION = 1000
Player.IMAGE_PATH = "data/player.png"
Player.KEY_UP = 'k'
Player.KEY_DOWN = 'j'
Player.KEY_LEFT = 'l'
Player.KEY_RIGHT = 'h'
Player.KEY_SHOOT = ' '

--[[ Uncomment for arrow keys controls:
local KEY_UP = 'up'
local KEY_DOWN = 'down'
local KEY_LEFT = 'left'
local KEY_RIGHT = 'right'
--]]

--- Creates a new Player
--- Parameters
---   shootCallback Function that will be called when the player shoot
function Player.create(shootCallback)
    local image = love.graphics.newImage(Player.IMAGE_PATH)
    local image_w, image_h = image:getWidth(), image:getHeight()
    local self = Player._create(50, Window.HEIGHT / 2, 0,
            Window.WIDTH - image_w, 0, Window.HEIGHT - image_h,
            Player.SPEED_LIMIT, Player.ACCELERATION, Player.LIFE, image)
    self.shootCallback = shootCallback
    return self
end

--- Moves the ship based on the key pressed
--- Parameters
---   key       Key pressed
function Player:keypressed(key)
    if key == Player.KEY_UP then
        self:addYForce(-1)
    elseif key == Player.KEY_DOWN then
        self:addYForce(1)
    elseif key == Player.KEY_RIGHT then
        self:addXForce(-1)
    elseif key == Player.KEY_LEFT then
        self:addXForce(1)
    elseif key == Player.KEY_SHOOT then
        local bbox = self:getBBox()
        local x, y = bbox.x + bbox.w, bbox.y + bbox.h / 2
        local laser = LaserBeam.create(x, y, 'right', {0, 255, 0})
        self.shootCallback(laser)
    end
end

--- Stops the ship based on the key released
--- Parameters
---   key       Key released
function Player:keyreleased(key)
    if key == Player.KEY_UP then
        self:addYForce(1)
    elseif key == Player.KEY_DOWN then
        self:addYForce(-1)
    elseif key == Player.KEY_RIGHT then
        self:addXForce(1)
    elseif key == Player.KEY_LEFT then
        self:addXForce(-1)
    end
end

return Player
