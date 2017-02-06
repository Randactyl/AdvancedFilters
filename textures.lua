local textures = {
    All = "esoui/art/inventory/inventory_tabicon_all_%s.dds",
    Trophy = "AdvancedFilters/assets/miscellaneous/trophy/trophy_%s.dds",

    --WEAPONS
    OneHand = "AdvancedFilters/assets/weapons/onehanded_%s.dds",
    TwoHand = "AdvancedFilters/assets/weapons/twohanded_%s.dds",
    Bow = "AdvancedFilters/assets/weapons/bow_%s.dds",
    DestructionStaff = "AdvancedFilters/assets/weapons/destruction_%s.dds",
    HealStaff = "AdvancedFilters/assets/weapons/healing_%s.dds",

    --ARMOR
    Heavy = "esoui/art/icons/progression_tabicon_armorheavy_%s.dds",
    Medium = "esoui/art/icons/progression_tabicon_armormedium_%s.dds",
    LightArmor = "esoui/art/icons/progression_tabicon_armorlight_%s.dds",
    Clothing = "AdvancedFilters/assets/apparel/clothing_%s.dds",
    Shield = "AdvancedFilters/assets/apparel/shield_%s.dds",
    Jewelry = "AdvancedFilters/assets/apparel/jewelry_%s.dds",
    Vanity = "AdvancedFilters/assets/apparel/vanity_%s.dds",

    --CONSUMABLES
    Crown = "esoui/art/housing/keyboard/furniture_tabicon_crownfurnishings_%s.dds",
    Food = "AdvancedFilters/assets/consumables/food/food_%s.dds",
    Drink = "AdvancedFilters/assets/consumables/drinks/drink_%s.dds",
    Recipe = "AdvancedFilters/assets/consumables/recipes/recipe_%s.dds",
    Potion = "AdvancedFilters/assets/consumables/potion/potion_%s.dds",
    Poison = "AdvancedFilters/assets/consumables/poison/poison_%s.dds",
    Motif = "AdvancedFilters/assets/consumables/motifs/motif_%s.dds",
    Writ = "esoui/art/crafting/formulae_tabicon_%s.dds",
    Container = "AdvancedFilters/assets/consumables/containers/container_%s.dds",
    Repair = "AdvancedFilters/assets/consumables/repair/repair_%s.dds",

    --FURNISHINGS
    CraftingStation = "esoui/art/treeicons/housing_indexicon_workshop_%s.dds",
    Light = "esoui/art/treeicons/housing_indexicon_shrine_%s.dds",
    Ornamental = "esoui/art/treeicons/housing_indexicon_gallery_%s.dds",
    Seating = "esoui/art/treeicons/collection_indexicon_furnishings_%s.dds",
    TargetDummy = "esoui/art/treeicons/collection_indexicon_weapons+armor_%s.dds",

    --MATERIALS
    Blacksmithing = "esoui/art/inventory/inventory_tabIcon_Craftbag_blacksmithing_%s.dds",
    Clothier = "esoui/art/inventory/inventory_tabIcon_Craftbag_clothing_%s.dds",
    Woodworking = "esoui/art/inventory/inventory_tabIcon_Craftbag_woodworking_%s.dds",
    Alchemy = "esoui/art/inventory/inventory_tabIcon_Craftbag_alchemy_%s.dds",
    Enchanting = "esoui/art/inventory/inventory_tabIcon_Craftbag_enchanting_%s.dds",
    Provisioning = "esoui/art/inventory/inventory_tabIcon_Craftbag_provisioning_%s.dds",
    Style = "esoui/art/inventory/inventory_tabIcon_Craftbag_styleMaterial_%s.dds",
    WeaponTrait = "AdvancedFilters/assets/materials/wtrait/wtrait_%s.dds",
    ArmorTrait = "AdvancedFilters/assets/materials/atrait/atrait_%s.dds",

    --MISCELLANEOUS
    Glyphs = "AdvancedFilters/assets/miscellaneous/glyphs/glyphs_%s.dds",
    SoulGem = "AdvancedFilters/assets/miscellaneous/soulgem/soulgem_%s.dds",
    Siege = "AdvancedFilters/assets/miscellaneous/avaweapon/avaweapon_%s.dds",
    Bait = "AdvancedFilters/assets/miscellaneous/bait/bait_%s.dds",
    Tool = "AdvancedFilters/assets/consumables/repair/repair_%s.dds",
    Fence = "esoui/art/vendor/vendor_tabicon_fence_%s.dds",
    Trash = "AdvancedFilters/assets/miscellaneous/trash/trash_%s.dds",

    --JUNK
    Weapon = "esoui/art/inventory/inventory_tabIcon_weapons_%s.dds",
    Apparel = "esoui/art/inventory/inventory_tabIcon_armor_%s.dds",
    Consumable = "esoui/art/inventory/inventory_tabIcon_consumables_%s.dds",
    Materials = "esoui/art/inventory/inventory_tabIcon_crafting_%s.dds",
    Miscellaneous = "esoui/art/inventory/inventory_tabIcon_misc_%s.dds",

    --CRAFT BAG
    --BLACKSMITHING
    RawMaterial = "AdvancedFilters/assets/craftbag/smithing/rawmaterial_%s.dds",
    RefinedMaterial = "AdvancedFilters/assets/craftbag/smithing/material_%s.dds",
    Temper = "esoui/art/worldmap/map_ava_tabIcon_resourceProduction_%s.dds",

    --ALCHEMY
    Reagent = "AdvancedFilters/assets/craftbag/alchemy/reagent_%s.dds",

    --ENCHANTING
    Aspect = "esoui/art/crafting/enchantment_tabIcon_aspect_%s.dds",
    Essence = "esoui/art/crafting/enchantment_tabIcon_essence_%s.dds",
    Potency = "esoui/art/crafting/enchantment_tabIcon_potency_%s.dds",

    --PROVISIONING
    OldIngredient = "esoui/art/worldmap/map_ava_tabicon_foodfarm_%s.dds",
    RareIngredient = "esoui/art/crafting/blueprints_tabicon_%s.dds",

    --STYLE
    NormalStyle = "esoui/art/progression/progression_indexicon_race_%s.dds",
    RareStyle = "esoui/art/progression/progression_indexicon_world_%s.dds",
    AllianceStyle = "esoui/art/charactercreate/charactercreate_raceicon_%s.dds",
    ExoticStyle = "esoui/art/icons/progression_tabicon_magma_%s.dds",
}

--CLOTHING
textures.Resin = textures.Temper

--WOODWORKING
textures.Tannin = textures.Temper

--ALCHEMY
textures.Water = textures.Potion
textures.Oil = textures.Poison

--PROVISIONING
textures.FoodIngredient = textures.Food
textures.DrinkIngredient = textures.Drink

--STYLE
textures.CrownStyle = textures.Crown

AdvancedFilters.textures = textures