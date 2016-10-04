local util = AdvancedFilters.util

local function BoPCallback(slot)
    local bagId, slotIndex = slot.bagId, slot.slotIndex

    if not bagId or not slotIndex then return false end

    if IsItemBoPAndTradeable(bagId, slotIndex) then return true end

    return false
end

local dropdownCallback = {
    {name = "BoPTade", filterCallback = BoPCallback},
}

local strings = {
    ["BoPTade"] = "Bound but Tradeable",
}

local filterInformation = {
    callbackTable = dropdownCallback,
    filterType = ITEMFILTERTYPE_WEAPONS,
    subfilters = {"All",},
    enStrings = strings,
}

AdvancedFilters_RegisterFilter(filterInformation)

filterInformation = {
    callbackTable = dropdownCallback,
    filterType = ITEMFILTERTYPE_ARMOR,
    subfilters = {"All",},
    enStrings = strings,
}

AdvancedFilters_RegisterFilter(filterInformation)