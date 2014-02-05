local tArgs = {...}

local function printUsage()
	print("Lite installation script for kode and stargate control")
	print("Usage: sgcli <dialer/controller> <username> <project key>")
	print("")
	print("username and project key will be used for the stargate address file stored on kode. (https://kealper.com/projects/kode/)") 
	print()
end

local function setupGit()
	shell.run("pastebin", "get imKdg0x8 gita")
	print("CCGit installed.")
end

if #tArgs == 3 then
	if not fs.exists("/gita") then
		setupGit()
	end
	print("Fetching full installer")
	gita.get("Zenith-One","sg_control","master","SGCinstall.lua","SGCinstall")
	print("Running full installer")
	shell.run("SGCinstall",tArgs[1],tArgs[2],tArgs[3])
else
	printUsage()
end
