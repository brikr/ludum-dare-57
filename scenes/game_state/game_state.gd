extends Node


signal tile_updated

var player: Player
var map: Dictionary[Vector2i, Tile] = {}
var gonster_init_position = Vector2i(0,0)
var purchased_items: Array[String] = []

func _ready():
  gen_map()

####### GAME STATE STATE #######
var player_has_won = false

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
    gen_chasms()
    gen_end_chasm_bubble()

func gen_end_chasm_bubble():
    var radius = 5
    var center_x = Constants.MAX_WORLD_WIDTH / 2
    var center_y = Constants.MAX_GEN_DEPTH - 2  # 1 tile above bottom

    var center_tile_cords = Vector2i(center_x, center_y)
    gonster_init_position = center_tile_cords * Constants.TILE_WIDTH

    for x in range(center_x - radius, center_x + radius + 1):
        for y in range(center_y - radius, center_y + radius + 1):
            var coords = Vector2i(x, y)
            var dx = x - center_x
            var dy = y - center_y
            var distance = sqrt(dx * dx + dy * dy)

            if distance <= radius and not is_edge(x, y):
                map[coords] = Tile.Empty(coords)

func gen_chasms():
    var noise = GenUtils.get_chasm_noise()

    var noise_func = func(coords: Vector2i) -> float:
        return (noise.get_noise_2dv(coords) + 1.0) / 2.0

    GenUtils.generate_with_depth_probability(
        Constants.WORLD_GEN_BASE,
        Tile.TileType.EMPTY,
        Constants.SURFACE_HEIGHT,
        Constants.MAX_GEN_DEPTH,
        noise_func,
        func(coords: Vector2i, probability: float) -> void:
            var x = coords.x
            var y = coords.y
            var threshold = Constants.WORLD_GEN_BASE[Tile.TileType.EMPTY][Constants.WORLD_GEN_FIELDS.THRESHOLD]

            if !is_edge(x, y) and probability > threshold:
                map[coords] = Tile.Empty(coords)
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

func get_player_map_coords():
  return global_position_to_map_coords(player.position)

func is_player_above_ground():
  return (GameState.get_player_map_coords().y - Constants.SURFACE_HEIGHT + 1) < 1

func dig(coords: Vector2i):
  if map[coords].is_diggable():
    map[coords].clear()
    tile_updated.emit(map[coords])

func has_won():
  player_has_won = player_has_won || (player.has_gonster && is_player_above_ground())
  return player_has_won
