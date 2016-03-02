local function GetFilterCallbackForWeaponType(filterTypes)
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

local function GetFilterCallbackForArmorType(filterTypes)
	return function(slot)
		local itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		local armorType = GetItemLinkArmorType(itemLink)
		for i=1, #filterTypes do
			if(filterTypes[i] == armorType) then
				return true
			end
		end
	end
end

local function GetFilterCallbackForGear(filterTypes)
	return function(slot)
		local result = false
		for i=1, #filterTypes do
			local _,_,_,_,_,equipType = GetItemInfo(slot.bagId, slot.slotIndex)
			result = result or (filterTypes[i] == equipType)
		end
		return result
	end
end

local function GetFilterCallbackForClothing()
	return function(slot)
		local itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		local armorType = GetItemLinkArmorType(itemLink)
		local _,_,_,_,_,equipType = GetItemInfo(slot.bagId, slot.slotIndex)
		if((ARMORTYPE_NONE == armorType) and
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
		local result = false
		for i=1, #filterTypes do
			local _,_,runeType = GetItemCraftingInfo(slot.bagId, slot.slotIndex)
			result = result or (filterTypes[i] == runeType)
		end
		return result
	end
end

local function GetFilterCallbackForAlchemy(filterTypes)
	return function(slot)
		return filterTypes[1] == GetItemType(slot.bagId, slot.slotIndex)
	end
end

local function GetFilterCallbackForTrophy()
	return function(slot)
		local itemType = GetItemType(slot.bagId, slot.slotIndex)

		if not slot.stolen and (itemType == ITEMTYPE_TROPHY
		  or itemType == ITEMTYPE_COLLECTIBLE or itemType == ITEMTYPE_FISH
		  or itemType == ITEMTYPE_TREASURE) then
			return true
		end

		return false
	end
end

local function GetFilterCallbackForFence()
	return function(slot)
		if slot.stolen and not (itemType == ITEMTYPE_GLYPH_ARMOR
		  or itemType == ITEMTYPE_GLYPH_JEWELRY
		  or itemType == ITEMTYPE_GLYPH_WEAPON or itemType == ITEMTYPE_SOUL_GEM
		  or itemType == ITEMTYPE_SIEGE or itemType == ITEMTYPE_LURE
		  or itemType == ITEMTYPE_TOOL or itemType == ITEMTYPE_TRASH) then
			return true
		end

		return false
	end
end

local function GetFilterCallback(filterTypes)
	if(not filterTypes) then return function(slot) return true end end

	return function( slot )
		local result = false
		for i=1, #filterTypes do
			result = result or (filterTypes[i] == GetItemType(slot.bagId, slot.slotIndex))
		end
		return result
	end
end

local masterSubfilterData = {
	["All"] = {
		dropdownCallbacks = {
			[1] = {name = "All", filterCallback = GetFilterCallback(nil)},
		},
	},
	["Weapons"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			icon = AF_TextureMap.ALL,
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
		["OneHand"] = {
			icon = AF_TextureMap.ONEHAND,
			filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_AXE, WEAPONTYPE_HAMMER, WEAPONTYPE_SWORD, WEAPONTYPE_DAGGER}),
			dropdownCallbacks = {
				[1] = {name = "Axe", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_AXE})},
			    [2] = {name = "Hammer", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_HAMMER})},
			    [3] = {name = "Sword", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_SWORD})},
			    [4] = {name = "Dagger", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_DAGGER})},
			},
		},
		["TwoHand"] = {
			icon = AF_TextureMap.TWOHAND,
			filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_AXE, WEAPONTYPE_TWO_HANDED_HAMMER, WEAPONTYPE_TWO_HANDED_SWORD}),
			dropdownCallbacks = {
				[1] = {name = "2HAxe", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_AXE})},
				[2] = {name = "2HHammer", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_HAMMER})},
				[3] = {name = "2HSword", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_SWORD})},
			},
		},
		["Bow"] = {
			icon = AF_TextureMap.BOW,
			filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_BOW}),
			dropdownCallbacks = {},
		},
		["DestructionStaff"] = {
			icon = AF_TextureMap.DESTRUCTIONSTAFF,
			filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_FIRE_STAFF, WEAPONTYPE_FROST_STAFF, WEAPONTYPE_LIGHTNING_STAFF}),
			dropdownCallbacks = {
				[1] = {name = "Fire", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_FIRE_STAFF})},
				[2] = {name = "Frost", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_FROST_STAFF})},
				[3] = {name = "Lightning", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_LIGHTNING_STAFF})},
			},
		},
		["HealStaff"] = {
			icon = AF_TextureMap.HEALSTAFF,
			filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_HEALING_STAFF}),
			dropdownCallbacks = {},
		},
	},
	["Armor"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			icon = AF_TextureMap.ALL,
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
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
			icon = AF_TextureMap.SHIELD,
			filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_OFF_HAND}),
			dropdownCallbacks = {},
		},
		["Jewelry"] = {
			icon = AF_TextureMap.JEWELRY,
			filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_RING, EQUIP_TYPE_NECK}),
			dropdownCallbacks = {
				[1] = {name = "Ring", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_RING})},
				[2] = {name = "Neck", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_NECK})},
			},
		},
		["Vanity"] = {
			icon = AF_TextureMap.VANITY,
			filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_DISGUISE, EQUIP_TYPE_COSTUME}),
			dropdownCallbacks = {},
		},
	},
	["Consumables"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			icon = AF_TextureMap.ALL,
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
		["Crown"] = {
			icon = AF_TextureMap.CROWN,
			filterCallback = GetFilterCallback({ITEMTYPE_CROWN_ITEM}),
			dropdownCallbacks = {},
		},
		["Food"] = {
			icon = AF_TextureMap.FOOD,
			filterCallback = GetFilterCallback({ITEMTYPE_FOOD}),
			dropdownCallbacks = {},
		},
		["Drink"] = {
			icon = AF_TextureMap.DRINK,
			filterCallback = GetFilterCallback({ITEMTYPE_DRINK}),
			dropdownCallbacks = {},
		},
		["Recipe"] = {
			icon = AF_TextureMap.RECIPE,
			filterCallback = GetFilterCallback({ITEMTYPE_RECIPE}),
			dropdownCallbacks = {},
		},
		["Potion"] = {
			icon = AF_TextureMap.POTION,
			filterCallback = GetFilterCallback({ITEMTYPE_POTION}),
			dropdownCallbacks = {},
		},
		["Poison"] = {
			icon = AF_TextureMap.POISON,
			filterCallback = GetFilterCallback({ITEMTYPE_POISON}),
			dropdownCallbacks = {},
		},
		["Motif"] = {
			icon = AF_TextureMap.MOTIF,
			filterCallback = GetFilterCallback({ITEMTYPE_RACIAL_STYLE_MOTIF}),
			dropdownCallbacks = {},
		},
		["Container"] = {
			icon = AF_TextureMap.CONTAINER,
			filterCallback = GetFilterCallback({ITEMTYPE_CONTAINER}),
			dropdownCallbacks = {},
		},
		["Repair"] = {
			icon = AF_TextureMap.REPAIR,
			filterCallback = GetFilterCallback({ITEMTYPE_AVA_REPAIR, ITEMTYPE_TOOL, ITEMTYPE_CROWN_REPAIR}),
			dropdownCallbacks = {},
		},
		["Trophy"] = {
			icon = AF_TextureMap.TROPHY,
			filterCallback = GetFilterCallbackForTrophy(),
			dropdownCallbacks = {},
		},
	},
	["Crafting"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			icon = AF_TextureMap.ALL,
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
		["Blacksmithing"] = {
			icon = AF_TextureMap.BLACKSMITHING,
			filterCallback = GetFilterCallback({ITEMTYPE_BLACKSMITHING_MATERIAL, ITEMTYPE_BLACKSMITHING_RAW_MATERIAL, ITEMTYPE_BLACKSMITHING_BOOSTER}),
			dropdownCallbacks = {},
		},
		["Clothier"] = {
			icon = AF_TextureMap.CLOTHIER,
			filterCallback = GetFilterCallback({ITEMTYPE_CLOTHIER_MATERIAL, ITEMTYPE_CLOTHIER_RAW_MATERIAL, ITEMTYPE_CLOTHIER_BOOSTER}),
			dropdownCallbacks = {},
		},
		["Woodworking"] = {
			icon = AF_TextureMap.WOODWORKING,
			filterCallback = GetFilterCallback({ITEMTYPE_WOODWORKING_MATERIAL, ITEMTYPE_WOODWORKING_RAW_MATERIAL, ITEMTYPE_WOODWORKING_BOOSTER}),
			dropdownCallbacks = {},
		},
		["Alchemy"] = {
			icon = AF_TextureMap.ALCHEMY,
			filterCallback = GetFilterCallback({ITEMTYPE_REAGENT, ITEMTYPE_ALCHEMY_BASE}),
			dropdownCallbacks = {
				[1] = {name = "Reagent", filterCallback = GetFilterCallbackForAlchemy({ITEMTYPE_REAGENT})},
				[2] = {name = "Solvent", filterCallback = GetFilterCallbackForAlchemy({ITEMTYPE_ALCHEMY_BASE})},
			},
		},
		["Enchanting"] = {
			icon = AF_TextureMap.ENCHANTING,
			filterCallback = GetFilterCallback({ITEMTYPE_ENCHANTING_RUNE_ASPECT, ITEMTYPE_ENCHANTING_RUNE_ESSENCE, ITEMTYPE_ENCHANTING_RUNE_POTENCY}),
			dropdownCallbacks = {
				[1] = {name = "Aspect", filterCallback = GetFilterCallbackForEnchanting({ENCHANTING_RUNE_ASPECT})},
				[2] = {name = "Essence", filterCallback = GetFilterCallbackForEnchanting({ENCHANTING_RUNE_ESSENCE})},
				[3] = {name = "Potency", filterCallback = GetFilterCallbackForEnchanting({ENCHANTING_RUNE_POTENCY})},
			},
		},
		["Provisioning"] = {
			icon = AF_TextureMap.PROVISIONING,
			filterCallback = GetFilterCallback({ITEMTYPE_INGREDIENT}),
			dropdownCallbacks = {},
		},
		["Style"] = {
			icon = AF_TextureMap.STYLE,
			filterCallback = GetFilterCallback({ITEMTYPE_STYLE_MATERIAL, ITEMTYPE_RAW_MATERIAL}),
			dropdownCallbacks = {},
		},
		["WeaponTrait"] = {
			icon = AF_TextureMap.WTRAIT,
			filterCallback = GetFilterCallback({ITEMTYPE_WEAPON_TRAIT}),
			dropdownCallbacks = {},
		},
		["ArmorTrait"] = {
			icon = AF_TextureMap.ATRAIT,
			filterCallback = GetFilterCallback({ITEMTYPE_ARMOR_TRAIT}),
			dropdownCallbacks = {},
		},
	},
	["Miscellaneous"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			icon = AF_TextureMap.ALL,
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
		["Glyphs"] = {
			icon = AF_TextureMap.GLYPHS,
			filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_ARMOR, ITEMTYPE_GLYPH_JEWELRY, ITEMTYPE_GLYPH_WEAPON}),
			dropdownCallbacks = {
				[1] = {name = "ArmorGlyph", filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_ARMOR})},
				[2] = {name = "JewelryGlyph", filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_JEWELRY})},
				[3] = {name = "WeaponGlyph", filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_WEAPON})},
			},
		},
		["SoulGem"] = {
			icon = AF_TextureMap.SOULGEM,
			filterCallback = GetFilterCallback({ITEMTYPE_SOUL_GEM}),
			dropdownCallbacks = {},
		},
		["Siege"] = {
			icon = AF_TextureMap.AVAWEAPON,
			filterCallback = GetFilterCallback({ITEMTYPE_SIEGE}),
			dropdownCallbacks = {},
		},
		["Bait"] = {
			icon = AF_TextureMap.BAIT,
			filterCallback = GetFilterCallback({ITEMTYPE_LURE}),
			dropdownCallbacks = {},
		},
		["Tool"] = {
			icon = AF_TextureMap.TOOL,
			filterCallback = GetFilterCallback({ITEMTYPE_TOOL}),
			dropdownCallbacks = {},
		},
		["Trophy"] = {
			icon = AF_TextureMap.TROPHY,
			filterCallback = GetFilterCallbackForTrophy(),
			dropdownCallbacks = {},
		},
		["Fence"] = {
			icon = AF_TextureMap.FENCE,
			filterCallback = GetFilterCallbackForFence(),
			dropdownCallbacks = {},
		},
		["Trash"] = {
			icon = AF_TextureMap.TRASH,
			filterCallback = GetFilterCallback({ITEMTYPE_TRASH}),
			dropdownCallbacks = {},
		},
	},
}

