-- install script for custom kode setup
if (fs.exists("/disk")) then
	print("/disk exists. Using that.")
else
	shell.run("mkdir", "/disk")
end

local file = fs.open("/disk/.koderc",'w')
file.writeLine("zenithSandbox")
file.writeLine("afz2014")
file.close()
--pastebin get jLjJR65B install
shell.run("pastebin", "get jLjJR65B install_kode")
shell.run("install_kode")
shell.run("rm","install_kode")
