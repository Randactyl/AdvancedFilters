local MAJOR, MINOR = "LibMotifCategories-1.0", 1
local LibMotifCategories, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if not LibMotifCategories then return end

LMC_MOTIF_CATEGORY_NORMAL = 1
LMC_MOTIF_CATEGORY_RARE = 2
LMC_MOTIF_CATEGORY_ALLIANCE = 3
LMC_MOTIF_CATEGORY_EXOTIC = 4
LMC_MOTIF_CATEGORY_DROPPED = 5
LMC_MOTIF_CATEGORY_CROWN = 6

local motifIdToItemStyleLookup = {
    ["16424"] = ITEMSTYLE_RACIAL_HIGH_ELF,
    ["16425"] = ITEMSTYLE_RACIAL_BRETON,
    ["16426"] = ITEMSTYLE_RACIAL_ORC,
    ["16427"] = ITEMSTYLE_RACIAL_REDGUARD,
    ["16428"] = ITEMSTYLE_RACIAL_WOOD_ELF,
    ["27244"] = ITEMSTYLE_RACIAL_NORD,
    ["27245"] = ITEMSTYLE_RACIAL_DARK_ELF,
    ["27246"] = ITEMSTYLE_RACIAL_ARGONIAN,
    ["44698"] = ITEMSTYLE_RACIAL_KHAJIIT,
    ["51345"] = ITEMSTYLE_ENEMY_PRIMITIVE,
    ["51565"] = ITEMSTYLE_AREA_REACH,
    ["51638"] = ITEMSTYLE_AREA_ANCIENT_ELF,
    ["51688"] = ITEMSTYLE_ENEMY_DAEDRIC,
    ["54868"] = ITEMSTYLE_RACIAL_IMPERIAL,
    ["64540"] = ITEMSTYLE_RACIAL_HIGH_ELF,
    ["64541"] = ITEMSTYLE_RACIAL_BRETON,
    ["64542"] = ITEMSTYLE_RACIAL_ORC,
    ["64543"] = ITEMSTYLE_RACIAL_REDGUARD,
    ["64544"] = ITEMSTYLE_RACIAL_WOOD_ELF,
    ["64545"] = ITEMSTYLE_RACIAL_NORD,
    ["64546"] = ITEMSTYLE_RACIAL_DARK_ELF,
    ["64547"] = ITEMSTYLE_RACIAL_ARGONIAN,
    ["64548"] = ITEMSTYLE_RACIAL_KHAJIIT,
    ["64549"] = ITEMSTYLE_ENEMY_PRIMITIVE,
    ["64550"] = ITEMSTYLE_AREA_REACH,
    ["64551"] = ITEMSTYLE_AREA_ANCIENT_ELF,
    ["64552"] = ITEMSTYLE_ENEMY_DAEDRIC,
    ["64553"] = ITEMSTYLE_AREA_DWEMER,
    ["64554"] = ITEMSTYLE_AREA_AKAVIRI,
    ["64555"] = ITEMSTYLE_AREA_YOKUDAN,
    ["64556"] = ITEMSTYLE_AREA_XIVKYN,
    ["64559"] = ITEMSTYLE_RACIAL_IMPERIAL,
    ["71765"] = ITEMSTYLE_AREA_SOUL_SHRIVEN,
}

