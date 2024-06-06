local FORMNAME = "essentials:color_menu"

local function convertColor(table)
    local hex = string.format("#%02X%02X%02X", table.r, table.g, table.b)
    return hex
end

minetest.register_on_chat_message(function(name, message)
	local prop = minetest.get_player_by_name(name):get_properties()
    --minetest.chat_send_player(name, dump(prop.nametag_color))
	minetest.chat_send_all(core.format_chat_message(core.colorize(convertColor(prop.nametag_color), name), message))
	return true
end)

function show_color_menu(name)
	local formspec = [[
        formspec_version[6]
        size[10,8]
        button[2.9,6.5;4.4,1.2;done;Accept]
        image_button_exit[8.8,0.2;1,1;essentials_close_btn.png;close_btn;]
        field[1.5,4.4;7.2,1.1;color;Color;]
        label[1.7,5.9;Or hex color or common color (red\, blue\, etc.)]
        label[2.7,1.6;Select color for your nickname]
    ]]

	minetest.show_formspec(name, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
    local name = player:get_player_name()
	minetest.sound_play("clicked", {to_player = name})
    
    if fields.done then
        if core.is_singleplayer() then
            minetest.chat_send_player(name, core.colorize("red", "Cannot coloring nickname or other in singleplayer"))
            minetest.sound_play("error")
            return
        end
        player:set_properties({
            nametag_color = fields.color
        })
        player:get_meta():set_string("essentials_color", fields.color)
        minetest.sound_play("clicked", name)
        minetest.close_formspec(name, formname)
    end
	return
end)