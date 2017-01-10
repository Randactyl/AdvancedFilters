local util = AdvancedFilters.util

local function GetFilterCallbackForNewMotif()
    return function(slot)
        local itemLink = util.GetItemLink(slot)

        return util.LibMotifCategories:IsNewMotif(itemLink)
    end
end

local dropdownCallback = {
    [1] = {name = "NewMotif", filterCallback = GetFilterCallbackForNewMotif()},
}

local strings = {
    ["NewMotif"] = "New Motif",
}

local filterInformation = {
    callbackTable = dropdownCallback,
    filterType = ITEMFILTERTYPE_WEAPONS,
    subfilters = {"All",},
    enStrings = strings,
}

AdvancedFilters_RegisterFilter(filterInformation)

filterInformation.filterType = ITEMFILTERTYPE_ARMOR
filterInformation.subfilters = {"Body", "Shield",}

AdvancedFilters_RegisterFilter(filterInformation)

filterInformation.filterType = ITEMFILTERTYPE_CONSUMABLE
filterInformation.subfilters = {"Motif",}

AdvancedFilters_RegisterFilter(filterInformation)

filterInformation.filterType = ITEMFILTERTYPE_CRAFTING
filterInformation.subfilters = {"Style",}

AdvancedFilters_RegisterFilter(filterInformation)

filterInformation.filterType = ITEMFILTERTYPE_STYLE_MATERIALS
filterInformation.subfilters = {"All",}

AdvancedFilters_RegisterFilter(filterInformation)