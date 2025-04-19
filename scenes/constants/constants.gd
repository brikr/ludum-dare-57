extends Node

# World Size
const SURFACE_HEIGHT := 10;
const MAX_GEN_DEPTH := 1000;
const MAX_WORLD_WIDTH := 20;

# World Tiles
const SOURCE_ID := 0;
const AIR_TILE := Vector2i(-1, -1)
const DIRT_TILE := Vector2i(0, 0)
const HAZARD_TILE := Vector2i(1, 0)
const FENCE_TILE := Vector2i(2, 0)
const EMPTY_DIRT_TILE := Vector2i(1, 0)
const TILE_WIDTH := 16

# Object Tiles
const GOLD_TILE := Vector2i(2, 0)
const BLUE_TILE := Vector2i(2, 1)
const ALIEN_SKULL_TILE := Vector2i(3, 0)
const ALIEN_TECH_TILE := Vector2i(3, 1)
const GONSTER_TILE := Vector2i(5, 0)
