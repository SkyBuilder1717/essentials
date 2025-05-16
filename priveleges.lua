local S = essentials.translate

local function is_contain(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

if essentials.add_privs then
    if is_contain(essentials.add_privs_list, "rename_item") then
        core.register_privilege("rename_item", {
            description = S("Can rename items"),
            give_to_singleplayer = false,
        })
    end
    if is_contain(essentials.add_privs_list, "god_mode") then
        core.register_privilege("god_mode", {
            description = S("Cannot be hurted by someone"),
            give_to_singleplayer = false,
        })
    end
    if is_contain(essentials.add_privs_list, "broadcast") then
        core.register_privilege("broadcast", {
            description = S("Can annonce all the server"),
            give_to_singleplayer = false,
        })
    end
    if is_contain(essentials.add_privs_list, "speed") then
        core.register_privilege("speed", {
            description = S("Can be fast or slow"),
            give_to_singleplayer = false,
        })
    end
    if is_contain(essentials.add_privs_list, "heal") then
        core.register_privilege("heal", {
            description = S("Can heal yourself or someone"),
            give_to_singleplayer = false,
        })
    end
    if is_contain(essentials.add_privs_list, "kill") then
        core.register_privilege("kill", {
            description = S("Can kill anyone"),
            give_to_singleplayer = false,
        })
    end
    if is_contain(essentials.add_privs_list, "get_pos") then
        core.register_privilege("get_pos", {
            description = S("Can get position of player"),
            give_to_singleplayer = false,
        })
    end
    if is_contain(essentials.add_privs_list, "seed") then
        core.register_privilege("seed", {
            description = S("Can see the seed of world/server"),
            give_to_singleplayer = true,
        })
    end
    if is_contain(essentials.add_privs_list, "invisible") then
        core.register_privilege("invisible", {
            description = S("Can be invisible"),
            give_to_singleplayer = false,
        })
    end
    if is_contain(essentials.add_privs_list, "inv") then
        core.register_privilege("inv", {
            description = S("Can open other player's inventories"),
            give_to_singleplayer = false,
        })
    end
    if is_contain(essentials.add_privs_list, "troll") then
        core.register_privilege("troll", {
            description = S("Can open troll menu for trolling"),
            give_to_singleplayer = false,
        })
    end
    if is_contain(essentials.add_privs_list, "mute") then
        core.register_privilege("mute", {
            description = S("Can mute players"),
            give_to_singleplayer = false,
        })
    end
    if is_contain(essentials.add_privs_list, "call") then
        core.register_privilege("call", {
            description = S("Can request to players a teleportation"),
            give_to_singleplayer = false,
        })
    end
    if (essentials.enable_ip_cmd and is_contain(essentials.add_privs_list, "ip")) then
        core.register_privilege("ip", {
            description = S("Can use @1 command to know ip of players.", "\'/ip\'"),
            give_to_singleplayer = false,
        })
    end
    if (essentials.biome and is_contain(essentials.add_privs_list, "biome")) then
        core.register_privilege("biome", {
            description = S("Can see current biome info"),
            give_to_singleplayer = false,
        })
    end
    --[[
    if essentials.admin_block then
        core.register_privilege("admin_stuff", {
            description = S("Can use admin items (Block and Pickaxe)"),
            give_to_singleplayer = false,
        })
    end
    core.register_privilege("rename_player", {
        description = S("Can rename self or someone else"),
    })
    core.register_privilege("colored_nickname", {
        description = S("Can color nicknames"),
    })
    ]]--
end