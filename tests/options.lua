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
	CheckButton:On('Update', function(self, event, value)
		print('CheckButton received an update with value "' .. tostring(value) .. '"')
	end)
	CheckButton:On('Click', function(self, event)
		print('CheckButton received a click')
	end)

	local DropDown = self:CreateDropDown('dropdown')
	DropDown:SetPoint('TOPLEFT', CheckButton, 'BOTTOMLEFT', 0, -10)
	DropDown:SetValues('Cabbage', 'Mustard', 'Wasabi') -- Can also be a table (pairs or indexed)
	DropDown:SetText('This is a DropDown widget with three values')
	DropDown:On('Update', 'Toggle', 'ItemClick', function(self, event, ...)
		print('DropDown received "' .. event .. '" event, arguments:', ...)
	end)

	local Slider = self:CreateSlider('slider')
	Slider:SetPoint('TOPLEFT', DropDown, 'BOTTOMLEFT', 4, -14)
	Slider:SetRange(1, 10)
	Slider:SetStep(1) -- Defaults to 1
	Slider:SetText('This is a Slider widget, with an an editbox')
	Slider:SetNewFeature(true)
	Slider:On('Update', function(self, event, ...)
		print('Slider received "' .. event .. '" event, arguments:', ...)
	end)

	local ColorPicker = self:CreateColorPicker('colorpicker')
	ColorPicker:SetPoint('TOPLEFT', Slider, 'BOTTOMLEFT', 0, -22)
	ColorPicker:EnableAlpha(true)
	ColorPicker:SetText('This is a ColorPicker widget')
	ColorPicker:On('Update', function(self, event, r, g, b, a, hex)
		print('ColorPicker received and update with values', r, g, b, a, hex)
	end)
	ColorPicker:On('Open', function(self, event)
		print('ColorPicker received "' .. event .. '" event')
	end)
end

local defaults = {
	checkbutton = true,
	dropdown = 3,
	slider = 1,
	colorpicker = 'ff003399',
}

local Panel = LibStub('Wasabi'):New('Wasabi', 'WasabiTestsDB', defaults)
Panel:AddSlash('/wa')
Panel:AddSlash('/wasabi')
Panel:Initialize(Config)

local Sub = Panel:CreateChild('Subpanel', 'WasabiSubTestsDB', defaults)
Sub:Initialize(Config)
