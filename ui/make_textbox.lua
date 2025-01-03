local S = essentials.translate
local FORMNAME = "essentials:textbox_maker"

-- Thanks to Bapt-tech for idea!
-- https://i.imgur.com/zVCmNOT.png

function show_textbox_admin(name)
    local players = ""
    for _, player in ipairs(minetest.get_connected_players()) do
        local name = player:get_player_name()
        players = players..","..name
    end
	local formspec = "formspec_version[6]"..
        "size[10.5,9]"..
        "image[0.2,0.2;1,1;essentials_warning.png]"..
        "field[1.4,0.4;7.7,0.8;textbox_label;Label of textbox;Warning]"..
        "textarea[0.5,1.7;9.5,4.7;textbox_text;Text in box;You have been do some thing bad!]"..
        "button[2.9,7.6;4.7,1.2;send_btn;Send to player]"..
        "image_button[9.2,0.4;0.8,0.8;essentials_close_btn.png;close_btn;;false;true]"..
        "dropdown[2.9,6.6;4.7,0.8;player;"..players..";1;false]"

	minetest.show_formspec(name, FORMNAME, formspec)
end

function show_textbox_player(name, label, textbox, owner)
	local formspec = "formspec_version[6]"..
        "size[10.5,8]"..
        "label[1.4,0.7;"..label.." "..S("(by @1)", owner).."]"..
        "image[0.2,0.2;1,1;essentials_warning.png]"..
        "button_exit[3.4,6.6;3.7,1.2;ok_button;OK]"..
        "textarea[0.5,1.5;9.5,4.9;textbox;;"..textbox.."]"

	minetest.show_formspec(name, "essentials:textbox", formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
    local name = player:get_player_name()
    minetest.sound_play("clicked", name)

    if fields.player == "" then
        minetest.chat_send_player(name, S("Select a player!"))
        minetest.sound_play("error", name)
    elseif fields.send_btn then
        local player_target = minetest.get_player_by_name(fields.player)
        if not player_target then
            minetest.chat_send_player(name, core.colorize("red", S("Player not found!")))
            minetest.close_formspec(name, FORMNAME)
            minetest.sound_play("error", name)
        elseif fields.textbox_label == "" then
            minetest.chat_send_player(name, S("Put valid text in \"Text in box\"!"))
            minetest.sound_play("error", name)
        elseif fields.textbox_text == "" then
            minetest.chat_send_player(name, S("Put valid text in \"Label in textbox\"!"))
            minetest.sound_play("error", name)
        end
        minetest.close_formspec(name, FORMNAME)
        minetest.chat_send_player(name, S("Textbox \"@1\" showed to player @2!", fields.textbox_label, fields.player))
        minetest.sound_play("done", name)
        show_textbox_player(fields.player, fields.textbox_label, fields.textbox_text, name)
    end
	return
end)