-- SGController by zenithselenium - © 2014
-- Large portions of this code is adapted from DireWolf20's portal program
-- ( http://pastebin.com/ELAFP3kT )

-- So that we don't try and wrap peripherals before they're properly loaded
sleep(10)

-- config
MONITOR_SIDE = "right"
MODEM_SIDE = "bottom"
DIALER_ID = 4

os.loadAPI("button")
m = peripheral.wrap(MONITOR_SIDE)
m.clear()
rednet.open(MODEM_SIDE)
local page = 1
local pages = 0
local names = {}
local dialers = {}
local remove = false

function fillDialers()
   dialers[1] = DIALER_ID
end

function fillTable()
   m.clear()
   button.clearTable()
   local totalrows = 0
   local numNames = 0
   local col = 2
   local row = 12
   local countRow = 1
   local currName = 0
   local npp = 12 --names per page
   for dialer, data in pairs(names) do
      for i,j in pairs(data) do
         totalrows = totalrows+1
      end
   end
   pages = math.ceil(totalrows/npp)
   print(totalrows)
   for dialer, data in pairs(names) do
      currName = 0
      for slot, name in pairs(data) do
       currName = currName + 1
       if currName > npp*(page-1) and currName < npp*page+1 then
         row = 4+(countRow)
         button.setTable(string.sub(name.name, 0, 17), runStuff, dialer..":"..slot, col, col+17 , row, row)
         if col == 21 then 
           col = 2 
           countRow = countRow + 2
         else 
           col = col+19 
         end
       end
      end
   end
   button.setTable("Next Page", nextPage, "", 21, 38, 1, 1)
   button.setTable("Prev Page", prevPage, "", 2, 19, 1, 1)
   button.setTable("Refresh", checkNames, "", 21, 38, 19, 19)
   button.setTable("Remove Address", removeIt, "", 2, 19, 19, 19)
   button.label(15,3, "Page: "..tostring(page).." of "..tostring(pages))
   button.screen()
end      

function nextPage()
   if page+1 <= pages then 
      page = page+1 
   end
   fillTable()
   sleep(0.25)
end

function prevPage()
   if page-1 >= 1 then page = page-1 end
   fillTable()
   sleep(0.25)
end   
                           
function getNames()
   names = {}
   for index, dialer in pairs(dialers) do
      names[dialer] = {}
      shell.run("rm","/addresses")
      shell.run("kode","pull addresses /addresses")
      local file = fs.open("/addresses","r")
      names[dialer] = textutils.unserialize(file.readAll())
      file.close()
   end
end

function removeIt()
   remove = not remove
--   print(remove)
   button.toggleButton("Remove Address")
end

function runStuff(info)
  if remove == true then
    removeAddress(info)
  else
    dial(info)
  end      
end

function removeAddress(info)
  local dialer, slot = string.match(info, "(%d+):(%d+)")
  button.toggleButton(names[tonumber(dialer)][tonumber(slot)])
   
  local temp = {}
  addresses[dialer][slot] = nil

  local count = 1
  for i = 1 to #addresses do
   	if addresses[dialer][i] ~= nil then
   		temp[count] = addresses[dialer][i]
   	  count = count +1
   	end
  end

  local file = fs.open("/addresses","w")
  file.write(textutils.serialize(temp))
  file.close()
  shell.run("kode","push addresses /addresses")

  button.toggleButton(names[tonumber(dialer)][tonumber(slot)])
  remove=false
  button.toggleButton("Remove Address")
--   sleep(1)
  checkNames()
end   

function dial(info)
   local dialer,slot = string.match(info, "(%d+):(%d+)")
--   print(names[tonumber(dialer)][tonumber(slot)])
   button.toggleButton(names[tonumber(dialer)][tonumber(slot)])
   print(names[tonumber(dialer)][tonumber(slot)])
   data = "dial|"..tostring(slot.addr)
   rednet.send(tonumber(dialer), data)
   rednet.receive()
   button.toggleButton(names[tonumber(dialer)][tonumber(slot)])
end

function checkNames()
   button.flash("Refresh")
   getNames()
   fillTable()
end

function getClick()
   event, side, x,y = os.pullEvent()
   if event == "monitor_touch" then
      button.checkxy(x,y)
   elseif event == "redstone" then
      print("redstone")
      sleep(5)
      checkNames()      
   end
end

fillDialers()
fillTable()
checkNames()


while true do
   getClick()
--   checkNames()
end