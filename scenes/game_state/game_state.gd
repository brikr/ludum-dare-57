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
  gen_base_under_world() # generates dirt and borders

  gen_resource(Tile.TileObjectType.BLUE)
  gen_resource(Tile.TileObjectType.GOLD)

func gen_resource(resourceType: Tile.TileObjectType):
  var noise = GenUtils.get_noise()
  var min_depth = Constants.WORLD_GEN[resourceType][Constants.WORLD_GEN_FIELDS.MIN_DEPTH]
  var max_depth = Constants.WORLD_GEN[resourceType][Constants.WORLD_GEN_FIELDS.MAX_DEPTH]
  var min_depth_coefficient = Constants.WORLD_GEN[resourceType][Constants.WORLD_GEN_FIELDS.MIN_COEFFICIENT]
  var max_depth_coefficient = Constants.WORLD_GEN[resourceType][Constants.WORLD_GEN_FIELDS.MAX_COEFFICIENT]
  var threashold = Constants.WORLD_GEN[resourceType][Constants.WORLD_GEN_FIELDS.THRESHOLD]

  for x in Constants.MAX_WORLD_WIDTH:
    for y in range(Constants.SURFACE_HEIGHT + min_depth, max_depth):
      var coords := Vector2i(x, y)

      # How far are we from min -> max depth (normalized 0.0 to 1.0)
      var depth_ratio := float(y - (Constants.SURFACE_HEIGHT + min_depth)) / float(max_depth - (Constants.SURFACE_HEIGHT + min_depth))
      # Sweep coefficient based on depth.
      var depth_coefficient = lerp(min_depth_coefficient, max_depth_coefficient, depth_ratio)

      var probability = noise.get_noise_2dv(coords) * y * depth_coefficient
      print(coords, probability)
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
