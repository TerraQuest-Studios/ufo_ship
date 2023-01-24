ufo_ship.tnt = {}

function ufo_ship.tnt.boom(pos, def)
    if tnt then tnt.boom(pos, def) end
end

--fake graphics only explosion
function ufo_ship.tnt.graphics_boom(pos, def)
    minetest.add_particle({
		pos = pos,
		expirationtime = 0.4,
		size = 15,
		texture = tnt and "tnt_boom.png" or minetest.registered_nodes["mapgen_stone"].tiles[1],
		glow = 15,
	})
    minetest.add_particlespawner({
		amount = 16,
		time = 1.5,
		minpos = vector.subtract(pos, 1.5),
		maxpos = vector.add(pos, 1.5),
		minvel = vector.new(-5, -5, -5),
		maxvel = vector.new(5, 5, 5),
		minexptime = 1,
		maxexptime = 2.5,
		minsize = 3,
		maxsize = 10,
		texture = tnt and "tnt_smoke.png" or minetest.registered_nodes["mapgen_stone"].tiles[1],
	})
end