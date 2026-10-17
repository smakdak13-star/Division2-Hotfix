-- ============================================================
--  TD2 MERGED SCRIPT
--  Merge of org.lua + td2.lua with fixes.
--
--  NOTE ON BONE RIG:
--    This merge uses the NEWER humanoid rig (td2.lua indices).
--    If your build uses the OLDER rig (org.lua indices), swap the
--    PLAYER_HUMANOID / NPC_HUMANOID blocks below.
-- ============================================================
 
-- ============================================================
--  SHARED RVA / OFF
-- ============================================================
local RVA = {
    rlclient    = 0x6D755E0,
    viewmatrix  = 0x6D75A70,
    recoil      = 0x642C638,
    spread      = 0x642C634,
    setnoon     = 0x6F10F2E,
    setnight    = 0x6F10F2F,
    magicbullet = 0x6424001,
}
 
local OFF = {
    pClient      = 0x130,
    pObject      = 0x28,
 
    entityArray  = 0x508,
    entityCount  = 0x510,
    entityPos    = 0x80,
    localStage0  = 0x340,
    localStage1  = 0x10,
    localStage2  = 0x30,
    viewProj     = 0x450,
    bonesBase    = 0x220,
    boneArray    = 0x170,
    entityType   = 0x228,
    entityName   = 0x438,
 
    relation     = 0x250,
    isDowned     = 0x3B8,
    hpPtr        = 0x7D0,
    health       = 0x5C,
    healthMax    = 0x60,
    -- Armor lives INSIDE the HP component (hpPtr + off), not on the entity.
    -- Values verified against TD2-Dumper (github.com/KushKoyote/TD2-Dumper):
    --   OFF_agentarmor     = 0x254 / agentarmorMax   = 0x258 (players)
    --   OFF_npcArmor       = 0x1C4 / npcArmorMax     = 0x1C8 (NPCs + props)
    agentarmorInHp     = 0x254,
    agentarmorMaxInHp  = 0x258,
    npcArmorInHp       = 0x1C4,
    npcArmorMaxInHp    = 0x1C8,
    -- Weak-point props (boss backpacks / propane tanks) are NOT agents: they
    -- use a lighter HealthComponent whose armor/shield fields sit at smaller
    -- offsets inside the same hpPtr block. Reading these lets us detect when
    -- a prop is still shielded (hits absorbed by armor -> hp never drops ->
    -- silent aim would otherwise hold the lock forever).
    wpArmor            = 0x30,
    wpArmorMax         = 0x34,
    factionCtx   = 0x3E0,
 
    entityTypeInt = 0xC00,
    factionTag   = 0x18,
    aimCtrl      = 0x848,
    worldAimPos  = 0x3AA8,
 
    npcDescriptorPtr   = 0x6D0,
    npcAgentDescriptor = 0x20,
    npcArchetypeOffset = 0x188,
    npcTierOffset      = 0x184,
 
    name             = 0x438,
    -- Local-player armor fields (verified on the LOCAL PLAYER structure only;
    -- these offsets are meaningless on NPC entity pointers).
    agentarmor       = 0x254,
    agentarmorMax    = 0x258,
    weapPtr0         = 0x718,
    weapPtr1         = 0x38,
    weapPtr2         = 0x10,
    rpmFinal         = 0x264,
 
    reloadField      = 0x3B18,
    combatAimClipSizeCached    = 0x3ADC,
    combatAimRoundsFired       = 0x3AE8,
    combatAimCurrentSpread     = 0x3B3C,
 
    combatAimWeaponDataPtr     = 0x3A78,
    combatAimSpreadRadius      = 0x424C,
    combatAimAccuracyLocked    = 0x3C38,
    combatAimFireInterval      = 0x3BC8,
    combatAimMoveSpreadAdd     = 0x3840,
    combatAimLerpedMoveSpeed   = 0x3844,
 
    weapTemplateDamageMin      = 0x40,
    weapTemplateDamageMax      = 0x44,
    weapTemplateDmgMultHead    = 0xA0,
    weapTemplateSwayMinH       = 0x2B8,
    weapTemplateSwayMaxH       = 0x2BC,
    weapTemplateSwayMinV       = 0x2C0,
    weapTemplateSwayMaxV       = 0x2C4,
    weapTemplateSwayResetDur   = 0x2C8,
    weapTemplateScopeSwaySpeed = 0x2D0,
    weapTemplateRange          = 0x4C,
}
 
local BONE_STRIDE  = 0x40
local BONE_POS_OFF = 0x30
 
local ENTITY_TYPE_GADGET = -1
local ENTITY_TYPE_NPC    =  5
local ENTITY_TYPE_PLAYER =  6
 
local NPC_ARCHETYPE = {
    Unset=0, Assault=1, Rusher=2, Thrower=3, Sniper=4, Controller=5,
    HeavyWeapons=6, Tank=7, Support=8, Medic=9, Engineer=10,
    Turret=11, StaticTurret=12, RPG=13, Immobilizer=14, Bomber=15,
    Flamer=16, Disruptor=17, Shield=18,
    DroneSuicide=19, DroneTaser=20, DroneRevive=21,
    MiniTank=22, BigDog=23, BigDogConvoy=24, DroneHelicopter=25,
    Hunter=26, LootGoblin=27, Bodyguard=28, Leader=29,
    ChemicalDrone=30, Special=31, Civilian=32,
    Dog=33, Raven=34, Rat=35, Pigeon=36, Seagull=37,
    SeekerMine=38, SupportStation=39, Crow=40, Raccoon=41,
    Squirrel=42, Fox=43, Rabbit=44, Eagle=45, Vulture=46,
    DestructibleProp=47, Cat=48, RCCar=49, RCBlade=50, Firefly=51,
    FemaleDeer=52, MaleDeer=53, Monkey=54, Flamingo=55, Crocodile=56,
    Parrot=57, CatLoco=58, RatLoco=59, JumperCar=60,
    DroneBomb=61, MGStationary=62, RogueAgent=63, DroneOperator=64,
    BigDogGrenadier=65, BigDogMinigun=66, SeagullLoco=67, SquirrelLoco=68,
    SkillDeploymentBox=69, Trap=70, Hive=71, Decoy=72, TurretCleaners=73,
    AssaultDrone=74, BigDogFlamer=75, DogCompanion=76, SmartCover=77,
    BigDogMortar=78, BigDogSmall=79,
}
 
local NPC_THREAT_TIER = { Boss=0, Heavy=1, Standard=2, Skill=3, NonThreat=4 }
 
local ARCHETYPE_NAME_BY_ID = {}
for k, v in pairs(NPC_ARCHETYPE) do ARCHETYPE_NAME_BY_ID[v] = k end
 
local ARCHETYPE_WHITELIST_GLOBAL = {}
for _, k in ipairs({
    "Unset","DestructibleProp","Civilian",
    "Dog","Raven","Rat","Pigeon","Seagull","Crow","Raccoon","Squirrel",
    "Fox","Rabbit","Eagle","Vulture","Cat",
    "FemaleDeer","MaleDeer","Monkey","Flamingo","Crocodile","Parrot",
    "CatLoco","RatLoco","SeagullLoco","SquirrelLoco",
}) do ARCHETYPE_WHITELIST_GLOBAL[NPC_ARCHETYPE[k]] = true end
 
local ARCHETYPE_WHITELIST_GADGET = {}
for _, k in ipairs({
    "Turret","StaticTurret","MGStationary","TurretCleaners",
    "ChemicalDrone","DroneSuicide","DroneTaser","DroneRevive",
    "DroneBomb","AssaultDrone","SeekerMine","Trap","Hive",
    "SupportStation","SkillDeploymentBox","RCCar","RCBlade","Firefly",
    "JumperCar","Decoy","SmartCover","DogCompanion",
}) do ARCHETYPE_WHITELIST_GADGET[NPC_ARCHETYPE[k]] = true end
 
local ARCHETYPE_COMBATANT = {}
for _, k in ipairs({
    "Assault","Rusher","Thrower","Sniper","Controller","HeavyWeapons",
    "Tank","Support","Medic","Engineer","RPG","Immobilizer","Bomber",
    "Flamer","Disruptor","Shield","Hunter","LootGoblin","Bodyguard",
    "Leader","Special","RogueAgent","DroneOperator",
    "BigDog","BigDogConvoy","BigDogGrenadier","BigDogMinigun",
    "BigDogFlamer","BigDogMortar","BigDogSmall","MiniTank",
    "DroneSuicide","DroneTaser","DroneRevive","DroneBomb","AssaultDrone",
    "SeekerMine","ChemicalDrone","Turret","StaticTurret","MGStationary",
    "TurretCleaners",
}) do ARCHETYPE_COMBATANT[NPC_ARCHETYPE[k]] = true end
 
local function lc(s)
    return (s:gsub("%u", function(c) return c:lower() end))
end
 
