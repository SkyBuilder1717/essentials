local S = essentials.translate
local FORMNAME = "essentials:ban_menu"
local xban2_mod = core.get_modpath("xban2") and core.global_exists("xban2")

function essentials.show_ban_menu(name)
	local formspec = {
        "formspec_version[6]",
        "size[12.5,4.5]",
		"dropdown[4.5,0.3;6.8,1.1;player;", essentials.get_players(), ";1;false]",
        "field[4.5,2;6.8,1.1;reason;", S("Reason of ban"), ";]",
        "button[4.5,3.3;6.8,1.1;ban;", S("Ban the player"), "]",
        "image[0.2,0.2;4.2,4.2;essentials_ban_user.png]",
        "image_button_exit[11.4,0.1;1,1;essentials_close_btn.png;close;]"
    }

	core.show_formspec(name, FORMNAME, table.concat(formspec))
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
    local name = player:get_player_name()
    essentials.player_sound("clicked", name)

    if not fields.player or not core.get_player_by_name(fields.player) then
        return
    end

    if fields.ban then
        if core.is_singleplayer() then
            core.chat_send_player(name, core.colorize("red", S("You cannot ban in single mode!")))
            essentials.player_sound("error", name)
            return
        end
        local banned = fields.player
        if banned == name then
            core.chat_send_player(name, core.colorize("red", S("You cannot ban yourself!")))
            essentials.player_sound("error", name)
            return
        end
        local reason = fields.reason
        if core.check_player_privs(banned, {server = true}) then
            core.chat_send_player(name, core.colorize("red", S("You cannot ban administrator!")))
            essentials.player_sound("error", name)
            return
        end
        if banned == core.settings:get("name") then
            core.chat_send_player(name, core.colorize("red", S("You cannot ban server owner!")))
            essentials.player_sound("error", name)
            return
        end
        if xban2_mod then
            xban.ban_player(banned, name, nil, reason)
        else
            core.ban_player(fields.player)
        end
        if reason == "" then
            core.chat_send_all(S("Banned @1.", banned))
        else
            core.chat_send_all(S("Banned @1 for @2.", banned, reason))
        end
        essentials.play_sound("error")
    end
end)