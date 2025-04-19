extends Node

# World Size
const SURFACE_HEIGHT := 10;
const MAX_GEN_DEPTH := 1000;
const MAX_WORLD_WIDTH := 20;
const TILE_WIDTH := 16

# World Tiles
const SOURCE_ID := 0;
const AIR_TILE := Vector2i(-1, -1)
const DIRT_TILE := Vector2i(0, 0)
const HAZARD_TILE := Vector2i(1, 0)
const FENCE_TILE := Vector2i(2, 0)
const EMPTY_DIRT_TILE := Vector2i(0, 1)

# Object Tiles
const GOLD_TILE := Vector2i(0, 2)
const BLUE_TILE := Vector2i(1, 2)
const ALIEN_SKULL_TILE := Vector2i(0, 3)
const ALIEN_TECH_TILE := Vector2i(1, 3)

# Animation
const TILE_BREAKING_FRAME_COUNT := 8
