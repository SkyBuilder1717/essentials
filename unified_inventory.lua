<<<<<<< HEAD
local function is_contain(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

if not core.is_singleplayer() then
    unified_inventory.register_button("ban_menu", {
        type = "image",
        image = "unified_inventory_ban.png",
        tooltip = "Ban menu",
        action = function(player)
            local name = player:get_player_name()
            if minetest.check_player_privs(name, {ban=true}) then
                show_ban_menu(name)
            else
                core.chat_send_player(name, "You dont have privilege \'ban\'!")
            end
        end
    })

    unified_inventory.register_button("kick_menu", {
        type = "image",
        image = "unified_inventory_kick.png",
        tooltip = "Kick menu",
        action = function(player)
            local name = player:get_player_name()
            if minetest.check_player_privs(name, {kick=true}) then
                show_kick_menu(name)
            else
                core.chat_send_player(name, "You dont have privilege \'kick\'!")
            end
        end
    })

    if essentials.enable_troll_cmd then
        unified_inventory.register_button("troll", {
            type = "image",
            image = "essentials_troll.png",
            tooltip = "Troll Menu",
            action = function(player)
                local name = player:get_player_name()
                if essentials.add_privs and is_contain(essentials.add_privs_list, "troll") then
                    if minetest.check_player_privs(name, {troll=true}) then
                        show_troll_menu(name)
                    else
                        core.chat_send_player(name, "You dont have privilege \'troll\'!")
                    end
                else
                    if minetest.check_player_privs(name, {ban=true}) then
                        show_troll_menu(name)
                    else
                        core.chat_send_player(name, "You dont have privilege \'ban\'!")
                    end
                end
            end
        })
    end
end
unified_inventory.register_button("rename_item", {
    type = "image",
    image = "unified_inventory_amogus.png",
    tooltip = "Rename item in hand",
    action = function(player)
        local name = player:get_player_name()
        if essentials.add_privs and is_contain(essentials.add_privs_list, "rename_item") then
            if minetest.check_player_privs(name, {rename_item=true}) then
                show_renameitem_menu(name)
            else
                core.chat_send_player(name, "You dont have privilege \'rename_item\'!")
            end
        else
            if minetest.check_player_privs(name, {basic_privs=true}) then
                show_renameitem_menu(name)
            else
                core.chat_send_player(name, "You dont have privilege \'basic_privs\'!")
            end
        end
    end
})
--[[
unified_inventory.register_button("rename_me", {
    type = "image",
    image = "unified_inventory_amogus.png",
    tooltip = "Rename yourself",
    action = function(player)
        local name = player:get_player_name()
        if minetest.check_player_privs(name, {rename_player=true}) then
            show_rename_menu(name)
        else
            core.chat_send_player(name, "You dont have privilege \'rename_player\'!")
        end
    end
})

unified_inventory.register_button("color_nickname", {
    type = "image",
    image = "unified_inventory_color_nickname.png",
    tooltip = "Coloring your nickname",
    action = function(player)
        local name = player:get_player_name()
        if minetest.check_player_privs(name, {colored_nickname=true}) then
            show_color_menu(name)
        else
            core.chat_send_player(name, "You dont have privilege \'colored_nickname\'!")
        end
    end
})

unified_inventory.register_button("mute_menu", {
    type = "image",
    image = "unified_inventory_mute.png",
    tooltip = "Mute menu",
    action = function(player)
        local name = player:get_player_name()
        if minetest.check_player_privs(name, {mute=true}) then
            show_mute_menu(name)
        else
            core.chat_send_player(name, "You dont have privilege 'mute'!")
        end
    end
})
=======
local function is_contain(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

if not core.is_singleplayer() then
    unified_inventory.register_button("ban_menu", {
        type = "image",
        image = "unified_inventory_ban.png",
        tooltip = "Ban menu",
        action = function(player)
            local name = player:get_player_name()
            if minetest.check_player_privs(name, {ban=true}) then
                show_ban_menu(name)
            else
                core.chat_send_player(name, "You dont have privilege \'ban\'!")
            end
        end
    })

    unified_inventory.register_button("kick_menu", {
        type = "image",
        image = "unified_inventory_kick.png",
        tooltip = "Kick menu",
        action = function(player)
            local name = player:get_player_name()
            if minetest.check_player_privs(name, {kick=true}) then
                show_kick_menu(name)
            else
                core.chat_send_player(name, "You dont have privilege \'kick\'!")
            end
        end
    })

    if essentials.enable_troll_cmd then
        unified_inventory.register_button("troll", {
            type = "image",
            image = "essentials_troll.png",
            tooltip = "Troll Menu",
            action = function(player)
                local name = player:get_player_name()
                if essentials.add_privs and is_contain(essentials.add_privs_list, "troll") then
                    if minetest.check_player_privs(name, {troll=true}) then
                        show_troll_menu(name)
                    else
                        core.chat_send_player(name, "You dont have privilege \'troll\'!")
                    end
                else
                    if minetest.check_player_privs(name, {ban=true}) then
                        show_troll_menu(name)
                    else
                        core.chat_send_player(name, "You dont have privilege \'ban\'!")
                    end
                end
            end
        })
    end
end
unified_inventory.register_button("rename_item", {
    type = "image",
    image = "unified_inventory_amogus.png",
    tooltip = "Rename item in hand",
    action = function(player)
        local name = player:get_player_name()
        if essentials.add_privs and is_contain(essentials.add_privs_list, "rename_item") then
            if minetest.check_player_privs(name, {rename_item=true}) then
                show_renameitem_menu(name)
            else
                core.chat_send_player(name, "You dont have privilege \'rename_item\'!")
            end
        else
            if minetest.check_player_privs(name, {basic_privs=true}) then
                show_renameitem_menu(name)
            else
                core.chat_send_player(name, "You dont have privilege \'basic_privs\'!")
            end
        end
    end
})
--[[
unified_inventory.register_button("rename_me", {
    type = "image",
    image = "unified_inventory_amogus.png",
    tooltip = "Rename yourself",
    action = function(player)
        local name = player:get_player_name()
        if minetest.check_player_privs(name, {rename_player=true}) then
            show_rename_menu(name)
        else
            core.chat_send_player(name, "You dont have privilege \'rename_player\'!")
        end
    end
})

unified_inventory.register_button("color_nickname", {
    type = "image",
    image = "unified_inventory_color_nickname.png",
    tooltip = "Coloring your nickname",
    action = function(player)
        local name = player:get_player_name()
        if minetest.check_player_privs(name, {colored_nickname=true}) then
            show_color_menu(name)
        else
            core.chat_send_player(name, "You dont have privilege \'colored_nickname\'!")
        end
    end
})

unified_inventory.register_button("mute_menu", {
    type = "image",
    image = "unified_inventory_mute.png",
    tooltip = "Mute menu",
    action = function(player)
        local name = player:get_player_name()
        if minetest.check_player_privs(name, {mute=true}) then
            show_mute_menu(name)
        else
            core.chat_send_player(name, "You dont have privilege 'mute'!")
        end
    end
})
>>>>>>> 46b4032d79edf22a60b1f30c2835b9369e30fba1
]]--