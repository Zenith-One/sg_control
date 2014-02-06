-- sgcli (SGInstallLite) by zenithselenium - © 2014
-- Lite Install script for SGCraft computer controlled dialing using kode

-- pastebin get 1gAjPwYT sgcli

local tArgs = {...}

local function printUsage()
	print("Lite installation script for kode and stargate control")
	print("Usage: sgcli <dialer/controller>")
	print()
end

function getArgsString(args)
	local out = args[1]
	if #args > 1 then
		for i = 2,#args do
			out = out .. " " .. args[i]
		end
	end
	return out
end

function run()
	if #tArgs >= 1 then
		print("Fetching full installer")
		local src = http.get("https://raw.github.com/Zenith-One/sg_control/master/SGCinstall.lua")
		if src ~= nil then
			local file = fs.open("/SGCinstall","w")
			file.write(src.readAll())
			file.close()
			src.close()
		else
			print("Failed to download full installer.")
			return
		end
		print("Running full installer")
		shell.run("SGCinstall",getArgsString(tArgs))
		print("")
	
		if fs.exists("/SGDial") or fs.exists("/SGControl") then
			print("Cleaning up - removing lite installer")
			shell.run("rm",shell.getRunningProgram())
		end
	else
		printUsage()
	end
end

run()
