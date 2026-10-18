// The Division 2 — FULL FIELD DUMP (no whitelist)
// Generated on 2026-10-15T20:44:49Z
//
// Line format: <sigTag>_p<relative offset>_<byte width> = <value read>
//   width 4 = disp32 candidate; width 1 = disp8 candidate
//
// [KNOWN] whitelist-confirmed fields (with their names) -- nothing missed
// [WILD]  candidates newly extracted from wildcard bytes; verify by hand
//
// Note: modrm / SIB bytes are usually wildcards too, so [WILD] contains noise;
//       real struct offsets are small and usually a multiple of 0x10, so filter on that.

// ─────────────────────────────────────────────────────────────
// SIG_POBJECT
//   match RVA = 0x1F61D99
constexpr std::uintptr_t SIG_POBJECT_p6_4 = 0x34081;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_POBJECT_p7_4 = 0x340;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_POBJECT_p2_1 = 0x48;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_POBJECT_p3_1 = 0x28;   // [KNOWN] OFF_pObject
constexpr std::uintptr_t SIG_POBJECT_p6_1 = 0x81;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_POBJECT_p7_1 = 0x40;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_POBJECT_p8_1 = 0x3;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_POBJECT_p9_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_POBJECT_p10_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_POBJECT_p13_1 = 0x60;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_POBJECT_p14_1 = 0x10;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_ENTITY_ARRAY
//   match RVA = 0x1F939FE
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p5_4 = 0x530A9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p6_4 = 0x530;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p15_4 = 0x540A9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p16_4 = 0x540;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p26_4 = 0x4D16A5C;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p27_4 = 0xBE04D16A;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p28_4 = 0x18BE04D1;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p29_4 = 0x218BE04;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p30_4 = 0x218BE;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p31_4 = 0x218;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p32_4 = 0x4C000002;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p37_4 = 0x508B1;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p38_4 = 0x508;   // [KNOWN] OFF_entityArray
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p39_4 = 0x44000005;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p44_4 = 0x510B9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p45_4 = 0x510;   // [KNOWN] OFF_entityCount
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p3_1 = 0x44;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p5_1 = 0xA9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p6_1 = 0x30;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p7_1 = 0x5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p8_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p9_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p13_1 = 0x44;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p15_1 = 0xA9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p16_1 = 0x40;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p17_1 = 0x5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p18_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p19_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p26_1 = 0x5C;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p27_1 = 0x6A;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p28_1 = 0xD1;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p29_1 = 0x4;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p30_1 = 0xBE;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p31_1 = 0x18;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p32_1 = 0x2;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p33_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p34_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p35_1 = 0x4C;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p37_1 = 0xB1;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p38_1 = 0x8;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p39_1 = 0x5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p40_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p41_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p42_1 = 0x44;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p44_1 = 0xB9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p45_1 = 0x10;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p46_1 = 0x5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p47_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p48_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p53_1 = 0x70;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_ARRAY_p54_1 = 0x8;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_ENTITY_POS
//   match RVA = 0xA29ED4
constexpr std::uintptr_t SIG_ENTITY_POS_p16_4 = 0x80;   // [KNOWN] OFF_entityPos
constexpr std::uintptr_t SIG_ENTITY_POS_p4_1 = 0x80;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_POS_p16_1 = 0x80;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_POS_p17_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_POS_p18_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ENTITY_POS_p19_1 = 0x0;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_STAGE_CHAIN
//   match RVA = 0x1F8FBEC
constexpr std::uintptr_t SIG_STAGE_CHAIN_p5_4 = 0x4F5E51F;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p14_4 = 0x4F5E51A;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p26_4 = 0x34088;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p27_4 = 0x340;   // [KNOWN] OFF_localStage0
constexpr std::uintptr_t SIG_STAGE_CHAIN_p5_1 = 0x1F;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p6_1 = 0xE5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p7_1 = 0xF5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p8_1 = 0x4;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p14_1 = 0x1A;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p15_1 = 0xE5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p16_1 = 0xF5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p17_1 = 0x4;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p19_1 = 0x41;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p26_1 = 0x88;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p27_1 = 0x40;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p28_1 = 0x3;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p29_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p30_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p33_1 = 0x41;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p34_1 = 0x10;   // [KNOWN] OFF_localStage1
constexpr std::uintptr_t SIG_STAGE_CHAIN_p39_1 = 0x25;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p42_1 = 0x40;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_STAGE_CHAIN_p43_1 = 0x30;   // [KNOWN] OFF_localStage2

