extends CanvasLayer

const FUEL_WEIGHT_MONEY_TEMPLATE := """Fuel: %.2fL
Weight: %dkg
Drill Heat: %dC
Money: $%d"""
const CURRENT_HAUL_VALUE_TEMPLATE := "Current haul: $%d"

func _process(delta):
  $Status.text = FUEL_WEIGHT_MONEY_TEMPLATE % [
    GameState.player.current_fuel / 1000,
    GameState.player.get_total_weight(),
    GameState.player.get_total_heat(),
    GameState.player.bank_value
  ]
  $CurrentHaulValue.text = CURRENT_HAUL_VALUE_TEMPLATE % GameState.player.haul_value

  if GameState.player.current_fuel <= 0.0:
    $RespawnHint.visible = true
  else:
    $RespawnHint.visible = false
