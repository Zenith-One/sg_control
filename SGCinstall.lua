-- SGCinstall by zenithselenium - © 2014
-- Install script for SGCraft computer controlled dialing using kode


function printHeader()
  shell.run("clear")
  print("################################################")
  print("#                                              #")
  print("#                   SGCinstall                 #")
  print("#              by: zenithselenium              #")
  print("#                                              #")
  print("################################################")
  print()
end

function emulateDisk()
	if (fs.exists("/disk")) then
		print("/disk exists. Using that.")
	else
		shell.run("mkdir", "/disk")
		print("disk emulation set up")
	end
end

local tArgs = {...}


-- set up kode auth file and disk emulation
local function auth(un,pkey)
	local file = fs.open("/disk/.koderc",'w')
	file.writeLine(un)
	file.writeLine(pkey)
	file.close()
	--pastebin get jLjJR65B install
	shell.run("pastebin", "get jLjJR65B install_kode")
	shell.run("install_kode")
	shell.run("rm","install_kode")
end

-- get file via http and save it to the filename passed in
local function getAndSave(url, filename)
	local src = http.get(url)
	if src == nil then
		print("failed to get file: "..url)
		return false
	else
		local file = fs.open(filename,"w")
		file.write(src.readAll())
		file.close()
		src.close()
	end
	return true
end

local function printUsage()
	print("Lite installation script for kode and stargate control")
	print("Usage: SGCinstall dialer")
	print("OR:    SGCinstall controller <username> <project key>")
	print("")
	print("Username and project key will be used for the stargate address file stored on kode. (https://kealper.com/projects/kode/)") 
	print()
end

function run()

	if #tArgs < 1 then
		-- Not enough arguments given, tell user how to use it
		printUsage()
		return
	end

	printHeader()
	local valid = false
	local version = ""
	local peripherals = ""

	if #tArgs == 3 and tArgs[1] == "controller" then
		emulateDisk()
		if not getAndSave("https://raw.github.com/Zenith-One/sg_control/master/SGControl.lua","/SGControl") then
			print("Failed to download SGControl")
			return
		else	
			print("Installed SGControl")
			local file = fs.open("/startup","w")
			file.writeLine("sleep(10)")
			file.writeLine("shell.run('SGControl')")
			file.close()
			print("Set SGControl to run on startup")
			auth(tArgs[2],tArgs[3])
			print("kode auth set up.")
			
			if not getAndSave("https://raw.github.com/Zenith-One/sg_control/master/button.lua","/button") then
				print("Failed to install button API")
				return
			else
				print("Installed modified button API")
				shell.run("kode", "pull addresses addresses")
				if not fs.exists("/addresses") then
					file = fs.open("/addresses","w")
					file.write("{}")
					file.close()
					shell.run("kode","make addresses")
					shell.run("kode","push addresses /addresses")
				end

				version = "SGControl"
				peripherals = "(modem and monitor, as well as set the id for the dialer)"
			end
		end 
	elseif #tArgs == 1 and tArgs[1] == "dialer" then
		if not getAndSave("https://raw.github.com/Zenith-One/sg_control/master/SGDial.lua","/SGDial") then
			print("Failed to download SGDial")
			return
		else
			print("Installed SGDial")
			local file = fs.open("/startup","w")
			file.writeLine("sleep(10)")
			file.writeLine("shell.run('SGDial')")
			file.close()
			print("Set SGDial to run on startup")
			version = "SGDial"
			peripherals = "(Stargate and fuel chest)"
		end

	else
		error("Illegal argument(s)")
		printUsage()
		return
	end

	print("---------------------------------------------------")
	print(version .. " successfully installed. You will need") 
	print("to edit it to input the correct sides for its")
	print("peripherals "..peripherals)
	print("")
	if version == "SGDial" then
		print("This machine's id: "..os.getComputerID())
	end
	
end

run()