// ─────────────────────────────────────────────────────────────
// SIG_VIEW_PROJ
//   match RVA = 0x2EA81DD
constexpr std::uintptr_t SIG_VIEW_PROJ_p2_4 = 0x4509D;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p3_4 = 0x450;   // [KNOWN] OFF_viewProj
constexpr std::uintptr_t SIG_VIEW_PROJ_p9_4 = 0x460A5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p10_4 = 0x460;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p16_4 = 0x470AD;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p17_4 = 0x470;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p23_4 = 0x480B5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p24_4 = 0x480;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p30_4 = 0x490BD;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p31_4 = 0x490;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p2_1 = 0x9D;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p3_1 = 0x50;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p4_1 = 0x4;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p5_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p6_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p9_1 = 0xA5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p10_1 = 0x60;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p11_1 = 0x4;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p12_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p13_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p16_1 = 0xAD;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p17_1 = 0x70;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p18_1 = 0x4;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p19_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p20_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p23_1 = 0xB5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p24_1 = 0x80;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p25_1 = 0x4;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p26_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p27_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p30_1 = 0xBD;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p31_1 = 0x90;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p32_1 = 0x4;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p33_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_VIEW_PROJ_p34_1 = 0x0;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_HEALTH
//   match RVA = 0x305F88C
constexpr std::uintptr_t SIG_HEALTH_p8_1 = 0x48;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HEALTH_p9_1 = 0x6C;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HEALTH_p12_1 = 0x70;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HEALTH_p13_1 = 0x54;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HEALTH_p15_1 = 0x70;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HEALTH_p16_1 = 0x58;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HEALTH_p18_1 = 0x78;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HEALTH_p19_1 = 0x5C;   // [KNOWN] OFF_health
constexpr std::uintptr_t SIG_HEALTH_p21_1 = 0x58;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HEALTH_p22_1 = 0x60;   // [KNOWN] OFF_healthMax