local categoryLookup = {
    [ITEMSTYLE_RACIAL_ARGONIAN] = LMC_MOTIF_CATEGORY_NORMAL,       --Argonian
    [ITEMSTYLE_RACIAL_WOOD_ELF] = LMC_MOTIF_CATEGORY_NORMAL,       --Bosmer
    [ITEMSTYLE_RACIAL_BRETON] = LMC_MOTIF_CATEGORY_NORMAL,         --Breton
    [ITEMSTYLE_RACIAL_HIGH_ELF] = LMC_MOTIF_CATEGORY_NORMAL,       --Altmer
    [ITEMSTYLE_RACIAL_DARK_ELF] = LMC_MOTIF_CATEGORY_NORMAL,       --Dunmer
    [ITEMSTYLE_RACIAL_KHAJIIT] = LMC_MOTIF_CATEGORY_NORMAL,        --Khajiit
    [ITEMSTYLE_RACIAL_NORD] = LMC_MOTIF_CATEGORY_NORMAL,           --Nord
    [ITEMSTYLE_RACIAL_ORC] = LMC_MOTIF_CATEGORY_NORMAL,            --Orc
    [ITEMSTYLE_RACIAL_REDGUARD] = LMC_MOTIF_CATEGORY_NORMAL,       --Redguard

    [ITEMSTYLE_AREA_REACH] = LMC_MOTIF_CATEGORY_RARE,              --Barbaric
    [ITEMSTYLE_ENEMY_PRIMITIVE] = LMC_MOTIF_CATEGORY_RARE,         --Primal
    [ITEMSTYLE_ENEMY_DAEDRIC] = LMC_MOTIF_CATEGORY_RARE,           --Daedric
    [ITEMSTYLE_AREA_ANCIENT_ELF] = LMC_MOTIF_CATEGORY_RARE,        --Ancient Elf
    [ITEMSTYLE_AREA_SOUL_SHRIVEN] = LMC_MOTIF_CATEGORY_RARE,       --Soul-Shriven
    
    [ITEMSTYLE_RACIAL_IMPERIAL] = LMC_MOTIF_CATEGORY_ALLIANCE,     --Imperial
    [ITEMSTYLE_ALLIANCE_ALDMERI] = LMC_MOTIF_CATEGORY_ALLIANCE,    --Aldmeri Dominion
    [ITEMSTYLE_ALLIANCE_EBONHEART] = LMC_MOTIF_CATEGORY_ALLIANCE,  --Ebonheart Pact
    [ITEMSTYLE_ALLIANCE_DAGGERFALL] = LMC_MOTIF_CATEGORY_ALLIANCE, --Daggerfall Covenant
    
    [ITEMSTYLE_AREA_DWEMER] = LMC_MOTIF_CATEGORY_EXOTIC,           --Dwemer
    [ITEMSTYLE_AREA_XIVKYN] = LMC_MOTIF_CATEGORY_EXOTIC,           --Xivkyn
    [ITEMSTYLE_AREA_AKAVIRI] = LMC_MOTIF_CATEGORY_EXOTIC,          --Akaviri
    [ITEMSTYLE_GLASS] = LMC_MOTIF_CATEGORY_EXOTIC,                 --Glass
    [ITEMSTYLE_UNDAUNTED] = LMC_MOTIF_CATEGORY_EXOTIC,             --Mercenary
    [ITEMSTYLE_AREA_ANCIENT_ORC] = LMC_MOTIF_CATEGORY_EXOTIC,      --Ancient Orc
    [ITEMSTYLE_ORG_OUTLAW] = LMC_MOTIF_CATEGORY_EXOTIC,            --Outlaw
    [ITEMSTYLE_DEITY_TRINIMAC] = LMC_MOTIF_CATEGORY_EXOTIC,        --Trinimac
    [ITEMSTYLE_DEITY_MALACATH] = LMC_MOTIF_CATEGORY_EXOTIC,        --Malacath
    [ITEMSTYLE_ORG_THIEVES_GUILD] = LMC_MOTIF_CATEGORY_EXOTIC,     --Thieves Guild
    [ITEMSTYLE_ORG_ASSASSINS] = LMC_MOTIF_CATEGORY_EXOTIC,         --Assassins League
    [ITEMSTYLE_ORG_ABAHS_WATCH] = LMC_MOTIF_CATEGORY_EXOTIC,       --Abah's Watch
    
    [ITEMSTYLE_AREA_YOKUDAN] = LMC_MOTIF_CATEGORY_DROPPED,         --Yokudan
    [ITEMSTYLE_DEITY_AKATOSH] = LMC_MOTIF_CATEGORY_DROPPED,        --Akatosh
    [ITEMSTYLE_ENEMY_MINOTAUR] = LMC_MOTIF_CATEGORY_DROPPED,       --Minotaur
    [ITEMSTYLE_NONE] = LMC_MOTIF_CATEGORY_DROPPED,                 --Monster pieces, etc.
    [ITEMSTYLE_ORG_DARK_BROTHERHOOD] = LMC_MOTIF_CATEGORY_DROPPED, --Dark Brotherhood
    [ITEMSTYLE_AREA_REACH_WINTER] = LMC_MOTIF_CATEGORY_DROPPED,    --Reach Winter
    [ITEMSTYLE_RAIDS_CRAGLORN] = LMC_MOTIF_CATEGORY_DROPPED,       --old raid sets
    
    [ITEMSTYLE_UNIVERSAL] = LMC_MOTIF_CATEGORY_CROWN,              --Crown Mimic Stone
}

local newLookup = {
    [ITEMSTYLE_ORG_THIEVES_GUILD] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_ASSASSINS] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_ABAHS_WATCH] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_DEITY_AKATOSH] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ENEMY_MINOTAUR] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_DARK_BROTHERHOOD] = LMC_MOTIF_CATEGORY_DROPPED,
}

