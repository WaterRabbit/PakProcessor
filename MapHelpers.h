//
//  MapHelpers.h
//  PAK processor
//
//  Created by id on 02/02/14.
//  Copyright (c) 2014 id. All rights reserved.
//

#ifndef PAK_processor_MapHelpers_h
#define PAK_processor_MapHelpers_h

typedef struct tile32 {
	uint16 x;
	uint16 y;
} tile32;

typedef struct LandscapeInfo {
	uint8  movementSpeed[6];                                /*!< Per MovementType the speed a Unit has on this LandscapeType. */
	bool   letUnitWobble;                                   /*!< True if a Unit on this LandscapeType should wobble around while moving on it. */
	bool   isValidForStructure;                             /*!< True if a Structure with notOnConcrete false can be build on this LandscapeType. */
	bool   isSand;                                          /*!< True if the LandscapeType is a sand tile (sand, dune, spice, thickspice, bloom). */
	bool   isValidForStructure2;                            /*!< True if a Structure with notOnConcrete true can be build on this LandscapeType. */
	bool   canBecomeSpice;                                  /*!< True if the LandscapeType can become a spice tile. */
	uint8  craterType;                                      /*!< Type of crater on tile; 0 for none, 1 for sand, 2 for concrete. */
	uint16 radarColour;                                     /*!< Colour used on radar for this LandscapeType. */
	uint16 spriteID;                                        /*!< Sprite used on map for this LandscapeType. */
} LandscapeInfo;

typedef enum LandscapeType {
	LST_NORMAL_SAND       =  0,                             /*<! Flat sand. */
	LST_PARTIAL_ROCK      =  1,                             /*!< Edge of a rocky area (mostly sand). */
	LST_ENTIRELY_DUNE     =  2,                             /*!< Entirely sand dunes. */
	LST_PARTIAL_DUNE      =  3,                             /*!< Partial sand dunes. */
	LST_ENTIRELY_ROCK     =  4,                             /*!< Center part of rocky area. */
	LST_MOSTLY_ROCK       =  5,                             /*!< Edge of a rocky area (mostly rocky). */
	LST_ENTIRELY_MOUNTAIN =  6,                             /*!< Center part of the mountain. */
	LST_PARTIAL_MOUNTAIN  =  7,                             /*!< Edge of a mountain. */
	LST_SPICE             =  8,                             /*!< Sand with spice. */
	LST_THICK_SPICE       =  9,                             /*!< Sand with thick spice. */
	LST_CONCRETE_SLAB     = 10,                             /*!< Concrete slab. */
	LST_WALL              = 11,                             /*!< Wall. */
	LST_STRUCTURE         = 12,                             /*!< Structure. */
	LST_DESTROYED_WALL    = 13,                             /*!< Destroyed wall. */
	LST_BLOOM_FIELD       = 14,                             /*!< Bloom field. */
    
	LST_MAX               = 15
} LandscapeType;

static const unsigned char _stepX[256] = {
    0,    3,    6,    9,   12,   15,   18,   21,   24,   27,   30,   33,   36,   39,   42,   45,
    48,   51,   54,   57,   59,   62,   65,   67,   70,   73,   75,   78,   80,   82,   85,   87,
    89,   91,   94,   96,   98,  100,  101,  103,  105,  107,  108,  110,  111,  113,  114,  116,
    117,  118,  119,  120,  121,  122,  123,  123,  124,  125,  125,  126,  126,  126,  126,  126,
    127,  126,  126,  126,  126,  126,  125,  125,  124,  123,  123,  122,  121,  120,  119,  118,
    117,  116,  114,  113,  112,  110,  108,  107,  105,  103,  102,  100,   98,   96,   94,   91,
    89,   87,   85,   82,   80,   78,   75,   73,   70,   67,   65,   62,   59,   57,   54,   51,
    48,   45,   42,   39,   36,   33,   30,   27,   24,   21,   18,   15,   12,    9,    6,    3,
    0,   -3,   -6,   -9,  -12,  -15,  -18,  -21,  -24,  -27,  -30,  -33,  -36,  -39,  -42,  -45,
    -48,  -51,  -54,  -57,  -59,  -62,  -65,  -67,  -70,  -73,  -75,  -78,  -80,  -82,  -85,  -87,
    -89,  -91,  -94,  -96,  -98, -100, -102, -103, -105, -107, -108, -110, -111, -113, -114, -116,
	-117, -118, -119, -120, -121, -122, -123, -123, -124, -125, -125, -126, -126, -126, -126, -126,
	-126, -126, -126, -126, -126, -126, -125, -125, -124, -123, -123, -122, -121, -120, -119, -118,
	-117, -116, -114, -113, -112, -110, -108, -107, -105, -103, -102, -100,  -98,  -96,  -94,  -91,
    -89,  -87,  -85,  -82,  -80,  -78,  -75,  -73,  -70,  -67,  -65,  -62,  -59,  -57,  -54,  -51,
    -48,  -45,  -42,  -39,  -36,  -33,  -30,  -27,  -24,  -21,  -18,  -15,  -12,   -9,   -6,   -3
};

