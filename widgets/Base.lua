local Wasabi = LibStub and LibStub('Wasabi', true)
if(not Wasabi) then
	return
end

local textMethods = {}
function textMethods:SetText(str)
	self.Text._content = str
	self.Text:SetText(str)
end
function textMethods:SetFormattedText(...)
	local str = string.format(...)
	self.Text._content = str
	self.Text:SetText(str)
end

local newFeatureIcon = [[|TInterface\OptionsFrame\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1|t]]
function textMethods:SetNewFeature(enabled)
	self._newFeature = enabled

	if(enabled) then
		self.Text:SetFormattedText('%s %s', self.Text._content, newFeatureIcon)
	else
		self.Text:SetText(self.Text._content)
	end
end

Wasabi:RegisterBaseWidget('Text', 1, function(parent)
	local Text = parent:CreateFontString(nil, nil, 'GameFontHighlightLeft')
	Text:SetPoint('LEFT', parent, 'RIGHT', 4, 1)
	parent.Text = Text

	for method, func in next, textMethods do
		parent[method] = func
	end
end)

local eventMethods = {}
function eventMethods:On(...)
	local numParams = select('#', ...)
	local callback = select(numParams, ...)
	assert(type(callback) == 'function')

	for index = numParams - 1, 1, -1 do
		self._events[select(index, ...)] = callback
	end
end

function eventMethods:Fire(event, ...)
	if(self._events[event]) then
		self._events[event](self, ...)
	end
end

Wasabi:RegisterBaseWidget('Events', 1, function(parent)
	parent._events = {}

	for method, func in next, eventMethods do
		parent[method] = func
	end
end)