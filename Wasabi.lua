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
end

function methods:default()
end

function methods:cancel()
end

function lib:New(name)
	local panel = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
	panel:Hide()

	panel.name = name

	for method, func in next, methods do
		panel[method] = func
	end

	InterfaceOptions_AddCategory(panel)

	return panel
end
