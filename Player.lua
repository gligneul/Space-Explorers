--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    player.lua
--]]

local Ship = require "Ship"
local LaserBeam = require "LaserBeam"
local Window = require "Window"

--- Class Player
--- Represents the player of the game
local Player = {}
Player.__index = Player

--- Constants
local SPEED_LIMIT = 200
local ACCELERATION = 1000
local IMAGE_PATH = "data/player.png"
local KEY_UP = 'k'
local KEY_DOWN = 'j'
local KEY_LEFT = 'l'
local KEY_RIGHT = 'h'
local KEY_SHOOT = ' '

--[[ Uncomment for arrow keys constants:
local KEY_UP = 'up'
local KEY_DOWN = 'down'
local KEY_LEFT = 'left'
local KEY_RIGHT = 'right'
--]]

--- Creates a new Player
--- Parameters
---   shootCallback Function that will be called when the player shoot
function Player.create(shootCallback)
    local image = love.graphics.newImage(IMAGE_PATH)
    local image_w, image_h = image:getWidth(), image:getHeight()
    local self = setmetatable({}, Player)
    self.ship = Ship.create(50, Window.HEIGHT / 2, 0, Window.WIDTH- image_w, 0,
                Window.HEIGHT - image_h, SPEED_LIMIT, ACCELERATION, image)
    self.shootCallback = shootCallback
    return setmetatable(self, Player)
end

--- Obtains the player bounding box
function Player:getBBox()
    return self.ship:getBBox()
end

--- Updates the player position
--- Parameters
---   dt      Time elapsed in milliseconds
function Player:update(dt)
    self.ship:update(dt)
end

--- Moves the ship based on the key pressed
--- Parameters
---   key       Key pressed
function Player:keypressed(key)
    if key == KEY_UP then
        self.ship:addYForce(-1)
    elseif key == KEY_DOWN then
        self.ship:addYForce(1)
    elseif key == KEY_RIGHT then
        self.ship:addXForce(-1)
    elseif key == KEY_LEFT then
        self.ship:addXForce(1)
    elseif key == KEY_SHOOT then
        local bbox = self.ship:getBBox()
        local x, y = bbox.x, bbox.y + bbox.h / 2
        local laser = LaserBeam.create(x, y, 'right', {0, 255, 0})
        self.shootCallback(laser)
    end
end

--- Stops the ship based on the key released
--- Parameters
---   key       Key released
function Player:keyreleased(key)
    if key == KEY_UP then
        self.ship:addYForce(1)
    elseif key == KEY_DOWN then
        self.ship:addYForce(-1)
    elseif key == KEY_RIGHT then
        self.ship:addXForce(1)
    elseif key == KEY_LEFT then
        self.ship:addXForce(-1)
    end
end

--- Draws the player
function Player:draw()
    self.ship:draw()
end

return Player
