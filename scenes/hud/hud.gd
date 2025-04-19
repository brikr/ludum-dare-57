extends CanvasLayer

const FUEL_TEMPLATE := "Fuel: %d"

func _process(delta):
  $Fuel.text = FUEL_TEMPLATE % %Player.current_fuel
