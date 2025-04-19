class_name Tile extends Object

enum TileType {EMPTY, DIRT, BORDER}
enum TileObjectType {NONE, GOLD, BLUE, ALIEN_SKULL, ALIEN_TECH}

var coords: Vector2i
var type: TileType
var objectType: TileObjectType

func _init(coords, type, objectType = TileObjectType.NONE):
  self.coords = coords
  self.type = type
  self.objectType = objectType

func is_above_ground():
  return coords.y < Constants.SURFACE_HEIGHT

func clear():
  type = TileType.EMPTY
  objectType = TileObjectType.NONE

static func Dirt(coords):
  return Tile.new(coords, TileType.DIRT)

static func Border(coords):
  return Tile.new(coords, TileType.BORDER)

static func Empty(coords):
  return Tile.new(coords, TileType.EMPTY)