// ─────────────────────────────────────────────────────────────
// SIG_IS_DOWNED
//   match RVA = 0xE1A0F6
constexpr std::uintptr_t SIG_IS_DOWNED_p9_4 = 0x3B883;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_IS_DOWNED_p10_4 = 0x3B8;   // [KNOWN] OFF_isDowned
constexpr std::uintptr_t SIG_IS_DOWNED_p7_1 = 0x42;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_IS_DOWNED_p9_1 = 0x83;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_IS_DOWNED_p10_1 = 0xB8;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_IS_DOWNED_p11_1 = 0x3;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_IS_DOWNED_p12_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_IS_DOWNED_p13_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_IS_DOWNED_p15_1 = 0xC0;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_NAME
//   match RVA = 0x21D1458
constexpr std::uintptr_t SIG_NAME_p5_4 = 0x43890;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p6_4 = 0x438;   // [KNOWN] OFF_name
constexpr std::uintptr_t SIG_NAME_p11_4 = 0xFDF7E5C9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p17_4 = 0x44883;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p18_4 = 0x448;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p5_1 = 0x90;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p6_1 = 0x38;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p7_1 = 0x4;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p8_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p9_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p11_1 = 0xC9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p12_1 = 0xE5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p13_1 = 0xF7;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p14_1 = 0xFD;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p17_1 = 0x83;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p18_1 = 0x48;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p19_1 = 0x4;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p20_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NAME_p21_1 = 0x0;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_TYPE
//   match RVA = 0xC187E2
constexpr std::uintptr_t SIG_TYPE_p2_4 = 0x22087;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p3_4 = 0x220;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p4_4 = 0x66000002;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p5_4 = 0x89660000;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p6_4 = 0x43896600;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p7_4 = 0x30438966;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p18_4 = 0x32438966;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p24_4 = 0x22887;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p25_4 = 0x228;   // [KNOWN] OFF_type
constexpr std::uintptr_t SIG_TYPE_p2_1 = 0x87;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p3_1 = 0x20;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p4_1 = 0x2;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p5_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p6_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p7_1 = 0x66;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p8_1 = 0x89;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p9_1 = 0x43;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p10_1 = 0x30;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p13_1 = 0x87;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p18_1 = 0x66;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p19_1 = 0x89;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p20_1 = 0x43;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p21_1 = 0x32;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p24_1 = 0x87;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p25_1 = 0x28;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p26_1 = 0x2;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p27_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_TYPE_p28_1 = 0x0;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_AGENT_ARMOR
//   match RVA = 0x13B79B0
constexpr std::uintptr_t SIG_AGENT_ARMOR_p3_4 = 0x254;   // [KNOWN] OFF_agentarmor
constexpr std::uintptr_t SIG_AGENT_ARMOR_p7_4 = 0x8B4CC033;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_p8_4 = 0xC18B4CC0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_p9_4 = 0x85C18B4C;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_p10_4 = 0xD285C18B;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_p16_4 = 0x258;   // [KNOWN] OFF_agentarmorMax
constexpr std::uintptr_t SIG_AGENT_ARMOR_p0_1 = 0x44;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_p2_1 = 0x89;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_p7_1 = 0x33;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_p8_1 = 0xC0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_p9_1 = 0x4C;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_p10_1 = 0x8B;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_p11_1 = 0xC1;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_p12_1 = 0x85;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_p13_1 = 0xD2;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_p15_1 = 0x89;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_PVP_DATA
//   match RVA = 0x11CFF52
constexpr std::uintptr_t SIG_PVP_DATA_p20_4 = 0x8A888;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p21_4 = 0x8A8;   // [KNOWN] OFF_pvpData
constexpr std::uintptr_t SIG_PVP_DATA_p6_1 = 0xDB;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p8_1 = 0x26;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p11_1 = 0x43;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p12_1 = 0x30;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p15_1 = 0xC0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p17_1 = 0x11;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p20_1 = 0x88;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p21_1 = 0xA8;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p22_1 = 0x8;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p23_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p24_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p27_1 = 0xC9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p29_1 = 0x5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p31_1 = 0x41;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_PVP_DATA_p32_1 = 0x10;   // [KNOWN] OFF_pvpTeamId

