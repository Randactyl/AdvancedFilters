local util = AdvancedFilters.util
local lib = util.LibMotifCategories

local function GetFilterCallbackForMotifCategory(motifCategory)
    return function(slot)
        local itemLink = util.GetItemLink(slot)

        return lib:GetMotifCategory(itemLink) == motifCategory
    end
end

local dropdownCallbacks = {
    [1] = {name = "NormalStyle", filterCallback = GetFilterCallbackForMotifCategory(LMC_MOTIF_CATEGORY_NORMAL)},
    [2] = {name = "RareStyle", filterCallback = GetFilterCallbackForMotifCategory(LMC_MOTIF_CATEGORY_RARE)},
    [3] = {name = "AllianceStyle", filterCallback = GetFilterCallbackForMotifCategory(LMC_MOTIF_CATEGORY_ALLIANCE)},
    [4] = {name = "ExoticStyle", filterCallback = GetFilterCallbackForMotifCategory(LMC_MOTIF_CATEGORY_EXOTIC)},
    [5] = {name = "DroppedStyle", filterCallback = GetFilterCallbackForMotifCategory(LMC_MOTIF_CATEGORY_DROPPED)},
}

local strings = {
    ["MotifCategories"] = "Motif Categories",
    ["NormalStyle"] = lib:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_NORMAL),
    ["RareStyle"] = lib:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_RARE),
    ["AllianceStyle"] = lib:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_ALLIANCE),
    ["ExoticStyle"] = lib:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_EXOTIC),
    ["DroppedStyle"] = lib:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_DROPPED),
}

local filterInformation = {
    submenuName = "MotifCategories",
    callbackTable = dropdownCallbacks,
    filterType = ITEMFILTERTYPE_WEAPONS,
    subfilters = {"All",},
    enStrings = strings,
}

AdvancedFilters_RegisterFilter(filterInformation)

filterInformation.filterType = ITEMFILTERTYPE_ARMOR
filterInformation.subfilters = {"Body", "Shield", "Jewelry",}

AdvancedFilters_RegisterFilter(filterInformation)