local MAJOR, MINOR = 'Wasabi', 1
assert(LibStub, MAJOR .. ' requires LibStub')

local lib, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if(not lib) then
	return
end

local methods = {}
function methods:Initialize(constructor)
	self:SetScript('OnShow', function()
		constructor(self)

		self:refresh()
		self:SetScript('OnShow', nil)
	end)
end

function methods:refresh()
end

function methods:okay()
	for key, value in next, self.temp do
		self.db[key] = value
	end
end

function methods:default()
	for key, value in next, self.defaults do
		self.db[key] = value
		self.temp[key] = value
	end
end

function methods:cancel()
	table.wipe(self.temp)

	for key, value in next, self.db do
		self.temp[key] = value
	end
end

local function OnEvent(self, event)
	if(event == 'PLAYER_LOGIN') then
		if(not _G[self.db_glob]) then
			_G[self.db_glob] = self.defaults
		end

		self.db = _G[self.db_glob]
		for key, value in next, self.defaults do
			if(self.db[key] == nil) then
				self.db[key] = value
			end
		end

		for key, value in next, self.db do
			self.temp[key] = value
		end
	else
		_G[self.db_glob] = self.db
	end
end

function lib:New(name, db_glob, defaults)
	local panel = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
	panel:RegisterEvent('PLAYER_LOGIN')
	panel:RegisterEvent('PLAYER_LOGOUT')
	panel:HookScript('OnEvent', OnEvent)
	panel:Hide()

	panel.name = name
	panel.defaults = defaults
	panel.db_glob = db_glob

	panel.temp = {}

	for method, func in next, methods do
		panel[method] = func
	end

	InterfaceOptions_AddCategory(panel)

	return panel
end
