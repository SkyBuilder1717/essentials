--local S = minetest.get_translator("simple_edit")
local S = minetest.get_translator("essentials")

local function set_the_block(name, param)
    local p = {}
    local player = minetest.get_player_by_name(name);
    local block = ""
    local pos = player:get_pos();
    p.x, p.y, p.z, block = string.match(param, "^([%d.~-]+)[, ] *([%d.~-]+)[, ] *([%d.~-]+) +(.+)$");
    p = core.parse_coordinates(p.x, p.y, p.z);

    if player == nil then
        return false
    end

    if p and p.x and p.y and p.z and block then
        minetest.chat_send_player(name, core.colorize("#00FF06", S("Block @1 sets successful at @2 @3 @4!", block, p.x, p.y, p.z)))
        minetest.set_node({x = p.x, y = p.y, z = p.z}, {name = block})
        minetest.sound_play("done", name)
    else
        minetest.chat_send_player(name, core.colorize("red", S("Something wrong!")))
        minetest.sound_play("error", name)
    end
end

local function fill_the_zone(name, param)
    local p = {}
    local p2 = {}
    local player = minetest.get_player_by_name(name);
    local block = ""
    local pos = player:get_pos();
    p.x, p.y, p.z, p2.x, p2.y, p2.z, block = string.match(param, "^([%d.~-]+)[, ] *([%d.~-]+)[, ] *([%d.~-]+) *([%d.~-]+)[, ] *([%d.~-]+)[, ] *([%d.~-]+) +(.+)$");
    p = core.parse_coordinates(p.x, p.y, p.z);
    p2 = core.parse_coordinates(p2.x, p2.y, p2.z);

    if player == nil then
        return false
    end

    if p and p2 and p.x and p.y and p.z and p2.x and p2.y and p2.z and block then
        minetest.chat_send_player(name, core.colorize("#00FF06", S("Zone filled from @1 @2 @3 to @4 @5 @6 with a @7", p.x, p.y, p.z, p2.x, p2.y, p2.z, block)))
        minetest.bulk_set_node({{x = p.x, y = p.y, z = p.z}, {x = p2.x, y = p2.y, z = p2.z}}, {name = block})
        minetest.sound_play("done", name)
    else
        minetest.chat_send_player(name, core.colorize("red", S("Something wrong!")))
        minetest.sound_play("error", name)
    end
end

minetest.register_on_leaveplayer(function(player)
    local prop = {visual_size = {x = 1, y = 1}, eye_height = 1.47}
    player:set_properties(prop)
end)

local function set_bug_size(name, param)
    local player = minetest.get_player_by_name(name);
    local size = tonumber(string.match(param, "^([%d.~-]+)$"))
    local prop = {visual_size = {x = size, y = size}}
    if not size then
        minetest.chat_send_player(name, "Please, enter size (number)!")
    elseif size == 1 then
        minetest.chat_send_player(name, "Size set to default")
        prop = {visual_size = {x = 1, y = 1}}
        player:set_properties(prop)
    else
        minetest.chat_send_player(name, "Now your size is ".. size)
        player:set_properties(prop)
    end
end

