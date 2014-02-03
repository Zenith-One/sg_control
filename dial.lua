sg = peripheral.wrap("top")
rednet.open("bottom")

state = {["Idle"] = 0, ["Dialling"] = 1, ["Connected"] = 2}

function split(str, delim, maxNb)
  -- Eliminate bad cases...
  if string.find(str, delim) == nil then
    return { str }
  end
  if maxNb == nil or maxNb < 1 then
    maxNb = 0    -- No limit
  end
  local result = {}
  local nb = 0
  local lastPos
  local working = str
  local continue = true
  while continue do
    local i = string.find(working, delim)
    if i == nil then
      break
    end
  --  print("Delimeter found at position "..i)
    local part = string.sub(working, 1, i-1)
    nb = nb + 1
  --  print("part "..nb..": "..part)
    working = string.sub(working, i+1)
  --  print("Remaining: "..working)
    result[nb] = part
    if nb == maxNb then break end
  end
  -- Handle the last field
  if nb ~= maxNb then
    result[nb + 1] = working
  end
  --for count = 1, #result do
  -- print(result[count])
  --end
  return result
end

function dial(addr)
  sg.connect(addr)
end

function close()
  sg.disconnect()
end

while true do
  local id, msg, dis = rednet.receive()
--  print("message received: "..msg)
  local msgArr = split(msg, "|", 0)
  local status = state[sg.getState()]
--  print(status)
--  print("Message array:")
--  for i=1,#msgArr do
--    print(i..": "..msgArr[i])
--  end
  if msgArr[1] == "dial" then
    if status == 0 then
      if pcall(dial, msgArr[2]) then
       
        print("Dialing " .. msgArr[2])
      else
        print("Unable to dial. Check fuel and verify address.")
      end
    else
      print("Stargate must be idle to dial!")
    end
  elseif msgArr[1] == "close" then
    if status > 0 then
      if pcall(close) then
        print("Closing wormhole")
      else
        print("Could not close wormhole!")
      end
    else
      print("No wormhole to close!")
    end
  end
end
