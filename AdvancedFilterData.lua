local function GetFilterCallbackForWeaponType( filterTypes )
	return function( slot )
		local itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		local weaponType = GetItemLinkWeaponType(itemLink)
		for i=1, #filterTypes do
			if(filterTypes[i] == weaponType) then
				return true
			end
		end
	end
end

local function GetFilterCallbackForArmorType( filterTypes )
	return function( slot )
		local itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		local armorType = GetItemLinkArmorType(itemLink)
		for i=1, #filterTypes do
			if(filterTypes[i] == armorType) then 
				return true 
			end
		end
	end
end

local function GetFilterCallbackForGear( filterTypes )
	return function( slot )
		local result = false
		for i=1, #filterTypes do
			local _,_,_,_,_,equipType = GetItemInfo(slot.bagId, slot.slotIndex)
			result = result or (filterTypes[i] == equipType)
		end
		return result
	end
end

local function GetFilterCallbackForEnchanting( filterTypes )
	return function( slot )
		local result = false
		for i=1, #filterTypes do
			local _,_,runeType = GetItemCraftingInfo(slot.bagId, slot.slotIndex)
			result = result or (filterTypes[i] == runeType)
		end
		return result
	end
end

local function GetFilterCallback( filterTypes )
	if(not filterTypes) then return function(slot) return true end end

	return function( slot )
		local result = false
		for i=1, #filterTypes do
			result = result or (filterTypes[i] == GetItemType(slot.bagId, slot.slotIndex))
		end
		return result
	end
end

local AF_Callbacks = {
	[ITEMFILTERTYPE_ALL] = {
		[1] = { name = "All", filterCallback = GetFilterCallback(nil) },
	},
	[ITEMFILTERTYPE_WEAPONS] = {
		Addons = {},
		["All"] = {},
		["OneHanded"] = {
			[1] = { name = "Axe", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_AXE}) },
		    [2] = { name = "Hammer", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_HAMMER}) },
		    [3] = { name = "Sword", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_SWORD}) },
		    [4] = { name = "Dagger", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_DAGGER}) },
		},
		["TwoHanded"] = {
			[1] = { name = "2HAxe", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_AXE}) },
			[2] = { name = "2HHammer", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_HAMMER}) },
			[3] = { name = "2HSword", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_SWORD}) },
		},
		["Bow"] = {},
		["DestructionStaff"] = {
			[1] = { name = "Fire", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_FIRE_STAFF}) },
			[2] = { name = "Frost", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_FROST_STAFF}) },
			[3] = { name = "Lightning", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_LIGHTNING_STAFF}) },
		},
		["HealStaff"] = {},
	},
	[ITEMFILTERTYPE_ARMOR] = {
		Addons = {},
		["All"] = {},
		["Body"] = {
			[1] = { name = "Head", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_HEAD}) },
			[2] = { name = "Chest", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_CHEST}) },
			[3] = { name = "Shoulders", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_SHOULDERS}) },
			[4] = { name = "Hand", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_HAND}) },
			[5] = { name = "Waist", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_WAIST}) },
			[6] = { name = "Legs", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_LEGS}) },
			[7] = { name = "Feet", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_FEET}) },
		},
		["Shield"] = {},
		["Jewelry"] = {
			[1] = { name = "Ring", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_RING}) },
			[2] = { name = "Neck", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_NECK}) },
		},
		["Miscellaneous"] = {},
	},
	[ITEMFILTERTYPE_CONSUMABLE] = {
		Addons = {},
		["All"] = {},
		["Food"] = {},
		["Drink"] = {},
		["Recipe"] = {},
		["Potion"] = {},
		["Poison"] = {},
		["Motif"] = {},
		["Container"] = {},
		["Repair"] = {},
		["Trophy"] = {},

	},
	[ITEMFILTERTYPE_CRAFTING] = {
		Addons = {},
		["All"] = {},
		["Blacksmithing"] = {},
		["Clothier"] = {},
		["Woodworking"] = {},
		["Alchemy"] = {},
		["Runes"] = {
			[1] = { name = "Aspect", filterCallback = GetFilterCallbackForEnchanting({ENCHANTING_RUNE_ASPECT}) },
			[2] = { name = "Essence", filterCallback = GetFilterCallbackForEnchanting({ENCHANTING_RUNE_ESSENCE}) },
			[3] = { name = "Potency", filterCallback = GetFilterCallbackForEnchanting({ENCHANTING_RUNE_POTENCY}) },
		},
		["Provisioning"] = {},
		["ItemStyle"] = {},
		["WeaponTrait"] = {},
		["ArmorTrait"] = {},
	},
	[ITEMFILTERTYPE_MISCELLANEOUS] = {
		Addons = {},
		["All"] = {},
		["Glyphs"] = {
			[1] = { name = "ArmorGlyph", filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_ARMOR}) },
			[2] = { name = "JewelryGlyph", filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_JEWELRY}) },
			[3] = { name = "WeaponGlyph", filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_WEAPON}) },
		},
		["SoulGem"] = {},
		["Siege"] = {},
		["Bait"] = {},
		["Tool"] = {},
		["Trash"] = {},
		["Trophy"] = {},
	},
}

