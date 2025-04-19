extends Node


signal tile_updated

var map: Dictionary[Vector2i, Tile] = {}

func _ready():
  gen_map()

####### WORLD GEN #######
func is_vertical_edge(y):
  return (y == 0 || y == Constants.MAX_GEN_DEPTH - 1 )

func is_horizontal_edge(x):
  return (x == 0 || x == Constants.MAX_WORLD_WIDTH - 1)

func is_edge(x, y):
  return is_horizontal_edge(x) || is_vertical_edge(y)

func gen_under_world():
  gen_base_under_world()
  gen_gold()


func gen_gold():
  var noise = FastNoiseLite.new() # there are a shit load of props you can change
  noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX
  noise.seed = 69 # kek, funny numbie
  noise.fractal_octaves = 5
  noise.fractal_gain = 10

  for x in Constants.MAX_WORLD_WIDTH:
    for y in Constants.MAX_GEN_DEPTH:
      y = y + Constants.SURFACE_HEIGHT
      var coords := Vector2i(x, y)
      print(noise.get_noise_2dv(coords))
      if noise.get_noise_2dv(coords) > 0.8:
        map[coords].type = Tile.TileType.EMPTY

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
  return (global_pos/Constants.TILE_WIDTH).floor()

func dig(coords: Vector2i):
  if map[coords].is_diggable():
    map[coords].clear()
    tile_updated.emit(map[coords])
