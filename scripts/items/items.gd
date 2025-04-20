extends Node

var GEAR_REGISTRY = [
  ## Drill
  Item.new(
    "Titanium Drill",
    "Stronger than the standard issue. Digs 50% faster.",
    Item.Category.DRILL, 100.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 0.5}),
  Item.new("Overdrive Rotor", Item.Category.DRILL, 1000.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 0.5}),
  Item.new("Worldbreaker Bit", Item.Category.DRILL, 5000.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 1.0}),
  ## Heat
  Item.new("Wood Heat Sink", Item.Category.HEAT, 50.0, Item.Type.GEAR, {Item.StatImpact.HEAT_CAPACITY: 50.0}),
  Item.new("Aluminum Heat Sink", Item.Category.HEAT, 500.0, Item.Type.GEAR, {Item.StatImpact.HEAT_CAPACITY: 100.0, Item.StatImpact.HEAT_DECAY_RATE: 0.5}),
  Item.new("Cryocooler", Item.Category.HEAT, 5000.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_HEAT_GEN: -0.2, Item.StatImpact.HEAT_DECAY_RATE: 0.5}),
  ## Fuel
  Item.new("Auxiliary Fuel Tank", Item.Category.FUEL, 200.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new("Ancillary Fuel Tank", Item.Category.FUEL, 500.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new("Supplementary Fuel Tank", Item.Category.FUEL, 2000.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new("Backup Fuel Tank", Item.Category.FUEL, 10000.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new("Exhaust Flow Reclaimer", Item.Category.FUEL, 10000.0, Item.Type.GEAR, {Item.StatImpact.JETPACK_FUEL_EFFICIENCY: -2.5}),
  ## Jetpack
  Item.new("Jetpack Turbo Booster", Item.Category.JETPACK, 5000.0, Item.Type.GEAR, {Item.StatImpact.JETPACK_SPEED_LIMIT: 25}),
  ## Weight
  Item.new("3025 NBA All Stars Nike Sneakers", Item.Category.WEIGHT, 5000.0, Item.Type.GEAR, {Item.StatImpact.PLAYER_WEIGHT: -50.0}),
]