static const unsigned char _stepY[256] = {
    127,  126,  126,  126,  126,  126,  125,  125,  124,  123,  123,  122,  121,  120,  119,  118,
    117,  116,  114,  113,  112,  110,  108,  107,  105,  103,  102,  100,   98,   96,   94,   91,
    89,   87,   85,   82,   80,   78,   75,   73,   70,   67,   65,   62,   59,   57,   54,   51,
    48,   45,   42,   39,   36,   33,   30,   27,   24,   21,   18,   15,   12,    9,    6,    3,
    0,   -3,   -6,   -9,  -12,  -15,  -18,  -21,  -24,  -27,  -30,  -33,  -36,  -39,  -42,  -45,
    -48,  -51,  -54,  -57,  -59,  -62,  -65,  -67,  -70,  -73,  -75,  -78,  -80,  -82,  -85,  -87,
    -89,  -91,  -94,  -96,  -98, -100, -102, -103, -105, -107, -108, -110, -111, -113, -114, -116,
	-117, -118, -119, -120, -121, -122, -123, -123, -124, -125, -125, -126, -126, -126, -126, -126,
	-126, -126, -126, -126, -126, -126, -125, -125, -124, -123, -123, -122, -121, -120, -119, -118,
	-117, -116, -114, -113, -112, -110, -108, -107, -105, -103, -102, -100,  -98,  -96,  -94,  -91,
    -89,  -87,  -85,  -82,  -80,  -78,  -75,  -73,  -70,  -67,  -65,  -62,  -59,  -57,  -54,  -51,
    -48,  -45,  -42,  -39,  -36,  -33,  -30,  -27,  -24,  -21,  -18,  -15,  -12,   -9,   -6,   -3,
    0,    3,    6,    9,   12,   15,   18,   21,   24,   27,   30,   33,   36,   39,   42,   45,
    48,   51,   54,   57,   59,   62,   65,   67,   70,   73,   75,   78,   80,   82,   85,   87,
    89,   91,   94,   96,   98,  100,  101,  103,  105,  107,  108,  110,  111,  113,  114,  116,
    117,  118,  119,  120,  121,  122,  123,  123,  124,  125,  125,  126,  126,  126,  126,  126
};

