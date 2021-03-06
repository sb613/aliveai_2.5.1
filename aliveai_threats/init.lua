if minetest.get_modpath("nitroglycerine")~=nil then
aliveai.create_bot({
		drop_dead_body=0,
		attack_players=1,
		name="nitrogen",
		team="ice",
		texture="aliveai_threats_nitrogen.png",
		stealing=1,
		steal_chanse=2,
		attacking=1,
		talking=0,
		light=0,
		building=0,
		escape=0,
		start_with_items={["default:snowblock"]=1,["default:ice"]=4},
		type="monster",
		dmg=1,
		hp=40,
		name_color="",
		arm=2,
		spawn_on={"default:silver_sand","default:dirt_with_snow","default:snow","default:snowblock","default:ice"},
	on_step=function(self,dtime)
		local pos=self.object:getpos()
		pos.y=pos.y-1.5
		local node=minetest.get_node(pos)
		if node and node.name and minetest.is_protected(pos,"")==false then
			if minetest.get_item_group(node.name, "soil")>0 then
				minetest.set_node(pos,{name="default:dirt_with_snow"})
			elseif minetest.get_item_group(node.name, "sand")>0  and minetest.registered_nodes["default:silver_sand"] then
				minetest.set_node(pos,{name="default:silver_sand"})
			elseif minetest.get_item_group(node.name, "water")>0 then
				minetest.set_node(pos,{name="default:ice"})
				pos.y=pos.y+1
				if minetest.get_item_group(minetest.get_node(pos).name, "water")>1 then
					minetest.set_node(pos,{name="default:ice"})
				end
			elseif minetest.get_item_group(node.name, "lava")>0 then
				minetest.set_node(pos,{name="default:ice"})
				pos.y=pos.y+1
				if minetest.get_item_group(minetest.get_node(pos).name, "lava")>1 then
					minetest.set_node(pos,{name="default:ice"})
				end
			end
		end
	end,
	on_punching=function(self,target)
		if aliveai.gethp(target)<=self.dmg+5 then
			aliveai_nitroglycerine.freeze(target)
		else
			target:punch(self.object,1,{full_punch_interval=1,damage_groups={fleshy=self.dmg}},nil)
		end
	end,
	on_death=function(self,puncher,pos)
		minetest.sound_play("default_break_glass", {pos=pos, gain = 1.0, max_hear_distance = 5,})
		aliveai_nitroglycerine.crush(pos)
	end,
})

aliveai.create_bot({
		drop_dead_body=0,
		attack_players=1,
		name="gassman",
		team="nuke",
		texture="aliveai_threats_gassman.png",
		attacking=1,
		talking=0,
		light=0,
		building=0,
		escape=0,
		--start_with_items={["default:snowblock"]=1,["default:ice"]=4},
		type="monster",
		dmg=0,
		hp=100,
		name_color="",
		arm=2,
		coming=0,
		smartfight=0,
		spawn_on={"group:sand","default:dirt_with_grass","default:dirt_with_dry_grass","default:gravel"},
		attack_chance=5,
	on_fighting=function(self,target)
		if not self.ti then self.ti={t=1,s=0} end
		self.temper=10
		self.ti.s=self.ti.s-1
		if self.ti.s<=0 then
			self.ti.t=self.ti.t-1
			if self.ti.t>=0 then
				self.ti.s=99
			end
		end
		if self.ti.t<0 then
			local pos=self.object:getpos()
			self.object:punch(self.object,1,{full_punch_interval=1,damage_groups={fleshy=self.object:get_hp()*2}},nil)
			aliveai_nitroglycerine.explode(pos,{
				radius=10,
				set="air",
				drops=0,
			})
			return self
		end

		local tag=self.ti.t ..":" .. self.ti.s
		self.object:set_properties({nametag=tag,nametag_color="#ff0000aa"})
	end,
	on_death=function(self,puncher,pos)
			if not self.ex then
				self.ex=true
				aliveai_nitroglycerine.explode(pos,{
				radius=2,
				set="air",
				})
			end
			return self
	end,
})



