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
			["HealStaff"] = "Heilungsstab",
			["Bow"] = "Bogen",
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

			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			["Misc"] = "Verkleidung",
			["Jewelry"] = "Schmuck",
			["Shield"] = "Schilde",
			["Light"] = "Leichte R\195\188stung",
			["Medium"] = "Mittlere R\195\188stung",
			["Heavy"] = "Schwere R\195\188stung",

			["Repair"] = "Werkzeug",
			["Container"] = "Beh\195\164lter",
			["Motif"] = "Stil",
			["Poison"] = "Gift",
			["Potion"] = "Zaubertrank",
			["Recipe"] = "Rezept",
			["Drink"] = "Getr\195\164nk",
			["Food"] = "Nahrung",

			["ArmorTrait"] = "R\195\188stungsmerkmal",
			["WeaponTrait"] = "Waffenmerkmal",
			["Style"] = "Stilmaterial",
			["Provisioning"] = "Versorgen",
			["Enchanting"] = "Verzaubern",
			["Alchemy"] = "Alchemie",
			["Woodworking"] = "Schreinerei",
			["Clothier"] = "Schneiderei",
			["Blacksmithing"] = "Schmiedekunst",

			["Trophy"] = "Troph\195\164e",
			["Trash"] = "Plunder",
			["Tool"] = "Werkzeug",
			["Bait"] = "K\195\182der",
			["Siege"] = "Belagerungsausr\195\188stung",
			["SoulGem"] = "Seelenstein",
			["JewelryGlyph"] = "Schmuckglyphe",
			["ArmorGlyph"] = "R\195\188stungsglyphe",
			["WeaponGlyph"] = "Waffenglyphe",
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
			["Bow"] = "Bow",
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

			["Reagent"] = "Reagent",
			["Solvent"] = "Solvent",

			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			["Vanity"] = "Vanity",
			["Jewelry"] = "Jewelry",
			["Shield"] = "Shield",
			["Clothing"] = "Clothing",
			["Light"] = "Light",
			["Medium"] = "Medium",
			["Heavy"] = "Heavy",

			["Repair"] = "Repair",
			["Container"] = "Container",
			["Motif"] = "Motif",
			["Poison"] = "Poison",
			["Potion"] = "Potion",
			["Recipe"] = "Recipe",
			["Drink"] = "Drink",
			["Food"] = "Food",

			["ArmorTrait"] = "Armor Trait",
			["WeaponTrait"] = "Weapon Trait",
			["Style"] = "Style",
			["Provisioning"] = "Provisioning",
			["Enchanting"] = "Enchanting",
			["Alchemy"] = "Alchemy",
			["Woodworking"] = "Woodworking",
			["Clothier"] = "Clothier",
			["Blacksmithing"] = "Blacksmithing",

			["Trophy"] = "Trophy",
			["Trash"] = "Trash",
			["Fence"] = "Fence",
			["Tool"] = "Tool",
			["Bait"] = "Bait",
			["Siege"] = "Siege",
			["SoulGem"] = "Soul Gem",
			["JewelryGlyph"] = "Jewelry Glyph",
			["ArmorGlyph"] = "Armor Glyph",
			["WeaponGlyph"] = "Weapon Glyph",
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
			["Bow"] = "Arcos",
			["TwoHand"] = "Dos Manos",
			["OneHand"] = "Una Mano",

			["Head"] = "Cabeza",
			["Chest"] = "Pecho",
			["Shoulders"] = "Hombros",
			["Hand"] = "Manos",
			["Waist"] = "Cintura",
			["Legs"] = "Piernas",
			["Feet"] = "Pies",

			["Ring"] = "Anillos",
			["Neck"] = "Amuletos",

			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			["Misc"] = "Varios",
			["Jewelry"] = "Joyas",
			["Shield"] = "Escudos",
			["Light"] = "Ligera",
			["Medium"] = "Media",
			["Heavy"] = "Pesada",

			["Repair"] = "Reparaci\195\179n",
			["Container"] = "Contenedores",
			["Motif"] = "Motivos",
			["Poison"] = "Veneno",
			["Potion"] = "Pociones",
			["Recipe"] = "Recetas",
			["Drink"] = "Bebidas",
			["Food"] = "Comida",

			["ArmorTrait"] = "Rasgos de armadura",
			["WeaponTrait"] = "Rasgos de arma",
			["Style"] = "Estilo",
			["Provisioning"] = "Cocina",
			["Enchanting"] = "Encantamiento",
			["Alchemy"] = "Alquimia",
			["Woodworking"] = "Carpinter\195\173a",
			["Clothier"] = "Sastrer\195\173a",
			["Blacksmithing"] = "Herrer\195\173a",

			["Trophy"] = "Trofeos",
			["Trash"] = "Basura",
			["Tool"] = "Herramientas",
			["Bait"] = "Cebo",
			["Siege"] = "Asedio",
			["SoulGem"] = "Piedras de Alma",
			["JewelryGlyph"] = "Glifos para joyas",
			["ArmorGlyph"] = "Glifos para armaduras",
			["WeaponGlyph"] = "Glifos para armas",
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
			["Bow"] = "Arcs",
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

			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			["Misc"] = "Divers",
			["Jewelry"] = "Bijoux",
			["Shield"] = "Boucliers",
			["Light"] = "L\195\169g\195\168re",
			["Medium"] = "Interm\195\169diaire",
			["Heavy"] = "Lourde",

			["Repair"] = "R\195\169paration",
			["Container"] = "Conteneurs",
			["Motif"] = "Motif",
			["Poison"] = "Poisons",
			["Potion"] = "Potions",
			["Recipe"] = "Recettes",
			["Drink"] = "Boissons",
			["Food"] = "Nourriture",

			["ArmorTrait"] = "Traits d'armure",
			["WeaponTrait"] = "Traits d'arme",
			["Style"] = "Style",
			["Provisioning"] = "Approvisionnement",
			["Enchanting"] = "Enchantement",
			["Alchemy"] = "Alchimie",
			["Woodworking"] = "Travail du bois",
			["Clothier"] = "Couture",
			["Blacksmithing"] = "Forge",

			["Trophy"] = "Troph\195\169es",
			["Trash"] = "Rebuts",
			["Tool"] = "Tool",
			["Bait"] = "App\195\162ts",
			["Siege"] = "Si\195\168ge",
			["SoulGem"] = "Pierres d'\195\162me",
			["JewelryGlyph"] = "Glyphes de bijou",
			["ArmorGlyph"] = "Glyphes d'armure",
			["WeaponGlyph"] = "Glyphes d'arme",
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
			["Bow"] = "Ìóê",
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

			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			["Misc"] = "Paçîoe",
			["Jewelry"] = "Àèæóòepèü",
			["Shield"] = "Ûèò",
			["Light"] = "Ìeâêaü",
			["Medium"] = "Cpeäîüü",
			["Heavy"] = "Òüæeìaü",

			["Repair"] = "Peíoîò",
			["Container"] = "Êoîòeéîep",
			["Motif"] = "Íoòèá",
			["Poison"] = "Üä",
			["Potion"] = "Çeìöe",
			["Recipe"] = "Peœeïò",
			["Drink"] = "Îaïèòoê",
			["Food"] = "Eäa",

			["ArmorTrait"] = "Ocoàeîîocòè àpoîè",
			["WeaponTrait"] = "Ocoàeîîocòè opóæèü",
			["Style"] = "Còèìö",
			["Provisioning"] = "Êóìèîapèü",
			["Enchanting"] = "Çaùapoáaîèe",
			["Alchemy"] = "Aìxèíèü",
			["Woodworking"] = "Äpeáooàpaàoòêa",
			["Clothier"] = "Úèòöe",
			["Blacksmithing"] = "Êóçîeùecòáo",

			["Trophy"] = "Òpo³eé",
			["Trash"] = "Íócop",
			["Tool"] = "Èîcòpóíeîò",
			["Bait"] = "Îaæèáêa",
			["Siege"] = "Ocaäîoe opóäèe",
			["SoulGem"] = "Êaíeîö äóú",
			["JewelryGlyph"] = "Ôáeìèpîÿé âìè³",
			["ArmorGlyph"] = "Äocïeúîÿé âìè³",
			["WeaponGlyph"] = "Opóæeéîÿé âìè³",
			["Glyphs"] = "Âìè³ÿ",
		}
	},
}

--Metatable trick to use english localization for german, french, russian and other values, which are missing
setmetatable(AF_Strings["de"].TOOLTIPS, {__index = AF_Strings["en"].TOOLTIPS})
setmetatable(AF_Strings["es"].TOOLTIPS, {__index = AF_Strings["en"].TOOLTIPS})
setmetatable(AF_Strings["fr"].TOOLTIPS, {__index = AF_Strings["en"].TOOLTIPS})
setmetatable(AF_Strings["ru"].TOOLTIPS, {__index = AF_Strings["en"].TOOLTIPS})