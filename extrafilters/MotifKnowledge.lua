local util = AdvancedFilters.util

local function GetFilterCallbackForCraftableMotif()
    return function(slot, slotIndex)
        if util.prepareSlot ~= nil then
            if slotIndex ~= nil and type(slot) ~= "table" then
                slot = util.prepareSlot(slot, slotIndex)
            end
        end
        local itemLink = util.GetItemLink(slot)

        return util.LibMotifCategories:IsMotifCraftable(itemLink)
    end
end

local function GetFilterCallbackForKnownMotif()
    return function(slot, slotIndex)
        if util.prepareSlot ~= nil then
            if slotIndex ~= nil and type(slot) ~= "table" then
                slot = util.prepareSlot(slot, slotIndex)
            end
        end
        local itemLink = util.GetItemLink(slot)

        return util.LibMotifCategories:IsMotifKnown(itemLink)
    end
end

local dropdownCallbacks = {
    [1] = {name = "CraftableMotif", filterCallback = GetFilterCallbackForCraftableMotif()},
    [2] = {name = "KnownMotif", filterCallback = GetFilterCallbackForKnownMotif()},
}

local styleDropdownCallbacks = {
    [1] = {name = "KnownMotif", filterCallback = GetFilterCallbackForKnownMotif()},
}

local strings = {
    ["MotifKnowledge"] = "Motif Knowledge",
    ["CraftableMotif"] = "Craftable Motif",
    ["KnownMotif"] = "Known Motif",
}
local stringsDE = {
    ["MotifKnowledge"] = "Motiv Wissen",
    ["CraftableMotif"] = "Herstellbare Motive",
    ["KnownMotif"] = "Bekannte Motive",
}

local filterInformation = {
    submenuName = "MotifKnowledge",
    callbackTable = dropdownCallbacks,
    filterType = ITEMFILTERTYPE_WEAPONS,
    subfilters = {"All",},
    deStrings = stringsDE,
    enStrings = strings,
}

AdvancedFilters_RegisterFilter(filterInformation)

filterInformation.filterType = ITEMFILTERTYPE_ARMOR
filterInformation.subfilters = {"Body", "Shield",}

AdvancedFilters_RegisterFilter(filterInformation)

filterInformation.filterType = ITEMFILTERTYPE_CONSUMABLE
filterInformation.subfilters = {"Motif",}

AdvancedFilters_RegisterFilter(filterInformation)

filterInformation.submenuName = nil
filterInformation.callbackTable = styleDropdownCallbacks
filterInformation.filterType = ITEMFILTERTYPE_CRAFTING
filterInformation.subfilters = {"Style",}

AdvancedFilters_RegisterFilter(filterInformation)

filterInformation.filterType = ITEMFILTERTYPE_STYLE_MATERIALS
filterInformation.subfilters = {"All",}

AdvancedFilters_RegisterFilter(filterInformation)