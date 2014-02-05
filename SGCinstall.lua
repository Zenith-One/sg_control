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


local function printUsage()
	print("Istallation script for kode and stargate control")
	print("Usage: sgcinstall <dialer/controller> <username> <project key>")
	print("")
	print("username and project key will be used for the stargate address file stored on kode. (https://kealper.com/projects/kode/)") 
	print()
end

if #tArgs < 3 then
	-- Not enough arguments given, tell user how to use it
	printUsage()
	return
end

if #tArgs == 3 then
	printHeader()
	local valid = false
	local version = ""
	local peripherals = ""
	os.loadAPI("gita")
	
	emulateDisk()
	if (tArgs[1] == "dialer") then
		gita.get("Zenith-One","sg_control","master","dial.lua","SGDial")
		print("Installed SGDial")
		local file = fs.open("/startup","w")
		file.writeLine("shell.run('SGDial')")
		file.close()
		print("Set SGDial on startup")
		version = "SGDial"
		peripherals = "(modem, fuel chest, and stargate)"
		valid = true
	elseif (tArgs[1] == "controller") then
		gita.get("Zenith-One","sg_control","master","controller.lua","SGControl")
		print("Installed SGControl")
		local file = fs.open("/startup","w")
		file.writeLine("shell.run('SGControl')")
		file.close()
		print("Set SGControl on startup")
		auth(tArgs[2],tArgs[3])
		print("kode auth set up.")
		gita.get("Zenith-One","sg_control","master","button.lua","button")
		print("Installed modified button API")
		file = fs.open("/addresses","w")
		file.write("{}")
		file.close()
		shell.run("kode","make addresses")
		shell.run("kode","push addresses /addresses")

		version = "SGControl"
		peripherals = "(modem and monitor, as well as set the id for the dialer)"
		valid = true
	else 
		error("Illegal argument(s)")
		printUsage()
	end


	if valid then
		print("---------------------------------------------------")
		print(version .. " successfully installed. You will need") 
		print("to edit it to input the correct sides for its")
		print("peripherals "..peripherals)
		print("")
		if version == "SGDial" then
			print("This machine's id: "..os.getComputerID())
		end
	end
end