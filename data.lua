local AF = AdvancedFilters

local function GetFilterCallbackForWeaponType(filterTypes)
	return function(slot)
		local itemLink

		if slot.bagId then
		    itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		else
			itemLink = GetStoreItemLink(slot.slotIndex)
		end

		local weaponType = GetItemLinkWeaponType(itemLink)

		for i=1, #filterTypes do
			if(filterTypes[i] == weaponType) then return true end
		end
	end
end

local function GetFilterCallbackForArmorType(filterTypes)
	return function(slot)
		local itemLink

		if slot.bagId then
		    itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		else
			itemLink = GetStoreItemLink(slot.slotIndex)
		end

		local armorType = GetItemLinkArmorType(itemLink)

		for i=1, #filterTypes do
			if(filterTypes[i] == armorType) then return true end
		end
	end
end

local function GetFilterCallbackForGear(filterTypes)
	return function(slot)
		local itemLink

		if slot.bagId then
		    itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		else
			itemLink = GetStoreItemLink(slot.slotIndex)
		end

		local _, _, _, equipType = GetItemLinkInfo(itemLink)

		for i=1, #filterTypes do
			if filterTypes[i] == equipType then return true end
		end
	end
end

local function GetFilterCallbackForClothing()
	return function(slot)
		local itemLink

		if slot.bagId then
		    itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		else
			itemLink = GetStoreItemLink(slot.slotIndex)
		end

		local armorType = GetItemLinkArmorType(itemLink)
		local _, _, _, equipType = GetItemLinkInfo(itemLink)

		if((armorType == ARMORTYPE_NONE) and
	      (equipType ~= EQUIP_TYPE_NECK) and (equipType ~= EQUIP_TYPE_MAIN_HAND) and
	      (equipType ~= EQUIP_TYPE_OFF_HAND) and (equipType ~= EQUIP_TYPE_ONE_HAND) and
	      (equipType ~= EQUIP_TYPE_TWO_HAND) and (equipType ~= EQUIP_TYPE_RING) and
	      (equipType ~= EQUIP_TYPE_COSTUME) and (equipType ~= EQUIP_TYPE_INVALID)) then
			return true
		end
	end
end

local function GetFilterCallbackForEnchanting(filterTypes)
	return function(slot)
		local itemLink

		if slot.bagId then
		    itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		else
			itemLink = GetStoreItemLink(slot.slotIndex)
		end

		local runeType = GetItemLinkEnchantingRuneClassification(itemLink)

		for i=1, #filterTypes do
			if filterTypes[i] == runeType then return true end
		end
	end
end

local function GetFilterCallbackForTrophy()
	return function(slot)
		local itemLink

		if slot.bagId then
		    itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		else
			itemLink = GetStoreItemLink(slot.slotIndex)
		end

		local itemType = GetItemLinkItemType(itemLink)

		if not IsItemLinkStolen(itemLink) and (itemType == ITEMTYPE_TROPHY
		  or itemType == ITEMTYPE_COLLECTIBLE or itemType == ITEMTYPE_FISH
		  or itemType == ITEMTYPE_TREASURE) then
			return true
		end
	end
end

local function GetFilterCallbackForFence()
	return function(slot)
		local itemLink

		if slot.bagId then
		    itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		else
			itemLink = GetStoreItemLink(slot.slotIndex)
		end

		local itemType = GetItemLinkItemType(itemLink)

		if IsItemLinkStolen(itemLink) and not (itemType == ITEMTYPE_GLYPH_ARMOR
		  or itemType == ITEMTYPE_GLYPH_JEWELRY
		  or itemType == ITEMTYPE_GLYPH_WEAPON or itemType == ITEMTYPE_SOUL_GEM
		  or itemType == ITEMTYPE_SIEGE or itemType == ITEMTYPE_LURE
		  or itemType == ITEMTYPE_TOOL or itemType == ITEMTYPE_TRASH) then
			return true
		end
	end
end

local function GetFilterCallback(filterTypes)
	if(not filterTypes) then return function(slot) return true end end

	return function(slot)
		local itemLink

		if slot.bagId then
		    itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		else
			itemLink = GetStoreItemLink(slot.slotIndex)
		end

		local itemType = GetItemLinkItemType(itemLink)

		for i=1, #filterTypes do
			if filterTypes[i] == itemType then return true end
		end
	end
end

