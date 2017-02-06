local util = AdvancedFilters.util
local enStrings = AdvancedFilters.strings
local strings = {
    --SHARED
    All = "Все",
    Trophy = util.Localize(SI_ITEMTYPE5),

    --WEAPON
    OneHand = "Одноручное",
    TwoHand = "Двуручное",
    Bow = util.Localize(SI_WEAPONTYPE8),
    DestructionStaff = "Посох разрушения",
    HealStaff = util.Localize(SI_WEAPONTYPE9),

    Axe = util.Localize(SI_WEAPONTYPE1),
    Sword = util.Localize(SI_WEAPONTYPE3),
    Hammer = util.Localize(SI_WEAPONTYPE2),
    TwoHandAxe = "2H "..util.Localize(SI_WEAPONTYPE1),
    TwoHandSword = "2H "..util.Localize(SI_WEAPONTYPE3),
    TwoHandHammer = "2H "..util.Localize(SI_WEAPONTYPE2),
    Dagger = util.Localize(SI_WEAPONTYPE11),
    Fire = util.Localize(SI_WEAPONTYPE12),
    Frost = util.Localize(SI_WEAPONTYPE13),
    Lightning = util.Localize(SI_WEAPONTYPE15),

    --ARMOR
    Heavy = util.Localize(SI_ARMORTYPE3),
    Medium = util.Localize(SI_ARMORTYPE2),
    LightArmor = util.Localize(SI_ARMORTYPE1),
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
    Crown = util.Localize(SI_ITEMTYPE57),
    Food = util.Localize(SI_ITEMTYPE4),
    Drink = util.Localize(SI_ITEMTYPE12),
    Recipe = util.Localize(SI_ITEMTYPE29),
    Potion = util.Localize(SI_ITEMTYPE7),
    Poison = util.Localize(SI_ITEMTYPE30),
    Motif = util.Localize(SI_ITEMTYPE8),
    Writ = util.Localize(SI_ITEMTYPE60),
    Container = util.Localize(SI_ITEMTYPE18),
    Repair = "Ремонт",

    --MATERIALS
    Blacksmithing = "Кузнечество",
    Clothier = "Шитье",
    Woodworking = "Древообработка",
    Alchemy = "Алхимия",
    Enchanting = "Зачарование",
    Provisioning = "Кулинария",
    Style = util.Localize(SI_ITEMTYPE44),
    WeaponTrait = util.Localize(SI_ITEMTYPE46),
    ArmorTrait = util.Localize(SI_ITEMTYPE45),

    Reagent = util.Localize(SI_ITEMTYPE31),
    Solvent = util.Localize(SI_ITEMTYPE33),
    Aspect = util.Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
    Essence = util.Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
    Potency = util.Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

    --FURNISHINGS
    CraftingStation = util.Localize(SI_SPECIALIZEDITEMTYPE213),
    Light = util.Localize(SI_SPECIALIZEDITEMTYPE211),
    Ornamental = util.Localize(SI_SPECIALIZEDITEMTYPE210),
    Seating = util.Localize(SI_SPECIALIZEDITEMTYPE212),
    TargetDummy = util.Localize(SI_SPECIALIZEDITEMTYPE214),

    --MISCELLANEOUS
    Glyphs = "Глифы",
    SoulGem = util.Localize(SI_ITEMTYPE19),
    Siege = util.Localize(SI_ITEMTYPE6),
    Bait = "Наживка",
    Tool = util.Localize(SI_ITEMTYPE9),
    Fence = util.Localize(SI_INVENTORY_STOLEN_ITEM_TOOLTIP),
    Trash = util.Localize(SI_ITEMTYPE48),

    ArmorGlyph = util.Localize(SI_ITEMTYPE21),
    JewelryGlyph = util.Localize(SI_ITEMTYPE26),
    WeaponGlyph = util.Localize(SI_ITEMTYPE20),

    --JUNK
    Weapon = util.Localize(SI_ITEMFILTERTYPE1),
    Apparel = util.Localize(SI_ITEMFILTERTYPE2),
    Consumable = util.Localize(SI_ITEMFILTERTYPE3),
    Materials = util.Localize(SI_ITEMFILTERTYPE4),
    Miscellaneous = util.Localize(SI_ITEMFILTERTYPE5),

    --DROPDOWN CONTEXT MENU
    ResetToAll = "Сбросить все",
    InvertDropdownFilter = "Инверт.выпадающий фильтр",
}

setmetatable(strings, {__index = enStrings})
AdvancedFilters.strings = strings