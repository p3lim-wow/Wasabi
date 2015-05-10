local Wasabi = LibStub and LibStub('Wasabi', true)
if(not Wasabi) then
	return
end

Wasabi:RegisterWidget('Title', 1, function(parent)
	return parent:CreateFontString(nil, nil, 'GameFontNormalLarge')
end)

Wasabi:RegisterWidget('Description', 1, function(parent)
	return parent:CreateFontString(nil, nil, 'GameFontHighlightSmallLeft')
end)