local function BuildCallbackTable(groupName, subfilterName)
	local callbackTable = {}
	local keys = {
		["Weapons"] = {
			[1] = "All",
			[2] = "OneHand",
			[3] = "TwoHand",
			[4] = "Bow",
			[5] = "DestructionStaff",
			[6] = "HealStaff",
		},
		["Armor"] = {
			[1] = "All",
			[2] = "Body",
			[3] = "Shield",
			[4] = "Jewelry",
			[5] = "Vanity",
		},
		["Consumables"] = {
			[1] = "All",
			[2] = "Crown",
			[3] = "Food",
			[4] = "Drink",
			[5] = "Recipe",
			[6] = "Potion",
			[7] = "Poison",
			[8] = "Motif",
			[9] = "Container",
			[10] = "Repair",
			[11] = "Trophy",
		},
		["Crafting"] = {
			[1] = "All",
			[2] = "Blacksmithing",
			[3] = "Clothier",
			[4] = "Woodworking",
			[5] = "Alchemy",
			[6] = "Enchanting",
			[7] = "Provisioning",
			[8] = "Style",
			[9] = "WeaponTrait",
			[10] = "ArmorTrait",
		},
		["Miscellaneous"] = {
			[1] = "All",
			[2] = "Glyphs",
			[3] = "SoulGem",
			[4] = "Siege",
			[5] = "Bait",
			[6] = "Tool",
			[7] = "Trophy",
			[8] = "Fence",
			[9] = "Trash",
		},
	}

	-- insert global "All" filters
	for _, callbackEntry in ipairs(masterSubfilterData["All"].dropdownCallbacks) do
		table.insert(callbackTable, callbackEntry)
	end

	if subfilterName == "All" then
		--insert all default filters for each subfilter
		for _, subfilterName in ipairs(keys[groupName]) do
			local currentSubfilterTable = masterSubfilterData[groupName][subfilterName]

			for _, callbackEntry in ipairs(currentSubfilterTable.dropdownCallbacks) do
				table.insert(callbackTable, callbackEntry)
			end
		end

		--insert all filters provided by addons
		for _, addonTable in ipairs(masterSubfilterData[groupName].addonDropdownCallbacks) do
			--check to see if addon is set up for a submenu
			if addonTable.submenuName then
				--insert whole package
				table.insert(callbackTable, addonTable)
			else
				--insert all callbackTable entries
				local currentAddonTable = addonTable.callbackTable

				for _, callbackEntry in ipairs(currentAddonTable) do
					table.insert(callbackTable, callbackEntry)
				end
			end
		end
	else
		--insert filters for provided subfilter
		local currentSubfilterTable = masterSubfilterData[groupName][subfilterName]
		for _, callbackEntry in ipairs(currentSubfilterTable.dropdownCallbacks) do
			table.insert(callbackTable, callbackEntry)
		end

		--insert filters provided by addons for this subfilter
		for _, addonTable in ipairs(masterSubfilterData[groupName].addonDropdownCallbacks) do
			--scan addon to see if it applies to given subfilter
			for _, subfilter in ipairs(addonTable.subfilters) do
				if subfilter == subfilterName or subfilter == "All" then
					--add addon filters
					--check to see if addon is set up for a submenu
					if addonTable.submenuName then
						--insert whole package
						table.insert(callbackTable, addonTable)
					else
						--insert all callbackTable entries
						local currentAddonTable = addonTable.callbackTable

						for _, callbackEntry in ipairs(currentAddonTable) do
							table.insert(callbackTable, callbackEntry)
						end
					end
				end
			end
		end
	end

	return callbackTable
