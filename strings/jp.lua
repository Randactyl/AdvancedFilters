local util = AdvancedFilters.util
local enStrings = AdvancedFilters.strings
local strings = {
    --SHARED
    All = "全て",
    Trophy = util.Localize(SI_ITEMTYPE5),

    --WEAPON
    OneHand = "片手武器",
    TwoHand = "両手武器",
    Bow = util.Localize(SI_WEAPONTYPE8),
    DestructionStaff = "攻撃の杖",
    HealStaff = util.Localize(SI_WEAPONTYPE9),

    Axe = util.Localize(SI_WEAPONTYPE1),
    Sword = util.Localize(SI_WEAPONTYPE3),
    Hammer = util.Localize(SI_WEAPONTYPE2),
    TwoHandAxe = "両手"..util.Localize(SI_WEAPONTYPE1),
    TwoHandSword = "両手"..util.Localize(SI_WEAPONTYPE3),
    TwoHandHammer = "両手"..util.Localize(SI_WEAPONTYPE2),
    Dagger = util.Localize(SI_WEAPONTYPE11),
    Fire = util.Localize(SI_WEAPONTYPE12),
    Frost = util.Localize(SI_WEAPONTYPE13),
    Lightning = util.Localize(SI_WEAPONTYPE15),

    --ARMOR
    Heavy = util.Localize(SI_ARMORTYPE3),
    Medium = util.Localize(SI_ARMORTYPE2),
    LightArmor = util.Localize(SI_ARMORTYPE1),
    Clothing = "鎧",
    Shield = "盾",
    Jewelry = "宝飾品",
    Vanity = "ガラクタ",

    Head = "頭",
    Chest = "胴体",
    Shoulders = "ショルダー",
    Hand = "手",
    Waist = "腰",
    Legs = "脚",
    Feet = "足",
    Ring = "指輪",
    Neck = "首",

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
    Repair = "修理",

    --MATERIALS
    Blacksmithing = "鍛冶",
    Clothier = "裁縫",
    Woodworking = "木工",
    Alchemy = "錬金術",
    Enchanting = "付呪",
    Provisioning = "調理",
    Style = util.Localize(SI_ITEMTYPE44),
    WeaponTrait = util.Localize(SI_ITEMTYPE46),
    ArmorTrait = util.Localize(SI_ITEMTYPE45),

    Reagent = util.Localize(SI_ITEMTYPE31),
    Water = util.Localize(SI_ITEMTYPE33),
    Oil = util.Localize(SI_ITEMTYPE58),
    Aspect = util.Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
    Essence = util.Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
    Potency = util.Localize(SI_ENCHANTINGRUNECLASSIFICATION3),
    FoodIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_FOOD)),
    DrinkIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_DRINK)),
    OldIngredient = zo_strformat("<<1>> - <<2>>", GetString("SI_ITEMTYPE", ITEMTYPE_INGREDIENT), GetString("SI_ITEMTYPE", ITEMTYPE_NONE)),
    RareIngredient = util.Localize(SI_SPECIALIZEDITEMTYPE48),

    --FURNISHINGS
    CraftingStation = util.Localize(SI_SPECIALIZEDITEMTYPE213),
    Light = util.Localize(SI_SPECIALIZEDITEMTYPE211),
    Ornamental = util.Localize(SI_SPECIALIZEDITEMTYPE210),
    Seating = util.Localize(SI_SPECIALIZEDITEMTYPE212),
    TargetDummy = util.Localize(SI_SPECIALIZEDITEMTYPE214),

    --MISCELLANEOUS
    Glyphs = "グリフ",
    SoulGem = util.Localize(SI_ITEMTYPE19),
    Siege = util.Localize(SI_ITEMTYPE6),
    Bait = "餌",
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
    ResetToAll = "全てリセット",
    InvertDropdownFilter = "ドロップダウンフィルタ反転",

    --LibMotifCategories
    NormalStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_NORMAL),
    RareStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_RARE),
    AllianceStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_ALLIANCE),
    ExoticStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_EXOTIC),
    DroppedStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_DROPPED),
    CrownStyle = AdvancedFilters.util.LibMotifCategories:GetLocalizedCategoryName(LMC_MOTIF_CATEGORY_CROWN),

    --CRAFT BAG
    --BLACKSMITHING
    RawMaterial = util.Localize(SI_ITEMTYPE17),
    RefinedMaterial = util.Localize(SI_ITEMTYPE36),
    Temper = util.Localize(SI_ITEMTYPE41),

    --CLOTHING
    Resin = util.Localize(SI_ITEMTYPE43),

    --WOODWORKING
    Tannin = util.Localize(SI_ITEMTYPE42),
}

setmetatable(strings, {__index = enStrings})
AdvancedFilters.strings = strings