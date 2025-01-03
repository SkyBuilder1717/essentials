<<<<<<< HEAD
local FORMNAME = "essentials:rename_me"
hide_names = {}

minetest.register_on_chat_message(function(name, message)
	local new_name = hide_names[name]
	if new_name then
		minetest.chat_send_all(core.format_chat_message(core.colorize(color, new_name), message))
		return true
	end
end)

function show_rename_menu(name)
	local formspec = [[
        formspec_version[6]
        size[4.5,11]
        field[0.1,5.3;4.3,1.1;new_name;New name;]
        button[0.1,9.7;4.3,1.2;rename;Rename]
        image_button_exit[3.4,0.1;1,1;essentials_close_btn.png;close_btn;]
        field[0.1,8.5;4.3,1.1;color;Color;]
        image[0.4,1.2;3.7,3.7;essentials_sussy_amogus_name.png]
        field[0.1,6.9;4.3,1.1;name;Player (Empty for yourself);]
    ]]

	minetest.show_formspec(name, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, field)
	if formname ~= FORMNAME then
		return
	end
    local name = player:get_player_name();
    local new_name = field.new_name
    local color = field.color
    local othername = field.name
	minetest.sound_play("clicked", {to_player = name})

    if field.rename then
        if core.is_singleplayer() then
            minetest.chat_send_player(name, core.colorize("red", "Cannot rename yourself or other in singleplayer"))
            minetest.sound_play("error")
            return
        end
        if othername == "" then
            if new_name == "" then
                minetest.chat_send_player(name, core.colorize("red", "New name cannot be empty!"))
                minetest.sound_play("error")
                return
            end
            minetest.get_player_by_name(name):set_properties({
                nametag_color = "",
            })
            if color == "" then
                hide_names[name] = new_name
                minetest.chat_send_player(name, core.colorize("green", "Name changed to '".. new_name .."'"))
                minetest.sound_play("done")
                player:set_properties({
                    nametag = "*".. new_name,
                    nametag_color = "#AAAAAA"
                })
                minetest.close_formspec(name, formname)
            else
                hide_names[name] = new_name
                minetest.chat_send_player(name, core.colorize("green", "Name changed to '".. new_name .."' with ").. core.colorize(color, "Color ".. color))
                minetest.sound_play("done")
                player:set_properties({
                    nametag = core.colorize("#AAAAAA", "*").. core.colorize(color, new_name)
                })
                minetest.close_formspec(name, formname)
            end
        else
            if minetest.get_player_by_name(othername) == nil then
                minetest.chat_send_player(name, core.colorize("red", string.format("Player \"%s\" doesnt exist or offline!", othername)))
                return
            end
            if new_name == "" then
                minetest.chat_send_player(name, core.colorize("red", "New name cannot be empty!"))
                minetest.sound_play("error")
                return
            end
            minetest.get_player_by_name(othername):set_properties({
                nametag_color = "",
            })
            if color == "" then
                hide_names[name] = new_name
                minetest.chat_send_player(name, core.colorize("green", "Name of ".. othername .." changed to '".. new_name .."'"))
                if essentials.changed_by then
                    minetest.chat_send_player(othername, core.colorize("green", "Your name changed to \'".. new_name .."\' by ".. name))
                end
                minetest.sound_play("done")
                
                minetest.get_player_by_name(othername):set_properties({
                    nametag = core.colorize("#AAAAAA", "*"..new_name),
                })
                minetest.close_formspec(name, formname)
            else
                hide_names[name] = new_name
                minetest.chat_send_player(name, string.format("Name of %s changed to \'%s\' with %s", othername, new_name, core.colorize(color, "color ".. color)))
                if essentials.changed_by then
                    minetest.chat_send_player(othername, core.colorize("green", "Your name changed to \'".. new_name .."\' with color ".. core.colorize(color, "color ".. color) .." by ".. name))
                end
                minetest.sound_play("done")
                minetest.get_player_by_name(othername):set_properties({
                    nametag = core.colorize("#AAAAAA", "*").. core.colorize(color, new_name)
                })
                minetest.close_formspec(name, formname)
            end
        end
    end