function AdvancedFilters_RegisterFilter(filterInformation)
	if filterInformation == nil then 
		d("No filter information provided. Filter not registered.")
		return 
	end
	if filterInformation.callbackTable == nil then 
		d("No callback information provided. Filter not registered.")
		return 
	end
	if filterInformation.subfilters == nil then 
		d("No subfilter type information provided. Filter not registered.")
		return
	end
	if filterInformation.filterType == nil then 
		d("No base filter type information provided. Filter not registered.")
		return 
	end

	local addonInformation = {
		callbackTable = filterInformation.callbackTable,
		subfilters = filterInformation.subfilters,
	}
	local filterType = filterInformation.filterType
	local enStrings = filterInformation.enStrings
	local deStrings = enStrings
	local frStrings = enStrings
	local ruStrings = enStrings

	if filterInformation.deStrings ~= nil then deStrings = filterInformation.deStrings end
	if filterInformation.frStrings ~= nil then frStrings = filterInformation.frStrings end
	if filterInformation.ruStrings ~= nil then ruStrings = filterInformation.ruStrings end

	if(filterType == ITEMFILTERTYPE_ALL) then
		table.insert(AF_Callbacks[ITEMFILTERTYPE_WEAPONS].Addons, addonInformation)
		table.insert(AF_Callbacks[ITEMFILTERTYPE_ARMOR].Addons, addonInformation)
		table.insert(AF_Callbacks[ITEMFILTERTYPE_CONSUMABLE].Addons, addonInformation)
		table.insert(AF_Callbacks[ITEMFILTERTYPE_CRAFTING].Addons, addonInformation)
		table.insert(AF_Callbacks[ITEMFILTERTYPE_MISCELLANEOUS].Addons, addonInformation)
	else
		table.insert(AF_Callbacks[filterType].Addons, addonInformation)
	end

	local function addStrings(lang, strings)
		for key, string in pairs(strings) do
			AF_Strings[lang].TOOLTIPS[key] = string
		end
	end

	addStrings("en", enStrings)

	if deStrings ~= enStrings then addStrings("de", deStrings) end
	if frStrings ~= enStrings then addStrings("fr", frStrings) end
	if ruStrings ~= enStrings then addStrings("ru", ruStrings) end
end

