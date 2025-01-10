local thanks_ok_meta = "__essentials_thanks_screen__ok_dont_show"

function essentials.play_sound(sound)
    if not sound then return end
    for _, p in ipairs(core.get_connected_players()) do
        core.sound_play("essentials_"..sound, p:get_player_name())
    end
end

function essentials.player_sound(sound, name)
    if not name then return end
    if not sound then return end
    core.sound_play("essentials_"..sound, name)
end

function essentials.get_address()
    local address = core.settings:get("server_address")
    local ip = core.settings:get("server_ip")
    if address == "" then address = nil end
    if ip == "" then ip = nil end
    return address or ip or ""
end

function essentials.get_title()
    return core.settings:get("server_name")
end

function essentials.get_admin_name()
    return core.settings:get("name")
end

function essentials.is_thanks(player)
    local meta = player:get_meta()
    local thanks = meta:get_string(thanks_ok_meta)
    if thanks == "" then
        return true
    end
    return false
end

function essentials.set_thanks(player)
    local meta = player:get_meta()
    meta:set_string(thanks_ok_meta, "yes")
end