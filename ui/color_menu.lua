local FORMNAME = "essentials:color_menu"
local S = essentials.translate

core.register_on_chat_message(function(name, message)
    local player = core.get_player_by_name(name)
    local color = player:get_meta():get_string("_essentials_nametag_color")
    if color == "" then return false end
    local new_name = essentials.hide_names[name]
	if new_name then
	    core.chat_send_all(core.format_chat_message(core.colorize("#AAAAAA", "*")..core.colorize(color, new_name), message))
	    return true
    end
    core.chat_send_all(core.format_chat_message(essentials.get_nickname(name), message))
    return true
end)

core.register_on_joinplayer(function(player)
    core.after(0, function()
        local name = player:get_player_name()
        local new_name = essentials.hide_names[name]
        local color = player:get_meta():get_string("_essentials_nametag_color")
        if color == "" then return end
        if new_name then
            player:set_properties({
                nametag = core.colorize("#AAAAAA", "*")..core.colorize(color, new_name)
            })
            return
        end
        player:set_properties({
            nametag = core.colorize(color, name)
        })
    end)
end)

function essentials.show_coloring_menu(name)
	local formspec = {
        "formspec_version[6]",
        "size[10,8]",
        "button[2.9,6.5;4.4,1.2;done;", S("Done"), "]",
        "image_button_exit[8.8,0.2;1,1;essentials_close_btn.png;close;]",
        "field[1.5,4.4;7.2,1.1;color;", S("Color"), ";]",
        "label[1.7,5.9;", core.formspec_escape(S("Or hex color or common color (red, blue, etc.)")), "]",
        "label[2.7,1.6;", core.formspec_escape(S("Select color for your nickname")), "]"
    }

	core.show_formspec(name, FORMNAME, table.concat(formspec))
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
    local name = player:get_player_name()
    if fields.done then
        if core.is_singleplayer() then
            core.chat_send_player(name, core.colorize("red", S("Cannot coloring nickname in single mode!")))
            essentials.player_sound("error", name)
            return
        end
        player:set_properties({
            nametag = core.colorize(fields.color, name)
        })
        essentials.hide_names[name] = nil
        essentials.save_nicknames()
        player:get_meta():set_string("_essentials_nametag_color", fields.color)
        core.close_formspec(name, formname)
    end
end)