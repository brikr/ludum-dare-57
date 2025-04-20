extends Node

var GEAR_REGISTRY = [
  ## Drill
  Item.new(
    "Titanium Drill",
    "[i]Stronger than the standard issue.[/i]\nDig 50% faster.",
    Item.Category.DRILL, 100.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 0.5}),
  Item.new(
    "Overdrive Rotor",
    "[i]Any professional would consider you just a hobbyist miner unless you've got one of these bad boys installed.[/i]\nDig 100% faster than the base drill.",
    Item.Category.DRILL, 1000.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 0.5}),
  Item.new(
    "Worldbreaker Bit",
    "[i]You'll be digging through the earth like it was made out of rice crispies.[/i]\nDig 200% faster than the base drill.",
    Item.Category.DRILL, 5000.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 1.0}),
  ## Heat
  Item.new(
    "Wood Heat Sink",
    "[i]\"It ain't much and it doesn't work\"[/i]\nDrill can get up to 250C before overheating.",
    Item.Category.HEAT, 50.0, Item.Type.GEAR, {Item.StatImpact.HEAT_CAPACITY: 50.0}),
  Item.new(
    "Aluminum Heat Sink",
    "[i]Lightweight. Reliable. Not recommended as a cooking surface.[/i]\nDrill can get up to 300C before overheating, and the drill cools off faster.",
    Item.Category.HEAT, 500.0, Item.Type.GEAR, {Item.StatImpact.HEAT_CAPACITY: 100.0, Item.StatImpact.HEAT_DECAY_RATE: 0.5}),
  Item.new(
    "CryoCooler™",
    "[i]Uses proprietary technology to keep the drill cool for extended mining sessions.[/i]\nSlows the speed at which the drill heats up, and the drill cools off even faster.",
    Item.Category.HEAT, 5000.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_HEAT_GEN: -0.2, Item.StatImpact.HEAT_DECAY_RATE: 0.5}),
  ## Fuel
  Item.new(
    "Auxiliary Fuel Tank",
    "[i]This could come in handy.[/i]\nCarry an extra 1L of fuel.",
    Item.Category.FUEL, 200.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new(
    "Ancillary Fuel Tank",
    "[i]Now you can delve even deeper before you realize you can't make it back to the surface.[/i]\nCarry an extra 1000mL of fuel.",
    Item.Category.FUEL, 500.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new(
    "Supplementary Fuel Tank",
    "[i]Just in case we want to go on an extended spelunking adventure.[/i]\nCarry an extra 1kg of dense-as-water fuel.",
    Item.Category.FUEL, 2000.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new(
    "Backup Fuel Tank",
    "[i]I'm starting to think this shopkeeper is price gouging me.[/i]\nCarry an extra 0.264gal of fuel.",
    Item.Category.FUEL, 10000.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new(
    "Exhaust Flow Reclaimer",
    "[i]Useful for trips to the moon.[/i]\nJetpack uses half as much fuel.",
    Item.Category.FUEL, 10000.0, Item.Type.GEAR, {Item.StatImpact.JETPACK_FUEL_EFFICIENCY: -2.5}),
  ## Jetpack
  Item.new(
    "Jetpack Turbo Booster",
    "[i]The ceiling will come at you so fast you'd think it was the ground.[/i]\nIncreases top speed of the jetpack.",
    Item.Category.JETPACK, 5000.0, Item.Type.GEAR, {Item.StatImpact.JETPACK_SPEED_LIMIT: 100.0}),
  ## Weight
  Item.new(
    "3025 NBA All Stars Nike Sneakers",
    "[i]Authenticity not verified.[/i]\nReduces weight by 50kg.",
    Item.Category.WEIGHT, 5000.0, Item.Type.GEAR, {Item.StatImpact.PLAYER_WEIGHT: -50.0}),
]
