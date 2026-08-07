enemies = {}

e_spawn = false
e_speed = 0.5
e_spawn_s_cnt = 0 -- stage cnt
e_spawn_d_cnt = 0 

function spawn_enemy(speed)
 e = {
	 s=8,
	 spd=speed, -- movement speed
	 f=true,
	 x=rnd({cam_x-16,
	 	cam_x+screen_s+16}),
	 y=rnd(56) + flr(stage/9)*screen_s+56,
	 d_afd=20, -- death anim frm delay
	 d_afc=0, -- death anim frm cnt
	 dead=0,
	 afd=7, -- anima frame delay
	 afc=0,
	 yeeted=false,
	 yeet_f=false, --flip of yeeting player
	 yeet_fc=0,
	 yeet_fd=5
	}
	
	-- fast enemies
	local f=rnd((stage / 12) * 0.99)
	if f > 0.5 then
	 e.spd *= 1.5
	 e.s = 4
	end
	
	-- if wall spawn support
	-- 25% chance of wall spawn
	if stages[stage].e_wsr and
		rnd() < 0.25 then
	 
	 -- which wall opening
	 -- opening is a spawn range
	 local r = 1 + flr(rnd(
	 	#stages[stage].e_wsr))
	 
	 -- get range and index r
	 local xr = stages[stage].e_wsr[r]

	 -- choose spawn point in range
	 local xs = xr[1]+rnd(xr[2]-xr[1])

  e.x = xs*8+cam_x
  e.y = flr(stage/9)*screen_s+42
	 
	end
	
 add(enemies, e)
end

function update_enemies()
 for e in all(enemies) do
	 if e.dead == 1 then
	  e.d_afc += 1
	  
	  if e.d_afc >= e.d_afd then
		  e.d_afc = 0
		  
		  if e.s == 12 then
		   e.s = 14
		  elseif e.s == 44 then
		   e.s = 46
		  end
		 end
		elseif e.yeeted then
			yeet(e)
	 else
	  if p1.x < e.x - e.spd then
	   e.x -= e.spd
	   e.f = false
	  elseif p1.x > e.x + e.spd then
	   e.x += e.spd
	   e.f = true
	  end
	  
	  -- walk to middle before down
	  if abs(p1.x-e.x) < 2 then
		  if p1.y < e.y - e.spd then
		   e.y -= e.spd
		  elseif p1.y > e.y + e.spd then
		   e.y += e.spd
		  end
	  end
	  
	  e.afc += 1
	  
	  if e.afc >= e.afd then
	   e.afc = 0
	   -- enemy animation
	   if e.s == 8 then
	    e.s = 10
	   elseif e.s == 10 then
	    e.s = 8
	   elseif e.s == 4 then
	    e.s = 6
	   elseif e.s == 6 then
	    e.s = 4
	   end
	  end 
	 end
 end
end

function draw_enemies()
 for e in all(enemies) do
  spr(e.s,e.x,e.y,2,2,e.f,false)
 end
end

function enemy_coll_detect(p) 
 local hbox = 4 -- hit box
 
 if p.wpn == 1 then
  hbox = 12
 end
 
 for e in all(enemies) do
  if e.dead == 0 and 
   ((e.x-2 < p.x and p.f) or
   (e.x+2 > p.x and not p.f)) and 
   (e.y > p.y-hbox and e.y < p.y+hbox) 
   then
        
   enemy_die(e,p)
   
   if p.wpn == 0 then
    return -- pistol hits 1 at a time
   end
  end
 end
end

function enemy_die(e,p)
 e.dead=1
   
 for i=1,20 do
 	local xs = rnd(3 - 0) + 0
  local ys = rnd(1 - -1) + -1
  add(particles, 
   particle(e.x+4,e.y,
    xs,ys,3,10))
 end

 if p.wpn == 1 or p.m then
  e.s = 46
 elseif p.wpn == 0 then
  e.s = 12
 end
end

function yeet(e)
 if e.yeet_fc < e.yeet_fd then
  e.yeet_fc+=1		
		
		if e.yeet_f then
		 e.x -= 3
		else
		 e.x += 3
		end
	else
	 e.yeeted=false
	 e.yeet_fc=0
	end
end