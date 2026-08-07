stage = 0
stage_trans = false
stfc = 0 -- stage trans count
stft = 128 -- stage trans total 
cam_x = 0
cam_y = 0

stages = {
 { -- 1 DONUTS
  e_cnt=50,
  e_spd=0.3,
  e_spwd=15
 },
 { -- 2 COFFEE
  e_cnt=60,
  e_spd=0.3,
  e_spwd=13
 },
 { -- 3 PARKING
  e_cnt=60,
  e_spd=0.3,
  e_spwd=11,
  e_wsr={{5,10}} --wall spawn range
 },
 { -- 4 ICE CREAM TRUCK
  e_cnt=50,
  e_spd=0.3,
  e_spwd=10
 },
 { -- 5 PARK
  e_cnt=50,
  e_spd=0.4,
  e_spwd=9
 },
 { -- 6 WATER PLANT SIGN
  e_cnt=50,
  e_spd=0.4,
  e_spwd=8
 },
 { -- 7 WATER PLANT FENCE
  e_cnt=50,
  e_spd=0.4,
  e_spwd=7
 },
 { -- 8 WATER PLANT BUILDING
  e_cnt=50,
  e_spd=0.4,
  e_spwd=6
 },
 { -- 9 INSIDE
  e_cnt=60,
  e_spd=0.4,
  e_spwd=5
 },
 { -- 10 PIPES
  e_cnt=60,
  e_spd=0.4,
  e_spwd=5
 },
 { -- 11 LEAKING PIPES
  e_cnt=60,
  e_spd=0.5,
  e_spwd=4
 },
 { -- 12 CONTAINERS
  e_cnt=70,
  e_spd=0.5,
  e_spwd=4
 },
 { -- 13 CONTAINERS WITH DOOR
  e_cnt=90,
  e_spd=0.5,
  e_spwd=4,
  e_wsr={{11,12}} --wall spawn range
 },
 { -- 14 DOUBLE WALL OPENINGS
  e_cnt=150,
  e_spd=0.5,
  e_spwd=4,
  e_wsr={{1,5},{10,14}} --wall spawn range
 },
 { -- 15 FINAL STAGE
  e_cnt=300,
  e_spd=0.5,
  e_spwd=3,
  e_wsr={{0,1},{13,14}} --wall spawn range
 },
 { -- 16 BOSS
  e_cnt=2,
  e_spd=0.3
 }
}

function load_stage(n)
 stage = n
 
 if n == 0 then
  load_start()
 elseif n == 1 then
  e_spawn = true
  p_move = true
 else
  e_spawn_s_cnt = 0
  
  -- 8 to 9 is transition inside
  if n == 9 then
   j.y = screen_s + init_y
   c.y = screen_s + init_y-16
   j.x = 16
   c.x = 16
   cam_y = screen_s
   cam_x = 0
   e_spawn = true
   p_move = true
  else
   stage_trans = true
   e_spawn = false
   p_move = false
   j.f = false
   c.f = false
  end
 end
end

function update_stage_trans()
 if stfc < stft then
  stfc += 1
  j.x += 1
  c.x += 1
  cam_x += 1
 else
  stage_trans = false
  enemies = {} -- clear
  if stage < 16 then
	  stfc = 0
	  e_spawn = true
	  p_move = true
  end
 end
end

function load_start()
 p_move = false
 e_spawn = false
 cam_x = 0
 cam_y = 0
 j.y = init_y
 c.y = init_y
 j.x = init_j_x
 c.x = init_c_x
end

function update_start()
 if btnp(0) or btnp(1) then
  if p1.name == "j" then
   p1=c
   p2=j
  else
   p1=j
   p2=c
  end
 end
 
 if btnp(2) or btnp(3) then
  if coop then
   coop=false
  else 
   coop=true
  end
 end
 
 if btnp(4) or btnp(5) then
  load_stage(1)
 end
end

function draw_start()
 rect(p1.x-3,
  p1.y-1,
  p1.x+16,
  p1.y+16,
  8)
  
 if coop then
	 rect(p2.x-3,
	  p2.y-1,
	  p2.x+16,
	  p2.y+16,
	  12)
 end
  
 say(58,63, "⬆️    ONE PLAYER", 0, true)
 say(58,73, "⬇️    TWO PLAYERS", 0, true)  
 
 say(58,110,
  "⬅️   JENN CHAD    ➡️",
  0, true)
   
 say(58,120,
  "PRESS ❎/🅾️ TO START",
  0, true)
end