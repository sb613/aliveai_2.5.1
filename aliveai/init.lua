aliveai={
	character_model="character.b3d",	--character model
	check_spawn_space=true,
	enable_build=true,
	status=false,			--show bot status
	tools=1,				--hide bot tools
	max_num=50,			--max bots
	max_num_by_self=7,		--max spawned bots by self
	max_num_by_self_monsters=12,	--max spawned monsters by self
	get_everything_to_build_chance=100,
	msg={},				--messages to bots
	registered_bots={},		--registered_bots
	active={},			--active bots
	active_num=0,			--active bots count
	regulate_prestandard=0,
	smartshop=minetest.get_modpath("smartshop")~=nil,
	mesecons=minetest.get_modpath("mesecons")~=nil,
				--staplefood database, add eatable stuff to the list, then can all other bots check if them have something like that to eat when they gets hurted
	staplefood=		{["default:apple"]=1,["farming:bread"]=1,["mobs:meat"]=1,["mobs:meat_raw"]=1,},
	furnishings=		{"default:torch","default:chest","default:furnace","default:chest_locked","default:sign_wall_wood","default:sign_wall_steel","vessels:steel_bottle","vessels:drinking_glass","vessels:glass_bottle"},
	basics=			{"default:desert_stone","default:sandstonebrick","default:sandstone","default:snowblock","default:ice","default:dirt","default:sand","default:desert_sand","default:silver_sand","default:stone","default:leaves"},
	windows=		{"default:glass"},
	ladders=			{"default:ladder_wood","default:ladder_steel"},
	standard={"w","s"},	--short names/group (wood stone) have to be added to the "aliveai.namecut" and "aliveai.newneed"
	tools_handler={		-- see extras.lua for use
		default={
			try_to_craft=true,
			use=false,
			tools={"pick_wood","pick_stone","steel_steel","pick_mese","pick_diamond"},
		}
	},




}
dofile(minetest.get_modpath("aliveai") .. "/base.lua")
dofile(minetest.get_modpath("aliveai") .. "/event.lua")
dofile(minetest.get_modpath("aliveai") .. "/other.lua")
dofile(minetest.get_modpath("aliveai") .. "/items.lua")
dofile(minetest.get_modpath("aliveai") .. "/missions.lua")
dofile(minetest.get_modpath("aliveai") .. "/chat.lua")
dofile(minetest.get_modpath("aliveai") .. "/bot.lua")
dofile(minetest.get_modpath("aliveai") .. "/extras.lua")

aliveai.create_bot()								-- create standard bots
aliveai.create_bot({							-- create standard bots 2
		attack_players=1,
		name="bot2",
		team="Jezy",
		texture="aliveai_skin2.png",
		stealing=1,
		steal_chanse=5,
})

print("[aliveai] Loaded")