AF.subfilterCallbacks = {
	["All"] = {
		dropdownCallbacks = {
			[1] = {name = "All", filterCallback = GetFilterCallback(nil)},
		},
	},
	["Weapons"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
		["OneHand"] = {
			filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_AXE, WEAPONTYPE_HAMMER, WEAPONTYPE_SWORD, WEAPONTYPE_DAGGER}),
			dropdownCallbacks = {
				[1] = {name = "Axe", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_AXE})},
			    [2] = {name = "Hammer", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_HAMMER})},
			    [3] = {name = "Sword", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_SWORD})},
			    [4] = {name = "Dagger", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_DAGGER})},
			},
		},
		["TwoHand"] = {
			filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_AXE, WEAPONTYPE_TWO_HANDED_HAMMER, WEAPONTYPE_TWO_HANDED_SWORD}),
			dropdownCallbacks = {
				[1] = {name = "2HAxe", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_AXE})},
				[2] = {name = "2HHammer", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_HAMMER})},
				[3] = {name = "2HSword", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_SWORD})},
			},
		},
		["Bow"] = {
			filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_BOW}),
			dropdownCallbacks = {},
		},
		["DestructionStaff"] = {
			filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_FIRE_STAFF, WEAPONTYPE_FROST_STAFF, WEAPONTYPE_LIGHTNING_STAFF}),
			dropdownCallbacks = {
				[1] = {name = "Fire", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_FIRE_STAFF})},
				[2] = {name = "Frost", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_FROST_STAFF})},
				[3] = {name = "Lightning", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_LIGHTNING_STAFF})},
			},
		},
		["HealStaff"] = {
			filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_HEALING_STAFF}),
			dropdownCallbacks = {},
		},
	},
	["Armor"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
		["Heavy"] = {
			filterCallback = GetFilterCallbackForArmorType({ARMORTYPE_HEAVY}),
		},
		["Medium"] = {
			filterCallback = GetFilterCallbackForArmorType({ARMORTYPE_MEDIUM}),
		},
		["Light"] = {
			filterCallback = GetFilterCallbackForArmorType({ARMORTYPE_LIGHT}),
		},
		["Clothing"] = {
			filterCallback = GetFilterCallbackForClothing(),
		},
		["Body"] = {
			dropdownCallbacks = {
				[1] = {name = "Head", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_HEAD})},
				[2] = {name = "Chest", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_CHEST})},
				[3] = {name = "Shoulders", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_SHOULDERS})},
				[4] = {name = "Hand", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_HAND})},
				[5] = {name = "Waist", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_WAIST})},
				[6] = {name = "Legs", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_LEGS})},
				[7] = {name = "Feet", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_FEET})},
			},
		},
		["Shield"] = {
			filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_OFF_HAND}),
			dropdownCallbacks = {},
		},
		["Jewelry"] = {
			filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_RING, EQUIP_TYPE_NECK}),
			dropdownCallbacks = {
				[1] = {name = "Ring", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_RING})},
				[2] = {name = "Neck", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_NECK})},
			},
		},
		["Vanity"] = {
			filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_DISGUISE, EQUIP_TYPE_COSTUME}),
			dropdownCallbacks = {},
		},
	},
	["Consumables"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
		["Crown"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_CROWN_ITEM}),
			dropdownCallbacks = {},
		},
		["Food"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_FOOD}),
			dropdownCallbacks = {},
		},
		["Drink"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_DRINK}),
			dropdownCallbacks = {},
		},
		["Recipe"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_RECIPE}),
			dropdownCallbacks = {},
		},
		["Potion"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_POTION}),
			dropdownCallbacks = {},
		},
		["Poison"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_POISON}),
			dropdownCallbacks = {},
		},
		["Motif"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_RACIAL_STYLE_MOTIF}),
			dropdownCallbacks = {},
		},
		["Container"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_CONTAINER}),
			dropdownCallbacks = {},
		},
		["Repair"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_AVA_REPAIR, ITEMTYPE_TOOL, ITEMTYPE_CROWN_REPAIR}),
			dropdownCallbacks = {},
		},
		["Trophy"] = {
			filterCallback = GetFilterCallbackForTrophy(),
			dropdownCallbacks = {},
		},
	},
	["Crafting"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
		["Blacksmithing"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_BLACKSMITHING_MATERIAL, ITEMTYPE_BLACKSMITHING_RAW_MATERIAL, ITEMTYPE_BLACKSMITHING_BOOSTER}),
			dropdownCallbacks = {},
		},
		["Clothier"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_CLOTHIER_MATERIAL, ITEMTYPE_CLOTHIER_RAW_MATERIAL, ITEMTYPE_CLOTHIER_BOOSTER}),
			dropdownCallbacks = {},
		},
		["Woodworking"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_WOODWORKING_MATERIAL, ITEMTYPE_WOODWORKING_RAW_MATERIAL, ITEMTYPE_WOODWORKING_BOOSTER}),
			dropdownCallbacks = {},
		},
		["Alchemy"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_REAGENT, ITEMTYPE_ALCHEMY_BASE}),
			dropdownCallbacks = {
				[1] = {name = "Reagent", filterCallback = GetFilterCallback({ITEMTYPE_REAGENT})},
				[2] = {name = "Solvent", filterCallback = GetFilterCallback({ITEMTYPE_ALCHEMY_BASE})},
			},
		},
		["Enchanting"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_ENCHANTING_RUNE_ASPECT, ITEMTYPE_ENCHANTING_RUNE_ESSENCE, ITEMTYPE_ENCHANTING_RUNE_POTENCY}),
			dropdownCallbacks = {
				[1] = {name = "Aspect", filterCallback = GetFilterCallbackForEnchanting({ENCHANTING_RUNE_ASPECT})},
				[2] = {name = "Essence", filterCallback = GetFilterCallbackForEnchanting({ENCHANTING_RUNE_ESSENCE})},
				[3] = {name = "Potency", filterCallback = GetFilterCallbackForEnchanting({ENCHANTING_RUNE_POTENCY})},
			},
		},
		["Provisioning"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_INGREDIENT}),
			dropdownCallbacks = {},
		},
		["Style"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_STYLE_MATERIAL, ITEMTYPE_RAW_MATERIAL}),
			dropdownCallbacks = {},
		},
		["WeaponTrait"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_WEAPON_TRAIT}),
			dropdownCallbacks = {},
		},
		["ArmorTrait"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_ARMOR_TRAIT}),
			dropdownCallbacks = {},
		},
	},
	["Miscellaneous"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
		["Glyphs"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_ARMOR, ITEMTYPE_GLYPH_JEWELRY, ITEMTYPE_GLYPH_WEAPON}),
			dropdownCallbacks = {
				[1] = {name = "ArmorGlyph", filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_ARMOR})},
				[2] = {name = "JewelryGlyph", filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_JEWELRY})},
				[3] = {name = "WeaponGlyph", filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_WEAPON})},
			},
		},
		["SoulGem"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_SOUL_GEM}),
			dropdownCallbacks = {},
		},
		["Siege"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_SIEGE}),
			dropdownCallbacks = {},
		},
		["Bait"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_LURE}),
			dropdownCallbacks = {},
		},
		["Tool"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_TOOL}),
			dropdownCallbacks = {},
		},
		["Trophy"] = {
			filterCallback = GetFilterCallbackForTrophy(),
			dropdownCallbacks = {},
		},
		["Fence"] = {
			filterCallback = GetFilterCallbackForFence(),
			dropdownCallbacks = {},
		},
		["Trash"] = {
			filterCallback = GetFilterCallback({ITEMTYPE_TRASH}),
			dropdownCallbacks = {},
		},
	},
}

