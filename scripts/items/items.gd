extends Node

var GEAR_REGISTRY = [
  ## Jetpack
  Item.new("Jetpack Turbo Booster", 5000.0, Item.Type.GEAR, {Item.StatImpact.JETPACK_SPEED_LIMIT: 25}),
  ## Fuel
  Item.new("Auxiliary Fuel Tank", 200.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new("Ancillary Fuel Tank", 500.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new("Supplementary Fuel Tank", 2000.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new("Backup Fuel Tank", 10000.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new("Exhaust Flow Reclaimer", 10000.0, Item.Type.GEAR, {Item.StatImpact.JETPACK_FUEL_EFFICIENCY: -2.5}),
  ## Drill
  Item.new("Titanium Drill", 100.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 0.5}),
  Item.new("Overdrive Rotor", 1000.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 0.5}),
  Item.new("Worldbreaker Bit", 5000.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 1.0}),
  ## Heat
  Item.new("Aluminum Heat Sink", 100.0, Item.Type.GEAR, {Item.StatImpact.HEAT_CAPACITY: 100.0, Item.StatImpact.HEAT_DECAY_RATE: 0.5}),
  Item.new("Cryocooler", 5000.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_HEAT_GEN: -0.2, Item.StatImpact.HEAT_DECAY_RATE: 0.5}),
  ## Weight
  Item.new("3025 NBA All Stars Nike Sneakers", 5000.0, Item.Type.GEAR, {Item.StatImpact.PLAYER_WEIGHT: -50.0}),
]

var CONSUMEABLE_REGISTRY = [
  Item.new("Fuel Canister", 50.0, Item.Type.CONSUMABLE, {Item.StatImpact.CURRENT_FUEL: 5000}),
]
