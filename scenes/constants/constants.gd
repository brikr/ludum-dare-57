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


# World Gen
enum WORLD_GEN_FIELDS {MIN_DEPTH, MAX_DEPTH, COEFFICIENT, THRESHOLD}
const WORLD_GEN := {
  Tile.TileObjectType.GOLD: {
    WORLD_GEN_FIELDS.MIN_DEPTH : 0,
    WORLD_GEN_FIELDS.MAX_DEPTH : 100,
    WORLD_GEN_FIELDS.COEFFICIENT : 0.02, # 2x as likely at depth of 100
    WORLD_GEN_FIELDS.THRESHOLD: 0.5,
  },
  Tile.TileObjectType.BLUE: {
    WORLD_GEN_FIELDS.MIN_DEPTH : 70,
    WORLD_GEN_FIELDS.MAX_DEPTH : 200,
    WORLD_GEN_FIELDS.COEFFICIENT : 0.01, # 2x as likely at depth of 200
    WORLD_GEN_FIELDS.THRESHOLD: 0.8,
  }
}

# Animation
const TILE_BREAKING_FRAME_COUNT := 8

# Tile difficulty
const TILE_DIFFICULTY: Dictionary[Tile.TileType, float] = {
  Tile.TileType.DIRT: 50.0,
}

const OBJECT_DIFFICULTY: Dictionary[Tile.TileObjectType, float] = {
  Tile.TileObjectType.GOLD: 50.0,
  Tile.TileObjectType.BLUE: 100.0,
  Tile.TileObjectType.ALIEN_SKULL: 150.0,
  Tile.TileObjectType.ALIEN_TECH: 200.0,
}
