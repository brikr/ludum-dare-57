extends Node2D

func _ready():
  GameState.tile_updated.connect(tile_updated)
  # Pull map data from GameState
  # I sure hope GameState did map gen before this...
  for coords in GameState.map:
    var tile = GameState.map[coords]
    $ForegroundTileMap.set_cell(coords, Constants.SOURCE_ID, get_tile_set_tile(tile))
    $ObjectTileMap.set_cell(coords, Constants.SOURCE_ID, get_tile_set_object(tile))

func tile_updated(tile: Tile):
  $ForegroundTileMap.set_cell(tile.coords, Constants.SOURCE_ID, get_tile_set_tile(tile))
  $ObjectTileMap.set_cell(tile.coords, Constants.SOURCE_ID, get_tile_set_object(tile))

func get_tile_set_tile(tile: Tile):
  match tile.type:
    Tile.TileType.EMPTY:
      # Above ground: nothing
      # Below ground: background dirt
      return Constants.AIR_TILE if tile.is_above_ground() else Constants.EMPTY_DIRT_TILE
    Tile.TileType.DIRT:
      return Constants.DIRT_TILE
    Tile.TileType.BORDER:
      # Above ground: fence
      # Below ground: hazard
      return Constants.FENCE_TILE if tile.is_above_ground() else Constants.HAZARD_TILE

func get_tile_set_object(tile: Tile):
  match tile.objectType:
    Tile.TileObjectType.NONE:
      return Constants.AIR_TILE
    Tile.TileObjectType.GOLD:
      return Constants.GOLD_TILE
    Tile.TileObjectType.BLUE:
      return Constants.BLUE_TILE
    Tile.TileObjectType.RED:
      return Constants.RED_TILE
    Tile.TileObjectType.GREEN:
      return Constants.GREEN_TILE
    Tile.TileObjectType.ALIEN_SKULL:
      return Constants.ALIEN_SKULL_TILE
    Tile.TileObjectType.ALIEN_TECH:
      return Constants.ALIEN_TECH_TILE
