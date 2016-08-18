--thanks ckaotik
local function AF_Localize(text)
	if type(text) == 'number' then
		-- get the string from this constant
		text = GetString(text)
	end
	-- clean up suffixes such as ^F or ^S
	return zo_strformat(SI_TOOLTIP_ITEM_NAME, text) or " "
end

local strings = {
	de = {
		--SHARED
		All = "Alle",
		Trophy = AF_Localize(SI_ITEMTYPE5),

		--WEAPON
		OneHand = "Einh\195\164ndig",
		TwoHand = "Zweih\195\164ndig",
        Bow = AF_Localize(SI_WEAPONTYPE8),
		DestructionStaff = "Zerst\195\182rungsstab",
		HealStaff = AF_Localize(SI_WEAPONTYPE9),

		Axe = AF_Localize(SI_WEAPONTYPE1),
		Sword = AF_Localize(SI_WEAPONTYPE3),
		Hammer = AF_Localize(SI_WEAPONTYPE2),
		TwoHandAxe = "2H "..AF_Localize(SI_WEAPONTYPE1),
		TwoHandSword = "2H "..AF_Localize(SI_WEAPONTYPE3),
		TwoHandHammer = "2H "..AF_Localize(SI_WEAPONTYPE2),
		Dagger = AF_Localize(SI_WEAPONTYPE11),
		Fire = AF_Localize(SI_WEAPONTYPE12),
		Frost = AF_Localize(SI_WEAPONTYPE13),
		Lightning = AF_Localize(SI_WEAPONTYPE15),

		--ARMOR
        Heavy = AF_Localize(SI_ARMORTYPE3),
        Medium = AF_Localize(SI_ARMORTYPE2),
		Light = AF_Localize(SI_ARMORTYPE1),
		Clothing = "Bekleidung",
		Shield = "Schilde",
		Jewelry = "Schmuck",
		Vanity = "Verkleidung",

		Head = "Kopf",
		Chest = "Torso",
		Shoulders = "Schultern",
		Hand = "H\195\164nde",
		Waist = "Taille",
		Legs = "Beine",
		Feet = "F\195\188ße",
		Ring = "Ring",
		Neck = "Hals",

		--CONSUMABLES
		Crown = AF_Localize(SI_ITEMTYPE57),
        Food = AF_Localize(SI_ITEMTYPE4),
        Drink = AF_Localize(SI_ITEMTYPE12),
        Recipe = AF_Localize(SI_ITEMTYPE29),
        Potion = AF_Localize(SI_ITEMTYPE7),
        Poison = AF_Localize(SI_ITEMTYPE30),
        Motif = AF_Localize(SI_ITEMTYPE8),
		Container = AF_Localize(SI_ITEMTYPE18),
		Repair = "Werkzeug",

		--MATERIALS
		Blacksmithing = "Schmiedekunst",
		Clothier = "Schneiderei",
		Woodworking = "Schreinerei",
		Alchemy = "Alchemie",
		Enchanting = "Verzaubern",
		Provisioning = "Versorgen",
        Style = AF_Localize(SI_ITEMTYPE44),
        WeaponTrait = AF_Localize(SI_ITEMTYPE46),
		ArmorTrait = AF_Localize(SI_ITEMTYPE45),

		Reagent = AF_Localize(SI_ITEMTYPE31),
        Water = AF_Localize(SI_ITEMTYPE33),
		Oil = AF_Localize(SI_ITEMTYPE58),
		Aspect = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
		Essence = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
		Potency = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),
		FoodIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_FOOD)),
	    DrinkIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_DRINK)),
		OldIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_NONE)),

		--MISCELLANEOUS
		Glyphs = "Glyphe",
        SoulGem = AF_Localize(SI_ITEMTYPE19),
		Siege = AF_Localize(SI_ITEMTYPE6),
		Bait = "K\195\182der",
		Tool = AF_Localize(SI_ITEMTYPE9),
		Fence = AF_Localize(SI_INVENTORY_STOLEN_ITEM_TOOLTIP),
		Trash = AF_Localize(SI_ITEMTYPE48),

		ArmorGlyph = AF_Localize(SI_ITEMTYPE21),
        JewelryGlyph = AF_Localize(SI_ITEMTYPE26),
        WeaponGlyph = AF_Localize(SI_ITEMTYPE20),

		--JUNK
		Weapon = AF_Localize(SI_ITEMFILTERTYPE1),
		Apparel = AF_Localize(SI_ITEMFILTERTYPE2),
		Consumable = AF_Localize(SI_ITEMFILTERTYPE3),
		Materials = AF_Localize(SI_ITEMFILTERTYPE4),
		Miscellaneous = AF_Localize(SI_ITEMFILTERTYPE5),

		--DROPDOWN CONTEXT MENU
		ResetToAll = "Alle anzeigen",
		InvertDropdownFilter = "Filter umdrehen",

		--LibMotifCategories
		NormalStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_NORMAL),
		RareStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_RARE),
		AllianceStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_ALLIANCE),
		ExoticStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_EXOTIC),
		DroppedStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_DROPPED),
		CrownStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_CROWN),

		--CRAFT BAG
		--BLACKSMITHING
		RawMaterial = AF_Localize(SI_ITEMTYPE17),
		RefinedMaterial = AF_Localize(SI_ITEMTYPE36),
		Temper = AF_Localize(SI_ITEMTYPE41),
		
		--CLOTHING
		Resin = AF_Localize(SI_ITEMTYPE43),
		
		--WOODWORKING
		Tannin = AF_Localize(SI_ITEMTYPE42),
	},
	en = {
		--SHARED
		All = "All",
		Trophy = AF_Localize(SI_ITEMTYPE5),

		--WEAPON
		OneHand = "One-Handed",
		TwoHand = "Two-Handed",
		Bow = AF_Localize(SI_WEAPONTYPE8),
		DestructionStaff = "Destruction Staff",
		HealStaff = AF_Localize(SI_WEAPONTYPE9),

		Axe = AF_Localize(SI_WEAPONTYPE1),
		Sword = AF_Localize(SI_WEAPONTYPE3),
		Hammer = AF_Localize(SI_WEAPONTYPE2),
		TwoHandAxe = "2H "..AF_Localize(SI_WEAPONTYPE1),
		TwoHandSword = "2H "..AF_Localize(SI_WEAPONTYPE3),
		TwoHandHammer = "2H "..AF_Localize(SI_WEAPONTYPE2),
		Dagger = AF_Localize(SI_WEAPONTYPE11),
		Fire = AF_Localize(SI_WEAPONTYPE12),
		Frost = AF_Localize(SI_WEAPONTYPE13),
		Lightning = AF_Localize(SI_WEAPONTYPE15),

		--ARMOR
		Heavy = AF_Localize(SI_ARMORTYPE3),
		Medium = AF_Localize(SI_ARMORTYPE2),
		Light = AF_Localize(SI_ARMORTYPE1),
		Clothing = "Clothing",
		Shield = "Shield",
		Jewelry = "Jewelry",
		Vanity = "Vanity",

		Head = "Head",
		Chest = "Chest",
		Shoulders = "Shoulders",
		Hand = "Hand",
		Waist = "Waist",
		Legs = "Legs",
		Feet = "Feet",
		Ring = "Ring",
		Neck = "Neck",

		--CONSUMABLES
		Crown = AF_Localize(SI_ITEMTYPE57),
		Food = AF_Localize(SI_ITEMTYPE4),
		Drink = AF_Localize(SI_ITEMTYPE12),
		Recipe = AF_Localize(SI_ITEMTYPE29),
		Potion = AF_Localize(SI_ITEMTYPE7),
		Poison = AF_Localize(SI_ITEMTYPE30),
		Motif = AF_Localize(SI_ITEMTYPE8),
		Container = AF_Localize(SI_ITEMTYPE18),
		Repair = "Repair",

		--MATERIALS
		Blacksmithing = "Blacksmithing",
		Clothier = "Clothier",
		Woodworking = "Woodworking",
		Alchemy = "Alchemy",
		Enchanting = "Enchanting",
		Provisioning = "Provisioning",
		Style = AF_Localize(SI_ITEMTYPE44),
		WeaponTrait = AF_Localize(SI_ITEMTYPE46),
		ArmorTrait = AF_Localize(SI_ITEMTYPE45),

		Reagent = AF_Localize(SI_ITEMTYPE31),
		Water = AF_Localize(SI_ITEMTYPE33),
		Oil = AF_Localize(SI_ITEMTYPE58),
		Aspect = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
		Essence = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
		Potency = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),
		FoodIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_FOOD)),
	    DrinkIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_DRINK)),
		OldIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_NONE)),

		--MISCELLANEOUS
		Glyphs = "Glyphs",
		SoulGem = AF_Localize(SI_ITEMTYPE19),
		Siege = AF_Localize(SI_ITEMTYPE6),
		Bait = "Bait",
		Tool = AF_Localize(SI_ITEMTYPE9),
		Fence = AF_Localize(SI_INVENTORY_STOLEN_ITEM_TOOLTIP),
		Trash = AF_Localize(SI_ITEMTYPE48),

		ArmorGlyph = AF_Localize(SI_ITEMTYPE21),
		JewelryGlyph = AF_Localize(SI_ITEMTYPE26),
		WeaponGlyph = AF_Localize(SI_ITEMTYPE20),

		--JUNK
		Weapon = AF_Localize(SI_ITEMFILTERTYPE1),
		Apparel = AF_Localize(SI_ITEMFILTERTYPE2),
		Consumable = AF_Localize(SI_ITEMFILTERTYPE3),
		Materials = AF_Localize(SI_ITEMFILTERTYPE4),
		Miscellaneous = AF_Localize(SI_ITEMFILTERTYPE5),

		--DROPDOWN CONTEXT MENU
		ResetToAll = "Reset to All",
		InvertDropdownFilter = "Invert Dropdown Filter",
		
		--LibMotifCategories
		NormalStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_NORMAL),
		RareStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_RARE),
		AllianceStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_ALLIANCE),
		ExoticStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_EXOTIC),
		DroppedStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_DROPPED),
		CrownStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_CROWN),

		--CRAFT BAG
		--BLACKSMITHING
		RawMaterial = AF_Localize(SI_ITEMTYPE17),
		RefinedMaterial = AF_Localize(SI_ITEMTYPE36),
		Temper = AF_Localize(SI_ITEMTYPE41),
		
		--CLOTHING
		Resin = AF_Localize(SI_ITEMTYPE43),
		
		--WOODWORKING
		Tannin = AF_Localize(SI_ITEMTYPE42),
	},
	es = {
		--SHARED
		All = "Todo",
		Trophy = AF_Localize(SI_ITEMTYPE5),

		--WEAPON
		OneHand = "Una Mano",
		TwoHand = "Dos Manos",
        Bow = AF_Localize(SI_WEAPONTYPE8),
		DestructionStaff = "Vara de destrucci\195\179n",
		HealStaff = AF_Localize(SI_WEAPONTYPE9),

		Axe = AF_Localize(SI_WEAPONTYPE1),
		Sword = AF_Localize(SI_WEAPONTYPE3),
		Hammer = AF_Localize(SI_WEAPONTYPE2),
		TwoHandAxe = "2H "..AF_Localize(SI_WEAPONTYPE1),
		TwoHandSword = "2H "..AF_Localize(SI_WEAPONTYPE3),
		TwoHandHammer = "2H "..AF_Localize(SI_WEAPONTYPE2),
		Dagger = AF_Localize(SI_WEAPONTYPE11),
		Fire = AF_Localize(SI_WEAPONTYPE12),
		Frost = AF_Localize(SI_WEAPONTYPE13),
		Lightning = AF_Localize(SI_WEAPONTYPE15),

		--ARMOR
        Heavy = AF_Localize(SI_ARMORTYPE3),
        Medium = AF_Localize(SI_ARMORTYPE2),
		Light = AF_Localize(SI_ARMORTYPE1),
		--Clothing = ,
		Shield = "Escudos",
		Jewelry = "Joyas",
		Vanity = "Varios",

		Head = "Cabeza",
		Chest = "Pecho",
		Shoulders = "Hombros",
		Hand = "Manos",
		Waist = "Cintura",
		Legs = "Piernas",
		Feet = "Pies",
		--Ring = ,
		--Neck = ,

		--CONSUMABLES
		Crown = AF_Localize(SI_ITEMTYPE57),
        Food = AF_Localize(SI_ITEMTYPE4),
        Drink = AF_Localize(SI_ITEMTYPE12),
        Recipe = AF_Localize(SI_ITEMTYPE29),
        Potion = AF_Localize(SI_ITEMTYPE7),
        Poison = AF_Localize(SI_ITEMTYPE30),
        Motif = AF_Localize(SI_ITEMTYPE8),
		Container = AF_Localize(SI_ITEMTYPE18),
		Repair = "Reparaci\195\179n",

		--MATERIALS
		Blacksmithing = "Herrer\195\173a",
		Clothier = "Sastrer\195\173a",
		Woodworking = "Carpinter\195\173a",
		Alchemy = "Alquimia",
		Enchanting = "Encantamiento",
		Provisioning = "Cocina",
        Style = AF_Localize(SI_ITEMTYPE44),
        WeaponTrait = AF_Localize(SI_ITEMTYPE46),
		ArmorTrait = AF_Localize(SI_ITEMTYPE45),

		Reagent = AF_Localize(SI_ITEMTYPE31),
        Water = AF_Localize(SI_ITEMTYPE33),
		Oil = AF_Localize(SI_ITEMTYPE58),
		Aspect = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
		Essence = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
		Potency = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),
		FoodIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_FOOD)),
	    DrinkIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_DRINK)),
		OldIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_NONE)),

		--MISCELLANEOUS
		Glyphs = "Glifos",
        SoulGem = AF_Localize(SI_ITEMTYPE19),
		Siege = AF_Localize(SI_ITEMTYPE6),
		Bait = "Cebo",
		Tool = AF_Localize(SI_ITEMTYPE9),
		Fence = AF_Localize(SI_INVENTORY_STOLEN_ITEM_TOOLTIP),
		Trash = AF_Localize(SI_ITEMTYPE48),

		ArmorGlyph = AF_Localize(SI_ITEMTYPE21),
        JewelryGlyph = AF_Localize(SI_ITEMTYPE26),
        WeaponGlyph = AF_Localize(SI_ITEMTYPE20),

		--JUNK
		Weapon = AF_Localize(SI_ITEMFILTERTYPE1),
		Apparel = AF_Localize(SI_ITEMFILTERTYPE2),
		Consumable = AF_Localize(SI_ITEMFILTERTYPE3),
		Materials = AF_Localize(SI_ITEMFILTERTYPE4),
		Miscellaneous = AF_Localize(SI_ITEMFILTERTYPE5),

		--DROPDOWN CONTEXT MENU
		ResetToAll = "Reset to All",
		InvertDropdownFilter = "Invert Dropdown Filter",
		
		--LibMotifCategories
		NormalStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_NORMAL),
		RareStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_RARE),
		AllianceStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_ALLIANCE),
		ExoticStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_EXOTIC),
		DroppedStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_DROPPED),
		CrownStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_CROWN),

		--CRAFT BAG
		--BLACKSMITHING
		RawMaterial = AF_Localize(SI_ITEMTYPE17),
		RefinedMaterial = AF_Localize(SI_ITEMTYPE36),
		Temper = AF_Localize(SI_ITEMTYPE41),
		
		--CLOTHING
		Resin = AF_Localize(SI_ITEMTYPE43),
		
		--WOODWORKING
		Tannin = AF_Localize(SI_ITEMTYPE42),
	},
	fr = {
		--SHARED
		All = "Tout",
		Trophy = AF_Localize(SI_ITEMTYPE5),

		--WEAPON
		OneHand = "Une Main",
		TwoHand = "Deux Mains",
		Bow = AF_Localize(SI_WEAPONTYPE8),
		DestructionStaff = "Destruction Staff",
		HealStaff = AF_Localize(SI_WEAPONTYPE9),

		Axe = AF_Localize(SI_WEAPONTYPE1),
		Sword = AF_Localize(SI_WEAPONTYPE3),
		Hammer = AF_Localize(SI_WEAPONTYPE2),
		TwoHandAxe = "2H "..AF_Localize(SI_WEAPONTYPE1),
		TwoHandSword = "2H "..AF_Localize(SI_WEAPONTYPE3),
		TwoHandHammer = "2H "..AF_Localize(SI_WEAPONTYPE2),
		Dagger = AF_Localize(SI_WEAPONTYPE11),
		Fire = AF_Localize(SI_WEAPONTYPE12),
		Frost = AF_Localize(SI_WEAPONTYPE13),
		Lightning = AF_Localize(SI_WEAPONTYPE15),

		--ARMOR
        Heavy = AF_Localize(SI_ARMORTYPE3),
        Medium = AF_Localize(SI_ARMORTYPE2),
		Light = AF_Localize(SI_ARMORTYPE1),
		Clothing = "Vêtements",
		Shield = "Boucliers",
		Jewelry = "Bijoux",
		Vanity = "Divers",

		Head = "T\195\170te",
		Chest = "Buste",
		Shoulders = "Epaules",
		Hand = "Mains",
		Waist = "Taille",
		Legs = "Jambes",
		Feet = "Pieds",
		Ring = "Anneaux",
		Neck = "Pendentifs",

		--CONSUMABLES
		Crown = AF_Localize(SI_ITEMTYPE57),
        Food = AF_Localize(SI_ITEMTYPE4),
        Drink = AF_Localize(SI_ITEMTYPE12),
        Recipe = AF_Localize(SI_ITEMTYPE29),
        Potion = AF_Localize(SI_ITEMTYPE7),
        Poison = AF_Localize(SI_ITEMTYPE30),
        Motif = AF_Localize(SI_ITEMTYPE8),
		Container = AF_Localize(SI_ITEMTYPE18),
		Repair = "R\195\169paration",

		--MATERIALS
		Blacksmithing = "Forge",
		Clothier = "Couture",
		Woodworking = "Travail du bois",
		Alchemy = "Alchimie",
		Enchanting = "Enchantement",
		Provisioning = "Approvisionnement",
        Style = AF_Localize(SI_ITEMTYPE44),
        WeaponTrait = AF_Localize(SI_ITEMTYPE46),
		ArmorTrait = AF_Localize(SI_ITEMTYPE45),

		Reagent = AF_Localize(SI_ITEMTYPE31),
        Water = AF_Localize(SI_ITEMTYPE33),
		Oil = AF_Localize(SI_ITEMTYPE58),
		Aspect = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
		Essence = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
		Potency = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),
		FoodIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_FOOD)),
	    DrinkIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_DRINK)),
		OldIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_NONE)),

		--MISCELLANEOUS
		Glyphs = "Glyphs",
        SoulGem = AF_Localize(SI_ITEMTYPE19),
		Siege = AF_Localize(SI_ITEMTYPE6),
		Bait = "App\195\162ts",
		Tool = AF_Localize(SI_ITEMTYPE9),
		Fence = AF_Localize(SI_INVENTORY_STOLEN_ITEM_TOOLTIP),
		Trash = AF_Localize(SI_ITEMTYPE48),

        ArmorGlyph = AF_Localize(SI_ITEMTYPE21),
        JewelryGlyph = AF_Localize(SI_ITEMTYPE26),
        WeaponGlyph = AF_Localize(SI_ITEMTYPE20),

		--JUNK
		Weapon = AF_Localize(SI_ITEMFILTERTYPE1),
		Apparel = AF_Localize(SI_ITEMFILTERTYPE2),
		Consumable = AF_Localize(SI_ITEMFILTERTYPE3),
		Materials = AF_Localize(SI_ITEMFILTERTYPE4),
		Miscellaneous = AF_Localize(SI_ITEMFILTERTYPE5),

		--DROPDOWN CONTEXT MENU
		ResetToAll = "Réinitialiser à Tout",
		InvertDropdownFilter = "Inverser la sélection",
		
		--LibMotifCategories
		NormalStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_NORMAL),
		RareStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_RARE),
		AllianceStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_ALLIANCE),
		ExoticStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_EXOTIC),
		DroppedStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_DROPPED),
		CrownStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_CROWN),

		--CRAFT BAG
		--BLACKSMITHING
		RawMaterial = AF_Localize(SI_ITEMTYPE17),
		RefinedMaterial = AF_Localize(SI_ITEMTYPE36),
		Temper = AF_Localize(SI_ITEMTYPE41),
		
		--CLOTHING
		Resin = AF_Localize(SI_ITEMTYPE43),
		
		--WOODWORKING
		Tannin = AF_Localize(SI_ITEMTYPE42),
	},
	ru = {
		--SHARED
		All = "Все",
		Trophy = AF_Localize(SI_ITEMTYPE5),

		--WEAPON
		OneHand = "Одноручное",
		TwoHand = "Двуручное",
		Bow = AF_Localize(SI_WEAPONTYPE8),
		DestructionStaff = "Посох разрушения",
		HealStaff = AF_Localize(SI_WEAPONTYPE9),

		Axe = AF_Localize(SI_WEAPONTYPE1),
		Sword = AF_Localize(SI_WEAPONTYPE3),
		Hammer = AF_Localize(SI_WEAPONTYPE2),
		TwoHandAxe = "2H "..AF_Localize(SI_WEAPONTYPE1),
		TwoHandSword = "2H "..AF_Localize(SI_WEAPONTYPE3),
		TwoHandHammer = "2H "..AF_Localize(SI_WEAPONTYPE2),
		Dagger = AF_Localize(SI_WEAPONTYPE11),
		Fire = AF_Localize(SI_WEAPONTYPE12),
		Frost = AF_Localize(SI_WEAPONTYPE13),
		Lightning = AF_Localize(SI_WEAPONTYPE15),

		--ARMOR
        Heavy = AF_Localize(SI_ARMORTYPE3),
        Medium = AF_Localize(SI_ARMORTYPE2),
		Light = AF_Localize(SI_ARMORTYPE1),
		--Clothing = ,
		Shield = "Щит",
		Jewelry = "Бижутерия",
		Vanity = "Разное",

		Head = "Голова",
		Chest = "Торс",
		Shoulders = "Плечи",
		Hand = "Руки",
		Waist = "Пояс",
		Legs = "Ноги",
		Feet = "Ступни",
		Ring = "Кольцо",
		Neck = "Шея",

		--CONSUMABLES
		Crown = AF_Localize(SI_ITEMTYPE57),
        Food = AF_Localize(SI_ITEMTYPE4),
        Drink = AF_Localize(SI_ITEMTYPE12),
        Recipe = AF_Localize(SI_ITEMTYPE29),
        Potion = AF_Localize(SI_ITEMTYPE7),
        Poison = AF_Localize(SI_ITEMTYPE30),
        Motif = AF_Localize(SI_ITEMTYPE8),
		Container = AF_Localize(SI_ITEMTYPE18),
		Repair = "Ремонт",

		--MATERIALS
		Blacksmithing = "Кузнечество",
		Clothier = "Шитье",
		Woodworking = "Древообработка",
		Alchemy = "Алхимия",
		Enchanting = "Зачарование",
		Provisioning = "Кулинария",
        Style = AF_Localize(SI_ITEMTYPE44),
        WeaponTrait = AF_Localize(SI_ITEMTYPE46),
		ArmorTrait = AF_Localize(SI_ITEMTYPE45),

		Reagent = AF_Localize(SI_ITEMTYPE31),
        Solvent = AF_Localize(SI_ITEMTYPE33),
		Aspect = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
		Essence = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
		Potency = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

		--MISCELLANEOUS
		Glyphs = "Глифы",
        SoulGem = AF_Localize(SI_ITEMTYPE19),
		Siege = AF_Localize(SI_ITEMTYPE6),
		Bait = "Наживка",
		Tool = AF_Localize(SI_ITEMTYPE9),
		Fence = AF_Localize(SI_INVENTORY_STOLEN_ITEM_TOOLTIP),
		Trash = AF_Localize(SI_ITEMTYPE48),

        ArmorGlyph = AF_Localize(SI_ITEMTYPE21),
        JewelryGlyph = AF_Localize(SI_ITEMTYPE26),
        WeaponGlyph = AF_Localize(SI_ITEMTYPE20),

		--JUNK
		Weapon = AF_Localize(SI_ITEMFILTERTYPE1),
		Apparel = AF_Localize(SI_ITEMFILTERTYPE2),
		Consumable = AF_Localize(SI_ITEMFILTERTYPE3),
		Materials = AF_Localize(SI_ITEMFILTERTYPE4),
		Miscellaneous = AF_Localize(SI_ITEMFILTERTYPE5),

		--DROPDOWN CONTEXT MENU
		ResetToAll = "Сбросить все",
		InvertDropdownFilter = "Инверт.выпадающий фильтр",
	},
}

--Metatable trick to use english localization for missing strings in other languages
setmetatable(strings["de"], {__index = strings["en"]})
setmetatable(strings["es"], {__index = strings["en"]})
setmetatable(strings["fr"], {__index = strings["en"]})
setmetatable(strings["ru"], {__index = strings["en"]})

AdvancedFilters.strings = strings[AdvancedFilters.util.GetLanguage()]