class_name Item extends Node

enum ItemType {GEAR, CONSUMABLE}
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

var itemType: ItemType
var itemStatImpact: Dictionary[StatImpact, float]

func _init(itemType: ItemType, itemStatImpact: Dictionary[StatImpact, float]) -> void:
  self.itemType = itemType
  self.itemStatImpact = itemStatImpact

func apply(player) -> void:
  for key in itemStatImpact:
    var val = itemStatImpact[key]
    match key:
      Item.StatImpact.FUEL_CAPACITY:
        player.fuel_capacity += val
      Item.StatImpact.MAX_JETPACK_ACCEL:
        player.max_jetpack_accel += val
      Item.StatImpact.MIN_JETPACK_ACCEL:
        player.min_jetpack_accel += val
      Item.StatImpact.JETPACK_ACCEL_PENALTY:
        player.jetpack_accel_penalty += val
      Item.StatImpact.JETPACK_SPEED_LIMIT:
        player.jetpack_speed_limit += val
      Item.StatImpact.JETPACK_FUEL_EFFICIENCY:
        player.jetpack_fuel_efficiency += val
      Item.StatImpact.CURRENT_FUEL:
        player.current_fuel += val
      Item.StatImpact.DIGGING_POWER:
        player.digging_power += val
