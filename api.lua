local thanks_ok_meta = "__essentials_thanks_screen__ok_dont_show"

function essentials.player_sound(sound, name)
    if not sound then return end
    if not name then return end
    core.sound_play("essentials_"..sound, {to_player = name})
end

function essentials.play_sound(sound)
    if not sound then return end
    for _, p in pairs(core.get_connected_players()) do
        essentials.player_sound(sound, p:get_player_name())
    end
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

function essentials.get_nickname(name)
    local player = core.get_player_by_name(name)
    if not player then return name end
    local color = player:get_meta():get_string("_essentials_nametag_color")
    if color == "" then return name end
	return core.colorize(color, name)
end

function essentials.update_nickname(player)
    local name = player:get_player_name()
    local new_name = essentials.hide_names[name]
    local color = player:get_meta():get_string("_essentials_nametag_color")
    if color == "" then return end
    if new_name then
        player:set_properties({
            nametag = core.colorize("#AAAAAA", "*")..core.colorize(color, new_name)
        })
        return
    end
    player:set_properties({
        nametag = core.colorize(color, name)
    })
end

local worldpath = core.get_worldpath().."/"
local data_reports = "essentials_reports.json"
local data_nicknames = "essentials_nicknames.json"
local data_muted_players = "essentials_muted_players.json"

local function write_file(path, content)
    local f = io.open(path, "w")
    f:write(content)
    f:close()
end

local function read_file(path)
    local f = io.open(path, "r")
    if not f then
        return nil
    end
    local txt = f:read("*all")
    f:close()
    return txt
end

function essentials.save_reports()
    local tbl = essentials.reports
    local content = core.write_json(tbl)
    local path = worldpath..data_reports
    write_file(path, content)
end

function essentials.load_reports()
    local content = read_file(worldpath..data_reports)
    if not content then return false end
    local tbl = core.parse_json(content) or {}
    essentials.reports = tbl
    return true
end

function essentials.save_nicknames()
    local tbl = essentials.hide_names
    local content = core.write_json(tbl)
    local path = worldpath..data_nicknames
    write_file(path, content)
end

function essentials.load_nicknames()
    local content = read_file(worldpath..data_nicknames)
    if not content then return false end
    local tbl = core.parse_json(content) or {}
    essentials.hide_names = tbl
    return true
end

function essentials.save_muted_players()
    local tbl = essentials.muted_players
    local content = core.write_json(tbl)
    local path = worldpath..data_muted_players
    write_file(path, content)
end

function essentials.load_muted_players()
    local content = read_file(worldpath..data_muted_players)
    if not content then return false end
    local tbl = core.parse_json(content) or {}
    essentials.muted_players = tbl
    return true
end

function essentials.add_report(broked_rule, name, reported, description)
    local newid = tostring(math.random(1000, 9999), 4)
    essentials.reports[newid] = {
        broken_rule = broked_rule,
        by_name = name,
        reported_name = reported,
        about = description
    }

    essentials.save_reports()
end

function essentials.appdec_report(id, state, admin)
    local def = essentials.reports[id]
    local player = core.get_player_by_name(def.by_name)
    if def then
        if state == "decline" then
            if player then
                core.chat_send_player(def.by_name, S("Your report @1 to player @2 is @3.", "\""..core.colorize("gray", def.broken_rule).."\"", core.colorize("lightgray", def.reported_name), core.colorize("red", S("Declined"))))
            end
            core.log("action", admin.." declined report for "..def.reported_name.." (broken rule: "..def.broken_rule..")")
        elseif state == "approve" then
            if player then
                core.chat_send_player(def.by_name, S("Your report @1 to player @2 has been @3 and coming soon that player will get punishment!", "\""..core.colorize("gray", def.broken_rule).."\"", core.colorize("lightgray", def.reported_name), core.colorize("lime", S("Approved"))))
            end
            core.log("action", admin.." approved report for "..def.reported_name.." (broken rule: "..def.broken_rule..")")
        end
    end
    essentials.reports[id] = nil
    essentials.save_reports()
end

local function remove_report(id)
    for aid, def in ipairs(essentials.reports) do
        if def.id == id then
            essentials.reports[aid] = nil
        end 
    end
    essentials.save_reports()
end

if essentials.reports_system then
    core.register_on_mods_loaded(function()
        essentials.load_reports()
        essentials.load_nicknames()
        essentials.load_muted_players()
    end)
end