aliveai.create_bot({
		drop_dead_body=0,
		attack_players=1,
		name="nitrogenblow",
		team="ice",
		texture="aliveai_threats_nitrogenblow.png",
		attacking=1,
		talking=0,
		light=0,
		building=0,
		escape=0,
		start_with_items={["default:snowblock"]=10,["default:ice"]=2},
		spawn_on={"default:silver_sand","default:dirt_with_snow","default:snow","default:snowblock","default:ice"},
		type="monster",
		dmg=1,
		hp=30,
		name_color="",
		arm=2,
		coming=0,
		smartfight=0,
		spawn_on={"group:sand","default:dirt_with_grass","default:dirt_with_dry_grass","default:gravel"},
		attack_chance=5,
	on_fighting=function(self,target)
		if aliveai.gethp(target)<=self.dmg+5 then
			aliveai_nitroglycerine.freeze(target)
		elseif math.random(1,10)==1 then
			target:punch(self.object,1,{full_punch_interval=1,damage_groups={fleshy=self.dmg}},nil)
		end
		if not self.ti then self.ti={t=5,s=9} end
		self.temper=10
		self.ti.s=self.ti.s-1
		if self.ti.s<=0 then
			self.ti.t=self.ti.t-1
			if self.ti.t>=0 then
				self.ti.s=9
			end
		end
		if self.ti.t<0 then
			self.ex=true
			if aliveai.gethp(target)<=11 then
				aliveai_nitroglycerine.freeze(target)
			else
				target:punch(self.object,1,{full_punch_interval=1,damage_groups={fleshy=10}},nil)
			end
			aliveai_nitroglycerine.crush(self.object:getpos())
			self.object:punch(self.object,1,{full_punch_interval=1,damage_groups={fleshy=self.object:get_hp()*2}},nil)
			return self
		end
		local tag=self.ti.t ..":" .. self.ti.s
		self.object:set_properties({nametag=tag,nametag_color="#ff0000aa"})
	end,
	on_death=function(self,puncher,pos)
			minetest.sound_play("default_break_glass", {pos=pos, gain = 1.0, max_hear_distance = 5,})
			if not self.ex then
				self.ex=true
				self.aliveai_ice=1
				local radius=10
				aliveai_nitroglycerine.explode(pos,{
					--drops=0,
					--velocity=0,
					radius=radius,
					hurt=0,
					place={"default:snowblock","default:ice","default:snowblock"},
					place_chance=2,
				})

				for _, ob in ipairs(minetest.get_objects_inside_radius(pos, radius*2)) do
					local pos2=ob:getpos()
					local d=math.max(1,vector.distance(pos,pos2))
					local dmg=(8/d)*radius
					local en=ob:get_luaentity()
					if ob:is_player() or not (en and en.name=="aliveai_nitroglycerine:ice" or en.aliveai_ice) then
						if ob:get_hp()<=dmg+5 then
							nitroglycerine.freeze(ob)
						else
							ob:punch(self.object,1,{full_punch_interval=1,damage_groups={fleshy=dmg}},nil)
						end
					end
				end
			end
			return self
	end,
})
end

