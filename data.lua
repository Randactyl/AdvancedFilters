local AF = AdvancedFilters
local util = AF.util

local function GetFilterCallbackForWeaponType(filterTypes)
    return function(slot)
        local itemLink = util.GetItemLink(slot)

        local weaponType = GetItemLinkWeaponType(itemLink)

        for i=1, #filterTypes do
            if(filterTypes[i] == weaponType) then return true end
        end
    end
end

local function GetFilterCallbackForArmorType(filterTypes)
    return function(slot)
        local itemLink = util.GetItemLink(slot)

        local armorType = GetItemLinkArmorType(itemLink)

        for i=1, #filterTypes do
            if(filterTypes[i] == armorType) then return true end
        end
    end
end

local function GetFilterCallbackForGear(filterTypes)
    return function(slot)
        local itemLink = util.GetItemLink(slot)

        local _, _, _, equipType = GetItemLinkInfo(itemLink)

        for i=1, #filterTypes do
            if filterTypes[i] == equipType then return true end
        end
    end
end

local function GetFilterCallbackForClothing()
    return function(slot)
        local itemLink = util.GetItemLink(slot)

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

local function GetFilterCallbackForTrophy()
    return function(slot)
        local itemLink = util.GetItemLink(slot)

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
        local itemLink = util.GetItemLink(slot)

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
        local itemLink = util.GetItemLink(slot)
        local itemId = select(4, ZO_LinkHandler_ParseLink(itemLink))

        if GetItemLinkItemType(itemLink) ~= ITEMTYPE_INGREDIENT then return false end
        if lookup[itemId] == ingredientType then return true end
        return false
    end
end

local function GetFilterCallbackForStyleMaterial(categoryConst)
    return function(slot)
        local itemLink = util.GetItemLink(slot)

        if categoryConst == AF.util.LibMotifCategories:GetMotifCategory(itemLink) then
            return true
        end
    end
end

local function GetFilterCallbackForSpecializedItemtype(sItemTypes)
    if(not sItemTypes) then return function(slot) return true end end

    return function(slot)
        local itemLink = util.GetItemLink(slot)

        local _, sItemType = GetItemLinkItemType(itemLink)

        for i = 1, #sItemTypes do
            if sItemTypes[i] == sItemType then return true end
        end
    end
end

local function GetFilterCallback(filterTypes)
    if(not filterTypes) then return function(slot) return true end end

    return function(slot)
        local itemLink = util.GetItemLink(slot)

        local itemType = GetItemLinkItemType(itemLink)

        for i=1, #filterTypes do
            if filterTypes[i] == itemType then return true end
        end
    end
end