local function BuildCallbackTable(filterType, subfilterString)
	local callbackTable = {}
	local keys = {
		[ITEMFILTERTYPE_WEAPONS] = {
			[1] = "All",
			[2] = "OneHanded",
			[3] = "TwoHanded",
			[4] = "Bow",
			[5] = "DestructionStaff",
			[6] = "HealStaff",
		},
		[ITEMFILTERTYPE_ARMOR] = {
			[1] = "All",
			[2] = "Body",
			[3] = "Shield",
			[4] = "Jewelry",
			[5] = "Miscellaneous",
		},
		[ITEMFILTERTYPE_CONSUMABLE] = {
			[1] = "All",
			[2] = "Food",
			[3] = "Drink",
			[4] = "Recipe",
			[5] = "Potion",
			[6] = "Poison",
			[7] = "Motif",
			[8] = "Container",
			[9] = "Repair",
			[10] = "Trophy",
		},
		[ITEMFILTERTYPE_CRAFTING] = {
			[1] = "All",
			[2] = "Blacksmithing",
			[3] = "Clothier",
			[4] = "Woodworking",
			[5] = "Alchemy",
			[6] = "Runes",
			[7] = "Provisioning",
			[8] = "ItemStyle",
			[9] = "WeaponTrait",
			[10] = "ArmorTrait",
		},
		[ITEMFILTERTYPE_MISCELLANEOUS] = {
			[1] = "All",
			[2] = "Glyphs",
			[3] = "SoulGem",
			[4] = "Siege",
			[5] = "Bait",
			[6] = "Tool",
			[7] = "Trash",
			[8] = "Trophy",
		},
	}

	if subfilterString == "All" then
		-- insert global "All" filters
		for i = 1, #AF_Callbacks[ITEMFILTERTYPE_ALL], 1 do
			table.insert(callbackTable, AF_Callbacks[ITEMFILTERTYPE_ALL][i])
		end

		--insert all default filters for each subfilter
		for i = 1, #keys[filterType], 1 do
			local currentSubfilterIndex = keys[filterType][i]
			local currentSubfilterTable = AF_Callbacks[filterType][currentSubfilterIndex]

			for j = 1, #currentSubfilterTable, 1 do
				table.insert(callbackTable, currentSubfilterTable[j])
			end
		end

		--insert all filters provided by addons
		for i = 1, #AF_Callbacks[filterType].Addons, 1 do
			local currentAddonTable = AF_Callbacks[filterType].Addons[i].callbackTable

			for j = 1, #currentAddonTable, 1 do
				table.insert(callbackTable, currentAddonTable[j])
			end
		end
	else
		-- insert global "All" filters
		for i = 1, #AF_Callbacks[ITEMFILTERTYPE_ALL], 1 do
			table.insert(callbackTable, AF_Callbacks[ITEMFILTERTYPE_ALL][i])
		end

		--insert filters for provided subfilter
		local currentSubfilterTable = AF_Callbacks[filterType][subfilterString]
		for i = 1, #currentSubfilterTable, 1 do
			table.insert(callbackTable, currentSubfilterTable[i])
		end

		--insert filters provided by addons for this subfilter
		local addonTable = AF_Callbacks[filterType].Addons
		for i = 1, #addonTable, 1 do
			local continue = false
			local allEncountered = false
			--scan addon to see if it applies to given subfilter
			for j = 1, #addonTable[i].subfilters, 1 do
				if addonTable[i].subfilters[j] == subfilterString then continue = true end
				if addonTable[i].subfilters[j] == "All" then allEncountered = true end
			end
			if allEncountered then
				for j = 1, #addonTable[i].callbackTable, 1 do
					table.insert(callbackTable, addonTable[i].callbackTable[j])
				end
			end
			if continue then
				--insert filters provided by addon
				for j = 1, #addonTable[i].callbackTable, 1 do
					table.insert(callbackTable, addonTable[i].callbackTable[j])
				end
			end
		end		
	end

	return callbackTable
end

local hasInit = false

