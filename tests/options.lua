local function Config(self)
	local CheckButton = self:CreateCheckButton('checkbutton')
	CheckButton:SetPoint('TOPLEFT', 16, -16)
	CheckButton:SetText('This is a CheckButton widget')
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
