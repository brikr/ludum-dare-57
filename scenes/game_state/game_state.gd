extends Node


signal tile_updated

var map: Dictionary[Vector2i, Tile] = {}

func _ready():
  gen_map()

####### WORLD GEN #######
func is_vertical_edge(y):
  return (y == 0 || y == Constants.MAX_GEN_DEPTH - 1)

func is_horizontal_edge(x):
  return (x == 0 || x == Constants.MAX_WORLD_WIDTH - 1)

func is_edge(x, y):
  return is_horizontal_edge(x) || is_vertical_edge(y)

func gen_under_world():
  gen_base_under_world()
  gen_resource(Tile.TileObjectType.GOLD)
  gen_resource(Tile.TileObjectType.BLUE)

func gen_resource(resourceType: Tile.TileObjectType):
  var noise = GenUtils.get_noise()
  var min_depth = Constants.WORLD_GEN[resourceType][Constants.WORLD_GEN_FIELDS.MIN_DEPTH]
  var max_depth = Constants.WORLD_GEN[resourceType][Constants.WORLD_GEN_FIELDS.MAX_DEPTH]
  var depth_coefficient = Constants.WORLD_GEN[resourceType][Constants.WORLD_GEN_FIELDS.COEFFICIENT]
  var threashold = Constants.WORLD_GEN[resourceType][Constants.WORLD_GEN_FIELDS.THRESHOLD]

  for x in Constants.MAX_WORLD_WIDTH:
    for y in range(Constants.SURFACE_HEIGHT + min_depth, max_depth):
      var coords := Vector2i(x, y)
      var probability = noise.get_noise_2dv(coords) * y * depth_coefficient
      if probability > threashold && map[coords].type == Tile.TileType.DIRT:
        map[coords].objectType = resourceType


func gen_base_under_world():
  for x in Constants.MAX_WORLD_WIDTH:
    for y in Constants.MAX_GEN_DEPTH:
      y = y + Constants.SURFACE_HEIGHT
      var coords := Vector2i(x, y)
      if is_edge(x, y):
        map[coords] = Tile.Border(coords)
      else:
        map[coords] = Tile.Dirt(coords)

func gen_over_world():
  for x in Constants.MAX_WORLD_WIDTH:
    for y in Constants.SURFACE_HEIGHT:
      var coords := Vector2i(x, y)
      if is_horizontal_edge(x):
        map[coords] = Tile.Border(coords)
      else:
        map[coords] = Tile.Empty(coords)


func gen_map():
  gen_over_world()
  gen_under_world()

func global_position_to_map_coords(global_pos: Vector2):
  return Vector2i(global_pos / Constants.TILE_WIDTH)

func dig(coords: Vector2i):
  if map[coords].is_diggable():
    map[coords].clear()
    tile_updated.emit(map[coords])
