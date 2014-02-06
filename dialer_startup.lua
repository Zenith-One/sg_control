-- so we don't try and wrap peripherals before they're ready
sleep(10)

-- random delay so we can (hopefully) avoid firing off 30
-- http requests as soon as the server starts up
local rnd = math.random(20)

-- install any updates to this startup script
local start_src = http.get("https://raw.github.com/Zenith-One/sg_control/master/dialer_startup.lua")
if start_src ~= nil then
	local file = fs.open("/startup","w")
	file.write(start_src.readAll())
	file.close()
	start_src.close()
end

-- install any updates to SGDial
local sgd_src = http.get("https://raw.github.com/Zenith-One/sg_control/master/SGDial.lua")
if sgd_src ~= nil then
	local file = fs.open("/SGDial","w")
	file.write(sgd_src.readAll())
	file.close()
	sgd_src.close()
end

shell.run("SGDial")