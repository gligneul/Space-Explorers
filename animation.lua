--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    animation.lua
--]]

--- Class Animation
local Animation = {}
Animation.__index = Animation

--- Loads the animation's images/frames
---   prefix    Images path prefix
---   suffix    Images path suffix
---   n_images  Number of images/frames
function Animation.loadImages(prefix, suffix, n_images)
    local images = {}
    for i = 1, n_images do
        local path = prefix .. i .. suffix
        local image = love.graphics.newImage(path)
        table.insert(images, image)
    end
    return images
end

--- Creates an new Animation
--- Parameters
---   frames    Sequence with the images/frames
---   frame_dt  Duration of each frame
---   mode      Animation mode: 'repeat' or 'once'
---   x         Initial x position
---   y         Initial y position
---   alpha     Image orientation
---   scale     Images scale
function Animation.create(frames, frame_dt, mode, x, y, alpha, scale)
    assert(frames ~= nil, "Frames cannot be null")
    assert(mode == 'repeat' or mode == 'once', "Invalid mode")
    local self = setmetatable({}, Animation)
    self.frames = frames
    self.frame_dt = frame_dt
    self.time = 0
    self.mode = mode
    self.x = x
    self.y = y
    self.alpha = alpha
    self.scale = scale
    self.origin = frames[1]:getWidth() / 2
    return self
end

--- Obtains the current animation frame
function Animation:getFrameNumber()
    return math.ceil(self.time / self.frame_dt)
end

--- Returns whether the animation is over (only for non-repeating animations)
function Animation:isDead()
    return self:getFrameNumber() > #self.frames
end

--- Sets the rotation
---   alpha     new Rotation
function Animation:setOrientation(alpha)
    self.alpha = alpha
end

--- Sets the position
---   x         Horizontal position (can be nil)
---   y         Vertical position (can be nil)
function Animation:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

--- Updates the time
--- Parameters
---   dt      Time elapsed in milliseconds
function Animation:update(dt)
    self.time = self.time + dt
end

--- Draws the current frame
function Animation:draw()
    if self.mode == 'repeat' or not self:isDead() then
        love.graphics.setColor(255, 255, 255)
        local frame_number = self:getFrameNumber()
        local frame = self.frames[1 + (frame_number - 1) % #self.frames]
        love.graphics.draw(frame, self.x, self.y, self.alpha, self.scale, 
                self.scale, self.origin, self.origin)
    end
end

return Animation