local function set_the_size(name, param)
    local player = minetest.get_player_by_name(name);
    local size = tonumber(string.match(param, "^([%d.~-]+)"))
    local prop = {visual_size = {x = size, y = size}}
    local other
    if size then
        other = string.match(param, size .." +(.+)$")
    end
    if not size then
        minetest.chat_send_player(name, "Please, enter size (number)!")
    elseif size > 10 then
        minetest.chat_send_player(name, "Size cannot be more than 10!")
    elseif size == 1 then
        minetest.chat_send_player(name, "Size set to default")
        prop = {visual_size = {x = 1, y = 1}, eye_height = 1.47, spepheight = 0.6}
        player:set_properties(prop)
    elseif not other then
        if size == 2 then
            minetest.chat_send_player(name, "Now your size is 2")
            prop = {visual_size = {x = size, y = size}, eye_height = size + .5 + .47}
            player:set_properties(prop)
        elseif size == 3 then
            minetest.chat_send_player(name, "Now your size is 3")
            prop = {visual_size = {x = size, y = size}, eye_height = size + 1 + .47}
            player:set_properties(prop)
        elseif size == 4 then
            minetest.chat_send_player(name, "Now your size is 4")
            prop = {visual_size = {x = size, y = size}, eye_height = size + 1.5 + .47}
            player:set_properties(prop)
        elseif size == 5 then
            minetest.chat_send_player(name, "Now your size is 5")
            prop = {visual_size = {x = size, y = size}, eye_height = size + 2 + .47}
            player:set_properties(prop)
        elseif size == 6 then
            minetest.chat_send_player(name, "Now your size is 6")
            prop = {visual_size = {x = size, y = size}, eye_height = size + 2.5 + .47}
            player:set_properties(prop)
        elseif size == 7 then
            minetest.chat_send_player(name, "Now your size is 7")
            prop = {visual_size = {x = size, y = size}, eye_height = size + 3 + .47}
            player:set_properties(prop)
        elseif size == 8 then
            minetest.chat_send_player(name, "Now your size is 8")
            prop = {visual_size = {x = size, y = size}, eye_height = size + 3.5 + .47}
            player:set_properties(prop)
        elseif size == 9 then
            minetest.chat_send_player(name, "Now your size is 9")
            prop = {visual_size = {x = size, y = size}, eye_height = size + 4 + .47}
            player:set_properties(prop)
        elseif size == 10 then
            minetest.chat_send_player(name, "Now your size is 10")
            prop = {visual_size = {x = size, y = size}, eye_height = size + 4.5 + .47}
            player:set_properties(prop)
        end
    elseif size == 1 and other then
        minetest.chat_send_player(name, "Now ".. other .." size set to default.")
        minetest.chat_send_player(other, name .." set your size to default.")
        prop = {visual_size = {x = size, y = size}, eye_height = size + 1.3 + .47, stepheight = size}
        other:set_properties(prop)
    else
        minetest.chat_send_player(name, "Now ".. other .." size is ".. size)
        minetest.chat_send_player(other, name .." set your size to ".. size)
        prop = {visual_size = {x = 1, y = 1}, eye_height = 1.47, spepheight = 0.6}
        other:set_properties(prop)
    end
end

-- Temporary disabled for rework
--[[
core.register_privilege("size", {
    description = "Can resize self, item and other.",
    give_to_singleplayer = false,
})

minetest.register_chatcommand("setsize", {
    params = "<size> [<name>]",
    description = "Sets a player size.",
    privs = {server = true},
    func = set_the_size,
})

minetest.register_chatcommand("setbugsize", {
    params = "<size>",
    description = "Sets a bugged player size.",
    privs = {server = true},
    func = set_bug_size,
})

minetest.register_chatcommand("setblock", {
    params = "<X>,<Y>,<Z> <block_name>",
    description = S("Sets a block at coordinates."),
    privs = {server = true},
    func = set_the_block,
})

minetest.register_chatcommand("fill", {
    params = "<X>,<Y>,<Z> <X>,<Y>,<Z> <block_name>",
    description = S("Fill zone with a block."),
    privs = {server = true},
    func = fill_the_zone,
})
]]--

minetest.register_craftitem("essentials:eraser", {
	description = S("Eraser"),
	inventory_image = "simple_edit_eraser.png",
    stack_max = 1,
    liquids_pointable = true,
    range = 128,
    on_use = function(itemstack, user, pointed_thing)
        local name = user:get_player_name()
        local pos = minetest.get_pointed_thing_position(pointed_thing)
        if minetest.check_player_privs(name, {server=true}) then
            if pos then
                minetest.remove_node(pos)
                minetest.sound_play("simple_edit_erase", name)
            end
        else
            minetest.chat_send_player(name, core.colorize("red", S("You an not admin!")))
            itemstack:take_item(1)
            minetest.sound_play("error", name)
            return itemstack
        end
    end,
})

if essentials.disposable_eraser then
    minetest.register_craft({
        type = "shaped",
        recipe = {
                {"default:coral_orange", "default:desert_sand", "default:coral_orange"},
                {"default:coral_brown", "default:mese_crystal", "default:coral_brown"},
                {"default:coral_orange", "default:desert_sand", "default:coral_orange"},
            },
        output = "essentials:disposable_eraser",
    })
    minetest.register_craftitem("essentials:disposable_eraser", {
        description = S("Disposable Eraser"),
        inventory_image = "simple_edit_disposable_eraser.png",
        stack_max = 1,
        on_use = function(itemstack, user, pointed_thing)
            local name = user:get_player_name()
            local pos = minetest.get_pointed_thing_position(pointed_thing)
            if pos then
                minetest.remove_node(pos)
                minetest.sound_play("simple_edit_erase", name)
                itemstack:take_item(1)
                return itemstack
            end
        end,
    })
end