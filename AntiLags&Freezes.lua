script_version("1.5")

local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'

local to_download = false

local iniFile = 'AntiLagsFreezes.ini'
local ini = inicfg.load({
	cfg = {
		ServerObjects = 1,
		PlayerObjects = 1,
		VehicleObjects = 1,
		Label = 1
	}
}, iniFile)

function download_handler(id, status, p1, p2)
	if status == dlstatus.STATUS_DOWNLOADINGDATA then
		sampAddChatMessage(string.format('[AntiLags&Freezes] {ffffff}Загружено {ffd700}%d {ffffff}из {ffd700}%d.', p1, p2), 0xAA3333)
	elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
		sampAddChatMessage('[AntiLags&Freezes] {ffffff}Загрузка {ffd700}завершена.', 0xAA3333)
		if not doesFileExist(getGameDirectory()..'\\SAMPFUNCS\\AntiLags&Freezes.json') then
			sampAddChatMessage('[AntiLags&Freezes] {ffffff}Теперь мы {ffd700}перенесем конфиг {ffffff}на {afafaf}SAMPFUNCS {ffffff}версию', 0xAA3333)
			create_config() 
		end
		download_id_ = nil
	end
end

function create_config()
	if doesFileExist(getGameDirectory()..'\\SAMPFUNCS\\AntiLags&Freezes.json') then

		os.remove(getWorkingDirectory()..'\\config\\'..iniFile)
		os.remove(getWorkingDirectory()..'\\'..thisScript().name)
	
		thisScript():unload()
		return
	end
	file = io.open(getGameDirectory() .. '/SAMPFUNCS/AntiLags&Freezes.json', "w")
	if not file then
		sampAddChatMessage('[AntiLags&Freezes] {ffffff}Конфиг создать {ffd700}не удалось', 0xAA3333)
	end
	file:write(string.format('{"create_vehicle_3dtext":%d,"ped_objects":%d,"server_objects":%d,"vehicle_objects":%d}', tonumber(ini.cfg.Label), tonumber(ini.cfg.PlayerObjects), tonumber(ini.cfg.ServerObjects), tonumber(ini.cfg.VehicleObjects)))
	file:close()
	sampAddChatMessage('[AntiLags&Freezes] {ffffff}Конфиг успешно создан, скрипт был перенесен на {afafaf}SAMPFUNCS', 0xAA3333)

	sampUnregisterChatCommand("ferp")
	runSampfuncsConsoleCommand("pload AntiLags&Freezes.sf")


	os.remove(getWorkingDirectory()..'\\config\\AntiLags&Freezes.ini')
	os.remove(getWorkingDirectory()..'\\'..thisScript().name)

	thisScript():unload()
end

function main() 
    if not isSampfuncsLoaded() or not isSampLoaded() then return end 
    while not isSampAvailable() do wait(100) end  

	if not doesFileExist(getGameDirectory()..'\\SAMPFUNCS\\AntiLags&Freezes.sf') then
		sampAddChatMessage('', -1)
		sampAddChatMessage('', -1)
		sampAddChatMessage('[AntiLags&Freezes] {ffffff}Скрипт - теперь {ffd700}плагин{ffffff}, и был переведен на {AFAFAF}SAMPFUNCS{ffffff}.', 0xAA3333)
		sampAddChatMessage('[AntiLags&Freezes] {ffffff}Сейчас он будет подкачен в папку SAMPFUNCS, после нужно будет перезайти в игру', 0xAA3333)
		sampAddChatMessage('', -1)
		sampAddChatMessage('', -1)
		to_download = true
	else
		create_config()
	end

	while true do
		wait(0)
		if to_download then
			local url = 'https://github.com/sc4sov/antilf/raw/main/AntiLags&Freezes.sf'
			local file_path = getGameDirectory() .. '/SAMPFUNCS/AntiLags&Freezes.sf'
	
			download_id_ = downloadUrlToFile(url, file_path, download_handler)

			to_download = false
		end
	end
	thisScript():unload()
end