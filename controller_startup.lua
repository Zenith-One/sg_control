-- so we don't try and wrap peripherals before they're ready
sleep(10)

-- random delay so we can (hopefully) avoid firing off 30
-- http requests as soon as the server starts up
local rnd = math.random(20)

-- install any updates to this startup script
local start_src = http.get("https://raw.github.com/Zenith-One/sg_control/master/controller_startup.lua")
if start_src ~= nil then
	local file = fs.open("/startup","w")
	file.write(start_src.readAll())
	file.close()
	start_src.close()
end

-- install any updates to button api that might be there
local button_src = http.get("https://raw.github.com/Zenith-One/sg_control/master/button.lua")
if button_src ~= nil then
	local file = fs.open("/button","w")
	file.write(button_src.readAll())
	file.close()
	button_src.close()
end

-- install any updates to SGControl
local sgc_src = http.get("https://raw.github.com/Zenith-One/sg_control/master/SGControl.lua")
if sgc_src ~= nil then
	local file = fs.open("/SGControl","w")
	file.write(sgc_src.readAll())
	file.close()
	sgc_src.close()
end

shell.run("SGControl")