--[[----------------------------------------------------------------------------
    The anonymous function returned by this function handles the actual
		filtering.
	Use whatever parameters for "GetFilterCallback..." and whatever logic you
		need to in "function(slot)".
	"slot" is a table of item data. A typical slot can be found in
		PLAYER_INVENTORY.inventories[bagId].slots[slotIndex]
	A return value of true means the item in question will be shown while the
		filter is active. False means the item will be hidden while the filter
		is active.
--]]----------------------------------------------------------------------------
local function GetFilterCallbackForIngredientType(ingredientType)
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

--[[----------------------------------------------------------------------------
    This table is processed within Advanced Filters and its contents are added
		to Advanced Filters'  master callback table.
	The string value for name is the relevant key for the language table.
--]]----------------------------------------------------------------------------
local provisioningIngredientTypeDropdownCallbacks = {
	[1] = {name = "SC.Food", filterCallback = GetFilterCallbackForIngredientType("Food")},
	[2] = {name = "SC.Drink", filterCallback = GetFilterCallbackForIngredientType("Drink")},
	[3] = {name = "SC.Old", filterCallback = GetFilterCallbackForIngredientType("Old")},
}

--[[----------------------------------------------------------------------------
    There are five potential tables for this section each covering either
		English, German, French, Russian, or Spanish. Only English is required.
	If other language tables are not included, the English table will
		automatically be used for those languages.
	All languages must share common keys.
--]]----------------------------------------------------------------------------
local strings = {
	["SC.Food"] = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT),
					GetString("SI_ITEMTYPE", ITEMTYPE_FOOD)),
	["SC.Drink"] = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT),
					GetString("SI_ITEMTYPE", ITEMTYPE_DRINK)),
	["SC.Old"] = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT),
					GetString("SI_ITEMTYPE", ITEMTYPE_NONE)),
}

--[[----------------------------------------------------------------------------
    This section packages the data for Advanced Filters to use.
    All keys are required except for deStrings, frStrings, ruStrings, and
	    esStrings as they correspond to optional languages. All language keys
		are assigned the same table here only to demonstrate the key names. You
		do not need to do this.
    The filterType key expects an ITEMFILTERTYPE constant provided by the game.
    The values for key/value pairs in the "subfilters" table can be any of the
		string keys from the "masterSubfilterData" table in data.lua such as
		"All", "OneHanded", "Body", or "Blacksmithing".
    If your filterType is ITEMFILTERTYPE_ALL then the "subfilters" table must
		only contain the value "All".
--]]----------------------------------------------------------------------------
local filterInformation = {
	callbackTable = provisioningIngredientTypeDropdownCallbacks,
	filterType = ITEMFILTERTYPE_CRAFTING,
	subfilters = {
		[1] = "Provisioning",
	},
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
