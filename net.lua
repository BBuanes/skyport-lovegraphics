function connect(ip,port)
	conn = lube.tcpClient()
	local table = {
		message = "connect",
		revision = 1,
		password = "supersecretpassword"
	}
	conn.handshake = false
	--conn.handshake = json.encode(table,{indent = false}) .. "\n"
	conn:setPing(false)
	conn:connect(ip, port, true)
	conn:send(json.encode(table,{indent = false}).."\n")
	conn.callbacks.recv = rcvCallback
	if not conn.connected then crogbteobvoer() end
end


function rcvCallback(data)
   lines = split(data, "\n")
   for k,v in ipairs(lines) do
      processLine(v)
   end
end

function processLine(data)
   if data ~= nil then
      local datacontainer, pos, err = json.decode(data,1,nil)
      if err then
	 print("fail to decode json package: " .. err)
	 return
      end
      local thingy = datacontainer.message
      if thingy == "gamestate" then
	 if datacontainer["turn"] ~= 0 then
	    gamestateset = true
	    gamestate = datacontainer
	    print("not initial gamestate!")
	 else
	    print("initial gamestate!")
	    print(gamestateset)
	    
	 end
      elseif thingy == "action" then
	 actions = actions + 1
	 actionTable[3] = actionTable[2]
	 actionTable[2] = actionTable[1]
	 actionTable[1] = datacontainer
	 actiontime = 0
      elseif thingy == "connect" then
	 --
      elseif thingy == "endactions" then
	 print("gamestate set: " .. tostring(gamestateset))
	 if not gamestateset then
	    print("printing ready!")
	    conn:send("{\"message\":\"ready\"}\n")
	 end
	 endturn = true
      else
	 print("couldn't understand message: " .. thingy)
      end
   end
end
