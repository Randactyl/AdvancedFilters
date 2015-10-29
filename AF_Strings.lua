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
			["All"] = "Alle",

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

			["DestructionStaff"] = "Zerst\195\182rungsstab",
			["HealStaff"] = AF_Localize(SI_WEAPONTYPE9),
	        ["Bow"] = AF_Localize(SI_WEAPONTYPE8),
			["TwoHand"] = "Zweih\195\164ndig",
			["OneHand"] = "Einh\195\164ndig",

			["Head"] = "Kopf",
			["Chest"] = "Torso",
			["Shoulders"] = "Schultern",
			["Hand"] = "H\195\164nde",
			["Waist"] = "Taille",
			["Legs"] = "Beine",
			["Feet"] = "F\195\188ße",

			["Ring"] = "Ring",
			["Neck"] = "Hals",

			["Reagent"] = AF_Localize(SI_ITEMTYPE31),
	        ["Solvent"] = AF_Localize(SI_ITEMTYPE33),

			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			["Vanity"] = "Verkleidung",
			["Jewelry"] = "Schmuck",
			["Shield"] = "Schilde",
			["Clothing"] = "Bekleidung",
			["Light"] = AF_Localize(SI_ARMORTYPE1),
	        ["Medium"] = AF_Localize(SI_ARMORTYPE2),
	        ["Heavy"] = AF_Localize(SI_ARMORTYPE3),

			["Repair"] = "Werkzeug",
			["Container"] = AF_Localize(SI_ITEMTYPE18),
	        ["Motif"] = AF_Localize(SI_ITEMTYPE8),
	        ["Poison"] = AF_Localize(SI_ITEMTYPE30),
	        ["Potion"] = AF_Localize(SI_ITEMTYPE7),
	        ["Recipe"] = AF_Localize(SI_ITEMTYPE29),
	        ["Drink"] = AF_Localize(SI_ITEMTYPE12),
	        ["Food"] = AF_Localize(SI_ITEMTYPE4),

			["ArmorTrait"] = AF_Localize(SI_ITEMTYPE45),
	        ["WeaponTrait"] = AF_Localize(SI_ITEMTYPE46),
	        ["Style"] = AF_Localize(SI_ITEMTYPE44),
			["Provisioning"] = "Versorgen",
			["Enchanting"] = "Verzaubern",
			["Alchemy"] = "Alchemie",
			["Woodworking"] = "Schreinerei",
			["Clothier"] = "Schneiderei",
			["Blacksmithing"] = "Schmiedekunst",

			["Trophy"] = AF_Localize(SI_ITEMTYPE5),
	        ["Trash"] = AF_Localize(SI_ITEMTYPE48),
			["Fence"] = "Hehlerware",
			["Tool"] = AF_Localize(SI_ITEMTYPE9),
			["Bait"] = "K\195\182der",
			["Siege"] = AF_Localize(SI_ITEMTYPE6),
	        ["SoulGem"] = AF_Localize(SI_ITEMTYPE19),
	        ["JewelryGlyph"] = AF_Localize(SI_ITEMTYPE26),
	        ["ArmorGlyph"] = AF_Localize(SI_ITEMTYPE21),
	        ["WeaponGlyph"] = AF_Localize(SI_ITEMTYPE20),
			["Glyphs"] = "Glyphe",
		}
	},
	["en"] = {
		TOOLTIPS = {
			["All"] = "All",

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

			["DestructionStaff"] = "Destruction Staff",
			["HealStaff"] = AF_Localize(SI_WEAPONTYPE9),
			["Bow"] = AF_Localize(SI_WEAPONTYPE8),
			["TwoHand"] = "Two-Handed",
			["OneHand"] = "One-Handed",

			["Head"] = "Head",
			["Chest"] = "Chest",
			["Shoulders"] = "Shoulders",
			["Hand"] = "Hand",
			["Waist"] = "Waist",
			["Legs"] = "Legs",
			["Feet"] = "Feet",

			["Ring"] = "Ring",
			["Neck"] = "Neck",

			["Reagent"] = AF_Localize(SI_ITEMTYPE31),
			["Solvent"] = AF_Localize(SI_ITEMTYPE33),

			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			["Vanity"] = "Vanity",
			["Jewelry"] = "Jewelry",
			["Shield"] = "Shield",
			["Clothing"] = "Clothing",
			["Light"] = AF_Localize(SI_ARMORTYPE1),
			["Medium"] = AF_Localize(SI_ARMORTYPE2),
			["Heavy"] = AF_Localize(SI_ARMORTYPE3),

			["Repair"] = "Repair",
			["Container"] = AF_Localize(SI_ITEMTYPE18),
			["Motif"] = AF_Localize(SI_ITEMTYPE8),
			["Poison"] = AF_Localize(SI_ITEMTYPE30),
			["Potion"] = AF_Localize(SI_ITEMTYPE7),
			["Recipe"] = AF_Localize(SI_ITEMTYPE29),
			["Drink"] = AF_Localize(SI_ITEMTYPE12),
			["Food"] = AF_Localize(SI_ITEMTYPE4),

			["ArmorTrait"] = AF_Localize(SI_ITEMTYPE45),
			["WeaponTrait"] = AF_Localize(SI_ITEMTYPE46),
			["Style"] = AF_Localize(SI_ITEMTYPE44),
			["Provisioning"] = "Provisioning",
			["Enchanting"] = "Enchanting",
			["Alchemy"] = "Alchemy",
			["Woodworking"] = "Woodworking",
			["Clothier"] = "Clothier",
			["Blacksmithing"] = "Blacksmithing",

			["Trophy"] = AF_Localize(SI_ITEMTYPE5),
			["Trash"] = AF_Localize(SI_ITEMTYPE48),
			["Fence"] = "Fence",
			["Tool"] = AF_Localize(SI_ITEMTYPE9),
			["Bait"] = "Bait",
			["Siege"] = AF_Localize(SI_ITEMTYPE6),
			["SoulGem"] = AF_Localize(SI_ITEMTYPE19),
			["JewelryGlyph"] = AF_Localize(SI_ITEMTYPE26),
			["ArmorGlyph"] = AF_Localize(SI_ITEMTYPE21),
			["WeaponGlyph"] = AF_Localize(SI_ITEMTYPE20),
			["Glyphs"] = "Glyphs",
		}
	},
	["es"] = {
		TOOLTIPS = {
			["All"] = "Todo",

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

			["DestructionStaff"] = "Vara de destrucci\195\179n",
			["HealStaff"] = AF_Localize(SI_WEAPONTYPE9),
	        ["Bow"] = AF_Localize(SI_WEAPONTYPE8),
			["TwoHand"] = "Dos Manos",
			["OneHand"] = "Una Mano",

			["Head"] = "Cabeza",
			["Chest"] = "Pecho",
			["Shoulders"] = "Hombros",
			["Hand"] = "Manos",
			["Waist"] = "Cintura",
			["Legs"] = "Piernas",
			["Feet"] = "Pies",

			["Reagent"] = AF_Localize(SI_ITEMTYPE31),
	        ["Solvent"] = AF_Localize(SI_ITEMTYPE33),

			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			["Misc"] = "Varios",
			["Jewelry"] = "Joyas",
			["Shield"] = "Escudos",
			["Light"] = AF_Localize(SI_ARMORTYPE1),
	        ["Medium"] = AF_Localize(SI_ARMORTYPE2),
	        ["Heavy"] = AF_Localize(SI_ARMORTYPE3),

			["Repair"] = "Reparaci\195\179n",
			["Container"] = AF_Localize(SI_ITEMTYPE18),
	        ["Motif"] = AF_Localize(SI_ITEMTYPE8),
	        ["Poison"] = AF_Localize(SI_ITEMTYPE30),
	        ["Potion"] = AF_Localize(SI_ITEMTYPE7),
	        ["Recipe"] = AF_Localize(SI_ITEMTYPE29),
	        ["Drink"] = AF_Localize(SI_ITEMTYPE12),
	        ["Food"] = AF_Localize(SI_ITEMTYPE4),

			["ArmorTrait"] = AF_Localize(SI_ITEMTYPE45),
	        ["WeaponTrait"] = AF_Localize(SI_ITEMTYPE46),
	        ["Style"] = AF_Localize(SI_ITEMTYPE44),
			["Provisioning"] = "Cocina",
			["Enchanting"] = "Encantamiento",
			["Alchemy"] = "Alquimia",
			["Woodworking"] = "Carpinter\195\173a",
			["Clothier"] = "Sastrer\195\173a",
			["Blacksmithing"] = "Herrer\195\173a",

			["Trophy"] = AF_Localize(SI_ITEMTYPE5),
	        ["Trash"] = AF_Localize(SI_ITEMTYPE48),
			--["Fence"] = "",
			["Tool"] = AF_Localize(SI_ITEMTYPE9),
			["Bait"] = "Cebo",
			["Siege"] = AF_Localize(SI_ITEMTYPE6),
	        ["SoulGem"] = AF_Localize(SI_ITEMTYPE19),
	        ["JewelryGlyph"] = AF_Localize(SI_ITEMTYPE26),
	        ["ArmorGlyph"] = AF_Localize(SI_ITEMTYPE21),
	        ["WeaponGlyph"] = AF_Localize(SI_ITEMTYPE20),
			["Glyphs"] = "Glifos",
		}
	},
	["fr"] = {
		TOOLTIPS = {
			["All"] = "Tout",

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

			["DestructionStaff"] = "Destruction Staff",
			["HealStaff"] = AF_Localize(SI_WEAPONTYPE9),
			["Bow"] = AF_Localize(SI_WEAPONTYPE8),
			["TwoHand"] = "Deux Mains",
			["OneHand"] = "Une Main",

			["Head"] = "T\195\170te",
			["Chest"] = "Buste",
			["Shoulders"] = "Epaules",
			["Hand"] = "Mains",
			["Waist"] = "Taille",
			["Legs"] = "Jambes",
			["Feet"] = "Pieds",

			["Ring"] = "Anneaux",
			["Neck"] = "Pendentifs",

			["Reagent"] = AF_Localize(SI_ITEMTYPE31),
	        ["Solvent"] = AF_Localize(SI_ITEMTYPE33),

			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			["Misc"] = "Divers",
			["Jewelry"] = "Bijoux",
			["Shield"] = "Boucliers",
			["Light"] = AF_Localize(SI_ARMORTYPE1),
	        ["Medium"] = AF_Localize(SI_ARMORTYPE2),
	        ["Heavy"] = AF_Localize(SI_ARMORTYPE3),

			["Repair"] = "R\195\169paration",
			["Container"] = AF_Localize(SI_ITEMTYPE18),
	        ["Motif"] = AF_Localize(SI_ITEMTYPE8),
	        ["Poison"] = AF_Localize(SI_ITEMTYPE30),
	        ["Potion"] = AF_Localize(SI_ITEMTYPE7),
	        ["Recipe"] = AF_Localize(SI_ITEMTYPE29),
	        ["Drink"] = AF_Localize(SI_ITEMTYPE12),
	        ["Food"] = AF_Localize(SI_ITEMTYPE4),

			["ArmorTrait"] = AF_Localize(SI_ITEMTYPE45),
	        ["WeaponTrait"] = AF_Localize(SI_ITEMTYPE46),
	        ["Style"] = AF_Localize(SI_ITEMTYPE44),
			["Provisioning"] = "Approvisionnement",
			["Enchanting"] = "Enchantement",
			["Alchemy"] = "Alchimie",
			["Woodworking"] = "Travail du bois",
			["Clothier"] = "Couture",
			["Blacksmithing"] = "Forge",

			["Trophy"] = AF_Localize(SI_ITEMTYPE5),
	        ["Trash"] = AF_Localize(SI_ITEMTYPE48),
			--["Fence"] = ,
			["Tool"] = AF_Localize(SI_ITEMTYPE9),
			["Bait"] = "App\195\162ts",
			["Siege"] = AF_Localize(SI_ITEMTYPE6),
	        ["SoulGem"] = AF_Localize(SI_ITEMTYPE19),
	        ["JewelryGlyph"] = AF_Localize(SI_ITEMTYPE26),
	        ["ArmorGlyph"] = AF_Localize(SI_ITEMTYPE21),
	        ["WeaponGlyph"] = AF_Localize(SI_ITEMTYPE20),
			["Glyphs"] = "Glyphs",
		}
	},
	["ru"] = {
		TOOLTIPS = {
			["All"] = "Áce",

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

			["DestructionStaff"] = "Ïocox paçpóúeîèü",
			["HealStaff"] = AF_Localize(SI_WEAPONTYPE9),
			["Bow"] = AF_Localize(SI_WEAPONTYPE8),
			["TwoHand"] = "Äáópóùîoe",
			["OneHand"] = "Oäîopóùîoe",

			["Head"] = "Âoìoáa",
			["Chest"] = "Òopc",
			["Shoulders"] = "Ïìeùè",
			["Hand"] = "Póêè",
			["Waist"] = "Ïoüc",
			["Legs"] = "Îoâè",
			["Feet"] = "Còóïîè",

			["Ring"] = "Êoìöœo",
			["Neck"] = "Úeü",

			["Reagent"] = AF_Localize(SI_ITEMTYPE31),
	        ["Solvent"] = AF_Localize(SI_ITEMTYPE33),

			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			["Misc"] = "Paçîoe",
			["Jewelry"] = "Àèæóòepèü",
			["Shield"] = "Ûèò",
			["Light"] = AF_Localize(SI_ARMORTYPE1),
	        ["Medium"] = AF_Localize(SI_ARMORTYPE2),
	        ["Heavy"] = AF_Localize(SI_ARMORTYPE3),

			["Repair"] = "Peíoîò",
			["Container"] = AF_Localize(SI_ITEMTYPE18),
	        ["Motif"] = AF_Localize(SI_ITEMTYPE8),
	        ["Poison"] = AF_Localize(SI_ITEMTYPE30),
	        ["Potion"] = AF_Localize(SI_ITEMTYPE7),
	        ["Recipe"] = AF_Localize(SI_ITEMTYPE29),
	        ["Drink"] = AF_Localize(SI_ITEMTYPE12),
	        ["Food"] = AF_Localize(SI_ITEMTYPE4),

			["ArmorTrait"] = AF_Localize(SI_ITEMTYPE45),
	        ["WeaponTrait"] = AF_Localize(SI_ITEMTYPE46),
	        ["Style"] = AF_Localize(SI_ITEMTYPE44),
			["Provisioning"] = "Êóìèîapèü",
			["Enchanting"] = "Çaùapoáaîèe",
			["Alchemy"] = "Aìxèíèü",
			["Woodworking"] = "Äpeáooàpaàoòêa",
			["Clothier"] = "Úèòöe",
			["Blacksmithing"] = "Êóçîeùecòáo",

			["Trophy"] = AF_Localize(SI_ITEMTYPE5),
	        ["Trash"] = AF_Localize(SI_ITEMTYPE48),
			--["Fence"] = ,
			["Tool"] = AF_Localize(SI_ITEMTYPE9),
			["Bait"] = "Îaæèáêa",
			["Siege"] = AF_Localize(SI_ITEMTYPE6),
	        ["SoulGem"] = AF_Localize(SI_ITEMTYPE19),
	        ["JewelryGlyph"] = AF_Localize(SI_ITEMTYPE26),
	        ["ArmorGlyph"] = AF_Localize(SI_ITEMTYPE21),
	        ["WeaponGlyph"] = AF_Localize(SI_ITEMTYPE20),
			["Glyphs"] = "Âìè³ÿ",
		}
	},
}

--Metatable trick to use english localization for german, french, russian and other values, which are missing
setmetatable(AF_Strings["de"].TOOLTIPS, {__index = AF_Strings["en"].TOOLTIPS})
setmetatable(AF_Strings["es"].TOOLTIPS, {__index = AF_Strings["en"].TOOLTIPS})
setmetatable(AF_Strings["fr"].TOOLTIPS, {__index = AF_Strings["en"].TOOLTIPS})
setmetatable(AF_Strings["ru"].TOOLTIPS, {__index = AF_Strings["en"].TOOLTIPS})