function AdvancedFilters_RegisterFilter(filterInformation)
	local filterTypeToGroupName = {
		[ITEMFILTERTYPE_ALL] = "All",
		[ITEMFILTERTYPE_WEAPONS] = "Weapons",
		[ITEMFILTERTYPE_ARMOR] = "Armor",
		[ITEMFILTERTYPE_CONSUMABLE] = "Consumables",
		[ITEMFILTERTYPE_CRAFTING] = "Crafting",
		[ITEMFILTERTYPE_MISCELLANEOUS] = "Miscellaneous",
	}

	--make sure all necessary information is present
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
	if filterInformation.enStrings == nil then
		d("No English strings provided. Filter not registered.")
		return
	end

	--get filter information from the calling addon and insert it into our callback table
	local addonInformation = {
		submenuName = filterInformation.submenuName,
		callbackTable = filterInformation.callbackTable,
		subfilters = filterInformation.subfilters,
	}
	local groupName = filterTypeToGroupName[filterInformation.filterType]

	if(groupName == "All") then
		table.insert(AF.subfilterCallbacks["Weapons"].addonDropdownCallbacks, addonInformation)
		table.insert(AF.subfilterCallbacks["Armor"].addonDropdownCallbacks, addonInformation)
		table.insert(AF.subfilterCallbacks["Consumables"].addonDropdownCallbacks, addonInformation)
		table.insert(AF.subfilterCallbacks["Crafting"].addonDropdownCallbacks, addonInformation)
		table.insert(AF.subfilterCallbacks["Miscellaneous"].addonDropdownCallbacks, addonInformation)
	else
		table.insert(AF.subfilterCallbacks[groupName].addonDropdownCallbacks, addonInformation)
	end

	--get string information from the calling addon and insert it into our string table
	local function addStrings(lang, strings)
		for key, string in pairs(strings) do
			AF.strings[key] = string
		end
	end
	addStrings("en", filterInformation.enStrings)
	if filterInformation.deStrings ~= nil then addStrings("de", filterInformation.deStrings) end
	if filterInformation.frStrings ~= nil then addStrings("fr", filterInformation.frStrings) end
	if filterInformation.ruStrings ~= nil then addStrings("ru", filterInformation.ruStrings) end
	if filterInformation.esStrings ~= nil then addStrings("es", filterInformation.esStrings) end
end
