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

		local itemType = GetItemLinkItemType(itemLink)
		if itemType ~= ITEMTYPE_ENCHANTING_RUNE_ASPECT
		  or itemType ~= ITEMTYPE_ENCHANTING_RUNE_ESSENCE
		  or itemType ~= ITEMTYPE_ENCHANTING_RUNE_POTENCY then
			return
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

local function GetFilterCallbackForProvisioningIngredient(ingredientType)
	return function(slot)
		local lookup = {
			--meats (health)
			["28609"] = "Food", --Game
		    ["33752"] = "Food", --Red Meat
			["33753"] = "Food", --Fish
			["33754"] = "Food", --White Meat
			["33756"] = "Food", --Small Game
			["34321"] = "Food", --Poultry
			--fruits (magicka)
			["28603"] = "Food", --Tomato
			["28610"] = "Food", --Jazbay Grapes
			["33755"] = "Food", --Bananas
			["34308"] = "Food", --Melon
			["34311"] = "Food", --Apples
			["34305"] = "Food", --Pumpkin
			--vegetables (stamina)
			["28604"] = "Food", --Greens
			["33758"] = "Food", --Potato
			["34307"] = "Food", --Radish
			["34309"] = "Food", --Beets
			["34323"] = "Food", --Corn
			["34324"] = "Food", --Carrots
			--dish additives
			["26954"] = "Food", --Garlic
			["27057"] = "Food", --Cheese
			["27058"] = "Food", --Seasoning
			["27063"] = "Food", --Saltrice
			["27064"] = "Food", --Millet
			["27100"] = "Food", --Flour
			--rare dish additive
			["26802"] = "Food", --Frost Mirriam
			--alcoholic (health)
			["28639"] = "Drink", --Rye
			["29030"] = "Drink", --Rice
			["33774"] = "Drink", --Yeast
			["34329"] = "Drink", --Barley
			["34345"] = "Drink", --Surilie Grapes
			["34348"] = "Drink", --Wheat
			--tea (magicka)
			["28636"] = "Drink", --Rose
			["33768"] = "Drink", --Comberry
			["33771"] = "Drink", --Jasmine
			["33773"] = "Drink", --Mint
			["34330"] = "Drink", --Lotus
			["34334"] = "Drink", --Bittergreen
			--tonic (stamina)
			["33772"] = "Drink", --Coffee
			["34333"] = "Drink", --Guarana
			["34335"] = "Drink", --Yerba Mate
			["34346"] = "Drink", --Gingko
			["34347"] = "Drink", --Ginseng
			["34349"] = "Drink", --Acai Berry
			--drink additives
			["27035"] = "Drink", --Isinglass
			["27043"] = "Drink", --Honey
			["27048"] = "Drink", --Metheglin
			["27049"] = "Drink", --Lemon
			["27052"] = "Drink", --Ginger
			["28666"] = "Drink", --Seaweed
			--rare drink additive
			["27059"] = "Drink", --Bervez Juice
			--old ingredients
			["26962"] = "Old", --Old Pepper
			["26966"] = "Old", --Old Drippings
			["26974"] = "Old", --Old Cooking Fat
			["26975"] = "Old", --Old Suet
			["26976"] = "Old", --Old Lard
			["26977"] = "Old", --Old Fatback
			["26978"] = "Old", --Old Pinguis
			["26986"] = "Old", --Old Thin Broth
			["26987"] = "Old", --Old Broth
			["26988"] = "Old", --Old Stock
			["26989"] = "Old", --Old Jus
			["26990"] = "Old", --Old Glace Viande
			["26998"] = "Old", --Old Imperial Stock
			["26999"] = "Old", --Old Meal
			["27000"] = "Old", --Old Milled Flour
			["27001"] = "Old", --Old Sifted Flour
			["27002"] = "Old", --Old Cake Flour
			["27003"] = "Old", --Old Baker's Flour
			["27004"] = "Old", --Old Imperial Flour
			["27044"] = "Old", --Old Saaz Hops
			["27051"] = "Old", --Old Jazbay Grapes
			["27053"] = "Old", --Old Canis Root
			["28605"] = "Old", --Old Scuttle Meat
			["28606"] = "Old", --Old Plump Worms^p
			["28607"] = "Old", --Old Plump Rodent Toes^p
			["28608"] = "Old", --Old Plump Maggots^p
			["28632"] = "Old", --Old Snake Slime
			["28634"] = "Old", --Old Snake Venom
			["28635"] = "Old", --Old Wild Honey
			["28637"] = "Old", --Old Sujamma Berries^P
			["28638"] = "Old", --Old River Grapes^p
			["33757"] = "Old", --Old Venison
			["33767"] = "Old", --Old Shornhelm Grains^p
			["33769"] = "Old", --Old Tangerine
			["33770"] = "Old", --Old Wasp Squeezings
			["34304"] = "Old", --Old Pork
			["34306"] = "Old", --Old Sweetmeats^p
			["34312"] = "Old", --Old Saltrice
			["34322"] = "Old", --Old Shank
			["34331"] = "Old", --Old Ripe Apple
			["34332"] = "Old", --Old Wisp Floss
			["34336"] = "Old", --Old Spring Essence
			["40260"] = "Old", --Old Brown Malt
			["40261"] = "Old", --Old Amber Malt
			["40262"] = "Old", --Old Caramalt
			["40263"] = "Old", --Old Wheat Malt
			["40264"] = "Old", --Old White Malt
			["40265"] = "Old", --Old Wine Grapes^p
			["40266"] = "Old", --Old Grasa Grapes^p
			["40267"] = "Old", --Old Lado Grapes^p
			["40268"] = "Old", --Old Camaralet Grapes^p
			["40269"] = "Old", --Old Ribier Grapes^p
			["40270"] = "Old", --Old Corn Mash
			["40271"] = "Old", --Old Wheat Mash
			["40272"] = "Old", --Old Oat Mash
			["40273"] = "Old", --Old Barley Mash
			["40274"] = "Old", --Old Rice Mash
			["40276"] = "Old", --Old Mutton Flank
			["45522"] = "Old", --Old Golden Malt
			["45523"] = "Old", --Old Emperor Grapes^p
			["45524"] = "Old", --Old Imperial Mash
		}
		local itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		local itemId = select(4, ZO_LinkHandler_ParseLink(itemLink))

		if GetItemLinkItemType(itemLink) ~= ITEMTYPE_INGREDIENT then return false end
		if lookup[itemId] == ingredientType then return true end
		return false
	end
