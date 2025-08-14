local FORMNAME = "essentials:kick_menu"
local S = essentials.translate

function essentials.show_kick_menu(name)
    local formspec = {
        "formspec_version[6]",
        "size[12.5,4.5]",
		"dropdown[4.5,0.3;6.8,1.1;player;", essentials.get_players(), ";1;false]",
        "field[4.5,2;6.8,1.1;reason;", S("Reason of kick"), ";]",
        "button[4.5,3.3;6.8,1.1;kick_btn;", S("Kick the player"), "]",
        "image[0.2,0.2;4.2,4.2;essentials_kick_user.png]",
        "image_button_exit[11.4,0.1;1,1;essentials_close_btn.png;close_btn;]"
    }

	core.show_formspec(name, FORMNAME, table.concat(formspec))
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
    if core.is_singleplayer() then return end
    local name = player:get_player_name()
    if fields.kick_btn then
        local target = fields.player
        if not core.get_player_by_name(target) then
            core.chat_send_player(name, core.colorize("red", S("Player @1 not found!", target)))
            essentials.player_sound("error", name)
            return
        end
        if target == name or target == core.settings:get("name") or core.check_player_privs(target, {server = true}) then
            core.chat_send_player(name, core.colorize("red", S("You cannot kick this player!")))
            essentials.player_sound("error", name)
            return
        end

        local reason = fields.reason
        if reason == "" then
            core.kick_player(fields.player)
            core.chat_send_all(S("Kicked @1.", essentials.get_nickname(target)))
            essentials.play_sound("kicked")
        else
            core.kick_player(fields.player, fields.reason)
            core.chat_send_all(S("Kicked @1 for @2.", essentials.get_nickname(target), reason))
            essentials.play_sound("kicked")
        end
    end
end)