// ─────────────────────────────────────────────────────────────
// SIG_ROGUE_COMP
//   match RVA = 0x24DB938
constexpr std::uintptr_t SIG_ROGUE_COMP_p2_4 = 0xC08;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p11_4 = 0x738;   // [KNOWN] OFF_rogueComp
constexpr std::uintptr_t SIG_ROGUE_COMP_p21_4 = 0xFE97678F;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p2_1 = 0x8;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p3_1 = 0xC;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p4_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p5_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p7_1 = 0x42;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p11_1 = 0x38;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p12_1 = 0x7;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p13_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p14_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p19_1 = 0x36;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p21_1 = 0x8F;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p22_1 = 0x67;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p23_1 = 0x97;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p24_1 = 0xFE;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_COMP_p28_1 = 0x2D;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_ROGUE_TEAM_IDX
//   match RVA = 0x24F8B5A
constexpr std::uintptr_t SIG_ROGUE_TEAM_IDX_p9_1 = 0x41;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_TEAM_IDX_p10_1 = 0x6C;   // [KNOWN] OFF_rogueTeamIdx
constexpr std::uintptr_t SIG_ROGUE_TEAM_IDX_p25_1 = 0x17;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_ROGUE_TEAM_IDX_p30_1 = 0xA;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_NPC_ARMOR
//   match RVA = 0xBA5220
constexpr std::uintptr_t SIG_NPC_ARMOR_p5_4 = 0x1C480;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NPC_ARMOR_p6_4 = 0x1C4;   // [KNOWN] OFF_npcArmor
constexpr std::uintptr_t SIG_NPC_ARMOR_p15_4 = 0x1C880;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NPC_ARMOR_p16_4 = 0x1C8;   // [KNOWN] OFF_npcArmorMax
constexpr std::uintptr_t SIG_NPC_ARMOR_p5_1 = 0x80;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NPC_ARMOR_p6_1 = 0xC4;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NPC_ARMOR_p7_1 = 0x1;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NPC_ARMOR_p8_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NPC_ARMOR_p9_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NPC_ARMOR_p15_1 = 0x80;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NPC_ARMOR_p16_1 = 0xC8;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NPC_ARMOR_p17_1 = 0x1;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NPC_ARMOR_p18_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_NPC_ARMOR_p19_1 = 0x0;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_HP_PTR
//   match RVA = 0xDCD180
constexpr std::uintptr_t SIG_HP_PTR_p21_4 = 0x7D08B;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HP_PTR_p22_4 = 0x7D0;   // [KNOWN] OFF_HpPtr
constexpr std::uintptr_t SIG_HP_PTR_p27_4 = 0x59C951;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HP_PTR_p4_1 = 0x71;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HP_PTR_p18_1 = 0x1B;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HP_PTR_p21_1 = 0x8B;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HP_PTR_p22_1 = 0xD0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HP_PTR_p23_1 = 0x7;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HP_PTR_p24_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HP_PTR_p25_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HP_PTR_p27_1 = 0x51;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HP_PTR_p28_1 = 0xC9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HP_PTR_p29_1 = 0x59;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_HP_PTR_p30_1 = 0x0;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_FACTION_CTX
//   match RVA = 0x1F8A2D5
constexpr std::uintptr_t SIG_FACTION_CTX_p3_4 = 0xA602A4;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p15_4 = 0xE6;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p21_4 = 0x3E088;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p22_4 = 0x3E0;   // [KNOWN] OFF_factionCtx
constexpr std::uintptr_t SIG_FACTION_CTX_p3_1 = 0xA4;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p4_1 = 0x2;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p5_1 = 0xA6;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p6_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p15_1 = 0xE6;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p16_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p17_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p18_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p21_1 = 0x88;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p22_1 = 0xE0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p23_1 = 0x3;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p24_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_FACTION_CTX_p25_1 = 0x0;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_AGENT_ARMOR_OVERFLOW
//   match RVA = 0x3A07DDE
constexpr std::uintptr_t SIG_AGENT_ARMOR_OVERFLOW_p3_4 = 0x248;   // [KNOWN] OFF_agentarmorOverflow
constexpr std::uintptr_t SIG_AGENT_ARMOR_OVERFLOW_p0_1 = 0x48;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_OVERFLOW_p2_1 = 0x9E;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_OVERFLOW_p3_1 = 0x48;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_OVERFLOW_p9_1 = 0xDB;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_OVERFLOW_p11_1 = 0x9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_AGENT_ARMOR_OVERFLOW_p14_1 = 0xB6;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_BONES_BASE
//   match RVA = 0xE88BDE
constexpr std::uintptr_t SIG_BONES_BASE_p10_4 = 0x220AF;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONES_BASE_p11_4 = 0x220;   // [KNOWN] OFF_bonesBase
constexpr std::uintptr_t SIG_BONES_BASE_p3_1 = 0x99;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONES_BASE_p8_1 = 0x4D;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONES_BASE_p10_1 = 0xAF;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONES_BASE_p11_1 = 0x20;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONES_BASE_p12_1 = 0x2;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONES_BASE_p13_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONES_BASE_p14_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONES_BASE_p17_1 = 0xC3;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_BONE_ARRAY
//   match RVA = 0x344D4C
constexpr std::uintptr_t SIG_BONE_ARRAY_p2_4 = 0x17089;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p3_4 = 0x170;   // [KNOWN] OFF_boneArray
constexpr std::uintptr_t SIG_BONE_ARRAY_p13_4 = 0xFFDE2823;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p14_4 = 0x48FFDE28;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p30_4 = 0xFFDE2812;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p31_4 = 0x48FFDE28;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p47_4 = 0xFFDE2801;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p48_4 = 0x48FFDE28;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p64_4 = 0xFFDE27F0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p65_4 = 0x48FFDE27;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p0_1 = 0x48;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p2_1 = 0x89;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p3_1 = 0x70;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p4_1 = 0x1;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p5_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p6_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p9_1 = 0xC9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p11_1 = 0x5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p13_1 = 0x23;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p14_1 = 0x28;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p15_1 = 0xDE;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p16_1 = 0xFF;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p17_1 = 0x48;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p19_1 = 0x8F;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p26_1 = 0xC9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p28_1 = 0x5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p30_1 = 0x12;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p31_1 = 0x28;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p32_1 = 0xDE;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p33_1 = 0xFF;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p34_1 = 0x48;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p36_1 = 0x8F;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p43_1 = 0xC9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p45_1 = 0x5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p47_1 = 0x1;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p48_1 = 0x28;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p49_1 = 0xDE;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p50_1 = 0xFF;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p51_1 = 0x48;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p53_1 = 0x8F;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p60_1 = 0xC9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p62_1 = 0x5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p64_1 = 0xF0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p65_1 = 0x27;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p66_1 = 0xDE;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p67_1 = 0xFF;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p68_1 = 0x48;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_BONE_ARRAY_p70_1 = 0x8F;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_WEAP_PTR_CHAIN
//   match RVA = 0x1923DE0
constexpr std::uintptr_t SIG_WEAP_PTR_CHAIN_p24_4 = 0x71890;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR_CHAIN_p25_4 = 0x718;   // [KNOWN] OFF_weapPtr0
constexpr std::uintptr_t SIG_WEAP_PTR_CHAIN_p17_1 = 0x41;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR_CHAIN_p18_1 = 0x8;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR_CHAIN_p21_1 = 0xF1;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR_CHAIN_p24_1 = 0x90;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR_CHAIN_p25_1 = 0x18;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR_CHAIN_p26_1 = 0x7;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR_CHAIN_p27_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR_CHAIN_p28_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR_CHAIN_p31_1 = 0x5A;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR_CHAIN_p32_1 = 0x38;   // [KNOWN] OFF_weapPtr1

