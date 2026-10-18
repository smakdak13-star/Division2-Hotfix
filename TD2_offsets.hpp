// The Division 2 — Offset Dump
// Generated on 2026-10-15T20:44:49Z

// ── Globals ──────────────────────────────────────────────────────────────────
constexpr std::uintptr_t RVA_rlclient_global = 0x6D755E0;
constexpr std::uintptr_t RVA_viewmatrix_base = 0x6D75A70;
constexpr std::uintptr_t RVA_recoil          = 0x642C638;  // float: Default = 30.0f
constexpr std::uintptr_t RVA_spread          = 0x642C634;  // float: Default = 4.0f
constexpr std::uintptr_t RVA_setnoon         = 0x6F10F2E;  // byte: 1=force noon (12:00), 0=normal
constexpr std::uintptr_t RVA_setnight        = 0x6F10F2F;  // byte: 1=force night (22:00), 0=normal
constexpr std::uintptr_t RVA_magicbullet     = 0x6424001;  // byte: default=0x98, write 0xFF to enable

// ── Structural offsets ───────────────────────────────────────────────────────
constexpr std::uintptr_t OFF_pClient                    = 0x130;
constexpr std::uintptr_t OFF_pObject                    = 0x28;
constexpr std::uintptr_t OFF_entityArray                = 0x508;
constexpr std::uintptr_t OFF_entityCount                = 0x510;
constexpr std::uintptr_t OFF_entityPos                  = 0x80;
constexpr std::uintptr_t OFF_localStage0                = 0x340;
constexpr std::uintptr_t OFF_localStage1                = 0x10;
constexpr std::uintptr_t OFF_localStage2                = 0x30;
constexpr std::uintptr_t OFF_viewProj                   = 0x450;
constexpr std::uintptr_t OFF_health                     = 0x5C;
constexpr std::uintptr_t OFF_healthMax                  = 0x60;
constexpr std::uintptr_t OFF_isDowned                   = 0x3B8;
constexpr std::uintptr_t OFF_name                       = 0x438;
constexpr std::uintptr_t OFF_type                       = 0x228;
constexpr std::uintptr_t OFF_agentarmor                 = 0x254;
constexpr std::uintptr_t OFF_agentarmorMax              = 0x258;
constexpr std::uintptr_t OFF_pvpData                    = 0x8A8;
constexpr std::uintptr_t OFF_pvpTeamId                  = 0x10;
constexpr std::uintptr_t OFF_rogueComp                  = 0x738;
constexpr std::uintptr_t OFF_rogueTeamIdx               = 0x6C;
constexpr std::uintptr_t OFF_npcArmor                   = 0x1C4;
constexpr std::uintptr_t OFF_npcArmorMax                = 0x1C8;
constexpr std::uintptr_t OFF_HpPtr                      = 0x7D0;
constexpr std::uintptr_t OFF_factionCtx                 = 0x3E0;
constexpr std::uintptr_t OFF_agentarmorOverflow         = 0x248;
constexpr std::uintptr_t OFF_bonesBase                  = 0x220;
constexpr std::uintptr_t OFF_boneArray                  = 0x170;
constexpr std::uintptr_t OFF_weapPtr0                   = 0x718;
constexpr std::uintptr_t OFF_weapPtr1                   = 0x38;
constexpr std::uintptr_t OFF_weapPtr2                   = 0x10;
constexpr std::uintptr_t OFF_rpmFinal                   = 0x264;
constexpr std::uintptr_t OFF_lootManager                = 0x80;
constexpr std::uintptr_t OFF_lootCount                  = 0x30;
constexpr std::uintptr_t OFF_lootPos                    = 0x38;
constexpr std::uintptr_t OFF_lootItemsCount             = 0x20;
constexpr std::uintptr_t OFF_lootItemsBase              = 0x18;
constexpr std::uintptr_t OFF_lootItemStride             = 0xE8;
constexpr std::uintptr_t OFF_lootItemData               = 0xC0;
constexpr std::uintptr_t OFF_lootItemObjName            = 0x98;
constexpr std::uintptr_t OFF_lootItemQuality            = 0x1B0;
constexpr std::uintptr_t OFF_weaponAimCtrl              = 0x848;
constexpr std::uintptr_t OFF_worldAimPos                = 0x3AA8;
constexpr std::uintptr_t OFF_lootArray                  = 0x28;
constexpr std::uintptr_t OFF_lootItemObj                = 0xB0;
constexpr std::uintptr_t OFF_lootItemHash               = 0xB8;

