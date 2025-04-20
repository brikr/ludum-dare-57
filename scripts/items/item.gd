class_name Item extends Object

enum Type {GEAR, CONSUMABLE}
enum StatImpact {
  FUEL_CAPACITY,
  MAX_JETPACK_ACCEL,
  MIN_JETPACK_ACCEL,
  JETPACK_ACCEL_PENALTY,
  JETPACK_SPEED_LIMIT,
  JETPACK_FUEL_EFFICIENCY,
  CURRENT_FUEL,
  DIGGING_POWER,
}

var type: Type
var statImpact: Dictionary[StatImpact, float]
var name: String
var price: float

func _init(name: String, price: float, type: Type, statImpact: Dictionary[StatImpact, float]) -> void:
  self.type = type
  self.statImpact = statImpact
  self.name = name
  self.price = price

func apply() -> void:
  for key in statImpact:
    var val = statImpact[key]
    match key:
      Item.StatImpact.FUEL_CAPACITY:
        GameState.player.fuel_capacity += val
      Item.StatImpact.MAX_JETPACK_ACCEL:
        GameState.player.max_jetpack_accel += val
      Item.StatImpact.MIN_JETPACK_ACCEL:
        GameState.player.min_jetpack_accel += val
      Item.StatImpact.JETPACK_ACCEL_PENALTY:
        GameState.player.jetpack_accel_penalty += val
      Item.StatImpact.JETPACK_SPEED_LIMIT:
        GameState.player.jetpack_speed_limit += val
      Item.StatImpact.JETPACK_FUEL_EFFICIENCY:
        GameState.player.jetpack_fuel_efficiency += val
      Item.StatImpact.CURRENT_FUEL:
        GameState.player.current_fuel += val
      Item.StatImpact.DIGGING_POWER:
        GameState.player.digging_power += val
