local function GetFilterCallbackForNewStyleMaterial()
	return function(slot)
		local itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		local _, isNew = AdvancedFilters.util.LibMotifCategories:GetCategory(itemLink)
		
		return isNew
	end
end

local dropdownCallback = {
    [1] = {name = "NewStyle", filterCallback = GetFilterCallbackForNewStyleMaterial()},
}

local strings = {
    ["NewStyle"] = "New",
}

local filterInformation = {
    callbackTable = dropdownCallback,
    filterType = ITEMFILTERTYPE_CRAFTING,
    subfilters = {"Style",},
    enStrings = strings,
}

AdvancedFilters_RegisterFilter(filterInformation)

--ESO 2.4.0
if INVENTORY_CRAFT_BAG then
    filterInformation = {
        callbackTable = dropdownCallback,
        filterType = ITEMFILTERTYPE_STYLE_MATERIALS,
        subfilters = {"All",},
        enStrings = strings,
    }

    AdvancedFilters_RegisterFilter(filterInformation)
end