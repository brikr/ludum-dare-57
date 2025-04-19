extends CanvasLayer

const FUEL_WEIGHT_MONEY_TEMPLATE := """Fuel: %.2fL
Weight: %dkg
Money: $%d"""
const CURRENT_HAUL_VALUE_TEMPLATE := "Current haul: $%d"

func _process(delta):
  $FuelWeightMoney.text = FUEL_WEIGHT_MONEY_TEMPLATE % [
    %Player.current_fuel / 1000,
    %Player.get_total_weight(),
    %Player.bank_value
  ]
  $CurrentHaulValue.text = CURRENT_HAUL_VALUE_TEMPLATE % %Player.haul_value
