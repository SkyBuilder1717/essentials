local S = essentials.translate
local FORMNAME = "essentials:rename_me"
essentials.hide_names = {}

function essentials.show_rename_menu(name)
    local formspec = {
        "formspec_version[6]",
        "size[4.5,11]",
        "field[0.1,5.3;4.3,1.1;new_name;", S("New name"), ";]",
        "button[0.1,9.7;4.3,1.2;rename;", S("Rename"), "]",
        "image_button_exit[3.4,0.1;1,1;essentials_close_btn.png;close_btn;]",
        "dropdown[0.1,8.5;4.3,1.1;color;,red,orange,yellow,green,lime,blue,cyan,pink,purple,white,black;1;false]",
        "image[0.4,1.2;3.7,3.7;essentials_sussy_amogus_name.png]",
        "dropdown[0.1,6.9;4.3,1.1;name;", essentials.get_players(), ";1;false]"
    }

	core.show_formspec(name, FORMNAME, table.concat(formspec))
end

core.register_on_player_receive_fields(function(player, formname, field)
	if formname ~= FORMNAME then
		return
	end
    local name = player:get_player_name();
    local new_name = field.new_name
    local color = field.color
    local othername = field.name

    if field.rename then
        if core.is_singleplayer() then
            core.chat_send_player(name, core.colorize("red", S("Cannot rename yourself in single mode!")))
            essentials.player_sound("error", name)
            return
        end
        if not core.get_player_by_name(othername) then
            core.chat_send_player(name, core.colorize("red", S("Player @1 not found!", othername)))
            return
        end
        local otherp = core.get_player_by_name(othername)
        if new_name == "" then
            core.chat_send_player(name, core.colorize("red", S("Name cannot be empty!")))
            essentials.player_sound("error", name)
            return
        end

        otherp:set_properties({nametag_color = ""})
        
        local meta = player:get_meta()
        if color == "" then
            essentials.hide_names[name] = new_name
            core.chat_send_player(name, S("Name of @1 changed to @2", othername, new_name))
            if essentials.changed_by then
                core.chat_send_player(othername, S("Your name changed to @1 by @2", new_name, name))
            end
            essentials.player_sound("done", name)
            
            otherp:set_properties({
                nametag = core.colorize("#AAAAAA", "*"..new_name)
            })
            meta:set_string("_essentials_nametag_color", "white")
            core.close_formspec(name, formname)
        else
            essentials.hide_names[name] = new_name
            core.chat_send_player(name, S("Name of @1 changed to @2 with @3", othername, new_name, core.colorize(color, "color ".. color)))
            if essentials.changed_by then
                core.chat_send_player(othername, S("Your name changed to @1 with @2 by @3", new_name, core.colorize(color, S("color @1", color)), name))
            end
            essentials.player_sound("done", name)
            otherp:set_properties({
                nametag = core.colorize("#AAAAAA", "*").. core.colorize(color, new_name)
            })
            meta:set_string("_essentials_nametag_color", color)
            core.close_formspec(name, formname)
        end
        essentials.save_nicknames()
    end
end)