aliveai.create_bot({
		attack_players=1,
		name="terminator",
		team="nuke",
		texture="aliveai_threats_terminator.png",
		attacking=1,
		talking=0,
		--light=0,
		building=0,
		escape=0,
		start_with_items={["default:steel_ingot"]=4,["default:steelblock"]=1},
		type="monster",
		dmg=0,
		hp=200,
		arm=3,
		name_color="",
		spawn_on={"group:sand","default:dirt_with_grass","default:dirt_with_dry_grass","default:gravel"},
		attack_chance=5,
	on_punching=function(self,target)
		local pos=self.object:getpos()
		pos.y=pos.y-0.5
		local radius=self.arm
		for _, ob in ipairs(minetest.get_objects_inside_radius(pos, radius)) do
			local pos2=ob:getpos()
			local d=math.max(1,vector.distance(pos,pos2))
			local dmg=(8/d)*radius
			local en=ob:get_luaentity()
			if ob:is_player() or not (en and en.team==self.team or ob.itemstring) then
				if en and en.object then
					if en.type~="" then ob:punch(self.object,1,{full_punch_interval=1,damage_groups={fleshy=dmg}},nil) end
					dmg=dmg*2
					ob:setvelocity({x=(pos2.x-pos.x)*dmg, y=((pos2.y-pos.y)*dmg)+2, z=(pos2.z-pos.z)*dmg})
				elseif ob:is_player() then
					ob:punch(self.object,1,{full_punch_interval=1,damage_groups={fleshy=dmg}},nil)
					local d=dmg/2
					local v=0
					local dd=0
					local p2={x=pos.x-pos2.x, y=pos.y-pos2.y, z=pos.z-pos2.z}
					local tmp
					for i=0,10,1 do
						dd=d*v
						tmp={x=pos.x+(p2.x*dd), y=pos.y+(p2.y*dd)+2, z=pos.z+(p2.z*dd)}
						local n=minetest.get_node(tmp)
						if n and n.name and minetest.registered_nodes[n.name].walkable then
							if minetest.is_protected(tmp,"")==false and minetest.dig_node(tmp) then
								for _, item in pairs(minetest.get_node_drops(n.name, "")) do
									if item then
										local it=minetest.add_item(tmp, item)
										it:get_luaentity().age=890
										it:setvelocity({x = math.random(-1, 1),y=math.random(-1, 1),z = math.random(-1, 1)})
									end
								end
							else
								break
							end
						end
						v=v-0.1
					end
					d=d*v
					ob:setpos({x=pos.x+(p2.x*d), y=pos.y+(p2.y*d)+2, z=pos.z+(p2.z*d)})
				end
			end
		end
	end,
	on_load=function(self)
		self.hp2=self.object:get_hp()
	end,
	on_punched=function(self,puncher)
		if self.hp2 and self.hp2-self.object:get_hp()<5 then
			self.object:set_hp(self.hp2)
			return self
		end
		local pos=self.object:getpos()
			minetest.add_particlespawner({
			amount = 5,
			time =0.05,
			minpos = pos,
			maxpos = pos,
			minvel = {x=-2, y=-2, z=-2},
			maxvel = {x=1, y=0.5, z=1},
			minacc = {x=0, y=-8, z=0},
			maxacc = {x=0, y=-10, z=0},
			minexptime = 2,
			maxexptime = 1,
			minsize = 0.1,
			maxsize = 2,
			texture = "default_steel_block.png",
			collisiondetection = true,
			spawn_chance=100,
		})
	end
})



