function essentials.show_reports_log(name)
	local ids = ""
	if not essentials.reports == nil then
		for i, name in ipairs(essentials.reports.log) do
			if i == 1 then
				ids = id..name
			else
				ids = ids..","..name
			end
		end
	end
	core.chat_send_player(name, ids)

	local formspec = {
		"formspec_version[6]",
		"size[10.5,11]",
		"label[1.2,0.5;", S("Reports log"), "]",
		"textlist[0.7,1;9.1,9.3;report_logger;", ids, ";1;false]"
	}
	core.show_formspec(name, "essentials:reports_log", table.concat(formspec))
end