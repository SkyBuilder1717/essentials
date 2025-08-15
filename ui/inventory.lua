local FORMNAME = "essentials:inventory"
local S = essentials.translate

function essentials.show_player_inventory(name, pname)
    local player = core.get_player_by_name(name)
    local hbi = player:hud_get_hotbar_itemcount()

    local pplayer = core.get_player_by_name(pname)
    local phbi = pplayer:hud_get_hotbar_itemcount()

    local width = phbi
    if hbi > phbi then
        width = hbi
    end

    local target = pplayer:get_inventory()

	local formspec = {
        "formspec_version[6]",
        "size[", (width + 2.5), ",11.5]",
        (core.global_exists("mcl_formspec") and (mcl_formspec.get_itemslot_bg_v4(0.4, 6.4, hbi, 4)..mcl_formspec.get_itemslot_bg_v4(0.4, 0.8, phbi, 4))),
        "list[current_player;main;0.4,6.4;", hbi, ",4;0]",
        "label[0.4,0.4;", S("@1's inventory", pname), "]",
        "list[detached:essentials:", pname, "_inv;main;0.4,0.8;", phbi, ",4;0]",
        "label[0.4,6;", S("Inventory"), "]"
    }

    local detached = core.create_detached_inventory("essentials:"..pname.."_inv", {
        allow_move = function(_, _, _, _, _, count)
            return count
        end,
        allow_put = function(_, _, _, stack)
            return stack:get_count()
        end,
        allow_take = function(_, _, _, stack)
            return stack:get_count()
        end,
        on_put = function(inv, listname, index, stack)
            local target = pplayer:get_inventory()
            target:set_stack("main", index, stack)
        end,
        on_take = function(inv, listname, index, stack)
            local target = pplayer:get_inventory()
            target:set_stack("main", index, inv:get_stack("main", index))
        end,
        on_move = function(inv, from_list, from_index, to_list, to_index, count)
            local target = pplayer:get_inventory()
            local from_stack = inv:get_stack(from_list, from_index)
            local to_stack = inv:get_stack(to_list, to_index)
            local taken_stack = from_stack:take_item(count)
            to_stack:add_item(taken_stack)
            inv:set_stack(from_list, from_index, from_stack)
            inv:set_stack(to_list, to_index, to_stack)
            target:set_stack(from_list, from_index, from_stack)
            target:set_stack(to_list, to_index, to_stack)
        end,
    })
    detached:set_size("main", target:get_size("main"))
    detached:set_list("main", target:get_list("main"))

	core.show_formspec(name, FORMNAME, table.concat(formspec))
end

core.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    local inv = "essentials:"..name.."_inv"
    if core.get_inventory({type="detached", name=inv}) then
        core.remove_detached_inventory(inv)
    end
end)