aliveai.create_bot({
		attack_players=1,
		name="pull_monster",
		team="pull",
		texture="aliveai_threats_pull.png",
		visual_size={x=0.8,y=1.4},
		collisionbox={-0.33,-1.3,-0.33,0.33,1.5,0.33},
		attacking=1,
		talking=0,
		light=-1,
		lowest_light=9,
		building=0,
		smartfight=0,
		escape=0,
		type="monster",
		dmg=0,
		hp=80,
		arm=2,
		name_color="",
		spawn_on={"group:sand","default:dirt_with_grass","default:dirt_with_dry_grass","group:stone","default:snow"},
		attack_chance=3,
		spawn_chance=200,
	on_punching=function(self,target)
		if not self.pull_down then
			local pos=aliveai.roundpos(target:getpos())
			local n=minetest.get_node(pos)
			if minetest.registered_nodes[n.name] and minetest.registered_nodes[n.name].walkable then return end
			pos.y=pos.y-1
			self.pull_down={pos={pos0=pos}}
			local p
			for i=1,3,1 do
				p={x=pos.x,y=pos.y-i,z=pos.z}
				n=minetest.get_node(p)
				self.pull_down.pos["pos" .. i]=p
				if minetest.registered_nodes[n.name] and minetest.registered_nodes[n.name].walkable==false then
					self.pull_down=nil
					return
				end
			end
			self.pull_down.target=target
		end
	end,
	on_detect_enemy=function(self,target)
		self.object:set_properties({
			mesh = aliveai.character_model,
			textures = {"aliveai_threats_pull.png"},
		})
	end,
	on_load=function(self)
		self.move.speed=0.5
		local pos=aliveai.roundpos(self.object:getpos())
		local n=minetest.get_node(pos)
		if minetest.registered_nodes[n.name] and minetest.registered_nodes[n.name].walkable then
			pos.y=pos.y+3
			local l=minetest.get_node_light(pos)
			if not l then return end
			local n=minetest.get_node(pos)
			if minetest.registered_nodes[n.name] and minetest.registered_nodes[n.name].walkable then
				self.domovefromslp=true
				return self
			elseif l>9 then
				self.sleeping={ground=pos}
				return self
			else
				self.domovefromslp=true
				return self
			end
		end
	end,
	on_step=function(self,dtime)
		if self.movefromslp then
			aliveai.rndwalk(self,false)
			aliveai.stand(self)
			for i, v in pairs(self.movefromslp) do
				self.object:moveto(v)
				table.remove(self.movefromslp,i)
				return self
			end
			self.movefromslp=nil
			return self
		end
		if self.domovefromslp then
			self.domovefromslp=nil
			local pos=self.object:getpos()
			local gpos={x=pos.x,y=pos.y+3,z=pos.z}
			local n=minetest.get_node(gpos)
			if minetest.registered_nodes[n.name] and minetest.registered_nodes[n.name].walkable then
				self.movefromslp={} -- move up from stuck sleep pos
				local p3=0
				for i=1,103,1 do
					p={x=gpos.x,y=gpos.y+i,z=gpos.z}
					local n=minetest.get_node(p)
					self.movefromslp[i]=p
					if minetest.registered_nodes[n.name] and minetest.registered_nodes[n.name].walkable==false then
						p3=p3+1
						if p3>2 then
							self.sleeping=nil
							return self
						end
					else
						p3=0
					end
				end
				aliveai.punch(self,self.object,self.object:get_hp()*2)
				return self
			end
		end
		if self.sleeping then
			local pos=aliveai.roundpos(self.object:getpos())
			if self.sleeping.pos then
				if self.sleeping.pos.pos0 then
					self.object:moveto(self.sleeping.pos.pos0)
					self.sleeping.pos.pos0=nil
				elseif self.sleeping.pos.pos1 then
					self.object:moveto(self.sleeping.pos.pos1)
					self.sleeping.pos.pos1=nil
				elseif self.sleeping.pos.pos2 then
					self.object:moveto(self.sleeping.pos.pos2)
					self.sleeping.pos=nil
				end
				if not self.pull_down then return self end
			end
			if self.pull_down then
				if self.pull_down.target and self.pull_down.pos then
					if self.pull_down.pos.pos0 and not (self.sleeping.pos and self.sleeping.pos.pos2) then 
						self.pull_down=nil
						self.sleeping=nil
						return
					end
					if self.pull_down.pos.pos0 then
						self.pull_down.target:moveto(self.pull_down.pos.pos0)
						self.pull_down.pos.pos0=nil
					elseif self.pull_down.pos.pos1 then
						self.pull_down.target:moveto(self.pull_down.pos.pos1)
						self.pull_down.pos.pos1=nil
					elseif self.pull_down.pos.pos2 then
						self.pull_down.target:moveto(self.pull_down.pos.pos2)
						self.pull_down.pos=nil
					end
					return self
				end
				if self.pull_down.target and aliveai.gethp(self.pull_down.target)>0 and aliveai.distance(self,self.pull_down.target:getpos())<=self.arm+1 then
					aliveai.punch(self,self.pull_down.target,1)
					if aliveai.gethp(self.pull_down.target)<=0 then
						self.object:set_hp(self.hp_max)
						aliveai.showhp(self,true)
						self.domovefromslp=true
					end
					return self
				else
					self.sleeping=nil
					self.pull_down=nil
					return
				end
			end
			if self.hide then
				self.time=self.otime
				if math.random(1,2)==1 then
					if not self.abortsleep then
						for _, ob in ipairs(minetest.get_objects_inside_radius(self.sleeping.ground, 10)) do
							local en=ob:get_luaentity()
							if not (en and en.aliveai and en.team==self.team) then
								return self
							end
						end
					end
					self.hide=nil
					self.pull_down=nil
					self.domovefromslp=true
				end
				if self.hide then return self end
			end
			local l=minetest.get_node_light(self.sleeping.ground)
			if not l then
				aliveai.punch(self,self.object,self.object:get_hp()*2)
				self.sleeping=nil
				self.domovefromslp=true
				return self
			elseif l<=9 or self.abortsleep then
				self.domovefromslp=true
			else
				if math.random(1,10)==1 then
					for _, ob in ipairs(minetest.get_objects_inside_radius(self.sleeping.ground, self.distance)) do
						local en=ob:get_luaentity()
						if not (en and en.aliveai and en.team==self.team) then
							return self
						end
					end
					aliveai.punch(self,self.object,self.object:get_hp()*2)
				end
				return self
			end
		elseif math.random(1,10)==1 or self.pull_down or self.hide then
			local pos=aliveai.roundpos(self.object:getpos())
			pos.y=pos.y-1
			local l=minetest.get_node_light(pos)
			if not l then return end
			if l>9 or self.pull_down or self.hide then
				local p
				self.sleeping={ground=pos,pos={pos0=pos}}
				for i=1,3,1 do
					p={x=pos.x,y=pos.y-i,z=pos.z}
					local n=minetest.get_node(p)
					self.sleeping.pos["pos" .. i]=p
					if minetest.registered_nodes[n.name] and minetest.registered_nodes[n.name].walkable==false then
						self.sleeping=nil
						self.pull_down=nil
						return
					end
				end
				aliveai.rndwalk(self,false)
				aliveai.stand(self)
				return self
			end
		elseif math.random(1,10)==1 then
			local pos=self.object:getpos()
			pos.y=pos.y-1.5
			local n=minetest.get_node(pos)
			if minetest.registered_nodes[n.name] and minetest.registered_nodes[n.name].tiles then
				local tiles=minetest.registered_nodes[n.name].tiles
				if type(tiles)=="table" and type(tiles[1])=="string" then
				self.tex=tiles[1]
				self.object:set_properties({
					mesh = aliveai.character_model,
					textures = {tiles[1]},
				})
				end
			end 
		end
	end,
	on_punched=function(self,puncher)
		self.object:set_properties({
			mesh = aliveai.character_model,
			textures = {"aliveai_threats_pull.png"},
		})
		local pos=self.object:getpos()
			minetest.add_particlespawner({
			amount = 5,
			time =0.05,
			minpos = pos,
			maxpos = pos,
			minvel = {x=-2, y=-2, z=-2},
			maxvel = {x=1, y=0.5, z=1},
			minacc = {x=0, y=-8, z=0},
			maxacc = {x=0, y=-10, z=0},
			minexptime = 2,
			maxexptime = 1,
			minsize = 0.1,
			maxsize = 2,
			texture = self.tex or "default_dirt.png",
			collisiondetection = true,
		})
		self.tex=nil
		if self.sleeping or self.hide then self.abortsleep=true end
		if self.hide or not self.fight then return end
		if not self.ohp then self.ohp=self.object:get_hp()*0.8 return end
		if self.ohp>self.object:get_hp() then
			local pos=self.object:getpos()
			local n=minetest.get_node(pos)
			if minetest.registered_nodes[n.name] and minetest.registered_nodes[n.name].walkable then return end
			self.hide=true
			self.ohp=nil
			self.time=0.2
			self.pull_down=nil
			return self
		end
	end
})

