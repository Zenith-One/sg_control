-- SGDial by zenithselenium - © 2014

-- Configuration
-- Notes: 
--   * 'sides' are from the perspective of the way the turtle is facing
--   * DIR_FROM_GATE wants the turtle's position relative to the gate.
--     e.g. "The turtle is west of the gate"

FUEL_CHEST_SIDE = "bottom" -- front, top, or bottom
STARGATE_SIDE = "top" -- front, left, right, back, top, or bottom
DIR_FROM_GATE = "down" -- north, south, east, west, up, or down

sg = peripheral.wrap(STARGATE_SIDE)
rednet.open("right")
turtle.select(1)

state = {["Idle"] = 0, ["Dialling"] = 1, ["Connected"] = 2}

function printHeader()
  shell.run("clear")
  print("################################################")
  print("#                                              #")
  print("#                    SGDial                    #")
  print("#              by: zenithselenium              #")
  print("#                                              #")
  print("################################################")
  print()
end

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

dirSuck = {
  ["front"] = turtle.suck,
  ["top"] = turtle.suckUp,
  ["bottom"] = turtle.suckDown
}

function dial(id, addr)
  if (sg.getStackInSlot(1) == nil) then
    print("No fuel in gate.")
    if turtle.getItemCount(1) == 0 then
      print("No fuel in turtle!")
      if dirSuck[FUEL_CHEST_SIDE]() then
        print("got fuel from chest.")
      else
        print("no fuel in chest either")
        print(id)
        rednet.send(id, "nofuel")
        return false
      end
    end
    sg.pullItem(DIR_FROM_GATE, 1, 1)
    print("Placed fuel in gate.")
  end
  sg.connect(addr)
end

function close()
  sg.disconnect()
end

printHeader()

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
      print(msgArr[2])
      if pcall(dial, id, msgArr[2]) then
        rednet.send(id, "dialing")
      else
        print("Unable to dial. Check fuel and verify address.")
        rednet.send(id, "unable")
      end
    else
      print("Stargate active; Closing womhole")
      pcall(close)
      --sleep(7)
      pcall(dial, id, msgArr[2])
      rednet.send(id, "notidle")
    end
  elseif msgArr[1] == "close" then
    if status ~= 0 then
      if pcall(close) then
        print("Closing wormhole")
      else
        print("Could not close wormhole!")
      end
    else
      print("No wormhole to close!")
    end
  elseif msgArr[1] == "ping" then
    print("Receieve ping from #"..id)
    rednet.send(id,"pong")
  end
end