function AdvancedFilters_InitAllFilters()
	if(hasInit) then return nil end
	hasInit = true

	local icon = [[/esoui/art/buttons/edit_disabled.dds]]

	-- WEAPONS --
	local allWeaponDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_WEAPONS, "All")
	local oneHandedDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_WEAPONS, "OneHanded")
	local twoHandedDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_WEAPONS, "TwoHanded")
	local bowDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_WEAPONS, "Bow")
	local destructionStaffDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_WEAPONS, "DestructionStaff")
	local healStaffDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_WEAPONS, "HealStaff")

	local WEAPONS = AdvancedFilterGroup:New("Weapons")
	WEAPONS:AddSubfilter("HealStaff", [[/esoui/art/progression/icon_healstaff.dds]], 
		GetFilterCallbackForWeaponType({WEAPONTYPE_HEALING_STAFF}), healStaffDropdownCallbacks)
	WEAPONS:AddSubfilter("DestructionStaff", [[/esoui/art/progression/icon_firestaff.dds]], 
		GetFilterCallbackForWeaponType({WEAPONTYPE_FIRE_STAFF, WEAPONTYPE_FROST_STAFF, WEAPONTYPE_LIGHTNING_STAFF}),
		destructionStaffDropdownCallbacks)
	WEAPONS:AddSubfilter("Bow", [[/esoui/art/progression/icon_bows.dds]], 
		GetFilterCallbackForWeaponType({WEAPONTYPE_BOW}), bowDropdownCallbacks)
	WEAPONS:AddSubfilter("TwoHand", [[/esoui/art/progression/icon_2handed.dds]], 
		GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_AXE, WEAPONTYPE_TWO_HANDED_HAMMER, WEAPONTYPE_TWO_HANDED_SWORD}),
		twoHandedDropdownCallbacks)
	WEAPONS:AddSubfilter("OneHand", [[/esoui/art/progression/icon_dualwield.dds]], 
		GetFilterCallbackForWeaponType({WEAPONTYPE_AXE, WEAPONTYPE_HAMMER, WEAPONTYPE_SWORD, WEAPONTYPE_DAGGER}),
		oneHandedDropdownCallbacks)
	WEAPONS:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil), allWeaponDropdownCallbacks)

	-- ARMORS --
	local allArmorDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_ARMOR, "All")
	local lightArmorDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_ARMOR, "Body")
	local mediumArmorDropdownCallbacks = ZO_DeepTableCopy(lightArmorDropdownCallbacks, mediumArmorDropdownCallbacks)
	local heavyArmorDropdownCallbacks = ZO_DeepTableCopy(lightArmorDropdownCallbacks, heavyArmorDropdownCallbacks)
	local shieldDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_ARMOR, "Shield")
	local jewelryDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_ARMOR, "Jewelry")
	local miscDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_ARMOR, "Miscellaneous")

	local ARMORS = AdvancedFilterGroup:New("Armors")
	ARMORS:AddSubfilter("Misc", [[/esoui/art/inventory/inventory_tabicon_misc_up.dds]],
		GetFilterCallbackForGear({EQUIP_TYPE_DISGUISE, EQUIP_TYPE_COSTUME}), miscDropdownCallbacks)
	ARMORS:AddSubfilter("Jewelry", [[/esoui/art/charactercreate/charactercreate_accessory_up.dds]],
		GetFilterCallbackForGear({EQUIP_TYPE_RING, EQUIP_TYPE_NECK}), jewelryDropdownCallbacks)
	ARMORS:AddSubfilter("Shield", [[/esoui/art/guild/guildhistory_indexicon_guild_up.dds]],
		GetFilterCallbackForGear({EQUIP_TYPE_OFF_HAND}), shieldDropdownCallbacks)
	ARMORS:AddSubfilter("Light", [[/esoui/art/charactercreate/charactercreate_bodyicon_up.dds]],
		GetFilterCallbackForArmorType({ARMORTYPE_LIGHT}), lightArmorDropdownCallbacks)
	ARMORS:AddSubfilter("Medium", [[/esoui/art/campaign/overview_indexicon_scoring_up.dds]],
		GetFilterCallbackForArmorType({ARMORTYPE_MEDIUM}), mediumArmorDropdownCallbacks)
	ARMORS:AddSubfilter("Heavy", [[/esoui/art/inventory/inventory_tabicon_armor_up.dds]],
		GetFilterCallbackForArmorType({ARMORTYPE_HEAVY}), heavyArmorDropdownCallbacks)
	ARMORS:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil), allArmorDropdownCallbacks)

	-- CONSUMABLES --
	local allConsumablesDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CONSUMABLE, "All")
	local foodDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CONSUMABLE, "Food")
	local drinkDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CONSUMABLE, "Drink")
	local recipeDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CONSUMABLE, "Recipe")
	local potionDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CONSUMABLE, "Potion")
	local poisonDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CONSUMABLE, "Poison")
	local motifDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CONSUMABLE, "Motif")
	local containerDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CONSUMABLE, "Container")
	local repairDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CONSUMABLE, "Repair")
	local trophyDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CONSUMABLE, "Trophy")

	local CONSUMABLES = AdvancedFilterGroup:New("Consumables")
	CONSUMABLES:AddSubfilter("Trophy", AF_TextureMap.TROPHY, GetFilterCallback({ITEMTYPE_TROPHY, ITEMTYPE_COLLECTIBLE}),
		trophyDropdownCallbacks)
	CONSUMABLES:AddSubfilter("Repair", AF_TextureMap.REPAIR, GetFilterCallback({ITEMTYPE_AVA_REPAIR, ITEMTYPE_TOOL}),
		repairDropdownCallbacks)
	CONSUMABLES:AddSubfilter("Container", AF_TextureMap.CONTAINER, GetFilterCallback({ITEMTYPE_CONTAINER}),
		containerDropdownCallbacks)
	CONSUMABLES:AddSubfilter("Motif", AF_TextureMap.MOTIF, GetFilterCallback({ITEMTYPE_RACIAL_STYLE_MOTIF}),
		motifDropdownCallbacks)
	CONSUMABLES:AddSubfilter("Poison", AF_TextureMap.POISON, GetFilterCallback({ITEMTYPE_POISON}),
		poisonDropdownCallbacks)
	CONSUMABLES:AddSubfilter("Potion", AF_TextureMap.POTION, GetFilterCallback({ITEMTYPE_POTION}),
		potionDropdownCallbacks)
	CONSUMABLES:AddSubfilter("Recipe", AF_TextureMap.RECIPE, GetFilterCallback({ITEMTYPE_RECIPE}),
		recipeDropdownCallbacks)
	CONSUMABLES:AddSubfilter("Drink", AF_TextureMap.DRINK, GetFilterCallback({ITEMTYPE_DRINK}),
		drinkDropdownCallbacks)
	CONSUMABLES:AddSubfilter("Food", AF_TextureMap.FOOD, GetFilterCallback({ITEMTYPE_FOOD}),
		foodDropdownCallbacks)
	CONSUMABLES:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil), allConsumablesDropdownCallbacks)

	-- MATERIALS --
	local allMaterialsDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CRAFTING, "All")
	local blacksmithingDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CRAFTING, "Blacksmithing")
	local clothierDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CRAFTING, "Clothier")
	local woodworkingDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CRAFTING, "Woodworking")
	local alchemyDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CRAFTING, "Alchemy")
	local runeDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CRAFTING, "Runes")
	local provisioningDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CRAFTING, "Provisioning")
	local styleDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CRAFTING, "ItemStyle")
	local weapontraitDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CRAFTING, "WeaponTrait")
	local armortraitDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_CRAFTING, "ArmorTrait")

	local MATERIALS = AdvancedFilterGroup:New("Materials")
	MATERIALS:AddSubfilter("ArmorTrait", AF_TextureMap.ATRAIT, GetFilterCallback({ITEMTYPE_ARMOR_TRAIT}),
		armortraitDropdownCallbacks)
	MATERIALS:AddSubfilter("WeaponTrait", AF_TextureMap.WTRAIT, GetFilterCallback({ITEMTYPE_WEAPON_TRAIT}),
		weapontraitDropdownCallbacks)
	MATERIALS:AddSubfilter("Style", AF_TextureMap.STYLE, GetFilterCallback({ITEMTYPE_STYLE_MATERIAL}),
		styleDropdownCallbacks)
	MATERIALS:AddSubfilter("Provisioning", AF_TextureMap.PROVISIONING, GetFilterCallback({ITEMTYPE_INGREDIENT}),
		provisioningDropdownCallbacks)
	MATERIALS:AddSubfilter("Enchanting", AF_TextureMap.ENCHANTING, GetFilterCallback({ITEMTYPE_ENCHANTING_RUNE_ASPECT, ITEMTYPE_ENCHANTING_RUNE_ESSENCE, ITEMTYPE_ENCHANTING_RUNE_POTENCY}),
		runeDropdownCallbacks)
	MATERIALS:AddSubfilter("Alchemy", AF_TextureMap.ALCHEMY, GetFilterCallback({ITEMTYPE_REAGENT, ITEMTYPE_ALCHEMY_BASE}),
		alchemyDropdownCallbacks)
	MATERIALS:AddSubfilter("Woodworking", AF_TextureMap.WOODWORKING, GetFilterCallback({ITEMTYPE_RAW_MATERIAL, ITEMTYPE_WOODWORKING_MATERIAL, ITEMTYPE_WOODWORKING_RAW_MATERIAL, ITEMTYPE_WOODWORKING_BOOSTER}),
		woodworkingDropdownCallbacks)
	MATERIALS:AddSubfilter("Clothier", AF_TextureMap.CLOTHIER, GetFilterCallback({ITEMTYPE_RAW_MATERIAL, ITEMTYPE_CLOTHIER_MATERIAL, ITEMTYPE_CLOTHIER_RAW_MATERIAL, ITEMTYPE_CLOTHIER_BOOSTER}),
		clothierDropdownCallbacks)
	MATERIALS:AddSubfilter("Blacksmithing", AF_TextureMap.BLACKSMITHING, GetFilterCallback({ITEMTYPE_RAW_MATERIAL, ITEMTYPE_BLACKSMITHING_MATERIAL, ITEMTYPE_BLACKSMITHING_RAW_MATERIAL, ITEMTYPE_BLACKSMITHING_BOOSTER}),
		blacksmithingDropdownCallbacks)
	MATERIALS:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil), allMaterialsDropdownCallbacks)

	-- MISCELLANEOUS --
	local allMiscellaneousDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_MISCELLANEOUS, "All")
	local glyphDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_MISCELLANEOUS, "Glyphs")
	local soulgemDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_MISCELLANEOUS, "SoulGem")
	local siegeDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_MISCELLANEOUS, "Siege")
	local baitDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_MISCELLANEOUS, "Bait")
	local toolDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_MISCELLANEOUS, "Tool")
	local trashDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_MISCELLANEOUS, "Trash")
	local trophyDropdownCallbacks = BuildCallbackTable(ITEMFILTERTYPE_MISCELLANEOUS, "Trophy")


	local MISCELLANEOUS = AdvancedFilterGroup:New("Miscellaneous")
	MISCELLANEOUS:AddSubfilter("Trophy", AF_TextureMap.TROPHY, GetFilterCallback({ITEMTYPE_TROPHY, ITEMTYPE_COLLECTIBLE}),
		trophyDropdownCallbacks)
	MISCELLANEOUS:AddSubfilter("Trash", AF_TextureMap.TRASH, GetFilterCallback({ITEMTYPE_TRASH}),
		trashDropdownCallbacks)
	MISCELLANEOUS:AddSubfilter("Tool", AF_TextureMap.TOOL, GetFilterCallback({ITEMTYPE_TOOL}),
		toolDropdownCallbacks)
	MISCELLANEOUS:AddSubfilter("Bait", AF_TextureMap.BAIT, GetFilterCallback({ITEMTYPE_LURE}),
		baitDropdownCallbacks)
	MISCELLANEOUS:AddSubfilter("Siege", AF_TextureMap.AVAWEAPON, GetFilterCallback({ITEMTYPE_SIEGE}),
		siegeDropdownCallbacks)
	MISCELLANEOUS:AddSubfilter("SoulGem", AF_TextureMap.SOULGEM, GetFilterCallback({ITEMTYPE_SOUL_GEM}),
		soulgemDropdownCallbacks)
	MISCELLANEOUS:AddSubfilter("Glyphs", AF_TextureMap.GLYPHS, GetFilterCallback({ITEMTYPE_GLYPH_ARMOR, ITEMTYPE_GLYPH_JEWELRY, ITEMTYPE_GLYPH_WEAPON}),
		glyphDropdownCallbacks)
	MISCELLANEOUS:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil), allMiscellaneousDropdownCallbacks)

	-- QUICKSLOT --
	--[[local QUICKSLOT = AdvancedFilterGroup:New("Quickslot")
	QUICKSLOT:AddSubfilter("Container", AF_TextureMap.CONTAINER, GetFilterCallback({ITEMTYPE_CONTAINER}))
	QUICKSLOT:AddSubfilter("Trophy", AF_TextureMap.TROPHY, GetFilterCallback({ITEMTYPE_TROPHY, ITEMTYPE_COLLECTIBLE}))
	QUICKSLOT:AddSubfilter("Drink", AF_TextureMap.DRINK, GetFilterCallback({ITEMTYPE_DRINK}))
	QUICKSLOT:AddSubfilter("Food", AF_TextureMap.FOOD, GetFilterCallback({ITEMTYPE_FOOD}))
	QUICKSLOT:AddSubfilter("Repair", AF_TextureMap.REPAIR, GetFilterCallback({ITEMTYPE_AVA_REPAIR, ITEMTYPE_TOOL}))
	QUICKSLOT:AddSubfilter("Siege", AF_TextureMap.AVAWEAPON, GetFilterCallback({ITEMTYPE_SIEGE}))
	QUICKSLOT:AddSubfilter("Poison", AF_TextureMap.POISON, GetFilterCallback({ITEMTYPE_POISON}))
	QUICKSLOT:AddSubfilter("Potion", AF_TextureMap.POTION, GetFilterCallback({ITEMTYPE_POTION}))
	QUICKSLOT:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil))]]

	AF_Callbacks = {}

	return WEAPONS,ARMORS,CONSUMABLES,MATERIALS,MISCELLANEOUS
end