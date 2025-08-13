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

local function utf8len(s)
    local _, c = s:gsub("[^\128-\191]", "")
    return c
end

local function utf8sub(s, char, endchar)
    local start = 1
    while char > 1 do
        local byte = string.byte(s, start)
        if byte >= 240 then
            start = start + 4
        elseif byte >= 224 then
            start = start + 3
        elseif byte >= 192 then
            start = start + 2
        else
            start = start + 1
        end
        char = char - 1
    end

    local cur = start
    while endchar and endchar >= 1 do
        local byte = string.byte(s, cur)
        if byte >= 240 then
            cur = cur + 4
        elseif byte >= 224 then
            cur = cur + 3
        elseif byte >= 192 then
            cur = cur + 2
        else
            cur = cur + 1
        end
        endchar = endchar - 1
    end

    return string.sub(s, start, cur - 1)
end

function essentials.trim(text, limit)
    if utf8len(text) > limit then
        return utf8sub(text, 1, limit) .. "..."
    else
        return text
    end
end

function essentials.get_players()
    local pls = ""
    for _, p in ipairs(core.get_connected_players()) do
		pls = pls..","..p:get_player_name()
	end
    return pls
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if not string.find(formname, "essentials:") then return end
	essentials.player_sound("clicked", player:get_player_name())
end)