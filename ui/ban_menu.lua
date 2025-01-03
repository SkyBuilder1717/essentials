local S = essentials.translate
local FORMNAME = "essentials:ban_menu"

function essentials.show_ban_menu(name)
	local formspec = "formspec_version[6]"
	local ids = ""
	for _, player in ipairs(core.get_connected_players()) do
		ids = ids..","..player:get_player_name()
	end

	formspec = formspec..
        "size[12.5,4.5]"..
		"dropdown[4.5,0.3;6.8,1.1;player;"..ids..";1;false]"..
        "field[4.5,2;6.8,1.1;reason;"..S("Reason of ban")..";]"..
        "button[4.5,3.3;6.8,1.1;ban;"..S("Ban the player").."]"..
        "image[0.2,0.2;4.2,4.2;essentials_ban_user.png]"..
        "image_button_exit[11.4,0.1;1,1;essentials_close_btn.png;close;]"

	core.show_formspec(name, FORMNAME, formspec)
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
    local player_ban = core.get_player_by_name(fields.player)

    if fields.ban then
        if core.is_singleplayer() then
            core.chat_send_player(name, core.colorize("red", S("You cannot ban in single mode!")))
            essentials.player_sound("error", name)
            return
        end
        local player_banned = fields.player
        if player_banned == name then
            core.chat_send_player(name, core.colorize("red", S("You cannot ban yourself!")))
            essentials.player_sound("error", name)
            return
        end
        local reason_ban = fields.reason
        if core.check_player_privs(player_banned, {server = true}) then
            core.chat_send_player(name, core.colorize("red", S("You cannot ban administrator!")))
            essentials.player_sound("error", name)
            return
        end
        if player_banned == core.settings:get("name") then
            core.chat_send_player(name, core.colorize("red", S("You cannot ban server owner!")))
            essentials.player_sound("error", name)
            return
        end
        core.ban_player(fields.player)
        if reason_ban == "" then
            core.chat_send_all(S("Banned @1.", player_banned))
        else
            core.chat_send_all(S("Banned @1 for @2.", player_banned, reason_ban))
        end
        essentials.play_sound("error")
    end
end)