// ── Bone matrix constants ────────────────────────────────────────────────────
constexpr std::uintptr_t BONE_STRIDE                   = 0x40;  // sizeof(BoneMatrix)
constexpr std::uintptr_t BONE_POS_X                    = 0x30;  // float x within BoneMatrix
constexpr std::uintptr_t BONE_POS_Y                    = 0x34;  // float y within BoneMatrix
constexpr std::uintptr_t BONE_POS_Z                    = 0x38;  // float z within BoneMatrix

// ── Pointer-chain references ──────────────────────────────────────────────────
//
//  core:
//     rlclient    = *(u64*)(base + RVA_rlclient_global)
//     pclient     = *(u64*)(rlclient + OFF_pClient)
//     pobject     = *(u64*)(pclient  + OFF_pObject)
//
//  local player:
//     stage0      = *(u64*)(pobject + OFF_localStage0)
//     stage1      = *(u64*)(stage0  + OFF_localStage1)
//     localplayer = *(u64*)(stage1  + OFF_localStage2)
//     localPos    = localplayer + OFF_entityPos    -- vec3 float[3]
//     localName   = localplayer + OFF_name         -- sd_string (inline or heap)
//     localFaction= *(u64*)(localplayer + OFF_factionCtx)
//
//  view matrix:
//     viewmatrix_ptr = *(u64*)(base + RVA_viewmatrix_base)
//     viewproj[16]   = (float*)(viewmatrix_ptr + OFF_viewProj)
//
//  entity list:
//     entityArray = *(u64*)(pobject + OFF_entityArray)   -- ptr to u64[]
//     entityCount = *(u32*)(pobject + OFF_entityCount)
//     entity[i]   = *(u64*)(entityArray + i * 8)
//
//  per-entity: (ent = entity[i])
//     entPos      = ent + OFF_entityPos        -- vec3 float[3]
//     entName     = ent + OFF_name             -- sd_string (inline or heap)
//     entType     = ent + OFF_type             -- sd_string: "soldier" == Player else empty or invalid string
//     isPlayer    = (entType == "soldier")
//     isDowned    = *(u32*)(ent + OFF_isDowned) -- 1 = player is downed
//     hpPtr       = *(u64*)(ent + OFF_HpPtr)
//     health      = *(u32*)(hpPtr + OFF_health)
//     healthMax   = *(u32*)(hpPtr + OFF_healthMax)
//     [Players only]:
//       armor         = *(u32*)(hpPtr + OFF_agentarmor)
//       armorMax      = *(u32*)(hpPtr + OFF_agentarmorMax)
//       armorOverflow = *(u32*)(hpPtr + OFF_agentarmorOverflow)
//     [NPCs only]:
//       armor         = *(u32*)(hpPtr + OFF_npcArmor)
//       armorMax      = *(u32*)(hpPtr + OFF_npcArmorMax)
//
//  hostility:
//     [Players] (entType == "soldier"):
//       rogueComp = *(u64*)(ent + OFF_rogueComp)
//       [Dark Zone]
//         rogueTeamIdx = *(u32*)(rogueComp + OFF_rogueTeamIdx)
//         isHostile    = (rogueTeamIdx != 0xFFFFFFFF)  -- Rogue Status for DZ
//       [Conflict mode]
//         pvpData      = *(u64*)(ent + OFF_pvpData)
//         pvpTeamId    = *(u32*)(pvpData + OFF_pvpTeamId)
//         localPvpData = *(u64*)(localplayer + OFF_pvpData)
//         localTeamId  = *(u32*)(localPvpData + OFF_pvpTeamId)
//         isHostile    = (pvpTeamId != localTeamId)
//      [NPCs] (all other entity types skip ):
//         entFaction   = *(u64*)(ent + OFF_factionCtx)
//         isHostile    = (entFaction != localFaction)
//
//  bones:
//     bonesBase   = *(u64*)(ent + OFF_bonesBase)
//     boneArray   = *(u64*)(bonesBase + OFF_boneArray)
//     mat         = boneArray + boneId * BONE_STRIDE   -- BONE_STRIDE = 0x40
//     bonePos     = { read_float(mat+0x30), read_float(mat+0x34), read_float(mat+0x38) }
//
//  loot list (dropped loot):
//     lootManager     = *[pobject + OFF_lootManager]
//     lootArray       = *[lootManager + OFF_lootArray]   -- ptr array of loot sources
//     lootCount       = *(u32*)(lootManager + OFF_lootCount)
//     lootPos         = loot + OFF_lootPos
//     lootItemsCount  = *(u32*)(loot + OFF_lootItemsCount)
//     lootItemsBase   = *(u64*)(loot + OFF_lootItemsBase)
//     firstEntry      = *(u64*)(lootItemsBase)
//     entry[i]        = firstEntry + i * OFF_lootItemStride
//     itemHash        = *(u32*)(entry + OFF_lootItemHash)
//     itemObj         = *(u64*)(entry + OFF_lootItemObj)
//     itemData        = *(u64*)(entry + OFF_lootItemData)
//
//  loot item:
//     name = sd_string(itemObj  + OFF_lootItemObjName)  -- ex: Grenade  
//     quality = *(u8*)(itemData + OFF_lootItemQuality)  -- eg: 0=Black,1=Yellow,2=Grey,3=Green,4=Blue,5=Purple,6=Orange,7=Vanity,8=GearSet,9=Exotic,10=Immersion,11=Prototype
//
//  recoil & spread:
//     recoilAddr  = base + RVA_recoil   -- default 30.0f, write 0.0f to disable
//     spreadAddr  = base + RVA_spread   -- default  4.0f, write 0.0f to disable
//     (spread lives 4 bytes before recoil in memory)
//
//  magic bullet (bullets pass through walls/cover):
//     mbAddr   = base + RVA_magicbullet   -- collision mask hi-byte in FIREROUND profile
//     enable:  wu8(mbAddr, 0xFF)          -- expands collision layer mask to include all
//     disable: wu8(mbAddr, 0x98)          -- restores original FIREROUND mask
//
//  silent aim (write direction):
//     aimCtrl     = *(u64*)(localplayer + OFF_weaponAimCtrl)   -- AgentWeaponAimController*
//     worldAimPos = aimCtrl + OFF_worldAimPos                  -- float3 {x, y, z}
//     to snap aim:  write_float(aimCtrl + 0x3778, target.x)
//                   write_float(aimCtrl + 0x377C, target.y)
//                   write_float(aimCtrl + 0x3780, target.z)
//     engine computes: aimDirection = normalize(worldAimPos - firePosition)
//
//  RPM final:
//     weapPtr1 = *(u64*)(localplayer + OFF_weapPtr0)
//     weapPtr2 = *(u64*)(weapPtr1    + OFF_weapPtr1)
//     weapPtr3 = *(u64*)(weapPtr2    + OFF_weapPtr2)
//     rpmFinal = read_float(weapPtr3 + OFF_rpmFinal)   -- read/write float
//
//  time of day:
//     setnoon  = base + RVA_setnoon    -- byte: 1 = force noon  (12:00), 0 = normal
//     setnight = base + RVA_setnight   -- byte: 1 = force night (22:00), 0 = normal
//     NOTE: setting both simultaneously causes the engine to clear both (normal cycle)