end

function AdvancedFilters_GetSubfilterData(groupName, subfilterName)
	local armorSubfilters = {
		["Heavy"] = {
			icon = AF_TextureMap.HEAVY,
			filterCallback = GetFilterCallbackForArmorType({ARMORTYPE_HEAVY}),
		},
		["Medium"] = {
			icon = AF_TextureMap.MEDIUM,
			filterCallback = GetFilterCallbackForArmorType({ARMORTYPE_MEDIUM}),
		},
		["Light"] = {
			icon = AF_TextureMap.LIGHT,
			filterCallback = GetFilterCallbackForArmorType({ARMORTYPE_LIGHT}),
		},
		["Clothing"] = {
			icon = AF_TextureMap.CLOTHING,
			filterCallback = GetFilterCallbackForClothing(),
		},
	}
	local subfilterData

	if armorSubfilters[subfilterName] then
		subfilterData = ZO_ShallowTableCopy(armorSubfilters[subfilterName])
		subfilterData.dropdownCallbacks = BuildCallbackTable(groupName, "Body")
	else
		subfilterData = ZO_ShallowTableCopy(masterSubfilterData[groupName][subfilterName])
		subfilterData.dropdownCallbacks = BuildCallbackTable(groupName, subfilterName)
	end

	return subfilterData
end

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
		table.insert(masterSubfilterData["Weapons"].addonDropdownCallbacks, addonInformation)
		table.insert(masterSubfilterData["Armor"].addonDropdownCallbacks, addonInformation)
		table.insert(masterSubfilterData["Consumables"].addonDropdownCallbacks, addonInformation)
		table.insert(masterSubfilterData["Crafting"].addonDropdownCallbacks, addonInformation)
		table.insert(masterSubfilterData["Miscellaneous"].addonDropdownCallbacks, addonInformation)
	else
		table.insert(masterSubfilterData[groupName].addonDropdownCallbacks, addonInformation)
	end

	--get string information from the calling addon and insert it into our string table
	local function addStrings(lang, strings)
		for key, string in pairs(strings) do
			AF_Strings[lang][key] = string
		end
	end
	addStrings("en", filterInformation.enStrings)
	if filterInformation.deStrings ~= nil then addStrings("de", filterInformation.deStrings) end
	if filterInformation.frStrings ~= nil then addStrings("fr", filterInformation.frStrings) end
	if filterInformation.ruStrings ~= nil then addStrings("ru", filterInformation.ruStrings) end
	if filterInformation.esStrings ~= nil then addStrings("es", filterInformation.esStrings) end
end
