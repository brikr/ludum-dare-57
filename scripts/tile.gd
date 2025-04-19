class_name Tile extends Object

enum TileType {EMPTY, DIRT, BORDER}
enum TileObjectType {NONE, GOLD, BLUE, ALIEN_SKULL, ALIEN_TECH}

var coords: Vector2i
var type: TileType
var objectType: TileObjectType

func _init(coords, type, objectType):
  self.coords = coords
  self.type = type
  self.objectType = objectType

func is_above_ground():
  return coords.y < Constants.SURFACE_HEIGHT

func is_diggable():
  return type == TileType.DIRT

# how much total digging power must be expended to break this tile
func difficulty():
  return Constants.TILE_DIFFICULTY.get(type, 0.0) + Constants.OBJECT_DIFFICULTY.get(objectType, 0.0)

func clear():
  type = TileType.EMPTY
  objectType = TileObjectType.NONE

static func Dirt(coords, objectType = TileObjectType.NONE):
  return Tile.new(coords, TileType.DIRT, objectType)

static func Border(coords):
  return Tile.new(coords, TileType.BORDER, TileObjectType.NONE)

static func Empty(coords):
  return Tile.new(coords, TileType.EMPTY, TileObjectType.NONE)
