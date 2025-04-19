class_name Item extends Node

enum ItemType {GEAR, CONSUMABLE}
enum StatImpact {CURRENT_FUEL, MAX_JETPACK_ACCEL}

var itemType: ItemType
var itemStatImpact: Dictionary[StatImpact, float]

func _init(itemType: ItemType, itemStatImpact: Dictionary[StatImpact, float]) -> void:
  self.itemType = itemType
  self.itemStatImpact = itemStatImpact

func apply(player) -> void:
  for key in itemStatImpact:
    var val = itemStatImpact[key]
    match key:
      Item.StatImpact.CURRENT_FUEL:
        player.current_fuel += val
      Item.StatImpact.MAX_JETPACK_ACCEL:
        player.max_jetpack_accel += val
      _:
        pass