// ─────────────────────────────────────────────────────────────
// SIG_WEAP_PTR2_RPM
//   match RVA = 0x24B8780
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p14_4 = 0xFFD7361E;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p37_4 = 0x264;   // [KNOWN] OFF_rpmFinal
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p8_1 = 0x59;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p9_1 = 0x10;   // [KNOWN] OFF_weapPtr2
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p12_1 = 0xCB;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p14_1 = 0x1E;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p15_1 = 0x36;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p16_1 = 0xD7;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p17_1 = 0xFF;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p20_1 = 0x88;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p28_1 = 0x81;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p29_1 = 0x68;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p30_1 = 0x2;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p36_1 = 0x91;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p37_1 = 0x64;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAP_PTR2_RPM_p38_1 = 0x2;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_LOOT_MGR
//   match RVA = 0x19769DA
constexpr std::uintptr_t SIG_LOOT_MGR_p2_4 = 0x8090;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_MGR_p3_4 = 0x80;   // [KNOWN] OFF_lootManager
constexpr std::uintptr_t SIG_LOOT_MGR_p2_1 = 0x90;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_MGR_p3_1 = 0x80;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_MGR_p4_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_MGR_p5_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_MGR_p6_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_MGR_p9_1 = 0xD2;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_MGR_p11_1 = 0x3;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_MGR_p13_1 = 0x5A;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_MGR_p14_1 = 0x30;   // [KNOWN] OFF_lootCount
constexpr std::uintptr_t SIG_LOOT_MGR_p16_1 = 0x41;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_LOOT_POS
//   match RVA = 0x198C0FA
constexpr std::uintptr_t SIG_LOOT_POS_p2_1 = 0x41;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_POS_p3_1 = 0x48;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_POS_p8_1 = 0x9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_POS_p11_1 = 0x41;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_POS_p12_1 = 0x40;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_POS_p17_1 = 0x10;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_POS_p21_1 = 0x70;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_POS_p22_1 = 0x38;   // [KNOWN] OFF_lootPos
constexpr std::uintptr_t SIG_LOOT_POS_p26_1 = 0x78;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_POS_p27_1 = 0x3C;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_POS_p32_1 = 0x40;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_POS_p33_1 = 0x40;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_LOOT_ITEMS
//   match RVA = 0x1987805
constexpr std::uintptr_t SIG_LOOT_ITEMS_p2_1 = 0x41;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEMS_p3_1 = 0x48;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEMS_p8_1 = 0x9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEMS_p11_1 = 0x41;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEMS_p12_1 = 0x40;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEMS_p17_1 = 0x3;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEMS_p19_1 = 0x58;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEMS_p20_1 = 0x20;   // [KNOWN] OFF_lootItemsCount
constexpr std::uintptr_t SIG_LOOT_ITEMS_p23_1 = 0x4A;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEMS_p27_1 = 0xC9;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEMS_p29_1 = 0x1C;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEMS_p31_1 = 0x41;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_LOOT_ITEM_LAYOUT
//   match RVA = 0x1987706
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p1_4 = 0xFE729DF5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p23_4 = 0xE8;   // [KNOWN] OFF_lootItemStride
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p31_4 = 0xC0;   // [KNOWN] OFF_lootItemData
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p1_1 = 0xF5;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p2_1 = 0x9D;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p3_1 = 0x72;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p4_1 = 0xFE;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p9_1 = 0x20;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p11_1 = 0x3F;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p15_1 = 0x3B;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p19_1 = 0x18;   // [KNOWN] OFF_lootItemsBase
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p23_1 = 0xE8;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p24_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p25_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p26_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p31_1 = 0xC0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p32_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p33_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_LOOT_ITEM_LAYOUT_p34_1 = 0x0;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// SIG_WEAPON_AIM_POS
//   match RVA = 0xE0DE64
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p2_4 = 0x84898;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p3_4 = 0x848;   // [KNOWN] OFF_weaponAimCtrl
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p38_4 = 0x3AA8B3;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p39_4 = 0x3AA8;   // [KNOWN] OFF_worldAimPos
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p46_4 = 0x3AACBB;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p47_4 = 0x3AAC;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p55_4 = 0x3AB083;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p56_4 = 0x3AB0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p2_1 = 0x98;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p3_1 = 0x48;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p4_1 = 0x8;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p5_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p6_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p9_1 = 0x74;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p11_1 = 0x50;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p17_1 = 0x7C;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p19_1 = 0x40;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p23_1 = 0x44;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p25_1 = 0x30;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p38_1 = 0xB3;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p39_1 = 0xA8;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p40_1 = 0x3A;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p41_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p42_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p46_1 = 0xBB;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p47_1 = 0xAC;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p48_1 = 0x3A;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p49_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p50_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p55_1 = 0x83;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p56_1 = 0xB0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p57_1 = 0x3A;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p58_1 = 0x0;   // [WILD]  new candidate
constexpr std::uintptr_t SIG_WEAPON_AIM_POS_p59_1 = 0x0;   // [WILD]  new candidate

// ─────────────────────────────────────────────────────────────
// total candidates = 474 ([KNOWN] whitelist 39, [WILD] new 435)

