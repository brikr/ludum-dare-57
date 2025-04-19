extends TileMapLayer

# World Size
const SURFACE_HEIGHT = 10;
const MAX_GEN_DEPTH = 1000;
const MAX_WORLD_WIDTH = 20;

# Tiles
const SOURCE_ID = 0;
const DIRT_TILE = Vector2(0,0)
const HAZARD_TILE = Vector2(1,0)
const FENCE_TILE = Vector2(2,0)

######## WORLD GEN ########
func _ready():
	gen_map()

func is_vertical_edge(y):
	return (y == 0 || y == MAX_GEN_DEPTH - 1 )
func is_horizontal_edge(x):
	return (x == 0 || x == MAX_WORLD_WIDTH - 1)
	
func is_edge(x, y):
	return is_horizontal_edge(x) || is_vertical_edge(y)
	
func gen_under_world():
	for x in MAX_WORLD_WIDTH:
		for y in MAX_GEN_DEPTH:
			y = y + SURFACE_HEIGHT
			var tile = DIRT_TILE
			
			if is_edge(x, y):
				tile = HAZARD_TILE
			
			set_cell(Vector2(x, y), SOURCE_ID, tile)

func gen_over_world():
	for x in MAX_WORLD_WIDTH:
		for y in SURFACE_HEIGHT:
			var tile = Vector2(-1,-1) # delete tile
			if is_horizontal_edge(x):
				tile = FENCE_TILE
			
			set_cell(Vector2(x, y), SOURCE_ID, tile)

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
	
	
