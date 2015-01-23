--[[
	This function handles the actual filtering. Use whatever parameters for "GetFilterCallback..." 
    and whatever logic you need to in "function( slot )". A return value of true means the item in
    question will be shown while the filter is active.
  ]]
local function GetFilterCallbackForLevel( minLevel, maxLevel )
	return function( slot )
		local link = GetItemLink(slot.bagId, slot.slotIndex)
		local level = GetItemLinkRequiredLevel(link)
		local vetLevel = GetItemLinkRequiredVeteranRank(link)

		if vetLevel > 0 then
			level = level + vetLevel
		end
		return false or ((level >= minLevel) and (level <= maxLevel))
	end
end

--[[
	This table is processed within Advanced Filters and its contents are added to Advanced Filters'
    callback table. The string value for name is the relevant key for the language table.
  ]]
local fullLevelDropdownCallbacks = {
	[1] = { name = "1-10", filterCallback = GetFilterCallbackForLevel(1, 10) },
	[2] = { name = "11-20", filterCallback = GetFilterCallbackForLevel(11, 20) },
	[3] = { name = "21-30", filterCallback = GetFilterCallbackForLevel(21, 30) },
	[4] = { name = "31-40", filterCallback = GetFilterCallbackForLevel(31, 40) },
	[5] = { name = "41-50", filterCallback = GetFilterCallbackForLevel(41, 50) },
	[6] = { name = "V1-V2", filterCallback = GetFilterCallbackForLevel(51, 52) },
	[7] = { name = "V3-V4", filterCallback = GetFilterCallbackForLevel(53, 54) },
	[8] = { name = "V5-V6", filterCallback = GetFilterCallbackForLevel(55, 56) },
	[9] = { name = "V7-V8", filterCallback = GetFilterCallbackForLevel(57, 58) },
	[10] = { name = "V9-V10", filterCallback = GetFilterCallbackForLevel(59, 60) },
	[11] = { name = "V11-V12", filterCallback = GetFilterCallbackForLevel(61, 62) },
	[12] = { name = "V13-V14", filterCallback = GetFilterCallbackForLevel(63, 64) },
}

--[[
	There are four potential tables for this section each covering either english, german, french, 
	or russian. Only english is required. If other language tables are not included, the english
	table will automatically be used for those languages. All languages must share common keys.
  ]]
local strings = {
	["1-10"] = "1-10",
	["11-20"] = "11-20",
	["21-30"] = "21-30",
	["31-40"] = "31-40",
	["41-50"] = "41-50",
	["V1-V2"] = "V1-V2",
	["V3-V4"] = "V3-V4",
	["V5-V6"] = "V5-V6",
	["V7-V8"] = "V7-V8",
	["V9-V10"] = "V9-V10",
	["V11-V12"] = "V11-V12",
	["V13-V14"] = "V13-V14",
}

--[[
	This section packages the data for Advanced Filters to use.
	All keys are required except for deStrings, frStrings, and ruStrings, as they correspond to 
		optional languages. Al language keys are assigned the same table here only to demonstrate
		the key names. You do not need to do this.
	The filterType key expects an ITEMFILTERTYPE constant provided by the game.
	The values for key/value pairs in subfilters can be any of the string keys from lines 127 - 218
		of AdvancedFiltersData.lua (AF_Callbacks table) such as "All", "OneHanded", "Body", or 
		"Blacksmithing".
	If your filterType is ITEMFILTERTYPE_ALL then subfilters must only contain the value "All".
  ]]
local filterInformation = {
	callbackTable = fullLevelDropdownCallbacks,
	filterType = ITEMFILTERTYPE_WEAPONS,
	subfilters = {
		[1] = "All",
	},
	enStrings = strings,
	deStrings = strings,
	frStrings = strings,
	ruStrings = strings,
	esStrings = strings,
}

--[[
	Register your filters by passing your filter information to this function.
  ]]
AdvancedFilters_RegisterFilter(filterInformation)

--[[
  	If you want your filters to show up under more than one main filter, redefine filterInformation
  	to include the new filterType. The shorthand version (not including optional languages) is shown here.
  ]]
filterInformation = {
	callbackTable = fullLevelDropdownCallbacks,
	filterType = ITEMFILTERTYPE_ARMOR,
	subfilters = {
		[1] = "All",
	},
	enStrings = strings,
}

--[[
	Again, register your filters by passing your new filter information to this function.
  ]]
AdvancedFilters_RegisterFilter(filterInformation)