local styleItemIndices = {
    [ITEMSTYLE_RACIAL_ARGONIAN] = 7,      --Argonian
    [ITEMSTYLE_RACIAL_WOOD_ELF] = 9,      --Bosmer
    [ITEMSTYLE_RACIAL_BRETON] = 2,        --Breton
    [ITEMSTYLE_RACIAL_HIGH_ELF] = 8,      --Altmer
    [ITEMSTYLE_RACIAL_DARK_ELF] = 5,      --Dunmer
    [ITEMSTYLE_RACIAL_KHAJIIT] = 10,      --Khajiit
    [ITEMSTYLE_RACIAL_NORD] = 6,          --Nord
    [ITEMSTYLE_RACIAL_ORC] = 4,           --Orc
    [ITEMSTYLE_RACIAL_REDGUARD] = 3,      --Redguard
    [ITEMSTYLE_AREA_REACH] = 18,          --Barbaric
    [ITEMSTYLE_ENEMY_PRIMITIVE] = 20,     --Primal
    [ITEMSTYLE_ENEMY_DAEDRIC] = 21,       --Daedric
    [ITEMSTYLE_AREA_ANCIENT_ELF] = 16,    --Ancient Elf
    [ITEMSTYLE_AREA_SOUL_SHRIVEN] = 31,   --Soul-Shriven
    [ITEMSTYLE_RACIAL_IMPERIAL] = 35,     --Imperial
    [ITEMSTYLE_ALLIANCE_ALDMERI] = 26,    --Aldmeri Dominion
    [ITEMSTYLE_ALLIANCE_EBONHEART] = 25,  --Ebonheart Pact
    [ITEMSTYLE_ALLIANCE_DAGGERFALL] = 24, --Daggerfall Covenant
    [ITEMSTYLE_AREA_DWEMER] = 15,         --Dwemer
    [ITEMSTYLE_AREA_XIVKYN] = 30,         --Xivkyn
    [ITEMSTYLE_AREA_AKAVIRI] = 34,        --Akaviri
    [ITEMSTYLE_GLASS] = 29,               --Glass
    [ITEMSTYLE_UNDAUNTED] = 27,           --Mercenary
    [ITEMSTYLE_AREA_ANCIENT_ORC] = 23,    --Ancient Orc
    [ITEMSTYLE_ORG_OUTLAW] = 48,          --Outlaw
    [ITEMSTYLE_DEITY_TRINIMAC] = 22,      --Trinimac
    [ITEMSTYLE_DEITY_MALACATH] = 14,      --Malacath
    [ITEMSTYLE_ORG_THIEVES_GUILD] = 12,   --Thieves Guild
    [ITEMSTYLE_ORG_ASSASSINS] = 47,       --Assassins League
    [ITEMSTYLE_ORG_ABAHS_WATCH] = 42,     --Abah's Watch
    [ITEMSTYLE_UNIVERSAL] = 37,           --Crown Mimic Stone
}

local function AddRangeToMotifIdToItemStyleLookup(min, max, itemStyle)
    for motifId = min, max do
        motifIdToItemStyleLookup["\""..motifId.."\""] = itemStyle
    end
end

local function GetItemStyle(itemLink)
    local itemStyle = GetItemLinkItemStyle(itemLink)
    
    if itemStyle == ITEMSTYLE_NONE
      and GetItemLinkItemType(itemLink) == ITEMTYPE_RACIAL_STYLE_MOTIF then
        local motifId = select(4, ZO_LinkHandler_ParseLink(itemLink))
        d(motifId)
        itemStyle = motifIdToItemStyleLookup[motifId]
    elseif itemStyle == ITEMSTYLE_NONE
      and GetItemLinkItemType(itemLink) ~= ITEMTYPE_ARMOR then
        itemStyle = -1
    end
    
    return itemStyle
end

function LibMotifCategories:GetMotifCategory(itemLink)
    local itemStyle = GetItemStyle(itemLink)
    
    return categoryLookup[itemStyle]
end

function LibMotifCategories:IsNewMotif(itemLink)
    local itemStyle = GetItemStyle(itemLink)
    
    if newLookup[itemStyle] then
        return true
    end
    
    return false
end

function LibMotifCategories:IsMotifCraftable(itemLink)
    local itemStyle = GetItemStyle(itemLink)
    
    if styleItemIndices[itemStyle] then
        return true
    end
    
    return false
end

function LibMotifCategories:IsMotifKnown(itemLink)
    local itemStyle = GetItemStyle(itemLink)
    local styleItemIndex = styleItemIndices[itemStyle]
    
    if not styleItemIndex then
        return false
    end
    
    --if styleItemIndex == 37 then return true end
    
    for patternIndex = 1, 200 do
        if IsSmithingStyleKnown(styleItemIndex, patternIndex) then
            return true
        end
    end
    
    return false
end

function LibMotifCategories:IsMotifAvailable(itemLink)
    local itemStyle = GetItemStyle(itemLink)
    
    if categoryLookup[itemStyle] then
        return true
    end
    
    return false
