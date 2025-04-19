extends TileMapLayer

######## WORLD GEN ########
func _ready():
  gen_map()

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
      var tile = Constants.DIRT_TILE
      
      if is_edge(x, y):
        tile = Constants.HAZARD_TILE
      
      set_cell(Vector2(x, y), Constants.SOURCE_ID, tile)

func gen_over_world():
  for x in Constants.MAX_WORLD_WIDTH:
    for y in Constants.SURFACE_HEIGHT:
      var tile = Vector2(-1,-1) # delete tile
      if is_horizontal_edge(x):
        tile = Constants.FENCE_TILE
      
      set_cell(Vector2(x, y), Constants.SOURCE_ID, tile)

func gen_map():
  gen_over_world()
  gen_under_world()
  

######## TICK PROCESS ########
@onready var marker: Node2D = get_node("HighlightedTile") 

func _process(_delta: float):
  var mouse_pos = get_local_mouse_position() # absolute pos
  var cell_pos = local_to_map(mouse_pos) # tile snapped pos
  highlight_cell(cell_pos)

func highlight_cell(cell_position: Vector2i):
  marker.position = map_to_local(cell_position)
  
  
