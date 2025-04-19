extends TileMapLayer

func _ready():
  GameState.tile_updated.connect(tile_updated)
  # Pull map data from GameState
  # I sure hope GameState did map gen before this...
  for coords in GameState.map:
    var tile = GameState.map[coords]
    set_cell(coords, Constants.SOURCE_ID, get_tile_set_tile(tile))

func _process(_delta: float):
  var mouse_pos = get_local_mouse_position() # absolute pos
  var cell_pos = local_to_map(mouse_pos) # tile snapped pos
  highlight_cell(cell_pos)

func highlight_cell(cell_position: Vector2i):
  $HighlightedTile.position = map_to_local(cell_position)
  
func tile_updated(tile: Tile):
  set_cell(tile.coords, Constants.SOURCE_ID, get_tile_set_tile(tile))

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
