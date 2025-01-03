if essentials.admin_block then
    if essentials.add_privs then
        minetest.register_node("essentials:admin_block", {
            description = essentials.translate("Admin Block"),
            tiles = {"essentials_block.png"},
            groups = {indestructible=1},
            sounds = { footstep = { name = "default_hard_footstep", gain = 1.10 } },
            is_ground_content = false,
            on_blast = function() end,
            on_destruct = function () end,
            can_dig = function(pos, player)
                if minetest.check_player_privs(player, {admin_stuff=true}) then
                    return true
                else
                    return false 
                end
            end,
            diggable = true,
            drop = "",
        })
    else
        minetest.register_node("essentials:admin_block", {
            description = essentials.translate("Admin Block"),
            tiles = {"essentials_block.png"},
            groups = {indestructible=1, },
            sounds = { footstep = { name = "default_hard_footstep", gain = 1.10 } },
            is_ground_content = false,
            on_blast = function() end,
            on_destruct = function () end,
            can_dig = function(pos, player)
                if minetest.check_player_privs(player, {server=true}) then
                    return true
                else
                    return false 
                end
            end,
            diggable = true,
            drop = "",
        })
    end
end