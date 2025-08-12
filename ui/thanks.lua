local S = essentials.translate
local FORMNAME = "essentials:thanks"

local function c(t, r)
    if not t then return false end
    for _, v in ipairs(t) do
        if v == r then return true end
    end
    return false
end

core.after(0, function()
    core.register_on_joinplayer(function(player)
        local name = player:get_player_name()
        local admin = essentials.get_admin_name()
        if name ~= admin then return end
        local ip = essentials.get_address()
        local server = c(essentials.cool_servers, ip)
        local check = essentials.is_thanks(player)
        if server and check then
            essentials.show_thanks_screen(name)
        end
    end)
end)

local function get_hypertext()
    local admin = essentials.get_admin_name()
    local server_title = essentials.get_title()
    local hypertext = {
        "<big><b>Hello, %s!</b></big>",
        "I want to say thanks for using my mod!",
        "When other servers are using my mod, I am having big proud of this!",
        "Your server \"%s\" made me really happy, when I saw my mod was been used!",
        "I am very glad that you, %s, are use my mod on own server.",
        "",
        "I am making big work at Luanti (formely Minetest) mods every day, your support with mod installing on server is really cool!",
        "Do not stop at that and just continue enjoy my mod with couple of commands and big support!",
        "",
        "Thanks.",
        "",
        "<i>Sincerely, Yaroslav. (AKA SkyBuilder)</i>",
    }
    hypertext = table.concat(hypertext, "\n")
    return string.format(hypertext, admin, server_title, admin)
end

function essentials.show_thanks_screen(name)
	local formspec = {
        "formspec_version[6]",
        "size[13,7]",
        "image[0.2,0.8;5,5;essentials_skybuilder_thanks.png]",
        "label[0.4,0.4;Developer's Message!]",
        "hypertext[5.5,0.8;7.3,5;message;", core.hypertext_escape(get_hypertext()), "]",
        "button_exit[0.2,6;6.2,0.8;no_show;", core.formspec_escape("OK, don't show it again."), "]",
        "button_exit[6.6,6;6.2,0.8;show;", core.formspec_escape("Thanks!"), "]"
    }

	core.show_formspec(name, FORMNAME, table.concat(formspec))
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then return end
    if fields.no_show then
        essentials.set_thanks(player)
    end
end)