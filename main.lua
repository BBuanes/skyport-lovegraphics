function love.load(args)
	
	-- love.graphics.setMode( 0, 0 , false, false)
        love.graphics.setMode(1024, 768, false, false)
        -- love.graphics.setMode(love.graphics.getWidth(),love.graphics.getHeight(),false,false)
	
	-- json = require "json"
	json = require "dkjson"
	class = require "class"
	require "LUBE"
	require "collectInfo"
	require "waitingForConnect"
	require "net"
	require "render"
	require "levelRender"
	require "animations"
	
	gamemodes = {collectInfo,waitingForConnect,levelRender}

	--[[
	if #args == 5 then
		ip = args[2]
		port = tonumber(args[3])
		mode = 2
	else
		mode = 1
	end
	]]--
	
	ip = "localhost"
	port = 54331
	mode = 2

	gamestateset = false
	love.filesystem.setIdentity("Skyport - samplegraphics")
	quit = false
	init = true
end

function love.draw()
	if gamemodes[mode].draw then
		gamemodes[mode].draw()
	end
end

function love.update(dt)
	if conn then
		conn:update(dt)
	end
	if gamemodes[mode].update then
		gamemodes[mode].update(dt)
	end
	collectgarbage('collect')
end

function love.keypressed(key,unicode)
	if key == "escape" then
      	love.event.push("quit")   -- actually causes the app to quit
	end
	if gamemodes[mode].keypressed then
		gamemodes[mode].keypressed(key,unicode)
	end
end

function love.keyreleased(key,unicode)
	if gamemodes[mode].keyreleased then
		gamemodes[mode].keyreleased(key,unicode)
	end
end

function split(str, pat)
	str = str or "0,0"
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function tablePrint(table)
	for k,v in pairs(table) do
		print(k.."\t"..v)
	end
end