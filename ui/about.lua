local FORMNAME = "essentials:about"
-- ban menu
function show_about(name)
	local formspec = [[
        formspec_version[6]
        size[8.6,9.9]
        image[1.6,0.1;5.6,5.6;essentials_logo.png]
        label[3.3,6;ESSENTIALS]
        label[0.1,8.5;Builder Mods STUDIO™ — a studio that develops great]
        label[0.1,8.9;mods and games for Minetest ContentDB.]
        label[0.1,9.3;A studio that will always be topical\, a studio that will]
        label[0.1,9.7;create comfort in the game.]
        label[2.2,6.4;By Builder Mods STUDIO™]
        image[0.1,6.9;1,1;skybuilder.png]
        label[1.2,7.2;Builder Mods STUDIO™]
        label[1.2,7.6;By -SkyBuilder-]
    ]]

	minetest.show_formspec(name, FORMNAME, formspec)
end