end)
=======
local FORMNAME = "essentials:rename_me"
hide_names = {}

minetest.register_on_chat_message(function(name, message)
	local new_name = hide_names[name]
	if new_name then
		minetest.chat_send_all(core.format_chat_message(core.colorize(color, new_name), message))
		return true
	end
end)

function show_rename_menu(name)
	local formspec = [[
        formspec_version[6]
        size[4.5,11]
        field[0.1,5.3;4.3,1.1;new_name;New name;]
        button[0.1,9.7;4.3,1.2;rename;Rename]
        image_button_exit[3.4,0.1;1,1;essentials_close_btn.png;close_btn;]
        field[0.1,8.5;4.3,1.1;color;Color;]
        image[0.4,1.2;3.7,3.7;essentials_sussy_amogus_name.png]
        field[0.1,6.9;4.3,1.1;name;Player (Empty for yourself);]
    ]]

	minetest.show_formspec(name, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, field)
	if formname ~= FORMNAME then
		return
	end
    local name = player:get_player_name();
    local new_name = field.new_name
    local color = field.color
    local othername = field.name
	minetest.sound_play("clicked", {to_player = name})

    if field.rename then
        if core.is_singleplayer() then
            minetest.chat_send_player(name, core.colorize("red", "Cannot rename yourself or other in singleplayer"))
            minetest.sound_play("error")
            return
        end
        if othername == "" then
            if new_name == "" then
                minetest.chat_send_player(name, core.colorize("red", "New name cannot be empty!"))
                minetest.sound_play("error")
                return
            end
            minetest.get_player_by_name(name):set_properties({
                nametag_color = "",
            })
            if color == "" then
                hide_names[name] = new_name
                minetest.chat_send_player(name, core.colorize("green", "Name changed to '".. new_name .."'"))
                minetest.sound_play("done")
                player:set_properties({
                    nametag = "*".. new_name,
                    nametag_color = "#AAAAAA"
                })
                minetest.close_formspec(name, formname)
            else
                hide_names[name] = new_name
                minetest.chat_send_player(name, core.colorize("green", "Name changed to '".. new_name .."' with ").. core.colorize(color, "Color ".. color))
                minetest.sound_play("done")
                player:set_properties({
                    nametag = core.colorize("#AAAAAA", "*").. core.colorize(color, new_name)
                })
                minetest.close_formspec(name, formname)
            end
        else
            if minetest.get_player_by_name(othername) == nil then
                minetest.chat_send_player(name, core.colorize("red", string.format("Player \"%s\" doesnt exist or offline!", othername)))
                return
            end
            if new_name == "" then
                minetest.chat_send_player(name, core.colorize("red", "New name cannot be empty!"))
                minetest.sound_play("error")
                return
            end
            minetest.get_player_by_name(othername):set_properties({
                nametag_color = "",
            })
            if color == "" then
                hide_names[name] = new_name
                minetest.chat_send_player(name, core.colorize("green", "Name of ".. othername .." changed to '".. new_name .."'"))
                if essentials.changed_by then
                    minetest.chat_send_player(othername, core.colorize("green", "Your name changed to \'".. new_name .."\' by ".. name))
                end
                minetest.sound_play("done")
                
                minetest.get_player_by_name(othername):set_properties({
                    nametag = core.colorize("#AAAAAA", "*"..new_name),
                })
                minetest.close_formspec(name, formname)
            else
                hide_names[name] = new_name
                minetest.chat_send_player(name, string.format("Name of %s changed to \'%s\' with %s", othername, new_name, core.colorize(color, "color ".. color)))
                if essentials.changed_by then
                    minetest.chat_send_player(othername, core.colorize("green", "Your name changed to \'".. new_name .."\' with color ".. core.colorize(color, "color ".. color) .." by ".. name))
                end
                minetest.sound_play("done")
                minetest.get_player_by_name(othername):set_properties({
                    nametag = core.colorize("#AAAAAA", "*").. core.colorize(color, new_name)
                })
                minetest.close_formspec(name, formname)
            end
        end
    end
end)
>>>>>>> 46b4032d79edf22a60b1f30c2835b9369e30fba1
