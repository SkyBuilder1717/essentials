local S = essentials.translate
local FORMNAME = "essentials:mute_menu"

function essentials.show_mute_menu(name)
	local formspec = "formspec_version[6]"
    local ids = ""
	for _, player in ipairs(core.get_connected_players()) do
		ids = ids..","..player:get_player_name()
	end

    formspec = formspec..
        "size[12.5,4.5]"..
		"dropdown[4.5,0.3;6.8,1.1;player;"..ids..";1;false]"..
        "button[4.5,2;6.8,1.1;mute;"..S("Un/Mute the player").."]"..
        "image[0.2,0.2;4.2,4.2;essentials_mute_user.png]"..
        "image_button_exit[11.4,0.1;1,1;essentials_close_btn.png;close;]"

	core.show_formspec(name, FORMNAME, formspec)
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
    local name = player:get_player_name()
    essentials.player_sound("clicked", name)

    local mp = fields.player

    if fields.mute then
        if core.is_singleplayer() then
            core.chat_send_player(name, core.colorize("red", S("You cannot mute in single mode!")))
            essentials.player_sound("error", name)
            return
        end
        if not core.get_player_by_name(mp) then
            core.chat_send_player(name, core.colorize("red", S("Player @1 not found!", mp)))
            essentials.player_sound("error", name)
            return
        end
        if mp == name then
            core.chat_send_player(name, core.colorize("red", S("You cannot mute yourself!")))
            essentials.player_sound("error", name)
            return
        end
        if core.check_player_privs(mp, {server = true}) then
            core.chat_send_player(name, core.colorize("red", S("You cannot mute administrator!")))
            essentials.player_sound("error", name)
            return
        end
        if mp == core.settings:get("name") then
            core.chat_send_player(name, core.colorize("red", S("You cannot mute server owner!")))
            essentials.player_sound("error", name)
            return
        end

        local shout = core.check_player_privs(mp, {shout = true})
        if shout then
            core.chat_send_all(S("Player @1 has been muted.", mp))
            core.change_player_privs(mp, {shout = false})
        else
            core.chat_send_all(S("Player @1 have been unmuted.", mp))
            core.change_player_privs(mp, {shout = true})
        end
    end
end)