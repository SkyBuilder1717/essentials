local S = essentials.translate
local FORMNAME = "essentials:mute_menu"

function essentials.show_mute_menu(name)
    local formspec = {
        "formspec_version[6]",
        "size[12.5,4.5]",
		"dropdown[4.5,0.3;6.8,1.1;player;", essentials.get_players(), ";1;false]",
        "field[4.5,2;6.8,1.1;reason;", S("Mute duration (in seconds)"), ";]",
        "button[4.5,3.3;6.8,1.1;mute;", S("Un/Mute the player"), "]",
        "image[0.2,0.2;4.2,4.2;essentials_mute_user.png]",
        "image_button_exit[11.4,0.1;1,1;essentials_close_btn.png;close;]"
    }

	core.show_formspec(name, FORMNAME, table.concat(formspec))
end

local function check_mute(name)
    local data = essentials.muted_players[name]
    if data and os.time() >= data.expires then
        essentials.muted_players[name] = nil
        essentials.save_muted_players()
        core.change_player_privs(name, {shout = true})
        core.chat_send_all(S("Player @1 has been automatically unmuted.", essentials.get_nickname(name)))
    end
end

core.register_on_chat_message(function(name, message)
    check_mute(name)
    if essentials.muted_players[name] then
        core.chat_send_player(name, core.colorize("red", S("You are muted for @1 seconds more!", essentials.muted_players[name].expires - os.time())))
        return true
    end
end)

core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= FORMNAME then
        return
    end
    if core.is_singleplayer() then return end
    local name = player:get_player_name()
    local target = fields.player
    local duration = tonumber(fields.reason) or 0
    if fields.mute then
        if not core.get_player_by_name(target) then
            core.chat_send_player(name, core.colorize("red", S("Player @1 not found!", target)))
            essentials.player_sound("error", name)
            return
        end
        if target == name or target == core.settings:get("name") or core.check_player_privs(target, {server = true}) then
            core.chat_send_player(name, core.colorize("red", S("You cannot mute this player!")))
            essentials.player_sound("error", name)
            return
        end

        local shout = core.check_player_privs(target, {shout = true})
        if shout then
            if duration <= 0 then
                core.chat_send_player(name, core.colorize("red", S("Invalid duration!")))
                essentials.player_sound("error", name)
                return
            end
            essentials.muted_players[target] = {expires = os.time() + duration}
            core.change_player_privs(target, {shout = false})
            core.chat_send_all(S("Player @1 has been muted for @2 seconds.", essentials.get_nickname(target), duration))
        else
            essentials.muted_players[target] = nil
            core.change_player_privs(target, {shout = true})
            core.chat_send_all(S("Player @1 has been unmuted.", essentials.get_nickname(target)))
        end
        essentials.save_muted_players()
    end
end)
