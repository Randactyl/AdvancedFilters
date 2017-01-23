local cpIcon = zo_iconFormat("/esoui/art/menubar/gamepad/gp_playermenu_icon_champion.dds", 18, 18)
local util = AdvancedFilters.util

--[[----------------------------------------------------------------------------
    The anonymous function returned by this function handles the actual
        filtering.
    Use whatever parameters for "GetFilterCallback..." and whatever logic you
        need to in "function(slot)".
    "slot" is a table of item data. A typical slot can be found in
        PLAYER_INVENTORY.inventories[bagId].slots[slotIndex].
    A return value of true means the item in question will be shown while the
        filter is active. False means the item will be hidden while the filter
        is active.
--]]----------------------------------------------------------------------------
local function GetFilterCallbackForLevel(minLevel, maxLevel)
    return function(slot)
        local itemLink = util.GetItemLink(slot)
        local level = GetItemLinkRequiredLevel(itemLink)
        local cp = GetItemLinkRequiredChampionPoints(itemLink)

        if cp > 0 then
            level = level + cp
        end

        return false or ((level >= minLevel) and (level <= maxLevel))
    end
end

--[[----------------------------------------------------------------------------
    This table is processed within Advanced Filters and its contents are added
        to Advanced Filters'  master callback table.
    The string value for name is the relevant key for the language table.
--]]----------------------------------------------------------------------------
local fullLevelDropdownCallbacks = {
    [1] = {name = "1-10", filterCallback = GetFilterCallbackForLevel(1, 10)},
    [2] = {name = "11-20", filterCallback = GetFilterCallbackForLevel(11, 20)},
    [3] = {name = "21-30", filterCallback = GetFilterCallbackForLevel(21, 30)},
    [4] = {name = "31-40", filterCallback = GetFilterCallbackForLevel(31, 40)},
    [5] = {name = "41-50", filterCallback = GetFilterCallbackForLevel(41, 50)},
    [6] = {name = "cp10-20", filterCallback = GetFilterCallbackForLevel(60, 70)},
    [7] = {name = "cp30-40", filterCallback = GetFilterCallbackForLevel(80, 90)},
    [8] = {name = "cp50-60", filterCallback = GetFilterCallbackForLevel(100, 110)},
    [9] = {name = "cp70-80", filterCallback = GetFilterCallbackForLevel(120, 130)},
    [10] = {name = "cp90-100", filterCallback = GetFilterCallbackForLevel(140, 150)},
    [11] = {name = "cp110-120", filterCallback = GetFilterCallbackForLevel(160, 170)},
    [12] = {name = "cp130-140", filterCallback = GetFilterCallbackForLevel(180, 190)},
    [13] = {name = "cp150-160", filterCallback = GetFilterCallbackForLevel(200, 210)},
}

--[[----------------------------------------------------------------------------
    There are many potential tables for this section, each covering a different
        language supported by Advanced Filters. Only English is required. See
        AdvancedFilters/strings/ for a list of implemented languages.
    If other language tables are not included, the English table will
        automatically be used for those languages.
    All languages must share common keys.
--]]----------------------------------------------------------------------------
local strings = {
    --Remember to provide a string for your submenu if using one (see below).
    ["LevelFilters"] = "Level Filters",
    ["1-10"] = "1-10",
    ["11-20"] = "11-20",
    ["21-30"] = "21-30",
    ["31-40"] = "31-40",
    ["41-50"] = "41-50",
    ["cp10-20"] = cpIcon .. "10-20",
    ["cp30-40"] = cpIcon .. "30-40",
    ["cp50-60"] = cpIcon .. "50-60",
    ["cp70-80"] = cpIcon .. "70-80",
    ["cp90-100"] = cpIcon .. "90-100",
    ["cp110-120"] = cpIcon .. "110-120",
    ["cp130-140"] = cpIcon .. "130-140",
    ["cp150-160"] = cpIcon .. "150-160",
}

--[[----------------------------------------------------------------------------
    This section packages the data for Advanced Filters to use.
    All keys are required except for xxStrings, where xx is any implemented
        language shortcode that is not "en". A few language keys are assigned
        the same table here only for demonstrative purposes. You do not need to
        do this.
    The filterType key expects an ITEMFILTERTYPE constant provided by the game.
    The values for key/value pairs in the "subfilters" table can be any of the
        string keys from the "masterSubfilterData" table in data.lua such as
        "All", "OneHanded", "Body", or "Blacksmithing".
    If your filterType is ITEMFILTERTYPE_ALL then the "subfilters" table must
        only contain the value "All".
    If the field "submenuName" is defined, your filters will be placed into a
        submenu in the dropdown list rather then in the root dropdown list
        itself. "submenuName" takes a string which matches a key in your strings
        table(s).
--]]----------------------------------------------------------------------------
local filterInformation = {
    submenuName = "LevelFilters",
    callbackTable = fullLevelDropdownCallbacks,
    filterType = ITEMFILTERTYPE_WEAPONS,
    subfilters = {"All",},
    enStrings = strings,
    deStrings = strings,
    frStrings = strings,
    ruStrings = strings,
    esStrings = strings,
}

--[[----------------------------------------------------------------------------
    Register your filters by passing your filter information to this function.
--]]----------------------------------------------------------------------------
AdvancedFilters_RegisterFilter(filterInformation)

--[[----------------------------------------------------------------------------
    If you want your filters to show up under more than one main filter,
        redefine filterInformation to use the new filterType.
    The shorthand version (not including optional languages) is shown here.
--]]----------------------------------------------------------------------------
filterInformation = {
    submenuName = "LevelFilters",
    callbackTable = fullLevelDropdownCallbacks,
    filterType = ITEMFILTERTYPE_ARMOR,
    subfilters = {"All",},
    enStrings = strings,
}

--[[----------------------------------------------------------------------------
    Again, register your filters by passing your new filter information to this
        function.
--]]----------------------------------------------------------------------------
AdvancedFilters_RegisterFilter(filterInformation)

--[[----------------------------------------------------------------------------
    If you only need to redefine some fields for the next registration, you can
        do that as well.
--]]----------------------------------------------------------------------------
filterInformation.filterType = ITEMFILTERTYPE_CONSUMABLE
filterInformation.subfilters = {"Food", "Drink", "Potion", "Poison",}

AdvancedFilters_RegisterFilter(filterInformation)