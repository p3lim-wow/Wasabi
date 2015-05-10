local widgetType, widgetVersion = 'CheckButton', 1
local Wasabi = LibStub and LibStub('Wasabi', true)
if(not Wasabi or (Wasabi:GetWidgetVersion(widgetType) or 0) >= widgetVersion) then
	return
end

local methods = {}
function methods:Update(value)
	self:SetChecked(value)
end

local function OnClick(self)
	self.panel.temp[self.key] = self:GetChecked()
end

Wasabi:RegisterWidget(widgetType, widgetVersion, function(panel, key)
	local Button = CreateFrame('CheckButton', nil, panel, 'InterfaceOptionsCheckButtonTemplate')
	Button:SetScript('OnClick', OnClick)
	Button.panel = panel
	Button.key = key

	for method, func in next, methods do
		Button[method] = func
	end

	Wasabi:InjectBaseWidget(Button, 'Text')

	panel.objects[key] = Button

	return Button
end)
