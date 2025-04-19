extends Node

signal tile_map_changed

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
        map.erase(coords)

func gen_map():
  gen_over_world()
  gen_under_world()

func dig(coords: Vector2i):
  # TODO: make sure they can dig lol
  map.erase(coords)
  tile_map_changed.emit(coords, null)
  pass