const LandscapeInfo g_table_landscapeInfo[LST_MAX] = {
	{ /* 0 / LST_NORMAL_SAND */
		/* movementSpeed        */ { 112, 112, 112, 160, 255, 192 },
		/* letUnitWobble        */ false,
		/* isValidForStructure  */ false,
		/* isSand               */ true,
		/* isValidForStructure2 */ false,
		/* canBecomeSpice       */ true,
		/* craterType           */ 1,
		/* radarColour          */ 88,
		/* spriteID             */ 37,
	},
    
	{ /* 1 / LST_PARTIAL_ROCK */
		/* movementSpeed        */ { 160, 112, 112, 64, 255, 0 },
		/* letUnitWobble        */ true,
		/* isValidForStructure  */ false,
		/* isSand               */ false,
		/* isValidForStructure2 */ false,
		/* canBecomeSpice       */ false,
		/* craterType           */ 1,
		/* radarColour          */ 28,
		/* spriteID             */ 39,
	},
    
	{ /* 2 / LST_ENTIRELY_DUNE */
		/* movementSpeed        */ { 112, 160, 160, 160, 255, 192 },
		/* letUnitWobble        */ false,
		/* isValidForStructure  */ false,
		/* isSand               */ true,
		/* isValidForStructure2 */ false,
		/* canBecomeSpice       */ true,
		/* craterType           */ 1,
		/* radarColour          */ 92,
		/* spriteID             */ 41,
	},
    
	{ /* 3 / LST_PARTIAL_DUNE */
		/* movementSpeed        */ { 112, 160, 160, 160, 255, 192 },
		/* letUnitWobble        */ false,
		/* isValidForStructure  */ false,
		/* isSand               */ true,
		/* isValidForStructure2 */ false,
		/* canBecomeSpice       */ true,
		/* craterType           */ 1,
		/* radarColour          */ 89,
		/* spriteID             */ 43,
	},
    
	{ /* 4 / LST_ENTIRELY_ROCK */
		/* movementSpeed        */ { 112, 160, 160, 112, 255, 0 },
		/* letUnitWobble        */ true,
		/* isValidForStructure  */ true,
		/* isSand               */ false,
		/* isValidForStructure2 */ true,
		/* canBecomeSpice       */ false,
		/* craterType           */ 2,
		/* radarColour          */ 30,
		/* spriteID             */ 45,
	},
    
	{ /* 5 / LST_MOSTLY_ROCK */
		/* movementSpeed        */ { 160, 160, 160, 160, 255, 0 },
		/* letUnitWobble        */ true,
		/* isValidForStructure  */ true,
		/* isSand               */ false,
		/* isValidForStructure2 */ true,
		/* canBecomeSpice       */ false,
		/* craterType           */ 2,
		/* radarColour          */ 29,
		/* spriteID             */ 47,
	},
    
	{ /* 6 / LST_ENTIRELY_MOUNTAIN */
		/* movementSpeed        */ { 64, 0, 0, 0, 255, 0 },
		/* letUnitWobble        */ true,
		/* isValidForStructure  */ false,
		/* isSand               */ false,
		/* isValidForStructure2 */ false,
		/* canBecomeSpice       */ false,
		/* craterType           */ 0,
		/* radarColour          */ 12,
		/* spriteID             */ 49,
	},
    
	{ /* 7 / LST_PARTIAL_MOUNTAIN */
		/* movementSpeed        */ { 64, 0, 0, 0, 255, 0 },
		/* letUnitWobble        */ true,
		/* isValidForStructure  */ false,
		/* isSand               */ false,
		/* isValidForStructure2 */ false,
		/* canBecomeSpice       */ false,
		/* craterType           */ 0,
		/* radarColour          */ 133,
		/* spriteID             */ 51,
	},
    
	{ /* 8 / LST_SPICE */
		/* movementSpeed        */ { 112, 160, 160, 160, 255, 192 },
		/* letUnitWobble        */ false,
		/* isValidForStructure  */ false,
		/* isSand               */ true,
		/* isValidForStructure2 */ false,
		/* canBecomeSpice       */ true,
		/* craterType           */ 1,
		/* radarColour          */ 215, /* was 88, but is changed on startup */
		/* spriteID             */ 53,  /* was 37, but is changed on startup */
	},
    
	{ /* 9 / LST_THICK_SPICE */
		/* movementSpeed        */ { 112, 160, 160, 160, 255, 192 },
		/* letUnitWobble        */ true,
		/* isValidForStructure  */ false,
		/* isSand               */ true,
		/* isValidForStructure2 */ false,
		/* canBecomeSpice       */ true,
		/* craterType           */ 1,
		/* radarColour          */ 216, /* was 88, but is changed on startup */
		/* spriteID             */ 53,  /* was 37, but is changed on startup */
	},
    
	{ /* 10 / LST_CONCRETE_SLAB */
		/* movementSpeed        */ { 255, 255, 255, 255, 255, 0 },
		/* letUnitWobble        */ false,
		/* isValidForStructure  */ true,
		/* isSand               */ false,
		/* isValidForStructure2 */ false,
		/* canBecomeSpice       */ false,
		/* craterType           */ 2,
		/* radarColour          */ 133,
		/* spriteID             */ 51,
	},
    
	{ /* 11 / LST_WALL */
		/* movementSpeed        */ { 0, 0, 0, 0, 255, 0 },
		/* letUnitWobble        */ false,
		/* isValidForStructure  */ false,
		/* isSand               */ false,
		/* isValidForStructure2 */ false,
		/* canBecomeSpice       */ false,
		/* craterType           */ 0,
		/* radarColour          */ 65535,
		/* spriteID             */ 31,
	},
    
	{ /* 12 / LST_STRUCTURE */
		/* movementSpeed        */ { 0, 0, 0, 0, 255, 0 },
		/* letUnitWobble        */ false,
		/* isValidForStructure  */ false,
		/* isSand               */ false,
		/* isValidForStructure2 */ false,
		/* canBecomeSpice       */ false,
		/* craterType           */ 0,
		/* radarColour          */ 65535,
		/* spriteID             */ 31,
	},
    
	{ /* 13 / LST_DESTROYED_WALL */
		/* movementSpeed        */ { 160, 160, 160, 160, 255, 0 },
		/* letUnitWobble        */ true,
		/* isValidForStructure  */ true,
		/* isSand               */ false,
		/* isValidForStructure2 */ true,
		/* canBecomeSpice       */ false,
		/* craterType           */ 2,
		/* radarColour          */ 29,
		/* spriteID             */ 47,
	},
    
	{ /* 14 / LST_BLOOM_FIELD */
		/* movementSpeed        */ { 112, 112, 112, 160, 255, 192 },
		/* letUnitWobble        */ false,
		/* isValidForStructure  */ false,
		/* isSand               */ true,
		/* isValidForStructure2 */ false,
		/* canBecomeSpice       */ true,
		/* craterType           */ 1,
		/* radarColour          */ 50,
		/* spriteID             */ 57,
	}
};