minetest.register_craft({
	output = "aliveai_threats:mind_manipulator",
	recipe = {
		{"default:steel_ingot", "default:papyrus"},
		{"default:steel_ingot", "default:mese_crystal"},
		{"default:steel_ingot", "default:obsidian_glass"},
	}
})

minetest.register_tool("aliveai_threats:mind_manipulator", {
	description = "Mind manipulator",
	inventory_image = "aliveai_threats_mind_manipulator.png",
		on_use = function(itemstack, user, pointed_thing)
			if pointed_thing.type=="object" then
				local ob=pointed_thing.ref
				if ob:get_luaentity() and ob:get_luaentity().type and ob:get_luaentity().type=="monster" then
					ob:get_luaentity().team="mind_manipulator" .. math.random(1,100)
				elseif ob:get_luaentity() then
					ob:get_luaentity().type="monster"
					ob:get_luaentity().team="mind_manipulator" .. math.random(1,100)
					ob:get_luaentity().attack_players=1
					ob:get_luaentity().attacking=1
					ob:get_luaentity().talking=0
					ob:get_luaentity().light=0
					ob:get_luaentity().building=0
					ob:get_luaentity().fighting=1
					ob:get_luaentity().attack_chance=2
--support for other mobs
					ob:get_luaentity().attack_type="dogfight"
					ob:get_luaentity().reach=2
					ob:get_luaentity().damage=3
					ob:get_luaentity().view_range=10
					ob:get_luaentity().walk_velocity= ob:get_luaentity().walk_velocity or 2
					ob:get_luaentity().run_velocity= ob:get_luaentity().run_velocity or 2
				elseif ob:is_player() then
					ob:punch(ob,1,{full_punch_interval=1,damage_groups={fleshy=5}},nil)
						ob:set_properties({
							mesh = aliveai.character_model,
							textures = {"aliveai_threats_mind_manipulator.png"}
						})
					if ob:get_hp()<=0 and aliveai.registered_bots["bot"] and aliveai.registered_bots["bot"].bot=="aliveai:bot" then
						local tex=ob:get_properties().textures
						local pos=ob:getpos()
						local m=minetest.add_entity(pos, "aliveai:bot")
						m:get_luaentity().attack_chance=2
						m:get_luaentity().type="monster"
						m:get_luaentity().team="mind_manipulator" .. math.random(1,100)
						m:get_luaentity().attack_players=1
						m:get_luaentity().attacking=1
						m:get_luaentity().talking=0
						m:get_luaentity().light=0
						m:get_luaentity().building=0
						m:get_luaentity().fighting=1
						m:setyaw(math.random(0,6.28))
						m:set_properties({
							mesh = aliveai.character_model,
							textures = tex
						})
					end
				end
			end
		end
})