end

local function GetFilterCallbackForStyleMaterial(categoryConst)
	return function(slot)
		local itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		
		if categoryConst == AF.util.LibMotifCategories:GetCategory(itemLink) then
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
			dropdownCallbacks = {
				[1] = {name = "FoodIngredient", filterCallback = GetFilterCallbackForProvisioningIngredient("Food")},
				[2] = {name = "DrinkIngredient", filterCallback = GetFilterCallbackForProvisioningIngredient("Drink")},
				[3] = {name = "OldIngredient", filterCallback = GetFilterCallbackForProvisioningIngredient("Old")},
			},
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
	["Blacksmithing"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
	},
	["Clothing"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
	},
	["Woodworking"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
	},
	["Alchemy"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
	},
	["Enchanting"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
	},
	["Provisioning"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
	},
	["Style"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			filterCallback = GetFilterCallback(nil),
			dropdownCallbacks = {},
		},
	},
	["Traits"] = {
		addonDropdownCallbacks = {},
		["All"] = {
			filterCallback = GetFilterCallback(nil),
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
}

if INVENTORY_CRAFT_BAG then
	AF.subfilterCallbacks.Crafting["Alchemy"] = {
		filterCallback = GetFilterCallback({ITEMTYPE_REAGENT, ITEMTYPE_POTION_BASE, ITEMTYPE_POISON_BASE}),
		dropdownCallbacks = {
			[1] = {name = "Reagent", filterCallback = GetFilterCallback({ITEMTYPE_REAGENT})},
			[2] = {name = "Water", filterCallback = GetFilterCallback({ITEMTYPE_POTION_BASE})},
			[3] = {name = "Oil", filterCallback = GetFilterCallback({ITEMTYPE_POISON_BASE})},
		},
	}
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
	local lang = AF.util.GetLanguage()
	if filterInformation[lang .. "Strings"] ~= nil then
		addStrings(lang, filterInformation[lang .. "Strings"])
	else
		addStrings("en", filterInformation.enStrings)
	end
end
