--[[
    PUC-Rio
    INF1405 - Construção de Sistemas 2015.2
    Professor Edmundo Torreão
    Gabriel de Quadros Ligneul 1212560
    Exploradores de Andrômeda

    Class.lua
--]]

--- Function for creating classes
return function(super)
    -- Classes are tables of methods, called by the __index metatable field
    local class = {}
    class.__index = class

    if super then
        -- If a method is not found, search it in the super class
        setmetatable(class, super)

        -- Calls the super's class method
        function class:_super(...)
            local f = debug.getinfo(2, "n").name
            return super[f](self, ...)
        end
    end

    -- Creates an empty object
    function class._create(...)
        local o = {}
        if super then
            o = super.create(...)
        end
        return setmetatable(o, class)
    end

    return class
end