static char around[] = {0, -1, 1, -16, 16, -17, 17, -15, 15, -2, 2, -32, 32, -4, 4, -64, 64, -30, 30, -34, 34};
static unsigned char _offsetTable[2][21][4] = {
    {
        {0, 0, 4, 0}, {4, 0, 4, 4}, {0, 0, 0, 4}, {0, 4, 4, 4}, {0, 0, 0, 2},
        {0, 2, 0, 4}, {0, 0, 2, 0}, {2, 0, 4, 0}, {4, 0, 4, 2}, {4, 2, 4, 4},
        {0, 4, 2, 4}, {2, 4, 4, 4}, {0, 0, 4, 4}, {2, 0, 2, 2}, {0, 0, 2, 2},
        {4, 0, 2, 2}, {0, 2, 2, 2}, {2, 2, 4, 2}, {2, 2, 0, 4}, {2, 2, 4, 4},
        {2, 2, 2, 4},
    },
    {
        {0, 0, 4, 0}, {4, 0, 4, 4}, {0, 0, 0, 4}, {0, 4, 4, 4}, {0, 0, 0, 2},
        {0, 2, 0, 4}, {0, 0, 2, 0}, {2, 0, 4, 0}, {4, 0, 4, 2}, {4, 2, 4, 4},
        {0, 4, 2, 4}, {2, 4, 4, 4}, {4, 0, 0, 4}, {2, 0, 2, 2}, {0, 0, 2, 2},
        {4, 0, 2, 2}, {0, 2, 2, 2}, {2, 2, 4, 2}, {2, 2, 0, 4}, {2, 2, 4, 4},
        {2, 2, 2, 4},
    },
};

#endif
