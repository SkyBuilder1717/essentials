local S = essentials.translate
local FORMNAME = "essentials:textbox_maker"

-- Thanks to Bapt-tech for idea!
-- https://i.imgur.com/zVCmNOT.png

function essentials.show_make_textbox(name)
	local formspec = {
        "formspec_version[6]",
        "size[10.5,9]",
        "image[0.2,0.2;1,1;essentials_warning.png]",
        "field[1.4,0.4;7.7,0.8;textbox_label;Label of textbox;Warning]",
        "textarea[0.5,1.7;9.5,4.7;textbox_text;Text in box;You have been do some thing bad!]",
        "button[2.9,7.6;4.7,1.2;send_btn;Send to player]",
        "image_button[9.2,0.4;0.8,0.8;essentials_close_btn.png;close_btn;;false;true]",
        "dropdown[2.9,6.6;4.7,0.8;player;", essentials.get_players(), ";1;false]"
    }

	core.show_formspec(name, FORMNAME, table.concat(formspec))
end

function essentials.show_textbox(name, label, textbox, owner)
	local formspec = {
        "formspec_version[6]",
        "size[10.5,8]",
        "label[1.4,0.7;", label, " ", S("(by @1)", owner), "]",
        "image[0.2,0.2;1,1;essentials_warning.png]",
        "button_exit[3.4,6.6;3.7,1.2;ok_button;OK]",
        "textarea[0.5,1.5;9.5,4.9;textbox;;", textbox, "]"
    }

	core.show_formspec(name, "essentials:textbox", table.concat(formspec))
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
    local name = player:get_player_name()
    essentials.player_sound("clicked", name)
    local target = fields.player

    if not core.get_player_by_name(target) then
        core.chat_send_player(name, core.colorize("red", S("Player @1 not found!", target)))
        essentials.player_sound("error", name)
        return
    end

    if fields.send_btn then
        if (fields.textbox_text == "") or (fields.textbox_label == "") then
            core.chat_send_player(name, S("Put text in inputs!"))
            essentials.player_sound("error", name)
            return
        end
        core.close_formspec(name, FORMNAME)
        core.chat_send_player(name, S("Textbox \"@1\" showed to player @2!", fields.textbox_label, target))
        essentials.player_sound("done", name)
        essentials.show_textbox(target, fields.textbox_label, fields.textbox_text, name)
    end
end)