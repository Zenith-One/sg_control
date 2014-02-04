local ec = peripheral.wrap("bottom")
addresses = {}
addressPath = "/drive/addresses"

function c2d()
	ec.setColors(32768,32768,128)	
	local success = false
	if (ec.getStackInSlot(1) ~= nil and ec.getStackInSlot(1).rawName == "item.ccdisk") then 
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

function loadAddressesFromDisk()
	local out = nil
	if chestToDrive() then
		if (fs.exists(addressPath)) then
			local file = fs.open(addressPath,"r")
			contents = file.readAll()
			file.close()
			print(contents)
			out = contents
		end
		driveToChest()
	else
		print("No disk found")
	end
	return out
end

function parseAddresses(addrString)
	print(addrString)
	if not (addrString == nil) then
		return textutils.unserialize(addrString)
	end
	return nil
end

function loadAddresses()
	local addrString = loadAddressesFromDisk()
	parsedAddresses = parseAddresses(addrString)
	local out = false
	if (parsedAddresses) then
		addresses = parsedAddresses
		out = true
	end
	return out
end

function getAddresses()
	loadAddresses()
	return addresses
end