end

function LibMotifCategories:GetFullMotifInfo(itemLink)
    local motifCategory = self:GetMotifCategory(itemLink)
    local isNew = self:IsNewMotif(itemLink)
    local isCraftable = self:IsMotifCraftable(itemLink)
    local isKnown = self:IsMotifKnown(itemLink)
    local isAvailable = self:IsMotifAvailable(itemLink)
    
    return motifCategory, isNew, isCraftable, isKnown, isAvailable
end

function LibMotifCategories:GetLocalizedCategoryName(categoryConst)
    return self.strings[categoryConst]
end

function LibMotifCategories:Initialize()
    local strings = {
        ["de"] = {
            "Normal", "Selten", "Allianz", "Exotisch", "", "Kronen",
        },
        ["en"] = {
            "Normal", "Rare", "Alliance", "Exotic", "Dropped", "Crown",
        },
        ["fr"] = {
            "Normal", "Rare", "Alliance", "Exotique", "", "Couronnes",
        },
    }
    
    local lang = GetCVar("language.2")
    
    if strings[lang] then
        self.strings = strings[lang]
    else
        self.strings = strings["en"]
    end
    
    AddRangeToMotifIdToItemStyleLookup(57572, 57586, ITEMSTYLE_AREA_DWEMER)
    AddRangeToMotifIdToItemStyleLookup(57590, 57604, ITEMSTYLE_AREA_AKAVIRI)
    AddRangeToMotifIdToItemStyleLookup(57834, 57848, ITEMSTYLE_AREA_XIVKYN)
    AddRangeToMotifIdToItemStyleLookup(64669, 64684, ITEMSTYLE_GLASS)
    AddRangeToMotifIdToItemStyleLookup(64715, 64730, ITEMSTYLE_UNDAUNTED)
    AddRangeToMotifIdToItemStyleLookup(69527, 69542, ITEMSTYLE_AREA_ANCIENT_ORC)
    AddRangeToMotifIdToItemStyleLookup(71522, 71537, ITEMSTYLE_ORG_OUTLAW)
    AddRangeToMotifIdToItemStyleLookup(71550, 71565, ITEMSTYLE_DEITY_TRINIMAC)
    AddRangeToMotifIdToItemStyleLookup(71566, 71581, ITEMSTYLE_DEITY_MALACATH)
    AddRangeToMotifIdToItemStyleLookup(71688, 71703, ITEMSTYLE_ALLIANCE_ALDMERI)
    AddRangeToMotifIdToItemStyleLookup(71704, 71719, ITEMSTYLE_ALLIANCE_DAGGERFALL)
    AddRangeToMotifIdToItemStyleLookup(71720, 71735, ITEMSTYLE_ALLIANCE_EBONHEART)
    AddRangeToMotifIdToItemStyleLookup(73838, 73853, ITEMSTYLE_ORG_MORAG_TONG)
    AddRangeToMotifIdToItemStyleLookup(73854, 73869, ITEMSTYLE_ENEMY_SKINCHANGER)
    AddRangeToMotifIdToItemStyleLookup(74539, 74554, ITEMSTYLE_ORG_ABAHS_WATCH)
    AddRangeToMotifIdToItemStyleLookup(74555, 74570, ITEMSTYLE_ORG_THIEVES_GUILD)
    AddRangeToMotifIdToItemStyleLookup(74652, 74667, ITEMSTYLE_ENEMY_DROMOTHRA)
    AddRangeToMotifIdToItemStyleLookup(75228, 75243, ITEMSTYLE_EBONY)
    AddRangeToMotifIdToItemStyleLookup(76878, 76893, ITEMSTYLE_ORG_ASSASSINS)
    AddRangeToMotifIdToItemStyleLookup(76894, 76909, ITEMSTYLE_ENEMY_DRAUGR)
end

LibMotifCategories:Initialize()

--[[
    unused item styles
    ["ITEMSTYLE_AREA_RA_GADA"] = 44
    ["ITEMSTYLE_EBONY"] = 40
    ["ITEMSTYLE_ENEMY_BANDIT"] = 18
    ["ITEMSTYLE_ENEMY_DRAUGR"] = 31
    ["ITEMSTYLE_ENEMY_DROMOTHRA"] = 45
    ["ITEMSTYLE_ENEMY_MAORMER"] = 32
    ["ITEMSTYLE_ENEMY_SKINCHANGER"] = 42
    ["ITEMSTYLE_ORG_MORAG_TONG"] = 43
    ["ITEMSTYLE_ORG_WORM_CULT"] = 38
    ["ITEMSTYLE_UNIQUE"] = 10
]]