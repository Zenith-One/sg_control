-- SGControl by zenithselenium - © 2014
-- Install script for SGCraft computer controlled dialing using kode


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
	print("username and project key will be used for the stargate address") 
	print("file stored on kode. (https://kealper.com/projects/kode/)")
end

if #tArgs < 3 then
	-- Not enough arguments given, tell user how to use it
	printUsage()
	return
end

local function setupGit()
	shell.run("pastebin", "get imKdg0x8 gita")
	print("CCGit setup.")
end

if #tArgs == 3 then
	local valid = false
	if not fs.exists("/gita") then
		setupGit()
	end
	os.loadAPI("gita")
	
	emulateDisk()

	if (tArgs[1] == "dialer") then
		gita.get("Zenith-One","sg_control","dial.lua","SGDial")
		local file = fs.open("/startup")
		file.writeLine("shell.run('SGDial')")
		file.close()
		valid = true
	elseif (tArgs[1] == "controller") then
		gita.get("Zenith-One","sg_control","controller.lua","SGControl")
		valid = true
	end

	if valid then
		auth(tArgs[2],tArgs[3])
	else 
		print("Invalid arguments.")
		printUsage()
	end


end