function AdvancedFilters_GetLanguage()
	local lang = GetCVar("language.2")

	--check for supported languages
	if(AF_Strings[lang] ~= nil) then return lang end

	--return english if not supported
	return "en"
end

--thanks ckaotik
local function AF_Localize(text)
	if type(text) == 'number' then
		-- get the string from this constant
		text = GetString(text)
	end
	-- clean up suffixes such as ^F or ^S
	return zo_strformat(SI_TOOLTIP_ITEM_NAME, text)
end

AF_Strings = {
	["de"] = {
		TOOLTIPS = {
			--SHARED
			["All"] = "Alle",
			["Trophy"] = AF_Localize(SI_ITEMTYPE5),

			--WEAPON
			["OneHand"] = "Einh\195\164ndig",
			["TwoHand"] = "Zweih\195\164ndig",
	        ["Bow"] = AF_Localize(SI_WEAPONTYPE8),
			["DestructionStaff"] = "Zerst\195\182rungsstab",
			["HealStaff"] = AF_Localize(SI_WEAPONTYPE9),

			["Axe"] = AF_Localize(SI_WEAPONTYPE1),
			["Sword"] = AF_Localize(SI_WEAPONTYPE3),
			["Hammer"] = AF_Localize(SI_WEAPONTYPE2),
			["2HAxe"] = "2H "..AF_Localize(SI_WEAPONTYPE1),
			["2HSword"] = "2H "..AF_Localize(SI_WEAPONTYPE3),
			["2HHammer"] = "2H "..AF_Localize(SI_WEAPONTYPE2),
			["Dagger"] = AF_Localize(SI_WEAPONTYPE11),
			["Fire"] = AF_Localize(SI_WEAPONTYPE12),
			["Frost"] = AF_Localize(SI_WEAPONTYPE13),
			["Lightning"] = AF_Localize(SI_WEAPONTYPE15),

			--ARMOR
	        ["Heavy"] = AF_Localize(SI_ARMORTYPE3),
	        ["Medium"] = AF_Localize(SI_ARMORTYPE2),
			["Light"] = AF_Localize(SI_ARMORTYPE1),
			["Clothing"] = "Bekleidung",
			["Shield"] = "Schilde",
			["Jewelry"] = "Schmuck",
			["Vanity"] = "Verkleidung",

			["Head"] = "Kopf",
			["Chest"] = "Torso",
			["Shoulders"] = "Schultern",
			["Hand"] = "H\195\164nde",
			["Waist"] = "Taille",
			["Legs"] = "Beine",
			["Feet"] = "F\195\188ße",
			["Ring"] = "Ring",
			["Neck"] = "Hals",

			--CONSUMABLES
			["Crown"] = AF_Localize(SI_ITEMTYPE57),
	        ["Food"] = AF_Localize(SI_ITEMTYPE4),
	        ["Drink"] = AF_Localize(SI_ITEMTYPE12),
	        ["Recipe"] = AF_Localize(SI_ITEMTYPE29),
	        ["Potion"] = AF_Localize(SI_ITEMTYPE7),
	        ["Poison"] = AF_Localize(SI_ITEMTYPE30),
	        ["Motif"] = AF_Localize(SI_ITEMTYPE8),
			["Container"] = AF_Localize(SI_ITEMTYPE18),
			["Repair"] = "Werkzeug",

			--MATERIALS
			["Blacksmithing"] = "Schmiedekunst",
			["Clothier"] = "Schneiderei",
			["Woodworking"] = "Schreinerei",
			["Alchemy"] = "Alchemie",
			["Enchanting"] = "Verzaubern",
			["Provisioning"] = "Versorgen",
	        ["Style"] = AF_Localize(SI_ITEMTYPE44),
	        ["WeaponTrait"] = AF_Localize(SI_ITEMTYPE46),
			["ArmorTrait"] = AF_Localize(SI_ITEMTYPE45),

			["Reagent"] = AF_Localize(SI_ITEMTYPE31),
	        ["Solvent"] = AF_Localize(SI_ITEMTYPE33),
			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			--MISCELLANEOUS
			["Glyphs"] = "Glyphe",
	        ["SoulGem"] = AF_Localize(SI_ITEMTYPE19),
			["Siege"] = AF_Localize(SI_ITEMTYPE6),
			["Bait"] = "K\195\182der",
			["Tool"] = AF_Localize(SI_ITEMTYPE9),
			["Fence"] = "Hehlerware",
			["Trash"] = AF_Localize(SI_ITEMTYPE48),

			["ArmorGlyph"] = AF_Localize(SI_ITEMTYPE21),
	        ["JewelryGlyph"] = AF_Localize(SI_ITEMTYPE26),
	        ["WeaponGlyph"] = AF_Localize(SI_ITEMTYPE20),
		}
	},
	["en"] = {
		TOOLTIPS = {
			--SHARED
			["All"] = "All",
			["Trophy"] = AF_Localize(SI_ITEMTYPE5),

			--WEAPON
			["OneHand"] = "One-Handed",
			["TwoHand"] = "Two-Handed",
			["Bow"] = AF_Localize(SI_WEAPONTYPE8),
			["DestructionStaff"] = "Destruction Staff",
			["HealStaff"] = AF_Localize(SI_WEAPONTYPE9),

			["Axe"] = AF_Localize(SI_WEAPONTYPE1),
			["Sword"] = AF_Localize(SI_WEAPONTYPE3),
			["Hammer"] = AF_Localize(SI_WEAPONTYPE2),
			["2HAxe"] = "2H "..AF_Localize(SI_WEAPONTYPE1),
			["2HSword"] = "2H "..AF_Localize(SI_WEAPONTYPE3),
			["2HHammer"] = "2H "..AF_Localize(SI_WEAPONTYPE2),
			["Dagger"] = AF_Localize(SI_WEAPONTYPE11),
			["Fire"] = AF_Localize(SI_WEAPONTYPE12),
			["Frost"] = AF_Localize(SI_WEAPONTYPE13),
			["Lightning"] = AF_Localize(SI_WEAPONTYPE15),

			--ARMOR
			["Heavy"] = AF_Localize(SI_ARMORTYPE3),
			["Medium"] = AF_Localize(SI_ARMORTYPE2),
			["Light"] = AF_Localize(SI_ARMORTYPE1),
			["Clothing"] = "Clothing",
			["Shield"] = "Shield",
			["Jewelry"] = "Jewelry",
			["Vanity"] = "Vanity",

			["Head"] = "Head",
			["Chest"] = "Chest",
			["Shoulders"] = "Shoulders",
			["Hand"] = "Hand",
			["Waist"] = "Waist",
			["Legs"] = "Legs",
			["Feet"] = "Feet",
			["Ring"] = "Ring",
			["Neck"] = "Neck",

			--CONSUMABLES
			["Crown"] = AF_Localize(SI_ITEMTYPE57),
			["Food"] = AF_Localize(SI_ITEMTYPE4),
			["Drink"] = AF_Localize(SI_ITEMTYPE12),
			["Recipe"] = AF_Localize(SI_ITEMTYPE29),
			["Potion"] = AF_Localize(SI_ITEMTYPE7),
			["Poison"] = AF_Localize(SI_ITEMTYPE30),
			["Motif"] = AF_Localize(SI_ITEMTYPE8),
			["Container"] = AF_Localize(SI_ITEMTYPE18),
			["Repair"] = "Repair",

			--MATERIALS
			["Blacksmithing"] = "Blacksmithing",
			["Clothier"] = "Clothier",
			["Woodworking"] = "Woodworking",
			["Alchemy"] = "Alchemy",
			["Enchanting"] = "Enchanting",
			["Provisioning"] = "Provisioning",
			["Style"] = AF_Localize(SI_ITEMTYPE44),
			["WeaponTrait"] = AF_Localize(SI_ITEMTYPE46),
			["ArmorTrait"] = AF_Localize(SI_ITEMTYPE45),

			["Reagent"] = AF_Localize(SI_ITEMTYPE31),
			["Solvent"] = AF_Localize(SI_ITEMTYPE33),
			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			--MISCELLANEOUS
			["Glyphs"] = "Glyphs",
			["SoulGem"] = AF_Localize(SI_ITEMTYPE19),
			["Siege"] = AF_Localize(SI_ITEMTYPE6),
			["Bait"] = "Bait",
			["Tool"] = AF_Localize(SI_ITEMTYPE9),
			["Fence"] = "Fence",
			["Trash"] = AF_Localize(SI_ITEMTYPE48),

			["ArmorGlyph"] = AF_Localize(SI_ITEMTYPE21),
			["JewelryGlyph"] = AF_Localize(SI_ITEMTYPE26),
			["WeaponGlyph"] = AF_Localize(SI_ITEMTYPE20),
		}
	},
	["es"] = {
		TOOLTIPS = {
			--SHARED
			["All"] = "Todo",
			["Trophy"] = AF_Localize(SI_ITEMTYPE5),

			--WEAPON
			["OneHand"] = "Una Mano",
			["TwoHand"] = "Dos Manos",
	        ["Bow"] = AF_Localize(SI_WEAPONTYPE8),
			["DestructionStaff"] = "Vara de destrucci\195\179n",
			["HealStaff"] = AF_Localize(SI_WEAPONTYPE9),

			["Axe"] = AF_Localize(SI_WEAPONTYPE1),
			["Sword"] = AF_Localize(SI_WEAPONTYPE3),
			["Hammer"] = AF_Localize(SI_WEAPONTYPE2),
			["2HAxe"] = "2H "..AF_Localize(SI_WEAPONTYPE1),
			["2HSword"] = "2H "..AF_Localize(SI_WEAPONTYPE3),
			["2HHammer"] = "2H "..AF_Localize(SI_WEAPONTYPE2),
			["Dagger"] = AF_Localize(SI_WEAPONTYPE11),
			["Fire"] = AF_Localize(SI_WEAPONTYPE12),
			["Frost"] = AF_Localize(SI_WEAPONTYPE13),
			["Lightning"] = AF_Localize(SI_WEAPONTYPE15),

			--ARMOR
	        ["Heavy"] = AF_Localize(SI_ARMORTYPE3),
	        ["Medium"] = AF_Localize(SI_ARMORTYPE2),
			["Light"] = AF_Localize(SI_ARMORTYPE1),
			--["Clothing"] = ,
			["Shield"] = "Escudos",
			["Jewelry"] = "Joyas",
			["Vanity"] = "Varios",

			["Head"] = "Cabeza",
			["Chest"] = "Pecho",
			["Shoulders"] = "Hombros",
			["Hand"] = "Manos",
			["Waist"] = "Cintura",
			["Legs"] = "Piernas",
			["Feet"] = "Pies",
			--["Ring"] = ,
			--["Neck"] = ,

			--CONSUMABLES
			["Crown"] = AF_Localize(SI_ITEMTYPE57),
	        ["Food"] = AF_Localize(SI_ITEMTYPE4),
	        ["Drink"] = AF_Localize(SI_ITEMTYPE12),
	        ["Recipe"] = AF_Localize(SI_ITEMTYPE29),
	        ["Potion"] = AF_Localize(SI_ITEMTYPE7),
	        ["Poison"] = AF_Localize(SI_ITEMTYPE30),
	        ["Motif"] = AF_Localize(SI_ITEMTYPE8),
			["Container"] = AF_Localize(SI_ITEMTYPE18),
			["Repair"] = "Reparaci\195\179n",

			--MATERIALS
			["Blacksmithing"] = "Herrer\195\173a",
			["Clothier"] = "Sastrer\195\173a",
			["Woodworking"] = "Carpinter\195\173a",
			["Alchemy"] = "Alquimia",
			["Enchanting"] = "Encantamiento",
			["Provisioning"] = "Cocina",
	        ["Style"] = AF_Localize(SI_ITEMTYPE44),
	        ["WeaponTrait"] = AF_Localize(SI_ITEMTYPE46),
			["ArmorTrait"] = AF_Localize(SI_ITEMTYPE45),

			["Reagent"] = AF_Localize(SI_ITEMTYPE31),
	        ["Solvent"] = AF_Localize(SI_ITEMTYPE33),
			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			--MISCELLANEOUS
			["Glyphs"] = "Glifos",
	        ["SoulGem"] = AF_Localize(SI_ITEMTYPE19),
			["Siege"] = AF_Localize(SI_ITEMTYPE6),
			["Bait"] = "Cebo",
			["Tool"] = AF_Localize(SI_ITEMTYPE9),
			--["Fence"] = "",
			["Trash"] = AF_Localize(SI_ITEMTYPE48),

			["ArmorGlyph"] = AF_Localize(SI_ITEMTYPE21),
	        ["JewelryGlyph"] = AF_Localize(SI_ITEMTYPE26),
	        ["WeaponGlyph"] = AF_Localize(SI_ITEMTYPE20),
		}
	},
	["fr"] = {
		TOOLTIPS = {
			--SHARED
			["All"] = "Tout",
			["Trophy"] = AF_Localize(SI_ITEMTYPE5),

			--WEAPON
			["OneHand"] = "Une Main",
			["TwoHand"] = "Deux Mains",
			["Bow"] = AF_Localize(SI_WEAPONTYPE8),
			["DestructionStaff"] = "Destruction Staff",
			["HealStaff"] = AF_Localize(SI_WEAPONTYPE9),

			["Axe"] = AF_Localize(SI_WEAPONTYPE1),
			["Sword"] = AF_Localize(SI_WEAPONTYPE3),
			["Hammer"] = AF_Localize(SI_WEAPONTYPE2),
			["2HAxe"] = "2H "..AF_Localize(SI_WEAPONTYPE1),
			["2HSword"] = "2H "..AF_Localize(SI_WEAPONTYPE3),
			["2HHammer"] = "2H "..AF_Localize(SI_WEAPONTYPE2),
			["Dagger"] = AF_Localize(SI_WEAPONTYPE11),
			["Fire"] = AF_Localize(SI_WEAPONTYPE12),
			["Frost"] = AF_Localize(SI_WEAPONTYPE13),
			["Lightning"] = AF_Localize(SI_WEAPONTYPE15),

			--ARMOR
	        ["Heavy"] = AF_Localize(SI_ARMORTYPE3),
	        ["Medium"] = AF_Localize(SI_ARMORTYPE2),
			["Light"] = AF_Localize(SI_ARMORTYPE1),
			--["Clothing"] = ,
			["Shield"] = "Boucliers",
			["Jewelry"] = "Bijoux",
			["Vanity"] = "Divers",

			["Head"] = "T\195\170te",
			["Chest"] = "Buste",
			["Shoulders"] = "Epaules",
			["Hand"] = "Mains",
			["Waist"] = "Taille",
			["Legs"] = "Jambes",
			["Feet"] = "Pieds",
			["Ring"] = "Anneaux",
			["Neck"] = "Pendentifs",

			--CONSUMABLES
			["Crown"] = AF_Localize(SI_ITEMTYPE57),
	        ["Food"] = AF_Localize(SI_ITEMTYPE4),
	        ["Drink"] = AF_Localize(SI_ITEMTYPE12),
	        ["Recipe"] = AF_Localize(SI_ITEMTYPE29),
	        ["Potion"] = AF_Localize(SI_ITEMTYPE7),
	        ["Poison"] = AF_Localize(SI_ITEMTYPE30),
	        ["Motif"] = AF_Localize(SI_ITEMTYPE8),
			["Container"] = AF_Localize(SI_ITEMTYPE18),
			["Repair"] = "R\195\169paration",

			--MATERIALS
			["Blacksmithing"] = "Forge",
			["Clothier"] = "Couture",
			["Woodworking"] = "Travail du bois",
			["Alchemy"] = "Alchimie",
			["Enchanting"] = "Enchantement",
			["Provisioning"] = "Approvisionnement",
	        ["Style"] = AF_Localize(SI_ITEMTYPE44),
	        ["WeaponTrait"] = AF_Localize(SI_ITEMTYPE46),
			["ArmorTrait"] = AF_Localize(SI_ITEMTYPE45),

			["Reagent"] = AF_Localize(SI_ITEMTYPE31),
	        ["Solvent"] = AF_Localize(SI_ITEMTYPE33),
			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			--MISCELLANEOUS
			["Glyphs"] = "Glyphs",
	        ["SoulGem"] = AF_Localize(SI_ITEMTYPE19),
			["Siege"] = AF_Localize(SI_ITEMTYPE6),
			["Bait"] = "App\195\162ts",
			["Tool"] = AF_Localize(SI_ITEMTYPE9),
			--["Fence"] = ,
			["Trash"] = AF_Localize(SI_ITEMTYPE48),

	        ["ArmorGlyph"] = AF_Localize(SI_ITEMTYPE21),
	        ["JewelryGlyph"] = AF_Localize(SI_ITEMTYPE26),
	        ["WeaponGlyph"] = AF_Localize(SI_ITEMTYPE20),
		}
	},
	["ru"] = {
		TOOLTIPS = {
			--SHARED
			["All"] = "Áce",
			["Trophy"] = AF_Localize(SI_ITEMTYPE5),

			--WEAPON
			["OneHand"] = "Oäîopóùîoe",
			["TwoHand"] = "Äáópóùîoe",
			["Bow"] = AF_Localize(SI_WEAPONTYPE8),
			["DestructionStaff"] = "Ïocox paçpóúeîèü",
			["HealStaff"] = AF_Localize(SI_WEAPONTYPE9),

			["Axe"] = AF_Localize(SI_WEAPONTYPE1),
			["Sword"] = AF_Localize(SI_WEAPONTYPE3),
			["Hammer"] = AF_Localize(SI_WEAPONTYPE2),
			["2HAxe"] = "2H "..AF_Localize(SI_WEAPONTYPE1),
			["2HSword"] = "2H "..AF_Localize(SI_WEAPONTYPE3),
			["2HHammer"] = "2H "..AF_Localize(SI_WEAPONTYPE2),
			["Dagger"] = AF_Localize(SI_WEAPONTYPE11),
			["Fire"] = AF_Localize(SI_WEAPONTYPE12),
			["Frost"] = AF_Localize(SI_WEAPONTYPE13),
			["Lightning"] = AF_Localize(SI_WEAPONTYPE15),

			--ARMOR
	        ["Heavy"] = AF_Localize(SI_ARMORTYPE3),
	        ["Medium"] = AF_Localize(SI_ARMORTYPE2),
			["Light"] = AF_Localize(SI_ARMORTYPE1),
			--["Clothing"] = ,
			["Shield"] = "Ûèò",
			["Jewelry"] = "Àèæóòepèü",
			["Vanity"] = "Paçîoe",

			["Head"] = "Âoìoáa",
			["Chest"] = "Òopc",
			["Shoulders"] = "Ïìeùè",
			["Hand"] = "Póêè",
			["Waist"] = "Ïoüc",
			["Legs"] = "Îoâè",
			["Feet"] = "Còóïîè",
			["Ring"] = "Êoìöœo",
			["Neck"] = "Úeü",

			--CONSUMABLES
			["Crown"] = AF_Localize(SI_ITEMTYPE57),
	        ["Food"] = AF_Localize(SI_ITEMTYPE4),
	        ["Drink"] = AF_Localize(SI_ITEMTYPE12),
	        ["Recipe"] = AF_Localize(SI_ITEMTYPE29),
	        ["Potion"] = AF_Localize(SI_ITEMTYPE7),
	        ["Poison"] = AF_Localize(SI_ITEMTYPE30),
	        ["Motif"] = AF_Localize(SI_ITEMTYPE8),
			["Container"] = AF_Localize(SI_ITEMTYPE18),
			["Repair"] = "Peíoîò",

			--MATERIALS
			["Blacksmithing"] = "Êóçîeùecòáo",
			["Clothier"] = "Úèòöe",
			["Woodworking"] = "Äpeáooàpaàoòêa",
			["Alchemy"] = "Aìxèíèü",
			["Enchanting"] = "Çaùapoáaîèe",
			["Provisioning"] = "Êóìèîapèü",
	        ["Style"] = AF_Localize(SI_ITEMTYPE44),
	        ["WeaponTrait"] = AF_Localize(SI_ITEMTYPE46),
			["ArmorTrait"] = AF_Localize(SI_ITEMTYPE45),

			["Reagent"] = AF_Localize(SI_ITEMTYPE31),
	        ["Solvent"] = AF_Localize(SI_ITEMTYPE33),
			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			--MISCELLANEOUS
			["Glyphs"] = "Âìè³ÿ",
	        ["SoulGem"] = AF_Localize(SI_ITEMTYPE19),
			["Siege"] = AF_Localize(SI_ITEMTYPE6),
			["Bait"] = "Îaæèáêa",
			["Tool"] = AF_Localize(SI_ITEMTYPE9),
			--["Fence"] = ,
			["Trash"] = AF_Localize(SI_ITEMTYPE48),

	        ["ArmorGlyph"] = AF_Localize(SI_ITEMTYPE21),
	        ["JewelryGlyph"] = AF_Localize(SI_ITEMTYPE26),
	        ["WeaponGlyph"] = AF_Localize(SI_ITEMTYPE20),
		}
	},
}

--Metatable trick to use english localization for german, french, russian and other values, which are missing
setmetatable(AF_Strings["de"].TOOLTIPS, {__index = AF_Strings["en"].TOOLTIPS})
setmetatable(AF_Strings["es"].TOOLTIPS, {__index = AF_Strings["en"].TOOLTIPS})
setmetatable(AF_Strings["fr"].TOOLTIPS, {__index = AF_Strings["en"].TOOLTIPS})
setmetatable(AF_Strings["ru"].TOOLTIPS, {__index = AF_Strings["en"].TOOLTIPS})
