local S = essentials.translate
local function c(t, v)
    for _, d in ipairs(t) do
        if d == v then
            return true
        end
    end
    return false
end

if not core.is_singleplayer() then
    unified_inventory.register_button("essentials_ban_menu", {
        type = "image",
        image = "unified_inventory_essentials_ban.png",
        tooltip = S("Ban Menu"),
        action = function(p)
            local name = p:get_player_name()
            essentials.show_ban_menu(name)
        end,
        condition = function(p)
            return core.check_player_privs(p:get_player_name(), {ban=true})
        end
    })

    unified_inventory.register_button("essentials_kick_menu", {
        type = "image",
        image = "unified_inventory_essentials_kick.png",
        tooltip = S("Kick Menu"),
        action = function(p)
            local name = p:get_player_name()
            essentials.show_kick_menu(name)
        end,
        condition = function(p)
            return core.check_player_privs(p:get_player_name(), {kick=true})
        end
    })

    unified_inventory.register_button("essentials_mute_menu", {
        type = "image",
        image = "unified_inventory_essentials_mute.png",
        tooltip = S("Mute Menu"),
        action = function(p)
            local name = p:get_player_name()
            essentials.show_mute_menu(name)
        end,
        condition = function(p)
            return core.check_player_privs(p:get_player_name(), {mute=true})
        end
    })

    if essentials.reports_system then
        unified_inventory.register_button("essentials_report_menu", {
            type = "image",
            image = "unified_inventory_essentials_report.png",
            tooltip = S("Report Menu"),
            action = function(p)
                local name = p:get_player_name()
                essentials.show_report_menu(name)
            end,
            condition = function(p)
                return core.check_player_privs(p:get_player_name(), {shout=true})
            end
        })
    end

    if essentials.enable_troll_cmd then
        unified_inventory.register_button("essentials_troll", {
            type = "image",
            image = "essentials_troll.png",
            tooltip = S("Troll").." "..S("Menu"),
            action = function(p)
                local name = p:get_player_name()
                essentials.show_troll_menu(name)
            end,
            condition = function(p)
                local name = p:get_player_name()
                if essentials.add_privs and c(essentials.add_privs_list, "troll") then
                    return core.check_player_privs(name, {troll=true})
                else
                    return core.check_player_privs(name, {ban=true})
                end
            end
        })
    end
end

unified_inventory.register_button("essentials_rename_item", {
    type = "image",
    image = "unified_inventory_essentials_amogus.png",
    tooltip = S("Rename item in hand"),
    action = function(p)
        local name = p:get_player_name()
        essentials.show_renameitem_menu(name)
    end,
    condition = function(p)
        local name = p:get_player_name()
        if essentials.add_privs and c(essentials.add_privs_list, "rename_item") then
            return core.check_player_privs(name, {rename_item=true})
        else
            return core.check_player_privs(name, {basic_privs=true})
        end
    end
})