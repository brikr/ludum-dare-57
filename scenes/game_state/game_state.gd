extends Node


signal tile_updated

var player: Player
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
  gen_out_of_bounds() # dirt outside the hazards as far as the eye can see (7 tiles)

  gen_resource(Tile.TileObjectType.ALIEN_SKULL, false)
  gen_resource(Tile.TileObjectType.ALIEN_TECH, false)
  gen_resource(Tile.TileObjectType.GREEN)
  gen_resource(Tile.TileObjectType.RED)
  gen_resource(Tile.TileObjectType.BLUE)
  gen_resource(Tile.TileObjectType.GOLD)

func gen_resource(resource_type: Tile.TileObjectType, use_noise := true):
    var noise = GenUtils.get_noise()

    var noise_func
    if use_noise:
     noise_func = func(coords: Vector2i) -> float: return (noise.get_noise_2dv(coords) + 1.0) / 2.0
    else:
      noise_func = func(coords: Vector2i) -> float: return randf()

    GenUtils.generate_with_depth_probability(
        Constants.WORLD_GEN_RESOURCES,
        resource_type,
        Constants.SURFACE_HEIGHT + Constants.WORLD_GEN_RESOURCES[resource_type][Constants.WORLD_GEN_FIELDS.MIN_DEPTH],
        Constants.WORLD_GEN_RESOURCES[resource_type][Constants.WORLD_GEN_FIELDS.MAX_DEPTH],
        noise_func,
        func(coords: Vector2i, probability: float) -> void:
            var threshold = Constants.WORLD_GEN_RESOURCES[resource_type][Constants.WORLD_GEN_FIELDS.THRESHOLD]
            if probability > threshold and map[coords].type in Tile.DIGGABLE_TILES:
                map[coords].objectType = resource_type
    )


func gen_base_under_world():
    # Fill with Dirt (except borders)
    for x in Constants.MAX_WORLD_WIDTH:
        for y in range(Constants.SURFACE_HEIGHT, Constants.MAX_GEN_DEPTH):
            var coords := Vector2i(x, y)
            if is_edge(x, y):
                map[coords] = Tile.Border(coords)
            else:
                map[coords] = Tile.Dirt(coords)

    # Overwrite with Stone based on noise
    var noise = GenUtils.get_noise()

    var noise_func = func(coords: Vector2i) -> float:
        return (noise.get_noise_2dv(coords) + 1.0) / 2.0

    GenUtils.generate_with_depth_probability(
        Constants.WORLD_GEN_BASE,
        Tile.TileType.STONE,
        Constants.SURFACE_HEIGHT,
        Constants.MAX_GEN_DEPTH,
        noise_func,
        func(coords: Vector2i, probability: float) -> void:
            var threshold = Constants.WORLD_GEN_BASE[Tile.TileType.STONE][Constants.WORLD_GEN_FIELDS.THRESHOLD]
            var x = coords.x
            var y = coords.y

            # Only overwrite non-border tiles
            if !is_edge(x, y) and probability > threshold:
                map[coords] = Tile.Stone(coords)
    )

func gen_out_of_bounds():
  # left
  for x in range(-7, 0):
    for y in range(Constants.SURFACE_HEIGHT, Constants.MAX_GEN_DEPTH):
      var coords := Vector2i(x, y)
      map[coords] = Tile.Dirt(coords)

  # right
  for x in range(Constants.MAX_WORLD_WIDTH, Constants.MAX_WORLD_WIDTH + 7):
    for y in range(Constants.SURFACE_HEIGHT, Constants.MAX_GEN_DEPTH):
      var coords := Vector2i(x, y)
      map[coords] = Tile.Dirt(coords)

  # under
  for x in range(-7, Constants.MAX_WORLD_WIDTH + 7):
    for y in range(Constants.MAX_GEN_DEPTH, Constants.MAX_GEN_DEPTH + 10):
      var coords := Vector2i(x, y)
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

func map_coords_to_global_position(map_coords: Vector2i):
  return Vector2(map_coords * Constants.TILE_WIDTH)

func dig(coords: Vector2i):
  if map[coords].is_diggable():
    map[coords].clear()
    tile_updated.emit(map[coords])
