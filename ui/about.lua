local S = essentials.translate
local FORMNAME = "essentials:about"

local function get_hypertext()
    local hypertext = {
        "<big><b>About Essentials</b></big>",
        "Essentials — Luanti mod, inspired by EssentialsX plug-in for Minecraft.",
        "Mod was intended to be command overhaul, to make moderation for the admin easier.",
        "",
        "<i>More information coming soon...</i>"
    }
    return table.concat(hypertext, "\n")
end

function essentials.show_about_screen(name)
	local formspec = {
        "formspec_version[6]",
        "size[12,6]",
        "hypertext[0.1,0.1;5.8,5.8;about;", core.hypertext_escape(get_hypertext()), "]",
        "image[6.1,0.1;5.8,5.8;essentials_skybuilder_approved.png]"
    }

	core.show_formspec(name, FORMNAME, table.concat(formspec))
end