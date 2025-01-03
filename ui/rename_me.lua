local FORMNAME = "essentials:rename_me"
hide_names = {}

core.register_on_chat_message(function(name, message)
	local new_name = hide_names[name]
	if new_name then
		core.chat_send_all(core.format_chat_message(core.colorize(color, new_name), message))
		return true
	end
end)

function essentials.show_rename_menu(name)
	local formspec = "formspec_version[6]"..
        "size[4.5,11]"..
        "field[0.1,5.3;4.3,1.1;new_name;"..S("New name")..";]"..
        "button[0.1,9.7;4.3,1.2;rename;"..S("Rename").."]"..
        "image_button_exit[3.4,0.1;1,1;essentials_close_btn.png;close_btn;]"..
        "field[0.1,8.5;4.3,1.1;color;"..S("Color")..";]"..
        "image[0.4,1.2;3.7,3.7;essentials_sussy_amogus_name.png]"..
        "field[0.1,6.9;4.3,1.1;name;"..core.formspec_escape(S("Player (Empty for yourself)"))..";]"

	core.show_formspec(name, FORMNAME, formspec)
end

core.register_on_player_receive_fields(function(player, formname, field)
	if formname ~= FORMNAME then
		return
	end
    local name = player:get_player_name();
    local new_name = field.new_name
    local color = field.color
    local othername = field.name
	essentials.player_sound("clicked", name)

    if field.rename then
        if core.is_singleplayer() then
            core.chat_send_player(name, core.colorize("red", S("Cannot rename yourself in single mode!")))
            essentials.player_sound("error", name)
            return
        end
        if core.get_player_by_name(othername) == nil then
            core.chat_send_player(name, core.colorize("red", S("Player @1 doesnt exist or offline!", othername)))
            return
        end
        if new_name == "" then
            core.chat_send_player(name, core.colorize("red", S("Name cannot be empty!")))
            essentials.player_sound("error", name)
            return
        end

        core.get_player_by_name(othername):set_properties({
            nametag_color = "",
        })
        
        if color == "" then
            hide_names[name] = new_name
            core.chat_send_player(name, core.colorize("green", S("Name of @1 changed to @2", othername, new_name)))
            if essentials.changed_by then
                core.chat_send_player(othername, core.colorize("green", S("Your name changed to @1 by @2", new_name, name)))
            end
            essentials.player_sound("done", name)
            
            core.get_player_by_name(othername):set_properties({
                nametag = core.colorize("#AAAAAA", "*"..new_name),
            })
            core.close_formspec(name, formname)
        else
            hide_names[name] = new_name
            core.chat_send_player(name, S("Name of @1 changed to @2 with @3", othername, new_name, core.colorize(color, "color ".. color)))
            if essentials.changed_by then
                core.chat_send_player(othername, core.colorize("green", S("Your name changed to @1 with @2 by @3", new_name, core.colorize(color, S("color @1", color)), name)))
            end
            essentials.player_sound("done", name)
            core.get_player_by_name(othername):set_properties({
                nametag = core.colorize("#AAAAAA", "*").. core.colorize(color, new_name)
            })
            core.close_formspec(name, formname)
        end
    end
end)