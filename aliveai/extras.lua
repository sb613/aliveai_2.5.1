--print(debug.getinfo(2).name)				-- get name from calling function

if minetest.get_modpath("bows") then
	aliveai.tools_handler.bows={--mod name
			try_to_craft=false, -- because its very unsure if they ever will be able to craft them
			use=true,
			tool_group="bow", -- item/node groups
			--tools={"bow_wood","bow_stone","bow_steel","bow_bronze","bow_obsidian","bow_mese","bow_diamond","bow_rainbow","bow_admin"},
			--amo="bows:arrow",
			amo_group="arrow", -- item/node groups
			amo_index=1,
			tool_index=2,
			tool_reuse=1,
			tool_near=0,
			tool_see=1,
			tool_chance=3,
		}
end

minetest.register_chatcommand("aliveai", {
	params = "",
	description = "aliveai settings",
	privs = {server=true},
	func = function(name, param)
		if string.find(param,"status=true")~=nil then
			aliveai.status=true
			minetest.chat_send_player(name, "<aliveai> bot status on")
		elseif string.find(param,"status=false")~=nil then
			aliveai.status=false
			minetest.chat_send_player(name, "<aliveai> bot status off")
		elseif string.find(param,"count")~=nil then
			minetest.chat_send_player(name, "<aliveai> max:".. aliveai.max_num .." by self:" .. aliveai.max_num_by_self .." monsters by self:" .. aliveai.max_num_by_self_monsters .." bots: " .. aliveai.active_num)
		end
	end
})