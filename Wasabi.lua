local MAJOR, MINOR = 'Wasabi', 1
assert(LibStub, MAJOR .. ' requires LibStub')

local lib, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if(not lib) then
	return
end

local databases = {}

local function OnEvent(self, event)
	if(event == 'PLAYER_LOGIN') then
		if(not _G[self.svars]) then
			_G[self.svars] = CopyTable(self.defaults)
		end

		self.db = _G[self.svars]
		for key, value in next, self.defaults do
			if(self.db[key] == nil) then
				self.db[key] = value
			end
		end

		self.temp = CopyTable(self.db)
	end
end

local methods = {}
local function CreatePanelProto(name, svars, defaults)
	assert(not databases[svars], 'Savedvariables "' .. svars .. '" is already in use')

	local panel = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
	panel:RegisterEvent('PLAYER_LOGIN')
	panel:HookScript('OnEvent', OnEvent)
	panel:Hide()

	panel.name = name
	panel.defaults = defaults
	panel.svars = svars

	panel.temp = {}
	panel.objects = {}

	for method, func in next, methods do
		panel[method] = func
	end

	databases[svars] = true

	return panel
end

function methods:AddSlash(slash)
	if(not self.slashIndex) then
		self.slashIndex = 1
		SlashCmdList[self.name] = function() self:ShowOptions() end
	else
		self.slashIndex = self.slashIndex + 1
	end

	_G['SLASH_' .. self.name .. self.slashIndex] = slash
end

function methods:ShowOptions()
	-- On first load IOF doesn't select the right category or panel.
	InterfaceOptionsFrame_OpenToCategory(self.name)
	InterfaceOptionsFrame_OpenToCategory(self.name)
end

function methods:Initialize(constructor)
	self:SetScript('OnShow', function()
		constructor(setmetatable(self, {__index = lib.widgets}))

		self:refresh()
		self:SetScript('OnShow', nil)
	end)
end

function methods:CreateChild(name, svars, defaults)
	assert(not self.parent, 'Cannot create child panel on a child panel.')

	local panel = CreatePanelProto(name, svars, defaults)
	panel.parent = self.name

	InterfaceOptions_AddCategory(panel)
	return panel
end

function methods:refresh()
	for key, object in next, self.objects do
		object:Update(self.temp[key])
	end
end

function methods:okay()
	for key, value in next, self.temp do
		if(self.db[key] ~= value) then
			self.db[key] = value
		end
	end
end

function methods:default()
	table.wipe(self.temp)
	self.temp = CopyTable(self.defaults)
end

function methods:cancel()
	table.wipe(self.temp)
	self.temp = CopyTable(self.db)
end

function lib:New(name, svars, defaults)
	local panel = CreatePanelProto(name, svars, defaults)

	InterfaceOptions_AddCategory(panel)
	return panel
end

lib.widgets = CreateFrame('Frame')
lib.widgetVersions = {}
function lib:RegisterWidget(type, version, constructor)
	local oldVersion = self.widgetVersions[type]
	if(oldVersion and oldVersion >= version) then
		return
	end

	self.widgets['Create' .. type] = constructor
	self.widgetVersions[type] = version
end

function lib:GetWidgetVersion(type)
	return self.widgetVersions[type]
end

lib.baseWidgets = CreateFrame('Frame')
lib.baseWidgetVersions = {}
function lib:RegisterBaseWidget(type, version, constructor)
	local oldVersion = self.baseWidgetVersions[type]
	if(oldVersion and oldVersion >= version) then
		return
	end

	self.baseWidgets[type] = constructor
	self.baseWidgetVersions[type] = version
end

function lib:GetBaseWidgetVersion(type)
	return self.baseWidgetVersions[type]
end

function lib:InjectBaseWidget(widget, type)
	self.baseWidgets[type](widget)
end
