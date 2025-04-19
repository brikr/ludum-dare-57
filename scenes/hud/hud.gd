extends CanvasLayer

const FUEL_WEIGHT_VALUE_TEMPLATE := """Fuel: %.2fL
Weight: %.2fkg
Value: $%.2f"""

func _process(delta):
  $FuelWeightValue.text = FUEL_WEIGHT_VALUE_TEMPLATE % [
    %Player.current_fuel / 1000,
    %Player.get_total_weight(),
    %Player.haul_value
  ]
