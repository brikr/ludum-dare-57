class_name Item extends Node

enum ItemType {GEAR, CONSUMABLE}
enum StatImpact {ADD_FUEL}

var itemType: ItemType
var itemStatImpact: Dictionary[StatImpact, float]

func _init(itemType: ItemType, itemStatImpact: Dictionary[StatImpact, float]) -> void:
  self.itemType = itemType
  self.itemStatImpact = itemStatImpact

func apply_item(player) -> void:
  for key in itemStatImpact:
    var val = itemStatImpact[key]
    match key:
      Item.StatImpact.ADD_FUEL:
        player.current_fuel += val
      _:
        pass
