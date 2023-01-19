minetest.register_entity("ufo_ship:ufo", {
    initial_properties = {
        visual = "mesh",
        mesh = "ufo_ship_ship.obj",
        visual_size = vector.new(10, 10, 10),
        textures = {"ufo_ship_ship.png"},
        physical = true,
    },
    on_activate = function(self, staticdata, dtime_s)
        self.object:set_rotation(vector.new(ufo_ship.deg_to_rad(ufo_ship.level_ship_offset), 0, 0))
    end,
    on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
        if not self.driver then
            minetest.add_item(self.object:get_pos(), "ufo_ship:ufo")
            self.object:remove()
        else
            return true --dont break when someone is in it
        end
    end,
    on_rightclick = function(self, clicker)
        if not clicker or not clicker:is_player() then return end

        --TODO: sometimes player is plain stupid and doesnt sit player, figure out why
        if not self.driver then
            clicker:set_attach(self.object, "", vector.new(0,0.5,0.25), vector.new(-ufo_ship.level_ship_offset,180,0))
            clicker:set_properties({visual_size = vector.new(0.075,0.075,0.075)})
            player_api.player_attached[clicker:get_player_name()] = true
            player_api.set_animation(clicker, "sit", 0)
            clicker:set_properties({
                eye_height = 1.25
            })
            clicker:set_eye_offset(vector.new(0,0,-2.5))
            self.driver = clicker:get_player_name()
        elseif self.driver == clicker:get_player_name() then
            clicker:set_detach()
            player_api.player_attached[clicker:get_player_name()] = nil
            clicker:set_eye_offset(vector.new(0,0,0))
            clicker:set_properties({visual_size = vector.new(1,1,1)})
            self.driver = nil
        end
    end,
    on_step = function(self, dtime, moveresult)
        --[[ TODO:
            * consider "animating" tilt
            * particles poring out on lift/forward
            * slow down with down key
        ]]
        if self.driver then
            local driver = minetest.get_player_by_name(self.driver)
            if not driver then
                self.driver = nil
                return
            end
            local controls = driver:get_player_control()
            local vel = self.object:get_velocity()

            --handle controls
            if controls.up then --add speed when on the trottle
                --speed
                vel.x = vel.x + math.cos((self.object:get_yaw()+ufo_ship.deg_to_rad(180))+math.pi/2)*ufo_ship.speed
			    vel.z = vel.z + math.sin((self.object:get_yaw()+ufo_ship.deg_to_rad(180))+math.pi/2)*ufo_ship.speed

                --tilt
                local currot = self.object:get_rotation()
                self.object:set_rotation(
                    vector.new(
                        0,
                        currot.y,
                        0
                    )
                )
            else --slow down when not on the throttle
                --speed
                vel.x = vel.x*ufo_ship.slow_factor
                vel.z = vel.z*ufo_ship.slow_factor

                --tilt
                local currot = self.object:get_rotation()
                self.object:set_rotation(
                    vector.new(
                        ufo_ship.deg_to_rad(ufo_ship.level_ship_offset),
                        currot.y,
                        0
                    )
                )
            end

            if controls.jump then
                vel.y = vel.y + ufo_ship.speed
            elseif controls.sneak then
                vel.y = vel.y-ufo_ship.speed
            else
                vel.y = vel.y*ufo_ship.slow_factor
            end

            --turning controls
            if controls.left then
                local currot = self.object:get_rotation()
                self.object:set_rotation(
                    vector.new(
                        currot.x,
                        currot.y + ufo_ship.deg_to_rad(ufo_ship.turn_speed),
                        0
                    )
                )
            end
            if controls.right then
                local currot = self.object:get_rotation()
                self.object:set_rotation(
                    vector.new(
                        currot.x,
                        currot.y - ufo_ship.deg_to_rad(ufo_ship.turn_speed),
                        0
                    )
                )
            end

            --speed lock
            if vel.x > ufo_ship.max_speed then vel.x = ufo_ship.max_speed end
            if vel.x < -ufo_ship.max_speed then vel.x = -ufo_ship.max_speed end
            if vel.y > ufo_ship.max_speed then vel.y = ufo_ship.max_speed end
            if vel.y < -ufo_ship.max_speed then vel.y = -ufo_ship.max_speed end
            if vel.z > ufo_ship.max_speed then vel.z = ufo_ship.max_speed end
            if vel.z < -ufo_ship.max_speed then vel.z = -ufo_ship.max_speed end

            self.object:setvelocity(vel)
        else
            --slow it down if the driver hops out hop out
            local vel = self.object:get_velocity()
            vel.x = vel.x*ufo_ship.slow_factor
            vel.y = vel.y*ufo_ship.slow_factor
            vel.z = vel.z*ufo_ship.slow_factor
            self.object:setvelocity(vel)
        end
    end,
})

minetest.register_craftitem("ufo_ship:ufo", {
    description = "ufo ship",
    inventory_image = "ufo_ship_ship_icon.png",
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then return end
        local pos = pointed_thing.under
        pos.y = pos.y+1
        minetest.add_entity(pos, "ufo_ship:ufo")
        --TODO: take item if in survival
    end,
})