aliveai.create_bot({
		drop_dead_body=0,
		attack_players=1,
		name="cockroach",
		team="bug",
		texture={"aliveai_threats_cockroach.png","aliveai_threats_cockroach.png","aliveai_threats_cockroach.png","aliveai_threats_cockroach.png","aliveai_threats_cockroach.png","aliveai_threats_cockroach.png"},
		attacking=1,
		talking=0,
		light=0,
		building=0,
		escape=0,
		type="monster",
		dmg=1,
		hp=4,
		name_color="",
		arm=2,
		coming=0,
		smartfight=0,
		spawn_on={"group:sand","default:dirt_with_grass","default:dirt_with_dry_grass","default:gravel"},
		attack_chance=2,
		visual="cube",
		visual_size={x=0.4,y=0.001},
		collisionbox={-0.1,0,-0.1,0.2,0.1,0.2},
		basey=0,
		distance=10,
	on_load=function(self)
		if self.save then
			self.object:remove()
		end
	end,
	on_step=function(self,dtime)
		if self.fight then
			local pos=aliveai.roundpos(self.object:getpos())
			local n=0
			for _, ob in ipairs(minetest.get_objects_inside_radius(pos, 20)) do
				local en=ob:get_luaentity()
				if en and en.name=="aliveai_threats:cockroach" then
					n=n+1
				end
			end
			if n<10 then
				for y=-2,5,1 do
				for x=-2,2,1 do
				for z=-2,2,1 do
					local p1={x=pos.x+x,y=pos.y+y,z=pos.z+z}
					local p2={x=pos.x+x,y=pos.y+y-1,z=pos.z+z}
					local no1=minetest.get_node(p1).name
					local no2=minetest.get_node(p2).name
					if not (minetest.registered_nodes[no1] and minetest.registered_nodes[no2]) then return end
					if minetest.registered_nodes[no1].walkable==false and minetest.registered_nodes[no2].walkable
					and aliveai.visiable(pos,p1) then
						local e=minetest.add_entity(p1,"aliveai_threats:cockroach")
						e:get_luaentity().save=1
						e:get_luaentity().fight=self.fight
						e:get_luaentity().temper=3
						e:setyaw(math.random(0,6.28))
						n=n+1
						if n>=10 then
							return
						end
					end
					end
					end
				end
			end
		elseif self.save and not self.fight then
			self.object:punch(self.object,1,{full_punch_interval=1,damage_groups={fleshy=self.object:get_hp()*2}},nil)
		end
	end,
	on_click=function(self,clicker)
		clicker:punch(self.object,1,{full_punch_interval=1,damage_groups={fleshy=self.object:get_hp()*2}},nil)
	end,
	on_death=function(self,puncher,pos)
		local pos=self.object:getpos()
			minetest.add_particlespawner({
			amount = 5,
			time =0.05,
			minpos = pos,
			maxpos = pos,
			minvel = {x=-2, y=-2, z=-2},
			maxvel = {x=1, y=0.5, z=1},
			minacc = {x=0, y=-8, z=0},
			maxacc = {x=0, y=-10, z=0},
			minexptime = 2,
			maxexptime = 1,
			minsize = 0.1,
			maxsize = 1,
			texture = "default_dirt.png^[colorize:#000000cc",
			collisiondetection = true,
		})
		return self
	end,
})