AF.subfilterCallbacks = {
    All = {
        addonDropdownCallbacks = {},
        dropdownCallbacks = {
            {name = "All", filterCallback = GetFilterCallback(nil)},
        },
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
    },
    Weapons = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        OneHand = {
            filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_AXE, WEAPONTYPE_HAMMER, WEAPONTYPE_SWORD, WEAPONTYPE_DAGGER}),
            dropdownCallbacks = {
                {name = "Axe", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_AXE})},
                {name = "Hammer", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_HAMMER})},
                {name = "Sword", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_SWORD})},
                {name = "Dagger", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_DAGGER})},
            },
        },
        TwoHand = {
            filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_AXE, WEAPONTYPE_TWO_HANDED_HAMMER, WEAPONTYPE_TWO_HANDED_SWORD}),
            dropdownCallbacks = {
                {name = "2HAxe", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_AXE})},
                {name = "2HHammer", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_HAMMER})},
                {name = "2HSword", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_SWORD})},
            },
        },
        Bow = {
            filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_BOW}),
            dropdownCallbacks = {},
        },
        DestructionStaff = {
            filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_FIRE_STAFF, WEAPONTYPE_FROST_STAFF, WEAPONTYPE_LIGHTNING_STAFF}),
            dropdownCallbacks = {
                {name = "Fire", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_FIRE_STAFF})},
                {name = "Frost", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_FROST_STAFF})},
                {name = "Lightning", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_LIGHTNING_STAFF})},
            },
        },
        HealStaff = {
            filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_HEALING_STAFF}),
            dropdownCallbacks = {},
        },
    },
    Armor = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        Heavy = {
            filterCallback = GetFilterCallbackForArmorType({ARMORTYPE_HEAVY}),
        },
        Medium = {
            filterCallback = GetFilterCallbackForArmorType({ARMORTYPE_MEDIUM}),
        },
        LightArmor = {
            filterCallback = GetFilterCallbackForArmorType({ARMORTYPE_LIGHT}),
        },
        Clothing = {
            filterCallback = GetFilterCallbackForClothing(),
        },
        Body = {
            dropdownCallbacks = {
                {name = "Head", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_HEAD})},
                {name = "Chest", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_CHEST})},
                {name = "Shoulders", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_SHOULDERS})},
                {name = "Hand", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_HAND})},
                {name = "Waist", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_WAIST})},
                {name = "Legs", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_LEGS})},
                {name = "Feet", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_FEET})},
            },
        },
        Shield = {
            filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_OFF_HAND}),
            dropdownCallbacks = {},
        },
        Jewelry = {
            filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_RING, EQUIP_TYPE_NECK}),
            dropdownCallbacks = {
                {name = "Ring", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_RING})},
                {name = "Neck", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_NECK})},
            },
        },
        Vanity = {
            filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_DISGUISE, EQUIP_TYPE_COSTUME}),
            dropdownCallbacks = {},
        },
    },
    Consumables = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        Crown = {
            filterCallback = GetFilterCallback({ITEMTYPE_CROWN_ITEM}),
            dropdownCallbacks = {},
        },
        Food = {
            filterCallback = GetFilterCallback({ITEMTYPE_FOOD}),
            dropdownCallbacks = {},
        },
        Drink = {
            filterCallback = GetFilterCallback({ITEMTYPE_DRINK}),
            dropdownCallbacks = {},
        },
        Recipe = {
            filterCallback = GetFilterCallback({ITEMTYPE_RECIPE}),
            dropdownCallbacks = {},
        },
        Potion = {
            filterCallback = GetFilterCallback({ITEMTYPE_POTION}),
            dropdownCallbacks = {},
        },
        Poison = {
            filterCallback = GetFilterCallback({ITEMTYPE_POISON}),
            dropdownCallbacks = {},
        },
        Motif = {
            filterCallback = GetFilterCallback({ITEMTYPE_RACIAL_STYLE_MOTIF}),
            dropdownCallbacks = {},
        },
        Writ = {
            filterCallback = GetFilterCallback({ITEMTYPE_MASTER_WRIT}),
            dropdownCallbacks = {},
        },
        Container = {
            filterCallback = GetFilterCallback({ITEMTYPE_CONTAINER}),
            dropdownCallbacks = {},
        },
        Repair = {
            filterCallback = GetFilterCallback({ITEMTYPE_AVA_REPAIR, ITEMTYPE_TOOL, ITEMTYPE_CROWN_REPAIR}),
            dropdownCallbacks = {},
        },
        Trophy = {
            filterCallback = GetFilterCallbackForTrophy(),
            dropdownCallbacks = {},
        },
    },
    Crafting = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        Blacksmithing = {
            filterCallback = GetFilterCallback({ITEMTYPE_BLACKSMITHING_MATERIAL, ITEMTYPE_BLACKSMITHING_RAW_MATERIAL, ITEMTYPE_BLACKSMITHING_BOOSTER}),
            dropdownCallbacks = {},
        },
        Clothier = {
            filterCallback = GetFilterCallback({ITEMTYPE_CLOTHIER_MATERIAL, ITEMTYPE_CLOTHIER_RAW_MATERIAL, ITEMTYPE_CLOTHIER_BOOSTER}),
            dropdownCallbacks = {},
        },
        Woodworking = {
            filterCallback = GetFilterCallback({ITEMTYPE_WOODWORKING_MATERIAL, ITEMTYPE_WOODWORKING_RAW_MATERIAL, ITEMTYPE_WOODWORKING_BOOSTER}),
            dropdownCallbacks = {},
        },
        Alchemy = {
            filterCallback = GetFilterCallback({ITEMTYPE_REAGENT, ITEMTYPE_POTION_BASE, ITEMTYPE_POISON_BASE}),
            dropdownCallbacks = {
                {name = "Reagent", filterCallback = GetFilterCallback({ITEMTYPE_REAGENT})},
                {name = "Water", filterCallback = GetFilterCallback({ITEMTYPE_POTION_BASE})},
                {name = "Oil", filterCallback = GetFilterCallback({ITEMTYPE_POISON_BASE})},
            },
        },
        Enchanting = {
            filterCallback = GetFilterCallback({ITEMTYPE_ENCHANTING_RUNE_ASPECT, ITEMTYPE_ENCHANTING_RUNE_ESSENCE, ITEMTYPE_ENCHANTING_RUNE_POTENCY}),
            dropdownCallbacks = {
                {name = "Aspect", filterCallback = GetFilterCallback({ITEMTYPE_ENCHANTING_RUNE_ASPECT})},
                {name = "Essence", filterCallback = GetFilterCallback({ITEMTYPE_ENCHANTING_RUNE_ESSENCE})},
                {name = "Potency", filterCallback = GetFilterCallback({ITEMTYPE_ENCHANTING_RUNE_POTENCY})},
            },
        },
        Provisioning = {
            filterCallback = GetFilterCallback({ITEMTYPE_INGREDIENT}),
            dropdownCallbacks = {
                {name = "FoodIngredient", filterCallback = GetFilterCallbackForProvisioningIngredient("Food")},
                {name = "DrinkIngredient", filterCallback = GetFilterCallbackForProvisioningIngredient("Drink")},
                {name = "OldIngredient", filterCallback = GetFilterCallbackForProvisioningIngredient("Old")},
                {name = "RareIngredient", filterCallback = GetFilterCallbackForSpecializedItemtype({SPECIALIZED_ITEMTYPE_INGREDIENT_RARE})},
            },
        },
        Style = {
            filterCallback = GetFilterCallback({ITEMTYPE_STYLE_MATERIAL, ITEMTYPE_RAW_MATERIAL}),
            dropdownCallbacks = {
                {name = "RawMaterial", filterCallback = GetFilterCallback({ITEMTYPE_RAW_MATERIAL})},
                {name = "NormalStyle", filterCallback = GetFilterCallbackForStyleMaterial(LMC_MOTIF_CATEGORY_NORMAL)},
                {name = "RareStyle", filterCallback = GetFilterCallbackForStyleMaterial(LMC_MOTIF_CATEGORY_RARE)},
                {name = "AllianceStyle", filterCallback = GetFilterCallbackForStyleMaterial(LMC_MOTIF_CATEGORY_ALLIANCE)},
                {name = "ExoticStyle", filterCallback = GetFilterCallbackForStyleMaterial(LMC_MOTIF_CATEGORY_EXOTIC)},
                {name = "CrownStyle", filterCallback = GetFilterCallbackForStyleMaterial(LMC_MOTIF_CATEGORY_CROWN)},
            },
        },
        WeaponTrait = {
            filterCallback = GetFilterCallback({ITEMTYPE_WEAPON_TRAIT}),
            dropdownCallbacks = {},
        },
        ArmorTrait = {
            filterCallback = GetFilterCallback({ITEMTYPE_ARMOR_TRAIT}),
            dropdownCallbacks = {},
        },
    },
    Furnishings = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        CraftingStation = {
            filterCallback = GetFilterCallbackForSpecializedItemtype({SPECIALIZED_ITEMTYPE_FURNISHING_CRAFTING_STATION}),
            dropdownCallbacks = {},
        },
        Light = {
            filterCallback = GetFilterCallbackForSpecializedItemtype({SPECIALIZED_ITEMTYPE_FURNISHING_LIGHT}),
            dropdownCallbacks = {},
        },
        Ornamental = {
            filterCallback = GetFilterCallbackForSpecializedItemtype({SPECIALIZED_ITEMTYPE_FURNISHING_ORNAMENTAL}),
            dropdownCallbacks = {},
        },
        Seating = {
            filterCallback = GetFilterCallbackForSpecializedItemtype({SPECIALIZED_ITEMTYPE_FURNISHING_SEATING}),
            dropdownCallbacks = {},
        },
        TargetDummy = {
            filterCallback = GetFilterCallbackForSpecializedItemtype({SPECIALIZED_ITEMTYPE_FURNISHING_TARGET_DUMMY}),
            dropdownCallbacks = {},
        },
    },
    Miscellaneous = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        Glyphs = {
            filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_ARMOR, ITEMTYPE_GLYPH_JEWELRY, ITEMTYPE_GLYPH_WEAPON}),
            dropdownCallbacks = {
                {name = "ArmorGlyph", filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_ARMOR})},
                {name = "JewelryGlyph", filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_JEWELRY})},
                {name = "WeaponGlyph", filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_WEAPON})},
            },
        },
        SoulGem = {
            filterCallback = GetFilterCallback({ITEMTYPE_SOUL_GEM}),
            dropdownCallbacks = {},
        },
        Siege = {
            filterCallback = GetFilterCallback({ITEMTYPE_SIEGE}),
            dropdownCallbacks = {},
        },
        Bait = {
            filterCallback = GetFilterCallback({ITEMTYPE_LURE}),
            dropdownCallbacks = {},
        },
        Tool = {
            filterCallback = GetFilterCallback({ITEMTYPE_TOOL}),
            dropdownCallbacks = {},
        },
        Trophy = {
            filterCallback = GetFilterCallbackForTrophy(),
            dropdownCallbacks = {},
        },
        Fence = {
            filterCallback = GetFilterCallbackForFence(),
            dropdownCallbacks = {},
        },
        Trash = {
            filterCallback = GetFilterCallback({ITEMTYPE_TRASH}),
            dropdownCallbacks = {},
        },
    },
    Junk = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        Weapon = {
            filterCallback = GetFilterCallback({ITEMTYPE_WEAPON}),
            dropdownCallbacks = {
                {name = "OneHand", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_AXE, WEAPONTYPE_HAMMER, WEAPONTYPE_SWORD, WEAPONTYPE_DAGGER})},
                {name = "TwoHand", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_AXE, WEAPONTYPE_TWO_HANDED_HAMMER, WEAPONTYPE_TWO_HANDED_SWORD})},
                {name = "Bow", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_BOW})},
                {name = "DestructionStaff", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_FIRE_STAFF, WEAPONTYPE_FROST_STAFF, WEAPONTYPE_LIGHTNING_STAFF})},
                {name = "HealStaff", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_HEALING_STAFF})},
            },
        },
        Apparel = {
            filterCallback = GetFilterCallback({ITEMTYPE_ARMOR}),
            dropdownCallbacks = {
                {name = "Heavy", filterCallback = GetFilterCallbackForArmorType({ARMORTYPE_HEAVY})},
                {name = "Medium", filterCallback = GetFilterCallbackForArmorType({ARMORTYPE_MEDIUM})},
                {name = "Light", filterCallback = GetFilterCallbackForArmorType({ARMORTYPE_LIGHT})},
                {name = "Clothing", filterCallback = GetFilterCallbackForClothing()},
                {name = "Shield", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_OFF_HAND})},
                {name = "Jewelry", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_RING, EQUIP_TYPE_NECK})},
                {name = "Vanity", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_DISGUISE, EQUIP_TYPE_COSTUME})},
            },
        },
        Consumable = {
            filterCallback = GetFilterCallback({ITEMTYPE_CROWN_ITEM, ITEMTYPE_FOOD, ITEMTYPE_DRINK, ITEMTYPE_RECIPE, ITEMTYPE_POTION, ITEMTYPE_POISON, ITEMTYPE_RACIAL_STYLE_MOTIF, ITEMTYPE_CONTAINER, ITEMTYPE_AVA_REPAIR, ITEMTYPE_TOOL, ITEMTYPE_CROWN_REPAIR, ITEMTYPE_TROPHY, ITEMTYPE_COLLECTIBLE, ITEMTYPE_FISH, ITEMTYPE_TREASURE}),
            dropdownCallbacks = {
                {name = "Crown", filterCallback = GetFilterCallback({ITEMTYPE_CROWN_ITEM})},
                {name = "Food", filterCallback = GetFilterCallback({ITEMTYPE_FOOD})},
                {name = "Drink", filterCallback = GetFilterCallback({ITEMTYPE_DRINK})},
                {name = "Recipe", filterCallback = GetFilterCallback({ITEMTYPE_RECIPE})},
                {name = "Potion", filterCallback = GetFilterCallback({ITEMTYPE_POTION})},
                {name = "Poison", filterCallback = GetFilterCallback({ITEMTYPE_POISON})},
                {name = "Motif", filterCallback = GetFilterCallback({ITEMTYPE_RACIAL_STYLE_MOTIF})},
                {name = "Container", filterCallback = GetFilterCallback({ITEMTYPE_CONTAINER})},
                {name = "Repair", filterCallback = GetFilterCallback({ITEMTYPE_AVA_REPAIR, ITEMTYPE_TOOL, ITEMTYPE_CROWN_REPAIR})},
                {name = "Trophy", filterCallback = GetFilterCallbackForTrophy()},
            },
        },
        Materials = {
            filterCallback = GetFilterCallback({ITEMTYPE_BLACKSMITHING_MATERIAL, ITEMTYPE_BLACKSMITHING_RAW_MATERIAL, ITEMTYPE_BLACKSMITHING_BOOSTER, ITEMTYPE_CLOTHIER_MATERIAL, ITEMTYPE_CLOTHIER_RAW_MATERIAL, ITEMTYPE_CLOTHIER_BOOSTER, ITEMTYPE_WOODWORKING_MATERIAL, ITEMTYPE_WOODWORKING_RAW_MATERIAL, ITEMTYPE_WOODWORKING_BOOSTER, ITEMTYPE_REAGENT, ITEMTYPE_POTION_BASE, ITEMTYPE_POISON_BASE, ITEMTYPE_ENCHANTING_RUNE_ASPECT, ITEMTYPE_ENCHANTING_RUNE_ESSENCE, ITEMTYPE_ENCHANTING_RUNE_POTENCY, ITEMTYPE_INGREDIENT, ITEMTYPE_STYLE_MATERIAL, ITEMTYPE_RAW_MATERIAL, ITEMTYPE_WEAPON_TRAIT, ITEMTYPE_ARMOR_TRAIT}),
            dropdownCallbacks = {
                {name = "Blacksmithing", filterCallback = GetFilterCallback({ITEMTYPE_BLACKSMITHING_MATERIAL, ITEMTYPE_BLACKSMITHING_RAW_MATERIAL, ITEMTYPE_BLACKSMITHING_BOOSTER})},
                {name = "Clothier", filterCallback = GetFilterCallback({ITEMTYPE_CLOTHIER_MATERIAL, ITEMTYPE_CLOTHIER_RAW_MATERIAL, ITEMTYPE_CLOTHIER_BOOSTER})},
                {name = "Woodworking", filterCallback = GetFilterCallback({ITEMTYPE_WOODWORKING_MATERIAL, ITEMTYPE_WOODWORKING_RAW_MATERIAL, ITEMTYPE_WOODWORKING_BOOSTER})},
                {name = "Alchemy", filterCallback = GetFilterCallback({ITEMTYPE_REAGENT, ITEMTYPE_POTION_BASE, ITEMTYPE_POISON_BASE})},
                {name = "Enchanting", filterCallback = GetFilterCallback({ITEMTYPE_ENCHANTING_RUNE_ASPECT, ITEMTYPE_ENCHANTING_RUNE_ESSENCE, ITEMTYPE_ENCHANTING_RUNE_POTENCY})},
                {name = "Provisioning", filterCallback = GetFilterCallback({ITEMTYPE_INGREDIENT})},
                {name = "Style", filterCallback = GetFilterCallback({ITEMTYPE_STYLE_MATERIAL, ITEMTYPE_RAW_MATERIAL})},
                {name = "ArmorTrait", filterCallback = GetFilterCallback({ITEMTYPE_ARMOR_TRAIT})},
                {name = "WeaponTrait", filterCallback = GetFilterCallback({ITEMTYPE_WEAPON_TRAIT})},
            },
        },
        Miscellaneous = {
            filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_ARMOR, ITEMTYPE_GLYPH_JEWELRY, ITEMTYPE_GLYPH_WEAPON, ITEMTYPE_SOUL_GEM, ITEMTYPE_SIEGE, ITEMTYPE_LURE, ITEMTYPE_TOOL, ITEMTYPE_TROPHY, ITEMTYPE_COLLECTIBLE, ITEMTYPE_FISH, ITEMTYPE_TREASURE, ITEMTYPE_TRASH}),
            dropdownCallbacks = {
                {name = "Glyphs", filterCallback = GetFilterCallback({ITEMTYPE_GLYPH_ARMOR, ITEMTYPE_GLYPH_JEWELRY, ITEMTYPE_GLYPH_WEAPON})},
                {name = "SoulGem", filterCallback = GetFilterCallback({ITEMTYPE_SOUL_GEM})},
                {name = "Siege", filterCallback = GetFilterCallback({ITEMTYPE_SIEGE})},
                {name = "Bait", filterCallback = GetFilterCallback({ITEMTYPE_LURE})},
                {name = "Tool", filterCallback = GetFilterCallback({ITEMTYPE_TOOL})},
                {name = "Trophy", filterCallback = GetFilterCallbackForTrophy()},
                {name = "Fence", filterCallback = GetFilterCallbackForFence()},
                {name = "Trash", filterCallback = GetFilterCallback({ITEMTYPE_TRASH})},
            },
        },
    },
    Blacksmithing = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        RawMaterial = {
            filterCallback = GetFilterCallback({ITEMTYPE_BLACKSMITHING_RAW_MATERIAL, ITEMTYPE_RAW_MATERIAL}),
            dropdownCallbacks = {},
        },
        RefinedMaterial = {
            filterCallback = GetFilterCallback({ITEMTYPE_BLACKSMITHING_MATERIAL}),
            dropdownCallbacks = {},
        },
        Temper = {
            filterCallback = GetFilterCallback({ITEMTYPE_BLACKSMITHING_BOOSTER}),
            dropdownCallbacks = {},
        },
    },
    Clothing = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        RawMaterial = {
            filterCallback = GetFilterCallback({ITEMTYPE_CLOTHIER_RAW_MATERIAL, ITEMTYPE_RAW_MATERIAL}),
            dropdownCallbacks = {},
        },
        RefinedMaterial = {
            filterCallback = GetFilterCallback({ITEMTYPE_CLOTHIER_MATERIAL}),
            dropdownCallbacks = {},
        },
        Resin = {
            filterCallback = GetFilterCallback({ITEMTYPE_CLOTHIER_BOOSTER}),
            dropdownCallbacks = {},
        },
    },
    Woodworking = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        RawMaterial = {
            filterCallback = GetFilterCallback({ITEMTYPE_WOODWORKING_RAW_MATERIAL, ITEMTYPE_RAW_MATERIAL}),
            dropdownCallbacks = {},
        },
        RefinedMaterial = {
            filterCallback = GetFilterCallback({ITEMTYPE_WOODWORKING_MATERIAL}),
            dropdownCallbacks = {},
        },
        Tannin = {
            filterCallback = GetFilterCallback({ITEMTYPE_WOODWORKING_BOOSTER}),
            dropdownCallbacks = {},
        },
    },
    Alchemy = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        Reagent = {
            filterCallback = GetFilterCallback({ITEMTYPE_REAGENT}),
            dropdownCallbacks = {},
        },
        Water = {
            filterCallback = GetFilterCallback({ITEMTYPE_POTION_BASE}),
            dropdownCallbacks = {},
        },
        Oil = {
            filterCallback = GetFilterCallback({ITEMTYPE_POISON_BASE}),
            dropdownCallbacks = {},
        },
    },
    Enchanting = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        Aspect = {
            filterCallback = GetFilterCallback({ITEMTYPE_ENCHANTING_RUNE_ASPECT}),
            dropdownCallbacks = {},
        },
        Essence = {
            filterCallback = GetFilterCallback({ITEMTYPE_ENCHANTING_RUNE_ESSENCE}),
            dropdownCallbacks = {},
        },
        Potency = {
            filterCallback = GetFilterCallback({ITEMTYPE_ENCHANTING_RUNE_POTENCY}),
            dropdownCallbacks = {},
        },
    },
    Provisioning = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        FoodIngredient = {
            filterCallback = GetFilterCallbackForProvisioningIngredient("Food"),
            dropdownCallbacks = {},
        },
        DrinkIngredient = {
            filterCallback = GetFilterCallbackForProvisioningIngredient("Drink"),
            dropdownCallbacks = {},
        },
        OldIngredient = {
            filterCallback = GetFilterCallbackForProvisioningIngredient("Old"),
            dropdownCallbacks = {},
        },
        RareIngredient = {
            filterCallback = GetFilterCallbackForSpecializedItemtype({SPECIALIZED_ITEMTYPE_INGREDIENT_RARE}),
            dropdownCallbacks = {},
        },
        Bait = {
            filterCallback = GetFilterCallback({ITEMTYPE_LURE}),
            dropdownCallbacks = {},
        },
    },
    Style = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        NormalStyle = {
            filterCallback = GetFilterCallbackForStyleMaterial(LMC_MOTIF_CATEGORY_NORMAL),
            dropdownCallbacks = {},
        },
        RareStyle = {
            filterCallback = GetFilterCallbackForStyleMaterial(LMC_MOTIF_CATEGORY_RARE),
            dropdownCallbacks = {},
        },
        AllianceStyle = {
            filterCallback = GetFilterCallbackForStyleMaterial(LMC_MOTIF_CATEGORY_ALLIANCE),
            dropdownCallbacks = {},
        },
        ExoticStyle = {
            filterCallback = GetFilterCallbackForStyleMaterial(LMC_MOTIF_CATEGORY_EXOTIC),
            dropdownCallbacks = {},
        },
        CrownStyle = {
            filterCallback = GetFilterCallbackForStyleMaterial(LMC_MOTIF_CATEGORY_CROWN),
            dropdownCallbacks = {},
        },
    },
    Traits = {
        addonDropdownCallbacks = {},
        All = {
            filterCallback = GetFilterCallback(nil),
            dropdownCallbacks = {},
        },
        WeaponTrait = {
            filterCallback = GetFilterCallback({ITEMTYPE_WEAPON_TRAIT}),
            dropdownCallbacks = {},
        },
        ArmorTrait = {
            filterCallback = GetFilterCallback({ITEMTYPE_ARMOR_TRAIT}),
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
        [ITEMFILTERTYPE_FURNISHING] = "Furnishings",
        [ITEMFILTERTYPE_MISCELLANEOUS] = "Miscellaneous",
        [ITEMFILTERTYPE_JUNK] = "Junk",
        [ITEMFILTERTYPE_BLACKSMITHING] = "Blacksmithing",
        [ITEMFILTERTYPE_CLOTHING] = "Clothing",
        [ITEMFILTERTYPE_WOODWORKING] = "Woodworking",
        [ITEMFILTERTYPE_ALCHEMY] = "Alchemy",
        [ITEMFILTERTYPE_ENCHANTING] = "Enchanting",
        [ITEMFILTERTYPE_PROVISIONING] = "Provisioning",
        [ITEMFILTERTYPE_STYLE_MATERIALS] = "Style",
        [ITEMFILTERTYPE_TRAIT_ITEMS] = "Traits",
    }

    --make sure all necessary information is present
    if filterInformation == nil then
        d("No filter information provided. Filter not registered.")
        return
    end
    if filterInformation.callbackTable == nil and filterInformation.generator == nil then
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
    if filterInformation.enStrings == nil and filterInformation.generator == nil then
        d("No English strings provided. Filter not registered.")
        return
    end

    --get filter information from the calling addon and insert it into our callback table
    local addonInformation = {
        submenuName = filterInformation.submenuName,
        callbackTable = filterInformation.callbackTable,
        subfilters = filterInformation.subfilters,
        generator = filterInformation.generator,
    }
    local groupName = filterTypeToGroupName[filterInformation.filterType]

    --insert addon information
    table.insert(AF.subfilterCallbacks[groupName].addonDropdownCallbacks, addonInformation)

    --if strings are going to be generated, end registration now
    if filterInformation.generator then return end

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