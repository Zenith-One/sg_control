ec = peripheral.wrap("bottom")
addresses = {}
addressPath = "/drive/addresses"

function c2d()
	ec.setColors(32768,32768,128)	
	local success = false
	if (ec.getItemInSlot(1).rawName == "item.ccdisk") then 
		turtle.suckDown() turtle.drop() 
		success = true
	else
		ec.setColors(1,1,1)
	end
	return success
end

function chestToDrive()	
	if c2d() then 
		return true
	else
		print("No disk in chest. Waiting")
		local count = 0
		while count <20 do
			sleep(3)
			count = count + 1
			if c2d() then
				print("Transfer complete")
			  return true
			end
	  end
	  return false
	end 
end

function driveToChest()
	ec.setColors(32768,32768,128)
	turtle.suck()
	turtle.dropDown()
	ec.setColors(1,1,1)
end

function getAddressFromDisk()
	chestToDrive()
	if (fs.exists(addressPath)) then
		local file = fs.open(addressPath,"r")
		local contents = file.readAll()
