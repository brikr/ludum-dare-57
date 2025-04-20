extends Node

var GEAR_REGISTRY = [
  Item.new("Jet Pack Speed", 100.0, Item.Type.GEAR, {Item.StatImpact.JETPACK_SPEED_LIMIT: 25}),
  Item.new("Fuel Tank Size", 100.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 500}),
  Item.new("Bigger Shovel", 50.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 0.25}),
  Item.new("Biggerr Shovel", 100.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 0.25}),
  Item.new("Biggerrr Shovel", 150.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 0.25}),
  Item.new("Heat sink", 200, Item.Type.GEAR, {Item.StatImpact.DIGGING_HEAT_GEN: -0.25, Item.StatImpact.HEAT_DECAY_RATE: 0.25}),
]

var CONSUMEABLE_REGISTRY = [
  Item.new("Fuel Canister", 50.0, Item.Type.CONSUMABLE, {Item.StatImpact.CURRENT_FUEL: 5000}),
]
