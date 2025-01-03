<<<<<<< HEAD
local S = essentials.translate
local defs = {
    {
        hud_elem_type = "image",
        position  = {x = 0.02, y = 0.035},
        offset    = {x = 0, y = 0},
        text      = "essentials_logo.png",
        scale     = { x = 1, y = 1},
        alignment = { x = 0, y = 0 },
    },
    {
        hud_elem_type = "text",
        position  = {x = 0.055, y = 0.0145},
        offset    = {x = 0, y = 0},
        text      = S("Essentials"),
        alignment = -1,
        scale     = { x = 50, y = 10},
        number    = 0x00FFFF,
    },
    {
        hud_elem_type = "text",
        position  = {x = 0.081, y = 0.03},
        offset    = {x = 0, y = 0},
        text      = S("Powered and created by"),
        alignment = -1,
        scale     = { x = 50, y = 10},
        number    = 0xFFFFFF,
    },
    {
        hud_elem_type = "text",
        position  = {x = 0.075, y = 0.047},
        offset    = {x = 0, y = 0},
        text      = "SkyBuilder1717",
        alignment = -1,
        scale     = { x = 50, y = 10},
        number    = 0x00FF00,
    }
}
local hud

if essentials.watermark then
    minetest.register_on_joinplayer(function(player)
        for i, def in pairs(defs) do
            hud = player:hud_add(def)
        end
    end)
end

--[[
minetest.register_on_leaveplayer(function(player)
    for i, def in pairs(defs) do
        player:hud_remove(def)
    end
end)
=======
local S = essentials.translate
local defs = {
    {
        hud_elem_type = "image",
        position  = {x = 0.02, y = 0.035},
        offset    = {x = 0, y = 0},
        text      = "essentials_logo.png",
        scale     = { x = 1, y = 1},
        alignment = { x = 0, y = 0 },
    },
    {
        hud_elem_type = "text",
        position  = {x = 0.055, y = 0.0145},
        offset    = {x = 0, y = 0},
        text      = S("Essentials"),
        alignment = -1,
        scale     = { x = 50, y = 10},
        number    = 0x00FFFF,
    },
    {
        hud_elem_type = "text",
        position  = {x = 0.081, y = 0.03},
        offset    = {x = 0, y = 0},
        text      = S("Powered and created by"),
        alignment = -1,
        scale     = { x = 50, y = 10},
        number    = 0xFFFFFF,
    },
    {
        hud_elem_type = "text",
        position  = {x = 0.075, y = 0.047},
        offset    = {x = 0, y = 0},
        text      = "SkyBuilder1717",
        alignment = -1,
        scale     = { x = 50, y = 10},
        number    = 0x00FF00,
    }
}
local hud

if essentials.watermark then
    minetest.register_on_joinplayer(function(player)
        for i, def in pairs(defs) do
            hud = player:hud_add(def)
        end
    end)
end

--[[
minetest.register_on_leaveplayer(function(player)
    for i, def in pairs(defs) do
        player:hud_remove(def)
    end
end)
>>>>>>> 46b4032d79edf22a60b1f30c2835b9369e30fba1
]]--