local NON_COMBATANT_NAME_PARTS = {}
for _, n in ipairs({
    "box","crate","canister","barrel","container","loot","supply",
    "yellow box","resource","cache","stash","drop","package","briefcase",
    "helicopter","chopper","drone carrier","extraction","balloon",
    "destructible","prop","barrier","cover","sandbag","barricade",
    "generator","antenna","terminal","console","vending",
}) do NON_COMBATANT_NAME_PARTS[#NON_COMBATANT_NAME_PARTS + 1] = n end
 
local function name_is_blacklisted(name)
    if not name or name == "" then return false end
    local ln = lc(name)
    for _, pat in ipairs(NON_COMBATANT_NAME_PARTS) do
        if ln:find(pat, 1, true) then return true end
    end
    return false
end
 
local BONE_PROFILES = {
 
    PLAYER_HUMANOID = {
        indices     = {0, 2, 4, 7, 8, 10, 15, 16, 17, 45, 46, 47, 79, 80, 84, 87, 88, 92},
        connections = {
            {8,7},{7,4},{4,2},
            {4,15},{15,16},{16,17},
            {4,45},{45,46},{46,47},
            {2,84},{84,79},{79,80},
            {2,92},{92,87},{87,88},
        },
        aim_bone = 8, aim_bone_fallback = 7,
        expected = 104, is_humanoid = true,
    },
    NPC_HUMANOID = {
        indices     = {0, 2, 4, 6, 8, 9, 14, 15, 17, 44, 45, 47, 78, 79, 83, 86, 87, 91},
        connections = {
            {8,6},{6,4},{4,2},
            {4,14},{14,15},{15,17},
            {4,44},{44,45},{45,47},
            {2,83},{83,78},{78,79},
            {2,91},{91,86},{86,87},
        },
        aim_bone = 8, aim_bone_fallback = 8,
        expected = 104, is_humanoid = true,
    },
    BIG_DOG = {
        indices     = {0, 2, 7, 8, 9, 14, 15, 16, 25, 30, 31, 32, 33, 36, 37, 38, 39},
        connections = {
            {9,8},{8,7},{7,2},
            {16,15},{15,14},{14,2},
            {39,38},{38,37},{37,36},{36,2},
            {33,32},{32,31},{31,30},{30,2},
            {2,25},
        },
        aim_bone = 7, aim_bone_fallback = 2,
        expected = 0, is_humanoid = false,
    },
    WARHOUND_GRENADIER = {
        indices     = {0, 2, 7, 8, 9, 16, 17, 18, 27, 38, 39, 40, 41, 45, 46, 47, 48},
        connections = {
            {9,8},{8,7},{7,2},
            {18,17},{17,16},{16,2},
            {41,40},{40,39},{39,38},{38,2},
            {48,47},{47,46},{46,45},{45,2},
            {2,27},
        },
        aim_bone = 7, aim_bone_fallback = 2,
        expected = 0, is_humanoid = false,
    },
    WARHOUND_MINIGUN = {
        indices     = {0, 2, 7, 8, 9, 16, 17, 18, 27, 34, 35, 36, 37, 40, 41, 42, 44},
        connections = {
            {9,8},{8,7},{7,2},
            {18,17},{17,16},{16,2},
            {44,42},{42,41},{41,40},{40,2},
            {37,36},{36,35},{35,34},{34,2},
            {2,27},
        },
        aim_bone = 7, aim_bone_fallback = 2,
        expected = 0, is_humanoid = false,
    },
    MINITANK = {
        indices     = {0,1,7,8,13,14,15,16,22,23,28,29,31,33,35,37},
        connections = {
            {0,1},{1,7},{7,13},{1,8},{8,14},
            {0,16},{16,22},{22,28},{16,23},{23,29},
            {31,33},{33,35},{33,37},
            {1,31},{16,31},
        },
        aim_bone = 31, aim_bone_fallback = 0,
        expected = 40, is_humanoid = false,
    },
    ITEM = {
        indices     = {},
        connections = {},
        aim_bone = nil, aim_bone_fallback = nil,
        expected = 0, is_humanoid = false,
    },
    NO_SKELETON = {
        indices     = {},
        connections = {},
        aim_bone = nil, aim_bone_fallback = nil,
        expected = 0, is_humanoid = false,
    },
}
 
local ARCHETYPE_PROFILE = {}
for _, k in ipairs({
    "Assault","Rusher","Thrower","Sniper","Controller","HeavyWeapons",
    "Tank","Support","Medic","Engineer","RPG","Immobilizer","Bomber",
    "Flamer","Disruptor","Shield","Hunter","LootGoblin","Bodyguard",
    "Leader","Special","Civilian","RogueAgent","DroneOperator",
}) do ARCHETYPE_PROFILE[NPC_ARCHETYPE[k]] = "NPC_HUMANOID" end
for _, k in ipairs({
    "BigDog","BigDogConvoy","BigDogFlamer","BigDogMortar","BigDogSmall",
    "DogCompanion",
}) do ARCHETYPE_PROFILE[NPC_ARCHETYPE[k]] = "BIG_DOG" end
ARCHETYPE_PROFILE[NPC_ARCHETYPE.BigDogGrenadier] = "WARHOUND_GRENADIER"
ARCHETYPE_PROFILE[NPC_ARCHETYPE.BigDogMinigun]   = "WARHOUND_MINIGUN"
ARCHETYPE_PROFILE[NPC_ARCHETYPE.MiniTank] = "MINITANK"
 
local LEGACY_BONE_NAMES = {
    PLAYER_HUMANOID  = { head=8, chest=7, belly=4, root=2,
                         l_shoulder=15, r_shoulder=45, l_arm=16, r_arm=46,
                         l_hand=17, r_hand=47,
                         l_knee=79, r_knee=87, l_heel=80, r_heel=88,
                         l_toe=84, r_toe=92 },
    NPC_HUMANOID     = { head=8, chest=6, belly=4, root=2,
                         l_shoulder=14, r_shoulder=44, l_arm=15, r_arm=45,
                         l_hand=17, r_hand=47,
                         l_knee=78, r_knee=86, l_heel=79, r_heel=87,
                         l_toe=83, r_toe=91 },
    BIG_DOG            = { root=0, pelvis=2, chest=7, head=9, top=9 },
    WARHOUND_GRENADIER = { root=0, pelvis=2, chest=7, head=9, top=9 },
    WARHOUND_MINIGUN   = { root=0, pelvis=2, chest=7, head=9, top=9 },
    MINITANK         = { head=31, chest=33, belly=33, root=0,
                         l_top=31, r_top=35, l_front=1, r_front=16,
                         middle=33, top=37 },
    ITEM             = { root=0 },
}
 
local ALL_BONE_IDS_SPARSE = {
    0, 1, 2, 4, 6, 7, 8, 9, 13, 14, 15, 16, 17, 18,
    22, 23, 25, 27, 28, 29, 30, 31, 32, 33, 34, 35,
    36, 37, 38, 39, 40, 41, 42, 44, 45, 46, 47, 48,
    78, 79, 80, 83, 84, 86, 87, 88, 91, 92,
}

-- Weak-point (backpack / propane / turret battery) entities: in TD2 these are
-- NOT bones of the boss rig. They spawn as separate lightweight entities.
-- Detection rules (in order):
--   1. explicit destructible archetypes (DestructibleProp/Trap/Hive);
--   2. entity name matches a known prop keyword;
--   3. GADGET-type entity whose descriptor chain cannot be resolved to a
--      real archetype (player skill gadgets ALWAYS resolve to a known
--      archetype id; boss props keep archetype Unset(0) or nil);
--   4. NEW fallback: any entity that has NO readable descriptor chain at all
--      but DOES own a valid HP component with hp_max in a sane range. This
--      catches props even when entityTypeInt@0xC00 reads as garbage/0, which
--      is why weak points previously were never found.
-- IMPORTANT: the keywords below are matched as LOWERCASE SUBSTRINGS against
-- the entity name.  That is why short/ambiguous fragments like "gas", "tank",
-- "med", "ammo", "car" used to misfire constantly: an NPC named e.g.
-- "StaticTurretBase" contains "turret"... but worse, ANY prop whose name
-- merely CONTAINS one of those fragments (or a humanoid enemy archetype that
-- shares the fragment) got classified as a weak point and the aim wrote the
-- crosshair onto its feet.  Every keyword is now either a full distinctive
-- word or an unambiguous compound; matching additionally requires the hit to
-- be a WORD BOUNDARY start (see wp_name_has_keyword) so "tanker"/"target" no
-- longer match "tank".
local WEAK_POINT_NAME_HINTS = {
    "backpack", "propane", "canister", "cylinder",
    "explosive", "weakpoint", "weak_point", "weak point", "vulnerable",
    "battery", "reactor", "fuel",
    "barrel", "oxygen", "acetylene", "valve",
    "generator", "transformer", "pylon", "charge",
    -- removed ambiguous fragments: "gas" (matches "gasmask"), "tank"
    -- (matches "tanker"), "med" (matches "medium"), "ammo" alone is kept
    -- only as "ammoload"/"ammo_" compounds below, "car" (matches "cargo"),
    -- "core" (matches "score"/"arcade"), "vent", "console", "junction",
    -- "support", "supply", "loader", "purifier", "heal" -> see tiers
}
for _, extra in ipairs({ "ammoload", "ammo_crate", "fuel tank", "fueltank",
                         "gas can", "gascan", "propane tank" }) do
    WEAK_POINT_NAME_HINTS[#WEAK_POINT_NAME_HINTS + 1] = extra
end

local WEAK_POINT_ARCHETYPES = {}
for _, k in ipairs({ "DestructibleProp", "Trap", "Hive" }) do
    WEAK_POINT_ARCHETYPES[NPC_ARCHETYPE[k]] = true
end

-- Per-archetype weak-point keyword table (The Division 2).
-- Bosses / named enemies on Legendary + Raid difficulty carry destructible
-- gadgets that must be destroyed before their armor becomes breakable:
--   True Son bosses (General Cross, "Gator", Commander Hyena crew leaders):
--       healing backpacks ("backpack", "purifier", "med")
--   Cleaners leaders (Lucas "Sadie" Oliveira, Pest engineers):
--       flamethrower fuel tanks ("flam", "fuel", "tank", "propane")
--   Black Tusk elite / Exo supports (Riley's Washington, BNT task force):
--       exo backpacks / generator packs ("generator", "exo", "battery")
--   Dark Zone / Manhunt raid props:
--       explosive barrels & car traps ("barrel", "explosive", "car")
-- Keys are matched as lowercase substrings against the entity NAME of a
-- gadget/prop entity; a hit boosts its priority tier and tags it with a
-- human-readable kind so silent aim locks the RIGHT prop first.
local WEAK_POINT_KEYWORD_TIERS = {
    -- tier A: heals/shields the boss -> kill FIRST
    { tier = 1, label = "HEALER",
      keys = { "backpack", "purifier", "medkit", "med_bag", "heal",
               "dronebay", "supply", "ammoload", "ammo_crate" } },
    -- tier B: big damage source (flamethrower tank, exo pack, generator)
    { tier = 2, label = "FUEL",
      keys = { "flamethrower", "fuel", "propane", "gascan", "gas_can",
               "canister", "cylinder", "acetylene", "oxygen", "barrel",
               "tank", "generator", "reactor", "battery", "transformer" } },
    -- tier C: anything else explicitly destructible/explosive
    { tier = 3, label = "EXPLOSIVE",
      keys = { "explosive", "weakpoint", "weak_point", "weak point",
               "vulnerable", "charge", "hive", "trap" } },
}

-- Word-boundary keyword matcher.  ln:find(k, 1, true) matches ANYWHERE inside
-- a word, which is why "tank" used to hit names like "TankerNPC" /
-- "StaticTurret..." style props and the aim locked onto random objects near
-- NPC feet.  Here a keyword only counts when it starts at a non-alphanumeric
-- boundary (start of name, after _, space, or any punctuation) AND ends at a
-- non-alphanumeric boundary too ("tank" hits "boss_tank_01" but not "tanker").
local function wp_name_has_keyword(ln, k)
    local from = 1
    while true do
        local s, e = ln:find(k, from, true)
        if not s then return false end
        local before = (s == 1) and "" or ln:sub(s - 1, s - 1)
        local after  = (e == #ln) and "" or ln:sub(e + 1, e + 1)
        local ok_l = (before == "") or not before:match("%w")
        local ok_r = (after == "")  or not after:match("%w")
        -- allow '_' as a separator on both sides (snake_case entity names)
        if before ~= "_" and before:match("%w") then ok_l = false end
        if after ~= "_" and after:match("%w") then ok_r = false end
        if ok_l and ok_r then return true end
        from = s + 1
    end
end

local function classify_weak_point(e)
    -- returns tier, label  (tier 0 = no keyword match but still a prop)
    local name = e.ent_name
    if name and name ~= "" then
        local ln = lc(name)
        -- check tiers in priority order; "barrel" is BOTH a fuel container and
        -- an explosive drum -> the higher-priority tier (lower number) wins so
        -- the scan stays deterministic regardless of key iteration order.
        for _, grp in ipairs(WEAK_POINT_KEYWORD_TIERS) do
            for _, k in ipairs(grp.keys) do
                if wp_name_has_keyword(ln, k) then return grp.tier, grp.label end
            end
        end
    end
    return 0, "PROP"
end

-- The entity position in TD2 is the object's ORIGIN, which for many props is
-- at their FEET (e.g. a propane "tank" prop whose origin sits on the ground
-- under it). Silent aim must write the actual damage volume center instead.
--
-- IMPORTANT: hp_max is HIT POINTS, not physical meters — the previous version
-- treated it as a box height ("lift = 0.55 * hp_max"), which produced garbage
-- offsets (a 900-HP tank got clamped to the max, a 3-HP prop got the min) and
-- aimed at random spots near the ground / NPC legs. Now the vertical lift is
-- derived ONLY from the prop kind (name keywords), with fixed sane ranges:
--   * floor-standing cylinders/tanks/generators: body center ~0.7 m up;
--   * wall/console/pylon objects: ~1.0 m;
--   * vehicles: ~0.8 m;
--   * small carried props (backpacks are usually read at torso height): no
--     lift unless clearly a ground prop;
--   * unknown props: default 0.5 m (origin of most gadgets is already the
--     volume center, so a small lift is safe).
-- state.wp_aim_lift is a user-adjustable multiplier (UI slider, default 1.0)
-- so the exact height can be calibrated in-game via the yellow crosshair
-- marker without editing the script.
local WP_LIFT_TABLE = {
    -- { min = lower bound of lift, max = upper bound, def = default lift }
    CYLINDER = { min = 0.20, max = 1.60, def = 0.70 }, -- tank/barrel/canister/propane
    WALL     = { min = 0.20, max = 2.20, def = 1.00 }, -- generator/console/reactor/pylon
    VEHICLE  = { min = 0.20, max = 1.80, def = 0.80 }, -- car/truck/van
    SMALL    = { min = 0.00, max = 0.60, def = 0.00 }, -- backpack/medkit/ammo (torso pos)
    DEFAULT  = { min = 0.00, max = 1.50, def = 0.50 },
}

local WP_LIFT_KEYWORDS = {
    { kind = "CYLINDER", keys = { "tank", "barrel", "canister", "cylinder",
        "propane", "gascan", "acetylene", "oxygen", "flamethrower", "fuel" } },
    { kind = "WALL", keys = { "generator", "transformer", "pylon",
        "battery", "reactor" } },
    { kind = "VEHICLE", keys = { "truck", "van", "sedan", "suv",
        "vehicle", "bus" } },
    { kind = "SMALL", keys = { "backpack", "medkit", "heal", "supply",
        "ammoload", "ammo_crate", "purifier", "dronebay" } },
}

local function weak_point_lift_kind(name)
    if not name or name == "" then return "DEFAULT" end
    local ln = lc(name)
    for _, grp in ipairs(WP_LIFT_KEYWORDS) do
        for _, k in ipairs(grp.keys) do
            if wp_name_has_keyword(ln, k) then return grp.kind end
        end
    end
    return "DEFAULT"
end

local function weak_point_aim_offset(e)
    local kind = weak_point_lift_kind(e.ent_name)
    local cfg = WP_LIFT_TABLE[kind] or WP_LIFT_TABLE.DEFAULT
    local base = cfg.def
    -- carried/healing props sit ON the boss: the entity origin of a backpack
    -- is typically already at torso height -> never lift those blindly
    if kind == "SMALL" then base = 0.0 end
    local mult = tonumber(state.wp_aim_lift) or 1.0
    local dy = base * mult
    if dy < cfg.min then dy = cfg.min end
    if dy > cfg.max then dy = cfg.max end
    return dy
end

local function aim_point_for_weak_point(e)
    local p = e.pos
    return { p[1], p[2] + weak_point_aim_offset(e), p[3] }
end

local function name_looks_like_weak_point(name)
    if not name or name == "" then return false end
    local ln = lc(name)
    for _, hint in ipairs(WEAK_POINT_NAME_HINTS) do
        if wp_name_has_keyword(ln, hint) then return true end
    end
    for _, grp in ipairs(WEAK_POINT_KEYWORD_TIERS) do
        for _, k in ipairs(grp.keys) do
            if wp_name_has_keyword(ln, k) then return true end
        end
    end
    return false
end

-- CRITICAL GUARD: a real agent (humanoid soldier, dog, boss) is NEVER a weak
-- point, no matter what its name contains.  Previous versions matched name
-- keywords against NPC names too ("AssaultTank", "Medic", "SupportBackpack"
-- style names), which made silent aim treat the whole AGENT as a prop: the
-- aim point became entityPos + small lift = the NPC's FEET/legs.  That is the
-- exact bug reported ("aims at legs / who knows where").  Only entities whose
-- type is GADGET/unknown (i.e. NOT ENTITY_TYPE_NPC / PLAYER) may qualify via
-- name heuristics; explicit destructible archetypes still pass.
local WEAK_POINT_AGENT_TYPES = {}
for _, t in ipairs({ ENTITY_TYPE_NPC, ENTITY_TYPE_PLAYER }) do
    WEAK_POINT_AGENT_TYPES[t] = true
end

local function is_agent_entity(e)
    if WEAK_POINT_AGENT_TYPES[e.entity_type_int] then return true end
    if e.entity_type ~= nil and WEAK_POINT_AGENT_TYPES[e.entity_type] then
        return true
    end
    -- readable combat archetype id => it is an agent, not a loose prop
    if e.archetype ~= nil and e.archetype > 0
       and ARCHETYPE_NAME_BY_ID[e.archetype] then
        return true
    end
    return false
end

local function is_weak_point_entity(e)
    if not e or e.is_player then return false end
    -- props are never "downed" agents; keep the guard anyway so corpses of
    -- NPCs can't be mistaken for weak points via the fallback rules below
    if e.is_downed then return false end
    if e.archetype ~= nil and WEAK_POINT_ARCHETYPES[e.archetype] then
        return true
    end
    -- AGENT GUARD: real NPCs/players (type 5/6 or readable combat archetype)
    -- must NEVER be classified as weak points by name heuristics.  Without
    -- this, a boss named "...Tank..." or a medic with a backpack in its name
    -- became a "prop", aim_point_for fell back to entityPos+lift and silent
    -- aim put the crosshair on the NPC's legs — exactly the misaim that was
    -- reported.
    if is_agent_entity(e) then return false end
    if name_looks_like_weak_point(e.ent_name) then return true end
    if e.entity_type_int == ENTITY_TYPE_GADGET then
        if e.archetype == nil or e.archetype == NPC_ARCHETYPE.Unset then
            return true
        end
    elseif e.archetype == nil then
        -- No readable descriptor chain. If it also owns a valid HP component
        -- it is a destructible prop, not an agent (agents always expose an
        -- archetype through NpcAgentDescriptor).
        if e.has_hp and e.hp_max > 0 and e.hp_max <= 2000000 then
            return true
        end
    end
    return false
end

-- Final safety gate used by the SILENT AIM path only (ESP may still draw every
-- prop).  A weak point must be either a real gadget/prop entity type OR expose
-- no agent archetype, AND must not be positioned exactly like a standing NPC
-- we can see bones for.  If an entity passed the name heuristics but actually
-- has a full skeleton with readable bones, it IS an agent -> refuse to treat
-- it as a prop so we never aim at someone's legs.
local function silent_accepts_weak_point(e)
    if not is_weak_point_entity(e) then return false end
    local b = e.bones
    if type(b) == "table" then
        local n = 0
        for _ in pairs(b) do n = n + 1 end
        -- real agents expose dozens of bones; destructible props expose none
        -- (bone read fails).  If we DO see a skeleton on this "prop", it is an
        -- NPC -> never aim at its entityPos (legs); let the normal head/body
        -- path handle it instead.
        if n >= 5 then return false end
    end
    return true
end

-- A weak point counts as a live silent-aim target while it still has health.
-- Props with an armor/shield layer are NOT filtered out here (a wrong armor
-- offset would make every prop look shielded and the aimbot would never see
-- them); instead the stall watchdog in wp_watchdog releases the lock when HP
-- refuses to drop while we keep firing at the prop.
local function is_alive_weak_point(e)
    if not is_weak_point_entity(e) then return false end
    if not e.has_hp then return true end          -- no HP info: assume shootable
    if e.hp <= 0 then return false end
    -- NOTE: we intentionally do NOT skip props that still have armor/shield.
    -- Reading a wrong offset would make every prop look "shielded" and the
    -- aimbot would silently refuse to target any of them (this was the exact
    -- reason weak points were never found before). Shielded props are handled
    -- by the stall watchdog instead: if HP refuses to drop while we keep
    -- firing, the prop is temporarily ignored and the aim moves on.
    return true
end
 
local ALL_BONE_IDS_0_90 = {}
for i = 0, 90 do ALL_BONE_IDS_0_90[#ALL_BONE_IDS_0_90 + 1] = i end
 
local DEFAULT_RECOIL   = 30.0
local DEFAULT_SPREAD   = 4.0
local MAGIC_BULLET_OFF = 0x98
local MAGIC_BULLET_ON  = 0xFF
local RPM_MIN          = 60
local RPM_MAX          = 3000
 
local BATCH_MAX_ENTRIES = 256
local BATCH_MAX_BYTES   = 4096
 
local TRANSITION_FRAMES       = 120
local MIN_OVERLAP_CHECK_COUNT = 4
local SILENT_LOCK_DELTA       = 2.0
-- pixels of "screen distance" bonus for the already-locked weak point, so the
-- aim keeps holding the same prop until it is destroyed instead of flitting
-- between several backpacks/tanks that are closer to the crosshair
local SILENT_WP_STICK_BONUS   = 500.0
-- watchdog: if the locked prop's HP did not move while we kept firing at it,
-- release the lock for a while (invulnerable / wrong hit surface) so silent
-- aim can move on to other weak points or the head
local WP_STALL_LIMIT          = 3
local WP_IGNORE_SECONDS       = 8.0
 
local LOCK_ID = {
    silent     = 10001,
    recoil     = 10002,
    spread_rva = 10003,
    spread_a1  = 10004,
    spread_a2  = 10005,
}
 
local ESP_PREDICT_STRENGTH = 0.7
local TURRET_BOX_HEIGHT_OFFSET = 1.3
 
local DEFAULT_EXTENDED_RANGE = 100.0
 
local ROBOT_NAME_PROFILE = {
    { "minitank",          "MINITANK" },
    { "mini tank",         "MINITANK" },
    { "warhound minigun",  "WARHOUND_MINIGUN" },
    { "warhound grenadier","WARHOUND_GRENADIER" },
    { "warhound",          "WARHOUND_GRENADIER" },
    { "war hound",         "WARHOUND_GRENADIER" },
    { "bigdog",            "BIG_DOG" },
    { "big dog",           "BIG_DOG" },
    { "canine",            "BIG_DOG" },
    { "war dog",           "BIG_DOG" },
}
 
local ITEM_NAME_PATTERNS = {
    "battery", "power cell", "powercell", "fuel cell", "fuelcell",
    "energy cell", "capacitor", "reactor", "core",
    "keycard", "key card", "access card", "id card", "badge",
    "intel", "document", "datapad", "hard drive", "harddrive",
    "usb", "disk", "tape", "recording",
    "medkit", "med kit", "first aid", "bandage", "antiviral", "vaccine",
    "ration", "ammo box", "ammo crate",
    "shd tech", "shd cache", "shd node", "satellite", "relay",
    "beacon", "transmitter", "receiver", "uplink",
    "objective", "marker", "waypoint", "checkpoint",
    "supply drop", "airdrop", "cache drop",
}
 
local function name_looks_like_item(name)
    if not name or name == "" then return false end
    local ln = lc(name)
    for _, pat in ipairs(ITEM_NAME_PATTERNS) do
        if ln:find(pat, 1, true) then return true end
    end
    return false
end
 
local ARCHETYPE_IS_DRONE = {}
for _, k in ipairs({
    "DroneSuicide","DroneTaser","DroneRevive","DroneBomb","AssaultDrone",
    "ChemicalDrone","DroneHelicopter","SeekerMine",
}) do ARCHETYPE_IS_DRONE[NPC_ARCHETYPE[k]] = true end
 
local ARCHETYPE_IS_DOG = {}
for _, k in ipairs({
    "BigDog","BigDogConvoy","BigDogFlamer","BigDogMortar","BigDogSmall",
    "BigDogGrenadier","BigDogMinigun","DogCompanion",
}) do ARCHETYPE_IS_DOG[NPC_ARCHETYPE[k]] = true end
 
local ARCHETYPE_IS_TURRET = {}
for _, k in ipairs({
    "Turret","StaticTurret","MGStationary","TurretCleaners",
    "SupportStation","SkillDeploymentBox",
}) do ARCHETYPE_IS_TURRET[NPC_ARCHETYPE[k]] = true end
 
local ARCHETYPE_IS_GADGET = {}
for _, k in ipairs({
    "RCCar","RCBlade","Firefly","JumperCar",
    "Trap","Hive","Decoy","SmartCover",
}) do ARCHETYPE_IS_GADGET[NPC_ARCHETYPE[k]] = true end
 
local function name_looks_like_robot(name)
    if not name or name == "" then return false end
    local ln = lc(name)
    for _, pair in ipairs(ROBOT_NAME_PROFILE) do
        if ln:find(pair[1], 1, true) then return true end
    end
    return false
end
 
local function profile_name_for(e)
    if e.is_player then return "PLAYER_HUMANOID" end
 
    if e.archetype ~= nil then
        if ARCHETYPE_IS_DRONE[e.archetype] then return "DRONE" end
        if ARCHETYPE_IS_TURRET[e.archetype] then return "TURRET" end
        local p = ARCHETYPE_PROFILE[e.archetype]
        if p then return p end
    end
 
    if e.ent_name and e.ent_name ~= "" and name_looks_like_item(e.ent_name) then
        return "ITEM"
    end
 
    if e.archetype ~= nil then return "NO_SKELETON" end
 
    return "NPC_HUMANOID"
end
 
local state

-- Forward declarations (definitions further below). Needed so that the
-- weak-point helpers can be used by functions defined earlier in the file.
local aim_point_for
local should_show
 
local function get_color(e)
    if is_weak_point_entity(e) then return {255, 200, 0} end
    if e.is_player then
        if e.relation == "hostile" then return {255, 140, 25} end
        return {51, 102, 255}
    end
    if e.is_low_hp then return {128, 128, 128} end
    if e.relation == "hostile"  then return {255, 38, 38} end
    if e.relation == "friendly" then return {25, 230, 51} end
    if e.relation == "neutral"  then return {255, 255, 80} end
    return {180, 80, 255}
end
 
-- Kept for diagnostics/back-compat; the actual two-stage selection happens
-- inside find_silent_target (weak points vs. regular targets are collected
-- separately and never mixed into one score).
local function aimbot_priority(e)
    if is_weak_point_entity(e) then return 2 end
    if e.entity_type_int == ENTITY_TYPE_GADGET then return 1 end
    return 0
end
 
local function is_silent_target(e)
    if not e or e.is_player or e.is_downed then return false end

    -- weak-point props: lightweight gadget entities. They classify as
    -- "friendly" via the normal pipeline, so they must bypass relation /
    -- archetype filtering here, otherwise the aimbot never sees them.
    -- IMPORTANT: only accept it as a PROP when silent_accepts_weak_point
    -- confirms there is no real skeleton on it; otherwise fall through to the
    -- regular NPC path below so we aim at head/chest bones instead of the
    -- entity origin (which sits at the NPC's feet -> shots into legs).
    if is_weak_point_entity(e) and silent_accepts_weak_point(e) then
        if not state.weak_points_first then return false end
        if not is_alive_weak_point(e) then return false end
        -- props whose HP refused to drop while locked are temporarily ignored
        -- (likely invulnerable / wrong hit position), so the aimbot can move
        -- on to other weak points or the head instead of stalling forever
        local until_t = state.wp_ignored[e.entity_ptr]
        if until_t and os.clock() < until_t then return false end
        return true
    end
    -- NOTE: player-deployed gadgets (turrets/skills, ARCHETYPE_IS_GADGET) are
    -- intentionally NOT silent targets anymore; only real NPC types pass the
    -- filter below. Boss backpacks/tanks still reach this function through
    -- the is_weak_point_entity branch above.
    if e.is_summoned then
        if e.relation == "hostile" then
            if not state.silent_target_summon then return false end
        else
            return false
        end
    end
    if e.entity_type ~= ENTITY_TYPE_NPC then return false end
 
    local pname = profile_name_for(e)
    if pname ~= "TURRET" and pname ~= "BIG_DOG"
       and pname ~= "WARHOUND_GRENADIER" and pname ~= "WARHOUND_MINIGUN"
       and pname ~= "MINITANK"
       and name_is_blacklisted(e.ent_name) then
        return false
    end
 
    if pname == "TURRET" then return true end
    if pname == "ITEM" then return false end
    -- own deployed skills/gadgets are never valid targets (their relation is
    -- friendly/neutral and the check below catches them; hostile enemy
    -- summons stay targetable when the toggle is on)
    if e.relation == "friendly" or e.relation == "neutral" then return false end
 
    if e.archetype ~= nil then
        if ARCHETYPE_WHITELIST_GLOBAL[e.archetype] then return false end
        if ARCHETYPE_COMBATANT[e.archetype] then return true end
        if ARCHETYPE_WHITELIST_GADGET[e.archetype] then return true end
    end
 
    if e.relation == "unknown" and name_looks_like_robot(e.ent_name) then
        return true
    end
    if e.relation == "unknown"
       and (pname == "DRONE" or pname == "TURRET"
            or pname == "BIG_DOG" or pname == "WARHOUND_GRENADIER"
            or pname == "WARHOUND_MINIGUN" or pname == "MINITANK") then
        return true
    end
    return e.relation == "hostile"
end
 
state = {
    name = "TheDivision2.exe",
    pid  = 0,
    base = 0,
    status = "Ready",
    scan_info   = "",
    stats_timer = 0,
    walk_skip   = 0,
 
    esp_enabled       = false,
    esp_boxes         = true,
    esp_snaplines     = false,
    esp_distance      = false,
    esp_bones         = false,
    esp_bone_ids      = false,
    esp_type          = false,
    esp_name          = false,
    esp_show_hostile  = true,
    esp_show_friendly = false,
    esp_show_neutral  = false,
    esp_show_player   = false,
    esp_show_other    = false,
    esp_show_relation = false,
    esp_show_faction  = false,
    esp_desc_test     = false,
    esp_show_silent_fov = false,
    esp_max_dist      = 200,
    entities          = {},
    local_pos         = {0, 0, 0},
    viewproj          = nil,
    viewproj_source   = "unavailable",
    window_rect       = nil,
    wr_timer          = 0,
    attach_timer      = 0,
 
    _last_arr_ptr      = 0,
    _last_count        = 0,
    _last_ptrs         = nil,
    _prev_pos_by_ptr   = nil,
    _was_attached      = false,
    _stable_frames     = 0,
    _transition_frames = 0,
 
    _weapon_ptr          = 0,
    _weapon_gen          = 0,
    _weapon_lp           = 0,
    _weapon_cached_frame = -1,
    _weapon_fingerprint  = nil,
    weapon_max_damage = nil,
    weapon_max_damage_frame = -1000,
 
    aim_part        = "head",
    target_gadgets  = true,
    weak_points_first = true,
    wp_aim_lift     = 1.0,   -- multiplier for weak-point vertical aim lift (m)
 
    silent_enabled       = false,
    silent_target_summon = true,
    silent_fov           = 150,
    silent_max_dist      = 300,
    silent_target_name   = "",
    silent_last_rounds   = 0,
    silent_fired         = false,
    silent_lock_addr     = nil,
    silent_shots         = 0,
    silent_armed         = false,
    silent_seen_gen      = 0,
    silent_target_ptr    = nil,
    wp_seen_count        = 0,
    wp_destroyed         = 0,
    wp_lock_start_hp     = 0,
    wp_lock_ptr          = nil,
    wp_lock_prev_hp      = nil,
    wp_lock_stall        = 0,
    wp_last_shots        = 0,
    wp_ignore_until      = 0,
    wp_ignored           = {},
    last_shot_rounds     = 0,
    last_shot_aim        = nil,
    last_shot_pos        = nil,
    last_shot_name       = "",
    hit_debug            = "",
 
    diag_last_write = nil,
 
    telem_valid       = false,
    telem_world_aim   = nil,
    telem_lock_target = nil,
    telem_delta       = nil,
    telem_rounds      = 0,
    telem_lock_addr   = nil,
 
    dbg_lp_pos        = nil,
    dbg_bone0         = nil,
    dbg_err           = nil,
 
    lp_name   = "",
    hp        = 0,
    hp_max    = 0,
    armor     = 0,
    armor_max = 0,
 
    no_recoil      = false,
    recoil_locked  = false,
    no_spread      = false,
    spread_rva_locked  = false,
    spread_aim_addrs   = nil,
    magic_bullet   = false,
    instant_reload = false,
    accuracy_locked = false,
    fast_fire = false,
    high_headshot_dmg = false,
    headshot_dmg_multiplier = 3.0,
    high_headshot_dmg_addr = nil,
    high_headshot_dmg_original = nil,
    accuracy_locked_addr = nil,
    accuracy_locked_original = nil,
    fast_fire_addr = nil,
    fast_fire_original = nil,
    rpm_enabled    = false,
    rpm_value      = 600,
    rpm_original   = nil,
    rpm_live       = 0.0,
    rpm_seen_gen   = 0,
 
    no_sway        = false,
    sway_saved     = {
        min_h = nil, max_h = nil, min_v = nil, max_v = nil,
        reset_dur = nil, scope_speed = nil,
    },
    no_sway_live   = 0.0,
    sway_seen_gen  = 0,
 
    extended_range = false,
    extended_range_live = nil,
    ext_seen_gen   = 0,
 
    move_speed     = false,
    move_speed_live= nil,
    move_spread_add_live = nil,
    move_seen_gen  = 0,
 
    master_enabled  = true,
    master_snapshot = nil,
    time_mode      = "normal",
    read_rva       = "0x642C638",
    read_size      = 16,
    read_result    = "",
}
 
local CFG_PREFIX = "td2."
local ONE_SHOT_APPLIES = {}
 
local PERSIST_KEYS = {
    "name",
    "esp_enabled", "esp_boxes", "esp_snaplines", "esp_distance",
    "esp_bones", "esp_bone_ids", "esp_type", "esp_name",
    "esp_show_hostile", "esp_show_friendly", "esp_show_neutral",
    "esp_show_player", "esp_show_other", "esp_show_relation",
    "esp_show_faction", "esp_desc_test", "esp_max_dist", "esp_show_silent_fov",
    "silent_enabled", "silent_target_summon", "silent_fov",
    "silent_max_dist", "aim_part",
    "target_gadgets", "weak_points_first", "wp_aim_lift",
    "no_recoil", "no_spread", "magic_bullet", "no_sway", "move_speed",
    "extended_range", "instant_reload",
    "accuracy_locked", "fast_fire", "high_headshot_dmg", "headshot_dmg_multiplier",
    "rpm_enabled", "rpm_value", "time_mode", "master_enabled",
}
 
local function write_cfg_to_memory()
    if not config then return false, "Config API unavailable" end
    for _, k in ipairs(PERSIST_KEYS) do
        local v = state[k]
        if type(v) == "boolean" or type(v) == "number" or type(v) == "string" then
            pcall(config.set, CFG_PREFIX .. k, v)
        end
    end
    return true
end
 
local function read_cfg_into_state()
    if not config then return false, "Config API unavailable" end
    for _, k in ipairs(PERSIST_KEYS) do
        local ok, v = pcall(config.get, CFG_PREFIX .. k, nil)
        if ok and v ~= nil then state[k] = v end
    end
    return true
end
 
local function cfg_save()
    local ok, err = write_cfg_to_memory()
    if not ok then state.status = "Save failed: " .. tostring(err); return end
    if config and config.save then
        local sok, serr = pcall(config.save)
        if not sok then state.status = "Save failed: " .. tostring(serr); return end
    end
    state.status = "Config saved"
end
 
local function cfg_load()
    local ok, err = read_cfg_into_state()
    if not ok then state.status = "Load failed: " .. tostring(err); return end
    for k, fn in pairs(ONE_SHOT_APPLIES) do
        if state[k] then pcall(fn) end
    end
    state.status = "Config loaded"
end
 
local function cfg_overwrite()
    local ok, err = write_cfg_to_memory()
    if not ok then state.status = "Overwrite failed: " .. tostring(err); return end
    if config and config.save then
        local sok, serr = pcall(config.save)
        if not sok then state.status = "Overwrite failed: " .. tostring(serr); return end
    end
    state.status = "Config overwritten"
end
 
local to_f32, from_f32
if string.pack and string.unpack then
    to_f32 = function(v) return string.unpack("<I4", string.pack("<f", v)) end
    from_f32 = function(b) return string.unpack("<f", string.pack("<I4", b)) end
else
    to_f32 = function(value)
        if value == 0 then return 0 end
        local sign = 0
        if value < 0 then sign = 0x80000000; value = -value end
        local mantissa, exponent = math.frexp(value)
        local biased = exponent + 126
        if biased <= 0 then return sign end
        if biased >= 255 then return sign + 0x7F800000 end
        return sign + biased * 0x800000 + math.floor((mantissa * 2 - 1) * 0x800000 + 0.5)
    end
    from_f32 = function(bits)
        if bits >= 0x80000000 then return -from_f32(bits - 0x80000000) end
        local exponent = math.floor(bits / 0x800000)
        local mantissa = bits % 0x800000
        if exponent == 255 then return 0 end
        if exponent == 0 then return math.ldexp(mantissa / 0x800000, -126) end
        return math.ldexp(1 + mantissa / 0x800000, exponent - 127)
    end
end
 
local function uint_from(bytes, off, n)
    local v = 0
    for i = off + n - 1, off, -1 do v = v * 256 + (bytes[i] or 0) end
    return v
end
 
local function parse_f32_array(data, count)
    local m = {}
    for i = 1, count do m[i] = from_f32(uint_from(data, (i - 1) * 4 + 1, 4)) end
    return m
end
 
local function vec_dist(a, b)
    local dx, dy, dz = a[1] - b[1], a[2] - b[2], a[3] - b[3]
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end
 
local function is_finite(v)
    return v == v and v ~= math.huge and v ~= -math.huge
end
 
local function assert_attached()
    if state.pid == 0 or state.base == 0 then error("not attached") end
end
 
local function to_byte_table(raw)
    if type(raw) == "string" then
        local n = #raw
        local t = {}
        for i = 1, n do t[i] = string.byte(raw, i) end
        return t, n
    elseif type(raw) == "table" then
        return raw, #raw
    end
    return {}, 0
end
 
local function pad_to(t, n)
    for i = #t + 1, n do t[i] = 0 end
    return t
end
 
local function read_bytes_table(addr, n)
    local raw = memory.read_bytes(state.pid, addr, n)
    local t, len = to_byte_table(raw)
    if len < n then pad_to(t, n) end
    return t, len
end
 
local function read_uint(addr, n)
    local data = read_bytes_table(addr, n)
    return uint_from(data, 1, n)
end
 
local function write_uint(addr, value, n)
    local bytes = {}
    for i = 1, n do bytes[i] = value % 256; value = math.floor(value / 256) end
    memory.write_bytes(state.pid, addr, bytes)
end
 
local function is_hostile_archetype(a)
    if ARCHETYPE_WHITELIST_GLOBAL[a] then return false end
    return true
end
 
local function read_faction_template_tag(faction_ptr)
    local raw, len = read_bytes_table(faction_ptr + OFF.factionTag, 16)
    if len < 16 then return "" end
    local chars = {}
    for i = 1, 16 do
        local b = raw[i]
        if b == 0 then break end
        if b < 0x20 or b >= 0x7F then return "" end
        chars[#chars + 1] = string.char(b)
    end
    return table.concat(chars)
end
 
local ENEMY_FACTION_TAGS = {
    ["legendary"] = "Legendary Black Tusk",
    ["endgame"]   = "Black Tusk",
    ["blackbloc"] = "Hyenas",
    ["ambushers"] = "Wanderers",
    ["militia"]   = "True Sons",
    ["rikers"]    = "Rikers",
    ["cleaners"]  = "Cleaners",
    ["cultists"]  = "Outcasts",
}
 
local function enemy_tag_entry(tag)
    if not tag or tag == "" then return nil end
    return ENEMY_FACTION_TAGS[string.lower(tag)]
end
 
local function faction_display(fac, tag)
    local name = enemy_tag_entry(tag)
    if name then return name end
    if tag and tag ~= "" then return tag end
    return string.format("fac:0x%X", fac)
end
 
local faction_display_en = faction_display
 
local RELATION_HOSTILE  = {0xBF, 0x06, 0x3D, 0x2C, 0x0F, 0xC0, 0x16, 0x0C}
local RELATION_FRIENDLY = {0x0D, 0x56, 0x38, 0xF4, 0x20, 0x76, 0x01, 0x00}
local RELATION_NEUTRAL  = {0xA4, 0x46, 0x88, 0x82, 0x54, 0xF0, 0x03, 0x00}
 
local function match_relation(raw, off, pattern)
    for i = 1, 8 do
        if raw[off + i] ~= pattern[i] then return false end
    end
    return true
end
 
local function classify_pipeline(e, ctx)
    local etype = e.entity_type_int
    if etype == ENTITY_TYPE_NPC or etype == ENTITY_TYPE_GADGET then
        -- destructible weak-point props (boss backpacks / fuel tanks) often
        -- carry the boss's faction id; without this early-exit the faction
        -- check below marks them "friendly" and silent aim never sees them
        if is_weak_point_entity(e) then return "hostile" end
        if e.tier_valid and e.tier == NPC_THREAT_TIER.NonThreat then
            return "friendly"
        end
        local a = e.archetype
        if a == nil then a = NPC_ARCHETYPE.Unset end
        if not is_hostile_archetype(a) then return "friendly" end
    end
 
    if ctx.local_faction ~= 0 and e.faction ~= 0 then
        if etype == ENTITY_TYPE_GADGET and not state.target_gadgets then
            return "friendly"
        end
            local tag = ctx.tag_cache[e.faction]
            if tag == nil then
                tag = read_faction_template_tag(e.faction)
                if tag ~= "" then
                    ctx.tag_cache[e.faction] = tag
                end
            end
        if tag == "PlayerServices" or tag == "Staff" then return "friendly" end
        if e.faction ~= ctx.local_faction then return "hostile" end
        return "friendly"
    end
 
    return "unknown"
end
 
local function classify_entity(e, ctx)
    if ctx.local_player == 0 then return "unknown" end
    if enemy_tag_entry(e.faction_tag) then return "hostile" end
 
    local classified = classify_pipeline(e, ctx)
 
    if not e.is_player then
        if classified == "unknown" then
            if e.rel_verdict then return e.rel_verdict end
        elseif e.rel_verdict and classified == "hostile"
               and (e.rel_verdict == "friendly" or e.rel_verdict == "neutral") then
            return e.rel_verdict
        end
        return classified
    end
 
    return classified
end
 
local function batch_read_chunked(pid, stride, addrs)
    local n = #addrs
    if n == 0 then return {} end
 
    local per_call = math.min(BATCH_MAX_ENTRIES, math.floor(BATCH_MAX_BYTES / stride))
    if per_call < 1 then return {} end
 
    local out = {}
    local i = 1
    while i <= n do
        local last = math.min(i + per_call - 1, n)
        local sub = {}
        for k = i, last do sub[#sub + 1] = addrs[k] end
        local expect = #sub * stride
 
        local data, dlen = to_byte_table(memory.batch_read(pid, stride, sub))
        if dlen == 0 then
            for _ = 1, expect do out[#out + 1] = 0 end
        else
            if dlen < expect then pad_to(data, expect) end
            for b = 1, expect do out[#out + 1] = data[b] end
        end
        i = last + 1
    end
    return out
end
 
local function read_f32(addr) return from_f32(read_uint(addr, 4)) end
local function write_f32(addr, value) write_uint(addr, to_f32(value), 4) end
local function pack_f32(value)
    local bits = to_f32(value)
    local out = {}
    for i = 1, 4 do out[i] = bits % 256; bits = math.floor(bits / 256) end
    return out
end
 
local function read_sd_string(addr)
    local hdr = read_bytes_table(addr, 32)
    if #hdr < 32 then return "" end
    local size = uint_from(hdr, 17, 8)
    if size == 0 or size > 128 then return "" end
    local bytes
    local cap = uint_from(hdr, 25, 8)
    if cap <= 15 then
        bytes = {}
        for i = 1, size do bytes[i] = hdr[i] end
    else
        local ptr = uint_from(hdr, 1, 8)
        if ptr == 0 then return "" end
        bytes = read_bytes_table(ptr, size)
    end
    local chars = {}
    for i = 1, size do chars[i] = string.char(bytes[i] or 0) end
    return table.concat(chars)
end
 
local WALK_SKIP_COOLDOWN = 120
 
local function safe_walk(pid, base, offsets)
    if state.walk_skip > 0 then return 0 end
    local ok, res = pcall(memory.traverse_pointer_chain, pid, base, offsets)
    if not ok then
        state.walk_skip = WALK_SKIP_COOLDOWN
        state.status = "Pointer walk: " .. tostring(res) ..
                       " (cooldown " .. WALK_SKIP_COOLDOWN .. ")"
        return 0
    end
    return res or 0
end
 
local function get_localplayer()
    return safe_walk(state.pid, state.base, {
        RVA.rlclient, OFF.pClient, OFF.pObject,
        OFF.localStage0, OFF.localStage1, OFF.localStage2,
    })
end
 
local function resolve_rpm_target(lp)
    if lp == 0 then return 0 end
    local w1 = read_uint(lp + OFF.weapPtr0, 8)
    if w1 == 0 then return 0 end
    local w2 = read_uint(w1 + OFF.weapPtr1, 8)
    if w2 == 0 then return 0 end
    return read_uint(w2 + OFF.weapPtr2, 8)
end
 
local function read_npc_archetype_and_tier(ent)
    if not OFF.npcDescriptorPtr then return nil, nil end
    local agent = read_uint(ent + OFF.npcDescriptorPtr, 8)
    if agent == 0 then return nil, nil end
    local desc = read_uint(agent + OFF.npcAgentDescriptor, 8)
    if desc == 0 then return nil, nil end
    local a_raw = read_uint(desc + OFF.npcArchetypeOffset, 4)
    local t_raw = read_uint(desc + OFF.npcTierOffset, 4)
    local archetype = (a_raw < 80) and a_raw or nil
    local tier      = (t_raw < 5)  and t_raw or nil
    return archetype, tier
end
 
local TEST_DESC = { hop1 = 0x6D0, hop2 = 0x20, arch = 0x188, tier = 0x184 }
local function test_read_desc_chain(ent)
    local agent = read_uint(ent + TEST_DESC.hop1, 8)
    if agent == 0 then return nil, nil end
    local desc = read_uint(agent + TEST_DESC.hop2, 8)
    if desc == 0 then return nil, nil end
    return read_uint(desc + TEST_DESC.arch, 4), read_uint(desc + TEST_DESC.tier, 4)
end
 
local _frame_id = 0
 
local function refresh_weapon_cache(force)
    if not force and state._weapon_cached_frame == _frame_id then
        return
    end
    state._weapon_cached_frame = _frame_id
 
    local lp = get_localplayer()
    state._weapon_lp = lp
 
    if lp == 0 then
        if state._weapon_ptr ~= 0 then
            state._weapon_ptr = 0
            state._weapon_gen = state._weapon_gen + 1
        end
        state._weapon_fingerprint = nil
        return
    end
 
    local w3 = resolve_rpm_target(lp)
    if w3 == 0 then
        if state._weapon_ptr ~= 0 then
            state._weapon_ptr = 0
            state._weapon_gen = state._weapon_gen + 1
        end
        state._weapon_fingerprint = nil
        return
    end
 
    local rpm_bits = read_uint(w3 + OFF.rpmFinal, 4)
    if not rpm_bits or rpm_bits == 0 then return end
    local fingerprint = rpm_bits
 
    if w3 ~= state._weapon_ptr then
        state._weapon_ptr = w3
        state._weapon_gen = state._weapon_gen + 1
        state._weapon_fingerprint = fingerprint
    elseif state._weapon_fingerprint ~= nil
       and state._weapon_fingerprint ~= fingerprint then
        state._weapon_gen = state._weapon_gen + 1
        state._weapon_fingerprint = fingerprint
    else
        state._weapon_fingerprint = fingerprint
    end
end
 
local function weapon_gen()
    refresh_weapon_cache(false)
    return state._weapon_gen
end
 
local function refresh_weapon_max_damage(force)
    if not force and (_frame_id - (state.weapon_max_damage_frame or -1000)) < 12 then
        return
    end
    state.weapon_max_damage_frame = _frame_id
    state.weapon_max_damage = nil
 
    if state.pid == 0 or state.base == 0 then return end
 
    local ok, value = pcall(function()
        local lp = get_localplayer()
        if not lp or lp < 0x10000 then return nil end
        local aim = read_uint(lp + OFF.aimCtrl, 8)
        if not aim or aim < 0x10000 then return nil end
        local wdata = read_uint(aim + OFF.combatAimWeaponDataPtr, 8)
        if not wdata or wdata < 0x10000 or wdata >= 0x7FFFFFFFFFFF then return nil end
 
        local max_damage = read_f32(wdata + OFF.weapTemplateDamageMax)
        if not is_finite(max_damage) or max_damage <= 0 or max_damage >= 1000000000 then
            return nil
        end
        return max_damage
    end)
 
    if ok and type(value) == "number" then
        state.weapon_max_damage = value
    end
end
 
local function reset_weapon_cache()
    state.rpm_original          = nil
    state.extended_range_live   = nil
    state.move_speed_live       = nil
    state.move_spread_add_live  = nil
    state.no_sway_live          = 0
    state.sway_saved = {
        min_h = nil, max_h = nil, min_v = nil, max_v = nil,
        reset_dur = nil, scope_speed = nil,
    }
    state._weapon_ptr          = 0
    state._weapon_fingerprint  = nil
    state._weapon_cached_frame = -1
    state._weapon_gen          = state._weapon_gen + 1
 
    state.rpm_seen_gen    = state._weapon_gen
    state.sway_seen_gen   = state._weapon_gen
    state.ext_seen_gen    = state._weapon_gen
    state.move_seen_gen   = state._weapon_gen
    state.silent_seen_gen = state._weapon_gen
end
 
local function invalidate_on_transition(pid)
    pcall(restore_combat_override,
          "high_headshot_dmg_addr", "high_headshot_dmg_original", true)
    if state.silent_lock_addr then
        pcall(memory.unlock, LOCK_ID.silent)
        state.silent_lock_addr = nil
    end
    if state.spread_aim_addrs then
        pcall(memory.unlock, LOCK_ID.spread_a1)
        pcall(memory.unlock, LOCK_ID.spread_a2)
        state.spread_aim_addrs = nil
    end
 
    state.recoil_locked     = false
    state.spread_rva_locked = false
 
    reset_weapon_cache()
 
    state.silent_armed       = false
    state.silent_last_rounds = 0
    state.silent_target_ptr  = nil
    state.diag_last_write    = nil
 
    state.telem_valid       = false
    state.telem_world_aim   = nil
    state.telem_lock_target = nil
    state.telem_delta       = nil
    state.telem_rounds      = 0
    state.telem_lock_addr   = nil
 
    state._transition_frames = TRANSITION_FRAMES
    state._stable_frames     = 0
    state.walk_skip          = 0
    state._prev_pos_by_ptr   = nil
    state.entities           = {}
end
 
local function chk(label, key, apply_fn)
    local v, changed = ui.checkbox(label, state[key])
    state[key] = v
    if changed and apply_fn then pcall(apply_fn) end
    return v
end
 
local function checkbox_edge(label, active)
    local a, b = ui.checkbox(label, active)
    if b ~= nil then return b == true end
    return a ~= active
end
 
local function draw_fov_circle(cx, cy, radius, r, g, b, a)
    r, g, b, a = r or 255, g or 255, b or 255, a or 160
    if not radius or radius <= 0 then return end
    if draw.circle then
        local ok = pcall(draw.circle, cx, cy, radius, r, g, b, a, 1.0)
        if ok then
            pcall(draw.circle, cx, cy, radius + 1, 0, 0, 0, 90, 1.0)
            return
        end
    end
    local segs = 64
    for i = 0, segs - 1 do
        local a1 = (i / segs) * math.pi * 2
        local a2 = ((i + 1) / segs) * math.pi * 2
        draw.line(
            cx + math.cos(a1) * radius, cy + math.sin(a1) * radius,
            cx + math.cos(a2) * radius, cy + math.sin(a2) * radius,
            r, g, b, a, 1.0
        )
    end
end
 
local function refresh_stats()
    assert_attached()
    local lp = get_localplayer()
    if lp == 0 then error("local player is NULL") end
    state.lp_name = read_sd_string(lp + OFF.name)
    local hp = read_uint(lp + OFF.hpPtr, 8)
    if hp == 0 then error("hp component is NULL") end
    state.hp        = read_uint(hp + OFF.health, 4)
    state.hp_max    = read_uint(hp + OFF.healthMax, 4)
    -- armor lives at +0x254/+0x258 of the LOCAL PLAYER structure (not of the
    -- HP component and not on NPC entities); validate the range so a stale
    -- offset can never show garbage like "Armor: 3e9" again.
    local ar     = read_uint(lp + OFF.agentarmor, 4)
    local ar_max = read_uint(lp + OFF.agentarmorMax, 4)
    if ar < 0 or ar > 100000 or ar_max <= 0 or ar_max > 1000000 then
        ar, ar_max = 0, 0
    end
    state.armor     = ar
    state.armor_max = ar_max
end
 
local function apply_recoil()
    assert_attached()
    if state.no_recoil then
        if pcall(memory.lock_rva, LOCK_ID.recoil, state.pid, RVA.recoil, pack_f32(0.0)) then
            state.recoil_locked = true
        else
            state.recoil_locked = false
            write_f32(state.base + RVA.recoil, 0.0)
        end
    else
        if state.recoil_locked then
            pcall(memory.unlock_rva, LOCK_ID.recoil)
            state.recoil_locked = false
        end
        write_f32(state.base + RVA.recoil, DEFAULT_RECOIL)
    end
    state.status = state.no_recoil and "No recoil ON (lock)" or "No recoil OFF"
end
 
local function apply_spread()
    assert_attached()
    if state.no_spread then
        if pcall(memory.lock_rva, LOCK_ID.spread_rva, state.pid, RVA.spread, pack_f32(0.0)) then
            state.spread_rva_locked = true
        else
            state.spread_rva_locked = false
            write_f32(state.base + RVA.spread, 0.0)
        end
        local lp = get_localplayer()
        if lp ~= 0 then
            local aim = read_uint(lp + OFF.aimCtrl, 8)
            if aim ~= 0 then
                local a1 = aim + OFF.combatAimCurrentSpread
                local a2 = aim + OFF.combatAimSpreadRadius
                local ok1 = pcall(memory.lock, LOCK_ID.spread_a1, state.pid, a1, pack_f32(0.0))
                local ok2 = pcall(memory.lock, LOCK_ID.spread_a2, state.pid, a2, pack_f32(0.0))
                if ok1 and ok2 then
                    state.spread_aim_addrs = { a1, a2 }
                else
                    write_f32(a1, 0.0)
                    write_f32(a2, 0.0)
                end
            end
        end
    else
        if state.spread_rva_locked then
            pcall(memory.unlock_rva, LOCK_ID.spread_rva)
            state.spread_rva_locked = false
        end
        write_f32(state.base + RVA.spread, DEFAULT_SPREAD)
        if state.spread_aim_addrs then
            pcall(memory.unlock, LOCK_ID.spread_a1)
            pcall(memory.unlock, LOCK_ID.spread_a2)
            state.spread_aim_addrs = nil
        end
        local lp = get_localplayer()
        if lp ~= 0 then
            local aim = read_uint(lp + OFF.aimCtrl, 8)
            if aim ~= 0 then
                write_f32(aim + OFF.combatAimCurrentSpread, 0.5)
                write_f32(aim + OFF.combatAimSpreadRadius, 1.0)
            end
        end
    end
    state.status = state.no_spread and "No spread ON (lock)" or "No spread OFF"
end
 
local function magic_bullet_should_enable()
    if not state.magic_bullet then return false end
    if not state.silent_armed then return false end
    if not state.silent_target_ptr then return false end
    for _, e in ipairs(state.entities) do
        if e.entity_ptr == state.silent_target_ptr then
            -- weak points are gadget props with their own HP pool: the
            -- ray-correcting flag works on them too and is REQUIRED to deal
            -- any damage at all (a normal bullet often can't hit a small prop
            -- where the aim vector says it should).
            return is_silent_target(e)
        end
    end
    return false
end
 
local function apply_magic_bullet()
    assert_attached()
    local on = magic_bullet_should_enable()
    write_uint(state.base + RVA.magicbullet,
               on and MAGIC_BULLET_ON or MAGIC_BULLET_OFF, 1)
    if state.magic_bullet then
        state.status = on and "Magic bullet ON (NPC-only, locked)"
                             or "Magic bullet ON (NPC-only, idle)"
    else
        state.status = "Magic bullet OFF"
    end
end
 
local function restore_combat_override(addr_key, original_key, is_float)
    local addr = state[addr_key]
    local original = state[original_key]
    if addr and original ~= nil then
        if is_float then
            pcall(write_f32, addr, original)
        else
            pcall(write_uint, addr, original, 1)
        end
    end
    state[addr_key] = nil
    state[original_key] = nil
end
 
local function set_combat_override(addr, addr_key, original_key, value, is_float)
    if state[addr_key] ~= addr then
        restore_combat_override(addr_key, original_key, is_float)
    end
    if state[original_key] == nil then
        local ok, original
        if is_float then
            ok, original = pcall(read_f32, addr)
        else
            ok, original = pcall(read_uint, addr, 1)
        end
        if not ok then error(original) end
        state[original_key] = original
    end
    state[addr_key] = addr
    if is_float then
        write_f32(addr, value)
    else
        write_uint(addr, value, 1)
    end
end
 
local function accuracy_locked_tick()
    if not state.accuracy_locked then
        restore_combat_override("accuracy_locked_addr", "accuracy_locked_original", false)
        return
    end
    local ok, err = pcall(function()
        local lp = get_localplayer()
        if lp == 0 then return end
        local aim = read_uint(lp + OFF.aimCtrl, 8)
        if aim == 0 then return end
        set_combat_override(
            aim + OFF.combatAimAccuracyLocked,
            "accuracy_locked_addr", "accuracy_locked_original", 1, false)
    end)
    if not ok then state.status = "Accuracy lock: " .. tostring(err) end
end
 
local function fire_interval_tick()
    if not state.fast_fire then
        restore_combat_override("fast_fire_addr", "fast_fire_original", true)
        return
    end
    local ok, err = pcall(function()
        local lp = get_localplayer()
        if lp == 0 then return end
        local aim = read_uint(lp + OFF.aimCtrl, 8)
        if aim == 0 then return end
        set_combat_override(
            aim + OFF.combatAimFireInterval,
            "fast_fire_addr", "fast_fire_original", 0.0, true)
    end)
    if not ok then state.status = "Fire interval: " .. tostring(err) end
end
 
local function headshot_dmg_tick()
    if not state.high_headshot_dmg then
        restore_combat_override("high_headshot_dmg_addr", "high_headshot_dmg_original", true)
        return
    end
 
    local ok, err = pcall(function()
        local multiplier = tonumber(state.headshot_dmg_multiplier) or 3.0
        if not is_finite(multiplier) then multiplier = 3.0 end
        multiplier = math.max(1.0, math.min(10.0, multiplier))
        state.headshot_dmg_multiplier = multiplier
 
        local lp = get_localplayer()
        if lp == 0 then
            restore_combat_override("high_headshot_dmg_addr", "high_headshot_dmg_original", true)
            return
        end
        local aim = read_uint(lp + OFF.aimCtrl, 8)
        if aim < 0x10000 or aim > 0x7FFFFFFFFFFF then
            restore_combat_override("high_headshot_dmg_addr", "high_headshot_dmg_original", true)
            return
        end
        local wdata = read_uint(aim + OFF.combatAimWeaponDataPtr, 8)
        if wdata < 0x10000 or wdata > 0x7FFFFFFFFFFF then
            restore_combat_override("high_headshot_dmg_addr", "high_headshot_dmg_original", true)
            return
        end
 
        local addr = wdata + OFF.weapTemplateDmgMultHead
        if state.high_headshot_dmg_addr and state.high_headshot_dmg_addr ~= addr then
            restore_combat_override("high_headshot_dmg_addr", "high_headshot_dmg_original", true)
        end
        local current = read_f32(addr)
        if not is_finite(current) or current <= 0.0 or current > 1000.0 then
            error("headshot multiplier field failed validation")
        end
        set_combat_override(
            addr,
            "high_headshot_dmg_addr", "high_headshot_dmg_original", multiplier, true)
    end)
    if not ok then
        pcall(restore_combat_override,
              "high_headshot_dmg_addr", "high_headshot_dmg_original", true)
        state.status = "Headshot damage: " .. tostring(err)
    end
end
 
local function apply_no_sway()
    assert_attached()
    local lp = get_localplayer()
    if lp == 0 then error("local player is NULL") end
    local aim = read_uint(lp + OFF.aimCtrl, 8)
    if aim == 0 then error("aimCtrl is NULL") end
    local wdata = read_uint(aim + OFF.combatAimWeaponDataPtr, 8)
    if wdata == 0 then error("weapon data ptr is NULL") end
    if state.no_sway then
        if state.sway_saved.min_h == nil then
            state.sway_saved.min_h       = from_f32(read_uint(wdata + OFF.weapTemplateSwayMinH, 4))
            state.sway_saved.max_h       = from_f32(read_uint(wdata + OFF.weapTemplateSwayMaxH, 4))
            state.sway_saved.min_v       = from_f32(read_uint(wdata + OFF.weapTemplateSwayMinV, 4))
            state.sway_saved.max_v       = from_f32(read_uint(wdata + OFF.weapTemplateSwayMaxV, 4))
            state.sway_saved.reset_dur   = from_f32(read_uint(wdata + OFF.weapTemplateSwayResetDur, 4))
            state.sway_saved.scope_speed = from_f32(read_uint(wdata + OFF.weapTemplateScopeSwaySpeed, 4))
        end
        write_f32(wdata + OFF.weapTemplateSwayMinH, 0.0)
        write_f32(wdata + OFF.weapTemplateSwayMaxH, 0.0)
        write_f32(wdata + OFF.weapTemplateSwayMinV, 0.0)
        write_f32(wdata + OFF.weapTemplateSwayMaxV, 0.0)
        write_f32(wdata + OFF.weapTemplateScopeSwaySpeed, 0.0)
        state.status = "No sway ON"
    else
        if state.sway_saved.min_h ~= nil then
            write_f32(wdata + OFF.weapTemplateSwayMinH, state.sway_saved.min_h)
            write_f32(wdata + OFF.weapTemplateSwayMaxH, state.sway_saved.max_h)
            write_f32(wdata + OFF.weapTemplateSwayMinV, state.sway_saved.min_v)
            write_f32(wdata + OFF.weapTemplateSwayMaxV, state.sway_saved.max_v)
            if state.sway_saved.reset_dur ~= nil then
                write_f32(wdata + OFF.weapTemplateSwayResetDur, state.sway_saved.reset_dur)
            end
            if state.sway_saved.scope_speed ~= nil then
                write_f32(wdata + OFF.weapTemplateScopeSwaySpeed, state.sway_saved.scope_speed)
            end
        end
        state.status = "No sway OFF"
    end
end
 
local function sway_tick()
    if not state.no_sway then return end
    local ok, err = pcall(function()
        local lp = get_localplayer()
        if lp == 0 then return end
        local aim = read_uint(lp + OFF.aimCtrl, 8)
        if aim == 0 then return end
        local wdata = read_uint(aim + OFF.combatAimWeaponDataPtr, 8)
        if wdata == 0 then return end
        local gen = weapon_gen()
        if gen ~= state.sway_seen_gen then
            state.sway_seen_gen = gen
            state.sway_saved = {
                min_h = nil, max_h = nil, min_v = nil, max_v = nil,
                reset_dur = nil, scope_speed = nil,
            }
        end
        if state.sway_saved.min_h == nil then
            state.sway_saved.min_h       = from_f32(read_uint(wdata + OFF.weapTemplateSwayMinH, 4))
            state.sway_saved.max_h       = from_f32(read_uint(wdata + OFF.weapTemplateSwayMaxH, 4))
            state.sway_saved.min_v       = from_f32(read_uint(wdata + OFF.weapTemplateSwayMinV, 4))
            state.sway_saved.max_v       = from_f32(read_uint(wdata + OFF.weapTemplateSwayMaxV, 4))
            state.sway_saved.reset_dur   = from_f32(read_uint(wdata + OFF.weapTemplateSwayResetDur, 4))
            state.sway_saved.scope_speed = from_f32(read_uint(wdata + OFF.weapTemplateScopeSwaySpeed, 4))
        end
        write_f32(wdata + OFF.weapTemplateSwayMinH, 0.0)
        write_f32(wdata + OFF.weapTemplateSwayMaxH, 0.0)
        write_f32(wdata + OFF.weapTemplateSwayMinV, 0.0)
        write_f32(wdata + OFF.weapTemplateSwayMaxV, 0.0)
        write_f32(wdata + OFF.weapTemplateScopeSwaySpeed, 0.0)
        state.no_sway_live = from_f32(read_uint(wdata + OFF.weapTemplateSwayResetDur, 4))
    end)
    if not ok then state.status = "NoSway: " .. tostring(err) end
end
 
local function apply_extended_range()
    assert_attached()
    local lp = get_localplayer()
    if lp == 0 then error("local player is NULL") end
    local aim = read_uint(lp + OFF.aimCtrl, 8)
    if aim == 0 then error("aimCtrl is NULL") end
    local wdata = read_uint(aim + OFF.combatAimWeaponDataPtr, 8)
    if wdata == 0 then error("weapon data ptr is NULL") end
    if state.extended_range then
        if state.extended_range_live == nil then
            local raw = from_f32(read_uint(wdata + OFF.weapTemplateRange, 4))
            if raw == 0 then raw = DEFAULT_EXTENDED_RANGE end
            state.extended_range_live = raw
        end
        write_f32(wdata + OFF.weapTemplateRange, 9999999.0)
        state.status = "Extended range ON"
    else
        if state.extended_range_live ~= nil then
            write_f32(wdata + OFF.weapTemplateRange, state.extended_range_live)
        end
        state.status = "Extended range OFF"
    end
end
 
local function extended_range_tick()
    if not state.extended_range then return end
    local ok, err = pcall(function()
        local lp = get_localplayer()
        if lp == 0 then return end
        local aim = read_uint(lp + OFF.aimCtrl, 8)
        if aim == 0 then return end
        local wdata = read_uint(aim + OFF.combatAimWeaponDataPtr, 8)
        if wdata == 0 then return end
        local gen = weapon_gen()
        if gen ~= state.ext_seen_gen then
            state.ext_seen_gen = gen
            state.extended_range_live = nil
        end
        if state.extended_range_live == nil then
            local raw = from_f32(read_uint(wdata + OFF.weapTemplateRange, 4))
            if raw == 0 then raw = DEFAULT_EXTENDED_RANGE end
            state.extended_range_live = raw
        end
        local cur = from_f32(read_uint(wdata + OFF.weapTemplateRange, 4))
        if cur ~= 9999999.0 then
            write_f32(wdata + OFF.weapTemplateRange, 9999999.0)
        end
    end)
    if not ok then state.status = "ExtendedRange: " .. tostring(err) end
end
 
local function teleport_guard()
    return (state._transition_frames or 0) > 0
end
 
local function apply_move_speed()
    assert_attached()
    if teleport_guard() then
 
        state.move_speed_live      = nil
        state.move_spread_add_live = nil
        state.status = "Teleport guard: move spread deferred"
        return
    end
    local lp = get_localplayer()
    if lp == 0 then error("local player is NULL") end
    local aim = read_uint(lp + OFF.aimCtrl, 8)
    if aim == 0 then error("aimCtrl is NULL") end
    if state.move_speed then
        if state.move_spread_add_live == nil then
            state.move_spread_add_live = from_f32(read_uint(aim + OFF.combatAimMoveSpreadAdd, 4))
        end
        if state.move_speed_live == nil then
            state.move_speed_live = from_f32(read_uint(aim + OFF.combatAimLerpedMoveSpeed, 4))
        end
        write_f32(aim + OFF.combatAimMoveSpreadAdd, 0.0)
        write_f32(aim + OFF.combatAimLerpedMoveSpeed, 0.0)
        state.status = "No move spread ON"
    else
        if state.move_spread_add_live ~= nil then
            write_f32(aim + OFF.combatAimMoveSpreadAdd, state.move_spread_add_live)
        end
        if state.move_speed_live ~= nil then
            write_f32(aim + OFF.combatAimLerpedMoveSpeed, state.move_speed_live)
        end
        state.status = "No move spread OFF"
    end
end
 
local function move_speed_tick()
    if not state.move_speed then return end
    local ok, err = pcall(function()
        local lp = get_localplayer()
        if lp == 0 then return end
        local aim = read_uint(lp + OFF.aimCtrl, 8)
        if aim == 0 then return end
 
        if state.move_spread_add_live == nil and state.move_speed_live == nil then
            apply_move_speed()
            return
        end
        local gen = weapon_gen()
        if gen ~= state.move_seen_gen then
            state.move_seen_gen = gen
            state.move_spread_add_live = nil
            state.move_speed_live      = nil
        end
        write_f32(aim + OFF.combatAimMoveSpreadAdd, 0.0)
    end)
    if not ok then state.status = "MoveSpread: " .. tostring(err) end
end
 
local function apply_time(mode)
    assert_attached()
    state.time_mode = mode
    local noon  = mode == "noon"  and 1 or 0
    local night = mode == "night" and 1 or 0
    write_uint(state.base + RVA.setnoon, noon, 1)
    write_uint(state.base + RVA.setnight, night, 1)
    state.status = "Time: " .. mode
end
 
local function sanitize_rpm_value()
    if state.rpm_value < RPM_MIN then state.rpm_value = RPM_MIN end
    if state.rpm_value > RPM_MAX then state.rpm_value = RPM_MAX end
end
 
local function restore_rpm()
    if state.rpm_original == nil then return end
    local lp = get_localplayer()
    if lp == 0 then return end
    local w3 = resolve_rpm_target(lp)
    if w3 ~= 0 then write_f32(w3 + OFF.rpmFinal, state.rpm_original) end
    state.rpm_original = nil
end
 
local function rpm_tick()
    if not state.rpm_enabled then return end
    sanitize_rpm_value()
    local ok, err = pcall(function()
        local lp = get_localplayer()
        if lp == 0 then return end
        local w3 = resolve_rpm_target(lp)
        if w3 ~= 0 then
            local gen = weapon_gen()
            if gen ~= state.rpm_seen_gen then
                state.rpm_seen_gen = gen
                state.rpm_original = nil
            end
            state.rpm_live = read_f32(w3 + OFF.rpmFinal)
            if state.rpm_original == nil then
                state.rpm_original = state.rpm_live
            end
            if state.rpm_live ~= state.rpm_value then
                write_f32(w3 + OFF.rpmFinal, state.rpm_value)
            end
        end
        local aim = read_uint(lp + OFF.aimCtrl, 8)
        if aim ~= 0 then
            local cached = 60000.0 / state.rpm_value
            write_f32(aim + OFF.combatAimClipSizeCached, cached)
        end
    end)
    if not ok then state.status = "RPM: " .. tostring(err) end
end
 
local function read_rpm_once()
    assert_attached()
    local lp = get_localplayer()
    if lp == 0 then error("local player is NULL") end
    local w3 = resolve_rpm_target(lp)
    if w3 == 0 then error("weapon chain broken") end
    state.rpm_live = read_f32(w3 + OFF.rpmFinal)
    state.status = string.format("RPM final: %.0f", state.rpm_live)
end
 
local function instant_reload_tick()
    if not state.instant_reload then return end
    local ok, err = pcall(function()
        local lp = get_localplayer()
        if lp == 0 then return end
        local aim = read_uint(lp + OFF.aimCtrl, 8)
        if aim == 0 then return end
        write_uint(aim + OFF.reloadField, 0, 4)
    end)
    if not ok then state.status = "InstantReload: " .. tostring(err) end
end
 
local MASTER_KEYS = {
    "no_recoil", "no_spread", "magic_bullet", "no_sway", "move_speed",
    "extended_range", "instant_reload", "rpm_enabled",
    "accuracy_locked", "fast_fire", "high_headshot_dmg",
}
 
local function set_master(on)
    if on == state.master_enabled then return end
    state.master_enabled = on
    if not on then
        state.master_snapshot = {}
        for _, k in ipairs(MASTER_KEYS) do
            state.master_snapshot[k] = state[k]
            state[k] = false
        end
        if state.pid ~= 0 and state.base ~= 0 then
            pcall(apply_recoil)
            pcall(apply_spread)
            pcall(apply_magic_bullet)
            pcall(apply_no_sway)
            pcall(apply_extended_range)
            pcall(apply_move_speed)
            pcall(restore_rpm)
        end
        if state.pid ~= 0 and state.silent_lock_addr then
            pcall(memory.unlock, LOCK_ID.silent)
            state.silent_lock_addr = nil
        end
        state.status = "Master OFF (F1 to re-enable)"
    else
        if state.master_snapshot then
            for _, k in ipairs(MASTER_KEYS) do
                state[k] = state.master_snapshot[k] or false
            end
            state.master_snapshot = nil
        end
        if state.pid ~= 0 and state.base ~= 0 then
            pcall(apply_recoil)
            pcall(apply_spread)
            pcall(apply_magic_bullet)
        end
        state.status = "Master ON"
    end
end
 
ONE_SHOT_APPLIES.no_recoil     = apply_recoil
ONE_SHOT_APPLIES.no_spread     = apply_spread
ONE_SHOT_APPLIES.magic_bullet  = apply_magic_bullet
 
local function get_bone_ids_for_entity(e, read_all)
    if read_all then
        return ALL_BONE_IDS_0_90
    end

    -- boss backpacks / propane tanks are separate prop entities without a
    -- meaningful skeleton; skip bone reads entirely (aiming uses the entity
    -- position, see aim_point_for)
    if is_weak_point_entity(e) then
        return {}
    end
 
    local pname = profile_name_for(e)
    if pname == "DRONE" then return {} end
    if pname == "TURRET" then return {} end
    if pname == "ITEM" then return {} end
    local prof = BONE_PROFILES[pname]
    if not prof then
        return ALL_BONE_IDS_SPARSE
    end
    return prof.indices
end
 
local function world_to_screen(pos, m, wr)
    if not m or not wr then return nil end
    if type(wr) ~= "table" then return nil end
    if not wr.width or not wr.height or wr.width <= 0 or wr.height <= 0 then
        return nil
    end
    local x, y, z = pos[1], pos[2], pos[3]
    local cx = m[1] * x + m[5] * y + m[9]  * z + m[13]
    local cy = m[2] * x + m[6] * y + m[10] * z + m[14]
    local cw = m[4] * x + m[8] * y + m[12] * z + m[16]
    if not is_finite(cw) or cw < 0.001 then return nil end
    local nx = cx / cw
    local ny = cy / cw
    return wr.x + (nx + 1) * wr.width / 2, wr.y + (1 - ny) * wr.height / 2
end
 
local function read_bones(pid, entities, read_all)
    if #entities == 0 then return {} end
 
    local bb_addrs = {}
    for _, e in ipairs(entities) do
        bb_addrs[#bb_addrs + 1] = e.entity_ptr + OFF.bonesBase
    end
    local bb_raw = batch_read_chunked(pid, 8, bb_addrs)
 
    local ba_addrs = {}
    local valid = {}
    for i = 1, #entities do
        local off = (i - 1) * 8
        if #bb_raw >= off + 8 then
            local bb = uint_from(bb_raw, off + 1, 8)
            if bb ~= 0 then
                ba_addrs[#ba_addrs + 1] = bb + OFF.boneArray
                valid[#valid + 1] = i
            end
        end
    end
    if #ba_addrs == 0 then return {} end
 
    local ba_raw = batch_read_chunked(pid, 8, ba_addrs)
 
    local bone_addr_list = {}
    local bone_owner = {}
    local bone_id_list = {}
    for vi = 1, #valid do
        local ei = valid[vi]
        local e = entities[ei]
        local off = (vi - 1) * 8
        if #ba_raw >= off + 8 then
            local bone_arr = uint_from(ba_raw, off + 1, 8)
            if bone_arr ~= 0 then
                local bone_ids = get_bone_ids_for_entity(e, read_all)
                for _, bid in ipairs(bone_ids) do
                    bone_addr_list[#bone_addr_list + 1] = bone_arr + bid * BONE_STRIDE + BONE_POS_OFF
                    bone_owner[#bone_owner + 1] = ei
                    bone_id_list[#bone_id_list + 1] = bid
                end
            end
        end
    end
    if #bone_addr_list == 0 then return {} end
 
    local raw = batch_read_chunked(pid, 12, bone_addr_list)
    local bone_results = {}
    local entity_bones = {}
 
    for k = 1, #bone_addr_list do
        local boff = (k - 1) * 12
        if #raw >= boff + 12 then
            local bx = from_f32(uint_from(raw, boff + 1, 4))
            local by = from_f32(uint_from(raw, boff + 5, 4))
            local bz = from_f32(uint_from(raw, boff + 9, 4))
            if is_finite(bx) and is_finite(by) and is_finite(bz) then
                if bx ~= 0 or by ~= 0 or bz ~= 0 then
                    local ei = bone_owner[k]
                    local bid = bone_id_list[k]
                    entity_bones[ei] = entity_bones[ei] or {}
                    entity_bones[ei][#entity_bones[ei] + 1] = { bid = bid, pos = {bx, by, bz} }
                end
            end
        end
    end
 
    local MAX_BONE_DIST_FROM_ENTITY = 6.0
    for ei, list in pairs(entity_bones) do
        local epos = entities[ei] and entities[ei].pos
        local kept = {}
        if epos then
            for _, entry in ipairs(list) do
                local p = entry.pos
                local dx, dy, dz = p[1] - epos[1], p[2] - epos[2], p[3] - epos[3]
                local d = math.sqrt(dx*dx + dy*dy + dz*dz)
                if d <= MAX_BONE_DIST_FROM_ENTITY then
                    kept[entry.bid] = p
                end
            end
        else
            for _, entry in ipairs(list) do
                kept[entry.bid] = entry.pos
            end
        end
        bone_results[ei] = kept
    end
 
    return bone_results
end
 
local function should_show(e)
    local pname = profile_name_for(e)
 
    if pname == "ITEM" then
        return false
    end

    -- show weak-point props in ESP so the user can verify silent aim sees them
    if is_weak_point_entity(e) then
        return state.esp_show_other or state.weak_points_first
    end
 
    if pname ~= "TURRET"
       and pname ~= "BIG_DOG"
       and pname ~= "WARHOUND_GRENADIER"
       and pname ~= "WARHOUND_MINIGUN"
       and pname ~= "MINITANK"
       and not e.is_player then
        if name_is_blacklisted(e.ent_name) then return false end
    end
 
    if pname == "TURRET" then
        if e.relation == "friendly" then return state.esp_show_friendly end
        if e.relation == "neutral"  then return state.esp_show_neutral  end
        return state.esp_show_hostile
    end
    if e.is_player then
        if e.relation == "hostile"  then return state.esp_show_hostile  end
        if e.relation == "friendly" then return state.esp_show_friendly end
        return state.esp_show_player
    end
    if e.relation == "unknown"
       and (pname == "DRONE" or pname == "TURRET"
            or pname == "BIG_DOG" or pname == "WARHOUND_GRENADIER"
            or pname == "WARHOUND_MINIGUN" or pname == "MINITANK") then
        return state.esp_show_hostile or state.esp_show_other
    end
    if e.relation == "hostile"  then return state.esp_show_hostile  end
    if e.relation == "friendly" then return state.esp_show_friendly end
    if e.relation == "neutral"  then return state.esp_show_neutral  end
    if e.relation == "unknown"  then return state.esp_show_other    end
    return false
end
 
local function compute_box(e, m, w, sx_hint, sy_hint)
    local box_h = 0
    local box_w = 0
    local box_cx = sx_hint
    local box_cy = sy_hint
    local pname = profile_name_for(e)
    local b = LEGACY_BONE_NAMES[pname] or LEGACY_BONE_NAMES.NPC_HUMANOID
    local draw_pos = e.pos
 
    if pname == "DRONE" then
        local ox, oy = world_to_screen(draw_pos, m, w)
        local top = { draw_pos[1], draw_pos[2] + 0.8, draw_pos[3] }
        local tx, ty = world_to_screen(top, m, w)
        if ox and oy and tx and ty then
            local h = math.abs(oy - ty)
            if h > 6 then
                return h, h * 0.8, (ox + tx) / 2, (oy + ty) / 2
            end
        end
        return 40, 30, sx_hint, sy_hint
    end
 
    if pname == "TURRET" then
        local base = draw_pos
        local top = { draw_pos[1], draw_pos[2] + TURRET_BOX_HEIGHT_OFFSET, draw_pos[3] }
        local bx, by = world_to_screen(base, m, w)
        local tx, ty = world_to_screen(top, m, w)
        if bx and by and tx and ty then
            local h = math.abs(by - ty)
            if h > 6 then
                return h, h * 0.75, (bx + tx) / 2, (by + ty) / 2
            end
        end
        return 60, 45, sx_hint, sy_hint
    end
 
    if pname == "BIG_DOG"
       or pname == "WARHOUND_GRENADIER"
       or pname == "WARHOUND_MINIGUN" then
        local bx, by = world_to_screen(draw_pos, m, w)
        local top = { draw_pos[1], draw_pos[2] + 1.6, draw_pos[3] }
        local tx, ty = world_to_screen(top, m, w)
        if bx and by and tx and ty then
            local h = math.abs(by - ty)
            if h > 4 then
                box_h = h
                box_w = h * 0.9
                box_cx = (bx + tx) / 2
                box_cy = (by + ty) / 2
            end
        end
    elseif pname == "MINITANK" then
        local bones = e.bones
        local rp = bones and bones[b.root or 0]
        local hp = bones and (bones[b.top or -1] or bones[b.head or -1] or bones[33] or bones[31])
        if not hp then hp = e.pos end
        if rp then
            local hx, hy = world_to_screen(hp, m, w)
            local rx, ry = world_to_screen(rp, m, w)
            if hx and hy and rx and ry then
                local h = math.abs(hy - ry)
                if h > 10 then
                    box_h = h
                    box_w = h * 0.5
                    box_cx = (hx + rx) / 2
                    box_cy = (hy + ry) / 2
                end
            end
        end
    else
        local bones = e.bones
        local hp = bones and bones[b.head or 8]
        local rp = bones and bones[b.root or 0]
        if hp and rp then
            local hx, hy = world_to_screen(hp, m, w)
            local rx, ry = world_to_screen(rp, m, w)
            if hx and hy and rx and ry then
                local h = math.abs(hy - ry)
                if h > 10 then
                    box_h = h
                    box_w = h * 0.4
                    box_cx = (hx + rx) / 2
                    box_cy = (hy + ry) / 2
                end
            end
        end
    end
 
    if box_h <= 0 then
        box_h = 40
        box_w = 16
        box_cx = sx_hint
        box_cy = sy_hint
    end
 
    return box_h, box_w, box_cx, box_cy
end
 
local function aim_point_for(e)
    if not e then return nil end

    -- weak-point props have no usable skeleton: always aim at the entity
    -- position itself (this is the prop's world center, where its HP
    -- component takes hits). Never route them through the humanoid profile,
    -- which would fall back to "head + 1.2m" above an object that has no head.
    -- NOTE: the entity origin of many props sits at their FEET, so we raise
    -- the aim point into the actual damage volume (see weak_point_aim_offset).
    if is_weak_point_entity(e) and silent_accepts_weak_point(e) then
        return aim_point_for_weak_point(e)
    end

    local pname = profile_name_for(e)
 
    if pname == "DRONE" or pname == "TURRET" or pname == "ITEM" then
        return { e.pos[1], e.pos[2], e.pos[3] }
    end
    if pname == "NO_SKELETON" then
        return { e.pos[1], e.pos[2], e.pos[3] }
    end
 
    local prof = BONE_PROFILES[pname]
    local bt = LEGACY_BONE_NAMES[pname] or LEGACY_BONE_NAMES.NPC_HUMANOID
 
    local target_bone
    if prof and prof.is_humanoid then
        if state.aim_part == "head"   then target_bone = bt.head   end
        if state.aim_part == "chest"  then target_bone = bt.chest  end
        if state.aim_part == "pelvis" then target_bone = bt.belly  end
    elseif prof then
        target_bone = prof.aim_bone
    end
    if target_bone == nil and prof then
        target_bone = prof.aim_bone_fallback
    end
    if target_bone ~= nil and prof and prof.aim_bone_fallback ~= nil
       and e.bones and not e.bones[target_bone] then
        target_bone = prof.aim_bone_fallback
    end
 
    if target_bone == nil then
        target_bone = bt.root or 0
    end
 
    local p = e.bones and e.bones[target_bone]
    if not p then
        local pos = e.pos
        p = { pos[1], pos[2] + 1.2, pos[3] }
    end
    return p
end
 
local function normalize_window_rect(raw)
    if type(raw) ~= "table" then return nil end
    local rect = raw[1]
    if not rect or not rect.width then
        if raw.width then
            rect = raw
        else
            return nil
        end
    end
    if type(rect) ~= "table"
       or type(rect.x) ~= "number" or type(rect.y) ~= "number"
       or type(rect.width) ~= "number" or type(rect.height) ~= "number"
       or not is_finite(rect.x) or not is_finite(rect.y)
       or not is_finite(rect.width) or not is_finite(rect.height)
       or rect.width <= 0 or rect.height <= 0 then
        return nil
    end
    return { rect }
end
 
local function find_silent_target(entities, viewproj, wr)
    if not viewproj then return nil end
    wr = normalize_window_rect(wr)
    if not wr then return nil end
    local w = wr[1]
    if not w or not w.width or w.width <= 0 then return nil end
    local cx, cy = w.x + w.width / 2, w.y + w.height / 2

    -- two-stage target selection: collect weak-point candidates and regular
    -- NPC candidates separately; switch to head/body targets only once no
    -- alive weak point is left inside the FOV (destroyed props disappear from
    -- the entity list on their own, so re-checking each frame is enough).
    -- A live lock on a weak point gets a stickiness bonus so the aim keeps
    -- holding the SAME prop until its HP reaches 0 / it despawns.
    local best_wp, best_wp_score = nil, -math.huge
    local best_np, best_np_score = nil, -math.huge

    -- cache of humanoid NPC positions for owner-proximity scoring: a prop
    -- that sits on/next to a boss (healing backpack etc.) outranks loose
    -- environmental barrels across the room
    local npc_positions = {}
    if state.weak_points_first then
        for _, e in ipairs(entities) do
            if not e.is_player and not e.is_downed
               and e.entity_type == ENTITY_TYPE_NPC
               and (e.relation == "hostile" or e.relation == "unknown")
               and e.pos then
                npc_positions[#npc_positions + 1] = e.pos
            end
        end
    end

    local function wp_owner_bonus(e)
        if #npc_positions == 0 then return 0 end
        local best_d2 = math.huge
        for _, p in ipairs(npc_positions) do
            local dx = e.pos[1] - p[1]
            local dy = e.pos[2] - p[2]
            local dz = e.pos[3] - p[3]
            local d2 = dx * dx + dy * dy + dz * dz
            if d2 < best_d2 then best_d2 = d2 end
        end
        -- within 4 m of an enemy -> strong bonus, fading out to 10 m
        if best_d2 <= 16 then return 2000 end
        if best_d2 <= 100 then return 800 end
        return 0
    end

    for _, e in ipairs(entities) do
        if not e.is_player and is_silent_target(e) and e.dist <= state.silent_max_dist then
            local tp = aim_point_for(e)
            if tp then
                local sx, sy = world_to_screen(tp, viewproj, w)
                if sx and sy then
                    local dx, dy = sx - cx, sy - cy
                    local dist_px = math.sqrt(dx * dx + dy * dy)
                    if dist_px < state.silent_fov then
                        local score = -dist_px
                        if state.weak_points_first
                           and is_weak_point_entity(e)
                           and silent_accepts_weak_point(e) then
                            -- tier priority: HEALER backpacks first, then fuel
                            -- tanks / generators, then generic explosives
                            local tier, _lbl = classify_weak_point(e)
                            score = score + (3 - tier) * 3000
                            score = score + wp_owner_bonus(e)
                            if state.silent_target_ptr
                               and e.entity_ptr == state.silent_target_ptr
                               and e.hp > 0 then
                                score = score + SILENT_WP_STICK_BONUS
                            end
                            if score > best_wp_score then
                                best_wp_score, best_wp = score, e
                            end
                        else
                            if score > best_np_score then
                                best_np_score, best_np = score, e
                            end
                        end
                    end
                end
            end
        end
    end
    -- record the currently locked weak point's HP so wp_watchdog can detect
    -- "hp stopped dropping" (shielded / invulnerable prop) and release the
    -- lock instead of aiming at an unkillable object forever
    if best_wp and best_wp.has_hp then
        if state.wp_lock_ptr ~= best_wp.entity_ptr then
            state.wp_lock_ptr      = best_wp.entity_ptr
            state.wp_lock_prev_hp  = best_wp.hp
            state.wp_lock_start_hp = best_wp.hp
            state.wp_lock_stall    = 0
        elseif best_wp.hp < (state.wp_lock_prev_hp or best_wp.hp) then
            state.wp_lock_prev_hp = best_wp.hp
            state.wp_lock_stall   = 0
        end
    elseif not best_wp then
        state.wp_lock_ptr     = nil
        state.wp_lock_stall   = 0
        state.wp_lock_prev_hp = nil
    end
    if best_wp then return best_wp end
    return best_np
end

-- Weak-point watchdog: runs once per frame with the entity list that was just
-- produced by the ESP scan. Tracks the currently locked prop's HP across
-- frames and fires while we are actually shooting at it:
--   * HP dropped                  -> reset stall counter, keep the lock
--   * HP unchanged + shots fired  -> stall++ ; after WP_STALL_LIMIT stalled
--     shot-windows the prop is marked ignored for WP_IGNORE_SECONDS so the
--     aimbot can move on (invulnerable surface / dead-but-not-despawned prop)
--   * prop despawned / hp <= 0    -> count as destroyed, clear the lock
local function wp_watchdog()
    local now = os.clock()

    -- purge expired ignore entries so a prop gets a second chance later
    for ptr, until_t in pairs(state.wp_ignored) do
        if now >= until_t then state.wp_ignored[ptr] = nil end
    end

    -- find the entity the aimbot is currently holding a lock on
    local cur = nil
    if state.wp_lock_ptr then
        for _, e in ipairs(state.entities) do
            if e.entity_ptr == state.wp_lock_ptr then cur = e break end
        end
    end

    -- locked prop despawned / killed -> count it as destroyed and clear lock
    if state.wp_lock_ptr and (not cur or not is_weak_point_entity(cur)
       or (cur.has_hp and cur.hp <= 0)) then
        state.wp_destroyed = state.wp_destroyed + 1
        state.hit_debug = string.format(
            "Weak point destroyed (%d total), switching target",
            state.wp_destroyed)
        state.wp_lock_ptr        = nil
        state.wp_lock_prev_hp    = nil
        state.wp_lock_stall      = 0
        state.wp_lock_start_hp   = 0
        return
    end

    -- freshly locked prop: register first-seen stats
    if cur and state.wp_seen_ptr ~= cur.entity_ptr then
        state.wp_seen_ptr = cur.entity_ptr
        state.wp_seen_count = state.wp_seen_count + 1
        state.wp_last_shots = state.silent_shots
        state.hit_debug = string.format("Locked weak point #%d (hp %d)",
            state.wp_seen_count, cur.hp)
    end

    -- stall detection: while the SAME prop stays locked and we keep firing
    -- new rounds but its HP refuses to drop, mark it ignored for a while so
    -- silent aim moves on to other props / the head. find_silent_target
    -- updates wp_lock_prev_hp whenever HP drops, so any real hit resets us.
    if cur and cur.has_hp and state.wp_lock_prev_hp ~= nil
       and cur.hp >= (state.wp_lock_prev_hp or cur.hp)
       and state.silent_shots > (state.wp_last_shots or 0) then
        state.wp_last_shots = state.silent_shots
        state.wp_lock_stall = (state.wp_lock_stall or 0) + 1
        if state.wp_lock_stall >= WP_STALL_LIMIT then
            state.wp_ignored[cur.entity_ptr] = now + WP_IGNORE_SECONDS
            state.hit_debug = string.format(
                "Weak point hp stuck at %d -> ignoring %.0fs",
                cur.hp, WP_IGNORE_SECONDS)
            state.wp_lock_ptr     = nil
            state.wp_lock_prev_hp = nil
            state.wp_lock_stall   = 0
            state.wp_seen_ptr     = nil
        end
    end
end

-- Scan the raw entity list (NOT the filtered silent-target list) and count
-- how many entities currently look like destructible weak points. Used by
-- the UI diagnostics so the user can tell apart "no props nearby" from
-- "props exist but the filter rejects them".
local function count_weak_point_candidates()
    local n = 0
    for _, e in ipairs(state.entities) do
        if not e.is_player and is_weak_point_entity(e) then n = n + 1 end
    end
    return n
end
 
local function pack_vec3(v)
    local out = {}
    for i = 1, 3 do
        local bits = 0
        local x = v[i]
        if x < 0 then bits = 0x80000000; x = -x end
        if x ~= 0 and is_finite(x) then
            local m, e = math.frexp(x)
            local b = e + 126
            if b >= 255 then
                bits = bits + 0x7F800000
            elseif b > 0 then
                bits = bits + b * 0x800000 + math.floor((m * 2 - 1) * 0x800000 + 0.5)
            end
        end
        for j = 1, 4 do
            out[(i - 1) * 4 + j] = bits % 256
            bits = math.floor(bits / 256)
        end
    end
    return out
end
 
local function read_world_aim(aim)
    if aim == 0 then return nil end
    local raw = read_bytes_table(aim + OFF.worldAimPos, 12)
    if #raw < 12 then return nil end
    return {
        from_f32(uint_from(raw, 1, 4)),
        from_f32(uint_from(raw, 5, 4)),
        from_f32(uint_from(raw, 9, 4)),
    }
end
 
local function release_silent_lock(pid)
    if state.silent_lock_addr then
        pcall(memory.unlock, LOCK_ID.silent)
        state.silent_lock_addr = nil
    end
    state.silent_armed = false
    state.diag_last_write = nil
end
 
local function silent_tick(pid, base)
    if not state.silent_enabled then
        release_silent_lock(pid)
        state.silent_last_rounds = 0
        state.silent_target_name = ""
        state.silent_target_ptr = nil
 
        if state.magic_bullet then
            pcall(write_uint, base + RVA.magicbullet, MAGIC_BULLET_OFF, 1)
        end
        return
    end
 
    local was_armed = state.silent_armed
 
    local ok, err = pcall(function()
        local lp = get_localplayer()
        if lp == 0 then
            release_silent_lock(pid)
            return
        end
        local aim = read_uint(lp + OFF.aimCtrl, 8)
        if aim == 0 then
            release_silent_lock(pid)
            return
        end
 
        local wr = normalize_window_rect(state.window_rect)
        if not wr then
            wr = {{ x = 0, y = 0, width = 1920, height = 1080 }}
        end
        local target = find_silent_target(state.entities, state.viewproj, wr)
 
        if target then
            if state.silent_target_ptr ~= target.entity_ptr then
                state.silent_target_ptr = target.entity_ptr
                state.silent_shots = 0
            end
 
            local tp = aim_point_for(target)
            if tp then
                state.silent_target_kind =
                    (is_weak_point_entity(target)
                     and silent_accepts_weak_point(target))
                    and "weak point" or "npc"
                local aim_addr = aim + OFF.worldAimPos
                local aim_bytes = pack_vec3(tp)
 
                if state.silent_lock_addr and state.silent_lock_addr ~= aim_addr then
                    pcall(memory.unlock, LOCK_ID.silent)
                    state.silent_lock_addr = nil
                end
 
                local lock_ok = pcall(memory.lock, LOCK_ID.silent, pid, aim_addr, aim_bytes)
                if lock_ok then
                    state.silent_lock_addr = aim_addr
                else
                    for _ = 1, 10 do
                        memory.write_bytes(pid, aim_addr, aim_bytes)
                    end
                    state.silent_lock_addr = aim_addr
                end
 
                state.diag_last_write = { tp[1], tp[2], tp[3] }
                state.silent_armed = true
                if state.silent_target_kind == "weak point" then
                    state.silent_target_name = string.format(
                        "WEAK POINT %s (%s) %.0fm",
                        target.wp_label or "PROP",
                        (target.ent_name ~= "" and target.ent_name or "unnamed"),
                        target.dist)
                else
                    state.silent_target_name = string.format(
                        "%s %.0fm", state.aim_part, target.dist)
                end
            end
        else
            release_silent_lock(pid)
            state.silent_target_name = ""
            state.silent_target_ptr = nil
        end
 
        if not was_armed then
            state.diag_last_write = nil
        end
 
        local gen = weapon_gen()
        if gen ~= state.silent_seen_gen then
            state.silent_seen_gen = gen
            state.silent_last_rounds = 0
        end
 
        local rounds = read_uint(aim + OFF.combatAimRoundsFired, 4)
        local delta
        if rounds >= state.silent_last_rounds then
            delta = rounds - state.silent_last_rounds
        else
            delta = 0
        end
        state.silent_last_rounds = rounds
        if delta > 0 then
            state.silent_fired = true
            state.silent_shots = state.silent_shots + delta
        else
            state.silent_fired = false
        end
 
        if state.magic_bullet then
            local on = false
            if state.silent_armed and state.silent_target_ptr and target then
                -- magic bullet must stay ON for weak points as well: props are
                -- tiny raycast targets, without the correction bullets aimed
                -- at them simply pass through and deal zero damage.
                on = is_silent_target(target)
            end
            write_uint(base + RVA.magicbullet,
                       on and MAGIC_BULLET_ON or MAGIC_BULLET_OFF, 1)
        end
    end)
    if not ok then state.status = "Silent: " .. tostring(err) end
end
 
local function dbg_refresh()
    state.dbg_lp_pos = nil
    state.dbg_bone0 = nil
    state.dbg_err = nil
    if state.pid == 0 or state.base == 0 then return end
    local lp = get_localplayer()
    if lp == 0 then return end
 
    local raw = read_bytes_table(lp + OFF.entityPos, 12)
    if #raw >= 12 then
        state.dbg_lp_pos = {
            from_f32(uint_from(raw, 1, 4)),
            from_f32(uint_from(raw, 5, 4)),
            from_f32(uint_from(raw, 9, 4)),
        }
    end
 
    local bb_raw = memory.batch_read(state.pid, 8, { lp + OFF.bonesBase })
    local bb = (bb_raw and #bb_raw >= 8) and uint_from(bb_raw, 1, 8) or 0
    if bb ~= 0 then
        local ba_raw = memory.batch_read(state.pid, 8, { bb + OFF.boneArray })
        local ba = (ba_raw and #ba_raw >= 8) and uint_from(ba_raw, 1, 8) or 0
        if ba ~= 0 then
            local m0 = read_bytes_table(ba + BONE_POS_OFF, 12)
            if #m0 >= 12 then
                state.dbg_bone0 = {
                    from_f32(uint_from(m0, 1, 4)),
                    from_f32(uint_from(m0, 5, 4)),
                    from_f32(uint_from(m0, 9, 4)),
                }
            end
        end
    end
end
 
function OnStart() end
 
function OnDestroy()
    state.esp_enabled = false
    state.silent_enabled = false
    state.magic_bullet = false
    state.rpm_enabled = false
    state.instant_reload = false
    state.no_sway = false
    state.extended_range = false
    state.move_speed = false
    state.accuracy_locked = false
    state.fast_fire = false
    state.high_headshot_dmg = false
    state._last_arr_ptr = 0
    state._last_count = 0
    state._last_ptrs = nil
    state._prev_pos_by_ptr = nil
    state._was_attached = false
    state._stable_frames = 0
    state._transition_frames = 0
 
    if state.pid ~= 0 and state.silent_lock_addr then
        pcall(memory.unlock, LOCK_ID.silent)
        state.silent_lock_addr = nil
    end
    if state.pid ~= 0 then
        if state.recoil_locked then
            pcall(memory.unlock_rva, LOCK_ID.recoil)
            state.recoil_locked = false
        end
        if state.spread_rva_locked then
            pcall(memory.unlock_rva, LOCK_ID.spread_rva)
            state.spread_rva_locked = false
        end
        if state.spread_aim_addrs then
            pcall(memory.unlock, LOCK_ID.spread_a1)
            pcall(memory.unlock, LOCK_ID.spread_a2)
            state.spread_aim_addrs = nil
        end
        pcall(restore_rpm)
        pcall(apply_no_sway)
        pcall(apply_extended_range)
        pcall(apply_move_speed)
        pcall(apply_magic_bullet)
        pcall(restore_combat_override,
              "accuracy_locked_addr", "accuracy_locked_original", false)
        pcall(restore_combat_override,
              "fast_fire_addr", "fast_fire_original", true)
        pcall(restore_combat_override,
              "high_headshot_dmg_addr", "high_headshot_dmg_original", true)
 
        pcall(write_f32, state.base + RVA.recoil, DEFAULT_RECOIL)
        pcall(write_f32, state.base + RVA.spread, DEFAULT_SPREAD)
 
        if memory.unlock_all then
            pcall(memory.unlock_all, state.pid)
        end
    end
    reset_weapon_cache()
end
 
function OnUpdate(dt)
    _frame_id = _frame_id + 1
    refresh_weapon_max_damage(false)
 
    if state.walk_skip > 0 then
        state.walk_skip = state.walk_skip - 1
    end
 
    if keyboard and keyboard.is_key_press then
        if keyboard.is_key_press("f1") then
            set_master(not state.master_enabled)
        end
        if keyboard.is_key_press("f2") then
            state.rpm_enabled = not state.rpm_enabled
            if not state.rpm_enabled then pcall(restore_rpm) end
        end
    end
 
    if state.pid ~= 0 and state.base ~= 0 then
        local dok, derr = pcall(dbg_refresh)
        if not dok then state.dbg_err = tostring(derr) end
    end
 
    if state.pid == 0 then
        state.attach_timer = state.attach_timer + (dt or 0)
        if state.attach_timer >= 2.0 then
            state.attach_timer = 0
            local ok, pid = pcall(memory.get_pid, state.name)
            if ok and pid and pid > 0 then
                state.pid = pid
                state.base = memory.get_process_base(state.pid)
                state.walk_skip = 0
                state.status = string.format("Attached PID %d 0x%X", state.pid, state.base)
            end
        end
    end
 
    if state.pid ~= 0 and state.base ~= 0 then
        local wok, werr = pcall(refresh_weapon_cache, false)
        if not wok then state.status = "Weapon cache: " .. tostring(werr) end
    end
 
    if (state.esp_enabled or state.silent_enabled)
       and state.pid ~= 0 and state.base ~= 0 then
        local pid = state.pid
        local base = state.base
        local ok, err = pcall(function()
 
            local function read_matrix_at(addr)
                local read_ok, bytes, byte_count = pcall(read_bytes_table, addr, 64)
                if not read_ok or type(bytes) ~= "table" or not byte_count or byte_count < 64 then
                    return nil
                end
                local matrix = parse_f32_array(bytes, 16)
                local nonzero = 0
                for i = 1, 16 do
                    local value = matrix[i]
                    if not is_finite(value) or math.abs(value) > 10000000 then
                        return nil
                    end
                    if math.abs(value) > 0.0000001 then nonzero = nonzero + 1 end
                end
                if nonzero < 6 then return nil end
                return matrix
            end
 
            local direct_matrix = read_matrix_at(base + RVA.viewmatrix + OFF.viewProj)
            local pointer_matrix = nil
            local ptr_ok, ptr_bytes, ptr_len = pcall(read_bytes_table, base + RVA.viewmatrix, 8)
            local vm_ptr = 0
            if ptr_ok and type(ptr_bytes) == "table" and ptr_len and ptr_len >= 8 then
                vm_ptr = uint_from(ptr_bytes, 1, 8)
            end
            if vm_ptr >= 0x10000 and vm_ptr < 0x7FFFFFFFFFFF then
                pointer_matrix = read_matrix_at(vm_ptr + OFF.viewProj)
            end
            state.wr_timer = state.wr_timer + 1
            if state.wr_timer >= 5 then
                state.wr_timer = 0
                local rect = normalize_window_rect(memory.get_window_rect(pid))
                if rect then state.window_rect = rect end
            end
 
            local po_ptr = safe_walk(pid, base, {
                RVA.rlclient, OFF.pClient, OFF.pObject,
            })
            if po_ptr == 0 then
                if state._was_attached then
                    invalidate_on_transition(pid)
                end
                state._was_attached = false
                state.entities = {}
                return
            end
            local lp = get_localplayer()
            if lp == 0 then
                if state._was_attached then
                    invalidate_on_transition(pid)
                end
                state._was_attached = false
                state.entities = {}
                return
            end
 
            local lp_pos, lp_pos_len = read_bytes_table(lp + OFF.entityPos, 12)
            if lp_pos_len and lp_pos_len >= 12 then
                state.local_pos = parse_f32_array(lp_pos, 3)
            end
 
            local matrix_rects = state.window_rect
            if not matrix_rects or not matrix_rects[1] then
                matrix_rects = {{x = 0, y = 0, width = 1920, height = 1080}}
            end
            local matrix_rect = matrix_rects[1]
            local function projects_local_position(matrix)
                if not matrix or not matrix_rect or not state.local_pos then return false end
                local x, y, z = state.local_pos[1], state.local_pos[2], state.local_pos[3]
                if not is_finite(x) or not is_finite(y) or not is_finite(z) then return false end
                local cx = matrix[1] * x + matrix[5] * y + matrix[9] * z + matrix[13]
                local cy = matrix[2] * x + matrix[6] * y + matrix[10] * z + matrix[14]
                local cw = matrix[4] * x + matrix[8] * y + matrix[12] * z + matrix[16]
                if not is_finite(cx) or not is_finite(cy) or not is_finite(cw) or cw <= 0.001 then
                    return false
                end
                local sx = matrix_rect.x + (cx / cw + 1) * matrix_rect.width / 2
                local sy = matrix_rect.y + (1 - cy / cw) * matrix_rect.height / 2
                return is_finite(sx) and is_finite(sy)
                    and sx >= matrix_rect.x - matrix_rect.width * 0.75
                    and sx <= matrix_rect.x + matrix_rect.width * 1.75
                    and sy >= matrix_rect.y - matrix_rect.height * 0.75
                    and sy <= matrix_rect.y + matrix_rect.height * 1.75
            end
            if direct_matrix and projects_local_position(direct_matrix) then
                state.viewproj = direct_matrix
                state.viewproj_source = "direct"
            elseif pointer_matrix and projects_local_position(pointer_matrix) then
                state.viewproj = pointer_matrix
                state.viewproj_source = "pointer"
            elseif direct_matrix then
                state.viewproj = direct_matrix
                state.viewproj_source = "direct-unchecked"
            elseif pointer_matrix then
                state.viewproj = pointer_matrix
                state.viewproj_source = "pointer-unchecked"
            else
                state.viewproj = nil
                state.viewproj_source = "unavailable"
            end
 
            local lp_faction_raw = read_bytes_table(lp + OFF.factionCtx, 8)
            local local_faction = 0
            if #lp_faction_raw == 8 then
                local_faction = uint_from(lp_faction_raw, 1, 8)
            end
            if state.faction_tag_pid ~= pid then
                state.faction_tag_cache = {}
                state.faction_tag_pid = pid
            end
            local scan_ctx = {
                local_player  = lp,
                local_faction = local_faction,
                tag_cache     = state.faction_tag_cache,
            }
 
            local meta = batch_read_chunked(pid, 8, {
                po_ptr + OFF.entityArray,
                po_ptr + OFF.entityCount,
            })
            local arr_ptr = 0
            local count = 0
            if #meta >= 12 then
                arr_ptr = uint_from(meta, 1, 8)
                count = uint_from(meta, 9, 4)
            end
 
            local prev_arr   = state._last_arr_ptr or 0
            local prev_count = state._last_count or 0
 
            local ptrs = {}
            if arr_ptr ~= 0 and count > 0 then
                local read_count = math.min(count, 512)
                local list_data = read_bytes_table(arr_ptr, read_count * 8)
                if #list_data >= read_count * 8 then
                    for i = 0, read_count - 1 do
                        local ep = uint_from(list_data, i * 8 + 1, 8)
                        if ep ~= 0 and ep > 0x10000 and ep < 0x7FFFFFFFFFFF then
                            ptrs[#ptrs + 1] = ep
                        end
                    end
                end
            end
            if #ptrs > 200 then
                local trimmed = {}
                for i = 1, 200 do trimmed[i] = ptrs[i] end
                ptrs = trimmed
            end
 
            local transition = false
            if arr_ptr ~= 0 and prev_arr ~= 0 and arr_ptr ~= prev_arr then
                transition = true
            end
            if prev_count > 0 and count == 0 then
                transition = true
            end
            if not transition
               and state._last_ptrs
               and #ptrs >= MIN_OVERLAP_CHECK_COUNT
               and #state._last_ptrs >= MIN_OVERLAP_CHECK_COUNT then
                local seen = {}
                for _, v in ipairs(state._last_ptrs) do seen[v] = true end
                local ov = 0
                for _, v in ipairs(ptrs) do if seen[v] then ov = ov + 1 end end
                local denom = math.min(#ptrs, #state._last_ptrs)
                if ov < denom * 0.25 then transition = true end
            end
 
            if transition then
                invalidate_on_transition(pid)
            end
 
            state._last_arr_ptr = arr_ptr
            state._last_count   = count
            state._last_ptrs    = ptrs
            state._was_attached = true
 
            if arr_ptr ~= 0 and arr_ptr == prev_arr and count == prev_count and count > 0 then
                state._stable_frames = (state._stable_frames or 0) + 1
            else
                state._stable_frames = 0
            end
 
            if state._transition_frames and state._transition_frames > 0 then
                state._transition_frames = state._transition_frames - 1
            end
 
            state.scan_info = string.format("po=0x%X arr=0x%X cnt=%d", po_ptr, arr_ptr, count)
            if arr_ptr == 0 or count == 0 then
                state.entities = {}
                return
            end
            if #ptrs == 0 then
                state.entities = {}
                return
            end
 
            local probe_ok = false
            local probe_count = math.min(#ptrs, 4)
            for pi = 1, probe_count do
                local probe = read_bytes_table(ptrs[pi] + OFF.entityType, 8)
                if #probe >= 4 then
                    local printable = 0
                    for i = 1, 8 do
                        local b = probe[i]
                        if b and b >= 0x20 and b < 0x7F then printable = printable + 1 end
                    end
                    if printable >= 4 then probe_ok = true; break end
                end
            end
            if not probe_ok then
                state.entities = {}
                return
            end
 
            local pos_addrs = {}
            local type_addrs = {}
            local name_addrs = {}
            local rel_addrs = {}
            local down_addrs = {}
            local fac_addrs = {}
            local ty_addrs = {}
            for _, ep in ipairs(ptrs) do
                pos_addrs[#pos_addrs + 1] = ep + OFF.entityPos
                type_addrs[#type_addrs + 1] = ep + OFF.entityType
                name_addrs[#name_addrs + 1] = ep + OFF.entityName
                rel_addrs[#rel_addrs + 1] = ep + OFF.relation
                down_addrs[#down_addrs + 1] = ep + OFF.isDowned
                fac_addrs[#fac_addrs + 1] = ep + OFF.factionCtx
                ty_addrs[#ty_addrs + 1] = ep + OFF.entityTypeInt
            end
            local raw      = batch_read_chunked(pid, 12, pos_addrs)
            local type_raw = batch_read_chunked(pid, 16, type_addrs)
            local name_raw = batch_read_chunked(pid, 16, name_addrs)
            local rel_raw  = batch_read_chunked(pid, 8,  rel_addrs)
            local down_raw = batch_read_chunked(pid, 4,  down_addrs)
            local fac_raw  = batch_read_chunked(pid, 8,  fac_addrs)
            local ty_raw   = batch_read_chunked(pid, 4,  ty_addrs)
 
            local hp_addrs = {}
            for _, ep in ipairs(ptrs) do
                hp_addrs[#hp_addrs + 1] = ep + OFF.hpPtr
            end
            local hp_raw = batch_read_chunked(pid, 8, hp_addrs)
 
            local hp_valid_index = {}
            local hp_data_addrs = {}
            local wp_armor_addrs = {}
            local hp_slot_count = 0
            for i = 1, #ptrs do
                local off = (i - 1) * 8
                if #hp_raw >= off + 8 then
                    local hp = uint_from(hp_raw, off + 1, 8)
                    if hp ~= 0 then
                        hp_slot_count = hp_slot_count + 1
                        hp_valid_index[i] = hp_slot_count
                        hp_data_addrs[#hp_data_addrs + 1] = hp + OFF.health
                        hp_data_addrs[#hp_data_addrs + 1] = hp + OFF.healthMax
                        -- prop armor/shield pool (only meaningful for weak
                        -- points; garbage on agents is filtered out later via
                        -- the hp_max sanity check in is_alive_weak_point)
                        wp_armor_addrs[hp_slot_count] = hp + OFF.wpArmor
                    end
                end
            end
            local hp_data_raw = #hp_data_addrs > 0
                and batch_read_chunked(pid, 4, hp_data_addrs) or nil

            local wp_armor_raw = nil
            if #wp_armor_addrs > 0 then
                local a_list = {}
                for s = 1, hp_slot_count do a_list[#a_list + 1] = wp_armor_addrs[s] end
                wp_armor_raw = batch_read_chunked(pid, 4, a_list)
            end
 
            do
                local misses, seen = {}, {}
                for i = 1, #ptrs do
                    local off = (i - 1) * 8
                    if #fac_raw >= off + 8 then
                        local f = uint_from(fac_raw, off + 1, 8)
                        if f ~= 0 and state.faction_tag_cache[f] == nil
                            and not seen[f] then
                            seen[f] = true
                            misses[#misses + 1] = f
                        end
                    end
                end
                if #misses > 0 then
                    local tag_addrs = {}
                    for _, f in ipairs(misses) do
                        tag_addrs[#tag_addrs + 1] = f + OFF.factionTag
                    end
                    local tag_raw = batch_read_chunked(pid, 16, tag_addrs)
                    if #tag_raw >= #misses * 16 then
                        for idx, f in ipairs(misses) do
                            local toff = (idx - 1) * 16
                            local chars, ok = {}, true
                            for j = 1, 16 do
                                local b = tag_raw[toff + j]
                                if b == 0 then break end
                                if b < 0x20 or b >= 0x7F then
                                    ok = false
                                    break
                                end
                                chars[#chars + 1] = string.char(b)
                            end
                            state.faction_tag_cache[f] =
                                ok and table.concat(chars) or ""
                        end
                    end
                end
            end
 
            local function type_str_at(idx)
                if not type_raw then return "" end
                local toff = (idx - 1) * 16
                if #type_raw < toff + 4 then return "" end
                local chars = {}
                for j = 0, 15 do
                    local b = type_raw[toff + j + 1]
                    if b == nil or b == 0 then break end
                    if b >= 0x20 and b < 0x7F then
                        chars[#chars + 1] = string.char(b)
                    else
                        break
                    end
                end
    return table.concat(chars)
end
 
            local ents = {}
            if raw then
                for i = 1, #ptrs do
                    local off = (i - 1) * 12
                    if #raw >= off + 12 then
                        local px = from_f32(uint_from(raw, off + 1, 4))
                        local py = from_f32(uint_from(raw, off + 5, 4))
                        local pz = from_f32(uint_from(raw, off + 9, 4))
                        local pos = {px, py, pz}
                        if is_finite(px) and is_finite(py) and is_finite(pz) then
                            local dist = vec_dist(state.local_pos, pos)
                            local ent_name = ""
                            if name_raw then
                                local noff = (i - 1) * 16
                                if #name_raw >= noff + 16 then
                                    local chars = {}
                                    for j = 0, 15 do
                                        local b = name_raw[noff + j + 1]
                                        if b == 0 then break end
                                        if b >= 0x20 and b < 0x7F then
                                            chars[#chars + 1] = string.char(b)
                                        end
                                    end
                                    ent_name = table.concat(chars)
                                end
                            end
                            if dist < state.esp_max_dist then
                                local is_downed = false
                                if down_raw then
                                    local doff = (i - 1) * 4
                                    if #down_raw >= doff + 4 then
                                        is_downed = (uint_from(down_raw, doff + 1, 4) ~= 0)
                                    end
                                end
                                if not is_downed then
                                    local type_str = type_str_at(i)
                                    local is_player = (type_str == "soldier")
 
                                    local archetype = nil
                                    local tier = NPC_THREAT_TIER.NonThreat
                                    local tier_valid = false
                                    local entity_type_val = is_player and ENTITY_TYPE_PLAYER
                                                          or ENTITY_TYPE_NPC
                                    local entity_type_int = 0
                                    if ty_raw then
                                        local tyoff = (i - 1) * 4
                                        if #ty_raw >= tyoff + 4 then
                                            entity_type_int = uint_from(ty_raw, tyoff + 1, 4)
                                            if entity_type_int >= 0x80000000 then
                                                entity_type_int = entity_type_int - 0x100000000
                                            end
                                        end
                                    end
                                    if not is_player then
                                        local a_raw, t_raw = read_npc_archetype_and_tier(ptrs[i])
                                        if a_raw ~= nil then archetype = a_raw end
                                        if t_raw ~= nil then
                                            tier = t_raw
                                            tier_valid = true
                                        end
                                    end
 
                                    local relation = "unknown"
                                    local relation_raw = 0
                                    local rel_verdict = nil
                                    local faction = 0
                                    if rel_raw then
                                        local roff = (i - 1) * 8
                                        if #rel_raw >= roff + 8 then
                                            relation_raw = uint_from(rel_raw, roff + 1, 8)
                                            if not is_player then
                                                if match_relation(rel_raw, roff, RELATION_HOSTILE) then
                                                    rel_verdict = "hostile"
                                                elseif match_relation(rel_raw, roff, RELATION_FRIENDLY) then
                                                    rel_verdict = "friendly"
                                                elseif match_relation(rel_raw, roff, RELATION_NEUTRAL) then
                                                    rel_verdict = "neutral"
                                                end
                                            end
                                        end
                                    end
                                    if fac_raw then
                                        local foff = (i - 1) * 8
                                        if #fac_raw >= foff + 8 then
                                            faction = uint_from(fac_raw, foff + 1, 8)
                                        end
                                    end
                                    local faction_tag = state.faction_tag_cache[faction] or ""
 
                                    local hp_val, hp_max = 0, 0
                                    local wp_armor = 0
                                    local vi = hp_valid_index[i]
                                    if vi and hp_data_raw then
                                        local doff = (vi - 1) * 8
                                        if #hp_data_raw >= doff + 8 then
                                            hp_val = uint_from(hp_data_raw, doff + 1, 4)
                                            hp_max = uint_from(hp_data_raw, doff + 5, 4)
                                        end
                                    end
                                    if vi and wp_armor_raw then
                                        local aoff = (vi - 1) * 4
                                        if #wp_armor_raw >= aoff + 4 then
                                            wp_armor = uint_from(wp_armor_raw, aoff + 1, 4)
                                        end
                                    end
                                    local is_low_hp = hp_max > 0 and (hp_val / hp_max) < 0.1
 
                                    local classified = classify_entity({
                                        is_player       = is_player,
                                        faction         = faction,
                                        faction_tag     = faction_tag,
                                        archetype       = archetype,
                                        tier            = tier,
                                        tier_valid      = tier_valid,
                                        entity_ptr      = ptrs[i],
                                        entity_type_int = entity_type_int,
                                        rel_verdict     = rel_verdict,
                                    }, scan_ctx)
                                    if classified == "unknown"
                                       and archetype ~= nil
                                       and archetype ~= NPC_ARCHETYPE.Unset then
                                        classified = "hostile"
                                    end
                                    if is_player then
                                        relation = (classified == "hostile")
                                            and "hostile" or "player"
                                    else
                                        relation = classified
                                    end
 
                                    local summon_kind = nil
                                    if not is_player and archetype ~= nil then
                                        if ARCHETYPE_IS_DRONE[archetype] then
                                            summon_kind = "drone"
                                        elseif ARCHETYPE_IS_DOG[archetype] then
                                            summon_kind = "dog"
                                        elseif archetype == NPC_ARCHETYPE.MiniTank then
                                            summon_kind = "tank"
                                        elseif ARCHETYPE_IS_TURRET[archetype] then
                                            summon_kind = "turret"
                                        elseif ARCHETYPE_IS_GADGET[archetype] then
                                            summon_kind = "gadget"
                                        end
                                    end
 
                                    local prev_by_ptr = state._prev_pos_by_ptr
                                    local prev = prev_by_ptr and prev_by_ptr[ptrs[i]] or nil
                                    local pred_pos = { pos[1], pos[2], pos[3] }
                                    if prev then
                                        pred_pos[1] = pos[1] + (pos[1] - prev[1]) * ESP_PREDICT_STRENGTH
                                        pred_pos[2] = pos[2] + (pos[2] - prev[2]) * ESP_PREDICT_STRENGTH
                                        pred_pos[3] = pos[3] + (pos[3] - prev[3]) * ESP_PREDICT_STRENGTH
                                    end

                                    -- weak-point kind tag for ESP / target name:
                                    -- HEALER (boss healing backpack), FUEL
                                    -- (flamethrower tank / generator), EXPLOSIVE
                                    local wp_tier, wp_label = nil, nil
                                    if not is_player then
                                        local probe = {
                                            is_player       = false,
                                            is_downed       = is_downed,
                                            archetype       = archetype,
                                            ent_name        = ent_name,
                                            entity_type_int = entity_type_int,
                                            has_hp          = (vi ~= nil),
                                            hp_max          = hp_max,
                                            wp_armor        = wp_armor,
                                        }
                                        if is_weak_point_entity(probe) then
                                            wp_tier, wp_label = classify_weak_point(probe)
                                        end
                                    end

                                    ents[#ents + 1] = {
                                        pos = pos, pred_pos = pred_pos,
                                        dist = dist, entity_ptr = ptrs[i],
                                        ent_type = is_player and "player" or "npc",
                                        entity_type = entity_type_val,
                                        entity_type_int = entity_type_int,
                                        is_player = is_player,
                                        is_summoned = (summon_kind ~= nil),
                                        summon_kind = summon_kind,
                                        ent_name = ent_name,
                                        type_str = type_str,
                                        relation = relation, relation_raw = relation_raw,
                                        faction = faction,
                                        faction_tag = faction_tag,
                                        is_downed = is_downed,
                                        hp = hp_val, hp_max = hp_max,
                                        wp_armor = wp_armor,
                                        has_hp = (vi ~= nil),
                                        is_low_hp = is_low_hp,
                                        archetype = archetype,
                                        archetype_name = (archetype ~= nil)
                                            and ARCHETYPE_NAME_BY_ID[archetype] or nil,
                                        tier = tier, tier_valid = tier_valid,
                                        wp_tier = wp_tier, wp_label = wp_label,
                                    }
                                end
                            end
                        end
                    end
                end
            end
 
            if (state.esp_boxes or state.esp_bones or state.silent_enabled) and #ents > 0 then
                local bone_ents = {}
                for _, e in ipairs(ents) do
                    if should_show(e) or state.silent_enabled then
                        bone_ents[#bone_ents + 1] = e
                    end
                end
                local bone_data = read_bones(pid, bone_ents, state.esp_bone_ids)
                local bi = 1
                for _, e in ipairs(ents) do
                    if should_show(e) or state.silent_enabled then
                        e.bones = bone_data[bi]
                        bi = bi + 1
                    end
                end
            end
 
            local prev_map = {}
            for _, e in ipairs(ents) do
                prev_map[e.entity_ptr] = e.pos
            end
            state._prev_pos_by_ptr = prev_map
 
            state.entities = ents
        end)
        if not ok then state.status = "Scan: " .. tostring(err) end
 
 
        silent_tick(pid, base)
        pcall(wp_watchdog)
 
        state.telem_valid       = false
        state.telem_world_aim   = nil
        state.telem_lock_target = nil
        state.telem_delta       = nil
        state.telem_rounds      = 0
        state.telem_lock_addr   = nil
 
        pcall(function()
            local lp = get_localplayer()
            if lp == 0 then return end
            local aimp = read_uint(lp + OFF.aimCtrl, 8)
            if aimp == 0 then return end
 
            state.telem_lock_addr = state.silent_lock_addr
            state.telem_rounds    = read_uint(aimp + OFF.combatAimRoundsFired, 4)
            state.telem_world_aim = read_world_aim(aimp)
 
            if state.silent_armed and state.silent_lock_addr then
                state.telem_lock_target = state.diag_last_write
            end
 
            if state.telem_world_aim and state.telem_lock_target then
                local p  = state.telem_world_aim
                local wd = state.telem_lock_target
                local dx, dy, dz = p[1] - wd[1], p[2] - wd[2], p[3] - wd[3]
                state.telem_delta = math.sqrt(dx*dx + dy*dy + dz*dz)
            end
            state.telem_valid = true
        end)
 
        local wr = state.window_rect
        if not wr or #wr == 0 then
            wr = {{x = 0, y = 0, width = 1920, height = 1080}}
        end
        local w = wr[1]
        local m = state.viewproj
        if m and #m >= 16 and w and w.width and w.width > 0 then
            local cx, cy = w.x + w.width / 2, w.y + w.height
 
            if state.silent_enabled and state.esp_show_silent_fov then
                local cross_x = w.x + w.width / 2
                local cross_y = w.y + w.height / 2
                local cr, cg, cb = 255, 200, 0
                if state.silent_armed then cr, cg, cb = 0, 255, 100 end
                draw_fov_circle(cross_x, cross_y, state.silent_fov, cr, cg, cb, 140)
            end
 
            if state.esp_enabled then
                for _, e in ipairs(state.entities) do
                    pcall(function()
                    if should_show(e) then
                        local draw_pos = e.pos
                        local sx, sy = world_to_screen(draw_pos, m, w)
                        if sx and sy then
                            local cr = get_color(e)
                            local pname = profile_name_for(e)
                            local prof = BONE_PROFILES[pname]
 
                            local is_summon_box = pname == "DRONE" or pname == "TURRET"
                                or pname == "MINITANK"
                                or pname == "BIG_DOG" or pname == "WARHOUND_GRENADIER"
                                or pname == "WARHOUND_MINIGUN"
                            local is_wp = is_weak_point_entity(e)
                            if is_wp then is_summon_box = true end
                            local draw_box = state.esp_boxes
                                and ( is_summon_box
                                      or not state.esp_bones
                                      or (e.bones ~= nil and next(e.bones) ~= nil) )
 
                            local box_h, box_w, box_cx, box_cy = compute_box(e, m, w, sx, sy)
                            sx = box_cx or sx

                            -- for weak-point props draw an explicit marker at
                            -- the exact world position silent aim writes into
                            -- the aim-control (damage-volume center). If this
                            -- cross does NOT sit on the visible prop (e.g. it
                            -- appears in the NPC's legs), the offset heuristic
                            -- below needs adjusting for that prop type.
                            if is_wp then
                                local ap = aim_point_for_weak_point(e)
                                local ax, ay = world_to_screen(ap, m, w)
                                if ax and ay then
                                    draw.line(ax - 6, ay, ax + 6, ay, 255, 200, 0, 230, 1.5)
                                    draw.line(ax, ay - 6, ax, ay + 6, 255, 200, 0, 230, 1.5)
                                    draw.circle(ax, ay, 4, 255, 200, 0, 180, 1.0)
                                end
                            end
 
                            if state.esp_snaplines then
                                local snap_y = is_summon_box and sy or box_cy
                                draw.line(cx, cy, sx, snap_y, 100, 100, 255, 120, 1.0)
                            end
 
                            if draw_box then
                                draw.rect(sx - box_w / 2, box_cy - box_h / 2, box_w, box_h,
                                          cr[1], cr[2], cr[3], 180, 1.0)
                                if e.hp_max > 0 and e.hp > 0 then
                                    local ratio = math.min(e.hp / e.hp_max, 1.0)
                                    local bar_x = sx - box_w / 2 - 4
                                    local bar_top = box_cy - box_h / 2
                                    local green_h = box_h * ratio
                                    local red_h = box_h - green_h
                                    if red_h > 0 then
                                        draw.filled_rect(bar_x, bar_top, 3, red_h, 200, 0, 0, 200)
                                    end
                                    if green_h > 0 then
                                        draw.filled_rect(bar_x, bar_top + red_h, 3, green_h, 0, 200, 0, 200)
                                    end
                                end
                            end
 
                            if state.esp_bones and e.bones and prof then
                                local cr1, cr2, cr3 = cr[1], cr[2], cr[3]
                                if prof.connections then
                                    for _, seg in ipairs(prof.connections) do
                                        local p1 = e.bones[seg[1]]
                                        local p2 = e.bones[seg[2]]
                                        if p1 and p2 then
                                            local x1, y1 = world_to_screen(p1, m, w)
                                            local x2, y2 = world_to_screen(p2, m, w)
                                            if x1 and x2 then
                                                draw.line(x1, y1, x2, y2, cr1, cr2, cr3, 200, 1.5)
                                            end
                                        end
                                    end
                                end
                            end
 
                            if state.esp_bone_ids and state.esp_bones and e.bones then
                                for bid, bp in pairs(e.bones) do
                                    local bx, by = world_to_screen(bp, m, w)
                                    if bx and by then
                                        local label = tostring(bid)
                                        draw.text(bx + 1, by + 1, label, 0, 0, 0, 200, 10)
                                        draw.text(bx,     by,     label, cr[1], cr[2], cr[3], 230, 10)
                                    end
                                end
                            end
 
                            if state.esp_distance then
                                local txt = string.format("%.0fm", e.dist)
                                draw.text(sx - #txt * 3, box_cy + box_h / 2 + 2, txt, 120, 180, 120, 200, 10)
                            end
 
                            if state.esp_name and e.ent_name and e.ent_name ~= "" then
                                draw.text(sx - #e.ent_name * 3, box_cy - box_h / 2 - 12, e.ent_name, 255, 255, 255, 220, 10)
                            end
 
                            if state.esp_type and e.ent_type then
                                local tlabel = e.ent_type
                                if is_wp then
                                    tlabel = string.format(
                                        "%s hp %d/%d%s Ty%d A%s",
                                        e.wp_label or "WEAKPOINT",
                                        e.hp or 0, e.hp_max or 0,
                                        ((e.wp_armor or 0) > 0)
                                            and (" ar" .. tostring(e.wp_armor)) or "",
                                        e.entity_type_int or 0,
                                        tostring(e.archetype))
                                elseif e.archetype_name then
                                    tlabel = tlabel .. ":" .. e.archetype_name
                                end
                                local yoff = state.esp_name and -24 or -12
                                draw.text(sx - #tlabel * 3, box_cy - box_h / 2 + yoff, tlabel, cr[1], cr[2], cr[3], 200, 10)
                            end
 
                            if state.esp_show_relation and e.relation_raw then
                                local rtxt = string.format("0x%X", e.relation_raw)
                                local yoff = -12
                                if state.esp_name then yoff = yoff - 12 end
                                if state.esp_type then yoff = yoff - 12 end
                                draw.text(sx - #rtxt * 3, box_cy - box_h / 2 + yoff, rtxt, 200, 200, 200, 180, 10)
                            end
 
                            if state.esp_show_faction and e.faction then
                                local ftxt = faction_display(e.faction, e.faction_tag)
                                local yoff = -12
                                if state.esp_name then yoff = yoff - 12 end
                                if state.esp_type then yoff = yoff - 12 end
                                if state.esp_show_relation then yoff = yoff - 12 end
                                draw.text(sx - #ftxt * 3, box_cy - box_h / 2 + yoff, ftxt, 180, 180, 255, 180, 10)
                            end
 
                            if state.esp_desc_test then
                                local dtxt
                                if e.is_player then
                                    dtxt = string.format("Ty%d Player", e.entity_type_int or 0)
                                else
                                    local a_raw, t_raw = test_read_desc_chain(e.entity_ptr)
                                    dtxt = string.format("A%s T%s Ty%d",
                                                         tostring(a_raw), tostring(t_raw),
                                                         e.entity_type_int or 0)
                                end
                                local yoff = -12
                                if state.esp_name then yoff = yoff - 12 end
                                if state.esp_type then yoff = yoff - 12 end
                                if state.esp_show_relation then yoff = yoff - 12 end
                                if state.esp_show_faction then yoff = yoff - 12 end
                                draw.text(sx - #dtxt * 3, box_cy - box_h / 2 + yoff, dtxt, 255, 200, 80, 200, 10)
                            end
                        end
                    end
                    end)
                end
            end
        end
    end
 
    if state.pid ~= 0 and state.base ~= 0 then
        if state.no_recoil then
            if not state.recoil_locked then
                pcall(apply_recoil)
            else
                local ok = pcall(memory.lock_rva, LOCK_ID.recoil, state.pid, RVA.recoil, pack_f32(0.0))
                if not ok then
                    state.recoil_locked = false
                    pcall(apply_recoil)
                end
            end
        end
        if state.no_spread then
            if not state.spread_rva_locked then
                pcall(apply_spread)
            else
                local ok = pcall(memory.lock_rva, LOCK_ID.spread_rva, state.pid, RVA.spread, pack_f32(0.0))
                if not ok then
                    state.spread_rva_locked = false
                    pcall(apply_spread)
                end
            end
        end
        if state.rpm_enabled then rpm_tick() end
        if state.instant_reload then instant_reload_tick() end
 
        accuracy_locked_tick()
        fire_interval_tick()
        headshot_dmg_tick()
        if state.no_sway then sway_tick() end
        if state.extended_range then extended_range_tick() end
 
        if state.move_speed and not teleport_guard() then move_speed_tick() end
 
        state.stats_timer = state.stats_timer + (dt or 0)
        if state.stats_timer >= 1.0 then
            state.stats_timer = 0
            pcall(refresh_stats)
            for k, fn in pairs(ONE_SHOT_APPLIES) do
                if state[k] then pcall(fn) end
            end
            if state.time_mode ~= "normal" then
                pcall(apply_time, state.time_mode)
            end
        end
    end
 
    if draw and draw.text then
        local rows = {
            { "Master",         state.master_enabled },
            { "ESP",            state.esp_enabled },
            { "Silent aim",     state.silent_enabled },
            { "Target gadgets", state.target_gadgets },
            { "Weak points first", state.weak_points_first },
            { "No recoil",      state.no_recoil },
            { "No spread",      state.no_spread },
            { "Magic bullet",   state.magic_bullet },
            { "No sway",        state.no_sway },
            { "No move spread", state.move_speed },
            { "Ext range",      state.extended_range },
            { "Inst reload",    state.instant_reload },
            { "Accuracy lock",  state.accuracy_locked },
            { "Fast fire",      state.fast_fire },
            { "Headshot Dmg",   state.high_headshot_dmg },
            { "RPM",            state.rpm_enabled },
        }
        local gx, gy = 0, 0
        local wr = state.window_rect
        if wr and #wr > 0 then
            gx, gy = wr[1].x + 12, wr[1].y + 40
        end
        local ox, oy, lh = gx, gy, 16
        for _, r in ipairs(rows) do
            local label = r[1] .. ": " .. (r[2] and "ON" or "OFF")
            if r[1] == "RPM" and r[2] then
                label = string.format("RPM: ON (%d)", state.rpm_value)
            end
            if r[2] then
                draw.text(ox, oy, label, 0, 255, 100, 220, 13)
            else
                draw.text(ox, oy, label, 255, 60, 60, 210, 13)
            end
            oy = oy + lh
        end
    end
 
    local title = state.pid ~= 0
        and string.format("TD2 [PID %d]", state.pid)
        or "TD2"
    ui.window(title, function()
        if state.pid ~= 0 then
            ui.monospace(string.format("Base 0x%X", state.base))
        else
            ui.small("Not attached - auto-search every 2s")
        end
        ui.separator()
 
        ui.scroll_area(560, function()
            ui.collapsing_header("Config", function()
                if ui.button("Save") then cfg_save() end
                if ui.button("Load") then cfg_load() end
                if ui.button("Overwrite") then cfg_overwrite() end
                ui.separator()
                ui.small("Save      - write current settings to config.json")
                ui.small("Load      - read config.json into this session")
                ui.small("Overwrite - replace config.json with current settings")
                ui.small("(Auto-save on exit/tick is disabled)")
            end)
 
            ui.collapsing_header("Toggles", function()
                ui.separator()
                local mv, mv_ch = ui.checkbox("Master (F1)", state.master_enabled)
                if mv_ch then set_master(mv) end
                ui.small("F1 = master on/off   F2 = RPM on/off")
                ui.separator()
                chk("ESP", "esp_enabled")
                chk("Silent aim", "silent_enabled")
                chk("Target gadgets", "target_gadgets")
                chk("No recoil", "no_recoil", apply_recoil)
                chk("No spread", "no_spread", apply_spread)
                chk("Magic bullet (NPC-only)", "magic_bullet", apply_magic_bullet)
                chk("No sway", "no_sway", apply_no_sway)
                chk("No move spread", "move_speed", apply_move_speed)
                chk("Extended range", "extended_range", apply_extended_range)
                chk("Instant reload", "instant_reload")
                chk("Accuracy Locked (Focused Accuracy)", "accuracy_locked")
                chk("Fast Fire Interval (RapidFire)", "fast_fire")
                chk("High Headshot Damage", "high_headshot_dmg")
                state.headshot_dmg_multiplier = select(1, ui.slider_f32(
                    "Headshot Multiplier", state.headshot_dmg_multiplier, 1.0, 10.0))
                state.headshot_dmg_multiplier = math.max(1.0, math.min(10.0,
                    tonumber(state.headshot_dmg_multiplier) or 3.0))
                if state.weapon_max_damage and is_finite(state.weapon_max_damage) then
                    ui.small(string.format("Max damage: %.2f", state.weapon_max_damage))
                else
                    ui.small("Weapon max damage: unavailable")
                end
                chk("RPM override (F2)", "rpm_enabled", function()
                    if not state.rpm_enabled then pcall(restore_rpm) end
                end)
            end)
 
            ui.collapsing_header("Silent Aim Settings", function()
                ui.monospace("Target part")
                if checkbox_edge("Head",   state.aim_part == "head")   then state.aim_part = "head"   end
                if checkbox_edge("Chest",  state.aim_part == "chest")  then state.aim_part = "chest"  end
                if checkbox_edge("Pelvis", state.aim_part == "pelvis") then state.aim_part = "pelvis" end
                ui.small("Current: " .. state.aim_part)
                ui.small("(humanoid rigs honor this; vehicles use profile aim bone)")
                chk("Weak points first (backpacks/tanks)", "weak_points_first")
                ui.small("Silent aim shoots boss backpacks/propane tanks before switching to the head")
                state.wp_aim_lift = select(1, ui.slider_f32("Weak point aim lift x", state.wp_aim_lift, 0.0, 3.0))
                ui.small(string.format("Vertical lift of prop aim point (%.2fx; tank ~%.1fm, generator ~%.1fm above origin)",
                    state.wp_aim_lift, 0.70 * state.wp_aim_lift, 1.00 * state.wp_aim_lift))
 
                ui.separator()
                state.silent_fov = select(1, ui.slider_f32("FOV", state.silent_fov, 10, 800))
                state.silent_max_dist = select(1, ui.slider_f32("Max dist", state.silent_max_dist, 10, 800))
                chk("Show FOV circle", "esp_show_silent_fov")
                chk("Enemy Summons", "silent_target_summon")
 
                ui.separator()
                ui.small("Target: " .. (state.silent_target_name ~= "" and state.silent_target_name or "none"))
                ui.small(state.silent_armed and "ARMED (kernel lock ~10ms)" or "idle")
                ui.small("Shots: " .. state.silent_shots)
                ui.separator()
                ui.small(string.format("Weak points nearby: %d  locked: %d  destroyed: %d",
                    count_weak_point_candidates(),
                    state.wp_lock_ptr and 1 or 0,
                    state.wp_destroyed))
                if state.hit_debug ~= "" then ui.small(state.hit_debug) end
            end)
 
            ui.collapsing_header("ESP settings", function()
                ui.monospace("Visuals")
                chk("Boxes", "esp_boxes")
                chk("Distance", "esp_distance")
                chk("Snap lines", "esp_snaplines")
                chk("Bones", "esp_bones")
                chk("Bone IDs", "esp_bone_ids")
                ui.small("Bone IDs dumps all 0..90 bones (slow, debug only)")
                chk("Type", "esp_type")
                chk("Name", "esp_name")
                ui.separator()
                ui.monospace("Filters")
                chk("Hostile", "esp_show_hostile")
                chk("Friendly", "esp_show_friendly")
                chk("Neutral", "esp_show_neutral")
                chk("Player", "esp_show_player")
                chk("Other", "esp_show_other")
                chk("Relation", "esp_show_relation")
                chk("Faction", "esp_show_faction")
                chk("[TEST] Desc A/T", "esp_desc_test")
                state.esp_max_dist = select(1, ui.drag_value_u64("Max dist", state.esp_max_dist))
                ui.small(string.format("Entities: %d  VM: %s",
                    #state.entities, state.viewproj_source or (state.viewproj and "OK" or "none")))
                if state.scan_info ~= "" then ui.code(state.scan_info) end
            end)
 
            ui.collapsing_header("RPM settings", function()
                local sv = select(1, ui.slider_f32("RPM", state.rpm_value, RPM_MIN, RPM_MAX))
                state.rpm_value = math.floor(sv + 0.5)
                state.rpm_value = select(1, ui.drag_value_i32("exact", state.rpm_value))
                sanitize_rpm_value()
                ui.small(string.format("live %.0f  target %d", state.rpm_live, state.rpm_value))
                if ui.button("Read RPM") then pcall(read_rpm_once) end
            end)
 
            ui.collapsing_header("Player", function()
                ui.label("Name: " .. (state.lp_name ~= "" and state.lp_name or "?"))
                ui.label(string.format("HP: %d / %d", state.hp, state.hp_max))
                ui.label(string.format("Armor: %d / %d", state.armor, state.armor_max))
                ui.small("auto-refresh 1s")
            end)
 
            ui.collapsing_header("World", function()
                ui.monospace("Time of day")
                if checkbox_edge("Noon",   state.time_mode == "noon")   then pcall(apply_time, "noon")   end
                if checkbox_edge("Night",  state.time_mode == "night")  then pcall(apply_time, "night")  end
                if checkbox_edge("Normal", state.time_mode == "normal") then pcall(apply_time, "normal") end
                ui.small("Current: " .. state.time_mode)
            end)
 
            ui.collapsing_header("Debug", function()
                ui.monospace("RVA read")
                state.read_rva = select(1, ui.text_edit(state.read_rva, false, false, false))
                state.read_size = select(1, ui.drag_value_u64("size", state.read_size))
                if ui.button("Read") then
                    local rva = tonumber(state.read_rva)
                    if rva and state.pid ~= 0 then
                        local okr, data = pcall(memory.read_rva, state.pid, rva,
                            math.min(math.max(state.read_size, 1), 256))
                        if okr and data then
                            local bytes, n = to_byte_table(data)
                            local hex = {}
                            for i = 1, n do hex[i] = string.format("%02X", bytes[i]) end
                            state.read_result = table.concat(hex, " ")
                        else
                            state.read_result = "read failed"
                        end
                    end
                end
                ui.code(state.read_result)
                ui.separator()
                ui.monospace("Silent aim live")
                if state.telem_valid then
                    local p  = state.telem_world_aim
                    local wd = state.telem_lock_target
                    if p then
                        ui.small(string.format("worldAimPos %.2f %.2f %.2f", p[1], p[2], p[3]))
                    else
                        ui.small("worldAimPos -")
                    end
                    if wd then
                        ui.small(string.format("lock target %.2f %.2f %.2f", wd[1], wd[2], wd[3]))
                    else
                        ui.small("lock target -")
                    end
                    if state.telem_delta then
                        ui.small(string.format("delta %.3f  %s",
                            state.telem_delta,
                            state.telem_delta < SILENT_LOCK_DELTA and "LOCKED OK" or "RACE"))
                    else
                        ui.small("delta -")
                    end
                    ui.small(string.format("lock addr %s",
                        state.telem_lock_addr and string.format("0x%X", state.telem_lock_addr) or "none"))
                    ui.small(string.format("roundsFired %d  shots %d",
                        state.telem_rounds, state.silent_shots))
                else
                    ui.small("telemetry unavailable")
                end
                ui.separator()
                ui.monospace("Position Debug")
                if state.dbg_err then
                    ui.small("Error: " .. state.dbg_err)
                end
                ui.small(state.dbg_lp_pos
                    and string.format("Player Pos %.3f %.3f %.3f",
                        state.dbg_lp_pos[1], state.dbg_lp_pos[2], state.dbg_lp_pos[3])
                    or "Player Pos -")
                ui.small(state.dbg_bone0
                    and string.format("Bone0 Pos %.3f %.3f %.3f",
                        state.dbg_bone0[1], state.dbg_bone0[2], state.dbg_bone0[3])
                    or "Bone0 Pos -")
                ui.separator()
                ui.monospace("Entity factions")
                local facs = {}
                local fac_tags = {}
                for _, ent in ipairs(state.entities) do
                    local f = ent.faction
                    if f and f ~= 0 then
                        facs[f] = (facs[f] or 0) + 1
                        if fac_tags[f] == nil then
                            fac_tags[f] = ent.faction_tag or ""
                        end
                    end
                end
                local fkeys = {}
                for f in pairs(facs) do fkeys[#fkeys + 1] = f end
                if #fkeys == 0 then
                    ui.small("none")
                else
                    table.sort(fkeys, function(a, b)
                        if facs[a] ~= facs[b] then return facs[a] > facs[b] end
                        return a < b
                    end)
                    local parts = {}
                    for i, f in ipairs(fkeys) do
                        local rawtag = fac_tags[f] or ""
                        local shown = rawtag ~= "" and rawtag or "?"
                        parts[i] = string.format("%s(%s)x%d",
                            faction_display_en(f, rawtag), shown, facs[f])
                    end
                    ui.code(table.concat(parts, "  "))
                end
            end)
        end)
 
        ui.separator()
        ui.small(state.status)
    end)
end