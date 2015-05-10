local function Config(self)
	local Title = self:CreateTitle()
	Title:SetPoint('TOPLEFT', 16, -16)
	Title:SetText('Wasabi')

	local Description = self:CreateDescription()
	Description:SetPoint('TOPLEFT', Title, 'BOTTOMLEFT', 0, -8)
	Description:SetPoint('RIGHT', -32, 0)
	Description:SetText('This is a test implementation of an options panel using Wasabi')

	local CheckButton = self:CreateCheckButton('checkbutton')
	CheckButton:SetPoint('TOPLEFT', Description, 'BOTTOMLEFT', -2, -10)
	CheckButton:SetText('This is a CheckButton widget')
	CheckButton:SetNewFeature(true)
	CheckButton:On('Update', function(self, value)
		print('CheckButton received an update with value "' .. tostring(value) .. '"')
	end)
	CheckButton:On('Click', function(self)
		print('CheckButton received a click')
	end)
end

local defaults = {
	checkbutton = true,
}

local Panel = LibStub('Wasabi'):New('Wasabi', 'WasabiTestsDB', defaults)
Panel:AddSlash('/wa')
Panel:AddSlash('/wasabi')
Panel:Initialize(Config)

local Sub = Panel:CreateChild('Subpanel', 'WasabiSubTestsDB', defaults)
Sub:Initialize(Config)
